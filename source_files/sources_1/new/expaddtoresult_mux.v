`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 11.02.2021 14:38:16
// Design Name: behavioral approach
// Module Name: expaddtoresult_mux
// Project Name: Systolic Array
// Target Devices: nexys ddr 4
// Tool Versions: 2020.2
// Description: this unit will select the proper result based on the
//              input from the exponent addition unit and status register.
//              i.e. check the overflow and underflow cases and then assign
//              the results accordingly.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module expaddtoresult_mux(
    output reg [7:0] mux_out,

    input wire [7:0] in_result,

    //select lines
    input wire underflow, 
    input wire overflow
    );

    always @(*) begin
        case({underflow, overflow}) 
            
            // neither overflow nor underflow has occured.
            00: mux_out= in_result;

            // overflow has occured.
            01: mux_out= 8'b1111_1110;

            // underflow has occured.
            10: mux_out= 8'b0000_0001;

            //-> take advice on this case. what should be the
            //-> default case for 11 and all other unforseen 
            //-> conditions?.
            default: mux_out= in_result;
        endcase
    end
endmodule
