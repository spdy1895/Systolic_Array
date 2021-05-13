`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 01.02.2021 13:20:40
// Design Name: instantiation of Processing Element Datapath and Controller
// Module Name: Systolic_Processor
// Project Name: Systolic Array
// Target Devices: ZYBO
// Tool Versions: 2020.2
// Description: a unit of systolic processor to perform multiplication of two operand in
//              BFLOAT16 format.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Systolic_Processor(
    output wire [15:0] result,
    output wire [15:0] next_row_operand,
    output wire delayed_done,

    input wire [15:0] operand1,
    input wire [15:0] operand2,
    input wire [15:0] previous_StageOperand,

    input wire start,
    input wire reset,       //to reset the state machine
    input wire clear,       //to clear various registers
    input wire clk
    );

    wire activate_BOOTH;
    wire clr_result_reg;
    wire clr_in_exp_reg;
    wire clr_status_reg;
    wire load_in_exp_reg;

    // instantiation of DATAPATH
    ProcessingElement_DATAPATH p0(
        .result(result),
        .next_row_operand(next_row_operand),
        .delayed_done(delayed_done),

        .in1(operand1),
        .in2(operand2),

        .previous_StageOperand(previous_StageOperand),

        .act_BOOTH(activate_BOOTH),
        .clr_result_PIPO(clr_result_reg),
        .clr_in_exp_PIPO(clr_in_exp_reg),
        .clr_status_reg(clr_status_reg),
        .load_in_exp_PIPO(load_in_exp_reg),
        .clk(clk)
    );

    // instantiation of CONTROLLER
    ProcessingElement_CONTROLLER p1(
        .act_BOOTH(activate_BOOTH),
        .clr_in_exp_PIPO(clr_in_exp_reg),
        .clr_result_PIPO(clr_result_reg),
        .clr_status_reg(clr_status_reg),
        .load_in_exp_PIPO(load_in_exp_reg),
        .start(start),

        // to reset the state machine
        .rst(reset),

        // to clear the various registers
        .clr(clear),
        .clk(clk)
    );


endmodule
