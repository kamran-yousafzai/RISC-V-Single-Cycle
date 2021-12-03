module imem
#(
  parameter integer AWIDTH=32,
  parameter integer DWIDTH=32
 )
 (
  input  wire [AWIDTH-1:0] pc ,
  output  wire [DWIDTH-1:0] instr  
 );
  localparam addressible_bits=8;
  reg [7:0] imemory [99:0];
 
 


  assign instr[31:24] = imemory[pc+3] ;
  assign instr[23:16] = imemory[pc+2] ;
  assign instr[15:8] = imemory[pc+1] ;
  assign instr[7:0] = imemory[pc] ;

endmodule

