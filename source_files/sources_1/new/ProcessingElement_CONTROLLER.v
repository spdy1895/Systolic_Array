`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
//
// Create Date: 30.01.2021 15:32:41
// Design Name: controller for processing element
// Module Name: ProcessingElement_CONTROLLER
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: Processing Element Controller to generate the control signal
//              for the Processign Element Datapath. A simple FSM is
//              implemented here.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ProcessingElement_CONTROLLER(

    // signal to activate the BOOTH MUL
    output reg act_BOOTH,

    // clear signal for various registers
    output reg clr_in_exp_PIPO,
    output reg clr_result_PIPO,
    output reg clr_status_reg,

    // signal to load the value to sign and exponent registers
    output reg load_in_exp_PIPO,

    // controller for processign element gets acitvated by the start signal
    input wire start,

    input wire rst,     // to reset the controller to idle state.
    input wire clr,
    input wire clk
    );

    reg [1:0] pr_state, nxt_state;
    parameter   idle=   2'b00,
                clear=  2'b01,
                actv=   2'b10;

    //clock triggers the transition
    always @(posedge clk) begin
        if(rst==1) pr_state<= idle;
        else pr_state<= nxt_state;
    end

    //input determines the transition
    always @(pr_state or start or clr) begin

        case(pr_state)
        //all the control signals are low
        //waiting for activation
        idle: begin
            if(clr==1) nxt_state<= clear;
            else if(start==1) nxt_state<= actv;
            else nxt_state<= pr_state;
        end

        // after clearing the registers go to idle state
        clear: nxt_state<= idle;

        // after activating the required signals go to idle state
        actv: nxt_state<= idle;

        default: nxt_state<= idle;
        endcase
    end

    always @(pr_state) begin
        case (pr_state)

        idle: {
            act_BOOTH,
            clr_in_exp_PIPO,
            clr_result_PIPO,
            clr_status_reg,
            load_in_exp_PIPO
        }= 5'b00000;

        clear: {
            act_BOOTH,
            clr_in_exp_PIPO,
            clr_result_PIPO,
            clr_status_reg,
            load_in_exp_PIPO
        }= 5'b01110;

        //-> state to activate the BOOTH MUL and load the value to
        //-> sign and exponent registers.
        actv: {
            act_BOOTH,
            clr_in_exp_PIPO,
            clr_result_PIPO,
            clr_status_reg,
            load_in_exp_PIPO
        }= 5'b10001;

        default: {
            act_BOOTH,
            clr_in_exp_PIPO,
            clr_result_PIPO,
            clr_status_reg,
            load_in_exp_PIPO
        }= 5'b00000;
        endcase
    end

endmodule
