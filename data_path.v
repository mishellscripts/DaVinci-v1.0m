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
//output [`DATA_INDEX_LIMIT:0] DATA_OUT;

// input list
//input [`DATA_INDEX_LIMIT:0] INSTRUCTION;
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

// TBD
reg pc_load, pc_sel_1, pc_sel_2, pc_sel_3, mem_r, mem_w,
r1_sel_1, reg_r, reg_w, wa_sel_1, wa_sel_2, wa_sel_3,
wd_sel_1, wd_sel_2, wd_sel_3, sp_load, op1_sel_1, op2_sel_1,
op2_sel_2, op2_sel_3, op2_sel_4, ma_sel_1, dmem_r,
dmem_w, md_sel_1, ir_load, ma_sel_2;
reg [5:0] alu_oprn;

reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  immediate;
reg [25:0]  address;

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
alu_oprn = CTRL[26:21]; 
ma_sel_1 = CTRL[27]; 
dmem_r = CTRL[28];
dmem_w = CTRL[29]; 
md_sel_1 = CTRL[30]; 
ir_load = CTRL[31];
//ma_sel_2 = CTRL[31];

/* =================== Parse data (instruction) ====================== */
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = DATA_IN;
// I-type
{opcode, rs, rt, immediate } = DATA_IN;
// J-type
{opcode, address} = DATA_IN;
end

/* ============== WRITE selection ================ */
// Write address
wire [31:0] rt_or_rd;
MUX32_2x1 inst_mux_wa1(.Y(rt_or_rd), .I0({27'b0,rd}), .I1({27'b0,rt}), .S(wa_sel_1));

wire [31:0] zero_or_31;
MUX32_2x1 inst_mux_wa2(.Y(zero_or_31), .I0(32'b0), .I1({27'b0, 5'b1}), .S(wa_sel_2));

wire [31:0] is_stack_op;
MUX32_2x1 inst_mux_wa3(.Y(is_stack_op), .I0(zero_or_31), .I1(rt_or_rd), .S(wa_sel_3));

/* ================= DATA MEMORY WRITE =================== */
wire [31:0] mem_or_alu;
wire [31:0] alu_out;
MUX32_2x1 inst_mux_dmemw1(.Y(mem_or_alu), .I0(alu_out), .I1(DATA_IN), .S(wd_sel_1));

wire [31:0] is_write_imm;
MUX32_2x1 inst_mux_dmemw2(.Y(is_write_imm), .I0(mem_or_alu), .I1({immediate, 16'b0}), .S(wd_sel_2));

wire [31:0] is_pc_add1;
wire [31:0] pc_adder_out1;
MUX32_2x1 inst_mux_dmemw3(.Y(is_pc_add1), .I0(pc_adder_out1), .I1(is_write_imm), .S(wd_sel_3));


/* ================== init REG FILE ==================== */

wire [31:0] rs_or_zero;
MUX32_2x1 inst_mux_32bit(.Y(rs_or_zero), .I0(32'b0), .I1({27'b0, rs}), .S(r1_sel_1));

wire [31:0] r1_data;
wire [31:0] r2_data;

REGISTER_FILE_32x32 inst_reg_32x32(.DATA_R1(r1_data), .DATA_R2(r2_data), .ADDR_R1(rs_or_zero[4:0]), .ADDR_R2(rt), 
                            	   .DATA_W(is_pc_add1), .ADDR_W(is_stack_op[4:0]), .READ(reg_r), .WRITE(reg_w), .CLK(CLK), .RST(RST));

/* ================ PC selection =================== */
wire [31:0] pc;
wire [31:0] sp;
wire [31:0] next_pc;
wire [31:0] next_sp;

defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q(pc), .D(next_pc), .LOAD(pc_load), .CLK(CLK), .RESET(RST));

defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(sp), .D(next_sp), .LOAD(sp_load), .CLK(CLK), .RESET(RST));

//wire [31:0] pc_adder_out1;
RC_ADD_SUB_32 inst_pcadd_1(.Y(pc_adder_out1), .CO(CO), .A(next_pc), .B({31'b0, 1'b1}), .SnA(1'b0));

wire [31:0] jump_reg_or_increment;
MUX32_2x1 inst_mux_jr(.Y(jump_reg_or_increment), .I0(r1_data), .I1(pc_adder_out1), .S(pc_sel_1));

// Add with sign extended immediate
wire [31:0] pc_adder_out2;
RC_ADD_SUB_32 inst_pcadd_2(.Y(pc_adder_out2), .CO(CO), .A(pc_adder_out1), .B(), .SnA(1'b0));

wire [31:0] pc_or_add;
MUX32_2x1 inst_mux_pcadd(.Y(pc_or_add), .I0(jump_reg_or_increment), .I1(pc_adder_out2), .S(pc_sel_2));

wire [31:0] jump_or_res;
MUX32_2x1 inst_mux_j(.Y(jump_or_res), .I0(), .I1(pc_or_add), .S(pc_sel_3));

/* ================= OPERAND select for ALU =================== */
wire [31:0] shamt_or_1;
MUX32_2x1 inst_mux_op1(.Y(shamt_or_1), .I0({31'b0, 1'b1}), .I1({27'b0, shamt}), .S(op2_sel_1));

wire [31:0] zero_or_sign_ext;
wire [31:0] sign_extended_imm;
assign sign_extended_imm = $signed(immediate);
MUX32_2x1 inst_mux_op2(.Y(zero_or_sign_ext), .I0({16'b0, immediate}), .I1(sign_extended_imm), .S(op2_sel_2));

wire [31:0] shamt_or_imm;
MUX32_2x1 inst_mux_op3(.Y(shamt_or_imm), .I0(zero_or_sign_ext), .I1(shamt_or_1), .S(op2_sel_3));

// Alu select
wire [31:0] rf_or_sp;
MUX32_2x1 inst_mux_alu1(.Y(rf_or_sp), .I0(r1_data), .I1(next_sp), .S(op1_sel_1));

wire [31:0] is_r_type;
MUX32_2x1 inst_mux_alu2(.Y(is_r_type), .I0(shamt_or_imm), .I1(r2_data), .S(op2_sel_4));

// Alu instantiation
//wire [31:0] alu_out;
wire [31:0] zero_out;
ALU inst_ALU(.A(rf_or_sp), .B(is_r_type), .OPRN(alu_oprn), .Y(alu_out), .ZERO(zero_out));
assign ZERO = zero_out[0];

/* ================= DATA MEMORY READ =================== */
wire [31:0] stack_or_alu;
MUX32_2x1 inst_mux_dmemr(.Y(stack_or_alu), .I0(alu_out), .I1(next_sp), .S(ma_sel_1));

// Mem data output
//wire [31:0] r1_or_r2;
MUX32_2x1 inst_mux_dmem1(.Y(DATA_OUT), .I0(r2_data), .I1(r1_data), .S(md_sel_1));

// Mem address output
wire [31:0] addr_out;
MUX32_2x1 inst_mux_dmem2(.Y(addr_out), .I0(stack_or_alu), .I1(next_pc), .S(ma_sel_2));

assign ADDR = addr_out[25:0];

assign INSTRUCTION = DATA_IN;

endmodule

