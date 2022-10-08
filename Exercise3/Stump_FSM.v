// Stump FSM
// Implement your Stump FSM here
//
// Created by Horia-Gabriel Radu, Nov 2020
//
// ** Update this header **

// 'include' definitions of function codes etc.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none

module Stump_FSM (input  wire	     clk,	    // System clock
                  input  wire	     rst,	    // Master reset
                  input  wire [2:0]  opcode,    // Opcode from IR
                  output reg  [1:0]  state);	// Current state of the FSM


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

reg [1:0] current_state, next_state;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* FSM here                                                                   */

/* Next state logic */
always @ (*)

    case (current_state)

        `FETCH:      next_state = `EXECUTE;

        `EXECUTE:    if (opcode == `LDST)   next_state = `MEMORY;
                     else                   next_state = `FETCH;

        `MEMORY:     next_state = `FETCH;

        default:     next_state = 2'bxx;

    endcase

/* Reset and change memory logic */
always @ (posedge clk, posedge rst)
    begin
        if (rst)
            current_state <= `FETCH;
        else
            current_state <= next_state;
    end
    
/* Output logic logic */
always @ (*)
    begin
        state = current_state;
    end


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
