// File: enc2freq_tb.sv
// Description: Testbench for the enc2freq module. Verifies frequency changes every 4 pulses.
// Author: Legendary ASIC Engineer & Mikhail R
// Date: 2025-02-02
/////////////////////////////////////////////////////////////////////////////////////////////////

// Function: check_value()
// Description: Checks if expected value matches actual value.  
// Returns '1' if test fails, '0' if pass.
function logic check_value (int expected_value, int actual_value);
    if (expected_value != actual_value) begin
        $display("FAIL: expected value = %d, actual value = %d", expected_value, actual_value);
        check_value = 1;
    end else begin
        check_value = 0;
    end
endfunction

module enc2freq_tb;

    // Signals to connect to the enc2freq module
    logic clk = 0;          // 50 MHz clock
    logic reset_n;          // Active-low reset
    logic cw, ccw;          // Encoder direction pulses
    logic [31:0] freq;      // Output frequency

    // Test variables
    logic tb_fail = 0;      // Track if test failed
    int expected_freq;      // Expected frequency based on note index
    int note_index = 0;     // Track expected note index
    int i;                  // Loop variable

    // Instantiate the device under test (DUT)
    enc2freq dut (.*);

    // 50 MHz clock generation (20 ns period)
    always #10 clk = ~clk;

    // Expected frequency lookup using a function (case statement for clarity)
    function int get_expected_freq(int index);
        case (index)
            0: get_expected_freq = 262;  // C_3
            1: get_expected_freq = 295;  // D_3
            2: get_expected_freq = 328;  // E_3
            3: get_expected_freq = 349;  // F_3
            4: get_expected_freq = 393;  // G_3
            5: get_expected_freq = 437;  // A_3
            6: get_expected_freq = 491;  // B_3
            7: get_expected_freq = 524;  // C_4
            default: get_expected_freq = 262; // Default to C_3
        endcase
    endfunction

    // Stimulus process
    initial begin
        // Initialize signals
        reset_n = 0;
        cw = 0;
        ccw = 0;
        expected_freq = get_expected_freq(0); // Start at C_3

        // Apply reset
        #50 reset_n = 1;
        #50;

        // Check initial frequency (should be C_3)
        tb_fail |= check_value(expected_freq, freq);

        // Test CW (Clockwise) Rotation (Move Up the Scale)
        for (i = 0; i < 7; i++) begin
            // Send 4 pulses to trigger a frequency change
            repeat (4) begin
                #20 cw = 1; #20 cw = 0;  // Pulse high for one clock cycle
            end
            note_index++;
            expected_freq = get_expected_freq(note_index);
            #50;
            tb_fail |= check_value(expected_freq, freq);
        end

        // Test CCW (Counterclockwise) Rotation (Move Down the Scale)
        for (i = 0; i < 7; i++) begin
            // Send 4 pulses to trigger a frequency change
            repeat (4) begin
                #20 ccw = 1; #20 ccw = 0;  // Pulse high for one clock cycle
            end
            note_index--;
            expected_freq = get_expected_freq(note_index);
            #50;
            tb_fail |= check_value(expected_freq, freq);
        end

        // Check final frequency (should be back at C_3)
        tb_fail |= check_value(get_expected_freq(0), freq);

        // Test results
        if (tb_fail)
            $display("enc2freq Simulation *** FAILED *** See transcript for details.");
        else
            $display("enc2freq Simulation *** PASSED ***");

        $stop;
    end

endmodule

