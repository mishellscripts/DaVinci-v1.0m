`include "prj_definition.v"

module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT : ALU output data
//	   ZERO       : Zero flag signal
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------


// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
// Write data to memory
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

// Internal registers
reg [`DATA_INDEX_LIMIT:0] PC_REG = 'h1000;
reg [`DATA_INDEX_LIMIT:0] INST_REG;
reg [`DATA_INDEX_LIMIT:0] SP_REG;
reg [15:0] stored_imm;
reg [15:0] stored_signextimm;
reg [15:0] stored_zeroextimm;
reg [31:0] stored_jump_addr;
reg [5:0] stored_opcode;
reg [5:0] stored_funct;
reg [4:0] stored_rd;
reg [4:0] stored_rs;
reg [4:0] stored_rt;
reg [4:0] stored_shamt;

// Registers for output ports
reg [`ADDRESS_INDEX_LIMIT:0]  mem_addr;
reg mem_read, mem_write;
reg rf_read = 1'b1;
reg rf_write = 1'b0;
reg [`DATA_INDEX_LIMIT:0]  alu_op1, alu_op2;
reg [`ALU_OPRN_INDEX_LIMIT:0] alu_oprn;
reg [`ADDRESS_INDEX_LIMIT:0] rf_addr_w, rf_addr_r1, rf_addr_r2;
reg [`DATA_INDEX_LIMIT:0] mem_datax;
reg [`DATA_INDEX_LIMIT:0] rf_data_w;
reg zero; // zero flag

//reg reset;

