`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 29.01.2021 19:27:46
// Design Name: behavioral approach
// Module Name: RESULT_PIPO
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: the result register stores the final result of the entire
//              BFLOAT16 multiplication.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RESULT_PIPO(
    output reg [15:0] data_out,

    input wire [15:0] data_in,
    input wire clr,
    input wire en,
    input wire clk
    );

    always @(posedge clk) begin
        if(clr== 1) data_out<= 15'd0;
        else if(en== 1) data_out<= data_in;
        else data_out<= data_out;
    end
endmodule
