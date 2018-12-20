`timescale 1ns / 1ns
/** @module : ALU
 *  @author : Albert Bitdiddle
 *  ALU Module Testbed 
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */
 
module tb_ALU (); 
 
reg    clock; 
reg [3:0]   ALU_Control; 
reg [31:0]  operand_A;
reg [31:0]  operand_B;
wire zero; 
wire [31:0] ALU_result;

 
ALU DUT (
		.ALU_Control(ALU_Control), 
		.operand_A(operand_A), .operand_B(operand_B), 
		.ALU_result(ALU_result), .zero(zero)
); 

// Clock generator
always #1 clock = ~clock;

initial begin
  clock = 0;
  $display (" --- Start --- ");
  repeat (1) @ (posedge clock);
  
  operand_A   <= 32'h0000_0000_0000_0007;
  operand_B   <= 32'h0000_0000_0000_000B;
  ALU_Control <= 4'b0000;  
  repeat (1) @ (posedge clock);
  
  operand_A   <= 32'h0000_0000_0000_0002;
  operand_B   <= 32'h0000_0000_0000_0004;
  ALU_Control <= 4'b0001;  
  repeat (1) @ (posedge clock);
  
  operand_A   <= 32'h0000_0000_0000_000A;
  operand_B   <= 32'h0000_0000_0000_0004;
  ALU_Control <= 4'b0110;  
  repeat (1) @ (posedge clock);
  
  operand_A   <= 32'h0000_0000_0000_0002;
  operand_B   <= 32'h0000_0000_0000_0004;
  ALU_Control <= 4'b0111;  
  repeat (1) @ (posedge clock);
  
  operand_A   <= 32'h0000_0000_0000_0002;
  operand_B   <= 32'h0000_0000_0000_0004;
  ALU_Control <= 4'b1100;  
  repeat (1) @ (posedge clock);
end
  
  
always @ (posedge clock) begin 
    	$display ("ALU_Control [%b], operand_A [%d] operand_B [%d]", ALU_Control, operand_A, operand_B); 
    	$display ("ALU_result [%d] zero  [%b]",ALU_result,zero); 
end
     
endmodule
