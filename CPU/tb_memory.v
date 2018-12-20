`timescale 1ns / 1ns
/** @module : Memory Module
 *  @author : Albert Bitdiddle
 *  Simple Memory Design Testbed 
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */
 

module tb_Memory (); 

reg    clock; 
reg    MemRead, MemWrite; 
reg    [7:0]  Address;
reg    [31:0] WriteData;
wire   [31:0] ReadData;

Memory DUT (
		.clock(clock),
    	.Address(Address),
   		.MemRead(MemRead), .ReadData(ReadData),
    	.MemWrite(MemWrite), .writeData(writeData)
); 

// Clock generator
always #1 clock = ~clock;

initial begin
  clock = 0;
  MemWrite = 0;
  MemRead  = 0;
  $display (" --- Start --- ");
  repeat (1) @ (posedge clock);
  
  WriteData  <= 32'h0000_0000_0000_0002;
  Address    <= 8'b00000100;  
  MemWrite   <= 1'b1;
  repeat (1) @ (posedge clock);
  
  MemWriteData <= 32'h0000_0000_0000_0005;
  Address      <= 8'b00001000;  
  MemWrite     <= 1'b1;
  repeat (1) @ (posedge clock);
  
  MemWriteData <= 32'h0000_0000_0000_0009;
  Address      <= 8'b00001100;  
  MemWrite     <= 1'b1;
  repeat (1) @ (posedge clock);
  
  MemWriteData <= 32'h0000_0000_0000_0007;
  Address      <= 8'b00011000;  
  MemWrite     <= 1'b1;
  repeat (1) @ (posedge clock);
  
  MemWriteData <= 32'h0000_0000_0000_000A;
  Address      <= 8'b00011100;  
  MemWrite     <= 1'b1;
  repeat (1) @ (posedge clock);

  Address      <= 8'b00011000;  
  MemWrite     <= 1'b0;
  MemRead      <= 1'b1;
  repeat (1) @ (posedge clock);
 
  Address      <= 8'b00000100;  
  MemRead      <= 1'b1;
  repeat (1) @ (posedge clock);
 
  Address      <= 8'b00011100;  
  MemRead      <= 1'b1;
  repeat (1) @ (posedge clock);
  
  Address      <= 8'b00001000;  
  MemRead      <= 1'b1;
  repeat (1) @ (posedge clock);
 
  Address      <= 8'b00001100;  
  MemRead      <= 1'b1;
  repeat (1) @ (posedge clock);          
end
  
  
always @ (posedge clock) begin 
    	$display ("MemWrite [%b], Address [%h] WriteData [%h]",MemWrite, Address, WriteData); 
    	$display ("MemRead  [%b], Address [%h] ReadData  [%h]",MemRead,  Address, ReadData); 
end
     
endmodule
