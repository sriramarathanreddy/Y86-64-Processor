module Memory(Clk,icode,valA,valP,valE,valM,DataMemError);
    
    parameter MemSize = 20;
    
    input Clk; // Clock
    input [3:0] icode; // Instruction Code
    input signed [63:0] valA,valP,valE; // Value decoded from register id, PC Update Value, and ALU Output
    
    output reg [63:0] valM; // Data Read from Memory
    output reg DataMemError; // Memory Error Signal (to be raised if invalid memory data address is accessed)

    reg [63:0] DataMemory[0:19];
    initial begin
        $display("Entered Memory");
    end
    
    // ***** Checking for Memory Error ***** //
    reg isvalE,isvalA;

    always @(*) begin
        if (icode == 4'h4 || icode == 4'h5 || icode == 4'h8 || icode == 4'hA) begin
            isvalE = 1; // valE is required for rmmovq(4), mrmovq(5), call(8), pushq(A)
            isvalA = 0;
        end
        else if (icode == 4'h9 || icode == 4'hB) begin
            isvalA = 1; // valA is required for ret(9), popq(B)
            isvalE = 0;
        end
        else begin
            isvalE = 0; // Remaining instructions do not require memory access. So set them to zero
            isvalA = 0;
        end
    end

    always @(*) begin
        if ((isvalE == 1 && valE >= MemSize) || (isvalA == 1 && valA >= MemSize)) // Accessing Out of Bounds data
            DataMemError = 1;
        else
            DataMemError = 0;
    end
    
    // ***** Reading and Writing to Memory ***** //
    always @(*) begin
        case (icode)
            4'h4: // rmmovq
                    DataMemory[valE] = valA;
            4'h5: // mrmovq
                valM = DataMemory[valE];
            4'h8: // call
                DataMemory[valE] = valP;
            4'h9: // ret
                valM = DataMemory[valA];
            4'hA: // pushq
                DataMemory[valE] = valA;
            4'hB: // popq
                begin
                    valM = DataMemory[valA];
                end
        endcase    
    end

    always @(Clk) begin
        $display("\n\tMemory Value = %3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d,%3d",DataMemory[0],DataMemory[1],DataMemory[2],DataMemory[3],DataMemory[4],DataMemory[5],DataMemory[6],DataMemory[7],DataMemory[8],DataMemory[9],DataMemory[10],DataMemory[11],DataMemory[12],DataMemory[13],DataMemory[14],DataMemory[15],DataMemory[16],DataMemory[17],DataMemory[18],DataMemory[19]);
    end
endmodule