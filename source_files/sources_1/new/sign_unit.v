`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 29.01.2021 19:54:41
// Design Name: behavioral approach
// Module Name: sign_unit
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: based upon the sign of the two operands the sign for the
//              rsult is generated.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sign_unit(
    output wire sign,
    
    input wire sign1,
    input wire sign2
    );

    assign sign= ((sign1^sign2)== 1) ? 1 : 0;
endmodule
