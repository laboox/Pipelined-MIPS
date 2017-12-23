module memory#(parameter MEM_WIDTH=8, parameter DATA_WIDTH=16)(clk, reset, addr, readData, writeData, writeEn);
	
	input clk, reset;
	input writeEn;
	input [MEM_WIDTH-1:0] addr;
	output [DATA_WIDTH-1:0] readData;
	input [DATA_WIDTH-1:0] writeData;
	
	reg [DATA_WIDTH-1:0] mem [0:2**MEM_WIDTH-1];
	
	assign readData = mem[addr];
	
	integer i;
	
	always @(posedge clk) begin
		if(reset) begin
			for (i=0; i<2**MEM_WIDTH; i=i+1) 
				mem[i] <= {DATA_WIDTH{1'b0}};
		end
		else if(writeEn==1) begin
			mem[addr] <= writeData;
		end
	end
	
	
	
endmodule
