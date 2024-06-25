`include "ALU/Logical_And/And.v"
`include "ALU/Adder_and_Subtractor/Adder_Subtractor.v"
`include "ALU/Adder_and_Subtractor/FullAdder.v"
`include "ALU/Logical_Xor/Xor.v"

module ALU (S,In1,In2,OUTPUT,Overflow);
    input [1:0]S;
    input signed [63:0] In1,In2;
    output reg signed[63:0] OUTPUT;
    output reg Overflow;

    wire signed [63:0] OUTPUT_Add,OUTPUT_Sub,OUTPUT_And,OUTPUT_Xor;
    wire Overflow_Add,Overflow_Sub,Overflow_And,Overflow_Xor;

    Adder_Subtractor addition(In1, In2, 1'b0, OUTPUT_Add, Overflow_Add);
    Adder_Subtractor subtraction(In1, In2, 1'b1, OUTPUT_Sub, Overflow_Sub);
    And anding(In1, In2, OUTPUT_And, Overflow_And);
    Xor xoring(In1, In2, OUTPUT_Xor, Overflow_Xor);

    always @(*)
    begin
        case (S)
            2'b00:
                begin
                    OUTPUT = OUTPUT_Add;
                    Overflow = Overflow_Add;
                end
            2'b01:
                begin
                    OUTPUT = OUTPUT_Sub;
                    Overflow = Overflow_Sub;
                end
            2'b10:
                begin
                    OUTPUT = OUTPUT_And;
                    Overflow = Overflow_And;
                end
            2'b11:
                begin
                    OUTPUT = OUTPUT_Xor;
                    Overflow = Overflow_Xor;
                end
        endcase    
    end
endmodule