// File: tonegen.sv
// Description: Tone generator module that, given a decimal fequency, produces an output at a thay frequency.
// Author: [Your Name]
// Date: [Date]
// chat has really not been too helpful with this one
////////////////////////////////////////////////////////////////////////////////////////////////////////////


module tonegen 
   #( parameter FCLK ) (          // external (input) clock frequency, Hz. should be 50 MHz.
      input logic [31:0] freq,   // frequency to output on speaker 
      input logic onOff,         // 1 -> generate output, 0-> no output 
      output logic spkr,         // speaker output toggles twice per cycle
      input logic reset_n, clk	// reset and internal clock (of this module)
   ); 
logic [32:0] twiceFreq; // should coninuosly be updated & assigned the value freq<<2; (logical left shift assignment)
logic count = 0; // count, starting at zero, should increment-up by twice the input freq
// spkr should probably be intially set to 0.
// then, take twiceFreq, and add it to count
// once count == FCLK, tiggle the speaker output
	// this should give the effect of the speaker toggling on, then off in exactly 1 FCLK cycle
// onOff(FALSE) sets the speaker output to zero right after the above toggle logic
// onOff(TRUE) leaves the speaker output alone
// reset_n resets the value of count 
// clk is used for always_ff blocks

endmodule 


/* chat

module tonegen 
  #( parameter FCLK = 50000000 )   // Default clock frequency, 50 MHz
   ( input logic [31:0] freq,   // Frequency for speaker output
     input logic onOff,         // 1 -> generate output, 0 -> no output
     output logic spkr,         // Speaker output
     input logic reset_n, clk); // Reset and clock

    logic [31:0] count;          // Counter

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
            spkr <= 0;
        end else if (onOff) begin
            if (count >= FCLK / (2 * freq)) begin
                count <= 0;
                spkr <= ~spkr;  // Toggle speaker output
            end else begin
                count <= count + (2 * freq);
            end
        end
    end
endmodule

*/