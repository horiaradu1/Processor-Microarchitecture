// Stump ALU
// Implement your Stump ALU here
//
// Created by Horia-Gabriel Radu, Oct 2020
//
// ** Update this header **

// 'include' definitions of function codes etc.
// e.g. can use "`ADD" instead of "'h0" to aid readability
// Substitute your own definitions if you prefer.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none


/*----------------------------------------------------------------------------*/

module Stump_ALU (input  wire [15:0] operand_A,		// First operand
                  input  wire [15:0] operand_B,		// Second operand
		          input  wire [ 2:0] func,			// Function specifier
		          input  wire        c_in,			// Carry input
		          input  wire        csh,  			// Carry from shifter
		          output reg  [15:0] result,		// ALU output
		          output reg  [ 3:0] flags_out);	// Flags {N, Z, V, C}


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

reg C14, C15; /* Setting registers for the carry value of bit 14 and 15 */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Verilog code                                                               */

/* Executes the always block every time a signal is recieved */
always @ (*)
begin
	/* Making a case to catch each function */
	case (func)
		3'b000: /* ADD */
		begin
			result = operand_A + operand_B;
			/* Setting the flags for ADD */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			/* Calculating the Carry from bit 14 and bit 15 */
			C14 = ((operand_A[15] ^ operand_B[15]) != result[15]);
			C15 = (operand_A[15] & operand_B[15]) | (operand_A[15] & C14) | (operand_B[15] & C14);
			flags_out[1] = (C14 != C15);
			flags_out[0] = C15;
		end

		3'b001: /* ADC */
		begin
			result = operand_A + operand_B + c_in;
			/* Setting the flags for ADC */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			/* Calculating the Carry from bit 14 and bit 15 */
			C14 = ((operand_A[15] ^ operand_B[15]) != result[15]);
			C15 = (operand_A[15] & operand_B[15]) | (operand_A[15] & C14) | (operand_B[15] & C14);
			flags_out[1] = (C14 != C15);
			flags_out[0] = C15;
		end

		3'b010: /* SUB */
		begin
			result = operand_A + ~operand_B + 1;
			/* Setting the flags for SUB */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			/* Calculating the Carry from bit 14 and bit 15 */
			C14 = ((operand_A[15] ^ (~operand_B[15])) != result[15]);
			C15 = (operand_A[15] & (~operand_B[15])) | (operand_A[15] & C14) | ((~operand_B[15]) & C14);
			flags_out[1] = (C14 != C15);
			flags_out[0] = ~C15;
		end

		3'b011: /* SBC */
		begin
			result = operand_A + ~operand_B + {15'b0, ~c_in} ;
			/* Setting the flags for SBC */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			/* Calculating the Carry from bit 14 and bit 15 */
			C14 = ((operand_A[15] ^ (~operand_B[15])) != result[15]);
			C15 = (operand_A[15] & (~operand_B[15])) | (operand_A[15] & C14) | ((~operand_B[15]) & C14);
			flags_out[1] = (C14 != C15);
			flags_out[0] = ~C15;
		end

		3'b100: /* AND */
		begin
			/* Simple logic AND operator */
			result = operand_A & operand_B;
			/* Setting the flags for AND */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			flags_out[1] = 1'b0;
			flags_out[0] = csh;
		end

		3'b101: /* OR */
		begin
			/* Simple logic OR operator */
			result = operand_A | operand_B;
			/* Setting the flags for OR */
			flags_out[3] = (result[15] == 1);
			flags_out[2] = (result == 16'b0000_0000_0000_0000);
			flags_out[1] = 1'b0;
			flags_out[0] = csh;
		end

		/* Default case to catch anything that may have slipped past the other cases */
		/* The default case also catches the LD/ST */
		/* and the BCC instructions */
		default:
		begin
			result = 16'bx;
			flags_out = 4'bx;
		end
	endcase
end

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
