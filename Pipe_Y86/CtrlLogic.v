module CtrlLogic(clk,W_stat,e_cnd,m_stat,E_dstM,d_srcB,d_srcA,D_icode,E_icode,E_bubble,M_bubble,D_bubble, set_cc,W_stall ,D_stall, F_stall,  Ret, LoadUse, MisJmp);

    input clk;
    input [3:0] W_stat, m_stat;
    input e_cnd;
    input [3:0] E_dstM;
    input [3:0] d_srcB ,d_srcA;
    input [3:0] D_icode, E_icode, M_icode;

    output reg E_bubble,M_bubble,D_bubble;
    output reg set_cc;
    output reg W_stall ,D_stall, F_stall;
    output reg Ret, LoadUse, MisJmp;

    always@(*) begin

        Ret = (D_icode == 4'd9 || E_icode == 4'd9 || M_icode == 4'd9)? 1 : 0;
        LoadUse = ((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB))? 1 : 0;
        MisJmp = ((E_icode == 4'd7) && !e_cnd)? 1 : 0;

        // stall conditions
        if(((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)) ||  (D_icode == 4'd9 || E_icode == 4'd9 || M_icode == 4'd9)) //changes 3 to 5 
            F_stall = 1'd1;
        else
            F_stall = 1'd0;

        if ((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA | E_dstM == d_srcB)) 
            D_stall = 1'd1;
        else
            D_stall = 1'd0;

        if(W_stat == 4'd3 || W_stat == 4'd4 || W_stat == 4'd2)
            W_stall = 1'd1;
        else
            W_stall = 1'd0;


        // bubble conditions
        if ((((E_icode == 4'd7) && !e_cnd) || (D_icode == 4'd9 || E_icode == 4'd9 || M_icode == 4'd9)) && ~((E_icode == 4'd5 || E_icode == 4'd11) & (E_dstM == d_srcA || E_dstM == d_srcB)))
            D_bubble =1'd1;
        else
            D_bubble = 1'd0;

        if (((E_icode == 4'd7) && !e_cnd) || ((E_icode == 4'd5 || E_icode == 4'd11) && (E_dstM == d_srcA || E_dstM == d_srcB)))
            E_bubble =1'd1;
        else
            E_bubble = 1'd0;    

        if((m_stat == 4'd3 || m_stat == 4'd4 || m_stat == 2'd2) || (W_stat == 4'd3 || W_stat == 4'd4 || W_stat == 2'd2))
            M_bubble =1'd1;
        else
            M_bubble = 1'd0;

        // $display("Processing Ret = %0b, Load/Use Hazard = %0b, MisPredicted Jmp = %0b",Ret,LoadUse,MisJmp);

    end
endmodule