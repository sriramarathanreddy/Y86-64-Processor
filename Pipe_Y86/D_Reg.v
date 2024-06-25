module D_Reg(
    input clk,
    input [3:0] f_icode, f_ifun, f_rA, f_rB, f_stat,
    input [63:0] f_valP, f_valC,
    input D_stall, D_bubble,

    output reg [3:0] D_icode, D_ifun, D_rA, D_rB, D_stat,
    output reg [63:0] D_valC, D_valP
);

    always @(posedge clk)
    begin
        if (!D_stall)
        begin
            if (!D_bubble)
            begin
                D_icode <= f_icode; 
                D_ifun <= f_ifun;
                D_rA <= f_rA;
                D_rB <= f_rB;
                D_valC <= f_valC;
                D_valP <= f_valP;
                D_stat <= f_stat;
            end
            else
            begin
                D_icode <= 4'b1;
                D_ifun <= 4'b0;
            end
        end
    end
endmodule
