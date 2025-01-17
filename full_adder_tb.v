`timescale 1ns/1ps

module full_adder_tb;
reg A, B, CI;
wire Y, CO;

FULL_ADDER inst_full_adder(.Y(Y), .CO(CO), .A(A), .B(B), .CI(CI));

initial
begin
#5 CI=0; A=0; B=0;
#5 CI=0; A=0; B=1;
#5 CI=0; A=1; B=0;
#5 CI=0; B=1; B=1;
#5 CI=1; B=0; B=0;
#5 CI=1; B=0; B=1;
#5 CI=1; B=1; B=0;
#5 CI=1; B=1; B=1;
end

endmodule;