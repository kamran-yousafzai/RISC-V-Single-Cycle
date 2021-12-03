
module controller
#(
  parameter integer AWIDTH=32,
  parameter integer DWIDTH=32
 )
 (
   
  input                 BrEQ,
  input                 BrLT,
  input  [DWIDTH-1:0]   instr  ,
  output     reg           PCSel,
  output     reg [3:0]      ImmSel,
  output      reg          RegWEn,
  output      reg          BrUN,
  output    reg            ASel,
  output     reg           BSel,
  output  reg [3:0]        ALUSel,
  output   reg             MemRW,
  output    reg   [1:0]     WBSel,
  output reg [2:0]          Size

 );
 localparam  rtype1 = 7'b0110011, rtype2 = 7'b01110011, itype1 = 7'b0000011 , itype2 = 7'b0001111, itype3 = 7'b0010011,
                  itype4 = 7'b0011011 ,itype5 = 7'b1100111 , itype6 = 7'b1110011, stype = 7'b0100011, sbtype = 7'b1100011, utype1 = 7'b0010111,
                  utype2 = 7'b0110111, ujtype = 7'b1101111 ;


  //for ALUSel
  localparam  add=4'b0000 , sub=4'b0001 , sll=4'b0010 , slt=4'b0011 , sltu=4'b0100 ,
                   xorr=4'b0101 , srl=4'b0110 , sra=4'b0111 , orr=4'b1000 , andd=4'b1001 ,
                   addw=4'b1010 ,subw=4'b1011 ,sllw=4'b1100 ,srlw=4'b1101 ,sraw=4'b1110 ;
  reg [6:0] opcode;
  reg [2:0] func3;
  reg [6:0] func7;
