`include "ALU.v"

module ALU_tb;
    reg [1:0] S;
    reg [63:0] In1,In2;
    wire [63:0] OUTPUT;
    wire Overflow;

    ALU dut (.S(S),.In1(In1),.In2(In2),.OUTPUT(OUTPUT),.Overflow(Overflow));

    always @(*)
    begin
        if (S == 2'b00)
            $write("Operation Performed is Addition, ");
        else if (S == 2'b01)
            $write("Operation Performed is Subtraction, ");
        else if (S == 2'b10)
            $write("Operation Performed is Logical AND, ");
        else if (S == 2'b11)
            $write("Operation Performed is Logical XOR, ");
    end

    initial
    begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);

        $monitor("at Time = %4t:\nInputs:\n\tS = %2b,\n\tIn1 = %64b (%d),\n\tIn2 = %64b (%d)\nOutputs:\n\tOUT= %64b (%d),\n\tOverflow Bit: = %b",$time, S, In1, In1, In2, In2, OUTPUT, OUTPUT, Overflow);                                                                                                                                                                                                                                                                    

        #2 S = 2'b00; In1 = 64'b0111001001100100010100111011101100111111111000000001101101111101; In2 = 64'b0010010001111110011101001100011110000011011000101101010111010011;
        #2 S = 2'b01; In1 = 64'b0111001001100100010100111011101100111111111000000001101101111101; In2 = 64'b0010010001111110011101001100011110000011011000101101010111010011;
        #2 S = 2'b10; In1 = 64'b0111001001100100010100111011101100111111111000000001101101111101; In2 = 64'b0010010001111110011101001100011110000011011000101101010111010011;
        #2 S = 2'b11; In1 = 64'b0111001001100100010100111011101100111111111000000001101101111101; In2 = 64'b0010010001111110011101001100011110000011011000101101010111010011;

        #2 S = 2'b00; In1 = 64'b1111110100111000111100011110101101011101101000101001111011100000; In2 = 64'b1001111110101111011110011110011011110111101001000001001111010010;
        #2 S = 2'b01; In1 = 64'b1111110100111000111100011110101101011101101000101001111011100000; In2 = 64'b1001111110101111011110011110011011110111101001000001001111010010;
        #2 S = 2'b10; In1 = 64'b1111110100111000111100011110101101011101101000101001111011100000; In2 = 64'b1001111110101111011110011110011011110111101001000001001111010010;
        #2 S = 2'b11; In1 = 64'b1111110100111000111100011110101101011101101000101001111011100000; In2 = 64'b1001111110101111011110011110011011110111101001000001001111010010;

        #2 S = 2'b00; In1 = 64'b0011001000101000011001001100111110101011101000100100010100000110; In2 = 64'b1110110011110111001001111111000111011001100100110000011100100000;
        #2 S = 2'b01; In1 = 64'b0011001000101000011001001100111110101011101000100100010100000110; In2 = 64'b1110110011110111001001111111000111011001100100110000011100100000;
        #2 S = 2'b10; In1 = 64'b0011001000101000011001001100111110101011101000100100010100000110; In2 = 64'b1110110011110111001001111111000111011001100100110000011100100000;
        #2 S = 2'b11; In1 = 64'b0011001000101000011001001100111110101011101000100100010100000110; In2 = 64'b1110110011110111001001111111000111011001100100110000011100100000;

        #2 S = 2'b00; In1 = 64'b1001101111111111101111000010010010111110101111001100111110110101; In2 = 64'b0000100110011010110110101001101000011101100101100111101111100101;
        #2 S = 2'b01; In1 = 64'b1001101111111111101111000010010010111110101111001100111110110101; In2 = 64'b0000100110011010110110101001101000011101100101100111101111100101;
        #2 S = 2'b10; In1 = 64'b1001101111111111101111000010010010111110101111001100111110110101; In2 = 64'b0000100110011010110110101001101000011101100101100111101111100101;
        #2 S = 2'b11; In1 = 64'b1001101111111111101111000010010010111110101111001100111110110101; In2 = 64'b0000100110011010110110101001101000011101100101100111101111100101;

        #2 S = 2'b00; In1 = 64'b0100110110111101010000100001111001010110011010100101000110011101; In2 = 64'b1001000101100100100110001010111011100011010010011111100010101000;
        #2 S = 2'b01; In1 = 64'b0100110110111101010000100001111001010110011010100101000110011101; In2 = 64'b1001000101100100100110001010111011100011010010011111100010101000;
        #2 S = 2'b10; In1 = 64'b0100110110111101010000100001111001010110011010100101000110011101; In2 = 64'b1001000101100100100110001010111011100011010010011111100010101000;
        #2 S = 2'b11; In1 = 64'b0100110110111101010000100001111001010110011010100101000110011101; In2 = 64'b1001000101100100100110001010111011100011010010011111100010101000;

        #2 S = 2'b00; In1 = 64'b1110101010100110101100110010100000101110010001100100010111000111; In2 = 64'b0111011110000011110111011000011101000011001001110101100101010011;
        #2 S = 2'b01; In1 = 64'b1110101010100110101100110010100000101110010001100100010111000111; In2 = 64'b0111011110000011110111011000011101000011001001110101100101010011;
        #2 S = 2'b10; In1 = 64'b1110101010100110101100110010100000101110010001100100010111000111; In2 = 64'b0111011110000011110111011000011101000011001001110101100101010011;
        #2 S = 2'b11; In1 = 64'b1110101010100110101100110010100000101110010001100100010111000111; In2 = 64'b0111011110000011110111011000011101000011001001110101100101010011;

        #2 S = 2'b00; In1 = 64'b1101011110111111101111100101011101101110101101100001110010101001; In2 = 64'b1011111001001110001111111101001010011100011111010010011011101100;
        #2 S = 2'b01; In1 = 64'b1101011110111111101111100101011101101110101101100001110010101001; In2 = 64'b1011111001001110001111111101001010011100011111010010011011101100;
        #2 S = 2'b10; In1 = 64'b1101011110111111101111100101011101101110101101100001110010101001; In2 = 64'b1011111001001110001111111101001010011100011111010010011011101100;
        #2 S = 2'b11; In1 = 64'b1101011110111111101111100101011101101110101101100001110010101001; In2 = 64'b1011111001001110001111111101001010011100011111010010011011101100;

        #2 S = 2'b00; In1 = 64'b1100111000101010000101101100000110111110100010100111111001011011; In2 = 64'b1010011101100001110111100101110001011100011101010101100110011101;
        #2 S = 2'b01; In1 = 64'b1100111000101010000101101100000110111110100010100111111001011011; In2 = 64'b1010011101100001110111100101110001011100011101010101100110011101;
        #2 S = 2'b10; In1 = 64'b1100111000101010000101101100000110111110100010100111111001011011; In2 = 64'b1010011101100001110111100101110001011100011101010101100110011101;
        #2 S = 2'b11; In1 = 64'b1100111000101010000101101100000110111110100010100111111001011011; In2 = 64'b1010011101100001110111100101110001011100011101010101100110011101;

        #2 S = 2'b00; In1 = 64'b1000111000101100101010001011011100011011010100000111010100011000; In2 = 64'b0000101101010000010101000111011001001011100101001011011111101100;
        #2 S = 2'b01; In1 = 64'b1000111000101100101010001011011100011011010100000111010100011000; In2 = 64'b0000101101010000010101000111011001001011100101001011011111101100;
        #2 S = 2'b10; In1 = 64'b1000111000101100101010001011011100011011010100000111010100011000; In2 = 64'b0000101101010000010101000111011001001011100101001011011111101100;
        #2 S = 2'b11; In1 = 64'b1000111000101100101010001011011100011011010100000111010100011000; In2 = 64'b0000101101010000010101000111011001001011100101001011011111101100;

        #2 S = 2'b00; In1 = 64'b1111100101101110010110000111010101010000101100000100101101001000; In2 = 64'b0011100101010001101110011110101011100101000101101000100111110011;
        #2 S = 2'b01; In1 = 64'b1111100101101110010110000111010101010000101100000100101101001000; In2 = 64'b0011100101010001101110011110101011100101000101101000100111110011;
        #2 S = 2'b10; In1 = 64'b1111100101101110010110000111010101010000101100000100101101001000; In2 = 64'b0011100101010001101110011110101011100101000101101000100111110011;
        #2 S = 2'b11; In1 = 64'b1111100101101110010110000111010101010000101100000100101101001000; In2 = 64'b0011100101010001101110011110101011100101000101101000100111110011;

        #2 $finish;
    end
endmodule