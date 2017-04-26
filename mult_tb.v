`include "prj_definition.v"
`timescale 1ns/1ps

module MULT_TB;
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;
wire [`DATA_INDEX_LIMIT:0] HI;
wire [`DATA_INDEX_LIMIT:0] LO;

MULT32_U inst_mult_32(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
#5 A=2; B=3;
#5 A=0; B=1;
#5 A=5; B=7;
#5 A=0; B=1;
end

endmodule;
