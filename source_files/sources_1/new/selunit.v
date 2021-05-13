`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 02.01.2021 00:16:26
// Design Name: Systolic-processor
// Module Name: selunit
// Project Name: Systolic-processor
// Target Devices: SPARTAN-3
// Tool Versions: 2019.1
// Description: select unit to select between ripple carry
//              and skip carry.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module selunit(
    output wire sel,
    input wire a0 ,b0,
    input wire a1, b1

    );

    //carry equation is Ci+1= Gi + Pi*Ci;
    //Pi is the propagation i.e. Ai xor Bi;
    //Gi is the generation i.e. Ai and Bi;

    assign sel= (((a0^b0)&(a1^b1))== 1'b1) ? 1 : 0;
endmodule
