`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 29.01.2021 20:15:01
// Design Name: instantiation of discrete modules
// Module Name: ProcessingElement_DATAPATH
// Project Name: Systolic Array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: this top module instantiates the discrete modules in systolic
//              processing element.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//-> new units addded:
//-> 1. storing elements for operand2 (which will be
//->    passed vertically)
//-> 2. accumulate unit for adding and storing the previous obtained
//->    result added to newly obtained result (a11*b11 + a12*b21).
//-> 3. a bus for feeding the result of the previous processign element to
//->    next accumulator.
//-> 4. a out bus for passign the operand 2 to next stage of computation

module ProcessingElement_DATAPATH(
    output wire [15:0] result,
    output wire [15:0] next_row_operand,
    output wire delayed_done,

    input wire [15:0] in1,
    input wire [15:0] in2,

    // result from last stage of operation.
    input wire [15:0] previous_StageOperand,

    input wire act_BOOTH,
    input wire clr_result_PIPO,
    input wire clr_in_exp_PIPO,
    input wire clr_status_reg,
    input wire load_in_exp_PIPO,
    input wire clk
    );

    //wire acitvated by done of BOOTH multiplier acts as enable for result
    //register to store the result after the computation.
    wire enable;

    //bus to load the result of BOOTH multiplier output to rounding logic.
    wire [15:0] BOOTH_to_round;

    //bus to store the result of rounding logic to result register.
    wire [6:0] round_to_result;

    //buses to transfer input bits from input register to carryskip adder rounding logic
    wire [7:0] in_to_carry_round1;
    wire [7:0] in_to_carry_round2;

    //bus to transfer output of carry skip rounding logic to result register.
    wire [7:0] carryskipround_to_mux;

    //wire to transfer sign bits from in_exp_pipo to sign unit.
    wire pipo_to_sign1;
    wire pipo_to_sign2;

    //wire to transfer the resultant sign bit to result register.
    wire sign_to_result;


    //-> since the BOOTH multiplier is used for signed multiplicaiton and the
    //-> MSB is treated as sign, but for our application here it is to perform
    //-> magnitude multiplication that too of the bits after the decimal.
    //-> a not so good workaround is to send only the magnitude bits to BOOTH
    //-> i.e. let the MSB bits be zero that way we will have magnitude multiplication
    //-> by BOOTH.

    //@ also changing the BOOTH multiplier size from 7 bits to 8 bits operand.
    wire [7:0] workaround_wire1;
    wire [7:0] workaround_wire2;

    assign workaround_wire1[7]= 1'b0;
    assign workaround_wire2[7]= 1'b0;

    assign workaround_wire1= in1[6:0];
    assign workaround_wire2= in2[6:0];

    // wire relating to addition unit
    wire PIPO_sign;
    wire [7:0] PIPO_exp;
    wire [6:0] PIPO_mantissa;

    // wire relating to mux unit between exponent addition and mux
    wire [7:0] mux_out;
    wire underflow_status;
    wire overflow_status;

    // wire between final addition unit to accumulator
     wire [8:0] end_result_of_mul;

    //@ instantiating the discrete modules

    //@ 1
    //instantiation of top_BOOTH
    top_BOOTH tp0(
        //output ports
        .done(enable),
        .MUL_result(BOOTH_to_round),

        //input ports
        //-> in BFLOAT16 format the lower 7 bits that represent 
        //-> mantissa are to be fed to BOOTH multiplier.
        //-> workaround wires added for hack.
        .data_in1(workaround_wire1),
        .data_in2(workaround_wire2),
        .start(act_BOOTH),
        .clk(clk)
    );

    //@ 2
    //instantiation of roundunit
    roundunit ru0(
        //output ports
        .out(round_to_result),

        //input ports
        .in(BOOTH_to_round)
    );

    //@ 3
    //instantiation of IN_EXP_PIPO
    IN_EXP_PIPO i0(
        //output ports
        .out_exp1(in_to_carry_round1),
        .out_exp2(in_to_carry_round2),
        .out_sign1(pipo_to_sign1),
        .out_sign2(pipo_to_sign2),
        
        //input ports
        .in_exp1(in1[15:7]),
        .in_exp2(in2[15:7]),
        .clk(clk),
        .clr(clr_in_exp_PIPO),
        .load(load_in_exp_PIPO)
    );

    //@ 4
    //instantiation of RoundExp
    RoundExp re0(
        //output ports
        .result(carryskipround_to_mux),
        .overflow_status(overflow_status),
        .underflow_status(underflow_status),

        //input ports
        .in1(in_to_carry_round1),
        .in2(in_to_carry_round2),
        .clr(clr_status_reg),
        .clk(clk)
    );

    //@ 5
    //instantiation of sign unit
    sign_unit su0(
        //output ports
        .sign(sign_to_result),

        //input ports
        .sign1(pipo_to_sign1),
        .sign2(pipo_to_sign2)
    );

    //@ 6
    //instantiation of result register
    RESULT_PIPO rp0(
        //output ports
        .data_out({PIPO_sign, PIPO_exp, PIPO_mantissa}),

        //input ports
        .data_in({sign_to_result, mux_out, round_to_result}),
        .clr(clr_result_PIPO),
        .en(enable),
        .clk(clk)
    );

    //@ 7
    //instantiation of mux unit for choosing appropriat result based on
    //addition performed by exponent addition unit and status register.
    expaddtoresult_mux em0(
        .mux_out(mux_out),
        .in_result(carryskipround_to_mux),
        .underflow(underflow_status),
        .overflow(overflow_status)
    );

    //@ 8
    //instantiation of PIPO unit for transferring operand2 to next stage of SYSTOLIC array row.
    pipo_OP2 po0(
        .out(next_row_operand),

        .in(in2),
        .clr(clr_in_exp_PIPO),
        .en(load_in_exp_PIPO),
        .clk(clk)
    );

    //@ 9
    //instantiation of addition unit for final addition of operands
    addition_unit au0 (
        .addition_result(end_result_of_mul),
        .mantissa1(in1[6:0]),
        .mantissa2(in2[6:0]),
        .round_unit_result(PIPO_mantissa)
    );

    //@ 10
    // instantiation of accumulator unit, which also performs normalization
    // to BFLOAT16 format.
    accumulator_unit accu0 (
        .processingElementResult(result),

        .result_reg_pipo({PIPO_sign, PIPO_exp}),
        .addition_unit_result(end_result_of_mul),
        .previousOperand(previous_StageOperand),
        .clr(clr_result_PIPO),
        .clk(clk)
    );

    //@ 11
    // instantiation of delay_sr unit, which is a 2 bit shift register unit to delay done
    // signal by a clock.
    delay_sr dsr0(
        .out(delayed_done),

        .d(enable),
        .clk(clk)
    );

endmodule
