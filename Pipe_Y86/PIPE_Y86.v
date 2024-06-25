`include "Fetch.v"
`include "F_Reg.v"
`include "Decode.v"
`include "D_Reg.v"
`include "Execute.v"
`include "E_Reg.v"
`include "Memory.v"
`include "M_Reg.v"
`include "Writeback.v"
`include "W_Reg.v"
`include "CtrlLogic.v"

module PIPE_Y86();

    reg clk;
    reg [63:0] F_PC;

    wire [3:0] f_icode, f_ifun, f_rA, f_rB;
    wire [63:0] f_valC, f_valP, F_predPC, predPC, PC_new;
    wire instr_valid, imem_err, hlt;


    wire [3:0] D_icode, D_ifun, D_rA, D_rB, d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun;
    wire [63:0] D_valC, D_valP, d_valC, d_valA,e_valE, d_valB;

    wire [3:0] e_dstE;
    wire [3:0] e_icode, e_dstM;
    wire [63:0] e_valA;
    wire [3:0] E_icode, E_ifun, E_dstE, E_dstM;
    wire [63:0] E_valA, E_valB, E_valC;
    wire e_cnd;

    wire [63:0] M_valA, M_valE;
    wire [3:0] M_icode, M_dstE, M_dstM;
    wire [3:0] m_dstE, m_dstM, m_icode;
    wire [63:0] m_valE;
    wire M_cnd;
    wire [63:0] m_valM;

    wire [63:0] W_valM, W_valE;
    wire [3:0] W_icode, W_dstM, W_dstE;
    wire  Ret, LoadUse, MisJmp;

    wire [3:0] f_stat,d_stat,e_stat,m_stat,w_stat;
    wire [3:0] D_stat,E_stat,M_stat,W_stat;

    reg [63:0] reg_file [0:14] ;
    wire [63:0] reg_wire [0:14];


    // ******** calling pipeline modules ********* //

    F_Reg FR1(clk, F_stall, predPC, F_PC,  F_predPC);

    D_Reg DR1(clk, f_icode, f_ifun, f_rA, f_rB, f_stat, f_valP, f_valC, D_stall,D_bubble, D_icode, D_ifun, D_rA, D_rB, D_stat, D_valC, D_valP);

    E_Reg ER1(clk, d_valA, d_valB, d_valC, d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun, d_stat, E_bubble, E_stat, E_icode, E_ifun, E_valA, E_valB, E_valC, E_dstE, E_dstM);

    M_Reg MR1(clk, e_stat, M_stat, e_icode, M_icode, e_cnd, M_cnd, e_valE, M_valE, e_valA, M_valA, e_dstE, M_dstE, e_dstM, M_dstM, M_bubble);

    W_Reg WR1(clk, DataMemError, m_stat, W_stat, m_icode, W_icode, m_valE, W_valE, m_valM, W_valM, m_dstE, m_dstM, W_dstE, W_dstM, W_stall);

    Fetch F1(clk, F_PC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, predPC, f_stat);

    Select_PC SPC1(clk, F_predPC, m_valM, M_valA, M_icode, M_cnd, PC_new);

    Decode D1(clk ,D_icode ,D_ifun ,D_rA ,D_rB ,D_valC, D_valP ,D_stat, e_dstE ,e_valE ,M_dstE ,M_valE ,M_dstM ,m_valM, W_dstM ,W_valM ,W_dstE ,W_valE, reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7],reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], reg_wire[13], reg_wire[14], d_icode ,d_ifun ,d_valC ,d_valA ,d_valB ,d_dstE ,d_dstM ,d_srcA ,d_srcB, d_stat);

    Execute E1(clk ,E_stat ,E_icode ,E_ifun ,E_valA ,E_valB ,E_valC ,E_dstE ,E_dstM ,W_stat ,m_stat, e_stat ,e_icode ,e_cnd ,e_valE ,e_valA ,e_dstE ,e_dstM);

    Memory M1(clk, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM, m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, DataMemError);

    Writeback WB1(clk, W_icode, W_valE, W_valM, W_dstE, W_dstM, reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7], reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], reg_wire[13], reg_wire[14]);

    CtrlLogic CTRl1(clk,W_stat,e_cnd,m_stat,E_dstM,d_srcB,d_srcA,D_icode,E_icode,E_bubble,M_bubble,D_bubble, set_cc,W_stall ,D_stall, F_stall, Ret, LoadUse, MisJmp);

    initial begin
        $dumpfile("PIPE_Y86.vcd");
        $dumpvars(0, PIPE_Y86);

        $display("------------------------------------------------------------------------------------");
        clk = 0;
        F_PC = 64'd0;

        $monitor("time = %3d, clk = %b\n\trax=%0d, rcx=%0d, rdx=%0d, rbx=%0d, rsp=%0d, rbp=%0d, rsi=%0d, rdi=%0d, r8=%0d, r9=%0d, r10=%0d, r11=%0d, r12=%0d, r13=%0d, r14=%0d\n\tProcessing Ret = %0b, Load/Use Hazard = %0b, MisPredicted Jmp = %0b\n\tF_stall = %b, D_stall = %b, W_stall = %b, D_bubble = %b,E_bubble = %b, M_bubble = %b\n\tf_stat = %d, D_stat = %d, d_stat = %d, E_stat = %d, e_stat = %d, M_stat = %d, m_stat = %d, W_stat = %d\n\tpredPC=%0d, PC_new=%0d\n\tF_PC = %0d, F_predPC = %0d, f_icode = %0h, f_ifun = %0h,f_rA = %0h,f_rB = %0h, f_valC = %0d,f_valP = %0d\n\tD_icode = %0h,D_ifun = %0h,D_rA = %0h,D_rB = %0h, D_valC = %0d, D_valp = %0d\n\td_icode = %0h, d_ifun = %0h, d_valC = %0d, d_valA = %0d, d_valB = %0d, d_srcA = %0h, d_srcB = %0h, d_dstE = %0h, d_dstM = %0h\n\tE_icode = %0h, E_ifun = %0h, E_valC = %0d, E_valA = %0d, E_valb = %0d, E_dstE = %0h, E_valM = %0d\n\te_icode = %0h, e_valA = %0d, e_valE = %0d, e_dstE = %0h, e_dstM = %0h, e_cnd = %0b\n\tM_icode = %0h, M_valA = %0d, M_valE = %0d, M_dstE = %0h, M_dstM = %0h, M_cnd = %0b, m_icode = %0h, m_valE = %0d, m_valM = %0d, m_dstE = %0h, m_dstM = %0h\n\tW_icode = %0h, W_valE = %0d, W_valM = %0d, W_dstE = %0h, W_dstM = %0h\n------------------------------------------------------------------------------------",
                 $time,clk,reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8],reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14],Ret,LoadUse,MisJmp,F_stall,D_stall,W_stall,D_bubble,E_bubble,M_bubble,f_stat,D_stat,d_stat,E_stat,e_stat,M_stat,m_stat,W_stat,predPC,PC_new,F_PC,F_predPC,f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,d_icode,d_ifun,d_valC,d_valA,d_valB,d_srcA,d_srcB,d_dstE,d_dstM,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,e_icode,e_valA,e_valE,e_dstE,e_dstM,e_cnd,M_icode,M_valA,M_valE,M_dstE,M_dstM,M_cnd,m_icode,m_valE,m_valM,m_dstE,m_dstM,W_icode,W_valE,W_valM,W_dstE,W_dstM);
    end

    always #5 clk = ~clk;   
    
    always@(*) begin
        if(W_stat == 2 || W_stat == 3 || W_stat == 4)  
            $finish;
    end

    always@(*) begin
        F_PC <= PC_new;
    end

    always@(*) begin
        reg_file[0] = reg_wire[0];
        reg_file[1] = reg_wire[1];
        reg_file[2] = reg_wire[2];
        reg_file[3] = reg_wire[3];
        reg_file[4] = reg_wire[4];
        reg_file[5] = reg_wire[5];
        reg_file[6] = reg_wire[6];
        reg_file[7] = reg_wire[7];
        reg_file[8] = reg_wire[8];
        reg_file[9] = reg_wire[9];
        reg_file[10] = reg_wire[10];
        reg_file[11] = reg_wire[11];
        reg_file[12] = reg_wire[12];
        reg_file[13] = reg_wire[13];
        reg_file[14] = reg_wire[14];
    end

endmodule