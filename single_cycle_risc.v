module single_cycle_risc(input clk , input rst);


//PC
wire [31:0] pc_out_new;
wire [31:0] pc_f;
wire [31:0] pc_in;
program_counter pc(pc_in , pc_f , clk , rst);

//IMEM
wire [31:0] instr_f;
imem im(  pc_f , instr_f  );


adder add4(.pc_out(pc_f) , .pc_out_new(pc_out_new));

//reg fetch/decode
wire [31:0] pc_d;
wire [31:0] instr_d;
if_id ifid( .clk(clk)  ,  .rst(rst) ,  .pc_f(pc_f) , .pc_d(pc_d) , .instr_f(instr_f) , .instr_d(instr_d) );


//REGFILE
wire RegWEn;
wire [31:0] wb;
wire [31:0] DataA,DataB,instr_w;
reg_file rfile(.clk (clk) , .RegWEn(RegWEn), .AddrA(instr_d[19:15]), .AddrB(instr_d[24:20]), 
                .AddrD(instr_w[11:7]), .DataD(wb) ,.DataA (DataA), .DataB (DataB)   );


//Reg decode/execute
wire [31:0] pc_x,instr_x,rs1_x,rs2_x;
id_ex idex( .clk(clk),.rst(rst),.pc_d(pc_d) ,.pc_x(pc_x),.instr_d(instr_d),.instr_x(instr_x),.rs1_d(DataA) ,.rs1_x(rs1_x) , .rs2_d(DataB) ,.rs2_x(rs2_x)  );


//BRANCH_COMP

wire BrUN, BrEQ, BrLT;
branch_comp br_cmp(  .BrUN(BrUN) , .DataA(rs1_x) ,  .DataB(rs2_x)  , 
                    .BrEQ(BrEQ),  .BrLT (BrLT)  );

//IMM_GEN
wire [3:0] ImmSel;
wire [31:0] imm_x;
imm_gen imgen(.in(instr_x[31:7]), .ImmSel(ImmSel), .out(imm_x));



//ALU
wire [31:0] DA,DB, alu_x;
wire [3:0] ALU_Sel;
alu arlu(.in_a(DA), .in_b(DB), .ALU_Sel(ALU_Sel), .alu_x(alu_out));

//reg exexute/memory
wire [31:0] pc_m,instr_m, alu_m,rs2_m,imm_m;
ex_mem exmem
 (.clk(clk)  ,.rst(rst) , .pc_x(pc_x) , .pc_m(pc_m),.instr_x(instr_x), .instr_m(instr_m) , .alu_x(alu_x) 
 ,.alu_m(alu_m) ,.rs2_x(rs2_x) ,.rs2_m(rs2_m) , .imm_x(imm_x) ,.imm_m(imm_m));



//DMEM
wire [2:0] Size;
wire MemRW;
wire [31:0] DataR_m;
dmem dmemo( .clk(clk) ,.Size(Size) , .MemRW (MemRW), .Addr (alu_m) ,  .DataW(rs2_m)  ,  .DataR(DataR_m)  );


//Reg memory/wb

wire [31:0] DataR_w, alu_w, imm_w,pc_w;
mem_wb memwb( .clk(clk)  , .rst(rst) , .pc_m4(pc_m) , .pc_w(pc_w) ,.instr_m(instr_m) , .instr_w(instr_w) , .alu_m(alu_m) , .alu_w(alu_w) ,
   .DataR_m(DataR_m) , .DataR_w(DataR_w) ,.imm_m(imm_m) , .imm_w(imm_w)
 );





//Controller
wire PCSel;
wire [1:0] BSel,ASel;
wire [1:0] WBSel;
controller controlLogic (  .Size(Size),.BrEQ(BrEQ),  .BrLT(BrLT),  .instr_x(instr_x),  .instr_f(instr_f),  .instr_d(instr_d),  .instr_m(instr_m)  ,  .PCSel(PCSel),  .ImmSel(ImmSel),   
                              .instr_w(instr_w),.RegWEn(RegWEn),  .BrUN(BrUN), .ASel(ASel), .BSel(BSel), .ALUSel(ALU_Sel),  
                            .MemRW(MemRW), .WBSel(WBSel) );

//Muxes



mux2x1 m1(.sel(PCSel), .in0(pc_out_new), .in1(alu_x), .mux_out(pc_in));
mux3x1 m2(.sel(BSel), .in0(rs2_x), .in1(imm_x) , .in2(alu_m) , .mux_out(DB));
mux3x1 m3(.sel(ASel), .in0(rs1_x), .in1(pc_x), .in2(alu_m) ,.mux_out(DA));

mux4x1 m41(.sel(WBSel), .mem(DataR_w), .alu(alu_w), .pc(pc_w),.lui(imm_w), .mux_out(wb));

endmodule

