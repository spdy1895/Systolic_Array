`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 29.01.2021 19:44:15
// Design Name: behavioral approach
// Module Name: IN_EXP_PIPO
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: this register stores the input sign and exponent bits from
//              the input matrix. Two separate PIPO registers are used to store
//              the two operands.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IN_EXP_PIPO(
    output reg [8:0] out_exp1,
    output reg [8:0] out_exp2,
    output wire out_sign1,
    output wire out_sign2,

    input wire [8:0] in_exp1,
    input wire [8:0] in_exp2,
    input wire clk,
    input wire clr,
    input wire load
    );

    always @(posedge clk) begin
        if(clr==1) begin
            out_exp1<= 8'd0;
            out_exp2<= 8'd0;
        end
        else if(load==1) begin
            out_exp1<= in_exp1;
            out_exp2<= in_exp2;
        end
        else begin
            out_exp1<= out_exp1;
            out_exp2<= out_exp2;
        end
    end

    assign out_sign1= in_exp1[8];
    assign out_sign2= in_exp2[8];
endmodule
