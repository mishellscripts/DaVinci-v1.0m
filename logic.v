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
//
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
output [31:0] Y;
//input list
input [31:0] A;

// TBD
wire [31:0] a_inv;
INV32_1x1 inv_32_inst(a_inv, A);
wire CO;
reg SnA = 1'b0;
RC_ADD_SUB_32 adder1(.Y(Y), .CO(CO), .A(a_inv), .B(32'b1), .SnA(SnA));

endmodule

// 32-bit register -ve edge
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

// TBD

endmodule

// 1 bit register -ve edge
module REG1(Q, Qbar, D, L, nC, nP, nR);
input D, nC, L;
input nP, nR;
output Q,Qbar;

// TBD

endmodule

// 1 bit D F/F -ve edge
module D_FF(Q, Qbar, D, nC, nP, nR);
input D, nC;
input nP, nR;
output Q,Qbar;

// TBD

endmodule

// 1 bit D latch
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

// TBD

endmodule

// 1 bit SR latch
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

// TBD

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

// TBD

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

// TBD


endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

//TBD


endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

// YBD

endmodule