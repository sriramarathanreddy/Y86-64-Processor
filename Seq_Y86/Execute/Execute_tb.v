module Execute_tb();
    reg clk; // Clock
    reg [3:0] icode,ifun; // Instruction Code and Function Code to berformed
    reg [63:0] valA,valB,valC; // Inputs to ALU
    reg [2:0] CondititonCodes_In;

    wire [63:0] valE; // Output of ALU
    wire Condition; // Condition Signal to be used in Conditional Move and Conditional Jump
    wire [2:0] CondititonCodes_Out;

    Execute Execute_tb(clk,icode,ifun,valA,valB,valC,valE,Condition,CondititonCodes_In,CondititonCodes_Out);

    always begin
        #10 clk = ~clk;
    end

    initial begin
        $monitor("At T = %4t,\n\ticode = %1h, ifun = %1h, valA = %d, valB = %d, valC = %d, CC_In = %3b\n\tvalE = %d, Condition = %1b, CC_Out = %3b",$time,icode,ifun,valA,valB,valC,CondititonCodes_In,valE,Condition,CondititonCodes_Out);

        clk = 0;
        
        //Conditional Move
        #20; icode = 4'h2 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ;
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ; 

        #20; icode = 4'h2 ; ifun = 4'h1 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ; 
        
        #20; icode = 4'h2 ; ifun = 4'h2 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ;
        
        #20; icode = 4'h2 ; ifun = 4'h3 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ;
        
        #20; icode = 4'h2 ; ifun = 4'h4 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ;
        
        #20; icode = 4'h2 ; ifun = 4'h5 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ;

        #20; icode = 4'h2 ; ifun = 4'h6 ; CondititonCodes_In = 3'b000 ; 
        valA = 15686049516996210692 ; valB = 8305201631521356197 ; valC = 10211683239992122150 ;

        //Imm - Reg Move
        #20; icode = 4'h3 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 2545604381904918856 ; valB = 8195456806703676293 ; valC = 4531598557225673514 ;

        //Reg - Mem Move
        #20; icode = 4'h4 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 2548618866013362580 ; valB = 8377612678370507997 ; valC = 2601896683644409162 ;

        //Mem - Reg Move
        #20; icode = 4'h5 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 13415710752668321835 ; valB = 11576769314638729384 ; valC = 2601896683644409162 ;

        //Arithmetic Operations
        #20; icode = 4'h6 ; ifun = 4'h0 ; CondititonCodes_In = 3'b010 ; 
        valA = 10211683239992122150 ; valB = 2545604381904918856 ; valC = 2548618866013362580 ;

        #20; icode = 4'h6 ; ifun = 4'h1 ; CondititonCodes_In = 3'b001 ; 
        valA = 10211683239992122150 ; valB = 2545604381904918856 ; valC = 2548618866013362580 ;

        #20; icode = 4'h6 ; ifun = 4'h2 ; CondititonCodes_In = 3'b100 ; 
        valA = 10211683239992122150 ; valB = 2545604381904918856 ; valC = 2548618866013362580 ;

        #20; icode = 4'h6 ; ifun = 4'h3 ; CondititonCodes_In = 3'b110 ; 
        valA = 10211683239992122150 ; valB = 2545604381904918856 ; valC = 2548618866013362580 ;

        //Call
        #20; icode = 4'h8 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 2906480981508559908 ; valB = 8305201631521356197 ; valC = 16434942197326524573 ;

        //Return
        #20; icode = 4'h9 ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 2039589541697790346 ; valB = 2548618866013362580 ; valC = 2545604381904918856 ;

        //Push
        #20; icode = 4'hA ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 3219358289493549932 ; valB = 3219244442442772696 ; valC = 17278588888214152940 ; 

        //Pop
        #20; icode = 4'hB ; ifun = 4'h0 ; CondititonCodes_In = 3'b000 ; 
        valA = 18446744073709551628 ; valB = 17278588888214152940 ; valC = 4531598557225673514 ; 

        //Checker
        // #20; icode = 4'h ; ifun = 4'h ; CondititonCodes_In = 3'b ; 
        // valA =  ; valB =  ; valC =  ;

        $finish;
           
    end

endmodule