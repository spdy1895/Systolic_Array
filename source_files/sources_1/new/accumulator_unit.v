`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: open-source
// Engineer: Shubham Pandey
// 
// Create Date: 12.02.2021 13:09:12
// Design Name: behavioral approach
// Module Name: accumulator_unit
// Project Name: Systolic Array
// Target Devices: nexys ddr4
// Tool Versions: 2020.2
// Description: accumulator for storing the final addition of elements.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module accumulator_unit(
    output reg [15:0] processingElementResult,
    
    input wire [8:0] result_reg_pipo,           // current operands sign and exponent before normalization.
    input wire [8:0] addition_unit_result,      // current operands mantissa before normalization.
    input wire [15:0] previousOperand,
    input wire clr,
    input wire clk
    );


    // register to store temporary result.
    // reg [15:0] processingElementResult;
    reg [8:0] tempaddrslt;

    

    // new normalized current operand.
    reg [7:0] CNormMantissa;       // this is of the format 1.1100_111- 8-bits.
    reg [7:0] CNormExponent;

    // registers to store the last operands mantissa and exponent bits.
    reg [7:0] LNormMantissa;        // this if of the format 1.0011_111- 7-bits
    reg [7:0] LNormExponent;
    
    //-----------------------------------------------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------------------------------
    //- clear block to clear all register.
    always @(negedge clk) begin

        if (clr==1'b1) begin
            // clearing the mantissa and exponents bits of current operands.
            CNormMantissa<= 0;
            CNormExponent<= 0;

            // clearing the mantissa and exponents bits of last operands.
            LNormExponent<= 0;
            LNormMantissa<= 0;

            // clearing the temporary addition result register.
            tempaddrslt<= 0;

            // clearing the output -processing Element result register.
            processingElementResult<= 0;
        end
    end
    //-----------------------------------------------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------------------------------
    //-----------------------------------------------------------------------------------------------------------------



//---------------------------------------------------------------------------------------------------------------------->
//---------------------------------------------------------------------------------------------------------------------->
//---------------------------------------------------------------------------------------------------------------------->

    always @(negedge clk) begin


        //========================================================================================================================
        // first of all store all the values into temporary registers for further operations.

        //@ storing operands into the register, mantissa and exponent separate.
        LNormMantissa= {1'b1, previousOperand[6:0]};
        LNormExponent= previousOperand[14:7];
        //========================================================================================================================
        
        //@ **********************************************************************************************************************

        // first normalizing the obtained result fron the addition unit i.e. as the result obtained
        // will be of 9 bits so i have to extract 7 bits out of it. If MSB is 1 then extract the
        // first 7 bits of MSB and if MSB is 0 then extract the last 7 MSB bits of the addition unit 
        // result.

        CNormMantissa= (addition_unit_result[8]==1) ? addition_unit_result[8:1] : addition_unit_result[7:0];
        CNormExponent= (addition_unit_result[8]==1) ? result_reg_pipo[7:0]+8'd1 : result_reg_pipo[7:0];

        //@ **********************************************************************************************************************
        
        //->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //@ if previous operand is 0= 0_0000_0000_0000_000 then simply pass the current operand at the accumulator output.
        //@ {sign, exponent, mantissa};
        if ((|previousOperand)==0) begin
            processingElementResult<= {result_reg_pipo[8], CNormExponent, CNormMantissa[6:0]};
        end
        //->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        else begin

            case({previousOperand[15], result_reg_pipo[8]})

                2'b00: begin

                    $display("case 00 got executed!");

                //-> condition (Last Operand Exponent >= Current Operand Exponent) and the difference is less than equal to 7.
                    if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)<= 3'd7)) begin       // first check if the difference is less than equal to 7;
                        CNormMantissa= (CNormMantissa>> (LNormExponent-CNormExponent));                     // shift the mantissa bits accordingly.
                        CNormExponent= (CNormExponent+ (LNormExponent-CNormExponent));                      // and also update the exponent.
                        
                        // you have made the exponent bits same ,now you can add mantissa.
                        tempaddrslt= CNormMantissa+ LNormMantissa;

                        // updating the final result of accumulator unit.
                        processingElementResult= (tempaddrslt[8]==1'b1) ? {1'b0, (CNormExponent+ 1'b1), tempaddrslt[7:1]} : {1'b0, CNormExponent, tempaddrslt[6:0]};
                        
                        end
                    
                    //-> condition (Last Operand Exponent < Current Operand Exponent) and the difference is less than equal to 7
                    else if((LNormExponent< CNormExponent) && ((CNormExponent-LNormExponent)<= 3'd7)) begin          // first check if the difference is less than equal to 7;
                        LNormMantissa= (LNormMantissa >> (CNormExponent-LNormExponent));                             // shift the mantissa bits accordingly.
                        LNormExponent= (LNormExponent+ (CNormExponent-LNormExponent));                               // and also update the exponet.
                        
                        // you have made the exponent bits same ,now you can add mantissa.
                        tempaddrslt= CNormMantissa+ LNormMantissa;

                        // updating the final result of accumulator unit.
                        processingElementResult= (tempaddrslt[8]==1'b1) ? {1'b0, (LNormExponent+ 1'b1), tempaddrslt[7:1]} : {1'b0, LNormExponent, tempaddrslt[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)> 3'd7)) begin

                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b0, LNormExponent, LNormMantissa[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent< CNormExponent && ((CNormExponent- LNormExponent)> 3'd7)) begin
                        
                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b0, CNormExponent, CNormMantissa[6:0]};
                    end

                    //-> default case if any problem then simply pass the Current Operand.
                    else begin
                        processingElementResult= {1'b0, CNormExponent, CNormMantissa[6:0]};
                    end

                end

                2'b11: begin

                    $display("case 11 got executed!");
                    
                    //-> condition (Last Operand Exponent >= Current Operand Exponent) and the difference is less than equal to 7.
                    if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)<= 3'd7)) begin       // first check if the difference is less than equal to 7;
                        CNormMantissa= (CNormMantissa>> (LNormExponent-CNormExponent));                     // shift the mantissa bits accordingly.
                        CNormExponent= (CNormExponent+ (LNormExponent-CNormExponent));                      // and also update the exponent.
                        
                        // you have made the exponent bits same ,now you can add mantissa.
                        tempaddrslt= CNormMantissa+ LNormMantissa;

                        // updating the final result of accumulator unit.
                        processingElementResult= (tempaddrslt[8]==1'b1) ? {1'b1, (CNormExponent+ 1'b1), tempaddrslt[7:1]} : {1'b1, CNormExponent, tempaddrslt[6:0]};
                        
                        end
                    
                    //-> condition (Last Operand Exponent < Current Operand Exponent) and the difference is less than equal to 7
                    else if((LNormExponent< CNormExponent) && ((CNormExponent-LNormExponent)<= 3'd7)) begin          // first check if the difference is less than equal to 7;
                        LNormMantissa= (LNormMantissa >> (CNormExponent-LNormExponent));                             // shift the mantissa bits accordingly.
                        LNormExponent= (LNormExponent+ (CNormExponent-LNormExponent));                               // and also update the exponet.
                        
                        // you have made the exponent bits same ,now you can add mantissa.
                        tempaddrslt= CNormMantissa+ LNormMantissa;

                        // updating the final result of accumulator unit.
                        processingElementResult= (tempaddrslt[8]==1'b1) ? {1'b1, (LNormExponent+ 1'b1), tempaddrslt[7:1]} : {1'b1, LNormExponent, tempaddrslt[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)> 3'd7)) begin

                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b1, LNormExponent, LNormMantissa[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent< CNormExponent && ((CNormExponent- LNormExponent)> 3'd7)) begin
                        
                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b1, CNormExponent, CNormMantissa[6:0]};
                    end

                    //-> default case if any problem then simply pass the Current Operand.
                    else begin
                        processingElementResult= {1'b1, CNormExponent, CNormMantissa[6:0]};
                    end

                end

                2'b01: begin

                    $display("case 01 got executed!");

                    //->  condition (last operand exponent >= current operand exponent) and the difference is less than equal to 7.
                    if ((LNormExponent>=CNormExponent) && ((LNormExponent-CNormExponent)<= 3'd7)) begin     // first check if the difference is less than equal to 7;
                        CNormMantissa= (CNormMantissa>> (LNormExponent-CNormExponent));                     // shift the mantissa bits accordingly.
                        CNormExponent= (CNormExponent+ (LNormExponent-CNormExponent));                      // and also update the exponent.
                        
                        // you have made the exponent bits same ,now you can get the difference of mantissa.
                        tempaddrslt= LNormMantissa- CNormMantissa;

                        // updating the final result of accumulator unit.
                        // since it was difference the normalization is different i.e. simply
                        // shift your decimal to 1.mantissa format and accordingly update the 
                        // exponent.
                        // also tempaddrslt is of 9 bits but the difference will not overflow ever since it is difference.

                        //@ using function to produce BFLOAT16 format.
                        processingElementResult= (|tempaddrslt== 1'b0) ? 16'd0 : {1'b0, (BFLOAT16formatter(tempaddrslt, LNormExponent))};
                    end


                    //-> condition (Last Operand Exponent < Current Operand Exponent) and the difference is less than equal to 7
                    else if((LNormExponent< CNormExponent) && ((CNormExponent-LNormExponent)<= 3'd7)) begin          // first check if the difference is less than equal to 7;
                        LNormMantissa= (LNormMantissa >> (CNormExponent-LNormExponent));                             // shift the mantissa bits accordingly.
                        LNormExponent= (LNormExponent+ (CNormExponent-LNormExponent));                               // and also update the exponet.
                        
                        // you have made the exponent bits same ,now you can get the difference of mantissa.
                        tempaddrslt= CNormMantissa- LNormMantissa;

                        // updating the final result of accumulator unit.
                        // since it was difference the normalization is different i.e. simply
                        // shift your decimal to 1.mantissa format and accordingly update the 
                        // exponent.
                        // also tempaddrslt is of 9 bits but the difference will not overflow ever since it is difference.

                        //@ using function to produce BFLOAT16 format.
                         processingElementResult= (|tempaddrslt== 1'b0) ? 16'd0 : {1'b1, (BFLOAT16formatter(tempaddrslt, LNormExponent))};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)> 3'd7)) begin

                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b0, LNormExponent, LNormMantissa[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent < Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent< CNormExponent && ((CNormExponent- LNormExponent)> 3'd7)) begin
                        
                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b1, CNormExponent, CNormMantissa[6:0]};
                    end

                    //-> default case if any problem then simply pass the Current Operand.
                    else begin
                        processingElementResult= {1'b1, CNormExponent, CNormMantissa[6:0]};
                    end

                end

                2'b10: begin

                    $display("case 10 got executed!");

                    //->  condition (last operand exponent >= current operand exponent) and the difference is less than equal to 7.
                    if ((LNormExponent>=CNormExponent) && ((LNormExponent-CNormExponent)<= 3'd7)) begin     // first check if the difference is less than equal to 7;
                        CNormMantissa= (CNormMantissa>> (LNormExponent-CNormExponent));                     // shift the mantissa bits accordingly.
                        CNormExponent= (CNormExponent+ (LNormExponent-CNormExponent));                      // and also update the exponent.
                        
                        // you have made the exponent bits same ,now you can get the difference of mantissa.
                        tempaddrslt= LNormMantissa- CNormMantissa;

                        // updating the final result of accumulator unit.
                        // since it was difference the normalization is different i.e. simply
                        // shift your decimal to 1.mantissa format and accordingly update the 
                        // exponent.
                        // also tempaddrslt is of 9 bits but the difference will not overflow ever since it is difference.

                        //@ using function to produce BFLOAT16 format.
                        processingElementResult= (|tempaddrslt== 1'b0) ? 16'd0 : {1'b1, (BFLOAT16formatter(tempaddrslt, LNormExponent))};
                    end


                    //-> condition (Last Operand Exponent < Current Operand Exponent) and the difference is less than equal to 7
                    else if((LNormExponent< CNormExponent) && ((CNormExponent-LNormExponent)<= 3'd7)) begin          // first check if the difference is less than equal to 7;
                        LNormMantissa= (LNormMantissa >> (CNormExponent-LNormExponent));                             // shift the mantissa bits accordingly.
                        LNormExponent= (LNormExponent+ (CNormExponent-LNormExponent));                               // and also update the exponet.
                        
                        // you have made the exponent bits same ,now you can get the difference of mantissa.
                        tempaddrslt= CNormMantissa- LNormMantissa;

                        // updating the final result of accumulator unit.
                        // since it was difference the normalization is different i.e. simply
                        // shift your decimal to 1.mantissa format and accordingly update the 
                        // exponent.
                        // also tempaddrslt is of 9 bits but the difference will not overflow ever since it is difference.

                        //@ using function to produce BFLOAT16 format.
                         processingElementResult= (|tempaddrslt== 1'b0) ? 16'd0 : {1'b0, (BFLOAT16formatter(tempaddrslt, LNormExponent))};
                    end
                    
                    //-> condition (Last Operand Exponent > Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent>=CNormExponent && ((LNormExponent-CNormExponent)> 3'd7)) begin

                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b1, LNormExponent, LNormMantissa[6:0]};
                    end
                    
                    //-> condition (Last Operand Exponent < Current Operand Exponent) but difference greater than 7.
                    else if (LNormExponent< CNormExponent && ((CNormExponent- LNormExponent)> 3'd7)) begin
                        
                        // in this case since the difference is greater than 7 then simply consider greater exponent magnitude.
                        processingElementResult= {1'b0, CNormExponent, CNormMantissa[6:0]};
                    end

                    //-> default case if any problem then simply pass the Current Operand.
                    else begin
                        processingElementResult= {1'b0, CNormExponent, CNormMantissa[6:0]};
                    end

                    


                end


                // if no case satisfy then simply get the distance of exponent from the bias and whichever is
                // larger take that value in as result.
                default : begin
                    $display("case default got executed!");
                    if ((LNormExponent+8'b1000_0001)>= (CNormExponent+8'b1000_0001)) begin
                        processingElementResult= previousOperand;
                    end
                    
                    else if ((LNormExponent+8'b1000_0001)< (CNormExponent+8'b1000_0001)) begin
                        processingElementResult= {result_reg_pipo[8], CNormExponent, CNormMantissa[6:0]};
                    end

                    else begin
                        
                        // if this also not results in suitable result then simply, send the current output in result.
                        processingElementResult= {result_reg_pipo[8], CNormExponent, CNormMantissa[6:0]};
                    end
                end

                endcase
                end
        
end

//=========================================================
//=     function to shift the bits of the mantissa
//=     and also the exponents accordingly so that 
//=     the result is represented in BFLOAT16 format.
//=========================================================

function automatic [14:0] BFLOAT16formatter(
                            input [8:0] mantissa,
                            input [7:0] exponent
                        );

        begin
        if (mantissa[7]== 1'b1) begin
            BFLOAT16formatter= {exponent, mantissa[6:0]};
        end

        else if (mantissa[6]== 1'b1) begin
            exponent= exponent- 1'b1;       // exponent-1
            BFLOAT16formatter= {exponent, mantissa[5:0], 1'b0};
        end

        else if (mantissa[5]== 1'b1) begin
            exponent= exponent-2'b10;       // exponent-2
            BFLOAT16formatter= {exponent, mantissa[4:0], 2'b00};
        end

        else if (mantissa[4]== 1'b1) begin
            exponent= exponent- 2'b11;      // exponent-3
            BFLOAT16formatter= {exponent, mantissa[3:0], 3'b000};
        end

        else if (mantissa[3]== 1'b1) begin
            exponent= exponent- 3'b100;     // exponent-4
            BFLOAT16formatter= {exponent, mantissa[2:0], 4'b0000};
        end

        else if (mantissa[2]== 1'b1) begin
            exponent= exponent- 3'b101;      // exponent-5
            BFLOAT16formatter= {exponent, mantissa[1:0], 5'b00000};
        end

        else if (mantissa[1]== 1'b1) begin
            exponent= exponent- 3'b110;     // exponent-6
            BFLOAT16formatter= {exponent, mantissa[0], 6'b000000};
        end
                                
        else if (mantissa[0]== 1'b1) begin
            exponent= exponent- 3'b111;     // exponent-7
            BFLOAT16formatter= {exponent, 7'b000_0000};
        end

        else begin
            exponent= 8'b0000_0000;
            BFLOAT16formatter= {exponent, 7'b000_0000};
        end

        end
endfunction

endmodule