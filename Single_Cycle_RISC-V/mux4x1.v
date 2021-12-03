module mux4x1 (sel, mem, alu, pc,lui, mux_out);
parameter WIDTH=32;
input   [1:0]       sel;
input   [WIDTH-1:0] mem, alu, pc,lui ;

output reg [WIDTH-1:0] mux_out;

always @ ( sel , mem , alu , pc , lui )
begin
    case (sel)
        2'b00: mux_out = mem;
        2'b01: mux_out = alu;
        2'b10: mux_out = pc;
        2'b11: mux_out = lui;
    endcase
end
endmodule

