module Fetch (Clk,icode,ifun,rA,rB,valC,valP,PC,INS/*Invalid Instruction*/,ADR/*Address Error*/,HLT/*Halt*/,Instruction);
    parameter MemSize = 1024;

    input Clk; // Clock
    input [63:0] PC; // Program Counter
    input [0:79] Instruction; // Instruction (can be a maximum of 10 bytes in length: icode=> 1/2, ifun => 1/2, rA => 1/2, rB => 1/2, valC => 8)
    
    output reg [3:0] icode,ifun,rA,rB; // 8 bytes for instruction, registers to store parameters
    output reg signed [63:0] valC; // Destination of Jump
    output reg [63:0] valP; // Update PC value
    output reg HLT = 0,INS = 0,ADR = 0; // Flags (Status Registor)
    
    initial
        $display("Entered Fetch");
    
    always @(posedge Clk) begin
        // if(PC >= MemSize)
        //     ADR = 1;
        icode = Instruction[0:3];
        ifun = Instruction[4:7];
        
        case (icode)
            4'h0: // Halt
                begin
                    HLT = 1;
                    valP = PC+1;
                    if (ifun != 0)
                        INS = 1;
                    else 
                        INS = 0;
                end
            4'h1: // No Operation
                begin
                    valP = PC+1;
                    if (ifun != 0)
                        INS = 1;
                    else 
                        INS = 0;
                end
            4'h2: // cmovxx
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    if (ifun > 6) begin
                            INS = 1;
                            valP = PC + 1;
                    end
                    else begin
                        valP = PC + 2;
                        INS = 0;
                    end
                end
            4'h3: // irmovq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    valC = Instruction[16:79];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                    end
                    else begin
                        valP = PC + 10;
                        INS = 0;
                    end
                end
            4'h4: // rmmovq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    valC = Instruction[16:79];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        valP = PC + 10;
                        INS = 0;
                    end
                end
            4'h5: // mrmovq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    valC = Instruction[16:79];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        valP = PC + 10;
                        INS = 0;
                    end
                end
            4'h6: // Opq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    if (ifun > 4) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        valP = PC + 2;
                        INS = 0;
                    end
                end
            4'h7: // jxx
                begin
                    valC = Instruction[8:71];
                    if (ifun > 6) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        INS = 0;
                        valP = PC + 9;
                    end
                end
            4'h8: // call
                begin
                    valC = Instruction[8:71];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        valP = PC + 9;
                        INS = 0;
                    end
                end
            4'h9: // ret
                begin
                    valP = PC + 1;
                    if (ifun != 0)
                        INS = 1;
                    else
                        INS = 0;
                end
            4'hA: // pushq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        INS = 0;
                        valP = PC + 2;
                    end
                end
            4'hB: // popq
                begin
                    rA = Instruction[8:11];
                    rB = Instruction[12:15];
                    if (ifun != 0) begin
                            INS = 1;
                            valP = PC + 1;
                        end
                    else begin
                        INS = 0;
                        valP = PC + 2;
                    end
                end
            default: // Invalid Instruction
                begin
                    INS = 1;
                end
        endcase    
    end
endmodule