module M_Reg(clk, e_stat, M_stat, e_icode, M_icode, e_cnd, M_cnd, e_valE, M_valE, e_valA, M_valA, e_dstE, M_dstE, e_dstM, M_dstM,M_bubble);

    input clk,M_bubble,e_cnd;
    input [63:0] e_valE, e_valA;
    input [3:0] e_icode, e_dstE, e_dstM,e_stat;

    output reg [63:0] M_valE, M_valA;
    output reg M_cnd;
    output reg [3:0] M_stat, M_icode, M_dstE, M_dstM; 

    always@(posedge clk) begin
        M_stat <= e_stat;
        M_cnd <= e_cnd;
        M_valE <= e_valE;
        M_valA <= e_valA;
        case(M_bubble)
            1 : 
                begin
                    M_icode <= 4'b1;
                    M_dstE <= 4'hF;
                    M_dstM <= 4'hF;
                end
            0:
                begin
                    M_icode <= e_icode;
                    M_dstE <= e_dstE;
                    M_dstM <= e_dstM;
                end
        endcase     
    end
    
endmodule
