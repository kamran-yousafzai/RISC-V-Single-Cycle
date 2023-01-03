module reg_file
#(
  parameter integer RAWIDTH=5,
  parameter integer DWIDTH=32
 )
 (
  input                 clk  ,
  input                 RegWEn,
  input  [RAWIDTH-1:0]          AddrA,
  input  [RAWIDTH-1:0]          AddrB,
  input  [RAWIDTH-1:0]          AddrD,
  input  [DWIDTH-1:0]   DataD ,
  output  reg [DWIDTH-1:0]   DataA , 
  output  reg [DWIDTH-1:0]   DataB   
 );

  reg [DWIDTH-1:0] register [2**RAWIDTH-1:0];
  always @ (posedge clk) begin
          register[0] = 'b0;
          register[AddrD] = RegWEn ? (|AddrD ? DataD : 0) : register[AddrD] ;
  end


always @(*) begin
   DataA = register[AddrA];
   DataB = register[AddrB];
end
endmodule

