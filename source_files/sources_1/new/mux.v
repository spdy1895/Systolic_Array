`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 02.01.2021 00:27:52
// Design Name: Systolic-processor
// Module Name: mux
// Project Name: Systolic-processor
// Target Devices: SPARTAN-3
// Tool Versions: 2019.1
// Description: multiplexer unit to sel from ripple carry and
//              skip carry.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux(
    output wire out,
    input wire in0,
    input wire in1,
    input wire sel
    );

    assign out= (sel== 1'b1) ? in1 : in0;
endmodule
