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
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`ADDRESS_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

// reg for output ports
reg [`DATA_INDEX_LIMIT:0] data1_ret; // return data register 1
reg [`DATA_INDEX_LIMIT:0] data2_ret; // return data register 2

assign DATA_R1 = ((READ===1'b1)&&(WRITE===1'b0))?data1_ret:{`DATA_WIDTH{1'bz} };
assign DATA_R2 = ((READ===1'b1)&&(WRITE===1'b0))?data2_ret:{`DATA_WIDTH{1'bz} };

// memory bank
reg [`DATA_INDEX_LIMIT:0] sram_32x32 [0:`REG_INDEX_LIMIT]; // 32x32 memory storage
integer i; // index for reset operation

// initial block for initializing content of all 32 registers
initial
begin
  for(i=0;i<=`REG_INDEX_LIMIT; i = i +1)
    sram_32x32[i] = { `DATA_WIDTH{1'b0} };
end

// register block is reset on neg edge of RST signal
always @ (negedge RST or posedge CLK) begin
if (RST === 1'b0)
begin
for(i=0;i<=`REG_INDEX_LIMIT; i = i +1)
    sram_32x32[i] = { `DATA_WIDTH{1'b0} };
end
else begin
 if ((READ===1'b1)&&(WRITE===1'b0)) begin // read operation
	//$write("reading\n");
	data1_ret = sram_32x32[ADDR_R1];
	data2_ret = sram_32x32[ADDR_R2];
 end
 else if ((READ===1'b0)&&(WRITE===1'b1)) begin // write operation
	//$write("writing\n");
	sram_32x32[ADDR_W] = DATA_W;
 end
end
end
endmodule
