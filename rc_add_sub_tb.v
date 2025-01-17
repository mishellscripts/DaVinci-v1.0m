`include "prj_definition.v"
`timescale 1ns/1ps

module rc_add_sub_tb;
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;
reg SnA;
wire [`DATA_INDEX_LIMIT:0] Y;
wire CO;

RC_ADD_SUB_32 inst_add_sub_32(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial
begin
SnA=0; A=23; B=28;
#10 SnA=1; A=100; B=1;
#10 SnA=1; A=32'h03fffffff; B=1;
#10 SnA=1; A=32'hffffffff; B=1;
#10 SnA=1; A=100; B=1;
end

endmodule;