// Registers for input ports
reg [`DATA_INDEX_LIMIT:0] rf_datar1, rf_datar2;

assign MEM_ADDR = mem_addr;
assign MEM_READ = mem_read; 
assign MEM_WRITE = mem_write;

assign MEM_DATA = ((MEM_READ===1'b0)&&(MEM_WRITE===1'b1))?mem_datax:{`DATA_WIDTH{1'bz} };

assign ALU_OP1 = alu_op1;
assign ALU_OP2 = alu_op2;
assign ALU_OPRN = alu_oprn;

assign RF_READ = rf_read;
assign RF_WRITE = rf_write;
assign RF_ADDR_W = rf_addr_w;
assign RF_ADDR_R1 = rf_addr_r1;
assign RF_ADDR_R2 = rf_addr_r2;
assign RF_DATA_W = rf_data_w;

//assign RF_DATA_R1 = ((RF_READ===1'b0)&&(RF_WRITE===1'b1))?rf_datar1:{`DATA_WIDTH{1'bz} };
//assign RF_DATA_R2 = ((RF_READ===1'b0)&&(RF_WRITE===1'b1))?rf_datar2:{`DATA_WIDTH{1'bz} };

assign ZERO = zero;

//assign RST = reset;

////////////////////////////////////////////////////////////////////////////////////////
task print_instruction;
input [`DATA_INDEX_LIMIT:0] inst;
reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  immediate;
reg [25:0]  address;
begin
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = inst;
// I-type
{opcode, rs, rt, immediate } = inst;
// J-type
{opcode, address} = inst;

$write("@ %6dns -> [0X%08h] ", $time, inst);

case(opcode)
// R-Type
6'h00 : begin
            case(funct)
                6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 		6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h00: $write("sll  r[%02d], %2d, r[%02d];", rs, shamt, rd);
                6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
                6'h08: $write("jr   r[%02d];", rs);
                default: begin $write("");
		end
            endcase
        end
// I-type
6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0f : $write("lui   r[%02d], 0X%04h;", rt, immediate);
6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
// J-Type
6'h02 : $write("jmp   0X%07h;", address);
6'h03 : $write("jal   0X%07h;", address);
6'h1b : $write("push;");
6'h1c : $write("pop;");
default: $write("");
endcase


// Store values
stored_imm = immediate;
stored_signextimm = $signed(immediate);
stored_zeroextimm = {16'b0, immediate};
stored_jump_addr = {6'b0, address}; 
stored_opcode = opcode; 
stored_funct = funct;
stored_rs = rs;
stored_rd = rd;
stored_rt = rt;

$write("\n");
end
endtask
/////////////////////////////////////////////////////////////////////////////////////

// State nets
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

always @ (proc_state)
begin
$write("Current state: %3h\n", proc_state);
// TBD: Code for the control unit model
  if (proc_state === `PROC_FETCH) begin
	//$write("WB: Result in [rt] = %5h\n", RF_DATA_R2);
	//$write("------------------\n");

	//reset = 1'b0;
     // Set memory address to PC, memory control for read operation
     mem_addr = PC_REG;
     mem_read=1'b1; mem_write=1'b0;
     // Set register file control to hold {r,w} to 00 or 11
	rf_read=1'b0; rf_write=1'b0;
 	$write("FETCH: Mem read from address %3h\n", mem_addr);
	$write("------------------\n");
	//reset = 1'b1;
  end
  else if (proc_state === `PROC_DECODE) begin
     // Store memory read data into INST_REG 
     $write("DECODE: Mem read returning: %8h\n", MEM_DATA);
     INST_REG = MEM_DATA;
     print_instruction(INST_REG);
	//reset = 1'b0;
	rf_read= 1'b1; rf_addr_r1 = stored_rs; rf_addr_r2 = stored_rt;
	//$write("RF read %d, write %d\n", RF_READ, RF_WRITE);
	//reset = 1'b1;
     $write("------------------\n");
  end
  else if (proc_state === `PROC_EXE) begin
     // Set ALU operand and operation code (except lui, jmp, jal; no operand/operation)
	// Prepare to get R[rs]
	// R-Type (except jr)
	if (stored_opcode === 6'h00 && stored_funct !== 6'h08) begin
	   $write("EXE: R type except jr\n");
	   alu_oprn = stored_funct;
	   alu_op1 = RF_DATA_R1; // R[rs]
	   // If sll or srl instruction, use shamt
           if (stored_funct === 6'h00 || stored_funct === 6'h02) begin
  		alu_op2 = stored_shamt;
	   end
	   // Else, use rt
	   else
	   	alu_op2 = RF_DATA_R2; // R[rt]
	$write("R[rs] = %5h, R[rt] = %5h, Opcode = %5h\n", alu_op1, alu_op2, alu_oprn);
	end

	// I-Type (not including lui = 6'h0f and branch I-type (6'h04, 6'h05))
	if (stored_opcode !== 6'h02 && stored_opcode !== 6'h03 && stored_opcode !== 6'h1b && stored_opcode !== 6'h1c 
		&& stored_opcode !== 6'h0f && stored_opcode !== 0) begin
           $write("EXE: I type\n");
	   alu_op1 = RF_DATA_R1; // R[rs] 

	   // For andi and ori, use ZeroExtImm
	   if (stored_opcode === 6'h0c || stored_opcode === 6'h0d) begin        
		alu_op2 = stored_zeroextimm;
	   end
	   else begin
		alu_op2 = stored_signextimm;
	   end

	   // Add memory address for SW
	   if (stored_opcode === 6'h2b) begin
		alu_oprn = 6'h08;
	   end
	   // Beq, Bne instruction
	   else if (stored_opcode === 6'h04 || stored_opcode === 6'h05) begin
             alu_op1 = RF_DATA_R1; // R[rs]
	     alu_op2 = RF_DATA_R2; // R[rt]
	     alu_oprn = 6'h22; //sub op
	   end
	  else begin
	     alu_oprn = stored_opcode;
	  end
        end

	// Lui, jmp, jal
	if (stored_opcode === 6'h0f || stored_opcode === 6'h02 || stored_opcode === 6'h03) begin
	   // Do nothing
	end 

	// Push instruction
	if (stored_opcode === 6'h1b) begin
           alu_op1 = SP_REG;
	   alu_op2 = 1;
	   alu_oprn = 6'h22; //sub op
	   // set RF ADDR_R1 to be 0
	   rf_addr_r1 = 0;
	end

	// Pop instruction
	if (stored_opcode === 6'h1c) begin
           alu_op1 = SP_REG;
	   alu_op2 = 1;
	   alu_oprn = 6'h20; //add
	end

	$write("op1: %3h, op2: %3h, oprn: %3h\n", alu_op1, alu_op2, alu_oprn);
	$write("------------------\n");
  end
  else if (proc_state === `PROC_MEM) begin
	$write("MEM:\n");
     // Only lw, sw, push, pop
     // Default make memory operation 00 or 11
	mem_read=1'b0; mem_write=1'b0; 

	// Lw instruction
     	if (stored_opcode === 6'h23) begin 
	  mem_read=1'b1; mem_write=1'b0; mem_addr = ALU_RESULT;
	end
	
	// Sw instruction
	else if (stored_opcode === 6'h2b) begin
	 $write("Store %5h in Memory address = %5h + %5h, Opcode = %5h\n", ALU_RESULT, alu_op1, alu_op2, alu_oprn);
	  mem_read=1'b0; mem_write=1'b1; mem_addr = ALU_RESULT; 
	  mem_datax = RF_DATA_R2;
	end 

	// Push instruction
	else if (stored_opcode === 6'h1b) begin
	  mem_read=1'b0; mem_write=1'b1; mem_addr = SP_REG;
	  mem_datax = RF_DATA_R1; // M[SP_REG] = R[0]
	end 

	// Pop instruction
	else if (stored_opcode === 6'h1c) begin
	  mem_read=1'b1; mem_write=1'b0; mem_addr = SP_REG; 
	  // Set reg file afterwards
	end 
	else begin
	$write("No memory access\n");
	end
	$write("------------------\n");
  end
  else if (proc_state === `PROC_WB) begin
	$write("WRITEBACK:\n");
     // Write back to RF or PC_REG(beq, bne, jmp, jal)
     // Increase PC_REG BY 1 
	PC_REG = PC_REG + 1;
     // Reset memory write signal to no-op (00 or 11)
	mem_read=1'b0; mem_write=1'b0; 
     // Set RF writing address and data/control to write back into RF

	// R-Type
	if (stored_opcode === 6'h00 && stored_funct !== 6'h08) begin
	  rf_read=1'b0; rf_write=1'b1; rf_addr_w = stored_rd; rf_data_w = ALU_RESULT; 
	end

	// Jump register
	if (stored_opcode === 6'h00 && stored_funct === 6'h08) begin
          rf_read=1'b1; rf_write=1'b0; // rf_addr_r1 already is rs, turn on to get data from rf
	  PC_REG = RF_DATA_R1; // PC = R[rs]
	end

	// I-Type except beq, bne, sw, lui
	if (stored_opcode !== 6'h02 && stored_opcode !== 6'h03 && stored_opcode !== 6'h1b && stored_opcode !== 6'h1c 
		&& stored_opcode !== 0 && stored_opcode !== 6'h2b) begin
	   // Write to R[rt]
	   rf_read=1'b0; rf_write=1'b1; rf_addr_w = rf_addr_r2;

	   // If load word instruction, get memory data
	   if (stored_opcode === 6'h23) begin
		rf_data_w = mem_datax; // R[rt] = memory data
	   end

	   // If lui instruction, extend imm
	   else if (stored_opcode === 6'h0f) begin
	        rf_data_w = {stored_imm, 16'b0}; // Maybe supposed to do this before?
	   end

	   // If beq instruction
	   else if (stored_opcode === 6'h04) begin
		// If zero flag is on, R[rs] == R[rt]
		if (zero) begin
		  PC_REG = PC_REG + stored_signextimm;
		end
	   end

	   // If bne instruction (opp of beq)
	   else if (stored_opcode === 6'h05) begin
		// If zero flag is on, R[rs] == R[rt]
		if (!zero) begin
		  PC_REG = PC_REG + stored_signextimm;
		end

	   end
	   else begin
	        rf_data_w = ALU_RESULT; // R[rt] = result from ALU
		$write("R[%3h] set to %5h\n", rf_addr_w, ALU_RESULT);
	   end

	end

	// Jump instruction
	if (stored_opcode === 6'h02) begin
	   PC_REG = stored_jump_addr;
	end

	// Jal instruction
	if (stored_opcode === 6'h03) begin
	// Write to R[31]
	   rf_read=1'b0; rf_write=1'b1; rf_addr_w = 31;
	   rf_data_w = PC_REG;
	   PC_REG = stored_jump_addr;
	end 
	 $write("------------------\n");
  end
end

endmodule;

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

// TBD - implement the state machine here
reg [2:0] state;
reg [2:0] next_state;

assign STATE = state;

initial
begin
  state = 2'bxx;
  next_state = `PROC_FETCH;
end

// reset neg edge of RST
always @ (negedge RST)
begin
  state = 2'bxx;
  next_state = `PROC_FETCH;
end

// pos edge of clock, change state
always @ (posedge CLK)
begin
  state = next_state;
end

// state switching depending on current state
always @ (state)
begin
  if (state === `PROC_FETCH) begin
     next_state = `PROC_DECODE;
  end
  if (state === `PROC_DECODE) begin
     next_state = `PROC_EXE;
  end
  if (state === `PROC_EXE) begin
     next_state = `PROC_MEM;
  end
  if (state === `PROC_MEM) begin
     next_state = `PROC_WB;
  end
  if (state === `PROC_WB) begin
     next_state = `PROC_FETCH;
  end
end
endmodule;