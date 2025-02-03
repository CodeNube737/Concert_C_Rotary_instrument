// File: enc2bcd.sv
// Description: Works along with encoder.sv (2025-01-27, MR) to 
// 	take-in values from 0 to 255 and output a decimal value from 0 to 99.
// Author: Mikhail Rego with the help of OpenAI
// Date: 2025-01-27
//////////////////////////////////////////////////////////////////////////////
// Edited: Mikhail Rego, for use with a 32-bit input and output.. future work: go to 1 million
// Date: 2025-02-2
//////////////////////////////////////////////////////////////////////////////
module enc2bcd (
    input logic clk,                  // Clock signal
    input logic [31:0] enc_count,      // Input count in raw binary (32-bit)
    output logic [15:0] bcd_count      // Binary-coded decimal output (thousands, hundreds, tens, ones)
);

    // Registers for BCD conversion
    logic [31:0] temp_bcd;
    logic [3:0] thousands, hundreds, tens, ones; // Individual BCD digits
    logic [31:0] temp; // Moved outside `always_comb` to avoid syntax error

    // Sequential Logic: Capture input value and update BCD output
    always_ff @(posedge clk) begin
        temp_bcd <= enc_count;
        bcd_count <= {thousands, hundreds, tens, ones}; // Update BCD output
    end

    // **BCD Conversion Logic (Combinational)**
    always_comb begin
        // Initialize temporary values
        thousands = 4'b0000;
        hundreds = 4'b0000;
        tens = 4'b0000;
        ones = 4'b0000;
        temp = temp_bcd; // Assign working copy of temp_bcd

        // Perform the double-dabble algorithm
        for (int i = 31; i >= 0; i--) begin
            // Adjust BCD digits if needed before shifting
            if (thousands >= 5) thousands = thousands + 3;
            if (hundreds >= 5) hundreds = hundreds + 3;
            if (tens >= 5) tens = tens + 3;
            if (ones >= 5) ones = ones + 3;

            // Shift left and insert next bit from temp
            {thousands, hundreds, tens, ones, temp} = {thousands, hundreds, tens, ones, temp} << 1;
        end
    end

endmodule






/*
module enc2bcd(
   input logic clk,                  // Clock signal
   input logic reset_n,				// allows the bcd to be reset
   input logic [31:0] enc_count,    // Input count in raw binary (0 to 2^32-1)
   output logic [31:0] bcd_count    // Binary-coded decimal output
);

   // Registers for BCD conversion
   logic [31:0] temp_bcd;
   logic [3:0] tens, ones, hundreds, thousands; // Individual BCD digits
   //logic [15:0] millions;

   // Initialize temporary values
   temp_bcd = enc_count;
   thousands = 4'b0000;
   hundreds = 4'b0000;
   tens = 4'b0000;
   ones = 4'b0000;
   //millions = 16'h0000; // future work: go to 1 million

   // Sequential logic for conversion
   always_ff @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         temp_bcd <= enc_count;
         thousands <= 4'b0000;
         hundreds <= 4'b0000;
         tens <= 4'b0000;
         ones <= 4'b0000;
         //millions <= 16'h0000; // future work: go to 1 million

      end else begin

         // Process each nibble of temp_bcd to ensure proper carry
         ones <= temp_bcd[3:0]; // Extract lower nibble
         tens <= temp_bcd[7:4]; // Extract 2nd nibble
         tens <= temp_bcd[11:8]; // Extract 3rd nibble
         tens <= temp_bcd[15:12]; // Extract upper nibble

         // Ensure carry for BCD rules (0-9 per nibble)
         if (ones >= 4'd10) begin
            ones <= ones - 4'd10;
            tens <= tens + 4'd1;
         end

         if (tens >= 4'd10) begin
            tens <= tens - 4'd10;
            hundreds <= hundreds + 4'd1;
         end


         if (hundreds >= 4'd10) begin
            hundreds <= hundreds - 4'd10;
            thousands <= thousands + 4'd1;
         end


         if (thousands >= 4'd10) begin
            thousands <= thousands - 4'd10;
         end

         // Combine tens and ones into the final BCD count
         bcd_count[15:0] <= {thousands, hundreds, tens, ones}; //  future work: go to 1 million
      end
   end

endmodule

*/