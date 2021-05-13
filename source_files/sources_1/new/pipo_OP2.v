`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 11.02.2021 19:21:57
// Design Name: behavioral approach
// Module Name: pipo_OP2
// Project Name: Systolic Array
// Target Devices: nexys ddr4
// Tool Versions: 2020.2
// Description: this PIPO shift register will simply transfer the value of operand2 to
//              next row of Systolic array.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipo_OP2(
    output reg [15:0] out,
    input wire [15:0] in,
    input wire clr,
    input wire en,
    input wire clk
    );

    always @(posedge clk) begin
        if(clr) out<= 15'd0;
        else if (en==1) out<= in;
        else out<= out;
    end
endmodule
