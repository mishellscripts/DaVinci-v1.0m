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
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

// TBD

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;

// TBD

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

// TBD

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y; 
// input list
input [31:0] D; // B = D
input [4:0] S; //S0 TO S4

// TBD

// Ea column will have 32 multiplexer
// 5 such columns

reg zero = 1'b0;

//wire [31:0] previous;
wire [31:0] out1;

// Column 1 (shift 1)
genvar i1;
generate
    for(i1=0; i1<32; i1=i1+1)
    begin: barrelshift1_gen_loop
        if (i1 == 0) begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], zero, S[0]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out1[i1], D[i1], D[i1-1], S[0]);
	end
    end
endgenerate

//assign previous = out1;
wire [31:0] out2;

// Column 2 (shift 2)
genvar i2;
generate
    for(i2=0; i2<32; i2=i2+1)
    begin: barrelshift2_gen_loop
        if (i2 < 2) begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], zero, S[1]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out2[i2], out1[i2], D[i2-2], S[1]);
	end
    end
endgenerate

//assign previous = out2;
wire [31:0] out3;

// Column 3 (shift 4)
genvar i3;
generate
    for(i3=0; i3<32; i3=i3+1)
    begin: barrelshift3_gen_loop
        if (i3 < 4) begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], zero, S[2]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out3[i3], out2[i3], D[i3-4], S[2]);
	end
    end
endgenerate

wire [31:0] out4;

// Column 4 (shift 8)
genvar i4;
generate
    for(i4=0; i4<32; i4=i4+1)
    begin: barrelshift4_gen_loop
        if (i4 < 8) begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], zero, S[3]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out4[i4], out3[i4], D[i4-8], S[3]);
	end
    end
endgenerate

wire [31:0] out5;

// Column 5 (shift 16)
genvar i5;
generate
    for(i5=0; i5<32; i5=i5+1)
    begin: barrelshift5_gen_loop
        if (i5 < 16) begin
	    MUX1_2x1 mux2x1_inst(out5[i5], out4[i5], zero, S[4]);
	end
	else begin
	    MUX1_2x1 mux2x1_inst(out5[i5], out4[i5], D[i5-16], S[4]);
	end
    end
endgenerate

assign Y = out5;

endmodule