always @ (*) begin
  opcode <= instr [6:0];
  func3 <= instr [14:12];
  func7 <= instr [31:25];
  case (opcode)
    rtype1: begin
      case (func3)
        3'b000: begin
          case (func7[5])
            1'b0:  ALUSel <= add;
            1'b1:  ALUSel <= sub;
          endcase
        end
        3'b001: begin
          ALUSel <= sll;
        end
        3'b010: begin
          ALUSel <= slt;
        end
        3'b011: begin
          ALUSel <= sltu;
        end 
        3'b100: begin
          ALUSel <= xorr;
        end
        3'b101: begin
          case (func7[5])
            1'b0:  ALUSel <= srl;
            1'b1:  ALUSel <= sra;
          endcase
        end
        3'b110: begin
          ALUSel <= orr;
        end
        3'b111: begin
          ALUSel <= andd;
        end
      endcase
      {PCSel,ImmSel,RegWEn,BrUN,ASel,BSel,MemRW,WBSel,Size} <= { 1'b0,{4'b0000},1'b1,1'b0,1'b0,1'b0,1'b0,{2'b01},{3'b000} };
    end
    rtype2: begin
      case (func3)
        3'b000: begin
          case (func7[5])
            1'b0:  ALUSel <= addw;
            1'b1:  ALUSel <= subw;
          endcase
        end
        3'b001: begin
          ALUSel <= sllw;
        end
        3'b101: begin
          case (func7[5])
            1'b0:  ALUSel <= srlw;
            1'b1:  ALUSel <= sraw;
          endcase
        end
        default: begin
            ALUSel <= add;
        end
      endcase
    {PCSel,ImmSel,RegWEn,BrUN,ASel,BSel,MemRW,WBSel,Size} <= { 1'b0,{4'b0000},1'b1,1'b0,1'b0,1'b0,1'b0,{2'b01} ,{3'b000}};
    end
    itype1: begin
      case (func3)
        3'b000: begin
          ImmSel <= 4'b1000;
          Size   <= 3'b100;
        end
        3'b001: begin
          ImmSel <= 4'b1000;
          Size   <= 3'b101;
        end
        3'b010: begin
          ImmSel <= 4'b1000;
          Size   <= 3'b110;
        end
        3'b011: begin
          ImmSel <= 4'b1000;
          Size   <= 3'b111;
        end 
        3'b100: begin
          ImmSel <= 4'b0000;
          Size   <= 3'b000;
        end
        3'b101: begin
          ImmSel <= 4'b0000;
          Size   <= 3'b001;
        end
        3'b110: begin
          ImmSel <= 4'b0000;
          Size   <= 3'b010;
        end
        default: begin
          ImmSel <= 4'b0000;
          Size   <= 3'b000; 
        end
      endcase
      {PCSel,RegWEn,BrUN,ASel,BSel,MemRW,WBSel,ALUSel} <= { 1'b0,1'b1  ,1'b0,1'b0,1'b1,1'b0,2'b00, 4'b0000 };
    end
    //not to be implemented 
    // itype2: begin
      
    // end
    itype3: begin
      case (func3)
        3'b000: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b0000;
        end
        3'b001: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b0010;
        end
        3'b010: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b0011;
        end
        3'b011: begin
          ImmSel <= 4'b0000;
          ALUSel <= 4'b0100;
        end 
        3'b100: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b0101;
        end
        3'b101: begin
          ImmSel <= 4'b1000;
          case (func7[5]) 
            1'b0: ALUSel <= 4'b0110;
            1'b1: ALUSel <= 4'b0111;
          endcase
        end
        3'b110: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b1000;
        end
        3'b111: begin
          ImmSel <= 4'b1000;
          ALUSel <= 4'b1001;
        end
        default: begin
            ImmSel <= 4'b0000;
            ALUSel <= 4'b0000;
        end
      endcase
      //other control signals will be same
      {PCSel,RegWEn,BrUN,ASel,BSel,MemRW,WBSel , Size} <=  { 1'b0,1'b1,  1'b0,1'b0,1'b1,1'b0, {2'b01}, {3'b000}};
    end
    //Not to be implemented at the moment
    // itype4: begin
      
    // end
    itype5: begin
      PCSel <= 1'b1;
      RegWEn<= 1'b1;
      BrUN  <= 'b0;
      ASel  <= 1'b0;
      BSel  <= 1'b1;
      MemRW <= 1'b0;
      WBSel <= 2'b10;
      Size  <= 'b0;
      ALUSel<= 4'b0000;
      ImmSel<= 4'b1000;
    end
    //Not to be implemented
    // itype6: begin
      
    // end
    //Store
    stype: begin
      case (func3)
        3'b000: begin
          Size <= 3'b000;
        end
        3'b001: begin
          Size <= 3'b001;
        end
        3'b010: begin
          Size <= 3'b010;
        end
        //Store Double Word (Not to be implemented)
        3'b011: begin
          Size <= 3'b000;   //Dummy
        end 
        default: begin
            Size = 3'b000;
        end
      endcase
      MemRW <= 1'b1;
      ALUSel<= 4'b0000;
      PCSel <= 1'b0;
      ImmSel<= 4'b0001;
      BSel  <= 1'b1;
      ASel  <= 1'b0;
      WBSel <= 2'b00;
      RegWEn<= 1'b0;
      BrUN  <= 1'b0;
    end
    sbtype: begin
      RegWEn<= 1'b0;
      MemRW <= 1'b0;
      ALUSel<= 4'b0000;
      BSel  <= 1'b1;
      ASel  <= 1'b1;
      WBSel <= 2'b00;
      Size  <= 3'b000;
      case (func3)
        3'b000:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b0;
          if(BrEQ) begin
            PCSel <= 1'b1;
          end
          else begin
            PCSel <= 1'b0;
          end
        end
        3'b001:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b0;
          if(BrEQ) begin
            PCSel <= 1'b0;
          end
          else begin
            PCSel <= 1'b1;  
          end
        end
        3'b100:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b0;
          if(BrLT) begin
            PCSel <= 1'b1;
          end
          else begin
            PCSel <= 1'b0;
          end
        end
        3'b101:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b0;
          if(BrLT) begin
            PCSel <= 1'b0;
          end
          else begin
            PCSel <= 1'b1;
          end
        end
        3'b110:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b1;
          if(BrLT) begin
            PCSel <= 1'b1;
          end
          else begin
            PCSel <= 1'b0;
          end
        end
        3'b111:begin
          ImmSel <= 4'b0010;
          BrUN   <= 1'b1;
          if(BrLT) begin
            PCSel <= 1'b0;
          end
          else begin
            PCSel <= 1'b1;
          end
        end
        default: begin
            ImmSel <= 4'b0000;
            BrUN   <= 1'b0;
            PCSel  <= 1'b0;
        end
      endcase
    end
    //AUIPC
    utype1: begin
      PCSel  <= 1'b0;
      ImmSel <= 4'b0011;
      BrUN   <= 1'b0;
      ASel   <= 1'b1;
      BSel   <= 1'b1;
      ALUSel <= 4'b0000;
      MemRW  <= 1'b0;
      RegWEn <= 1'b1;
      WBSel  <= 2'b01;
      Size   <= 3'b000;
    end
    utype2: begin
      //LUI
      PCSel  <= 1'b0;
      ImmSel <= 4'b0011;
      BrUN   <= 1'b0;
      ASel   <= 1'b1;
      BSel   <= 1'b1;
      ALUSel <= 4'b0000;
      MemRW  <= 1'b0;
      RegWEn <= 1'b1;
      WBSel  <= 2'b11;
      Size   <= 3'b000;
    end
    ujtype: begin
      WBSel <= 2'b10;
      RegWEn<= 1'b1;
      MemRW <= 1'b0;
      ALUSel<= 4'b0000;
      Size  <= 3'b000;
      ImmSel<= 4'b0100;
      ASel  <= 1'b1;
      BSel  <= 1'b1;
      BrUN  <= 1'b0;
      PCSel <= 1'b1;
    end
    default: begin
      {PCSel,ImmSel,RegWEn,BrUN,ASel,BSel,ALUSel,MemRW,WBSel,Size} <= { 1'b0,{4'b0000},1'b0,1'b0,1'b0,1'b0,{4'b0000},1'b0,{2'b00} ,{4'b000}};
    end
  endcase

end
endmodule
