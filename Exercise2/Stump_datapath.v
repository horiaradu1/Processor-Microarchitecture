// Stump Datapath
// Implement your Stump datapath in structural Verilog here, no control block
//
// Created by Horia-Gabriel Radu, Nov 2020
//
// ** Update this header **

// 'include' definitions of function codes etc.
`include "../Include/Stump_definitions.v"

// for simulation purposes, do not delete
`default_nettype none

// Main module
/*----------------------------------------------------------------------------*/


module Stump_datapath (input  wire        clk, 			// System clock
                       input  wire        rst,			// Master reset
                       input  wire [15:0] data_in,		// Data from memory
                       input  wire        fetch,		// State from control	
                       input  wire        execute,		// State from control
                       input  wire        memory,		// State from control
                       input  wire        ext_op,		// sign extender control
                       input  wire        opB_mux_sel,	// src_B mux control
                       input  wire [ 1:0] shift_op,		// shift operation
                       input  wire [ 2:0] alu_func,		// ALU function 
                       input  wire        cc_en,		// Status register enable
                       input  wire        reg_write,	// Register bank write
                       input  wire [ 2:0] dest,			// Register bank dest reg
                       input  wire [ 2:0] srcA,			// Source A from reg bank
                       input  wire [ 2:0] srcB,			// Source B from reg bank
                       input  wire [ 2:0] srcC,			// Used by Perentie
                       output wire [15:0] ir,			// IR contents for control
                       output wire [15:0] data_out,		// Data to memory
                       output wire [15:0] address,		// Address
                       output wire [15:0] regC,			// Ignore
                       output wire [ 3:0] cc);	 		// Flags



/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

wire [15:0] regA;
wire [15:0] regB;
wire [15:0] immed;
wire [15:0] reg_data;
wire [15:0] operand_A;
wire [15:0] operand_B;
wire        csh;
wire [15:0] src_2;
wire [15:0] alu_out;
wire [3:0]  alu_flags;
wire [15:0] addr_reg;


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Instantiate register bank                                                  */

Stump_registers registers (.clk(clk),
                           .rst(rst),
                           .write_en(reg_write),
                           .write_addr(dest),
                           .write_data(reg_data),
                           .read_addr_A(srcA), 
                           .read_data_A(regA),
                           .read_addr_B(srcB), 
                           .read_data_B(regB),
                           .read_addr_C(srcC), 		// Debug port address 
                           .read_data_C(regC));		// Debug port data    

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Instantiate other datapath modules here                                    */

Stump_reg16bit IR (.CLK(clk),
                   .CE(fetch),
                   .D(data_in),
                   .Q(ir));

Stump_sign_extender Sign_Extender (.ext_op(ext_op),
                                   .D(ir[7:0]),
                                   .Q(immed));

Stump_mux16bit mux_1 (.D0(alu_out),
                      .D1(data_in),
                      .S(memory),
                      .Q(reg_data));

Stump_shifter Stump_shift (.operand_A(regA),
                           .c_in(cc[0]),
                           .shift_op(shift_op),
                           .shift_out(operand_A),
                           .c_out(csh));

assign data_out = regA;

Stump_mux16bit mux_2 (.D0(regB),
                      .D1(immed),
                      .S(opB_mux_sel),
                      .Q(src_2));

Stump_mux16bit mux_3 (.D0(src_2),
                      .D1(16'b1),
                      .S(fetch),
                      .Q(operand_B));

Stump_ALU alu (.operand_A(operand_A),
               .operand_B(operand_B),
               .func(alu_func),
               .c_in(cc[0]),
               .csh(csh),
               .result(alu_out),
               .flags_out(alu_flags));

Stump_reg4bit CC (.CLK(clk),
                  .CE(cc_en),
                  .D(alu_flags),
                  .Q(cc));

Stump_reg16bit Address (.CLK(clk),
                        .CE(execute),
                        .D(alu_out),
                        .Q(addr_reg));

Stump_mux16bit mux_4 (.D0(regA),
                      .D1(addr_reg),
                      .S(memory),
                      .Q(address));

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


/*----------------------------------------------------------------------------*/

endmodule

// for simulation purposes, do not delete
`default_nettype wire

/*============================================================================*/
