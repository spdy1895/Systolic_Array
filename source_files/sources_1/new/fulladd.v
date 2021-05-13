`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 01.01.2021 15:19:18
// Design Name: Systolic-processor
// Module Name: fulladd
// Project Name: Systolic-processor
// Target Devices: SPARTAN-3
// Tool Versions: 2019.1
// Description: a simple structural 1-bit full adder unit.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fulladd(
    output wire sum,
    output wire carry,
    input wire in1,
    input wire in2,
    input wire c_in 

    );

    wire w1, w2, w3;

    and(w1, in1, in2);
    xor(w2, in1, in2);
    and(w3, w2, c_in);
    xor(sum, w2, c_in);
    or(carry, w1, w3);

endmodule
