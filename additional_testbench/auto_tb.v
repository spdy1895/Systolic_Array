`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2020 18:46:50
// Design Name: 
// Module Name: auto_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define N_TESTS 10000

module auto_tb();

    
	reg clk = 0;
	reg [15:0] a_operand;
	reg [15:0] b_operand;
	
	wire Exception,Overflow,Underflow;
	wire [15:0] result;

	reg [15:0] Expected_result;

	reg [95:0] testVector [`N_TESTS-1:0];

	reg test_stop_enable;

	integer mcd;
	integer test_n = 0;
	integer pass   = 0;
	integer error  = 0;

	BF16mul DUT(a_operand,b_operand,Exception,Overflow,Underflow,result);

	always #5 clk = ~clk;

	initial  
	begin 
		$readmemh("/home/ankita/Documents/v_files/Bfloat16/BF16mul/FP16.srcs/sim_1/new/TestVectorMultiply", testVector);
		mcd = $fopen("Results_Ver2.txt","w");
	end 

	always @(posedge clk) 
	begin
			{a_operand,b_operand,Expected_result} = testVector[test_n];
			test_n = test_n + 1'b1;

			#2;
			if (result == Expected_result)
				begin
					$fdisplay (mcd,"TestPassed Test Number -> %d",test_n);
					pass = pass + 1'b1;
				end

			if (result != Expected_result)
				begin
					$fdisplay (mcd,"Test Failed Expected Result = %h, Obtained result = %h, Test Number -> %d",Expected_result,result,test_n);
					error = error + 1'b1;
				end
			
			if (test_n >= `N_TESTS) 
			begin
				$fdisplay(mcd,"Completed %d tests, %d passes and %d fails.", test_n, pass, error);
				test_stop_enable = 1'b1;
			end
	end

always @(posedge clk)
begin
if(test_stop_enable == 1'b1)
    begin
        $fclose(mcd);
        $finish;
    end
    
end
endmodule
