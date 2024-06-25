module Memory(clk, M_stat, M_icode, M_valE, M_valA, M_dstE, M_dstM ,m_stat, m_icode, m_valE, m_valM, m_dstE, m_dstM, DataMemError);
    parameter MemSize = 2048;
    input clk;
    input wire [3:0] M_stat, M_icode, M_dstE, M_dstM;
    input wire [63:0] M_valE ,M_valA;

    reg isvalA,isvalE;

    output reg [63:0] m_valE, m_valM;
    output reg DataMemError;
    output reg [3:0] m_stat, m_icode, m_dstE, m_dstM;

    reg [63:0] memory [0:MemSize-1]; // 1KB

    always @(*) begin
        if (m_icode == 4'h4 || m_icode == 4'h5 || m_icode == 4'h8 || m_icode == 4'hA) begin
            isvalE = 1; // valE is required for rmmovq(4), mrmovq(5), call(8), pushq(A)
            isvalA = 0;
        end
        else if (m_icode == 4'h9 || m_icode == 4'hB) begin
            isvalA = 1; // valA is required for ret(9), popq(B)
            isvalE = 0;
        end
        else begin
            isvalE = 0; // Remaining instructions do not require memory access. So set them to zero
            isvalA = 0;
        end
    end

    always @(*) begin
        if ((isvalE == 1 && M_valE >= MemSize) || (isvalA == 1 && M_valA >= MemSize)) // Accessing Out of Bounds data
            DataMemError = 1;
        else
            DataMemError = 0;
    end

    always@(clk) begin
        $display("\tMemory = %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d",memory[0],memory[1],memory[2],memory[3],memory[4],memory[5],memory[6],memory[7],memory[8],memory[9]);
    end
    
    always@(*) begin
        case(M_icode)
            4'b0100: // rmmovq
                    memory[M_valE]=M_valA;            
            4'b1010: // pushq
                    memory[M_valE]=M_valA;
            4'b1000: // call
                    memory[M_valE]=M_valA;
            4'b0101: // mrmovq
                    m_valM=memory[M_valE];
            4'b1011: // popq
                    m_valM=memory[M_valA];
            4'b1001: // ret
                    m_valM=memory[M_valA];
        endcase
    end

    always@(*) begin
            m_stat  <= M_stat;
            m_icode <= M_icode;
            m_dstE  <= M_dstE;
            m_dstM  <= M_dstM;
            m_valE  <= M_valE;
    end

endmodule