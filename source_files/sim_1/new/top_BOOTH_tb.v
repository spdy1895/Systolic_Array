`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 22:13:25
// Design Name: datapath and controller approach
// Module Name: top_BOOTH_tb
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


module top_BOOTH_tb(

    );

    wire done;
    wire [13:0] MUL_result;
    reg [6:0] data_in1;
    reg [6:0] data_in2;
    reg start;
    reg clk;

    //instantiating the top_BOOTH module
        top_BOOTH t0(done, MUL_result, data_in1, data_in2, start, clk);

        initial begin
            clk= 1'b0;
            forever #5 clk= ~clk;
        end
        initial begin
            #30 start= 1'b1; data_in1= 7'h76; data_in2= 7'h0d;
            #10 start= 1'b0;
            #400 start= 1'b1; data_in1<= 7'h09; data_in2<= 7'h0a;
            #400 $finish;
        end
endmodule
