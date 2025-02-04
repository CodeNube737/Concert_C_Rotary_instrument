// tonegen.sv 
// Description: takes-in a default 50MHz clock and and a frequency, then 
// 	outputs the toggle pulse for a piezo-speaker at input frequency.
// 	This module also has a mute (onOff) and a reset (_n) button input.
// Mikhail Rego
// 2/1/2025
/////////////////////////////////////////////////////////////////////////////////////////////
// 2/4/2025
// Edited: Mikhail Rego, adding debounce delay
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
   logic prev_onOff;        // state storage for edge-detection
   logic mute;              // latch for onOff
   logic [19:0] debounce_counter; // counter for debounce delay
   logic debounce_active;   // flag to indicate debounce in progress

   assign twiceFreq = freq << 1; // Simple assignment (combinational logic)

   always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         count <= 0;
         spkr <= 0;
         mute <= 0;
         prev_onOff <= 0;
         debounce_counter <= 0;
         debounce_active <= 0;
      end else begin
         // Debounce logic
         if (onOff != prev_onOff && !debounce_active) begin
            debounce_active <= 1;
            debounce_counter <= 0;
         end else if (debounce_active) begin
            if (debounce_counter < 20'd1000000) begin // Delay for ~20ms (assuming 50 MHz clock)
               debounce_counter <= debounce_counter + 1;
            end else begin
               debounce_active <= 0;
               if (onOff && !prev_onOff) begin
                  mute <= ~mute; // Toggle mute when button is pressed
               end
               prev_onOff <= onOff; // Store previous state of onOff
            end
         end

         if (count >= FCLK) begin
            count <= 0;
            spkr <= (mute) ? ~spkr : 0; // Toggle speaker output if mute is enabled
         end else begin
            count <= count + twiceFreq; // Increment by twice the frequency
         end
      end
   end

endmodule
