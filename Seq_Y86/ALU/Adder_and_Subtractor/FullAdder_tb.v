`include "FullAdder.v"

module FullAdder_tb;
    reg A,B,Cin;
    wire Cout,Sum;

    FullAdder x1(.A(A), .B(B), .Cin(Cin), .Cout(Cout), .Sum(Sum));

    initial begin
        $dumpfile("FullAdder.vcd");
        $dumpvars(0, FullAdder_tb);

        $monitor("At Time = %2t: A = %d, B = %d, Cin = %d, Cout = %d, Sum = %d", $time, A, B, Cin, Cout, Sum);
        
        #2 A = 0;B = 0;Cin = 0; /*Ans: Cout = 0,Sum = 0*/
        #2 A = 0;B = 0;Cin = 1; /*Ans: Cout = 0,Sum = 1*/
        #2 A = 0;B = 1;Cin = 0; /*Ans: Cout = 0,Sum = 1*/
        #2 A = 0;B = 1;Cin = 1; /*Ans: Cout = 1,Sum = 0*/
        #2 A = 1;B = 0;Cin = 0; /*Ans: Cout = 0,Sum = 1*/
        #2 A = 1;B = 0;Cin = 1; /*Ans: Cout = 1,Sum = 0*/
        #2 A = 1;B = 1;Cin = 0; /*Ans: Cout = 1,Sum = 0*/
        #2 A = 1;B = 1;Cin = 1; /*Ans: Cout = 1,Sum = 1*/
        #2 $finish;
    end
endmodule