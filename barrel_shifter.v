// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
// input list
input [`DATA_INDEX_LIMIT:0] D;
input [`DATA_INDEX_LIMIT:0] S;
input LnR;

// TBD
wire [`DATA_INDEX_LIMIT:0] shift_out;
BARREL_SHIFTER32 inst_barrel_shifter32(.Y(shift_out), .D(D), .S(S[4:0]), .LnR(LnR));

MUX32_2x1 inst_mux_32bit(.Y(Y),.I0(32'b0), .I1(shift_out), .S((S[31:5] == 0)));

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
// input list
input [`DATA_INDEX_LIMIT:0] D;
input [4:0] S;
input LnR;

// TBD

wire [`DATA_INDEX_LIMIT:0] outR;
wire [`DATA_INDEX_LIMIT:0] outL;

SHIFT32_R inst_rshift(.Y(outR), .D(D), .S(S));
SHIFT32_L inst_lshift(.Y(outL), .D(D), .S(S));

// Right shift if LnR = 0
MUX32_2x1 inst_mux_32bit(.Y(Y),.I0(outR), .I1(outL), .S(LnR));

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
// input list
input [`DATA_INDEX_LIMIT:0] D;
input [4:0] S;

// TBD
// Ea column will have 32 multiplexer
// 5 such columns

wire [`DATA_INDEX_LIMIT:0] out1;

// Column 1 (shift 1)
genvar i1;
generate
    for(i1=0; i1<32; i1=i1+1)
    begin: barrelshift1_gen_loop
        if (i1 == 31) begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], 1'b0, S[0]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], D[i1+1], S[0]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out2;

// Column 2 (shift 2)
genvar i2;
generate
    for(i2=0; i2<32; i2=i2+1)
    begin: barrelshift2_gen_loop
        if (i2 > 29) begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], 1'b0, S[1]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], out1[i2+2], S[1]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out3;

// Column 3 (shift 4)
genvar i3;
generate
    for(i3=0; i3<32; i3=i3+1)
    begin: barrelshift3_gen_loop
        if (i3 > 27) begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], 1'b0, S[2]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], out2[i3+4], S[2]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out4;

// Column 4 (shift 8)
genvar i4;
generate
    for(i4=0; i4<32; i4=i4+1)
    begin: barrelshift4_gen_loop
        if (i4 > 23) begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], 1'b0, S[3]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], out3[i4+8], S[3]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out5;

// Column 5 (shift 16)
genvar i5;
generate
    for(i5=0; i5<32; i5=i5+1)
    begin: barrelshift5_gen_loop
        if (i5 > 15) begin
	    MUX1_2x1 mux2x1_inst(out5[i5], out4[i5], 1'b0, S[4]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out5[i5], out4[i5], out4[i5+16], S[4]);
	end
    end
endgenerate

assign Y = out5;

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [`DATA_INDEX_LIMIT:0] Y; 
// input list
input [`DATA_INDEX_LIMIT:0] D; // B = D
input [4:0] S; //S0 TO S4

// TBD
// Ea column will have 32 multiplexer
// 5 such columns

wire [`DATA_INDEX_LIMIT:0] out1;

// Column 1 (shift 1)
genvar i1;
generate
    for(i1=0; i1<32; i1=i1+1)
    begin: barrelshift1_gen_loop
        if (i1 == 0) begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], 1'b0, S[0]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], D[i1-1], S[0]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out2;

// Column 2 (shift 2)
genvar i2;
generate
    for(i2=0; i2<32; i2=i2+1)
    begin: barrelshift2_gen_loop
        if (i2 < 2) begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], 1'b0, S[1]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], out1[i2-2], S[1]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out3;

// Column 3 (shift 4)
genvar i3;
generate
    for(i3=0; i3<32; i3=i3+1)
    begin: barrelshift3_gen_loop
        if (i3 < 4) begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], 1'b0, S[2]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], out2[i3-4], S[2]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out4;

// Column 4 (shift 8)
genvar i4;
generate
    for(i4=0; i4<32; i4=i4+1)
    begin: barrelshift4_gen_loop
        if (i4 < 8) begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], 1'b0, S[3]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], out3[i4-8], S[3]);
	end
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] out5;

// Column 5 (shift 16)
genvar i5;
generate
    for(i5=0; i5<32; i5=i5+1)
    begin: barrelshift5_gen_loop
        if (i5 < 16) begin
	    MUX1_2x1 mux2x1_inst(Y[i5], out4[i5], 1'b0, S[4]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(Y[i5], out4[i5], out4[i5-16], S[4]);
	end
    end
endgenerate

assign Y = out5;

endmodule