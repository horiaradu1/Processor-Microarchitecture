// Stump FSM testbench
// Horia-Gabriel Radu (based on a design by (P W Nutter (based on a design by Jeff Pepper))
// Nov 2020
// 

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps 

// module header

module Stump_FSM_tb();

// Internal connections

reg  clk, rst;
reg  [2:0] opcode;
wire [1:0] state;

// Instantiate mu0 fsm as dut (device under test)

Stump_FSM U0 (
    .clk    (clk),
    .rst    (rst),
    .opcode (opcode),
    .state  (state)
);

// Set up the clock

initial clk = 0;
initial rst = 0;
initial opcode = 0;

always
    begin
        #50 clk = ~clk;
    end
    

// Test vectors
initial
    begin
        // First we test all the instructions except LD/ST
        rst = 1;
        #5
        rst = 0;
        opcode = 0;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 1;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 2;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 3;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 4;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 5;
        #195
        rst = 1;
        #5
        rst = 0;
        opcode = 7;
        #195

        // Then we test the LD/ST instruction together with the reset signal

        // Tests for reset in first state for LD/ST
        #50
        rst = 1;
        opcode = 6;
        #5
        rst = 0;
        #95
        rst = 1;
        #5
        rst = 0;

        // Tests for reset in second state for LD/ST
        #145
        rst = 1;
        #5
        rst = 0;

        // Tests for reset in third state for LD/ST
        #195
        rst = 1;
        #5
        rst = 0;

        // And test for the whole sequence
        #450

        #100 $finish; // exit the simulation
    end
 
// Save results as VCD file 
initial
 begin
  $dumpfile("Stump_FSM_tb_results.vcd");  // Save simulation waveforms in this file
  $dumpvars; // Capture all simulation waveforms
 end

endmodule 
