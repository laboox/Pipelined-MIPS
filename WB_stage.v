module WB_stage
	#(parameter WIDTH=16, parameter DATA_WIDTH=16, parameter RF_WIDTH=3)
	(clk, reset, instrIn, instrOut, writeAddrIn, writeAddrOut, RFWriteEnIn, RFWriteEnOut, aluResIn, aluResOut, MEMReadData, LDSel);
	
	input clk, reset;
	input [WIDTH-1:0] instrIn;
	input [RF_WIDTH-1:0] writeAddrIn;
	output reg[WIDTH-1:0] instrOut;
	
	input LDSel;
	
	output [DATA_WIDTH-1:0] aluResOut;
	reg [DATA_WIDTH-1:0] aluResReg;
	assign aluResOut = aluResReg;
	
	output reg [RF_WIDTH-1:0] writeAddrOut;
		
	input [DATA_WIDTH-1:0] aluResIn;
	input [DATA_WIDTH-1:0] MEMReadData;

	
	input RFWriteEnIn;
	output reg RFWriteEnOut;
	
	always @(posedge clk) begin
		if(reset)
			RFWriteEnOut <= 1'b0;
		else
			RFWriteEnOut <= RFWriteEnIn;
	end
	
	
	always@(posedge clk) begin
		if(reset)
			instrOut <= {WIDTH{1'b0}};
		else
			instrOut <= instrIn;
	end
	
	always@(posedge clk)
		writeAddrOut <= writeAddrIn;
		
	always @(posedge clk) begin
		if(LDSel == 1)
			aluResReg <= MEMReadData;
		else
			aluResReg <= aluResIn;
	end

endmodule
