// Stump control block
//
// Created by P W Nutter, Sept 2020
//
// Update by Horia Gabriel Radu, Dec 2020

// 'include' definitions of function codes etc.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none

/*----------------------------------------------------------------------------*/

module Stump_control (input  wire		  rst,
                      input  wire         clk,
		    		  input  wire [3:0]   cc,			 // current status of cc
              	      input  wire [15:0]  ir,			 // current instruction
                      output wire         fetch,
                      output wire         execute,	     // current state
                      output wire         memory,
                      output wire         ext_op,		      
 		    		  output wire         reg_write,	 // register write enable
		    		  output wire  [2:0]  dest,		     // destination register		      
		   		 	  output wire  [2:0]  srcA,		     // Source register operand A
		    		  output wire  [2:0]  srcB,		     // Source register operand B
		    		  output wire  [1:0]  shift_op,
              	      output wire         opB_mux_sel,   // operandB mux select
		    		  output wire  [2:0]  alu_func,	     // function derived from ir
              	      output wire         cc_en,		 // cc register enable
                      output wire         mem_ren,	     // Memory read enable		      
                      output wire         mem_wen);	     // Memory write enable
                   

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

wire [1:0] state;


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Instantiate modules                                                        */

Stump_FSM FSM (.clk(clk),
			   .rst(rst),
			   .opcode(ir[15:13]),
			   .state(state));

Stump_control_decode control_decode (.state(state),
									 .cc(cc),
									 .ir(ir),
									 .fetch(fetch),
									 .execute(execute),
									 .memory(memory),
									 .ext_op(ext_op),
									 .reg_write(reg_write),
									 .dest(dest),
									 .srcA(srcA),
									 .srcB(srcB),
									 .shift_op(shift_op),
									 .opB_mux_sel(opB_mux_sel),
									 .alu_func(alu_func),
									 .cc_en(cc_en),
									 .mem_ren(mem_ren),
									 .mem_wen(mem_wen));
     
     
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
