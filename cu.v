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
reg [`CTRL_WIDTH_INDEX_LIMIT:0] C;

assign CTRL = C;

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
        C[4]=1'b1; C[5]=1'b0;
	// pc_load = CTRL[0];
	C[0] = 1'b1;

        // Set register file control to hold
        // reg_r = CTRL[7] reg_w = CTRL[8]
	C[7] = 1'b0; C[8] = 1'b0; 
    end
    // DECODE: Parse instruction and get values from register file
    else if (proc_state === `PROC_DECODE) begin
	//ir_load = CTRL[26]
	C[26] = 1'b1;

	// Set register file control to read
        // reg_r = CTRL[7] reg_w = CTRL[8]
	C[7] = 1'b1; C[8] = 1'b0; 

        // Read R[rs] and R[rt] from register file (rt automatically selected)
        //rf_addr_r1 = stored_rs; rf_addr_r2 = stored_rt;
	//r1_sel_1 = CTRL[6]; 
	C[6] = 1'b0;
    end
    // EXE: Set ALU operand and operation code (except lui, jmp, jal; no operand/operation)
    else if (proc_state === `PROC_EXE) begin
        // R-Type (except jr)
        if (opcode === 6'h00 && funct !== 6'h08) begin 
	    // Select alu operation, alu_oprn = CTRL[21];
	    case(funct)   
	        6'h20: C[21] = `ALU_OPRN_WIDTH'h01; // add
	        6'h22: C[21] = `ALU_OPRN_WIDTH'h02; // sub
	        6'h2c: C[21] = `ALU_OPRN_WIDTH'h03; // mul
	        6'h24: C[21] = `ALU_OPRN_WIDTH'h06; // and
	        6'h25: C[21] = `ALU_OPRN_WIDTH'h07; // or
	        6'h27: C[21] = `ALU_OPRN_WIDTH'h08; // nor
	        6'h2a: C[21] = `ALU_OPRN_WIDTH'h09; // slt
	        6'h00: C[21] = `ALU_OPRN_WIDTH'h05; // sll
	        6'h02: C[21] = `ALU_OPRN_WIDTH'h04; // srl
	    endcase

	    //op1_sel_1 = CTRL[16]; 
	    //op2_sel_1 = CTRL[17];
	    //op2_sel_2 = CTRL[18];
	    //op2_sel_3 = CTRL[19];
	    //op2_sel_4 = CTRL[20]; 

            // Select first alu operand
	    C[16] = 1'b0; //R[rs] - always for R-type

	    // Select second alu operand
	    // If sll or srl instruction, use shamt for op2
            if (funct === 6'h00 || funct === 6'h02) begin
  	        C[17] = 1'b1;
		C[19] = 1'b1;
		C[20] = 1'b0;
	    end 
	    // Else, use rt for op2
	    else
	        C[20] = 1'b1; // R[rt]
        end

        // I-Type (except lui)
        else if (opcode !== 6'h02 && opcode !== 6'h03 && opcode !== 6'h1b 
		&& opcode !== 6'h1c && opcode !== 6'h0f) begin

	    // Select first alu operand
	    C[16] = 1'b0; // R[rs] for all I-type except lui

	    // Select second alu operand: zero ext, sign ext immediate, or R[rt] depending on instruction
	    // For andi and ori, use ZeroExtImm
	    if (opcode === 6'h0c || opcode === 6'h0d) begin
	        C[18] = 1'b0;
		C[19] = 1'b0;
		C[20] = 1'b0;
	    end 
	    // For beq, bne, use R[rt]
	    else if (opcode === 6'h04 || opcode === 6'h05)
	        C[20] = 1'b1;
	    // For the rest, use SignExtImm
	    else begin
	        C[18] = 1'b1;
		C[19] = 1'b0;
		C[20] = 1'b0;
	    end

	    // Select alu operation
	    case(opcode)   
	        6'h08: C[21] = `ALU_OPRN_WIDTH'h01; // add
	        6'h2b: C[21] = `ALU_OPRN_WIDTH'h01; // sw
	        6'h1d: C[21] = `ALU_OPRN_WIDTH'h03; // muli
	        6'h0c: C[21] = `ALU_OPRN_WIDTH'h06; // andi
	        6'h0d: C[21] = `ALU_OPRN_WIDTH'h07; // ori
	        6'h0a: C[21] = `ALU_OPRN_WIDTH'h09; // slti
	        6'h04: C[21] = `ALU_OPRN_WIDTH'h02; // beq
	        6'h05: C[21] = `ALU_OPRN_WIDTH'h02; // bne
	    endcase
        end
        // Stack operations
        // Push
        else if (opcode === 6'h1b) begin 
            // set RF ADDR_R1 to be 0, r1_sel_1 = CTRL[6];
            C[6] = 1'b1;
        end
        // Pop instruction
        else if (opcode === 6'h1c) begin
            // Increment stack pointer
	    // Alu op1 = 1, op2 = sp reg
            C[17] = 1'b0;
	    C[19] = 1'b1;
	    C[20] = 1'b0;
	    C[16] = 1'b1;
            C[21] = `ALU_OPRN_WIDTH'h01; //add to sp
        end
    end
    // Only lw, sw, push, pop
    else if (proc_state === `PROC_MEM) begin
        // Default make memory operation 00 or 11
	//mem_read=1'b0; mem_write=1'b0; 

	// Lw instruction
     	if (opcode === 6'h23) begin 
	    // dmem_r = CTRL[23] dmem_w = CTRL[24]
            C[23]=1'b1; C[24]=1'b0; 
	    //mem_addr = ALU_RESULT;
	    C[22] = 1'b0;
	end	
	// Sw instruction
	else if (opcode === 6'h2b) begin
	    // dmem_r = CTRL[23] dmem_w = CTRL[24]
            C[23]=1'b0; C[24]=1'b1; 
	    //mem_data = r2data, mem_addr = ALU_RESULT; 
	    C[22] = 1'b0;
	    C[25] = 1'b0;
	    //mem_datax = RF_DATA_R2;
	end 
	// Push instruction
	else if (opcode === 6'h1b) begin
	    C[23]=1'b0; C[24]=1'b1; 
	    //mem_addr = SP_REG;
	    C[22] = 1'b1;
	    //mem_datax = RF_DATA_R1; // M[SP_REG] = R[0]
	    C[25] = 1'b1;

            // Decrement stack pointer	    
	    //alu_op1 = SP_REG;
	    //alu_op2 = 1;
            C[17] = 1'b0;
	    C[19] = 1'b1;
	    C[20] = 1'b0;
	    C[16] = 1'b1;
	    C[21] = `ALU_OPRN_WIDTH'h02; //sub op
	end 
	// Pop instruction
	else if (opcode === 6'h1c) begin
	    C[23]=1'b1; C[24]=1'b0; C[22] = 1'b1; 
	end 
    end
    else if (proc_state === `PROC_WB) begin
        /*if (ALU_RESULT !== 'h03ffffff && stored_opcode === 6'h1b) begin
	    SP_REG = ALU_RESULT;
	end*/

	// Write back to RF or PC_REG(beq, bne, jmp, jal)
        // Increase PC_REG BY 1 
	/*pc_load = CTRL[0];
	pc_sel_1 = CTRL[1];
	pc_sel_2 = CTRL[2];
	pc_sel_3 = CTRL[3];*/
	C[0] = 1'b1;
	C[1] = 1'b1;
	C[2] = 1'b0;
	C[3] = 1'b1;
        
	// Reset memory write signal to no-op (00 or 11)
	//mem_read=1'b0; mem_write=1'b0; 
  	
	/* wa_sel_1 = CTRL[9];
	wa_sel_2 = CTRL[10];
	wa_sel_3 = CTRL[11];
	wd_sel_1 = CTRL[12]; 
	wd_sel_2 = CTRL[13];
	wd_sel_3 = CTRL[14];*/

	// Set RF writing address and data/control to write back into RF
	// R-Type
	if (opcode === 6'h00 && funct !== 6'h08) begin
	    C[7]=1'b0; C[8]=1'b1; 
	    //rf_addr_w = stored_rd; rf_data_w = ALU_RESULT;
	    C[9]=1'b0; C[11]=1'b1;
	    C[12]=1'b0; C[13]=1'b0; C[14]=1'b1;
	end
	// Jump register
	else if (opcode === 6'h00 && funct === 6'h08) begin
            C[7]=1'b1; C[8]=1'b0; // rf_addr_r1 already is rs, turn on to get data from rf
	    //PC_REG = RF_DATA_R1; // PC = R[rs]
	    C[1]=1'b0; C[2]=1'b0; C[3]=1'b1;
	end

	// I-Type except sw, lui
	else if (opcode !== 6'h02 && opcode !== 6'h03 && opcode !== 6'h1b 
		&& opcode !== 6'h1c && opcode !== 6'h2b) begin
	   
	    // Write to R[rt]
	    C[7]=1'b0; C[8]=1'b1; 

	    // If load word instruction, get memory data
	    if (opcode === 6'h23) begin
		//rf_addr_w = stored_rt;
		C[9]=1'b1; C[11]=1'b1;
		//rf_data_w = MEM_DATA; // R[rt] = memory data
		C[12]=1'b1; C[13]=1'b0; C[14]=1'b1;
	        //$write("R[%3h] set to %5h\n", rf_addr_w, MEM_DATA);
	    end
	    // If lui instruction, extend imm
	    else if (opcode === 6'h0f) begin
	        //rf_addr_w = rf_addr_r2;
		//rf_addr_w = stored_rt;
		C[9]=1'b1; C[11]=1'b1;
		C[13]=1'b1; C[14]=1'b1;
	    end
	    // If beq instruction, update PC if zero flag is on
	    else if (opcode === 6'h04) begin
		// If zero flag is on, R[rs] == R[rt]
		if (ZERO) begin
		    //PC_REG = PC_REG + stored_signextimm;
		    C[2]=1'b1; C[3]=1'b1;
		end
	    end
	    // If bne instruction (opp of beq)
	    else if (opcode === 6'h05) begin
		// If zero flag is on, R[rs] == R[rt]
		if (~ZERO) begin
		    C[2]=1'b1; C[3]=1'b1;
		end
	    end
	    else begin
		//rf_addr_w = stored_rt;
		C[9]=1'b1; C[11]=1'b1;
	        //rf_data_w = ALU_RESULT; // R[rt] = result from ALU
		C[12]=1'b0; C[13]=1'b0; C[14]=1'b1;
	    end
        end

	// J-Type
	// Jump instruction
	else if (opcode === 6'h02) begin
	    //PC_REG = stored_jump_addr;
	    C[3]=1'b0;
	end

	// Jal instruction
	else if (opcode === 6'h03) begin
	    // Write to R[31]
	    C[7]=1'b0; C[8]=1'b1; 
	    //rf_addr_w = 31;
	    C[10]=1'b1; C[11]=1'b0;
	    //rf_data_w = PC_REG;
	    C[14]=1'b0;
	    //PC_REG = stored_jump_addr;
	    C[3]=1'b0;
	end 
	// Pop instruction
	if (opcode === 6'h1c) begin
	    C[7]=1'b0; C[8]=1'b1;  
	    //rf_addr_w = 0;
	    C[10]=1'b0; C[11]=1'b0;
	    //rf_data_w = MEM_DATA;
	    C[12]=1'b1; C[13]=1'b0; C[14]=1'b1;
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