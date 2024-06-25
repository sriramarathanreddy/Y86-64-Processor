module Fetch_tb();
    reg clk; // Clock
    reg [63:0] PC; // Program Counter
    reg [0:79] Instruction; // Instruction (can be a maximum of 10 bytes in length: icode=> 1/2, ifun => 1/2, rA => 1/2, rB => 1/2, valC => 8)
    
    wire [3:0] icode,ifun,rA,rB; // 8 bytes for instruction, registers to store parameters
    wire signed [63:0] valC,valP;// Destination of Jump, Update PC value
    wire HLT, INS ,ADR; // Flags (Status Registor)
    
    Fetch Fetch_tb(clk,icode,ifun,rA,rB,valC,valP,PC,INS,ADR,HLT,Instruction);

    always begin
        #10 clk = ~clk;
    end

    initial begin

        $monitor("At T = %4t,\n\tInstruction = %20h,\n\ticode = %1h, ifun = %1h, rA = %1h, rB = %1h, valC = %16h, valP = %16h, PC = %16h, InVal Ins = %1b, Address Error = %1b, Halt = %1b,",$time, Instruction, icode, ifun, rA, rB, valC, valP, PC, INS, ADR, HLT);

        clk = 0; PC = 16'h0; //Initial

        //Halt
        // #20; Instruction = 80'h00AD7392650AB73E8BCE;
        
        //No Operation
        #20; Instruction = 80'h104842BE8DC9A28D9CE2;

        //Conditional Move
        #20; Instruction = 80'h208ef729cba74d6c92bc;
        #20; Instruction = 80'h21784bac590e2c7d0b47;
        #20; Instruction = 80'h228bc5420cea7b08a479;
        #20; Instruction = 80'h237b8dbc90e27d04b4ac;
        #20; Instruction = 80'h244a50bc27e0394aeb7c;
        #20; Instruction = 80'h258cecbd5b375a85c869;
        #20; Instruction = 80'h268bc9eab567cd742ec2;

        //Imm - Reg Move
        #20; Instruction = 80'h3075239bce834dab49ec;

        //Reg - Mem Move
        #20; Instruction = 80'h407529bee639bcea9d9e;
        
        //Mem - Reg Move
        #20; Instruction = 80'h50739bce027ace484a4c;

        //Arithmetic Operations
        #20; Instruction = 80'h608ef729cba74d6c92bc;
        #20; Instruction = 80'h61784bac590e2c7d0b47;
        #20; Instruction = 80'h628bc5420cea7b08a479;
        #20; Instruction = 80'h637b8dbc90e27d04b4ac;

        //Conditional Jump
        #20; Instruction = 80'h708ef729cba74d6c92bc;
        #20; Instruction = 80'h71784bac590e2c7d0b47;
        #20; Instruction = 80'h728bc5420cea7b08a479;
        #20; Instruction = 80'h737b8dbc90e27d04b4ac;
        #20; Instruction = 80'h744a50bc27e0394aeb7c;
        #20; Instruction = 80'h758cecbd5b375a85c869;
        #20; Instruction = 80'h768bc9eab567cd742ec2;

        //Call
        #20; Instruction = 80'h808bc5420cea7b08a479;

        //Return
        #20; Instruction = 80'h9079b394ce4b0ce67907;

        //Push
        #20; Instruction = 80'hA07b8dbc90e27d04b4ac;

        //Pop
        #20; Instruction = 80'hB08bc9eab567cd742ec2;

        //Checker
        #20; Instruction = 80'hA18cecbd5b375a85c869;

        $finish;

    end
endmodule