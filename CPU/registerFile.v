`timescale 1ns / 1ns
/** @module : registerFile
 *  @author : Albert Bitdiddle
 *  Register File Template
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */

// Parameterized register file
module registerFile (
				clock, reset, 
                read_sel1, read_sel2,
				write, write_sel, write_data, 
				read_data1, read_data2
);

input clock, reset; 
input [4:0] read_sel1, read_sel2; 
input write; 
input [31:0] write_data;
input [4:0] write_sel;
output[31:0] read_data1; 
output[31:0] read_data2; 
reg [31:0] Registers [0:31];
//--------------Add your code here ------------------ 
assign read_data1 = Registers[read_sel1];
assign read_data2 = Registers[read_sel2];

integer i;
	
	initial
	begin	
	    for(i = 0; i < 32; i = i+1)
		begin
	        reg_file[i] = 0;
		end
	end


always @(posedge clock)
	begin
		if(write == 1)
			Registers[write_sel]= write_data;
	end

		



//----------------------------------------------------
endmodule
