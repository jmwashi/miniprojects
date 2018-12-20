`timescale 1ns / 1ns
module signExtend(inNum,outNum);


	input [15:0] inNum;
	output [31:0] outNum;
	assign outNum[15:0] = in[15:0];
	assign outNum[31:16] = in[15];

	endmodule 