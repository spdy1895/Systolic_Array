`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: shubham pandey
// 
// Create Date: 07.01.2021 21:08:38
// Design Name: 
// Module Name: controller_BOOTH
// Project Name: Systolic array
// Target Devices: SPARTAN-3
// Tool Versions: 2020.2
// Description: fsm based controller for BOOTH multiplier.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller_BOOTH(
    
    //partial product shift reg control signals
    output reg LdA,
    output reg clrA,
    output reg sftA,

    //multiplier control signals
    output reg LdQ,
    output reg clrQ,
    output reg sftQ,

    //dff control signals
    output reg sftDff,
    output reg clrff,

    //multiplicand control signals
    output reg LdM,
    output reg clrM,

    //alu control signals
    output reg add_sub,
    output reg EnableALU,

    //counter control signals
    output reg decr,
    output reg LdCount,

    //status signal to validate
    //completion of data computation
    output reg done,

    input wire clk,
    input wire q0,
    input wire qm1,
    input wire start,
    input wire eqz
    );

    //9 states needing 4-bits.
    reg [3:0] state;
    //-> using the gray code encoding for the state variable
    //-> adjacent states have 1 bit change
    parameter   idle=   4'b1100,     //idle state   : all control signals are low.
                clear=  4'b1110,     //clear state  : all shift registers are cleared.
                load=   4'b1010,     //loadi state  : load values to multiplier, multiplicand and counter.
                dummy=  4'b1000,     //dummy state  : before going to the check state values in the shift registers get loaded in this state.
                check=  4'b1001,     //check state  : based on the values of {Q[0], Q[-1]} next state is predicted.
                shift=  4'b0000,     //shift state  : all shift registers shifts there values and counter decrements.
                add=    4'b0001,     //add state    : if {Q[0], Q[-1]} is 01 then add the multiplicand to partial product.
                sub=    4'b0010,     //sub state    : if {Q[0], Q[-1]} is 10 then subtract multiplicand from partial product.
                done_state=   4'b0100;     //done state   : done signal is made high in this state.
        
    //clock triggers the transiton here.
    //in stages s2 lsb bits determines the next state.
    //state determining always block.
    always @(posedge clk) begin
        case (state)
            //@ initially start from idle state with all control signal set to low.
            //-> if start signal is high then move to clear state.
            idle: if(start) state<= clear;
            //= idle: 1100(12)

            //-> after clear state directly go to load state.
            clear: state<= load;
            //= clear: 1110(14)

            //-> after load state in order to load value to registers and to perform check
            //-> one additional state i.e. dummy state is required.
            load: state<= dummy;
            //= load: 1010(10)
            /*
            begin
                if({q0, qm1}== 2'b01) state= S3;
                else if({q0, qm1}== 2'b10) state= S4;
                else state= S5;
            end
            */
            //-> after dummy state directly go to check state.
            dummy: state<= check;
            //= dummy: 1000(8)

            //-> in check state on the basis of the value {Q[0], Q[-1]} predict next state.
            check: begin
                if(eqz== 1) state<= done_state;
                else if({q0, qm1}== 2'b01) state<= add;
                else if({q0, qm1}== 2'b10) state<= sub;
                else state<= shift;
            end
            //= check: 1001(9)
            
            //-> in shift state simply perform the shifting operation and check for counter equal to 0.
            //-> if counter equal to zero then go to done state else go back to dummy state.
            shift: state<= dummy;
            /*
            begin
                if(eqz== 1) state<= done_state;
                else state<= dummy;
            end
            */
            //= shift: 0000(0)
            
            //-> in add state add the multiplicand to partial product and then go to
            //-> shift state.
            add: state<= shift;
            //= add: 0001(1)

            //-> in sub state subtract the multiplier from partial product and then go to
            //-> shift state.
            sub: state<= shift;
            //= sub= 0010(2)

            //-> in done state simply make the done signal high and go to idle state and
            //-> wait for the next start signal to proceed.
            done_state: state<= idle;
            //= done= 0100(4)

            //-> by defalut stay in idle state.
            default: state<= idle;
        endcase
    end


    //output of the controller based on the stage.
    //output determinig always block.
    always @(state) begin
        case (state)
            idle: begin
                //idle state all control signals are low.
                //partial-product control signals are low. 
                {LdA, clrA, sftA}= 3'b000;

                //multiplier control signals are low.
                {LdQ, clrQ, sftQ}= 3'b000;

                //multiplicand and Dff  control signals are low.
                {LdM, clrM, clrff, sftDff, done}= 5'b0000; 
                //alu and counter control signals are low.
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end

            clear: begin
                //partial-product register is cleared.
                {LdA, clrA, sftA}= 3'b010; 

                //multiplier register is cleared.
                {LdQ, clrQ, sftQ}= 3'b010; 

                //multiplicand and dff register is cleared
                {LdM, clrM, clrff, sftDff, done}= 5'b01_100; 
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end

            load: begin
                {LdA, clrA, sftA}= 3'b000;

                //multiplier shift register loads it's value
                {LdQ, clrQ, sftQ}= 3'b100;
                
                //multiplicand shift register loads it's value
                {LdM, clrM, clrff, sftDff, done}= 5'b10_000;
                //counter loads it's value based on the number 
                //of the digits of multiplier (defautl 7-bits)
                {add_sub, EnableALU, LdCount, decr}= 4'b0010;
            end

            dummy: begin
                //dummy state all control signals are low.
                //partial-product control signals are low. 
                {LdA, clrA, sftA}= 3'b000;

                //multiplier control signals are low.
                {LdQ, clrQ, sftQ}= 3'b000;

                //multiplicand and Dff  control signals are low.
                {LdM, clrM, clrff, sftDff, done}= 5'b0000; 
                //alu and counter control signals are low.
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end
            
            check: begin
                //as this state is only responsible for decision maing so
                //no control signals are acitvated simply state transiton happens here.
                {LdA, clrA, sftA}= 3'b000; 
                {LdQ, clrQ, sftQ}= 3'b000; 
                {LdM, clrM, clrff, sftDff, done}= 5'b00_000; 
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end

            add: begin
                //{Q[0], Q[-1]}== 2'b01;
                //partial-product loads it's value.
                {LdA, clrA, sftA}= 3'b100; 
                {LdQ, clrQ, sftQ}= 3'b000; 
                {LdM, clrM, clrff, sftDff, done}= 5'b00_000;
                //alu performs addition
                {add_sub, EnableALU, LdCount, decr}= 4'b1100;
            end
            
            sub: begin
                //partial-product loads it's value.
                {LdA, clrA, sftA}= 3'b100; 
                {LdQ, clrQ, sftQ}= 3'b000; 
                {LdM, clrM, clrff, sftDff, done}= 5'b00_000;
                //alu performs subtraction.
                {add_sub, EnableALU, LdCount, decr}= 4'b0100;
            end

            shift: begin
                //partial-product shift register shifts it's value.
                {LdA, clrA, sftA}= 3'b001;
                //multiplier shift register shifts it's value.
                {LdQ, clrQ, sftQ}= 3'b001;
                //dff shifts it's value.
                {LdM, clrM, clrff, sftDff, done}= 5'b00_010;
                //counter decrements it's value.
                {add_sub, EnableALU, LdCount, decr}= 4'b0001;
            end

            
            done_state: begin
                //done state control signal.
                {LdA, clrA, sftA}= 3'b000; 
                {LdQ, clrQ, sftQ}= 3'b000; 
                {LdM, clrM, clrff, sftDff, done}= 5'b00_001; 
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end

            default: begin
                //default state with all the control signals are deactivated.
                {LdA, clrA, sftA}= 3'b000; 
                {LdQ, clrQ, sftQ}= 3'b000; 
                {LdM, clrM, clrff, sftDff, done}= 5'b00_000; 
                {add_sub, EnableALU, LdCount, decr}= 4'b0000;
            end
        endcase
    end
endmodule //controller_BOOTH
