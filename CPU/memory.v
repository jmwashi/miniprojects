`timescale 1ns / 1ns
/** @module : Memory Module
 *  @author : Albert Bitdiddle
 *  Simple Memory Design Template
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */
 
module Memory (
		clock,
    	Address,
   		MemRead, ReadData,
    	MemWrite,writeData
); 

input clock; 
input [7:0]  Address;
input MemRead;
output [31:0]  ReadData;
input MemWrite;
input [31:0]   writeData;
reg [31:0] ReadData;
localparam MEM_DEPTH = 1 << 7;
reg [31:0]     ram [0:MEM_DEPTH-1];
 
//--------------Add your code here ------------------ 
integer i;  
	initial begin
		for(i=0; i<MEM_DEPTH; i = i + 1)
			ram[i] = i*10+1;
	end
 always @(posedge clock) 
 	begin  
  		if (MemWrite)  
            ram[Address] <= writeData;  
    end
always@(ram[Address])
	ReadData <= ram[Address];

//----------------------------------------------------
endmodule
