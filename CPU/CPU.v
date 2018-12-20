`timescale 1ns / 1ns
/** @module : CPU
 *  @author : Albert Bitdiddle
 *  CPU Module Template 
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */

module CPU (
  clock, 
  reset, 
  start,
  program_counter
); 

    input clock, reset, start; 
    input [31:0]  program_counter; 
     
    wire [31:0] ALU_operand_A, ALU_operand_B, ALU_result;
    wire ALU_zero;
    wire ALU_Src;
    wire branch;
    // TODO: the instruction is currently a register, so we can control it from the testbench.
    // Later, we will want to turn it into a wire and drive it from instruction memory.
    wire [31:0] instruction;
    wire [31:0] instruction_signextended;
    wire MemRead;
    wire MemWrite;
    wire Mem_to_Reg;
    // Control signals from the control unit.
    wire [5:0] ALU_Control;
    wire [4:0] regfile_read_sel1, regfile_read_sel2, regfile_write_sel;
    wire regfile_write;
    wire [7:0] prgAddress;
    // TODO Instructions: We have connected the phase I modules - the ALU, register file, but not memory. 
    // For phase I, you shouldn't touch this file. You first need to:
    //    1) Complete refisterFile.v and test it 
    //    2) Complete ALU.v and test it
    //    3) Test both ALU and register file together, for which we have provided some simple benchmarks in tb_CPU.v
    //    4) Complete memory.v and test it
    //    5) Connect memory.v here and test all 3 modules together
    //
    // In phase II, you will have to add the rest of the modules.

    //Memory instruction_Memory (
            //// Add code 
    //); Added at bottom

    Control_Unit control (
        .instruction(instruction      ),
        .ALU_Src(ALU_Src),
        .read_sel_a (regfile_read_sel1),
        .read_sel_b (regfile_read_sel2),
        .write_sel  (regfile_write_sel),
        .write      (regfile_write    ),
        .ALUOp      (ALU_Control),
        .branch     (branch),
        //.Mem_to_Reg  (),
        .MemRead     (MemRead),
        .MemWrite    (MemWrite)
    );
    signExtend signExtended (.inNum(instruction[15:0]),
                                   .outNum(instruction_signextended));

    Instruction_Memory instruction_mem(
    .address(prgAddress),
    .instruction(instruction)
    );
    Program_Counter program_count(
        clock(clock),
        clear(0),
        prgCnt(prgAddress),
        newPrgCnt(prgAddress)
    );


    registerFile registers (
        .clock     (clock            ),
        .reset     (reset            ),
        .read_sel1 (regfile_read_sel1),
        .read_sel2 (regfile_read_sel2),
        .write     (regfile_write    ),
        .write_data(ALU_result       ),
        .write_sel (regfile_write_sel),
        .read_data1(ALU_operand_A    ),
        .read_data2(ALU_operand_B    )
    ); 

    ALU ALU_unit(
        .ALU_Control(ALU_Control  ),
        .operand_A  (ALU_operand_A),
        .operand_B  (ALU_operand_B),
        .zero       (ALU_zero     ),
        .ALU_result (ALU_result   )
    ); 
      
    Memory data_Memory (
            .clock(clock),
            .Address(ALU_result),
            .MemRead(MemRead),
            .ReadData(ALU_Result),
            .MemWrite(MemWrite),
            .writeData(ALU_operand_B)
    );






		
endmodule
