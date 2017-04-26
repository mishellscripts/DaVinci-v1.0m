// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

// TBD

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; // MCND
input [31:0] B; // MPLR

// TBD
reg [31:0] SnA = 32'b0;
reg [31:0] lo_reg;
assign LO = lo_reg;

AND32_2x1 and_inst_1a(and_1a, A, {32{B[0]}});
AND32_2x1 and_inst_1b(and_1b, A, {32{B[1]}});
wire CO_1;
wire [31:0] Y1;
RC_ADD_SUB_32 adder1(.Y(Y1), .CO(CO_1), .A(and_1a), .B(and_1b), .SnA({1'b0, SnA[31:1]}));

AND32_2x1 and_inst_2(and_2, A, {32{B[2]}});
wire CO_2;
wire [31:0] Y2;
RC_ADD_SUB_32 adder2(.Y(Y2), .CO(CO_2), .A(and_2), .B(Y1), .SnA({CO_1, SnA[31:1]}));

AND32_2x1 and_inst_3(and_3, A, {32{B[3]}});
wire CO_3;
wire [31:0] Y3;
RC_ADD_SUB_32 adder3(.Y(Y3), .CO(CO_3), .A(and_3), .B(Y2), .SnA({CO_2, SnA[31:1]}));

AND32_2x1 and_inst_4(and_4, A, {32{B[4]}});
wire CO_4;
wire [31:0] Y4;
RC_ADD_SUB_32 adder4(.Y(Y4), .CO(CO_4), .A(and_4), .B(Y3), .SnA({CO_3, SnA[31:1]}));

AND32_2x1 and_inst_5(and_5, A, {32{B[5]}});
wire CO_5;
wire [31:0] Y5;
RC_ADD_SUB_32 adder5(.Y(Y5), .CO(CO_5), .A(and_5), .B(Y4), .SnA({CO_4, SnA[31:1]}));

AND32_2x1 and_inst_6(and_6, A, {32{B[6]}});
wire CO_6;
wire [31:0] Y6;
RC_ADD_SUB_32 adder6(.Y(Y6), .CO(CO_6), .A(and_6), .B(Y5), .SnA({CO_5, SnA[31:1]}));

AND32_2x1 and_inst_7(and_7, A, {32{B[2]}});
wire CO_7;
wire [31:0] Y7;
RC_ADD_SUB_32 adder7(.Y(Y7), .CO(CO_7), .A(and_7), .B(Y6), .SnA({CO_6, SnA[31:1]}));

AND32_2x1 and_inst_8(and_8, A, {32{B[2]}});
wire CO_8;
wire [31:0] Y8;
RC_ADD_SUB_32 adder8(.Y(Y8), .CO(CO_8), .A(and_8), .B(Y7), .SnA({CO_7, SnA[31:1]}));

AND32_2x1 and_inst_9(and_9, A, {32{B[2]}});
wire CO_9;
wire [31:0] Y9;
RC_ADD_SUB_32 adder9(.Y(Y9), .CO(CO_9), .A(and_9), .B(Y8), .SnA({CO_8, SnA[31:1]}));

AND32_2x1 and_inst_10(and_10, A, {32{B[2]}});
wire CO_10;
wire [31:0] Y10;
RC_ADD_SUB_32 adder10(.Y(Y10), .CO(CO_10), .A(and_1a0), .B(Y9), .SnA({CO_9, SnA[31:1]}));

AND32_2x1 and_inst_11(and_11, A, {32{B[2]}});
wire CO_11;
wire [31:0] Y11;
RC_ADD_SUB_32 adder11(.Y(Y11), .CO(CO_11), .A(and_11), .B(Y10), .SnA({CO_10, SnA[31:1]}));

AND32_2x1 and_inst_12(and_12, A, {32{B[2]}});
wire CO_12;
wire [31:0] Y12;
RC_ADD_SUB_32 adder12(.Y(Y12), .CO(CO_12), .A(and_12), .B(Y11), .SnA({CO_11, SnA[31:1]}));

AND32_2x1 and_inst_13(and_13, A, {32{B[2]}});
wire CO_13;
wire [31:0] Y13;
RC_ADD_SUB_32 adder13(.Y(Y13), .CO(CO_13), .A(and_13), .B(Y12), .SnA({CO_12, SnA[31:1]}));

AND32_2x1 and_inst_14(and_14, A, {32{B[2]}});
wire CO_14;
wire [31:0] Y14;
RC_ADD_SUB_32 adder14(.Y(Y14), .CO(CO_14), .A(and_14), .B(Y13), .SnA({CO_13, SnA[31:1]}));

AND32_2x1 and_inst_15(and_15, A, {32{B[2]}});
wire CO_15;
wire [31:0] Y15;
RC_ADD_SUB_32 adder15(.Y(Y15), .CO(CO_15), .A(and_15), .B(Y14), .SnA({CO_14, SnA[31:1]}));

AND32_2x1 and_inst_16(and_16, A, {32{B[2]}});
wire CO_16;
wire [31:0] Y16;
RC_ADD_SUB_32 adder16(.Y(Y16), .CO(CO_16), .A(and_16), .B(Y15), .SnA({CO_15, SnA[31:1]}));

AND32_2x1 and_inst_17(and_17, A, {32{B[2]}});
wire CO_17;
wire [31:0] Y17;
RC_ADD_SUB_32 adder17(.Y(Y17), .CO(CO_17), .A(and_17), .B(Y16), .SnA({CO_16, SnA[31:1]}));

AND32_2x1 and_inst_18(and_18, A, {32{B[2]}});
wire CO_18;
wire [31:0] Y18;
RC_ADD_SUB_32 adder18(.Y(Y18), .CO(CO_18), .A(and_18), .B(Y17), .SnA({CO_17, SnA[31:1]}));

AND32_2x1 and_inst_19(and_19, A, {32{B[2]}});
wire CO_19;
wire [31:0] Y19;
RC_ADD_SUB_32 adder19(.Y(Y19), .CO(CO_19), .A(and_19), .B(Y18), .SnA({CO_18, SnA[31:1]}));

AND32_2x1 and_inst_20(and_20, A, {32{B[2]}});
wire CO_20;
wire [31:0] Y20;
RC_ADD_SUB_32 adder20(.Y(Y20), .CO(CO_20), .A(and_20), .B(Y19), .SnA({CO_19, SnA[31:1]}));

AND32_2x1 and_inst_21(and_21, A, {32{B[2]}});
wire CO_21;
wire [31:0] Y21;
RC_ADD_SUB_32 adder21(.Y(Y21), .CO(CO_21), .A(and_21), .B(Y20), .SnA({CO_20, SnA[31:1]}));

AND32_2x1 and_inst_22(and_22, A, {32{B[2]}});
wire CO_22;
wire [31:0] Y22;
RC_ADD_SUB_32 adder22(.Y(Y22), .CO(CO_22), .A(and_22), .B(Y21), .SnA({CO_21, SnA[31:1]}));

AND32_2x1 and_inst_23(and_23, A, {32{B[2]}});
wire CO_23;
wire [31:0] Y23;
RC_ADD_SUB_32 adder23(.Y(Y23), .CO(CO_23), .A(and_23), .B(Y22), .SnA({CO_22, SnA[31:1]}));

AND32_2x1 and_inst_24(and_24, A, {32{B[2]}});
wire CO_24;
wire [31:0] Y24;
RC_ADD_SUB_32 adder24(.Y(Y24), .CO(CO_24), .A(and_24), .B(Y23), .SnA({CO_23, SnA[31:1]}));

AND32_2x1 and_inst_25(and_25, A, {32{B[2]}});
wire CO_25;
wire [31:0] Y25;
RC_ADD_SUB_32 adder25(.Y(Y25), .CO(CO_25), .A(and_25), .B(Y24), .SnA({CO_24, SnA[31:1]}));

AND32_2x1 and_inst_26(and_26, A, {32{B[2]}});
wire CO_26;
wire [31:0] Y26;
RC_ADD_SUB_32 adder26(.Y(Y26), .CO(CO_26), .A(and_26), .B(Y25), .SnA({CO_25, SnA[31:1]}));

AND32_2x1 and_inst_27(and_27, A, {32{B[2]}});
wire CO_27;
wire [31:0] Y27;
RC_ADD_SUB_32 adder27(.Y(Y27), .CO(CO_27), .A(and_27), .B(Y26), .SnA({CO_26, SnA[31:1]}));

AND32_2x1 and_inst_28(and_28, A, {32{B[2]}});
wire CO_28;
wire [31:0] Y28;
RC_ADD_SUB_32 adder28(.Y(Y28), .CO(CO_28), .A(and_28), .B(Y27), .SnA({CO_27, SnA[31:1]}));

AND32_2x1 and_inst_29(and_29, A, {32{B[2]}});
wire CO_29;
wire [31:0] Y29;
RC_ADD_SUB_32 adder29(.Y(Y29), .CO(CO_29), .A(and_29), .B(Y28), .SnA({CO_28, SnA[31:1]}));

AND32_2x1 and_inst_30(and_30, A, {32{B[2]}});
wire CO_30;
wire [31:0] Y30;
RC_ADD_SUB_32 adder30(.Y(Y30), .CO(CO_30), .A(and_30), .B(Y29), .SnA({CO_29, SnA[31:1]}));

AND32_2x1 and_inst_31(and_31, A, {32{B[2]}});
wire CO_31;
wire [31:0] Y31;
RC_ADD_SUB_32 adder31(.Y(Y31), .CO(CO_31), .A(and_31), .B(Y30), .SnA({CO_30, SnA[31:1]}));

AND32_2x1 and_inst_32(and_32, A, {32{B[2]}});
wire CO_32;
wire [31:0] Y32;
RC_ADD_SUB_32 adder32(.Y(Y32), .CO(CO_32), .A(and_32), .B(Y31), .SnA({CO_31, SnA[31:1]}));
endmodule
