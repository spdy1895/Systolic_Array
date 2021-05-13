`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 20:26:26
// Design Name: 
// Module Name: SHIFTREG2
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: SHIFTREG2 is used to store the
//              multiplier.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SHIFTREG2(
    output reg [7:0] data_out,
    output wire [3:0] LdCountValue,
    input wire [7:0] data_in2,
    input wire s_in,
    input wire clk,
    input wire Ld,
    input wire clr,
    input wire sft
    );

    always @(posedge clk) begin
    if(clr) data_out<= 0;
    else if(Ld) data_out<= data_in2;
    else if(sft) data_out<= {s_in, data_out[7:1]};
end

assign LdCountValue= 4'b1000;
endmodule //SHIFTREG2
