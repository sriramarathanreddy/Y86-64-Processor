module Decode_Writeback (Clk,icode,ifun,rA,rB,Condition,valA,valB,valE,valM,
                         rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14);
    input Clk,Condition; // Clock and Condition Signal
    input [3:0] icode,ifun,rA,rB; // Outputs from fetch stage Instruction Code and Registers to extract valA and valB
    input signed [63:0] valE; // Output of ALU to be written to memory or register
    input [63:0] valM; // Value read from memory
    
    output reg signed [63:0] valA,valB; // Inputs to ALU from decode stage
    output reg [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14; // Register File

    reg [63:0] TempMem[0:14];

    initial
        $display("Entered Decode");

    initial begin
        TempMem[0] = 64'd0;   // rax
        TempMem[1] = 64'd1;   // rcx
        TempMem[2] = 64'd2;   // rdx
        TempMem[3] = 64'd3;   // rbx
        TempMem[4] = 64'd4;// rsp
        TempMem[5] = 64'd5;   // rbp
        TempMem[6] = 64'd6;   // rsi
        TempMem[7] = 64'd7;   // rdi
        TempMem[8] = 64'd8;   // r8
        TempMem[9] = 64'd9;   // r9
        TempMem[10] = 64'd10; // r10
        TempMem[11] = 64'd11; // r11
        TempMem[12] = 64'd12; // r12
        TempMem[13] = 64'd13; // r13
        TempMem[14] = 64'd14; // r14
    end

    // ***** Decode Stage ***** //
    always @(*) begin
        case (icode)
            4'h2: // cmovxx
                begin
                    valA = TempMem[rA];
                    valB = 64'd0;
                end
            4'h3: // irmovq
                // valA = valC;
                valB = 64'd0;
            4'h4: // rmmovq
                begin
                    valA = TempMem[rA];
                    valB = TempMem[rB];
                end
            4'h5: // mrmovq
                // valA = valC;
                valB = TempMem[rB];
            4'h6: // Opq
                begin
                    valA = TempMem[rA];
                    valB = TempMem[rB];
                end
            4'h8: // call
                // valA = -8;
                valB = TempMem[4];
            4'h9: // ret
                begin
                    valA = TempMem[4];
                    valB = TempMem[4];
                end
            4'hA: // pushq
                begin
                    valA = TempMem[rA];
                    valB = TempMem[4];
                end
            4'hB: // popq
                begin
                    valA = TempMem[4];
                    valB = TempMem[4];
                end
            // For call, ret, pushq and popq, valB is used to update stack pointer. So are taken from %rsp.
        endcase
    end

    // ***** Writeback Stage ***** //
    initial
        $display("Entered Writeback");
    
    always @(negedge Clk) begin
        case (icode)
            4'h2: // cmovxx
                begin
                    if (Condition)
                        TempMem[rB] = valE;
                end
            4'h3: // irmovq
                begin
                    TempMem[rB] = valE;
                end
            4'h5: // mrmovq
                begin
                    TempMem[rA] = valM;
                end
            4'h6: // Opq
                begin
                    TempMem[rB] = valE;
                end
            4'h8: // call
                begin
                    TempMem[4] = valE;
                end
            4'h9: // ret
                begin
                    TempMem[4] = valE;
                end
            4'hA: // pushq
                begin
                    TempMem[4] = valE;
                end
            4'hB: // popq
                begin
                    TempMem[4] = valE;
                    TempMem[rA] = valM;
                end
        endcase

        rax = TempMem[0];
        rcx = TempMem[1];
        rdx = TempMem[2];
        rbx = TempMem[3];
        rsp = TempMem[4];
        rbp = TempMem[5];
        rsi = TempMem[6];
        rdi = TempMem[7];
        r8  = TempMem[8];
        r9  = TempMem[9];
        r10 = TempMem[10];
        r11 = TempMem[11];
        r12 = TempMem[12];
        r13 = TempMem[13];
        r14 = TempMem[14];
    end
endmodule