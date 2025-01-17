// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

wire [31:0] decoder_5x32_out;
wire [31:0] L;
DECODER_5x32 inst_decoder_5x32(.D(decoder_5x32_out), .I(ADDR_W));

always @(WRITE) begin
$write("WRITE SIGNAL = %h, ADDR_W = %h, DATA_W = %h\n", WRITE, ADDR_W, DATA_W);
end

always @(posedge CLK) begin
$write("READ SIGNAL = %h, ADDR_R1 = %h\n", READ, ADDR_R1);
$write("READ SIGNAL = %h, ADDR_R2 = %h\n", READ, ADDR_R2);
end

//always @(mux_32x1_res1 or mux_32x1_res2) begin
always @(posedge CLK) begin
$write("DATA_R1 = %h\n", mux_32x1_res1);
$write("DATA_R2 = %h\n", mux_32x1_res2);
end

genvar i;
generate
	for(i=0; i<32; i=i+1)
	begin: load_gen_loop
		and and_inst(L[i], decoder_5x32_out[i], WRITE);
	end
endgenerate

always @(L[1]) begin
$write("Writing %h into address %h, Load[1]= %h\n", DATA_W, ADDR_W, L[1]);
end

// TBD
wire [31:0] reg0_res;
REG32 inst_reg32_0(reg0_res, DATA_W, L[0], CLK, RST);

wire [31:0] reg1_res;
REG32 inst_reg32_1(reg1_res, DATA_W, L[1], CLK, RST);

wire [31:0] reg2_res;
REG32 inst_reg32_2(reg2_res, DATA_W, L[2], CLK, RST);

wire [31:0] reg3_res;
REG32 inst_reg32_3(reg3_res, DATA_W, L[3], CLK, RST);

wire [31:0] reg4_res;
REG32 inst_reg32_4(reg4_res, DATA_W, L[4], CLK, RST);

wire [31:0] reg5_res;
REG32 inst_reg32_5(reg5_res, DATA_W, L[5], CLK, RST);

wire [31:0] reg6_res;
REG32 inst_reg32_6(reg6_res, DATA_W, L[6], CLK, RST);

wire [31:0] reg7_res;
REG32 inst_reg32_7(reg7_res, DATA_W, L[7], CLK, RST);

wire [31:0] reg8_res;
REG32 inst_reg32_8(reg8_res, DATA_W, L[8], CLK, RST);

wire [31:0] reg9_res;
REG32 inst_reg32_9(reg9_res, DATA_W, L[9], CLK, RST);

wire [31:0] reg10_res;
REG32 inst_reg32_10(reg10_res, DATA_W, L[10], CLK, RST);

wire [31:0] reg11_res;
REG32 inst_reg32_11(reg11_res, DATA_W, L[11], CLK, RST);

wire [31:0] reg12_res;
REG32 inst_reg32_12(reg12_res, DATA_W, L[12], CLK, RST);

wire [31:0] reg13_res;
REG32 inst_reg32_13(reg13_res, DATA_W, L[13], CLK, RST);

wire [31:0] reg14_res;
REG32 inst_reg32_14(reg14_res, DATA_W, L[14], CLK, RST);

wire [31:0] reg15_res;
REG32 inst_reg32_15(reg15_res, DATA_W, L[15], CLK, RST);

wire [31:0] reg16_res;
REG32 inst_reg32_16(reg16_res, DATA_W, L[16], CLK, RST);

wire [31:0] reg17_res;
REG32 inst_reg32_17(reg17_res, DATA_W, L[17], CLK, RST);

wire [31:0] reg18_res;
REG32 inst_reg32_18(reg18_res, DATA_W, L[18], CLK, RST);

wire [31:0] reg19_res;
REG32 inst_reg32_19(reg19_res, DATA_W, L[19], CLK, RST);

wire [31:0] reg20_res;
REG32 inst_reg32_20(reg20_res, DATA_W, L[20], CLK, RST);

wire [31:0] reg21_res;
REG32 inst_reg32_21(reg21_res, DATA_W, L[21], CLK, RST);

wire [31:0] reg22_res;
REG32 inst_reg32_22(reg22_res, DATA_W, L[22], CLK, RST);

wire [31:0] reg23_res;
REG32 inst_reg32_23(reg23_res, DATA_W, L[23], CLK, RST);

wire [31:0] reg24_res;
REG32 inst_reg32_24(reg24_res, DATA_W, L[24], CLK, RST);

wire [31:0] reg25_res;
REG32 inst_reg32_25(reg25_res, DATA_W, L[25], CLK, RST);

wire [31:0] reg26_res;
REG32 inst_reg32_26(reg26_res, DATA_W, L[26], CLK, RST);

wire [31:0] reg27_res;
REG32 inst_reg32_27(reg27_res, DATA_W, L[27], CLK, RST);

wire [31:0] reg28_res;
REG32 inst_reg32_28(reg28_res, DATA_W, L[28], CLK, RST);

wire [31:0] reg29_res;
REG32 inst_reg32_29(reg29_res, DATA_W, L[29], CLK, RST);

wire [31:0] reg30_res;
REG32 inst_reg32_30(reg30_res, DATA_W, L[30], CLK, RST);

wire [31:0] reg31_res;
REG32 inst_reg32_31(reg31_res, DATA_W, L[31], CLK, RST);

wire [31:0] mux_32x1_res1;
wire [31:0] mux_32x1_res2;

MUX32_32x1 inst_mux_32x1_1(mux_32x1_res1, reg0_res, reg1_res, reg2_res, reg3_res, 
			  	reg4_res, reg5_res, reg6_res, reg7_res, reg8_res,
				reg9_res, reg10_res, reg11_res, reg12_res, reg13_res,
				reg14_res, reg15_res, reg16_res, reg17_res, reg18_res,
				reg19_res, reg20_res, reg21_res, reg22_res, reg23_res,
				reg24_res, reg25_res, reg26_res, reg27_res, reg28_res,
				reg29_res, reg30_res, reg31_res, ADDR_R1);

MUX32_32x1 inst_mux_32x1_2(mux_32x1_res2, reg0_res, reg1_res, reg2_res, reg3_res, 
			  	reg4_res, reg5_res, reg6_res, reg7_res, reg8_res,
				reg9_res, reg10_res, reg11_res, reg12_res, reg13_res,
				reg14_res, reg15_res, reg16_res, reg17_res, reg18_res,
				reg19_res, reg20_res, reg21_res, reg22_res, reg23_res,
				reg24_res, reg25_res, reg26_res, reg27_res, reg28_res,
				reg29_res, reg30_res, reg31_res, ADDR_R2);

MUX32_2x1 inst_mux_2x1_1(DATA_R1, {`DATA_WIDTH{1'bz} }, mux_32x1_res1, READ);

MUX32_2x1 inst_mux_2x1_2(DATA_R2, {`DATA_WIDTH{1'bz} }, mux_32x1_res2, READ);

endmodule

