`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 21:01:10
// Design Name: 
// Module Name: COUNTER
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: this counter unit provides the counting
//              value for ALU addition(here it is 7 for 7 bits).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module COUNTER(
    output reg [3:0] data_out,

    input wire [3:0] LdCountValue,
    input wire decr,
    input wire Ld,
    input wire clk
    );

    always @(posedge clk) begin
        if(Ld) data_out<= LdCountValue;
        else if(decr) data_out<= data_out-1;
    end
endmodule //COUNTER
