module dmem#
(
  parameter AWIDTH=5,
  parameter DWIDTH=32
 )
 (
  input  clk, MemRW,
  input  [AWIDTH-1:0]   Addr,
  input  [DWIDTH-1:0]   DataW,
  input  [2:0] Size,

  output reg [DWIDTH-1:0] DataR
 );
  localparam load_word = 3'b010, load_half_word = 3'b001, load_byte = 3'b000,
             load_word_signed = 3'b110, load_half_word_signed = 3'b101,
             load_byte_signed = 3'b100, load_double_word = 3'b111;
  localparam store_word = 2'b10, store_half_word = 2'b01, store_byte = 2'b00, store_double_word = 2'b11;
  reg [7:0] dmemory [0:31];
//Synchronous write
always @(posedge clk)
begin
    if ( MemRW )
    begin
      case(Size[1:0])
          store_word:
          begin
                dmemory[Addr] = DataW[7:0];
                dmemory[Addr+1] = DataW[15:8];
                dmemory[Addr+2] = DataW[23:16];
                dmemory[Addr+3] = DataW[31:24];
          end
          store_half_word:
          begin
                dmemory[Addr] = DataW[7:0];
                dmemory[Addr+1] = DataW[15:8];
                dmemory[Addr+2] = 8'h0;
                dmemory[Addr+3] = 8'h0;
          end
          store_byte:
          begin
                dmemory[Addr] = DataW[7:0];
                dmemory[Addr+1] = 8'h0;
                dmemory[Addr+2] = 8'h0;
                dmemory[Addr+3] = 8'h0;
          end
//          store_double_word:
//          begin
//                //for 64-bit
//          end
			 default: begin
			 dmemory[Addr] = dmemory[Addr];
			 end
      endcase
    end
end
//Asynchronous read
always @*
begin
  case(Size)
      load_word:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = dmemory[Addr+1];
                DataR[23:16] = dmemory[Addr+2];
                DataR[31:24] = dmemory[Addr+3];
      end
      load_half_word:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = dmemory[Addr+1];
                DataR[23:16] = 8'h0;
                DataR[31:24] = 8'h0;
      end
      load_byte:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = 8'h0;
                DataR[23:16] = 8'h0;
                DataR[31:24] = 8'h0;
      end
      load_word_signed:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = dmemory[Addr+1];
                DataR[23:16] = dmemory[Addr+2];
                DataR[31:24] = dmemory[Addr+3];
      end
      load_half_word_signed:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = dmemory[Addr+1];
                DataR[23:16] = {8{DataR[15]}};
                DataR[31:24] = {8{DataR[15]}};
      end
      load_byte_signed:
      begin
                DataR[7:0] = dmemory[Addr];
                DataR[15:8] = {8{DataR[7]}}; //DataR[7]?
                DataR[23:16] = {8{DataR[7]}};
                DataR[31:24] = {8{DataR[7]}};
      end
//      load_double_word:
//      begin
//                //for 64-bit
//      end
		default: begin
		DataR = 'b0;
		end
  endcase
end
endmodule
