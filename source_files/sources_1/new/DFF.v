`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 20:33:14
// Design Name: 
// Module Name: DFF
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: a 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DFF(
    output reg q,
    
    input wire d, 
    input wire sft,
    input wire clk,
    input wire clr 
    );

    always @(posedge clk) begin
        if(clr) q<= 1'b0;
        else if(sft) q<= d;
        else q<= q;
    end
endmodule //DFF
