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
output [`DATA_INDEX_LIMIT:0] HI;
output [`DATA_INDEX_LIMIT:0] LO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;

// TBD
wire [`DATA_INDEX_LIMIT:0] twos_mcnd;
wire [`DATA_INDEX_LIMIT:0] twos_mplr;

TWOSCOMP32 inst_twos_mcnd(.Y(twos_mcnd), .A(A));
TWOSCOMP32 inst_twos_mplr(.Y(twos_mplr), .A(B));

wire [`DATA_INDEX_LIMIT:0] MCND;
wire [`DATA_INDEX_LIMIT:0] MPLR;

MUX32_2x1 inst_mux_1(.Y(MCND), .I0(A), .I1(twos_mcnd), .S(A[31]));
MUX32_2x1 inst_mux_2(.Y(MPLR), .I0(B), .I1(twos_mplr), .S(B[31]));

wire [`DATA_INDEX_LIMIT:0] HI_RES;
wire [`DATA_INDEX_LIMIT:0] LO_RES;

MULT32_U inst_uns_mult(.HI(HI_RES), .LO(LO_RES), .A(MCND), .B(MPLR));

wire [`DATA_INDEX_LIMIT:0] inv_hi;
wire [`DATA_INDEX_LIMIT:0] twos_lo;

assign HI_RES = (HI_RES === {`DATA_WIDTH{1'bz}})?{32'b0}:HI_RES;

INV32_1x1 inst_inv_hi(.Y(inv_hi), .A(HI_RES));
TWOSCOMP32 inst_twos_lo(.Y(twos_lo), .A(LO_RES));

wire result_sign;

xor xor_result_sign(result_sign, A[31], B[31]);

MUX32_2x1 inst_mux_prod1(.Y(HI), .I0(HI_RES), .I1(inv_hi), .S(result_sign));
MUX32_2x1 inst_mux_prod2(.Y(LO), .I0(LO_RES), .I1(twos_lo), .S(result_sign));

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [`DATA_INDEX_LIMIT:0] HI;
output [`DATA_INDEX_LIMIT:0] LO;
// input list
input [`DATA_INDEX_LIMIT:0] A; // MCND
input [`DATA_INDEX_LIMIT:0] B; // MPLR

// TBD
reg SnA = 1'b0;

wire [`DATA_INDEX_LIMIT:0] and_1a;
wire [`DATA_INDEX_LIMIT:0] and_1b;
AND32_2x1 and_inst_1a(and_1a, A, {32{B[1]}});
AND32_2x1 and_inst_1b(and_1b, A, {32{B[0]}});
wire CO_1;
wire [`DATA_INDEX_LIMIT:0] Y1;
RC_ADD_SUB_32 adder1(.Y(Y1), .CO(CO_1), .A(and_1a), .B({1'b0, and_1b[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_2;
AND32_2x1 and_inst_2(and_2, A, {32{B[2]}});
wire CO_2;
wire [`DATA_INDEX_LIMIT:0] Y2;
RC_ADD_SUB_32 adder2(.Y(Y2), .CO(CO_2), .A(and_2), .B({CO_1,Y1[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_3;
AND32_2x1 and_inst_3(and_3, A, {32{B[3]}});
wire CO_3;
wire [`DATA_INDEX_LIMIT:0] Y3;
RC_ADD_SUB_32 adder3(.Y(Y3), .CO(CO_3), .A(and_3), .B({CO_2,Y2[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_4;
AND32_2x1 and_inst_4(and_4, A, {32{B[4]}});
wire CO_4;
wire [`DATA_INDEX_LIMIT:0] Y4;
RC_ADD_SUB_32 adder4(.Y(Y4), .CO(CO_4), .A(and_4), .B({CO_3,Y3[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_5;
AND32_2x1 and_inst_5(and_5, A, {32{B[5]}});
wire CO_5;
wire [`DATA_INDEX_LIMIT:0] Y5;
RC_ADD_SUB_32 adder5(.Y(Y5), .CO(CO_5), .A(and_5), .B({CO_4,Y4[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_6;
AND32_2x1 and_inst_6(and_6, A, {32{B[6]}});
wire CO_6;
wire [`DATA_INDEX_LIMIT:0] Y6;
RC_ADD_SUB_32 adder6(.Y(Y6), .CO(CO_6), .A(and_6), .B({CO_5,Y5[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_7;
AND32_2x1 and_inst_7(and_7, A, {32{B[7]}});
wire CO_7;
wire [`DATA_INDEX_LIMIT:0] Y7;
RC_ADD_SUB_32 adder7(.Y(Y7), .CO(CO_7), .A(and_7), .B({CO_6,Y6[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_8;
AND32_2x1 and_inst_8(and_8, A, {32{B[8]}});
wire CO_8;
wire [`DATA_INDEX_LIMIT:0] Y8;
RC_ADD_SUB_32 adder8(.Y(Y8), .CO(CO_8), .A(and_8), .B({CO_7,Y7[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_9;
AND32_2x1 and_inst_9(and_9, A, {32{B[9]}});
wire CO_9;
wire [`DATA_INDEX_LIMIT:0] Y9;
RC_ADD_SUB_32 adder9(.Y(Y9), .CO(CO_9), .A(and_9), .B({CO_8,Y8[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_10;
AND32_2x1 and_inst_10(and_10, A, {32{B[10]}});
wire CO_10;
wire [`DATA_INDEX_LIMIT:0] Y10;
RC_ADD_SUB_32 adder10(.Y(Y10), .CO(CO_10), .A(and_10), .B({CO_9,Y9[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_11;
AND32_2x1 and_inst_11(and_11, A, {32{B[11]}});
wire CO_11;
wire [`DATA_INDEX_LIMIT:0] Y11;
RC_ADD_SUB_32 adder11(.Y(Y11), .CO(CO_11), .A(and_11), .B({CO_10,Y10[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_12;
AND32_2x1 and_inst_12(and_12, A, {32{B[12]}});
wire CO_12;
wire [`DATA_INDEX_LIMIT:0] Y12;
RC_ADD_SUB_32 adder12(.Y(Y12), .CO(CO_12), .A(and_12), .B({CO_11,Y11[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_13;
AND32_2x1 and_inst_13(and_13, A, {32{B[13]}});
wire CO_13;
wire [`DATA_INDEX_LIMIT:0] Y13;
RC_ADD_SUB_32 adder13(.Y(Y13), .CO(CO_13), .A(and_13), .B({CO_12,Y12[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_14;
AND32_2x1 and_inst_14(and_14, A, {32{B[14]}});
wire CO_14;
wire [`DATA_INDEX_LIMIT:0] Y14;
RC_ADD_SUB_32 adder14(.Y(Y14), .CO(CO_14), .A(and_14), .B({CO_13,Y13[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_15;
AND32_2x1 and_inst_15(and_15, A, {32{B[15]}});
wire CO_15;
wire [`DATA_INDEX_LIMIT:0] Y15;
RC_ADD_SUB_32 adder15(.Y(Y15), .CO(CO_15), .A(and_15), .B({CO_14,Y14[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_16;
AND32_2x1 and_inst_16(and_16, A, {32{B[16]}});
wire CO_16;
wire [`DATA_INDEX_LIMIT:0] Y16;
RC_ADD_SUB_32 adder16(.Y(Y16), .CO(CO_16), .A(and_16), .B({CO_15,Y15[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_17;
AND32_2x1 and_inst_17(and_17, A, {32{B[17]}});
wire CO_17;
wire [`DATA_INDEX_LIMIT:0] Y17;
RC_ADD_SUB_32 adder17(.Y(Y17), .CO(CO_17), .A(and_17), .B({CO_16,Y16[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_18;
AND32_2x1 and_inst_18(and_18, A, {32{B[18]}});
wire CO_18;
wire [`DATA_INDEX_LIMIT:0] Y18;
RC_ADD_SUB_32 adder18(.Y(Y18), .CO(CO_18), .A(and_18), .B({CO_17,Y17[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_19;
AND32_2x1 and_inst_19(and_19, A, {32{B[19]}});
wire CO_19;
wire [`DATA_INDEX_LIMIT:0] Y19;
RC_ADD_SUB_32 adder19(.Y(Y19), .CO(CO_19), .A(and_19), .B({CO_18,Y18[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_20;
AND32_2x1 and_inst_20(and_20, A, {32{B[20]}});
wire CO_20;
wire [`DATA_INDEX_LIMIT:0] Y20;
RC_ADD_SUB_32 adder20(.Y(Y20), .CO(CO_20), .A(and_20), .B({CO_19,Y19[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_21;
AND32_2x1 and_inst_21(and_21, A, {32{B[21]}});
wire CO_21;
wire [`DATA_INDEX_LIMIT:0] Y21;
RC_ADD_SUB_32 adder21(.Y(Y21), .CO(CO_21), .A(and_21), .B({CO_20,Y20[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_22;
AND32_2x1 and_inst_22(and_22, A, {32{B[22]}});
wire CO_22;
wire [`DATA_INDEX_LIMIT:0] Y22;
RC_ADD_SUB_32 adder22(.Y(Y22), .CO(CO_22), .A(and_22), .B({CO_21,Y21[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_23;
AND32_2x1 and_inst_23(and_23, A, {32{B[23]}});
wire CO_23;
wire [`DATA_INDEX_LIMIT:0] Y23;
RC_ADD_SUB_32 adder23(.Y(Y23), .CO(CO_23), .A(and_23), .B({CO_22,Y22[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_24;
AND32_2x1 and_inst_24(and_24, A, {32{B[24]}});
wire CO_24;
wire [`DATA_INDEX_LIMIT:0] Y24;
RC_ADD_SUB_32 adder24(.Y(Y24), .CO(CO_24), .A(and_24), .B({CO_23,Y23[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_25;
AND32_2x1 and_inst_25(and_25, A, {32{B[25]}});
wire CO_25;
wire [`DATA_INDEX_LIMIT:0] Y25;
RC_ADD_SUB_32 adder25(.Y(Y25), .CO(CO_25), .A(and_25), .B({CO_24,Y24[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_26;
AND32_2x1 and_inst_26(and_26, A, {32{B[26]}});
wire CO_26;
wire [`DATA_INDEX_LIMIT:0] Y26;
RC_ADD_SUB_32 adder26(.Y(Y26), .CO(CO_26), .A(and_26), .B({CO_25,Y25[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_27;
AND32_2x1 and_inst_27(and_27, A, {32{B[27]}});
wire CO_27;
wire [`DATA_INDEX_LIMIT:0] Y27;
RC_ADD_SUB_32 adder27(.Y(Y27), .CO(CO_27), .A(and_27), .B({CO_26,Y26[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_28;
AND32_2x1 and_inst_28(and_28, A, {32{B[28]}});
wire CO_28;
wire [`DATA_INDEX_LIMIT:0] Y28;
RC_ADD_SUB_32 adder28(.Y(Y28), .CO(CO_28), .A(and_28), .B({CO_27,Y27[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_29;
AND32_2x1 and_inst_29(and_29, A, {32{B[29]}});
wire CO_29;
wire [`DATA_INDEX_LIMIT:0] Y29;
RC_ADD_SUB_32 adder29(.Y(Y29), .CO(CO_29), .A(and_29), .B({CO_28,Y28[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_30;
AND32_2x1 and_inst_30(and_30, A, {32{B[30]}});
wire CO_30;
wire [`DATA_INDEX_LIMIT:0] Y30;
RC_ADD_SUB_32 adder30(.Y(Y30), .CO(CO_30), .A(and_30), .B({CO_29,Y29[31:1]}), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] and_31;
AND32_2x1 and_inst_31(and_31, A, {32{B[31]}});
wire CO_31;
wire [`DATA_INDEX_LIMIT:0] Y31;
RC_ADD_SUB_32 adder31(.Y(Y31), .CO(CO_31), .A(and_31), .B({CO_30,Y30[31:1]}), .SnA(SnA));


assign LO = {Y31[0], Y30[0], Y29[0], Y28[0], Y27[0], Y26[0], Y25[0], Y24[0], Y23[0], Y22[0], Y21[0], 
		Y20[0], Y19[0], Y18[0], Y17[0], Y16[0], Y15[0], Y14[0], Y13[0], Y12[0], Y11[0], 
		Y10[0], Y9[0], Y8[0], Y7[0], Y6[0], Y5[0], Y4[0], Y3[0], Y2[0], Y1[0], and_1b[0]};

assign HI = Y31;

endmodule
