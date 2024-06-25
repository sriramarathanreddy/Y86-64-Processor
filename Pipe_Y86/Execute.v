`include "ALU/ALU.v"

module Execute
(
    input clk,
    input [3:0] E_stat,
    input [3:0] E_icode,
    input [3:0] E_ifun,
    input [63:0] E_valA,
    input [63:0] E_valB,
    input [63:0] E_valC,
    input [3:0] E_dstE,
    input [3:0] E_dstM,
    input [3:0] W_stat,
    input [3:0] m_stat,

    output reg [3:0] e_stat,
    output reg [3:0] e_icode,
    output reg e_cnd,
    output reg [63:0] e_valE,
    output reg [63:0] e_valA,
    output reg [3:0] e_dstE,
    output reg [3:0] e_dstM
);
    reg [1:0]  S;
    reg [63:0] In1,In2;

    wire [63:0] OUTPUT;
    wire Overflow;

    reg [2:0] ConditionCodes; // as Zero Flag, Sign Flag, Overflow Flag

    ALU ALU1(S,In1,In2,OUTPUT,Overflow);


    always @* begin
        // Resetting values
        e_icode = E_icode;
        e_stat  = E_stat ;
        e_valA  = E_valA ;
        e_dstM  = E_dstM ;
        e_cnd   = 0;

        e_dstE = E_dstE; // Default value
        
        // Compute ALU operation based on E_icode
        case(E_icode)
            4'h2:
                begin
                    S = 0;
                    In1 = E_valA;
                    In2 = 0;
                    // Calculate condition code
                    case(E_ifun)
                        4'h0: e_cnd = 1;
                        4'h1: e_cnd = ((ConditionCodes[1]^ConditionCodes[2]) || ConditionCodes[0]);
                        4'h2: e_cnd = ((ConditionCodes[1]^ConditionCodes[2]));
                        4'h3: e_cnd = ConditionCodes[0];
                        4'h4: e_cnd = ~ConditionCodes[0];
                        4'h5: e_cnd = ~(ConditionCodes[1]^ConditionCodes[2]);
                        4'h6: e_cnd = ~(((ConditionCodes[1]^ConditionCodes[2]) || ConditionCodes[0]));
                    endcase
                    if(!e_cnd)
                        e_dstE = 4'b1111;
                end
            4'h3:
                begin
                    S = 0;
                    In1 = E_valC;
                    In2 = 0;
                end
            4'h4:
                begin
                    S = 0;
                    In1 = E_valB;
                    In2 = E_valC;
                end
            4'h5:
                begin
                    S = 0;
                    In1 = E_valC;
                    In2 = E_valB;
                end
                
            4'h6:
                begin
                    S = E_ifun[1:0];
                    In1 = E_valB;
                    In2 = E_valA;

                    // Compute condition codes
                    ConditionCodes[0] = (In1 == In2);
                    ConditionCodes[1] = (OUTPUT[63] == 1);
                    ConditionCodes[2] = Overflow;
                end
            4'h7:
                begin
                    case(E_ifun)
                        4'h0: e_cnd = 1;
                        4'h1: e_cnd = ((ConditionCodes[1]^ConditionCodes[2]) || ConditionCodes[0]);
                        4'h2: e_cnd = ((ConditionCodes[1]^ConditionCodes[2]));
                        4'h3: e_cnd = ConditionCodes[0];
                        4'h4: e_cnd = ~ConditionCodes[0];
                        4'h5: e_cnd = ~(ConditionCodes[1]^ConditionCodes[2]);
                        4'h6: e_cnd = ~(((ConditionCodes[1]^ConditionCodes[2]) || ConditionCodes[0]));
                    endcase
                end
            4'h8, 4'h9, 4'hA, 4'hB:
                begin
                    S = (E_icode == 4'h8 || E_icode == 4'hA) ? 1 : 0; // Set subtraction for E_icode 8 and A
                    In1 = (E_icode == 4'h9 || E_icode == 4'hB) ? 64'd1 : E_valB; // Set In1 to 1 for E_icode 9 and B
                    In2 = (E_icode == 4'h9 || E_icode == 4'hB) ? E_valB : 64'd1; // Set In2 to 1 for E_icode 9 and B
                end
        endcase
        // Update e_valE with ALU output
        e_valE = OUTPUT; 
    end
endmodule
