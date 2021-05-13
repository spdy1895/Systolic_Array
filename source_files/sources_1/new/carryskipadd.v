`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 02.01.2021 00:33:40
// Design Name: Systolic-processor
// Module Name: carryskipadd
// Project Name: Systolic-processor
// Target Devices: SPARTAN-3
// Tool Versions: 2019.1
// Description: 16-bit carry skip adder. Each block is of 
//              size 3-bit. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carryskipadd(
    output wire [7:0] sum,
    output wire carry_final,

    input wire [7:0] in1,
    input wire [7:0] in2,
    input wire carry_in

    );

    wire [4:0] carry;
    wire [2:0] m;   //output of multiplexer units

    //initial carry is assigned to carry[0]
    assign carry[0]= carry_in;

    //initializing the carrty initial of individual blocks
    assign carry[1]= m[0];
    assign carry[2]= m[1];
    assign carry[3]= m[2];

    fulladd f2(sum[6], carry[4], in1[6], in2[6], carry[3]);
    fulladd f3(sum[7], carry_final, in1[7], in2[7], carry[4]);

    genvar i;
    generate
        for (i= 0; i<= 4 ; i= i+2) begin
            wire   w0, w1, sel;
            fulladd f0(sum[i], w0, in1[i], in2[i], carry[i/2]);
            fulladd f1(sum[i+1], w1, in1[i+1], in2[i+1], w0);
            selunit s0(sel, in1[i], in2[i], in1[i+1], in2[i+1]);
            mux m0(m[i/2], w1, carry[i/2], sel);
        end
    endgenerate
endmodule
