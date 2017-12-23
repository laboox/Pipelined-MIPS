module MEM_stage
		#(parameter WIDTH=16, parameter DATA_WIDTH=16, parameter MID_WIDTH=1)
		(clk, reset, instrIn, instrOut, midSignalIn, midSignalOut, addr, writeData, readData, writeEn);
	
	parameter MEM_WIDTH = 8;

	input clk, reset;
	input [WIDTH-1:0] instrIn;
	output reg[WIDTH-1:0] instrOut;
	
	input [DATA_WIDTH-1:0] addr;
	reg [DATA_WIDTH-1:0] addrReg;
	output [DATA_WIDTH-1:0] readData;
	input [DATA_WIDTH-1:0] writeData;
	input writeEn;
	reg [DATA_WIDTH-1:0] writeDataReg;
	reg writeEnReg;
	
	always @(posedge clk) begin
		writeDataReg <= writeData;
	end
	
	input [MID_WIDTH-1:0] midSignalIn;
	output reg [MID_WIDTH-1:0] midSignalOut;
	
	always @(posedge clk) begin
		if(reset)
			writeEnReg <= 1'b0;
		else
			writeEnReg <= writeEn;
	end
	
	
	always @(posedge clk) begin
		if(reset)
			midSignalOut <= {MID_WIDTH{1'b0}};
		else
			midSignalOut <= midSignalIn;
	end
	
	always@(posedge clk) begin
		addrReg <= addr;
	end
	
	always@(posedge clk) begin
		if(reset)
			instrOut <= {WIDTH{1'b0}};
		else
			instrOut <= instrIn;
	end
	
	memory mem(.clk(clk), .reset(reset), .addr(addrReg[MEM_WIDTH-1:0]), .readData(readData), .writeData(writeDataReg), .writeEn(writeEnReg));

endmodule

