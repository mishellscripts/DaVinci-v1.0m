`include "prj_definition.v"
`timescale 1ns/1ps

module LSHIFTER_TB;
reg [31:0] D;
reg [4:0] S;
wire [31:0] Y;

SHIFT32_L inst_lshift_32bit(.Y(Y), .D(D), .S(S));

initial
begin
#5 S=1; D=32;
#5 S=8; D=1;
#5 S=2; D=4;
#5 S=20; D=1;
#5 S=0; D=7;
#5 S=1; D=100;
end

endmodule;