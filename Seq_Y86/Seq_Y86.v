`include "Fetch/Fetch.v"
`include "Decode_Writeback/Decode_Writeback.v"
`include "Execute/Execute.v"
`include "Memory/Memory.v"
`include "PC_Update/PC_Update.v"

module Sequential_Y86;
    reg Clk; // Clock
    reg [63:0] PC; // Program Counter
    reg [0:2] ConditionCodes_In = 3'b0; // 3 bits of Condition codes indicates Zero Flag, Sign Flag, and Overflow Flag respectively used to update Condition Signal
    reg [0:79] Instruction; // Instruction (can be a maximum of 10 bytes in length: icode=> 1/2, ifun => 1/2, rA => 1/2, rB => 1/2, valC => 8)
    
    wire [3:0] icode,ifun,rA,rB; // 8 bytes for instruction, registers to store parameters
    wire signed [63:0] valC,valP;// Destination of Jump, Update PC value
    wire HLT, INS ,ADR; // Flags (Status Registor)
    wire DataMemError; // outof Bounds Data Memory accrssed
    wire Condition; // Clock and Condition Signal
    wire [63:0] valE; // Output of ALU to be written to memory or register
    wire [63:0] valM; // Value read from memory
    wire [0:2] ConditionCodes_Out = 3'b0;
    wire [63:0] valA,valB; // Inputs to ALU from decode stage
    wire [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14; // Register File
    wire [63:0]NewPC;
    reg [3:0] Status = 4'b0;

    reg [7:0] InstructionMemory [0:2048];

    always @(PC) begin
        Instruction = {InstructionMemory[PC],InstructionMemory[PC+1],InstructionMemory[PC+2],InstructionMemory[PC+3],InstructionMemory[PC+4],InstructionMemory[PC+5],InstructionMemory[PC+6],InstructionMemory[PC+7],InstructionMemory[PC+8],InstructionMemory[PC+9]};
    end

    Fetch Fetch_Instance(Clk,icode,ifun,rA,rB,valC,valP,PC,INS/*Invalid Instruction*/,ADR/*Address Error*/,HLT/*Halt*/,Instruction);
    Decode_Writeback Decode_Writebacck_Instance(Clk,icode,ifun,rA,rB,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);
    Execute Execute_Instance(Clk,icode,ifun,valA,valB,valC,valE,Condition,ConditionCodes_In,ConditionCodes_Out);
    always @(*)
    begin
        if(icode == 4'h6)
            ConditionCodes_In <= ConditionCodes_Out;
    end
    Memory Memory_Instance(Clk,icode,valA,valP,valE,valM,DataMemError);
    PC_Update PC_Update_Insatnce(Clk,icode,Condition,valC,valM,valP,NewPC);

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

    always#10 Clk = ~Clk;

    always @(*) PC = NewPC;

    // initial $readmemh("test1{3,4,5,7,8}.txt",InstructionMemory);
    initial $readmemh("test2{2,A,B}.txt",InstructionMemory);
        // initial $readmemh("test3{8,9}.txt",InstructionMemory);

    initial begin
        $dumpfile("Sequential_Y86.vcd");
        $dumpvars(0,Sequential_Y86);
        // $monitor("At T = %4t,Clk = %b,\n\tInstruction = %20h,\n\ticode = %1h, ifun = %1h, rA = %1h, rB = %1h,\n\tvalC = %16h, valP = %16h, PC = %16h,\n\tInVal Ins = %1b, Address Error = %1b, Halt = %1b,\n\tCondition = %1b,\n\tvalA = %16h, valB = %16h,\n\tvalE = %16h, valM = %16h,\n\trax = %16h,\n\trbx = %16h,\n\trcx = %16h,\n\trdx = %16h,\n\trsp = %16h,\n\trbp = %16h,\n\trsi = %16h,\n\trdi = %16h,\n\tr8 = %16h,\n\tr9 = %16h,\n\tr10 = %16h,\n\tr11 = %16h,\n\tr12 = %16h,\n\tr13 = %16h,\n\tr14 = %16h\n\tDMem Error = %b, NewPC = %16h,\n\tConditionCodes_In = %3b,ConditionCodes_Out = %3b",$time, Clk, Instruction, icode, ifun, rA, rB, valC, valP, PC, INS, ADR, HLT,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,DataMemError,NewPC,ConditionCodes_In,ConditionCodes_Out);
        $monitor("At T = %4t,Clk = %b,\n\tInstruction = %20h,\n\ticode = %1h, ifun = %1h, rA = %1h, rB = %1h,\n\tvalC = %3d, valP = %3d, PC = %3d,\n\tInVal Ins = %1b, Address Error = %1b, Halt = %1b,\n\tCondition = %1b,\n\tvalA = %3d, valB = %3d,\n\tvalE = %3d, valM = %3d,\n\trax = %3d,\n\trbx = %3d,\n\trcx = %3d,\n\trdx = %3d,\n\trsp = %3d,\n\trbp = %3d,\n\trsi = %3d,\n\trdi = %3d,\n\tr8 = %3d,\n\tr9 = %3d,\n\tr10 = %3d,\n\tr11 = %3d,\n\tr12 = %3d,\n\tr13 = %3d,\n\tr14 = %3d\n\tDMem Error = %b, NewPC = %3d,\n\tConditionCodes_In = %3b,ConditionCodes_Out = %3b",$time, Clk, Instruction, icode, ifun, rA, rB, valC, valP, PC, INS, ADR, HLT,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,DataMemError,NewPC,ConditionCodes_In,ConditionCodes_Out);
        Clk = 0; PC = 16'h0; //Initialize the Clock and PC to zero
    end

endmodule