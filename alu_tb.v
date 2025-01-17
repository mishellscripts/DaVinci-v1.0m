`include "prj_definition.v"
`timescale 1ns/1ps

module ALU_TB;

reg [31:0] A;
reg [31:0] B;
reg [5:0] OPRN;
wire [31:0] Y;
wire [31:0] ZERO;

ALU alu_inst(.A(A), .B(B), .OPRN(OPRN), .Y(Y), .ZERO(ZERO));

initial
begin

// Add
#5 A=5; B=7; OPRN=1;
// Sub
#5 A=32'h03fffffff; B=1; OPRN=2;
// Sub
#5 A=100; B=7; OPRN=2;
// Mul
#5 A=5; B=7; OPRN=3;
// Shift R
#5 A=5; B=7; OPRN=4;
// Shift R
#5 A=5; B=1; OPRN=4;
// Shift L
#5 A=5; B=1; OPRN=5;
// Shift L
#5 A=5; B=7; OPRN=5;
// And
#5 A=5; B=7; OPRN=6;
// Or
#5 A=5; B=7; OPRN=7;
// Nor
#5 A=5; B=7; OPRN=8;
// Slt
#5 A=5; B=7; OPRN=9;
// Slt
#5 A=5; B=7; OPRN=9;
end 
endmodule;
