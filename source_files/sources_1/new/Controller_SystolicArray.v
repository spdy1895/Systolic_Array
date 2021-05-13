`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 14.04.2021 12:54:28
// Design Name: fsm based controller for Systolic Array
// Module Name: Controller_SystolicArray
// Project Name: Systolic Array
// Target Devices: nexys ddr 4
// Tool Versions: 2020.2
// Description: fsm based controller for the processing elements.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller_SystolicArray(
    output reg rst,
    output reg clr,
    output reg start_PE11,
    output reg start_PE12,
    output reg start_PE21,
    output reg start_PE22,

    input wire PE11_delayed_done,
    input wire PE22_delayed_done,
    input wire idle,
    input wire clr,
    input wire rst,
    input wire start,
    input wire clk
    );

    reg [6:0] pr_state, nxt_state;

    parameter   idle=       7'b000_0001,
                clear=      7'b000_0010,
                reset=      7'b000_0100,
                startPE11=  7'b000_1000,
                startPE21=  7'b001_0000,
                startPE12=  7'b010_0000,
                startPE22=  7'b100_0000;


    // making a moore machine.
    // transition block
    always @(posedge clk) begin
        if(idle== 1'b1) pr_state<= idle;
        else pr_state<= nxt_state;
    end

    // state determining block
    always @(pr_state, start, done, rst, clear) begin
        
        case(pr_state)
            
            idle: begin
                if(idle== 1'b1) nxt_state<= idle;
                else if(rst== 1'b1) nxt_state<= reset;
                else if(clear== 1'b1) nxt_state<= clear;
                else if(start== 1'b1 || PE22_delayed_done== 1'b1) nxt_state<= startPE11;
                else if(PE11_delayed_done== 1'b1) nxt_state<= start_PE12;
                else nxt_state<= idle;
            end

            reset: nxt_state<= idle;
            
            clear: nxt_state<= idle;

            startPE11: nxt_state<= startPE21;

            startPE12: nxt_state<= startPE22;

            startPE21: nxt_state<= idle;

            start_PE22: nxt_state<= idle;

            default: nxt_state<= idle;
        endcase

    end

    // output from the state.
    always @(pr_state) begin
        
        case(pr_state)
            idle:       {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_0000;
            clear:      {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b01_0000;
            reset:      {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b10_0000;
            startPE11:  {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_1000;
            startPE12:  {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_0100;
            startPE21:  {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_0010;
            startPE22:  {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_0001;
            default:    {rst, clr, start_PE11, start_PE12, start_PE21, start_PE22}= 6'b00_0000;
        endcase

    end

endmodule
