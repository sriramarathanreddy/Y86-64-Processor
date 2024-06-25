module FullAdder (
    input A, B, Cin,
    output Cout, Sum
);
    wire w1, w2, w3;

    xor x1(Sum, A, B, Cin);
    
    and x2(w1, A, B);
    and x3(w2, Cin, B);
    and x4(w3, A, Cin);
    
    or x5(Cout, w1, w2, w3);
endmodule