// Stump SIgn Extender
//
// J Pepper

module Stump_sign_extender (input wire        ext_op,
			                input wire [7:0]  D,
			                output reg [15:0] Q);

// The output Q contains a sign extended version of the input D depending
// upon the state of ext_op
			    
always @(*)                 // combinatorial logic block
 if(ext_op == 1)
  Q = {{8{D[7]}}, D[7:0]};  // sign extend to 16bits from bit7
 else
  Q = {{11{D[4]}}, D[4:0]}; // sign extend to 16bits from bit4
  
/*----------------------------------------------------------------------------*/

endmodule

/*============================================================================*/
