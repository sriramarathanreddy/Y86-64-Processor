`include "ALU/ALU.v"

module Execute(Clk,icode,ifun,valA,valB,valC,valE,Condition,ConditionCodes_In,ConditionCodes_Out);
    input Clk; // Clock
    input [3:0] icode,ifun; // Instruction Code and Function Code to berformed
    input [0:2] ConditionCodes_In; // 3 bits of Condition codes indicates Zero Flag, Sign Flag, and Overflow Flag respectively used to update Condition Signal
    input signed [63:0] valA,valB,valC; // Inputs to ALU

    output reg signed [63:0] valE; // Output of ALU
    output reg Condition = 1'b1; // Condition Signal to be used in Conditional Move and Conditional Jump
    output reg [0:2] ConditionCodes_Out; // 3 bits of Condition codes indicates Zero Flag, Sign Flag, and Overflow Flag respectively which are updated only in Opq stage

    wire [63:0] valE_adder,valE_addC,valE_op,valE_inc,valE_dec;
    wire OF_adder,OF_addC,OF_op,OF_inc,OF_dec;

    initial begin
        $display("Entered Execute");
    end

    ALU adder(2'b00,valB,valA,valE_adder,OF_adder);
    ALU add_valC(2'b00,valC,valB,valE_addC,OF_addC);
    ALU Operation(ifun[1:0],valA,valB,valE_op,OF_op);
    ALU Increment(2'b00,valB,64'd1,valE_inc,OF_inc);
    ALU Decrement(2'b01,valB,64'd1,valE_dec,OF_dec);

    // ***** ALU Operations ***** //
    always @(*) begin
        valE = 0;
        case (icode)
            4'h2: // cmovxx
                valE = valE_adder;
            4'h3: // irmovq
                valE = valE_addC;
            4'h4: // rmmovq
                valE = valE_addC;
            4'h5: // mrmovq
                valE = valE_addC;
            4'h6: // opq
                begin
                    valE = valE_op;

                    if (valE == 0)
                        ConditionCodes_Out[0] = 1'b1;
                    else
                        ConditionCodes_Out[0] = 1'b0;
                        
                    ConditionCodes_Out[1] = valE[63];
                    ConditionCodes_Out[2] = OF_op;
                end
            4'h8: // call
                valE = valE_dec; // Decrement the stack pointer
            4'h9: // ret
                valE = valE_inc; // Increment the stack pointer
            4'hA: // pushq
                valE = valE_dec; // Decrement the stack pointer
            4'hB: // popq
                valE = valE_inc; // Increment the stack pointer
        endcase    
    end

    // ***** Updating Condition Signal based on Input Condition codes ***** //
    wire ZeroFlag,SignFlag,OverflowFlag;
    assign ZeroFlag = ConditionCodes_In[0];
    assign SignFlag = ConditionCodes_In[1];
    assign OverflowFlag = ConditionCodes_In[2];

    // always @(*)
    // begin
    //     if(icode == 2 || icode == 7) // Conditional Move and Conditional Jump respectively
    //     begin
    //         case (ifun)
    //             4'h0: // No Condition (Unconditional register to register move OR Unconditional Jump)
    //                 begin
    //                     Condition = 1'b1;
    //                 end
    //             4'h1: // Less than or equal to
    //                 begin
    //                     Condition = ZeroFlag|(OverflowFlag^SignFlag);
    //                 end
    //             4'h2: // Less than
    //                 begin
    //                     Condition = (OverflowFlag^SignFlag);
    //                 end
    //             4'h3: // Equal to
    //                 begin
    //                     Condition = ZeroFlag;
    //                 end
    //             4'h4: // Not Equal to
    //                 begin
    //                     Condition = ~ZeroFlag;
    //                 end
    //             4'h5: // Greater than or Equal to
    //                 begin
    //                     Condition = ~(OverflowFlag^SignFlag);
    //                 end
    //             4'h6: // Greater than
    //                 begin
    //                     Condition = (~ZeroFlag)&(~(OverflowFlag^SignFlag));
    //                 end 
    //             default:
    //                 begin
    //                     Condition = 1'b0;
    //                 end
    //         endcase
    //     end    
    // end
    
endmodule