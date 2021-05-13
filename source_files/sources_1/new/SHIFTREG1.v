`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 20:16:18
// Design Name: 
// Module Name: SHIFTREG1
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: SHIFTREG1 is used for storing the 
//              partial product.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SHIFTREG1(
    output reg [7:0] data_out,
    input wire [7:0] data_in,
    input wire s_in, clk, Ld, clr, sft
    );

    always @(posedge clk) begin
    if(clr) data_out<= 0;
    else if(Ld) data_out<= data_in;
    else if(sft) data_out<= {s_in, data_out[7:1]};
end

endmodule //SHIFTREG1
