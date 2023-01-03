module branch_comp
#(
  parameter integer AWIDTH=32,
  parameter integer DWIDTH=32
 )
 (
  input                 BrUN ,
  input  [DWIDTH-1:0]   DataA , 
  input  [DWIDTH-1:0]   DataB  ,

  output wire           BrEQ, 
  output wire           BrLT  
 );
  assign BrEQ = (DataA == DataB);
  assign BrLT = BrUN ? (DataA <  DataB) : ($signed(DataA) <  $signed(DataB));
endmodule

