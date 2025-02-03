// enc2freq.sv
// Description: Maps the encoder output to frequencies in a C-major scale using a case statement.
//              The frequency updates only after 4 consecutive pulses in one direction.
// Author: Mikhail Rego with the help of Verilog Expert gpt
// Date: 2/2/2025
/////////////////////////////////////////////////////////////////////////////////////////////

`define C_3 262 // Hz
`define D_3 295
`define E_3 328
`define F_3 349
`define G_3 393
`define A_3 437
`define B_3 491
`define C_4 524 // End of C-major scale

module enc2freq (
   input logic cw, ccw,            // Outputs from the lab2 encoder module
   output logic [31:0] freq,        // Output frequency
   input logic reset_n, clk         // Reset and clock
   //logic idle;
);

   logic [2:0] note_index;   // 3-bit index (0 to 7) for the current note
   logic [1:0] pulse_count;  // 2-bit counter (0 to 3) to track pulses before updating frequency

   always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         note_index  <= 0;  // Start at C_3
         pulse_count <= 0;  // Reset pulse count
      end else begin
         if (cw) begin
            if (pulse_count == 3) begin  // After 4 pulses (0,1,2,3 ? 4th pulse triggers update)
               if (note_index < 7) 
                  note_index <= note_index + 1; // Move up the scale
               pulse_count <= 0;  // Reset counter after frequency change
            end else begin
               pulse_count <= pulse_count + 1;  // Increment pulse count
            end
         end else if (ccw) begin
            if (pulse_count == 3) begin
               if (note_index > 0) 
                  note_index <= note_index - 1; // Move down the scale
               pulse_count <= 0;
            end else begin
               pulse_count <= pulse_count + 1;
            end
         end
      end
   end

   // Use a case statement to map `note_index` to frequency
   always_comb begin
      case (note_index)
         3'd0: freq = `C_3;
         3'd1: freq = `D_3;
         3'd2: freq = `E_3;
         3'd3: freq = `F_3;
         3'd4: freq = `G_3;
         3'd5: freq = `A_3;
         3'd6: freq = `B_3;
         3'd7: freq = `C_4;
         default: freq = `C_3;  // Default to C_3
      endcase
   end

endmodule

