`include "prj_definition.v"
`timescale 1ns/1ps

module MULT_TB;
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;
wire [`DATA_INDEX_LIMIT:0] HI;
wire [`DATA_INDEX_LIMIT:0] LO;

//MULT32_U inst_mult_32(.HI(HI), .LO(LO), .A(A), .B(B));
MULT32 inst_mult_32(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
//#50 A=-2; B=-3;
//#50 A=0; B=1;
#50 A=5; B=-7;
#50 A=1; B=-1;
#50 A=8; B=7;
//#10 A=4; B=3;
//#10 A=0; B=1;
end

endmodule;
