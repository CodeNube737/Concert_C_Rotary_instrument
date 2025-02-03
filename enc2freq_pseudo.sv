// enc2freq.sv
// Description: maps the encoder output to an array of frequencies in order to play a C-scale
// Mikhail Rego
// 2/2/2025
/////////////////////////////////////////////////////////////////////////////////////////////

`define C_3 262 // Hz ... but i think this is actually c4-c5...
`define D_3 295
`define E_3 328
`define F_3 349
`define G_3 393
`define A_3 437
`define B_3 491
`define C_4 524 // end of C-major scale

module enc2freq (
   input logic cw, ccw // outputs from the lab2 encoder module
   output logic [31:0] freq,
   input logic reset_n, clk
);

   // declare a 2D packed array, "scale", that can contain 8 frequencies
   // assign scale all notes from C_3 to C_4 in sequence
   // increase the freq to a higher note for every 4 pulses of cw
   // decrease the freq to a higher note for every 4 pulses of ccw
   // reset_n (negedge) returns frequency to zero or maybe to C_3

endmodule 

// after it looks like this works,
	// make a pseudo_tb
	// ask verilog expert to make a test bench for enc2freq
	// compare