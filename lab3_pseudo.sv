// lab3_pseudo.sv
// Description: plays a note in 1 octave of the C-scale, based on rotary input, as well as 
//		clk, reset and enable. The frequency is displayed on the 4-dig, 7-seg display.
// Author: Mikhail Rego 
// Date: 2/2/2025
/////////////////////////////////////////////////////////////////////////////////////////////

module lab3 ( input logic CLOCK_50,		// 50 MHz clock
						(* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) // likely needed for the encoder
              input logic enc1_a, enc1_b,	// all 4 signals will just be controlled by encoder 1
				  input logic s1, s2			// active low push-buttons on boosterpk
              output logic [7:0] leds,	// 7-seg LED enables
              output logic [3:0] ct    // digit cathodes
				  output logic spkr;			// pulsating speaker output
				  output logic red, green, blue; // dm leds
) ;
// create logics for everything 
// instantiate as needed
// display the lower 16 bits of frequency on the digital display
// s1 input from the boosterpak to reset_n for enc3freq.sv and tonegen.sv
// s2 input from the boosterpak to onOff for tonegen.sv for mute/sound-enable
// logic is needed similar to lab 2, except freq goes to the display, and ccw/cw goes to enc3freq
// don't forget to turn off those dm leds
// check syntax in VEgpt

endmodule 