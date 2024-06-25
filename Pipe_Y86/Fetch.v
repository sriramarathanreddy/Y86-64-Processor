module Select_PC
(
    input clk,
    input [63:0] F_predPC, m_valM, M_valA,
    input [3:0] M_icode,
    input M_cnd,

    output reg [63:0] PC_new
);
    always @(*)
    begin
        case(M_icode)
            4'd7: begin // Conditional move
                if (!M_cnd)
                    PC_new <= M_valA;
                else
                    PC_new <= F_predPC;
            end
            4'd9: begin // Return
                PC_new <= m_valM;
            end
            default: begin
                PC_new <= F_predPC;
            end
        endcase
    end
endmodule

module Fetch (
    input clk,
    input [63:0] F_PC,
    output reg [3:0] f_icode, f_ifun, f_rA, f_rB,
    output reg [0:63] f_valC,
    output reg [63:0] f_valP, predPC,
    output reg [3:0] f_stat
);
    parameter IMemSize = 1024;
    reg INS,IMemErr,HLT;
    reg [7:0] InstructionMemory[0:IMemSize-1];
    reg [0:79] Instruction;

    initial $readmemb("smoltest.txt", InstructionMemory);

    always @(*)
    begin
        case(f_icode)
            4'h0:
            begin // Halt
                if (HLT)
                    f_stat <= 4'h2;
                else if (IMemErr)
                    f_stat <= 4'h3;
                else if (INS)
                    f_stat <= 4'h4;
                else
                    f_stat <= 4'h1;
            end
            default: f_stat <= 4'h1;
        endcase
    end

    initial HLT = 0;

    always @(*)
    begin
        IMemErr = 0;
        if (F_PC >= IMemSize) begin
            IMemErr = 1;
        end

        Instruction = {InstructionMemory[F_PC],InstructionMemory[F_PC+1],InstructionMemory[F_PC+2],InstructionMemory[F_PC+3],InstructionMemory[F_PC+4],InstructionMemory[F_PC+5],InstructionMemory[F_PC+6],InstructionMemory[F_PC+7],InstructionMemory[F_PC+8],InstructionMemory[F_PC+9]};

        if (Instruction[0:3] == 4'h3 || Instruction[0:3] == 4'h4 || Instruction[0:3] == 4'h5)
        begin
            Instruction = {InstructionMemory[F_PC],InstructionMemory[F_PC+1],InstructionMemory[F_PC+9],InstructionMemory[F_PC+8],InstructionMemory[F_PC+7],InstructionMemory[F_PC+6],InstructionMemory[F_PC+5],InstructionMemory[F_PC+4],InstructionMemory[F_PC+3],InstructionMemory[F_PC+2]};    
        end
        if (Instruction[0:3] == 4'h7 || Instruction[0:3] == 4'h8)
        begin
            Instruction = {InstructionMemory[F_PC],InstructionMemory[F_PC+8],InstructionMemory[F_PC+7],InstructionMemory[F_PC+6],InstructionMemory[F_PC+5],InstructionMemory[F_PC+4],InstructionMemory[F_PC+3],InstructionMemory[F_PC+2],InstructionMemory[F_PC+1],InstructionMemory[F_PC+9]};    
        end

        f_icode = Instruction[0:3];
        f_ifun = Instruction[4:7];
        INS = 1'b0;
        HLT = 1'b0;

        case(f_icode)
            // Halt or No operation
            4'h0,4'h1:
            begin
                HLT = (f_icode == 4'h0) ? 1'b1 : 1'b0;
                f_valP = F_PC + 1;
            end
            // Conditional move
            4'h2:
            begin
                {f_rA, f_rB} = {Instruction[8:15]};
                f_valP = F_PC + 2;
            end
            // irmovq, rmmovq, mrmovq
            4'h3, 4'h4, 4'h5:
            begin
                {f_rA, f_rB, f_valC} = {Instruction[8:15],Instruction[16:79]};
                f_valP = F_PC + 10;
            end
            // opq
            4'h6:
            begin
                {f_rA, f_rB} = {Instruction[8:15]};
                f_valP = F_PC + 2;
            end
            // jump or call
            4'h7, 4'h8:
            begin
                {f_valC} = {Instruction[8:71]};
                f_valP = F_PC + 9;
            end
            // Return
            4'h9:
            begin
                f_valP = F_PC + 1;
            end
            // pushq or popq
            4'hA, 4'hB:
            begin
                {f_rA, f_rB} = {Instruction[8:15]};
                f_valP = F_PC + 2;
            end
            default: INS = 1'b1;
        endcase
    end

    always @(*)
    begin
        case (f_icode)
            4'h7,4'h8:
                begin // Jump or Call
                    predPC = f_valC;
                end
            default: predPC = f_valP;
        endcase
    end

    always @(*) $display("\tInstruction = %h", Instruction);
endmodule
