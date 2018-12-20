`timescale 1ns / 1ns
/** @module : registerFile
 *  @author : Albert Bitdiddle
 *  Register File Testbed 
 *  Adaptive and Secure Computing Systems (ASCS) Laboratory
 */


module tb_registerFile (); 

reg clock, reset; 
reg [4:0] read_sel1, read_sel2, write_sel; 
reg write; 
reg [31:0] write_data; 
wire read_data1, read_data2; 

registerFile DUT (
        .clock(clock), .reset(reset), 
        .read_sel1(read_sel1), .read_sel2(read_sel2),
        .write(write), .write_sel(write_sel), .write_data(write_data), 
        .read_data1(read_data1), .read_data2(read_data2)
);     

// Clock generator
always #1 clock = ~clock;

initial begin
  clock = 0;
  reset = 1;
  write = 0;
  #10 reset = 0; 
  $display (" --- Start --- ");
  repeat (1) @ (posedge clock);
  
  write_data <= 32'h0000_0000_0000_0002;
  write_sel  <= 5'b00001;  
  write      <= 1'b1;
  repeat (1) @ (posedge clock);
  
  write_data <= 32'h0000_0000_0000_0005;
  write_sel  <= 5'b00011;  
  write      <= 1'b1;
  repeat (1) @ (posedge clock);
  
  write_data <= 32'h0000_0000_0000_0009;
  write_sel  <= 5'b00111;  
  write      <= 1'b1;
  repeat (1) @ (posedge clock);
  
  write_data <= 32'h0000_0000_0000_0007;
  write_sel  <= 5'b00000;  
  write      <= 1'b1;
  repeat (1) @ (posedge clock);
  
  write_data <= 32'h0000_0000_0000_000A;
  write_sel  <= 5'b00101;  
  write      <= 1'b1;
  read1_sel  <= 5'b00101; 
  repeat (1) @ (posedge clock);

  write_data <= 32'h0000_0000_0000_000A;
  write_sel  <= 5'b00101;  
  write      <= 1'b0;
  read1_sel  <= 5'b00101; 
  repeat (1) @ (posedge clock);
 
  write_data <= 32'h0000_0000_0000_000A;
  write_sel  <= 5'b00101;  
  write      <= 1'b0;
  read1_sel  <= 5'b00101; 
  read2_sel  <= 5'b00101; 
  repeat (1) @ (posedge clock);
 
  read1_sel  <= 5'b00111; 
  read2_sel  <= 5'b00111; 
  repeat (1) @ (posedge clock);
  
  read1_sel  <= 5'b00011; 
  read2_sel  <= 5'b00001; 
  repeat (1) @ (posedge clock);
 
  read1_sel  <= 5'b00000; 
  read2_sel  <= 5'b00001; 
  repeat (1) @ (posedge clock);          
end
  
  
always @ (posedge clock) begin 
    	$display ("Read1 Sel [%d], Read1 Data [%h]",read_sel1, read_data1); 
    	$display ("Read2 Sel [%d], Read2 Data [%h]",read_sel2, read_data2); 
end

endmodule
