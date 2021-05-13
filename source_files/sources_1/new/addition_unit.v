`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 12.02.2021 11:48:22
// Design Name: behavioral approach
// Module Name: addition_unit
// Project Name: Systolic Array
// Target Devices: nexys ddr4
// Tool Versions: 2020.2
// Description: this unit performs the final additon for the multiplication
//              of operands i.e. the mantissa1, mantissa2 and BOOTH result.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module addition_unit(
    output wire [8:0] addition_result,

    input wire [6:0] mantissa1,
    input wire [6:0] mantissa2,
    input wire [6:0] round_unit_result
    );

    wire carryL;
    assign carryL= 1'b0;

    wire final_carry;
    wire [7:0] final_result;
    wire [7:0]intermediate_sum;

    // to add mantissa1 and mantissa2
    carryskipadd c2(
        .sum(intermediate_sum),
        .carry_final(),
        .in1({1'b0,mantissa1[6:0]}),
        .in2({1'b0,mantissa2[6:0]}),
        .carry_in(carryL)
    );

    // to add result obtained from above addition and BOOTH result
    //-> for simplicity and synchronization i will take round unit
    //-> result from the PIPO result register.
    carryskipadd c3(
        .sum(final_result),
        .carry_final(final_carry),
        .in1(intermediate_sum),
        .in2({1'b0,round_unit_result}),
        .carry_in(carryL)
    );

    assign addition_result= {final_carry, final_result} + 8'b1000_0000;

endmodule
