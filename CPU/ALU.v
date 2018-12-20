`timescale 1ns / 1ns
/** @module : ALU
 *  @author : Albert Bitdiddle
 *  ALU Module Template 
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */
 
module ALU (
		ALU_Control, 
		operand_A, operand_B, 
		ALU_result, zero
); 
input [5:0]   ALU_Control; 
input [31:0]  operand_A ;
input [31:0]  operand_B ;
output zero; 
output reg [31:0] ALU_result;

//--------------Add your code here ------------------ 

// TODO: right now, ALU only ANDs the two operands. You have to implement the rest of the instructions.
assign zero = (ALU_result==0);
always @(ALU_Control,operand_A,operand_B)
case(ALU_Control)
0: ALU_result <= operand_A & operand_B;
1: ALU_result <= operand_A | operand_B;
2: ALU_result <= operand_A + operand_B;
6: ALU_result <= operand_A - operand_B;
7: ALU_result <= (operand_A < operand_B) ? 1:0;
12: ALU_result <= ~(operand_A|operand_B);
default: ALU_result = 0;
endcase


//----------------------------------------------------

endmodule
