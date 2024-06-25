module PC_Update_tb();
    reg Clk,Condition; // Clock and Condition Signal
    reg [3:0] icode; // Instruction Code
    reg [63:0] valC,valP,valM; // Value decoded from register id, PC Update Value, and data read from memory

    wire [63:0] PC; // Program Counter

    PC_Update PC_Update_tb(Clk,icode,Condition,valC,valM,valP,PC);

    always begin
        #10 Clk = ~Clk;
    end

    initial begin
        $monitor("At T = %4t,\n\ticode = %1h, Condition = %1b, valC = %d, valP = %d, valM = %d,\n\tPC = %d",$time,icode,Condition,valC,valP,valM,PC);

        Clk = 0; 

        #20; icode = 4'h5; Condition = 1'b0;
        valC = 10211683239992122109 ; valP = 10372616094590529012 ; valM = 10211683239992122150 ;

        #20; icode = 4'h7; Condition = 1'b0;
        valC = 11233699228836496516 ; valP = 10211683239992122109 ; valM = 10340227422010646612 ;

        #20; icode = 4'h7; Condition = 1'b1;
        valC = 11233699228836496516 ; valP = 11233699228836496516 ; valM = 10211683239992122109 ;

        #20; icode = 4'h8; Condition = 1'b0;
        valC = 35308702996967868165 ; valP = 11681961979569129325 ; valM = 8305201631521356197 ;

        #20; icode = 4'h9; Condition = 1'b0;
        valC = 10211683239992122150 ; valP = 8595184200984314740 ; valM = 11576769314638729381 ;

        
    
        $finish;
    end

endmodule