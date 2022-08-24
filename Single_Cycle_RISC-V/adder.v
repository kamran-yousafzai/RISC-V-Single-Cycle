/
module adder
#(
  parameter integer AWIDTH=5,
  parameter integer DWIDTH=32
 )
 (
  input  wire [DWIDTH-1:0] pc_out ,
  output  wire [DWIDTH-1:0] pc_out_new  
 );
  assign pc_out_new = pc_out + 4 ;
endmodule
