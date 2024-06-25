module Decode (clk ,D_icode ,D_ifun ,D_rA ,D_rB ,D_valC, D_valP ,D_stat, e_dstE ,e_valE ,M_dstE ,M_valE ,M_dstM ,m_valM, W_dstM ,W_valM ,W_dstE ,W_valE, value0, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14, d_icode ,d_ifun ,d_valC ,d_valA ,d_valB ,d_dstE ,d_dstM ,d_srcA ,d_srcB, d_stat);

    input clk;
    input [3:0] D_icode, D_ifun, D_rA, D_rB, D_stat;
    input [3:0] e_dstE, M_dstE, M_dstM, W_dstM, W_dstE;
    input [63:0] e_valE,M_valE,m_valM,W_valM,W_valE,D_valC, D_valP;
    //reg file
    input [63:0] value0,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14;

    reg [0:63] list[0:14];
    reg [3:0]  inp1,inp2;

    output reg [63:0] d_valA ,d_valB, d_valC;
    output reg [3:0] d_dstE ,d_dstM, d_srcA ,d_srcB, d_icode ,d_ifun, d_stat;

    always@(*) begin
        
        d_icode <= D_icode;
        d_ifun <= D_ifun;
        d_valC <= D_valC;
        d_stat <= D_stat;

        list[0] <= value0;
        list[1] <= value1;
        list[2] <= value2;
        list[3] <= value3;
        list[4] <= value4;
        list[5] <= value5;
        list[6] <= value6;
        list[7] <= value7;
        list[8] <= value8;
        list[9] <= value9;
        list[10] <= value10;
        list[11] <= value11;
        list[12] <= value12;
        list[13] <= value13;
        list[14] <= value14;

        d_dstE = 4'b1111; //f
        d_dstM = 4'b1111; //f

        case(D_icode)
        
            4'h2  : 
                begin          
                    inp1 = D_rA;
                    d_dstE = D_rB;
                end

            4'h3 : d_dstE = D_rB;

            4'h4  : 
                begin                      
                    inp1 = D_rA;
                    inp2 = D_rB;
                end

            4'h5  : 
                begin
                    inp2 = D_rB;
                    d_dstM = D_rA;
                end

            4'h6  :  
                begin                      
                    inp1 = D_rA;
                    inp2 = D_rB;
                    d_dstE = D_rB;
                end

            4'h8  :   
                begin  
                    inp2 = 4'd4;
                    d_dstE = 4'd4;
                end 

            4'h9  :  
                begin  
                    inp1 = 4'd4;  
                    inp2 = 4'd4;
                    d_dstE = 4'd4;
                end 

            4'hA  :  
                begin  
                    inp1 = D_rA;
                    inp2 = 4'd4;
                    d_dstE = 4'd4;
                end 
                
            4'hB  :  
                begin
                    inp1 = 4'd4; 
                    inp2 = 4'd4; 
                    d_dstE = 4'd4;
                    d_dstM = D_rA;
                end 
        endcase

        d_srcA= inp1;
        d_srcB= inp2;

    end
    
    always @(*) begin
        case (D_icode)
            7, 8: d_valA = D_valP;
            default:
                case (d_srcA)
                    e_dstE: d_valA = e_valE;
                    M_dstM: d_valA = m_valM;
                    M_dstE: d_valA = M_valE;
                    W_dstM: d_valA = W_valM;
                    W_dstE: d_valA = W_valE;
                    default: d_valA = list[d_srcA];
                endcase
        endcase
    end

    always @(*) begin
        case (d_srcB)
            e_dstE: d_valB = e_valE;
            M_dstM: d_valB = m_valM;
            M_dstE: d_valB = M_valE;
            W_dstM: d_valB = W_valM;
            W_dstE: d_valB = W_valE;
            default: d_valB = list[d_srcB];
        endcase
    end


endmodule

//temp reg_file to be moved to wD_rApper
