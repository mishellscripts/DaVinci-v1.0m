// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

// TBD
reg pc_load, pc_sel_1, pc_sel_2, pc_sel_3, mem_r, mem_w,
r1_sel_1, reg_r, reg_w, wa_sel_1, wa_sel_2, wa_sel_3,
wd_sel_1, wd_sel_2, wd_sel_3, sp_load, op1_sel_1, op2_sel_1,
op2_sel_2, op2_sel_3, op2_sel_4, alu_oprn, ma_sel_1, dmem_r,
dmem_w, md_sel_1, ir_load, ma_sel_2;

initial begin
pc_load = CTRL[0];
pc_sel_1 = CTRL[1];
pc_sel_2 = CTRL[2];
pc_sel_3 = CTRL[3];
mem_r = CTRL[4]; 
mem_w = CTRL[5];
r1_sel_1 = CTRL[6]; 
reg_r = CTRL[7]; 
reg_w = CTRL[8]; 
wa_sel_1 = CTRL[9];
wa_sel_2 = CTRL[10];
wa_sel_3 = CTRL[11];
wd_sel_1 = CTRL[12]; 
wd_sel_2 = CTRL[13];
wd_sel_3 = CTRL[14];
sp_load = CTRL[15]; 
op1_sel_1 = CTRL[16]; 
op2_sel_1 = CTRL[17];
op2_sel_2 = CTRL[18];
op2_sel_3 = CTRL[19];
op2_sel_4 = CTRL[20]; 
alu_oprn = CTRL[21]; 
ma_sel_1 = CTRL[22]; 
dmem_r = CTRL[23];
dmem_w = CTRL[24]; 
md_sel_1 = CTRL[25]; 
ir_load = CTRL[26];
ma_sel_2 = CTRL[27];
end

/* =================== Parse data (instruction) ====================== */
reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  immediate;
reg [25:0]  address;
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = DATA_IN;
// I-type
{opcode, rs, rt, immediate } = DATA_IN;
// J-type
{opcode, address} = DATA_IN;

wire [31:0] rs_or_zero;
MUX32_2x1 inst_mux_32bit(.Y(rs_or_zero), .I0(32'b0), .I1({27'b0, rs}), .S(r1_sel_1));

wire [31:0] r1_data;
wire [31:0] r2_data;

REGISTER_FILE_32x32 inst_reg_32x32(.DATA_R1(r1_data), .DATA_R2(r2_data), .ADDR_R1(rs_or_zero), .ADDR_R2(rt), 
                            	   .DATA_W(), .ADDR_W(), .READ(reg_r), .WRITE(reg_w), .CLK(CLK), .RST(RST));

defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q(pc), .D(next_pc), .LOAD(pc_load), .CLK(CLK), .RESET(RST));

defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(sp), .D(next_sp), .LOAD(sp_load), .CLK(CLK), .RESET(RST));

/* ================ PC selection =================== */
wire [31:0] pc_adder_out1;
RC_ADD_SUB_32 inst_pcadd_1(.Y(pc_adder_out1), .CO(CO), .A(next_pc), .B({31'b0, 1'b1}), .SnA(1'b0));

wire [31:0] jump_reg_or_increment;
MUX32_2x1 inst_mux_jr(.Y(jump_reg_or_increment), .I0(), .I1(pc_adder_1), .S(pc_sel_1));

// Add with sign extended immediate
wire [31:0] pc_adder_out2;
RC_ADD_SUB_32 inst_pcadd_2(.Y(pc_adder_out2), .CO(CO), .A(pc_adder_out1), .B(), .SnA(1'b0));

wire [31:0] pc_or_add;
MUX32_2x1 inst_mux_pcadd(.Y(pc_or_add), .I0(jump_reg_or_increment), .I1(pc_adder_out2), .S(pc_sel_2));

wire [31:0] jump_or_res;
MUX32_2x1 inst_mux_j(.Y(jump_or_res), .I0(), .I1(pc_or_add), .S(pc_sel_3));




endmodule

