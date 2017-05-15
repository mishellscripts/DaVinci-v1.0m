// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

// TBD

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

// TBD
//reg init_CI = 1'b0;
wire CO_0b;
xor add_sub_0(as0, B[0], SnA);
FULL_ADDER full_adder_0(.Y(Y[0]), .CO(CO_0b), .A(A[0]), .B(as0), .CI(SnA));

wire CO_1b;
xor add_sub_1(as1, B[1], SnA);
FULL_ADDER full_adder_1(.Y(Y[1]), .CO(CO_1b), .A(A[1]), .B(as1), .CI(CO_0b));

wire CO_2b;
xor add_sub_2(as2, B[2], SnA);
FULL_ADDER full_adder_2(.Y(Y[2]), .CO(CO_2b), .A(A[2]), .B(as2), .CI(CO_1b));

wire CO_3b;
xor add_sub_3(as3, B[3], SnA);
FULL_ADDER full_adder_3(.Y(Y[3]), .CO(CO_3b), .A(A[3]), .B(as3), .CI(CO_2b));

wire CO_4b;
xor add_sub_4(as4, B[4], SnA);
FULL_ADDER full_adder_4(.Y(Y[4]), .CO(CO_4b), .A(A[4]), .B(as4), .CI(CO_3b));

wire CO_5b;
xor add_sub_5(as5, B[5], SnA);
FULL_ADDER full_adder_5(.Y(Y[5]), .CO(CO_5b), .A(A[5]), .B(as5), .CI(CO_4b));

wire CO_6b;
xor add_sub_6(as6, B[6], SnA);
FULL_ADDER full_adder_6(.Y(Y[6]), .CO(CO_6b), .A(A[6]), .B(as6), .CI(CO_5b));

wire CO_7b;
xor add_sub_7(as7, B[7], SnA);
FULL_ADDER full_adder_7(.Y(Y[7]), .CO(CO_7b), .A(A[7]), .B(as7), .CI(CO_6b));

wire CO_8b;
xor add_sub_8(as8, B[8], SnA);
FULL_ADDER full_adder_8(.Y(Y[8]), .CO(CO_8b), .A(A[8]), .B(as8), .CI(CO_7b));

wire CO_9b;
xor add_sub_9(as9, B[9], SnA);
FULL_ADDER full_adder_9(.Y(Y[9]), .CO(CO_9b), .A(A[9]), .B(as9), .CI(CO_8b));

wire CO_10b;
xor add_sub_10(as10, B[10], SnA);
FULL_ADDER full_adder_10(.Y(Y[10]), .CO(CO_10b), .A(A[10]), .B(as10), .CI(CO_9b));

wire CO_11b;
xor add_sub_11(as11, B[11], SnA);
FULL_ADDER full_adder_11(.Y(Y[11]), .CO(CO_11b), .A(A[11]), .B(as11), .CI(CO_10b));

wire CO_12b;
xor add_sub_12(as12, B[12], SnA);
FULL_ADDER full_adder_12(.Y(Y[12]), .CO(CO_12b), .A(A[12]), .B(as12), .CI(CO_11b));

wire CO_13b;
xor add_sub_13(as13, B[13], SnA);
FULL_ADDER full_adder_13(.Y(Y[13]), .CO(CO_13b), .A(A[13]), .B(as13), .CI(CO_12b));

wire CO_14b;
xor add_sub_14(as14, B[14], SnA);
FULL_ADDER full_adder_14(.Y(Y[14]), .CO(CO_14b), .A(A[14]), .B(as14), .CI(CO_13b));

wire CO_15b;
xor add_sub_15(as15, B[15], SnA);
FULL_ADDER full_adder_15(.Y(Y[15]), .CO(CO_15b), .A(A[15]), .B(as15), .CI(CO_14b));

wire CO_16b;
xor add_sub_16(as16, B[16], SnA);
FULL_ADDER full_adder_16(.Y(Y[16]), .CO(CO_16b), .A(A[16]), .B(as16), .CI(CO_15b));

wire CO_17b;
xor add_sub_17(as17, B[17], SnA);
FULL_ADDER full_adder_17(.Y(Y[17]), .CO(CO_17b), .A(A[17]), .B(as17), .CI(CO_16b));

wire CO_18b;
xor add_sub_18(as18, B[18], SnA);
FULL_ADDER full_adder_18(.Y(Y[18]), .CO(CO_18b), .A(A[18]), .B(as18), .CI(CO_17b));

wire CO_19b;
xor add_sub_19(as19, B[19], SnA);
FULL_ADDER full_adder_19(.Y(Y[19]), .CO(CO_19b), .A(A[19]), .B(as19), .CI(CO_18b));

wire CO_20b;
xor add_sub_20(as20, B[20], SnA);
FULL_ADDER full_adder_20(.Y(Y[20]), .CO(CO_20b), .A(A[20]), .B(as20), .CI(CO_19b));

wire CO_21b;
xor add_sub_21(as21, B[21], SnA);
FULL_ADDER full_adder_21(.Y(Y[21]), .CO(CO_21b), .A(A[21]), .B(as21), .CI(CO_20b));

wire CO_22b;
xor add_sub_22(as22, B[22], SnA);
FULL_ADDER full_adder_22(.Y(Y[22]), .CO(CO_22b), .A(A[22]), .B(as22), .CI(CO_21b));

wire CO_23b;
xor add_sub_23(as23, B[23], SnA);
FULL_ADDER full_adder_23(.Y(Y[23]), .CO(CO_23b), .A(A[23]), .B(as23), .CI(CO_22b));

wire CO_24b;
xor add_sub_24(as24, B[24], SnA);
FULL_ADDER full_adder_24(.Y(Y[24]), .CO(CO_24b), .A(A[24]), .B(as24), .CI(CO_23b));

wire CO_25b;
xor add_sub_25(as25, B[25], SnA);
FULL_ADDER full_adder_25(.Y(Y[25]), .CO(CO_25b), .A(A[25]), .B(as25), .CI(CO_24b));

wire CO_26b;
xor add_sub_26(as26, B[26], SnA);
FULL_ADDER full_adder_26(.Y(Y[26]), .CO(CO_26b), .A(A[26]), .B(as26), .CI(CO_25b));

wire CO_27b;
xor add_sub_27(as27, B[27], SnA);
FULL_ADDER full_adder_27(.Y(Y[27]), .CO(CO_27b), .A(A[27]), .B(as27), .CI(CO_26b));

wire CO_28b;
xor add_sub_28(as28, B[28], SnA);
FULL_ADDER full_adder_28(.Y(Y[28]), .CO(CO_28b), .A(A[28]), .B(as28), .CI(CO_27b));

wire CO_29;
xor add_sub_29(as29, B[29], SnA);
FULL_ADDER full_adder_29(.Y(Y[29]), .CO(CO_29b), .A(A[29]), .B(as29), .CI(CO_28b));

wire CO_30b;
xor add_sub_30(as30, B[30], SnA);
FULL_ADDER full_adder_30(.Y(Y[30]), .CO(CO_30b), .A(A[30]), .B(as30), .CI(CO_29b));

wire CO_31b;
xor add_sub_31(as31, B[31], SnA);
FULL_ADDER full_adder_31(.Y(Y[31]), .CO(CO_31b), .A(A[31]), .B(as31), .CI(CO_30b));




endmodule

