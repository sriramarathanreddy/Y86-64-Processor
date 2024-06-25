module F_Reg
(
    input clk,
    input F_stall,
    input [63:0] predPC, F_PC,

    output reg [63:0] F_predPC
);
    always @(posedge clk) F_predPC <= F_stall ? F_PC : predPC;
endmodule