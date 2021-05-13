`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 20:42:59
// Design Name: 
// Module Name: ALU
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    output reg [7:0] out,
    input wire [7:0] data_in1, data_in2,
    input wire add_sub,
    input wire EnableALU
    );

    always @(EnableALU, data_in1, data_in2) begin
        //add when active high.
        if(add_sub==0 && EnableALU== 1) out= data_in1-data_in2;
        else if(add_sub== 1 && EnableALU== 1) out= data_in1+data_in2;
        else out= 8'b000_0000;
    end
endmodule //ALU
