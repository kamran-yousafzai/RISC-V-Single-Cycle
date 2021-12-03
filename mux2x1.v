module mux2x1 (sel, in0, in1, mux_out);
parameter WIDTH=32;
input sel;
input   [WIDTH-1:0] in0, in1;

output reg [WIDTH-1:0] mux_out;

always @ ( sel , in0 , in1 )
begin
    mux_out = sel ? in1 : in0 ;
end
endmodule

