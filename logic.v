// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module REG32_PP(Q, D, LOAD, CLK, RESET);
parameter PATTERN = 32'h00000000;
output [`DATA_INDEX_LIMIT:0] Q;

input CLK, LOAD;
input [`DATA_INDEX_LIMIT:0] D;
input RESET;

/*
always @(posedge CLK) begin
$write("D: %h, CLK: %h, LOAD: %h, RESET: %h\n", D, CLK, LOAD, RESET);
end
*/

wire [`DATA_INDEX_LIMIT:0] qbar;

genvar i;
generate 
for(i=0; i<32; i=i+1)
begin : reg32_gen_loop
if (PATTERN[i] == 0)
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET)); 
else
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
end 
endgenerate

endmodule
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

// TBD

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] A;

// TBD
wire [`DATA_INDEX_LIMIT:0] a_inv;
INV32_1x1 inv_32_inst(a_inv, A);
wire CO;
reg SnA = 1'b0;
RC_ADD_SUB_32 adder1(.Y(Y), .CO(CO), .A(a_inv), .B(32'b1), .SnA(SnA));

endmodule

// 32-bit register +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [`DATA_INDEX_LIMIT:0] Q;

input CLK, LOAD;
input [`DATA_INDEX_LIMIT:0] D;
input RESET;

wire [`DATA_INDEX_LIMIT:0] Qbar;

// TBD
genvar i;
generate
	for(i=0; i<32; i=i+1)
	begin: reg32_gen_loop
		REG1 reg1_inst(Q[i], Qbar[i], D[i], LOAD, CLK, 1'b1, RESET);
	end
endgenerate
endmodule

// 1 bit register +ve edge 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

// TBD
wire mux2x1_d_res;
MUX1_2x1 mux2x1_d(mux2x1_d_res, Q, D, L);
D_FF inst_dff(.Q(Q), .Qbar(Qbar), .D(mux2x1_d_res), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

not inv_c(nC, C);

// TBD
wire Y, Ybar;
D_LATCH inst_d_latch(.Q(Y), .Qbar(Ybar), .D(D), .C(nC), .nP(nP), .nR(nR));

//not inv_inv_c(nnC, nC);

SR_LATCH inst_sr_latch(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

// TBD
wire Dbar;
not not_d(Dbar, D);
SR_LATCH inst_dlatch_sr(.Q(Q), .Qbar(Qbar), .S(D), .R(Dbar), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

wire sr_out_1, sr_out_2;

// TBD
nand nand_sr_1(sr_out_1, S, C);
nand nand_sr_2(sr_out_2, R, C);
nand nand_sr_3(Q, sr_out_1, Qbar, nP);
nand nand_sr_4(Qbar, sr_out_2, Q, nR);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [`DATA_INDEX_LIMIT:0] D;
// input
input [4:0] I;

// TBD
wire [15:0] decoder_4x16_out;

DECODER_4x16 inst_decoder_4x16(.D(decoder_4x16_out), .I(I[3:0]));
not inst_inv_i4(inv_I4, I[4]);

and inst4_and1(D[0], decoder_4x16_out[0], inv_I4);
and inst4_and2(D[1], decoder_4x16_out[1], inv_I4);
and inst4_and3(D[2], decoder_4x16_out[2], inv_I4); 
and inst4_and4(D[3], decoder_4x16_out[3], inv_I4); 
and inst4_and5(D[4], decoder_4x16_out[4], inv_I4);
and inst4_and6(D[5], decoder_4x16_out[5], inv_I4);
and inst4_and7(D[6], decoder_4x16_out[6], inv_I4); 
and inst4_and8(D[7], decoder_4x16_out[7], inv_I4); 
and inst4_and9(D[8], decoder_4x16_out[8], inv_I4);
and inst4_and10(D[9], decoder_4x16_out[9], inv_I4);
and inst4_and11(D[10], decoder_4x16_out[10], inv_I4); 
and inst4_and12(D[11], decoder_4x16_out[11], inv_I4); 
and inst4_and13(D[12], decoder_4x16_out[12], inv_I4);
and inst4_and14(D[13], decoder_4x16_out[13], inv_I4);
and inst4_and15(D[14], decoder_4x16_out[14], inv_I4); 
and inst4_and16(D[15], decoder_4x16_out[15], inv_I4); 
and inst4_and17(D[16], decoder_4x16_out[0], I[4]);
and inst4_and18(D[17], decoder_4x16_out[1], I[4]);
and inst4_and19(D[18], decoder_4x16_out[2], I[4]); 
and inst4_and20(D[19], decoder_4x16_out[3], I[4]); 
and inst4_and21(D[20], decoder_4x16_out[4], I[4]);
and inst4_and22(D[21], decoder_4x16_out[5], I[4]);
and inst4_and23(D[22], decoder_4x16_out[6], I[4]); 
and inst4_and24(D[23], decoder_4x16_out[7], I[4]); 
and inst4_and25(D[24], decoder_4x16_out[8], I[4]);
and inst4_and26(D[25], decoder_4x16_out[9], I[4]);
and inst4_and27(D[26], decoder_4x16_out[10], I[4]); 
and inst4_and28(D[27], decoder_4x16_out[11], I[4]); 
and inst4_and29(D[28], decoder_4x16_out[12], I[4]);
and inst4_and30(D[29], decoder_4x16_out[13], I[4]);
and inst4_and31(D[30], decoder_4x16_out[14], I[4]); 
and inst4_and32(D[31], decoder_4x16_out[15], I[4]); 

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

// TBD
wire [7:0] decoder_3x8_out;

DECODER_3x8 inst_decoder_3x8(.D(decoder_3x8_out), .I(I[2:0]));
not inst_inv_i3(inv_I3, I[3]);

and inst3_and1(D[0], decoder_3x8_out[0], inv_I3);
and inst3_and2(D[1], decoder_3x8_out[1], inv_I3);
and inst3_and3(D[2], decoder_3x8_out[2], inv_I3); 
and inst3_and4(D[3], decoder_3x8_out[3], inv_I3); 
and inst3_and5(D[4], decoder_3x8_out[4], inv_I3);
and inst3_and6(D[5], decoder_3x8_out[5], inv_I3);
and inst3_and7(D[6], decoder_3x8_out[6], inv_I3); 
and inst3_and8(D[7], decoder_3x8_out[7], inv_I3); 
and inst3_and9(D[8], decoder_3x8_out[0], I[3]);
and inst3_and10(D[9], decoder_3x8_out[1], I[3]);
and inst3_and11(D[10], decoder_3x8_out[2], I[3]); 
and inst3_and12(D[11], decoder_3x8_out[3], I[3]); 
and inst3_and13(D[12], decoder_3x8_out[4], I[3]);
and inst3_and14(D[13], decoder_3x8_out[5], I[3]);
and inst3_and15(D[14], decoder_3x8_out[6], I[3]); 
and inst3_and16(D[15], decoder_3x8_out[7], I[3]); 


endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

//TBD
wire [3:0] decoder_2x4_out;

DECODER_2x4 inst_decoder_2x4(.D(decoder_2x4_out), .I(I[1:0]));
not inst_inv_i2(inv_I2, I[2]);

and inst2_and1(D[0], decoder_2x4_out[0], inv_I2);
and inst2_and2(D[1], decoder_2x4_out[1], inv_I2);
and inst2_and3(D[2], decoder_2x4_out[2], inv_I2); 
and inst2_and4(D[3], decoder_2x4_out[3], inv_I2); 
and inst2_and5(D[4], decoder_2x4_out[0], I[2]);
and inst2_and6(D[5], decoder_2x4_out[1], I[2]);
and inst2_and7(D[6], decoder_2x4_out[2], I[2]); 
and inst2_and8(D[7], decoder_2x4_out[3], I[2]); 

endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

// TBD
not inst_inv_i0(inv_I0, I[0]);
not inst_inv_i1(inv_I1, I[1]);
and inst_and1(D[0], inv_I1, inv_I0);
and inst_and2(D[1], inv_I1, I[0]);
and inst_and3(D[2], I[1], inv_I0); 
and inst_and4(D[3], I[0], I[1]); 

endmodule