`timescale 1ns / 1ns
module Two_To_One(
    select,
    out,
    in_1,
    in_2
);

input select;
input [31:0] in_1, in_2;
output reg [31:0] out;

always @(select, in_2, in_1)
	if (sel == 0)
		out <= in_1;
	else
		out <= in_2;




endmodule