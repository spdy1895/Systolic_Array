`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 17:16:22
// Design Name: datapath and controller approach
// Module Name: top_BOOTH
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: top module to instantiate the datapath and controller
//              of BOOTH MULTIPLIER
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_BOOTH(
    output wire done,
    output wire [15:0] MUL_result,
    
    //in1 is multiplicand
    input wire [7:0] data_in1,
    //in2 is multiplier
    input wire [7:0] data_in2,
    input wire start,
    //input wire rstn,
    input wire clk
    );

    //this wire is a hack to solve to problem of
    //wire driving the other module wire.
    //wire [13:0] datapath2top;

    wire    LdA, clrA, sftA,
        LdQ, clrQ, sftQ,
        clrff, sftDff,
        LdM, clrM,
        q0, qm1,
        LdCount, decr,
        add_sub, EnableALU,
        eqz;

datapath_BOOTH DAT(
    .eqz(eqz),

    .LdA(LdA),
    .clrA(clrA),
    .sftA(sftA),

    .LdQ(LdQ),
    .clrQ(clrQ),
    .sftQ(sftQ),

    .LdM(LdM),
    .clrM(clrM),
    .clrff(clrff),
    .sftDff(sftDff),
    
    .add_sub(add_sub),
    .EnableALU(EnableALU),

    .q0(q0),
    .qm1(qm1),
    
    .LdCount(LdCount),
    .decr(decr),

    //multiplicand
    .data_in1(data_in1),
    //multiplier
    .data_in2(data_in2),
    .data_out(MUL_result),
    
    .clk(clk)
);

//concept wise a reg should drive the other module wire.
//but this is a hack.
//assign MUL_result= datapath2top;

controller_BOOTH CTRL(
    .eqz(eqz),
    
    .LdA(LdA),
    .clrA(clrA),
    .sftA(sftA),
    
    .LdQ(LdQ),
    .clrQ(clrQ),
    .sftQ(sftQ),

    .LdM(LdM),
    .clrM(clrM),

    .clrff(clrff),
    .sftDff(sftDff),
    
    .add_sub(add_sub),
    .EnableALU(EnableALU),
    
    .q0(q0),
    .qm1(qm1),
    
    .LdCount(LdCount),
    .decr(decr),
    
    .start(start),
    .done(done),
    //.rstn(rstn),
    .clk(clk)
);

endmodule //top_BOOTH
