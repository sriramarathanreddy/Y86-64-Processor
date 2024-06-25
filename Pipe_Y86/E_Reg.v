module E_Reg(
    input clk,
    input [63:0] d_valA, d_valB, d_valC,
    input [3:0] d_dstE, d_dstM,
    input [3:0] d_srcA, d_srcB,
    input [3:0] d_icode, d_ifun, d_stat,
    input E_bubble,
    
    output reg [3:0] E_stat,
    output reg [3:0] E_icode, E_ifun,
    output reg [63:0] E_valA, E_valB, E_valC,
    output reg [3:0] E_dstE, E_dstM
);
    always @(posedge clk)
    begin
        E_icode <= E_bubble ? 4'b1 : d_icode;
        E_ifun <= E_bubble ? 4'b0 : d_ifun;
        E_dstE <= E_bubble ? 4'hF : d_dstE;
        E_dstM <= E_bubble ? 4'hF : d_dstM;
        E_stat <= d_stat;
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_valC <= d_valC;
    end
endmodule
