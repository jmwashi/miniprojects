`timescale 1ns / 1ns
module Program_Counter(
    clock,
    clear,
    prgCnt,
    newPrgCnt
);

input [7:0] prgCng;
//input clk,clear,enable;
input clock,clear;
output reg [7:0] newPrgCnt;
always@(posedge clock)
	if(enable)
		begin
		if(clear)
			newPrgCnt<=0;
		else
			newPrgCnt<=prgCnt + 4;
end



endmodule