// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(Y,CO,A,B, CI);
output Y,CO;
input A,B, CI;

xor a_xor_b(C, A, B);
xor inst1(Y, CI, C);
and first_term(FT, CI, C);
and second_term(ST, A, B);
or inst2(CO, FT, ST);

endmodule;
