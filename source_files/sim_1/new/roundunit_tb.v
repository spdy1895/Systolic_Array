`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2021 14:57:27
// Design Name: 
// Module Name: roundunit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module roundunit_tb(
    );
    wire [6:0] out;
    reg [13:0] in;

    roundunit r0(out, in);

    initial begin
        #50 in= 14'h29af;       //10_1001_10__10_1111--2
        #50 in= 14'h11ff;       //01_0001_11__11_1111--3
        #50 in= 14'h3fff;       //11_1111_11__11_1111--1
        #50 in= 14'h3f40;       //11_1111_01__00_0000--4
        #50 in= 14'h3ec0;       //11_1110_11__00_0000--5
        #50 $finish;
    end
endmodule
