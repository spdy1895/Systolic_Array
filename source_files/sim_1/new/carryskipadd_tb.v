`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 02.01.2021 01:07:39
// Design Name: Systolic-processor
// Module Name: carryskipadd_tb
// Project Name: Systolic-processor
// Target Devices: SPARTAN-3
// Tool Versions: 2019.1
// Description: testbench for carryskip adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carryskipadd_tb(

    );
    wire [7:0] sum;
    wire carry_final;
    reg [7:0] in1, in2;
    reg carry_in;

    carryskipadd s0(sum, carry_final, in1, in2, carry_in);

    initial begin
        {in1, in2, carry_in}= {8'hAC, 8'h31, 1'b0};
        #30 {in1, in2, carry_in}= {8'hB1, 8'h3A, 1'b1}; 
        #30 $finish;
    end

endmodule
