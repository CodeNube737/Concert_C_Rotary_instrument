// tonegen.sv 
// Description: takes-in a default 50MHz clock and and a frequency, then 
// 	outputs the toggle pulse for a piezo-speaker at input frequency.
// 	This module also has a mute (onOff) and a reset (_n) button input.
// Mikhail Rego
// 2/1/2025
/////////////////////////////////////////////////////////////////////////////////////////////

module tonegen 
   #( parameter FCLK ) (         // external (input) clock frequency, Hz. should be 50 MHz.
      input logic [31:0] freq,   // frequency to output on speaker 
      input logic onOff,         // 1 -> generate output, 0-> no output 
      output logic spkr,         // speaker output toggles twice per cycle
      input logic reset_n, clk   // reset and internal clock (of this module)
   ); 

   logic [32:0] twiceFreq;  // continuously updated & assigned freq << 1 (logical left shift by 1)
   logic [31:0] count;      // counter initialized at zero
	logic prev_onOff;			// state storage for edge-detection
	logic mute;					// latch for onOff

   assign twiceFreq = freq << 1; // Simple assignment (combinational logic)

   always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         count <= 0;
         spkr <= 0;
			mute <= 0;
			prev_onOff <=0;
      end else begin
         // Edge detection: Toggle mute only on rising edge of onOff
         if (onOff && !prev_onOff) begin  
            mute <= ~mute; // Toggle mute when button is pressed
         end
         prev_onOff <= onOff; // Store previous state of onOff

         if (count >= FCLK) begin
            count <= 0;
            spkr <= (mute) ? ~spkr : 0; // Toggle speaker output if mute is enabled
         end else begin
            count <= count + twiceFreq; // Increment by twice the frequency
         end
      end
   end

endmodule

