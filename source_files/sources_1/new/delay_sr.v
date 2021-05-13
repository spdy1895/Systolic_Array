`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 13.04.2021 14:09:52
// Design Name: delay shift register
// Module Name: delay_sr
// Project Name: Systolic Array
// Target Devices: nexys ddr 4
// Tool Versions: 2020.2
// Description: this module is designed to provide a delay of one clock to done signal.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module delay_sr(
    output reg out,

    input wire d,
    input wire clk
    );

    reg q0;

    always @(negedge clk) begin
        q0<= d;
        out<= q0;
    end
endmodule
