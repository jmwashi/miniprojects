`timescale 1ns / 1ns
module Control_Unit(
    instruction,
    ALU_Control,
    ALU_Src,
    branch,
    Mem_to_Reg,
    MemRead;
    MemWrite;
    read_sel_a,
    read_sel_b,
    write_sel,
    write,
    ALUOp
);

    // TODO This is an unfinished control unit. It serves just to get you going with phase I, so you will need to change it
    // as you go along.

    input [31:0] instruction;
    output [4:0] read_sel_a, read_sel_b, write_sel;
    output write;
    output  reg     Mem_to_Reg;,
    output  reg     MemRead,
    output  reg     MemWrite,
    output  reg     ALU_Src,
    output reg [5:0] ALUOp;
    output reg branch;

    wire  [5:0] ALU_Control;
    assign ALU_Control = instruction[5:0];
    assign read_sel_a  = instruction[20:16];
    assign read_sel_b  = instruction[15:11];
    assign write_sel   = instruction[25:21];
    assign write       = 1'b1;
    localparam DEFAULT   = 6'b111111;
    localparam ADD       = 6'b000010;
    localparam SUB       = 6'b000110;
    localparam AND       = 6'b000000;
    localparam OR        = 6'b000001;
    localparam XOR       = 6'b001100;
    localparam SLT       = 6'b000111;
    localparam LW        = 6'b100011;
    localparam SW        = 6'b101011;
    localparam ADDI      = 6'b001000;

always @(*) begin
        case (ALU_Control)
            LW: begin
                RegDst      = 1'b0;
                ALU_Src      = 1'b1;
                Mem_to_Reg  = 1'b1;
                write    = 1'b1;
                MemRead     = 1'b1;
                MemWrite    = 1'b0;
                branch = 1'b0;
                ALUOp       = ADD;
            end
            SW: begin
                RegDst      = 1'bx;
                ALU_Src      = 1'b1;
                Mem_to_Reg    = 1'bx;
                write    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b1;
                branch = 1'b0;
                ALUOp       = ADD;
            end
            SLT: begin
                 RegDst      = 1'bx;
                ALU_Src      = 1'b1;
                Mem_to_Reg    = 1'bx;
                write    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b1;
                branch = 1'b1;
                ALUOp       = SLT;
            end
            default: begin
                RegDst      = 1'b0;
                ALU_Src      = 1'b1;
                Mem_to_Reg  = 1'b0;
                write    = 1'b1;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                branch = 1'b0
                ALUOp = ALU_Control;
            end
        endcase
    end





endmodule

