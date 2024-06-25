`include "Fetch/Fetch.v"
`include "Decode_Writeback/Decode_Writeback.v"
`include "Execute/Execute.v"
`include "Memory/Memory.v"
`include "PC_Update/PC_Update.v"

module Seq_y86;   
    // ** Inputs to Processor ** //
    reg Clk; // Clock
    reg [63:0] PC; // Program Counter for current code
    reg [3:0] InstructionMemory[0:255];
    
    // ** Outputs from Processor ** //
    wire [3:0] icode,ifun,rA,rB; // Instruction Code and Function Code
    wire signed [63:0] valC; // 8 byte constant word from instruction
    wire [63:0] valP,NewPC; // PC update value and PC value for next cycle
    wire DataMemError,INS,HLT; // Flags
    wire signed [63:0] valA,valB,valE,valM; // Inputs to ALU, Output From ALU, Output of Memory Read.
    wire [2:0] CondititonCodes_Out; // 3 bits of Condition codes indicates Zero Flag, Sign Flag, and Overflow Flag respectively
    wire signed [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14; // Register File

    reg [2:0] CondititonCodes_In;
    reg [3:0] Status;
    reg [0:79] Instruction;

    Fetch fetch_instance(.Clk(Clk),.icode(icode),.ifun(ifun),.rA(rA),.rB(rB),.valC(valC),.valP(valP),.PC(PC),.INS(INS),.ADR(ADR),.HLT(HLT),.Instruction(Instruction));
    Decode_Writeback decode_writeback_instance(.Clk(Clk),.icode(icode),.rA(rA),.rB(rB),.Condition(Condition),.valA(valA),.valB(valB),.valE(valE),.valM(valM),.rax(rax),.rbx(rbx),.rcx(rcx),.rdx(rdx),.rsp(rsp),.rbp(rbp),.rsi(rsi),.rdi(rdi),.r8(r8),.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14));
    Execute execute_instance(.Clk(Clk),.icode(icode),.ifun(ifun),.valA(valA),.valB(valB),.valC(valC),.valE(valE),.Condition(Condition),.CondititonCodes_In(CondititonCodes_In),.CondititonCodes_Out(CondititonCodes_Out));
    always @(*) begin
        if (icode == 4'h6)
            CondititonCodes_In = CondititonCodes_Out;
    end
    Memory memory_instance(.Clk(Clk),.icode(icode),.valA(valA),.valP(valP),.valE(valE),.valM(valM),.DataMemError(DataMemError));
    PC_Update pc_update_instance(.Clk(Clk),.icode(icode),.Condition(Condition),.valC(valC),.valM(valM),.valP(valP),.PC(NewPC));

    // Give Instruction
    always @(PC)
        Instruction = {InstructionMemory[PC], InstructionMemory[PC+1], InstructionMemory[PC+2], InstructionMemory[PC+3], InstructionMemory[PC+4], InstructionMemory[PC+5], InstructionMemory[PC+6], InstructionMemory[PC+7], InstructionMemory[PC+8], InstructionMemory[PC+9], InstructionMemory[PC+10], InstructionMemory[PC+11], InstructionMemory[PC+12], InstructionMemory[PC+13], InstructionMemory[PC+14], InstructionMemory[PC+15], InstructionMemory[PC+16], InstructionMemory[PC+17], InstructionMemory[PC+18], InstructionMemory[PC+19]};

    // Set Status Register.
    always @(HLT,PC,DataMemError,INS) begin
        if (HLT == 1)
            Status = 4'h4; // Halt instruction encountered 
        else if (INS == 1)
            Status = 4'h3; // Invalid Instruction Encountered
        else if ( (PC >= 256) || (DataMemError == 1))
            Status = 4'h2; // Invalid Address Encountered
        else
            Status = 4'h1; // Normal Operation

        if ((Status == 4'h2) || (Status == 4'h3)|| (Status == 4'h4))
            $finish;
    end

    always #10 Clk = ~Clk;
    always @(*)
    begin
        PC = NewPC;    
    end

    initial
    begin
      $dumpfile("Seq_y86.vcd");
      $dumpvars(1,Seq_y86);
      Clk = 0;
      PC = 64'h0;
      CondititonCodes_In = 3'd0;
    // end

    // always @(posedge Clk )
    // begin
    //     $display("At T = %4t, Clk = %b, PC = %16h, New_PC = %16h, Current Stack Pointer: %b\nStatus of Processor: %4b \nInstruction = %16h, \nicode = %1h,ifun = %1h, rA = %1h, rB = %1h,valC = %16h.\nvalA = %16h,valB = %16h,valE = %16h,valM = %16h.\nInput Condition Codes (ZF,SF,OF respectively): %4b,\nOutput Condition Codes (ZF,SF,OF respectively): %4b",$time,Clk,PC,NewPC,rsp,Status,Instruction,icode,ifun,rA,rB,valC,valA,valB,valE,valM,CondititonCodes_In,CondititonCodes_Out);    
    // end

    // initial begin
        $monitor("At T = %4t, Clk = %b, PC = %16h, New_PC = %16h, Current Stack Pointer: %b\nStatus of Processor: %d \nInstruction = %16h, \nicode = %1h,ifun = %1h, rA = %1h, rB = %1h,valC = %16h.\nvalA = %16h,valB = %16h,valE = %16h,valM = %16h.\nInput Condition Codes (ZF,SF,OF respectively): %4b,\nOutput Condition Codes (ZF,SF,OF respectively): %4b",$time,Clk,PC,NewPC,rsp,Status,Instruction,icode,ifun,rA,rB,valC,valA,valB,valE,valM,CondititonCodes_In,CondititonCodes_Out);    
        #10;
        InstructionMemory[1] = 4'b0011;
        InstructionMemory[2] = 4'b0000;
        InstructionMemory[3] = 4'b1111;
        InstructionMemory[4] = 4'b0011;
        InstructionMemory[5] = 4'b0000;
        InstructionMemory[6] = 4'b0000;
        InstructionMemory[7] = 4'b0000;
        InstructionMemory[8] = 4'b0001;
        InstructionMemory[9] = 4'b0000;
        InstructionMemory[10] = 4'b0000;
        InstructionMemory[11] = 4'b0000;
        InstructionMemory[12] = 4'b0000;
        InstructionMemory[13] = 4'b0000;
        InstructionMemory[14] = 4'b0000;
        InstructionMemory[15] = 4'b0000;
        InstructionMemory[16] = 4'b0000;
        InstructionMemory[17] = 4'b0000;
        InstructionMemory[18] = 4'b0000;
        InstructionMemory[19] = 4'b0000;
        InstructionMemory[20] = 4'b0000;
        InstructionMemory[21] = 4'b0011;
        InstructionMemory[22] = 4'b0000;
        InstructionMemory[23] = 4'b1111;
        InstructionMemory[24] = 4'b0010;
        InstructionMemory[25] = 4'b0000;
        InstructionMemory[26] = 4'b0000;
        InstructionMemory[27] = 4'b0000;
        InstructionMemory[28] = 4'b0010;
        InstructionMemory[29] = 4'b0000;
        InstructionMemory[30] = 4'b0000;
        InstructionMemory[31] = 4'b0000;
        InstructionMemory[32] = 4'b0000;
        InstructionMemory[33] = 4'b0000;
        InstructionMemory[34] = 4'b0000;
        InstructionMemory[35] = 4'b0000;
        InstructionMemory[36] = 4'b0000;
        InstructionMemory[37] = 4'b0000;
        InstructionMemory[38] = 4'b0000;
        InstructionMemory[39] = 4'b0000;
        InstructionMemory[40] = 4'b0110;
        InstructionMemory[41] = 4'b0000;
        InstructionMemory[42] = 4'b0010;
        InstructionMemory[43] = 4'b0011;

        #100;
        $finish;
    end


endmodule


