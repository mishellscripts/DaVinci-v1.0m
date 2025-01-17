// Name: reg_32x32_tb.v
// Module: REG_32X32_TB
// 
//
// Monitors:  DATA : Data to be written at address ADDR
//            ADDR : Address of the memory location to be accessed
//            READ : Read signal
//            WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - Testbench for REGISTER_FILE_32x32 memory system
`include "prj_definition.v"
module REG_32X32_TB;
// Storage list
reg [`DATA_INDEX_LIMIT:0] DATA_W;
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
// reset
reg READ, WRITE, RST;
integer i; // index for memory operation
integer no_of_test, no_of_pass;

// wire lists
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1;
wire [`DATA_INDEX_LIMIT:0] DATA_R2;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// 64MB memory instance
REGISTER_FILE_32x32 reg_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1),
		     .ADDR_R2(ADDR_R2), .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), 
                     .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin
RST=1'b1;
READ=1'b0;
WRITE=1'b0;
DATA_W = {`DATA_WIDTH{1'b0} };
no_of_test = 0;
no_of_pass = 0;

// Start the operation
#10    RST=1'b0;
#10    RST=1'b1;
// Write cycle
for(i=1;i<10; i = i + 1)
begin
#10     DATA_W=i*2; READ=1'b0; WRITE=1'b1; ADDR_W = i;
end

// Read Cycle
for(i=1;i<10; i = i + 1)
begin
#10   READ=1'b1; WRITE=1'b0; ADDR_R1 = i;
#10    no_of_test = no_of_test + 1;
      if (DATA_R1 !== i*2) begin
        $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [FAILED]\n", 
		READ, WRITE, i*2, DATA_R1);
      end
      else begin
	$write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h [PASSED]\n", 
		READ, WRITE, i*2, DATA_R1);
	no_of_pass  = no_of_pass + 1;
      end
end

#10 $write("\n");
    $write("\tTotal number of tests %d\n", no_of_test);
    $write("\tTotal number of pass  %d\n", no_of_pass);
    $write("\n");
    $stop;

end
endmodule;
