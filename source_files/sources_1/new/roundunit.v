`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 20.01.2021 19:32:27
// Design Name: behavioral approach
// Module Name: roundunit
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: the result generated by BOOTH MULTIPLIER is of 14 bits
//              but as specified in BFLOAT16 representation the mantissa
//              is of 7 bits so some rounding is to be done.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module roundunit(
    output reg[6:0] out,
    input wire [15:0] in
    );

    always @(in) begin

        //- if significand bits are all 1's then no normalization.
        if((&in[13:7])== 1) out= in[13:7];

        //- if index 6 is 0 down normalization
        else if(in[6]== 0) out= in[13:7];

        //- if index 6 is 1 then if any one subsequent bit is 1 then
        //- up normalization.
        else if((in[6]==1) && ((|in[5:0])==1)) out= in[13:7]+7'b000_0001;

        //- if index 6 is 1 also no subsequent bits are 1 then
        //- normalize such that index 7 is 0.
        else if(in[7]==0) out= in[13:7];
        
        else out= in[13:7]+7'b000_0001;
    end
endmodule
