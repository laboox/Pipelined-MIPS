module IF_stage #(parameter MEM_WIDTH=8, parameter WIDTH, parameter OFF_WIDTH=6)(clk, reset, addr, instr, jump, stall, jumpOffset);
	input clk, reset, jump, stall;
	output [WIDTH-1:0] instr;
	wire [WIDTH-1:0] instrRead;
	output [MEM_WIDTH-1:0] addr;
	input [OFF_WIDTH-1:0] jumpOffset;
	wire [MEM_WIDTH-1:0] jumpAddress;
	
	signExtend SE(.offset(jumpOffset), .fixed(jumpAddress));
	PC pcIF(.clk(clk), .reset(reset), .PCOut(addr), .PCIn(jumpAddress), .load(jump), .en(~stall));
	instrMem memIF(.addr(addr), .instr(instrRead));
	
	/*instRom (
		address(addr),
		.clken(~stall),
		.clock(clk),
		.q(instr)); */
	
	assign instr = instrRead;

endmodule
