module imm_gen(in, ImmSel, out);

    parameter IMMWIDTH = 25;
    parameter DWIDTH   = 32;
    input [IMMWIDTH-1:0] in;
    input [3:0]          ImmSel;
    output reg [DWIDTH-1:0] out;
always @*
begin
case(ImmSel[2:0])
    //I  - Type
    3'b000: out = ImmSel[3]? { {{DWIDTH-12}{in[24]}} , {in[24 : 13]}  } :                            
                    { {{DWIDTH-12}{1'b0}} , {in[24 : 13]}  } ; 
    //S  - Type                                      
    3'b001: out = { {{DWIDTH-12}{in[24]}} , {in[24 : 18]} , {in[4 : 0]} } ;                         
    //SB - Type
    3'b010: out = { {{DWIDTH-13}{in[24]}} , {in[24]} , {in[0]} , {in[23:18]} , {in[4:1]} ,1'b0} ;
    //U  - Type       
    3'b011: out = { {in[24:5]} , {{DWIDTH-20}{1'b0}} } ;
    //UJ - Type                                              
    3'b100: out = { {{DWIDTH-21}{in[24]}} , {in[24]} , {in[12 : 5]} , {in[13]} , {in[23:14]} ,1'b0} ;    
    default: out = 'h0;
endcase
end
endmodule
