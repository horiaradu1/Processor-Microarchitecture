// Stump control decode module.
// Behavioural Verilog module describing combinatorial logic.
//
// Created by P W Nutter, Sept 2020
//
// Update by Horia Gabriel Radu, Dec 2020

// 'include' definitions of function codes etc.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none

/*----------------------------------------------------------------------------*/

module Stump_control_decode (input  wire [1:0]  state,      // current state of FSM
		             		 input  wire [3:0]  cc,         // current status of cc
              	             input  wire [15:0] ir,	        // current instruction
                             output reg         fetch,
                             output reg         execute,    // current state
                             output reg         memory,
 		             		 output reg         ext_op,		      
 		             		 output reg         reg_write,  // register write enable
		             		 output reg  [2:0]  dest,	    // destination register		      
		             		 output reg  [2:0]  srcA,	    // Source register operand A
		             		 output reg  [2:0]  srcB,	    // Source register operand B
		             		 output reg  [1:0]  shift_op,
              	             output reg         opB_mux_sel,// operandB mux select
		             		 output reg  [2:0]  alu_func,   // function derived from ir
              	             output reg         cc_en,      // cc register enable
                             output reg         mem_ren,	// Memory read enable		      
                             output reg         mem_wen		// Memory write enable
                      );

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

always @ (*)
  begin
    if (state == `FETCH)
    // -- For FETCH state --
      begin
        fetch = 1;
        execute = 0;
        memory = 0;

        ext_op = 0;
        reg_write = 1;

        dest = 3'b111;
        srcA = 3'b111;
        srcB = 3'bx;
        shift_op = 2'b00;
        opB_mux_sel = 1'bx;

        alu_func = `ADD;
        cc_en = 0;
        mem_ren = 1;
        mem_wen = 0;

      end
    else if (state == `EXECUTE)
    // -- For EXECUTE state --
      begin
        fetch = 0;
        execute = 1;
        memory = 0;

        mem_ren = 0;
        mem_wen = 0;

        if (ir[12] == 0)
          begin
            // - Type 1 -
            ext_op = 0;
            reg_write = 1;

            dest = ir[10:8];
            srcA = ir[7:5];
            srcB = ir[4:2];
            shift_op = ir[1:0];
            opB_mux_sel = 0;

            alu_func = ir[15:13];
            cc_en = ir[11];

            if (ir[15:13] == `LDST)
              begin
                // For Load/Store instructions
                reg_write = 0;

                alu_func = `ADD;
                cc_en = 0;
              end
          end
        else if (ir[12] == 1)
          begin
            if (ir[15:13] != 3'b111)
              begin
                // - Type 2 -
                ext_op = 0;
                reg_write = 1;

                dest = ir[10:8];
                srcA = ir[7:5];
                srcB = 3'bx;
                shift_op = 0;
                opB_mux_sel = 1;

                alu_func = ir[15:13];
                cc_en = ir[11];

                if (ir[15:13] == `LDST)
                  begin
                    // For Load/Store instructions
                    reg_write = 0;

                    alu_func = `ADD;
                    cc_en = 0;
                  end
              end
            else if (ir[15:13] == 3'b111)
              begin
                // - Type 3 -
                ext_op = 1;
                reg_write <= Testbranch(ir[11:8], cc);

                dest = 3'b111;
                srcA = 3'b111;
                srcB = 3'bx;
                shift_op = 0;
                opB_mux_sel = 1;

                alu_func = `ADD;
                cc_en = 0;
              end
          end
        
      end
    else if (state == `MEMORY)
    // -- For MEMORY state --
      begin
        fetch = 0;
        execute = 0;
        memory = 1;

        ext_op = 0;

        dest = 3'bx;
        srcA = 3'bx;
        srcB = 3'bx;
        shift_op = 1'bx;

        alu_func = 3'bx;
        cc_en = 0;
        if (ir[11] == 0)
          begin
            // For Load instruction
            reg_write = 1;

            dest = ir[10:8];
            
            mem_ren = 1;
            mem_wen = 0;
          end
        else if (ir[11] == 1)
          begin
            // For Store instruction
            reg_write = 0;

            srcA = ir[10:8];

            mem_ren = 0;
            mem_wen = 1;

          end
      end
  end


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/



/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Control decoder                                                             */







/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Condition evaluation - an example 'function'                               */

function Testbranch; 		// Returns '1' if branch taken, '0' otherwise
input [3:0] condition;		// Condition bits from instruction
input [3:0] CC;				// Current condition code register
reg N, Z, V, C;

begin
  {N,Z,V,C} = CC;			// Break condition code register into flags
  case (condition)
     0 : Testbranch =   1;	// Always (true)
     1 : Testbranch =   0;	// Never (false)
     2 : Testbranch = ~(C|Z);
     3 : Testbranch =   C|Z;
     4 : Testbranch =  ~C;
     5 : Testbranch =   C;
     6 : Testbranch =  ~Z;
     7 : Testbranch =   Z;
     8 : Testbranch =  ~V;
     9 : Testbranch =   V;
    10 : Testbranch =  ~N;
    11 : Testbranch =   N;
    12 : Testbranch =   V~^N;
    13 : Testbranch =   V^N;
    14 : Testbranch = ~((V^N)|Z) ;
    15 : Testbranch =  ((V^N)|Z) ;
  endcase
end
endfunction

/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
