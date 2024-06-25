// `include "FullAdder.v"
module Adder_Subtractor (In1,In2,Mode,Sum,Overflow);
    parameter N = 64;
    input signed [N-1:0] In1,In2;
    input Mode;
    output signed [N-1:0] Sum;
    output Overflow;

    wire [N-1:0] In2Comp;
    wire [N:0] Carry;
    assign Carry[0] = Mode;

    genvar j;
    generate
        for (j = 0; j < N; j = j + 1)
            xor x1(In2Comp[j], Mode, In2[j]);
    endgenerate
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1)
        begin
            FullAdder f1(In1[i], In2Comp[i], Carry[i], Carry[i+1], Sum[i]);
        end
    endgenerate
    
    xor x2(Overflow, Carry[N-1], Carry[N]);
endmodule