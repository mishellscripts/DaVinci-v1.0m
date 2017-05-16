// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------

`include "prj_definition.v"
module ALU(A, B, OPRN, Y, ZERO);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output [`DATA_INDEX_LIMIT:0] ZERO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input [5:0] OPRN;

wire CO;
wire SnA;

// Set SnA to OPRN[0]' + OPRN[3]OPRN[0]
not not_oprn0 (not_res, OPRN[0]);
and and_oprn13 (and_res, OPRN[0], OPRN[3]);
or or_res(SnA, not_res, and_res);

// Add and Sub
wire [`DATA_INDEX_LIMIT:0] add_sub_out;
RC_ADD_SUB_32 inst_add_32(.Y(add_sub_out), .CO(CO), .A(A), .B(B), .SnA(SnA));

// Mul
wire [`DATA_INDEX_LIMIT:0] mul_hi_out;
wire [`DATA_INDEX_LIMIT:0] mul_lo_out;
MULT32 inst_mult_32(.HI(mul_hi_out), .LO(mul_lo_out), .A(A), .B(B));

// Shifter
wire [`DATA_INDEX_LIMIT:0] shift_out;
SHIFT32 inst_shiftLR_32bit(.Y(shift_out), .D(A), .S(B), .LnR(OPRN[0]));

// And
wire [`DATA_INDEX_LIMIT:0] and_out;
AND32_2x1 and_32_bit_inst(.Y(and_out),.A(A),.B(B));

// Or
wire [`DATA_INDEX_LIMIT:0] or_out;
OR32_2x1 or_32_bit_inst(.Y(or_out),.A(A),.B(B));

// Nor
wire [`DATA_INDEX_LIMIT:0] nor_out;
NOR32_2x1 nor_32_bit_inst(.Y(nor_out),.A(A),.B(B));

// Slt
wire [`DATA_INDEX_LIMIT:0] slt_out;
assign slt_out = (add_sub_out < 0)?1:0;


MUX32_16x1 oprn_select (Y, {`DATA_WIDTH{1'bx} }, add_sub_out, add_sub_out, mul_lo_out, shift_out, shift_out, and_out, 
			or_out, nor_out, {31'b0, add_sub_out[31]}, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, 
			{`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, OPRN[3:0]);

wire [`DATA_INDEX_LIMIT:0] zero_flag_result;

NOR32_2x1 zero_flag(.Y(zero_flag_result), .A(Y), .B({`DATA_WIDTH{1'b0} }));

assign ZERO = (zero_flag_result == {`DATA_WIDTH{1'b1} });

endmodule
