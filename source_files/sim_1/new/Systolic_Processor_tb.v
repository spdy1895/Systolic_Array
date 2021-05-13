`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 01.02.2021 14:20:49
// Design Name: testbench for Systolic Processor
// Module Name: Systolic_Processor_tb
// Project Name: Systolic Array
// Target Devices: ZYBO
// Tool Versions: 2020.2
// Description: a self checking testbench for Systolic Array
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Systolic_Processor_tb(

    );
    wire [15:0] result;
    wire [15:0] next_row_operand;
    wire delayed_done;

    reg [15:0] operand1;
    reg [15:0] operand2;
    reg [15:0] previous_StageOperand;

    reg start;
    reg reset;
    reg clear;
    reg clk;

    //-> register for BFLOAT16 values
    //reg [15:0] bfloat16;

    //-> mcd for file.
    //integer mcd;

    // instantiation of Systolic Processor
    Systolic_Processor DUT(
        .result(result),
        .next_row_operand(next_row_operand),
        .delayed_done(delayed_done),


        .operand1(operand1),
        .operand2(operand2),
        .previous_StageOperand(previous_StageOperand),

        .start(start),
        .reset(reset),
        .clear(clear),
        .clk(clk)
    );

    // clock generation
    initial begin
        clk= 1'b0;
        forever clk= #5 ~clk;
    end

    initial begin


        //=============================================================================================
        //=============================================================================================
        //////////////////////////////////////////////////////////////////////////////////////////////
        /////////       
        /////////       fist checking all possibility of both operand negative case.
        /////////
        /////////       for this case last stage operand is set to:
        /////////       
        /////////       16'b1_1000_0011_1111_000
        /////////
        /////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        //============================================================================================
        //=============================================================================================
        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------
        /////////////////////////////////////////////////////
        //  1. last operand 0
        //
        /////////////////////////////////////////////////////

        //@ **************************************************************************************
        //-> both the operands to the accumulator unit are negative.
        //-> firstly assuming the previoius Stage Operand to 0.


        operand1= 16'b1_1000_0110_110_0111;     // c367= -1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 1_1000_0001_0001_100. 
        // after rounding the decimal and updating the exponent c10c.
        previous_StageOperand= 16'd0;           // assuming first stage processing elements.

        // this should pass the result of the processing element directly to output.
        
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ **************************************************************************************

        //////////////////////////////////////
        //  1.1. last operand !=0
        //  
        //  last Exponent > current Exponent
        //      
        //  difference less than 7
        //      
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b1_1000_0110_110_0111;     // c367= -1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 1_1000_0001_0001_100.

        previous_StageOperand= 16'b1_1000_0011_1111_000;    // c178= -1.09375x2^3

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  1.2. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference less than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5
        operand2= 16'b1_1000_0110_110_0111;     // c367= -1.8046875x2^7

        // this results in 16'b1_1000_0001_0001_100.

        previous_StageOperand= 16'b1_1000_0000_1111_000;    // c178= -1.09375x2^1

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  1.3. last operand !=0
        //  
        //  last Exponent > current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5
        operand2= 16'b1_1000_0110_110_0111;     // c367= -1.8046875x2^7

        // this results in 16'b1_1000_0001_0001_100.

        previous_StageOperand= 16'b1_1000_1111_1111_000;    // c178= -1.09375x2^16

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;


        //@ *************************************************************************************
        //////////////////////////////////////
        //  1.4. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5
        operand2= 16'b1_1000_0110_110_0111;     // c367= -1.8046875x2^7

        // this results in 16'b1_1000_0001_0001_100.

        previous_StageOperand= 16'b1_0111_0100_1111_000;    // c178= -1.09375x2^-11

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;






//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================


        //=============================================================================================
        //=============================================================================================
        //////////////////////////////////////////////////////////////////////////////////////////////
        /////////       
        /////////       checking all possibility of both operand positive case.
        /////////
        /////////       for this case last stage operand is set to:
        /////////       
        /////////       16'b0_1000_0011_1111_000 (1.1111_000x2^1000_0011)
        /////////
        /////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        //============================================================================================
        //=============================================================================================

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------
        /////////////////////////////////////////////////////
        //  2. last operand 0
        //
        /////////////////////////////////////////////////////

        //@ **************************************************************************************
        //-> both the operands to the accumulator unit are negative.
        //-> firstly assuming the previoius Stage Operand to 0.


        operand1= 16'b0_1000_0110_110_0111;     // 4367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 410c.
        previous_StageOperand= 16'd0;           // assuming first stage processing elements.

        // this should pass the result of the processing element directly to output.

        
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ **************************************************************************************

        //////////////////////////////////////
        //  2.1. last operand !=0
        //  
        //  last Exponent > current Exponent
        //      
        //  difference less than 7
        //      
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_1000_0011_1111_000;    // c178= +1.09375x2^4

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  2.2. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference less than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_0111_1101_1111_000;    // c178= +1.09375x2^(-2)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  2.3. last operand !=0
        //  
        //  last Exponent > current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_1000_1101_1111_000;    // c178= +1.09375x2^14

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;
        
        //@ *************************************************************************************
        //////////////////////////////////////
        //  2.4. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_0111_1000_111_1000;    // 3c78= +1.09375x2^(-7)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;











//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================

//=============================================================================================
        //=============================================================================================
        //////////////////////////////////////////////////////////////////////////////////////////////
        /////////       
        /////////       checking all the possibility of operand types positive-negative case: 01.
        /////////
        /////////       for this case last stage operand is set to:
        /////////       
        /////////       16'b0_1000_0011_1111_000 (1.1111_000x2^1000_0011)
        /////////
        /////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        //============================================================================================
        //=============================================================================================

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------
        /////////////////////////////////////////////////////
        //  3. last operand 0
        //
        /////////////////////////////////////////////////////

        //@ **************************************************************************************
        //-> operands to the accumulator unit are positive and negative.
        //-> firstly assuming the previoius Stage Operand to 0.


        operand1= 16'b0_1000_0110_110_0111;     // 4367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 410c.
        previous_StageOperand= 16'd0;           // assuming first stage processing elements.

        // this should pass the result of the processing element directly to output.

        
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ **************************************************************************************

        //////////////////////////////////////
        //  3.1. last operand !=0
        //  
        //  last Exponent > current Exponent
        //      
        //  difference less than 7
        //      
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b1_1000_0011_1111_000;    // c178= -1.09375x2^4

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  3.2. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference less than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b1_0111_1010_001_1011;     // 3d1b= -1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_0111_1101_1111_000;    // c178= +1.09375x2^(-2)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  3.3. last operand !=0
        //  
        //  last Exponent > current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b1_0111_1010_001_1011;     // 3d1b= -1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_1000_1101_1111_000;    // c178= +1.09375x2^14

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;
        
        //@ *************************************************************************************
        //////////////////////////////////////
        //  3.4. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b1_0111_1010_001_1011;     // 3d1b= -1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 1_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b0_0111_0000_111_1000;    // 3c78= +1.09375x2^(-15)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;





//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================
//=====================================================================================================================

//=============================================================================================
        //=============================================================================================
        //////////////////////////////////////////////////////////////////////////////////////////////
        /////////       
        /////////       checking all the possibility of operand types negative-positive case: 10.
        /////////
        /////////       for this case last stage operand is set to:
        /////////       
        /////////       16'b0_1000_0011_1111_000 (1.1111_000x2^1000_0011)
        /////////
        /////////
        //////////////////////////////////////////////////////////////////////////////////////////////
        //============================================================================================
        //=============================================================================================

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------
        /////////////////////////////////////////////////////
        //  4. last operand 0
        //
        /////////////////////////////////////////////////////

        //@ **************************************************************************************
        //-> operands to the accumulator unit are positive and negative.
        //-> firstly assuming the previoius Stage Operand to 0.


        operand1= 16'b0_1000_0110_110_0111;     // 4367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 410c.
        previous_StageOperand= 16'd0;           // assuming first stage processing elements.

        // this should pass the result of the processing element directly to output.

        
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ **************************************************************************************

        //////////////////////////////////////
        //  4.1. last operand !=0
        //  
        //  last Exponent > current Exponent
        //      
        //  difference less than 7
        //      
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b1_1000_0011_1111_000;    // c178= -1.09375x2^4

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ **************************************************************************************

        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  4.2. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference less than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b1_0111_1101_1111_000;    // c178= -1.09375x2^(-2)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;

        //@ *************************************************************************************
        //////////////////////////////////////
        //  4.3. last operand !=0
        //  
        //  last Exponent > current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b1_1000_1101_1111_000;    // c178= -1.09375x2^14

        //=    last stage operand exponent > current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************
        
        #2000;
        
        //@ *************************************************************************************
        //////////////////////////////////////
        //  4.4. last operand !=0
        //  
        //  last Exponent < current Exponent
        //
        //  difference greater than 7
        //
        //////////////////////////////////////

        //---------------------------------------------------------------------------------------
        
        //= clear block to clear all the registers and reset the controllers.

        #50 reset= 1'b1;        // reset the controller state
        #10 reset= 1'b0;
        #50 clear= 1'b1;        // clear pulse to clear the various registers
        #10 clear= 1'b0;
        #50;

        //---------------------------------------------------------------------------------------

        operand1= 16'b0_1000_0110_110_0111;     // c367= +1.8046875x2^7
        operand2= 16'b0_0111_1010_001_1011;     // 3d1b= +1.2109375x2^-5

        // this results in 16'b 0_1000_0010_0001_100. 
        // after rounding the decimal and updating the exponent 
        // product of operands is 0_1000_0010_000_1100 (410c).

        previous_StageOperand= 16'b1_0111_0000_111_1000;    // 3c78= -1.09375x2^(-15)

        //=    last stage operand exponent < current stage operand exponent.  

        //-> BOOTH multiplier results in 0000_1010_1101_1101
        //-> since the MUL_result[6]=1 and also subsequent bit are 1 so
        //-> it will be up-rounded so we'll get 001_0110 significand 7 bits.
        #50 start= 1'b1;
        #10 start= 1'b0;        // start pulse to start the computation

        //@ *************************************************************************************

        #2000;





        #1000 $finish;
    end
endmodule
