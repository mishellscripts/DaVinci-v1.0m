`timescale 1ns/1ps

// Testing and
module AND_32BIT_TB;
reg [31:0] A;
reg [31:0] B;
wire [31:0] Y;

AND32_2x1 and_32_bit_inst(.Y(Y),.A(A),.B(B));


initial
begin
#5 A=32'h00000000; B=32'hffffffff;
#5 A=32'hffffffff; B=32'hffffffff;
#5 A=32'h00000000; B=32'h00000000;
#5 A=32'h00000000; B=32'h00000000;
end

endmodule;



// Testing or
module OR_32BIT_TB;
reg [31:0] A;
reg [31:0] B;
wire [31:0] Y;

OR32_2x1 nor_32_bit_inst(.Y(Y),.A(A),.B(B));

initial
begin
#5 A=32'h00000000; B=32'hffffffff;
#5 A=32'hffffffff; B=32'hffffffff;
#5 A=32'h00000000; B=32'h00000000;
#5 A=32'h00000000; B=32'h00000000;
end
endmodule;



// Testing nor
module NOR_32BIT_TB;
reg [31:0] A;
reg [31:0] B;
wire [31:0] Y;

NOR32_2x1 or_32_bit_inst(.Y(Y),.A(A),.B(B));

initial
begin
#5 A=32'h00000000; B=32'hffffffff;
#5 A=32'hffffffff; B=32'hffffffff;
#5 A=32'h00000000; B=32'h00000000;
#5 A=32'h00000000; B=32'h00000000;
end
endmodule;




// Testing inverter
module INV_32BIT_TB;
reg [31:0] A;
wire [31:0] Y;

INV32_1x1 INV_32_bit_inst(.Y(Y),.A(A));

initial
begin
#5 A=32'h00000000;
#5 A=32'hffffffff;
#5 A=32'h00000000;
end
endmodule;


