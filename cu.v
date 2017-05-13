// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;
 
reg [5:0]   opcode;
reg [4:0]   rs;
reg [4:0]   rt;
reg [4:0]   rd;
reg [4:0]   shamt;
reg [5:0]   funct;
reg [15:0]  immediate;
reg [25:0]  address;

initial begin
/* =================== Parse data (instruction) ====================== */
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;
// I-type
{opcode, rs, rt, immediate } = INSTRUCTION;
// J-type
{opcode, address} = INSTRUCTION;
end

// TBD - take action on each +ve edge of clock
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state), .CLK(CLK),.RST(RST));

always @ (proc_state)
begin
    // FETCH: Get next instruction from memory with address as content in PC register
    if (proc_state === `PROC_FETCH) begin
	// mem_r = CTRL[4] mem_w = CTRL[5]
        CTRL[4]=1'b1; CTRL[5]=1'b0;
	// pc_load = CTRL[0];
	CTRL[0] = 1'b1;

        // Set register file control to hold
        // reg_r = CTRL[7] reg_w = CTRL[8]
	CTRL[7] = 1'b0; CTRL[8] = 1'b0; 
    end
    // DECODE: Parse instruction and get values from register file
    else if (proc_state === `PROC_DECODE) begin
	//ir_load = CTRL[26]
	CTRL[26] = 1'b1;

	// Set register file control to read
        // reg_r = CTRL[7] reg_w = CTRL[8]
	CTRL[7] = 1'b1; CTRL[8] = 1'b0; 

        // Read R[rs] and R[rt] from register file (rt automatically selected)
        //rf_addr_r1 = stored_rs; rf_addr_r2 = stored_rt;
	//r1_sel_1 = CTRL[6]; 
	CTRL[6] = 1'b0;
    end
    // EXE: Set ALU operand and operation code (except lui, jmp, jal; no operand/operation)
    else if (proc_state === `PROC_EXE) begin
        // R-Type (except jr)
        if (opcode === 6'h00 && stored_funct !== 6'h08) begin 
	    // Select alu operation, alu_oprn = CTRL[21];
	    case(stored_funct)   
	        6'h20: CTRL[21] = `ALU_OPRN_WIDTH'h01; // add
	        6'h22: CTRL[21] = `ALU_OPRN_WIDTH'h02; // sub
	        6'h2c: CTRL[21] = `ALU_OPRN_WIDTH'h03; // mul
	        6'h24: CTRL[21] = `ALU_OPRN_WIDTH'h06; // and
	        6'h25: CTRL[21] = `ALU_OPRN_WIDTH'h07; // or
	        6'h27: CTRL[21] = `ALU_OPRN_WIDTH'h08; // nor
	        6'h2a: CTRL[21] = `ALU_OPRN_WIDTH'h09; // slt
	        6'h00: CTRL[21] = `ALU_OPRN_WIDTH'h05; // sll
	        6'h02: CTRL[21] = `ALU_OPRN_WIDTH'h04; // srl
	    endcase

	    //op1_sel_1 = CTRL[16]; 
	    //op2_sel_1 = CTRL[17];
	    //op2_sel_2 = CTRL[18];
	    //op2_sel_3 = CTRL[19];
	    //op2_sel_4 = CTRL[20]; 

            // Select first alu operand
	    CTRL[16] = 1'b0; //R[rs] - always for R-type

	    // Select second alu operand
	    // If sll or srl instruction, use shamt for op2
            if (stored_funct === 6'h00 || stored_funct === 6'h02) begin
  	        CTRL[17] = 1'b1;
		CTRL[19] = 1'b1;
		CTRL[20] = 1'b0; 
	    // Else, use rt for op2
	    else begin
	        CTRL[20] = 1'b1; // R[rt]
        end

        // I-Type (except lui)
        else if (stored_opcode !== 6'h02 && stored_opcode !== 6'h03 && stored_opcode !== 6'h1b 
		&& stored_opcode !== 6'h1c && stored_opcode !== 6'h0f) begin

	    // Select first alu operand
	    alu_op1 = RF_DATA_R1; // R[rs] for all I-type except lui

	    // Select second alu operand: zero ext, sign ext immediate, or R[rt] depending on instruction
	    // For andi and ori, use ZeroExtImm
	    if (stored_opcode === 6'h0c || stored_opcode === 6'h0d)       
	        alu_op2 = stored_zeroextimm;
	    // For beq, bne, use R[rt]
	    else if (stored_opcode === 6'h04 || stored_opcode === 6'h05)
	        alu_op2 = RF_DATA_R2;
	    // For the rest, use SignExtImm
	    else 
	        alu_op2 = stored_signextimm;

	    // Select alu operation
	    case(stored_opcode)   
	        6'h08: alu_oprn = `ALU_OPRN_WIDTH'h01; // add
	        6'h2b: alu_oprn = `ALU_OPRN_WIDTH'h01; // sw
	        6'h1d: alu_oprn = `ALU_OPRN_WIDTH'h03; // muli
	        6'h0c: alu_oprn = `ALU_OPRN_WIDTH'h06; // andi
	        6'h0d: alu_oprn = `ALU_OPRN_WIDTH'h07; // ori
	        6'h0a: alu_oprn = `ALU_OPRN_WIDTH'h09; // slti
	        6'h04: alu_oprn = `ALU_OPRN_WIDTH'h02; // beq
	        6'h05: alu_oprn = `ALU_OPRN_WIDTH'h02; // bne
	    endcase
        end
        // Stack operations
        // Push
        else if (stored_opcode === 6'h1b) begin 
            // set RF ADDR_R1 to be 0
            rf_addr_r1 = 0;
        end
        // Pop instruction
        else if (stored_opcode === 6'h1c) begin
            // Increment stack pointer
            alu_op1 = SP_REG;
            alu_op2 = 1;
            alu_oprn = `ALU_OPRN_WIDTH'h01; //add
        end
    end
    // Only lw, sw, push, pop
    else if (proc_state === `PROC_MEM) begin
        // Default make memory operation 00 or 11
	mem_read=1'b0; mem_write=1'b0; 

	// Lw instruction
     	if (stored_opcode === 6'h23) begin 
	    mem_read=1'b1; mem_write=1'b0; mem_addr = ALU_RESULT;
	end	
	// Sw instruction
	else if (stored_opcode === 6'h2b) begin
	    mem_read=1'b0; mem_write=1'b1; mem_addr = ALU_RESULT; 
	    mem_datax = RF_DATA_R2;
	end 
	// Push instruction
	else if (stored_opcode === 6'h1b) begin
	    mem_read=1'b0; mem_write=1'b1; mem_addr = SP_REG;
	    mem_datax = RF_DATA_R1; // M[SP_REG] = R[0]
	    
            // Decrement stack pointer	    
	    alu_op1 = SP_REG;
	    alu_op2 = 1;
	    alu_oprn = `ALU_OPRN_WIDTH'h02; //sub op
	end 
	// Pop instruction
	else if (stored_opcode === 6'h1c) begin
	    mem_read=1'b1; mem_write=1'b0; mem_addr = SP_REG; 
	end 
    end
    else if (proc_state === `PROC_WB) begin
        if (ALU_RESULT !== 'h03ffffff && stored_opcode === 6'h1b) begin
	    SP_REG = ALU_RESULT;
	end

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
	else if (stored_opcode === 6'h00 && stored_funct === 6'h08) begin
            rf_read=1'b1; rf_write=1'b0; // rf_addr_r1 already is rs, turn on to get data from rf
	    PC_REG = RF_DATA_R1; // PC = R[rs]
	end

	// I-Type except sw, lui
	else if (stored_opcode !== 6'h02 && stored_opcode !== 6'h03 && stored_opcode !== 6'h1b 
		&& stored_opcode !== 6'h1c && stored_opcode !== 6'h2b) begin
	   
	    // Write to R[rt]
	    rf_read=1'b0; rf_write=1'b1; 

	    // If load word instruction, get memory data
	    if (stored_opcode === 6'h23) begin
		rf_addr_w = stored_rt;
		rf_data_w = MEM_DATA; // R[rt] = memory data
	        //$write("R[%3h] set to %5h\n", rf_addr_w, MEM_DATA);
	    end
	    // If lui instruction, extend imm
	    else if (stored_opcode === 6'h0f) begin
	        rf_addr_w = rf_addr_r2;
	        rf_data_w = {stored_imm, 16'b0}; // Maybe supposed to do this before?
	    end
	    // If beq instruction, update PC if zero flag is on
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
		rf_addr_w = rf_addr_r2;
	        rf_data_w = ALU_RESULT; // R[rt] = result from ALU
	    end
        end

	// J-Type
	// Jump instruction
	else if (stored_opcode === 6'h02) begin
	    PC_REG = stored_jump_addr;
	end

	// Jal instruction
	else if (stored_opcode === 6'h03) begin
	    // Write to R[31]
	    rf_read=1'b0; rf_write=1'b1; rf_addr_w = 31;
	    rf_data_w = PC_REG;
	    PC_REG = stored_jump_addr;
	end 
	// Pop instructon
	if (stored_opcode === 6'h1c) begin
	    rf_read=1'b0; rf_write=1'b1; rf_addr_w = 0;
	    rf_data_w = MEM_DATA;
	end 
    end
end

endmodule


//------------------------------------------------------------------------------------------
// Module: PROC_SM
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

// TBD - take action on each +ve edge of clock
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

endmodule