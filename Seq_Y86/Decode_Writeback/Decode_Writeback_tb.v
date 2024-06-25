module Decode_Writeback_tb();
    reg clk,Condition; // Clock and Condition Signal
    reg [3:0] icode,rA,rB; // Outputs from fetch stage Instruction Code and Registers to extract valA and valB
    reg [63:0] valE; // Output of ALU to be written to memory or register
    reg [63:0] valM; // Value read from memory
    
    wire [63:0] valA,valB; // Inputs to ALU from decode stage
    wire [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14; // Register File

    Decode_Writeback Decode_Writeback_tb(clk,icode,rA,rB,Condition,valA,valB,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);

    always begin
        #10 clk = ~clk;
    end

    initial begin
        $monitor("At T = %4t,\n\t icode = %1h, rA = %1h, rB = %1h, valA = %d, valB = %d \n\t Condition = %1b, valE = %d, valM = %d , rax = %d, rbx = %d, rcx = %d, rdx = %d, rsp = %d, rbp = %d, rsi = %d, rdi = %d, r8 = %d, r9 = %d, r10 = %d, r11 = %d, r12 = %d, r13 = %d, r14 = %d",$time, icode,rA,rB,valA,valB,Condition,valE,valM,rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);

        clk = 0;  //Initial

        //Halt
        #20; icode = 4'h0; rA = 4'h4; rB = 4'hd;
            Condition = 1'b1; valE = 11233699228836496574; valM = 11681961979569129357;

        //No Op
        #20; icode = 4'h1; rA = 4'hb ; rB = 4'ha;
            Condition = 1'b0 ; valE = 8305201631521356197 ; valM = 10211683239992122150;

        //Conditional Move
        #20; icode = 4'h2; rA = 4'h8 ; rB = 4'h1;
            Condition = 1'b1 ; valE = 8305201631521356197 ; valM = 11576769314638729384;

        //Imm - Reg Move
        #20; icode = 4'h3; rA = 4'he ; rB = 4'h1;
            Condition = 1'b0 ; valE = 8595184200984314740 ; valM = 6949601727419549188;

        //Reg - Mem Move
        #20; icode = 4'h4; rA = 4'h2 ; rB = 4'hc;
            Condition = 1'b1 ; valE = 18446744073709551628 ; valM = 7276952987114288244;

        //Mem - Reg Move
        #20; icode = 4'h5; rA = 4'hd ; rB = 4'h2;
            Condition = 1'b1 ; valE = 10372616094590529012 ; valM = 12204259632832272261;

        //Arithmetic Operations
        #20; icode = 4'h6; rA = 4'hb ; rB = 4'h0;
            Condition = 1'b1 ; valE = 83185343525611810410 ; valM = 8305201631521356197;

        //Conditional Jump
        #20; icode = 4'h7; rA = 4'h8 ; rB = 4'ha;
            Condition = 1'b1 ; valE = 10211683239992122150 ; valM = 2545604381904918856;

        //Call
        #20; icode = 4'h8; rA = 4'h3 ; rB = 4'h4;
            Condition = 1'b1 ; valE = 7276952987114288244 ; valM = 25311521678492668330;

        //Return
        #20; icode = 4'h9; rA = 4'h5 ; rB = 4'hd;
            Condition = 1'b1 ; valE = 10372616094590529012 ; valM = 13265615713787372605;

        //Push
        #20; icode = 4'ha; rA = 4'h7 ; rB = 4'h4;
            Condition = 1'b1 ; valE = 4531598557225673514 ; valM = 10324523461618334252;

        //Pop
        #20; icode = 4'hb; rA = 4'h1 ; rB = 4'h7;
            Condition = 1'b1 ; valE = 8595184200984314740 ; valM = 8689149341829706189;

        //Checker
        // #10 icode = 4'h ; rA = 4'h ; rB = 4'h ;
        //     Condition = 1'b1 ; valE = ; valM = ;

        $finish;
        
    end
endmodule