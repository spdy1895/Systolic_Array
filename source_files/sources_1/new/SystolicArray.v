`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 14.04.2021 10:42:26
// Design Name: instantiation of Systolic Processing elements
// Module Name: SystolicArray
// Project Name: Systolic Array
// Target Devices: nexys ddr 4
// Tool Versions: 2020.2
// Description: instantiation of various processing elements
//              to form an array of processing elements.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SystolicArray(
    output wire done_PE11,
    output wire done_PE22,
    output wire [15:0] result_row1,
    output wire [15:0] result_row2,

    // input signals for processing element PE11
    input wire [15:0] a11,
    input wire [15:0] b1,
    input wire [15:0] previous_StageOperand,
    input wire start_PE11,
    input reset,
    input clear,

    // input signals for processing element PE21
    input wire [15:0] a21,
    input wire start_PE21,

    // input signal for processing element PE12
    input wire [15:0] a12,
    input wire [15:0] b2,
    input wire start_PE12,

    // input wire for processing element PE22
    input wire [15:0] a22,
    input wire start_PE22,

    input wire clk
    );

    // wires to connect the processing elements with each other.
    wire [15:0] w0;
    wire [15:0] w1;
    wire [15:0] w2;
    wire [15:0] w3;

    // instantiation of PE11
    Systolic_Processor PE11(
        
        // output
        .result(w1),
        .next_row_operand(w0),
        .delayed_done(done_PE11),

        // input
        .operand1(a11),
        .operand2(b1),
        .previous_StageOperand(previous_StageOperand),
        .start(start_PE11),
        .reset(reset),
        .clear(clear),
        .clk(clk)
    
    );

    
    
    // instantiation of PE12
    Systolic_Processor PE12(

        // output
        .result(result_row1),
        .next_row_operand(w2),      
        .delayed_done(),            // ignore, not used by controller

        // input
        .operand1(a12),
        .operand2(b2),
        .previous_StageOperand(w1),
        .start(start_PE12),
        .reset(reset),
        .clear(clear),
        .clk(clk)

    );
    
    
    // instantiation of PE21
    Systolic_Processor PE21(
        
        // output
        .result(w3),
        .next_row_operand(),    // not used further
        .delayed_done(),        // ignore, not used by controller

        // input
        .operand1(a21),
        .operand2(w0),
        .previous_StageOperand(previous_StageOperand),
        .start(start_PE21),
        .reset(reset),
        .clear(clear),
        .clk(clk)

    );
    
    
    // instantiation of PE22
    Systolic_Processor PE22(
        // output
        .result(result_row2),
        .next_row_operand(),        // not used further
        .delayed_done(donw_PE22),

        // input
        .operand1(a22),
        .operand2(w2),
        .previous_StageOperand(w3),
        .start(start_PE22),
        .reset(reset),
        .clear(clear),
        .clk(clk)

    );


endmodule
