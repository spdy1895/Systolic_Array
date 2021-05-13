`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 17:33:31
// Design Name: datapath for BOOTH MULTIPLIER
// Module Name: datapath_BOOTH
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: datapath for BOOTH MULTIPLICATION instantiating the individual
//              modules:
//              1. shift register A(SHIFTREG1)
//              2. shift register Q(SHIFTREG2)
//              3. dff(DFF)
//              4. PIPO M(PIPO)
//              5. ALU(ALU)
//              6. COUNTER(COUNTER)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath_BOOTH(
    output wire q0, qm1, eqz,
    output wire [15:0] data_out,

    //multiplicand
    input wire [7:0] data_in1,
    //multiplier
    input wire [7:0] data_in2,
    input wire LdA, 
    input wire LdQ,
    input wire LdM,

    input wire clrA,
    input wire clrQ,
    input wire clrM,
    input wire clrff,

    input wire sftA,
    input wire sftQ,
    input wire sftDff,

    input wire add_sub,
    input wire EnableALU,
    
    input wire clk,
    input wire LdCount,
    input wire decr
    );

    wire [7:0] A, M, Q, Z;
    wire [3:0] LdCountValue;
    wire [3:0] count;
    wire [15:0]tmp;

    assign eqz= ~|count;
    assign data_out= {A, Q};
    assign q0= Q[0];

    SHIFTREG1 REG_A(A, Z, A[7], clk, LdA, clrA, sftA);
    //A[7] -sign of the register A to be carry forwarded for 
    //the next iterations after the shift right operation is 
    //performed.
    SHIFTREG2 REG_Q(Q, LdCountValue, data_in2, A[0], clk, LdQ, clrQ, sftQ);
    //A[0]- LSB of the register A which is to be shifted to 
    //the next register Q which stores the multiplier.
    DFF QM1(qm1, Q[0], sftDff, clk, clrff);
    //the dff input is Q[0] which is the LSB of register Q
    //the multiplier.
    PIPO REG_M(M, data_in1, clk, LdM, clrM);
    ALU AL(Z, A, M, add_sub, EnableALU);
    COUNTER CN(count, LdCountValue, decr, LdCount, clk);
    /*
    always @(posedge clk) begin
        data_out<= tmp;
    end
*/
endmodule //datapath_BOOTH
