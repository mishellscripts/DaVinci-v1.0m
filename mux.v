// Name: mux.v
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

// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [`DATA_INDEX_LIMIT:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [`DATA_INDEX_LIMIT:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [`DATA_INDEX_LIMIT:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

// TBD
wire [`DATA_INDEX_LIMIT:0] mux_1a_out4;
wire [`DATA_INDEX_LIMIT:0] mux_1b_out4;
MUX32_16x1 mux32_inst_4a(mux_1a_out4, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10,
			I11, I12, I13, I14, I15, S[3:0]);
MUX32_16x1 mux32_inst_4b(mux_1b_out4, I16, I17, I18, I19, I20, I21, I22, I23, I24,
			I25, I26, I27, I28, I29, I30, I31, S[3:0]);

MUX32_2x1 mux32_inst_4(Y, mux_1a_out4, mux_1b_out4, S[4]);

endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] I0;
input [`DATA_INDEX_LIMIT:0] I1;
input [`DATA_INDEX_LIMIT:0] I2;
input [`DATA_INDEX_LIMIT:0] I3;
input [`DATA_INDEX_LIMIT:0] I4;
input [`DATA_INDEX_LIMIT:0] I5;
input [`DATA_INDEX_LIMIT:0] I6;
input [`DATA_INDEX_LIMIT:0] I7;
input [`DATA_INDEX_LIMIT:0] I8;
input [`DATA_INDEX_LIMIT:0] I9;
input [`DATA_INDEX_LIMIT:0] I10;
input [`DATA_INDEX_LIMIT:0] I11;
input [`DATA_INDEX_LIMIT:0] I12;
input [`DATA_INDEX_LIMIT:0] I13;
input [`DATA_INDEX_LIMIT:0] I14;
input [`DATA_INDEX_LIMIT:0] I15;
input [3:0] S;

// TBD
wire [`DATA_INDEX_LIMIT:0] mux_1a_out3;
wire [`DATA_INDEX_LIMIT:0] mux_1b_out3;
MUX32_8x1 mux32_inst_3a(mux_1a_out3, I0, I1, I2, I3, I4, I5, I6, I7, S[2:0]);
MUX32_8x1 mux32_inst_3b(mux_1b_out3, I8, I9, I10, I11, I12, I13, I14, I15, S[2:0]);

MUX32_2x1 mux32_inst_3(Y, mux_1a_out3, mux_1b_out3, S[3]);


endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] I0;
input [`DATA_INDEX_LIMIT:0] I1;
input [`DATA_INDEX_LIMIT:0] I2;
input [`DATA_INDEX_LIMIT:0] I3;
input [`DATA_INDEX_LIMIT:0] I4;
input [`DATA_INDEX_LIMIT:0] I5;
input [`DATA_INDEX_LIMIT:0] I6;
input [`DATA_INDEX_LIMIT:0] I7;
input [2:0] S;

// TBD
wire [`DATA_INDEX_LIMIT:0] mux_1a_out2;
wire [`DATA_INDEX_LIMIT:0] mux_1b_out2;
MUX32_4x1 mux32_inst_2a(mux_1a_out2, I0, I1, I2, I3, S[1:0]);
MUX32_4x1 mux32_inst_2b(mux_1b_out2, I4, I5, I6, I7, S[1:0]);

MUX32_2x1 mux32_inst_2(Y, mux_1a_out2, mux_1b_out2, S[2]);

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] I0;
input [`DATA_INDEX_LIMIT:0] I1;
input [`DATA_INDEX_LIMIT:0] I2;
input [`DATA_INDEX_LIMIT:0] I3;
input [1:0] S;

// TBD
wire [`DATA_INDEX_LIMIT:0] mux_1a_out1;
wire [`DATA_INDEX_LIMIT:0] mux_1b_out1;
MUX32_2x1 mux32_inst_1a(mux_1a_out1, I0, I1, S[0]);
MUX32_2x1 mux32_inst_1b(mux_1b_out1, I2, I3, S[0]);

MUX32_2x1 mux32_inst_1(Y, mux_1a_out1, mux_1b_out1, S[1]);

endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
//input list
input [`DATA_INDEX_LIMIT:0] I0;
input [`DATA_INDEX_LIMIT:0] I1;
input S;

// TBD
genvar i;
generate
	for(i=0; i<32; i=i+1)
	begin: mux32_gen_loop
		MUX1_2x1 mux2x1_inst(Y[i], I0[i], I1[i], S);
	end
endgenerate
endmodule

// 1-bit mux
module MUX1_2x1(Y,I0, I1, S);
//output list
output Y;
//input list
input I0, I1, S;

// TBD
not not_s(NS, S);
and and_inst1(Y1, NS, I0);
and and_inst2(Y2, S, I1);
or or_inst(Y, Y1, Y2);

endmodule
