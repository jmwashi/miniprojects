`timescale 1ns / 1ns
module Instruction_Memory(
    address,
    instruction
);

input [7:0] address;
output reg [31:0] instruction;

reg [31:0] memory[0:7];

initial begin
//FIX THIS TO INSTRUCTIONS FOR SPECIFIC PROJECT
memory[1] <= ’h10000011;
memory[2] <= ’h20000022; 
memory[3] <= ’h30000033; 
memory[4] <= ’h40000044; 
memory[5] <= ’h50000055;
memory[6] <= ’h60000066; 
memory[7] <= ’h70000077;
memory[8] <= ’h80000088; 
memory[9] <= ’h90000099;

end
always @(address)

begin
	instruction <= memory[address];


end



endmodule