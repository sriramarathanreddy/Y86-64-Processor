module Memory_tb();
    reg Clk; // Clock
    reg [3:0] icode; // Instruction Code
    reg signed [63:0] valA,valP,valE; // Value decoded from register id, PC Update Value, and ALU Output
    
    wire [63:0] valM; // Data Read from Memory
    wire DataMemError; // Memory Error Signal (to be raised if invalid memory data address is accessed)

    Memory Memory_tb(Clk,icode,valA,valP,valE,valM,DataMemError);

    always begin 
        #10 Clk = ~Clk;
    end

    initial begin
    
        $monitor("At T = %4t\n\t,icode = %1h, valA = %d, valP = %d, valE = %d\n\tvalM = %d, DMemErr = %1b",$time,icode,valA,valP,valE,valM,DataMemError);

        Clk = 0;

        //Imm - Reg Move
        #20; icode = 4'h2 ;
        valA = 124 ; valP = 1253 ; valE = 1284;

        //Reg - Mem Move
        #20; icode = 4'h4 ;
        valA = 732 ; valP = 91 ; valE = 261;
        
        //Mem - Reg Move
        #20; icode = 4'h5 ;
        valA = 8103 ; valP = 1000 ; valE = 422;

        //Call
        #20; icode = 4'h8 ;
        valA = 13 ; valP = 4 ; valE = 124;

        //Return
        #20; icode = 4'h9 ;
        valA = 134 ; valP = 1243 ; valE = 41;

        //Push
        #20; icode = 4'hA ;
        valA = 124 ; valP = 1253 ; valE = 1284;

        //Pop
        #20; icode = 4'hB ;
        valA = 13; valP =  53; valE = 1254;

        //Checker
        // #20; icode = 4'h ; 
        // valA = ; valP = ; valE = ;

        $finish;

    end
endmodule