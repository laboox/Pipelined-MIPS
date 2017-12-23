module registerFile #(parameter RF_WIDTH=3, parameter DATA_WIDTH=16)
	(clk,
	reset, 
	readAddr1,
	readAddr2,
	readAddr3,
	readData1,
	readData2,
	readData3,
	writeEn,
	writeAddr,
	writeData);
	
	input clk, reset, writeEn;
	input [RF_WIDTH-1:0] readAddr1, readAddr2, readAddr3, writeAddr;
	input [DATA_WIDTH-1:0] writeData;
	output [DATA_WIDTH-1:0] readData1, readData2, readData3;
	
	reg [DATA_WIDTH-1:0] mem [2**RF_WIDTH-1:0];
	
	//assign readData1 = (readAddr1=='d0)?'b0:mem[readAddr1];
	//assign readData2 = (readAddr2=='d0)?'b0:mem[readAddr2];
	assign readData1 = mem[readAddr1];
	assign readData2 = mem[readAddr2];
	assign readData3 = mem[readAddr3];
	
	integer i;
	
	always @(posedge clk) begin
		if(reset) begin
			for (i=0; i<2**RF_WIDTH; i=i+1) 
				mem[i] <= {DATA_WIDTH{1'b0}};
		end
		else if(writeEn && writeAddr!='d0) begin
			mem[writeAddr]<=writeData;

		end
	end

endmodule
