// File: lab3.sv
// Description: plays a note in 1 octave of the C-scale, based on rotary input, as well as 
//		clk, reset and enable. The frequency is displayed on the 4-dig, 7-seg display.
// Author: Mikhail Rego 
// Date: 2/2/2025
/////////////////////////////////////////////////////////////////////////////////////////////

module lab3 (
    input logic CLOCK_50,        // 50 MHz clock
    (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
    input logic enc1_a, enc1_b,  // Encoder 1 signals
    input logic s1, s2,          // Push-buttons
    output logic [7:0] leds,     // 7-seg LED enables
    output logic [3:0] ct,       // Digit cathodes
    output logic spkr,           // Speaker output
    output logic red, green, blue // DM LEDs
);

   logic [1:0] digit;  // select digit to display
   logic [3:0] disp_digit;  // current digit of count to display
   logic [15:0] clk_div_count; // count used to divide clock
   logic enc1_cw, enc1_ccw;  // encoder module outputs
	logic [31:0] bcd_count; // will be used for binary-to-decimal output
   // **new** //
   logic [31:0] freq; // stores the current frequency being played

   // instantiate modules to implement design
   decode2 decode2_0 (.digit,.ct) ;
   decode7 decode7_0 (.num(disp_digit),.leds) ;
   whiteOut dmLEDS (.red, .green, .blue) ; // comment out if u want to use BP leds
   encoder encoder_1 (.clk(CLOCK_50), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));
   // **new** //
	enc2bcd bdc_0 ( .clk(CLOCK_50), .enc_count(freq), .bcd_count(bcd_count) );
   enc2freq C_major_scale ( .cw(enc1_cw), .ccw(enc1_ccw), .freq(freq), .reset_n(s1), .clk(CLOCK_50) );
   tonegen #(.FCLK(50000000)) tonegen_0 ( .freq(freq), .onOff(s2), .reset_n(s1), .spkr(spkr), .clk(CLOCK_50) ); // C.O. to turn off spkr

   // use count to divide clock and generate a 2 bit digit counter to determine which digit to display
	always_ff @(posedge CLOCK_50) begin
	   clk_div_count <= clk_div_count + 1'b1;
	   digit <= clk_div_count[15:14];  // Now inside sequential block
	end

   // Select digit to display (disp_digit) from last 4 nibbles of freq
   always_comb begin
      case (digit)
         2'b00: disp_digit = bcd_count[3:0];
         2'b01: disp_digit = bcd_count[7:4]; 
         2'b10: disp_digit = bcd_count[11:8];
         2'b11: disp_digit = bcd_count[15:12];
         default: disp_digit = 16'h0000;        // Default case (shouldn't occur)
      endcase
   end

endmodule 