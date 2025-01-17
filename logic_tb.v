`include "prj_definition.v"
`timescale 1ns/1ps

module SR_LATCH_TB;
reg S, R, C, nP, nR;
wire Q,Qbar;

SR_LATCH inst_sr_latch(.Q(Q), .Qbar(Qbar), .S(S), .R(R), .C(C), .nP(nP), .nR(nR));

initial
begin
nP=1; nR=1;
#100 C=1'b1; S=1'b1; R=1'b0; 
#100 $write("1: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("1: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 nP=1'b1; nR=1'b0;
#100 $write("1: Q= %1h; Qbar= %1h\n", Q, Qbar);
end

/*initial
begin
nP=1; nR=1;

#100 C=1'b0; S=1'bx; R=1'bx; 
   $write("1: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("1: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b0; S=1'bx; R=1'bx;
   $write("2: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("2: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b1; S=1'b1; R=1'b0;
   $write("3: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("3: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b1; S=1'b0; R=1'b1;
   $write("4: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("4: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b1; S=1'b0; R=1'b0;
   $write("5: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("5: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b1; S=1'b0; R=1'b0;
   $write("6: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("6: Q= %1h; Qbar= %1h\n", Q, Qbar);

#100 C=1'b1; S=1'b1; R=1'b1;
   $write("7: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("7: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 C=1'b1; S=1'b1; R=1'b1;
   $write("8: Q= %1h; Qbar= %1h\n", Q, Qbar);
#100 $write("8: Q= %1h; Qbar= %1h\n", Q, Qbar);

#2000 $stop;
end*/

/*initial
begin
C = 1'b1;
// Preset on nP=0, nR=1
nP=1; nR=1;
#5 S=0; R=0;
#5 ;
#5 S=0; R=1;
#5 ;
#5 S=1; R=0;
#5 ;#5 S=1; R=1;
#5 ;
#5 S=0; R=0;
#5 ;
#5 S=0; R=1;
#5 ;
#5 S=1; R=0;
#5 ;#5 S=1; R=1;
#5 ;
end
// For ever perform the following task.
always
begin
//#`SYS_CLK_HALF_PERIOD $write(".\n");
#20 C <= ~C;
end*/

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

module REG32_TB;
reg [31:0] D;
reg LOAD, CLK, RESET;
wire [31:0] Q;

REG32 inst_reg32(Q, D, LOAD, CLK, RESET);

initial 
begin
RESET=0;
#5 RESET = 1;
LOAD=1;
CLK=1;

#5 D=32'h00001000;
#5 LOAD=1;
#5 D=32'hffffffff;
#5 LOAD=1;
#5 D=32'h12345678;
#5 LOAD=0;
#5 D=32'hffffffff;
#50 $stop;
end

always
begin
#`SYS_CLK_HALF_PERIOD CLK <= ~CLK;
end
endmodule;

module REG32_PP_TB;
reg [31:0] D;
reg LOAD, CLK, RESET;
wire [31:0] Q;

REG32_PP inst_regpp_32(Q, D, LOAD, CLK, RESET);

initial 
begin
RESET=0;
#5 RESET = 1;
LOAD=1;
CLK=1;

#5 D=32'h00001000;
#5 LOAD=1;
#5 D=32'hffffffff;
#5 LOAD=1;
#5 D=32'h12345678;
#5 LOAD=0;
#5 D=32'hffffffff;
#50 $stop;
end

always
begin
#`SYS_CLK_HALF_PERIOD CLK <= ~CLK;
end
endmodule;

