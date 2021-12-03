module program_counter (pc_in , pc_out , clk , rst);
    parameter AWIDTH = 32;
    input clk , rst;
    input [AWIDTH-1:0]pc_in;
    output reg [AWIDTH-1:0]pc_out;

always @ ( posedge clk ) 
begin
    if (rst)
            pc_out <= 'b0;
    else
            pc_out <= pc_in;
end
endmodule

