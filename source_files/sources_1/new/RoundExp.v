`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-sources
// Engineer: Shubham Pandey
// 
// Create Date: 26.01.2021 10:52:42
// Design Name: behavioral approach
// Module Name: RoundeExp
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: this rounding unit will take exponent bits as inputs and will generate
//              addition of the bits only considering the significand bits for BFLOAT16.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//-> have to add status signal for overflow/underflow cases

//-> 1. added separate cases for positive overflow
//@  if positive overflow happens simply set the overflow register
//-> 2. added separate cases for negative underflow
//@  if negative underflow happens simply set the underflow register

//-> added clear signal for status registers (overflow and underflow)

module RoundExp(
    output reg [7:0] result,
    output reg overflow_status,
    output reg underflow_status,
    
    input wire [7:0] in1,
    input wire [7:0] in2,
    input wire clr,
    input wire clk
);

    wire carry_inH, carry_inL;
    wire carry_from_first_adder;
    wire [7:0] biascomp;
    wire [7:0] exp_add;
    wire [7:0] temp_result;

    assign carry_inH= 1'b1;
    assign carry_inL= 1'b0;

    assign biascomp= 8'b1000_0000;

    carryskipadd c0(
        .sum(exp_add),
        .carry_final(carry_from_first_adder),
        .in1(in1), 
        .in2(in2), 
        .carry_in(carry_inL)
    );

    carryskipadd c1(
        .sum(temp_result),
        .carry_final(),
        .in1(exp_add),
        .in2(biascomp),
        .carry_in(carry_inH)
    );

always @(posedge clk) begin
    result= temp_result;
end

//-> all the results should be within bounds:
//@ exponents can be represented as:
//@ -126 ----------0---------- +127
//- -126=  0000_0001
//- -infinity= 0000_0000

//= 0= 0111_1111 which is also the bias in BFLOAT16

//- +127= 1111_1110 maximum value to be represented.
//- from 1111_1111 overflow occurs and represents +infinity.

//= here lets deal with positve overlfow
always @(posedge clk) begin
    if(clr) overflow_status= 1'b0;
    else if((( (in1[7]&in2[7])==1) && 
                ( ((&temp_result)==1) ||
                ((carry_from_first_adder&(&exp_add[6:0]))==1) ||
                ((carry_from_first_adder&temp_result[7])==1)))==1) overflow_status= 1;
    else overflow_status= 0;
end
/*
assign overflow=    (( (in1[7]&in1[7])==1) && 
                    ( ((&temp_result[7:0])==1) ||
                      (carry_from_first_adder&(&exp_add[6:0])==1) ||
                      (carry_from_first_adder&temp_result[7])==1)) ? 1 : 0;
*/
//*******************************************************************************
// maximum postive value that can be obtained after addition without overflow
// is 1111_1110= +127.
// with 1111_1111= this represents +infinity i.e. assume the maximun allowable
// value of this particular standard which is +127 so will "set the resultant 
// register to 1111_1110= +127".
// in all the other additions the overflow carry and also the msb of temp_result
// will be high.
// addition resulting to 1_0000_0000 is also taken into account here.
//********************************************************************************

//= here lets deal with negative underflow
always @(posedge clk) begin
    if(clr) underflow_status= 1'b0;
    else if(((in1[7]|in2[7])==0) && (((|in1) | (|in2))!=0) && (((|temp_result)==0) || ( temp_result[7]==1))==1) underflow_status= 1;
    else underflow_status= 0;
end
/*
assign underflow=  ( ((in1[7]|in2[7])==0) &&
                   ( (|temp_result)==0) ||
                   ( temp_result[7]==1) ) ? 1 : 0;
*/
//********************************************************************************
// minimum negative value that one can expect after exponent addition is
// (-126)= 0000_0001 this is permissible.
// if value results further less than this then it's out of bounds. So we have to
// throw underflow error and then set the result of exponent addition to (-126)
// which is the maximum value.
// now exception cases:
//-  addition leading to -127 which is 0000_0000 so second condition is for this.
//-  addition below this will will have temp_result_msb[7]==1 which is not possible
//-  since in out BFLOAT16 we know exponent with MSB=1 are positive while with 0 are
//-  negative so addition of two negatives will not result in postitive. Hence underflow.

endmodule //RoundExp