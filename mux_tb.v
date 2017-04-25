`include "prj_definition.v"
`timescale 1ns/1ps

module MUX_TB;
//reg I0, I1, S;
//wire Y;

reg [31:0] I0;
reg [31:0] I1;
reg S;
wire [31:0] Y;

//MUX1_2x1 inst_mux_2x1(.Y(Y),.I0(I0), .I1(I1), .S(S));
MUX32_2x1 inst_mux_32bit(.Y(Y),.I0(I0), .I1(I1), .S(S));

initial
begin
#5 S=1; I0=1; I1=1;
#5 S=0; I0=0; I1=1;
#10 S=1; I0=1; I1=0;
end

endmodule;