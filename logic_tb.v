`include "prj_definition.v"
`timescale 1ns/1ps

module SR_LATCH_TB;
reg S, R, C, nP, nR;
wire Q,Qbar;

SR_LATCH inst_sr_latch(.Q(Q), .Qbar(Qbar), .S(S), .R(R), .C(C), .nP(nP), .nR(nR));

initial
begin
#5 C=1'b0; S=1'bx; R=1'bx; 
#5 C=1'b0; S=1'bx; R=1'bx;
#5 C=1'b1; S=1'b1; R=1'b0;
#5 C=1'b1; S=1'b0; R=1'b1;
#5 C=1'b1; S=1'b0; R=1'b0;
#5 C=1'b1; S=1'b0; R=1'b0;
#5 C=1'b1; S=1'b1; R=1'b1;#5 C=1'b1; S=1'b1; R=1'b1;
end

endmodule;

module D_LATCH_TB;
reg D, C, nP, nR;
wire Q,Qbar;

D_LATCH inst_d_latch(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));

initial
begin
#5 C=1'b0; D=1'bx; 
#5 C=1'b1; D=1'b1;
#5 C=1'b1; D=1'b0;
end

endmodule;

module D_FF_TB;
reg D, C, nP, nR;
wire Q,Qbar;

D_FF inst_d_ff(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));

// Preset on nP=0, nR=1, reset on nP=1, nR=0;

initial 
begin
nR = 0;
nP = 1;
end

//always #5 nC=~nC;

initial
begin
#10 C=1'bx; D=1'bx; nP=0; nR=1'b0; 
nR = 0;
nP = 1;
#10 C=1'bx; D=1'bx; nP=0; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'bx; D=1'bx; nP=1; nR=1'b0;
nR = 0;
nP = 1;
#10 C=1'b0; D=1'bx; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b0; D=1'bx; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b1; D=1'b0; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b1; D=1'b1; nP=1; nR=1'b1;
nR = 0;
nP = 1;#10 C=1'b1; D=1'b1; nP=1; nR=1'b1;
end
endmodule;

module REG1_TB;
reg D, C, L, nP, nR;
wire Q,Qbar;

REG1 inst_reg1(.Q(Q), .Qbar(Qbar), .D(D), .L(L), .C(C), .nP(nP), .nR(nR));

// Preset on nP=0, nR=1, reset on nP=1, nR=0;
initial 
begin
nR = 0;
nP = 1;
end

initial
begin
#10 C=1'bx; D=1'bx; nP=0; nR=1'b0; 
nR = 0;
nP = 1;
#10 C=1'bx; D=1'bx; nP=0; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'bx; D=1'bx; nP=1; nR=1'b0;
nR = 0;
nP = 1;
#10 C=1'b0; D=1'bx; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b0; D=1'bx; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b1; D=1'b0; nP=1; nR=1'b1;
nR = 0;
nP = 1;
#10 C=1'b1; D=1'b1; nP=1; nR=1'b1;
nR = 0;
nP = 1;#10 C=1'b1; D=1'b1; nP=1; nR=1'b1;
end

endmodule;



