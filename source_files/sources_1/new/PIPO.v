`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubam pandey
// 
// Create Date: 07.01.2021 20:39:22
// Design Name: 
// Module Name: PIPO
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: PIPO to store the multiplicand.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//multiplicand unit
module PIPO(
    output reg [7:0] data_out,
    input wire [7:0] data_in1,
    input wire clk, 
    input wire load,
    input wire clear 
    );

    always @(posedge clk) begin
        if(clear) data_out<= 8'b000_0000;
        else if(load) data_out<= data_in1;
    end
endmodule //PIPO
