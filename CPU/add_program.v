`timescale 1ns / 1ns
module Add_Program(
    prgCntSrc
    clear,
    prgCnt,
    prgOut,
    offset
);

input prgCntSrc;
input [7:0] offset,prgCnt;
output reg [7:0] prgOut;

	always @(prgCntSrc, prgCnt, offset)
		if (prgCntSrc == 0)
			prgOut<= prgCnt+ 1;
		else
			prgOut <= prgCnt + 1 + offset;	  
	end






endmodule