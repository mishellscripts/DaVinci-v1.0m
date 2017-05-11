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
//

/*
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO; // zero flag

// simulator internal storage - this is not h/w register
reg [`DATA_INDEX_LIMIT:0] result;
reg [`DATA_INDEX_LIMIT:0] zero;

// whenever op1, op2, or oprn changes
always @(OP1 or OP2 or OPRN)
begin
    case (OPRN)
	`ALU_OPRN_WIDTH'h01 : result = OP1 + OP2; // addition
	`ALU_OPRN_WIDTH'h02 : result = OP1 - OP2; // subtraction
	`ALU_OPRN_WIDTH'h03 : result = OP1 * OP2; // multiplication
	`ALU_OPRN_WIDTH'h04 : result = OP1 >> OP2; // shift right
	`ALU_OPRN_WIDTH'h05 : result = OP1 << OP2; // shift left
	`ALU_OPRN_WIDTH'h06 : result = OP1 & OP2; // bitwise and
	`ALU_OPRN_WIDTH'h07 : result = OP1 | OP2; // bitwise or
	`ALU_OPRN_WIDTH'h08 : result = ~(OP1 | OP2); // bitwise nor
	`ALU_OPRN_WIDTH'h09 : result = (OP1 < OP2)?1:0;// set less than
        default: result = `DATA_WIDTH'hxxxxxxxx;            
    endcase
    if (result === 0)
       zero = 1'b1;
    else
       zero = 1'b0;
end

assign OUT = result;
assign ZERO = zero;

endmodule*/

`include "prj_definition.v"
module ALU(A, B, OPRN, Y, ZERO);
// output list
output [31:0] Y;
output [31:0] ZERO;
// input list
input [31:0] A;
input [31:0] B;
input [5:0] OPRN;

wire CO;
wire SnA;

// Set SnA to OPRN[0]' + OPRN[3]OPRN[0]
not not_oprn0 (not_res, OPRN[0]);
and and_oprn13 (and_res, OPRN[0], OPRN[3]);
or or_res(SnA, not_res, and_res);

// Add and Sub
wire [31:0] add_sub_out;
RC_ADD_SUB_32 inst_add_32(.Y(add_sub_out), .CO(CO), .A(A), .B(B), .SnA(SnA));

/* Sub
wire [31:0] sub_out;
RC_ADD_SUB_32 inst_sub_32(.Y(sub_out), .CO(CO), .A(A), .B(B), .SnA(1'b1));*/

// Mul
wire [31:0] mul_hi_out;
wire [31:0] mul_lo_out;
MULT32 inst_mult_32(.HI(mul_hi_out), .LO(mul_lo_out), .A(A), .B(B));

// Shifter
wire [31:0] shift_out;
SHIFT32 inst_shiftLR_32bit(.Y(shift_out), .D(A), .S(B), .LnR(OPRN[0]));

/*
// Shift R
wire [31:0] shiftr_out;
SHIFT32 inst_shiftR_32bit(.Y(shiftr_out), .D(D), .S(S), .LnR(1'b0));
// Shift L
wire [31:0] shiftl_out;
SHIFT32 inst_shiftL_32bit(.Y(shiftl_out), .D(D), .S(S), .LnR(1'b1));
*/

// And
wire [31:0] and_out;
AND32_2x1 and_32_bit_inst(.Y(and_out),.A(A),.B(B));

// Or
wire [31:0] or_out;
OR32_2x1 or_32_bit_inst(.Y(or_out),.A(A),.B(B));

// Nor
wire [31:0] nor_out;
NOR32_2x1 nor_32_bit_inst(.Y(nor_out),.A(A),.B(B));

// Slt
wire [31:0] slt_out;
//wire [31:0] sub_out;
//RC_ADD_SUB_32 inst_sub_32(.Y(sub_out), .CO(CO), .A(A), .B(B), .SnA(1'b1));
assign slt_out = (add_sub_out < 0)?1:0;

//INV32_1x1 INV_32_bit_inst(.Y(Y),.A(A));

MUX32_16x1 oprn_select (Y, {`DATA_WIDTH{1'bx} }, add_sub_out, add_sub_out, mul_lo_out, shift_out, shift_out, and_out, 
			or_out, nor_out, {31'b0, add_sub_out[31]}, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, 
			{`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, {`DATA_WIDTH{1'bx} }, OPRN[3:0]);

wire [31:0] zero_flag_result;

NOR32_2x1 zero_flag(.Y(zero_flag_result), .A(Y), .B({`DATA_WIDTH{1'b0} }));

assign ZERO = (zero_flag_result == {`DATA_WIDTH{1'b1} });

endmodule
