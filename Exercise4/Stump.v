// Stump Processor
//
// Created by Paul W Nutter, April 2019
//
// Update by Horia Gabriel Radu, Dec 2020

// 'include' definitions of function codes etc.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none

/*----------------------------------------------------------------------------*/

module Stump (input  wire        clk,		// System clock
              input  wire        rst,		// Master reset
              input  wire [15:0] data_in,	// Data from memory
              output wire [15:0] data_out,	// Data to memory
              output wire [15:0] address,	// Address
              output wire        mem_wen,	// Memory write enable
              output wire        mem_ren,	// Memory read enable
              // Extra signals for observability
              output wire        fetch,		// CPU in the fetch state
              input  wire [ 2:0] srcC,		// Extra register port select
              output wire [15:0] regC,		// Extra register port data
              output wire [ 3:0] cc);		// Flags

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

wire [15:0] ir;
//wire fetch;
wire execute;
wire memory;
wire ext_op;
wire reg_write;
wire [2:0] dest;	      
wire [2:0] srcA;
wire [2:0] srcB;
wire [1:0] shift_op;
wire opB_mux_sel;
wire [2:0] alu_func;
wire cc_en;
//wire mem_ren;	      
//wire mem_wen);


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Instantiate modules here                                                   */

Stump_control control (.rst(rst),
                       .clk(clk),
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

Stump_datapath datapath (.clk(clk),
                         .rst(rst),
                         .data_in(data_in),
                         .fetch(fetch),
                         .execute(execute),
                         .memory(memory),
                         .ext_op(ext_op),
                         .opB_mux_sel(opB_mux_sel),
                         .shift_op(shift_op),
                         .alu_func(alu_func),
                         .cc_en(cc_en),
                         .reg_write(reg_write),
                         .dest(dest),
                         .srcA(srcA),
                         .srcB(srcB),
                         .srcC(srcC),
                         .ir(ir),
                         .data_out(data_out),
                         .address(address),
                         .regC(regC),
                         .cc(cc));


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
