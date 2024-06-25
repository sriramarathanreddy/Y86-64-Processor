`include "Fetch/Fetch.v"
`include "Decode_Writeback/Decode_Writeback.v"

module f_wb_tb;
    reg Clk; // Clock
    reg [63:0] PC; // Program Counter
    reg [0:79] Instruction; // Instruction (can be a maximum of 10 bytes in length: icode=> 1/2, ifun => 1/2, rA => 1/2, rB => 1/2, valC => 8)
    
    wire [3:0] icode,ifun,rA,rB; // 8 bytes for instruction, registers to store parameters
    wire signed [63:0] valC,valP;// Destination of Jump, Update PC value
    wire HLT, INS ,ADR; // Flags (Status Registor)

    wire Condition = 1; // Clock and Condition Signal
    // reg [3:0] icode,rA,rB; // Outputs from fetch stage Instruction Code and Registers to extract valA and valB
    wire [63:0] valE; // Output of ALU to be written to memory or register
    wire [63:0] valM; // Value read from memory
    
    wire [63:0] valA,valB; // Inputs to ALU from decode stage
    wire [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14; // Register File

    Fetch f_wb_tb(Clk,icode,ifun,rA,rB,valC,valP,PC,INS/*Invalid Instruction*/,ADR/*Address Error*/,HLT/*Halt*/,Instruction);
    Decode_Writeback f_wb_tb_2(Clk,icode,rA,rB,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);

    always begin
        #10 Clk = ~Clk;  
    end 

    initial begin
    
        $monitor("At T = %4t,\n\tInstruction = %20h,\n\ticode = %1h, ifun = %1h, rA = %1h, rB = %1h,\n valC = %16h, valP = %16h, PC = %16h, InVal Ins = %1b, Address Error = %1b, Halt = %1b,\nCondition = %1b, valA = %d, valB = %d ,valE = %d, valM = %d , rax = %d, rbx = %d, rcx = %d, rdx = %d, rsp = %d, rbp = %d, rsi = %d, rdi = %d, r8 = %d, r9 = %d, r10 = %d, r11 = %d, r12 = %d, r13 = %d, r14 = %d",$time, Instruction, icode, ifun, rA, rB, valC, valP, PC, INS, ADR, HLT,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);

        Clk = 0; PC = 16'h0; //Initial

        //Halt
        // #40; Instruction = 80'h00AD7392650AB73E8BCE;
        
        //No Operation
        #40; Instruction = 80'h104842BE8DC9A28D9CE2;

        //Conditional Move
        #40; Instruction = 80'h208ef729cba74d6c92bc;
        #40; Instruction = 80'h21784bac590e2c7d0b47;
        #40; Instruction = 80'h228bc5420cea7b08a479;
        #40; Instruction = 80'h237b8dbc90e27d04b4ac;
        #40; Instruction = 80'h244a50bc27e0394aeb7c;
        #40; Instruction = 80'h258cecbd5b375a85c869;
        #40; Instruction = 80'h268bc9eab567cd742ec2;

        //Imm - Reg Move
        #40; Instruction = 80'h3075239bce834dab49ec;

        //Reg - Mem Move
        #40; Instruction = 80'h407529bee639bcea9d9e;
        
        //Mem - Reg Move
        #40; Instruction = 80'h50739bce027ace484a4c;

        //Arithmetic Operations
        #40; Instruction = 80'h608ef729cba74d6c92bc;
        #40; Instruction = 80'h61784bac590e2c7d0b47;
        #40; Instruction = 80'h628bc5420cea7b08a479;
        #40; Instruction = 80'h637b8dbc90e27d04b4ac;

        //Conditional Jump
        #40; Instruction = 80'h708ef729cba74d6c92bc;
        #40; Instruction = 80'h71784bac590e2c7d0b47;
        #40; Instruction = 80'h728bc5420cea7b08a479;
        #40; Instruction = 80'h737b8dbc90e27d04b4ac;
        #40; Instruction = 80'h744a50bc27e0394aeb7c;
        #40; Instruction = 80'h758cecbd5b375a85c869;
        #40; Instruction = 80'h768bc9eab567cd742ec2;

        //Call
        #40; Instruction = 80'h808bc5420cea7b08a479;

        //Return
        #40; Instruction = 80'h9079b394ce4b0ce67907;

        //Push
        #40; Instruction = 80'hA07b8dbc90e27d04b4ac;

        //Pop
        #40; Instruction = 80'hB08bc9eab567cd742ec2;

        //Checker
        #40; Instruction = 80'hA18cecbd5b375a85c869;

        $finish;
    end

endmodule