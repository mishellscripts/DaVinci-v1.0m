`include "prj_definition.v"
`timescale 1ns/1ps

module TWOSCOMP32_TB;
reg [`DATA_INDEX_LIMIT:0] A;
wire [`DATA_INDEX_LIMIT:0] Y;

TWOSCOMP32 inst_tc_32(.Y(Y),.A(A));

initial
begin
#5 A=-32;
#5 A=-10;
#5 A=-58;
#5 A=-81;
#5 A=-1002;
#5 A=-4;
#5 A=0;
end

endmodule;