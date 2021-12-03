
module alu(in_a, in_b, ALU_Sel, alu_out);

    parameter DWIDTH = 32;
    input [DWIDTH-1:0] in_a, in_b;
    input [3:0]ALU_Sel;
    output reg [DWIDTH-1:0] alu_out;
always @*
begin
case(ALU_Sel)
    4'b0000: alu_out = in_a + in_b ;                      //add
    4'b0001: alu_out = in_a - in_b;                       //sub
    4'b0010: alu_out = in_a << in_b;                      //sll
    4'b0011: alu_out = $signed(in_a) < $signed(in_b);     //slt
    4'b0100: alu_out = in_a < in_b;                       //sltu
    4'b0101: alu_out = in_a ^ in_b;                       //xor
    4'b0110: alu_out = in_a >> in_b;                      //srl
    4'b0111: alu_out = $signed($signed(in_a) >>> in_b);                     //sra
    4'b1000: alu_out = in_a | in_b;                       //or
    4'b1001: alu_out = in_a & in_b;                       //and
    4'b1010: alu_out = in_a + in_b;                       //addw
    4'b1011: alu_out = in_a - in_b;                       //subw
    4'b1100: alu_out = in_a << in_b;                      //sllw
    4'b1101: alu_out = in_a << in_b;                      //srlw
    4'b1110: alu_out = in_a >>> in_b;                     //sraw
//  4'b1110: alu_out = in_a;
//  4'b1111: alu_out = in_a;
    default: alu_out = 'hz;
endcase
end
endmodule