`include "prj_definition.v"
`timescale 1ns/1ps

module LSHIFTER_TB;
reg [31:0] D;
reg [4:0] S;
wire [31:0] Y;

SHIFT32_L inst_lshift_32bit(.Y(Y), .D(D), .S(S));

initial
begin
#10 S=1; D=32;
#10 S=8; D=1;
#10 S=2; D=4;
#10 S=20; D=1;
#10 S=0; D=7;
#10 S=7; D=5;
#10 S=7; D=5;
#10 S=7; D=5;
#10 S=1; D=100;
end

endmodule;

module RSHIFTER_TB;
reg [31:0] D;
reg [4:0] S;
wire [31:0] Y;

SHIFT32_R inst_rshift_32bit(.Y(Y), .D(D), .S(S));

initial
begin
#5 S=1; D=64;
#5 S=8; D=100;
#5 S=2; D=40;
#5 S=20; D=1;
#5 S=0; D=7;
#5 S=1; D=100;
end

endmodule;

module BARREL_SHIFTER32_TB;
// Shifter with LnR control

reg [31:0] D;
reg [4:0] S;
wire [31:0] Y;
reg LnR;

BARREL_SHIFTER32 inst_barrelshifter_32bit(.Y(Y), .D(D), .S(S), .LnR(LnR));

initial
begin
#5 LnR=1; S=1; D=64;
#5 LnR=0; S=1; D=64;
#5 LnR=1; S=8; D=100;
#5 LnR=0; S=8; D=100;
#5 LnR=1; S=2; D=40;
#5 LnR=0; S=2; D=40;
#5 LnR=1; S=20; D=1;
#5 LnR=0; S=20; D=1;
#5 LnR=1; S=0; D=7;
#5 LnR=0; S=0; D=7;
#5 LnR=1; S=1; D=100;
#5 LnR=0; S=1; D=100;
#5 LnR=0; S=1; D=100;
end 
endmodule;

module SHIFT32_TB;

reg [31:0] D;
reg [31:0] S;
wire [31:0] Y;
reg LnR;

SHIFT32 inst_shift_32bit(.Y(Y), .D(D), .S(S), .LnR(LnR));

initial
begin
#5 LnR=1; S=1; D=64;
#5 LnR=0; S=1; D=64;
#5 LnR=1; S=8; D=100;
#5 LnR=0; S=8; D=100;
#5 LnR=1; S=2; D=40;
#5 LnR=0; S=2; D=40;
#5 LnR=1; S=20; D=1;
#5 LnR=0; S=20; D=1;
#5 LnR=1; S=100; D=7;
#5 LnR=0; S=100; D=7;
#5 LnR=1; S=1; D=100;
#5 LnR=0; S=1; D=100;
#5 LnR=0; S=1; D=100;
end 

endmodule;