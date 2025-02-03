// File: decode7.sv
// Description: This module decodes a 4-bit number into a 7-segment display format.
// 				It gives the proper output to turn-on specific leds so the 7-seg displays the char u want
// Author: Mikhail Rego, with the help of open-AI
// Date: 2025-01-20

module decode7 (
  input  logic [3:0] num,			// 4-bit number (0-F)
  output logic [7:0] leds			// 8-bit output (7-segment + decimal point)
);
always_comb begin
    case (num) // here u send info to display the physical number on the led array
      4'h0: leds = 7'b0111111;	// Display the number 0 ...... displays the ctr-led instead of the top
      4'h1: leds = 7'b0000110;	// Display the number 1
      4'h2: leds = 7'b1011011;	// Display the number 2
      4'h3: leds = 7'b1001111;	// Display the number 3
      4'h4: leds = 7'b1100110;	// Display the number 4 ...... is currently displaying a 7
      4'h5: leds = 7'b1101101;	// Display the number 5
      4'h6: leds = 7'b1111101;	// Display the number 6
      4'h7: leds = 7'b0000111;	// Display the number 7 ...... displays the ctr-led instead of the top
      4'h8: leds = 7'b1111111;	// Display the number 8
      4'h9: leds = 7'b1101111;	// Display the number 9
//      4'hA: leds = 8'b10001000;	// Display the letter A
//      4'hB: leds = 8'b10000011;	// Display the letter b
//      4'hC: leds = 8'b11000110;	// Display the letter C
//      4'hD: leds = 8'b10100001;	// Display the letter d
//      4'hE: leds = 8'b10000110;	// Display the letter E
//      4'hF: leds = 8'b10001110;	// Display the letter F
      default: leds = 8'b11111111; // All off
    endcase
  end
endmodule

/* E7660 leds (7-segment display)
 * 
 * xxx xxx1 (top)
 * xxx xx1x (top right)
 * xxx x1xx (bot right)
 * xxx 1xxx (bottom)
 * xx1 xxxx (bot left)
 * x1x xxxx (top left)
 * 1xx xxxx (centre)
 * 1xxxxxxx (dp)
 */