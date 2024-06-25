module PC_Update(Clk,icode,Condition,valC,valM,valP,PC);
    
    input Clk,Condition; // Clock and Condition Signal
    input [3:0] icode; // Instruction Code
    input signed [63:0] valC,valM; // Value decoded from register id, and data read from memory
    input  [63:0] valP; // PC Update Value
    output reg [63:0] PC; // Program Counter
    initial begin
        $display("Entered PC");
    end
    always @(*) begin
        case (icode)
            4'h7: // jxx
                PC = Condition?valC:valP;
            4'h8: // call
                PC = valC;
            4'h9: // ret
                PC = valM;
            default: // Remaining instructions take valP as PC Update
                PC = valP;
        endcase    
    end
endmodule