module EX_stage
	#(parameter RF_WIDTH=3, parameter WIDTH=16, parameter ALU_CON_WIDTH=3, parameter DATA_WIDTH=16, parameter MID_WIDTH=1, parameter OFF_WIDTH=6)
	(clk, reset, instrIn, instrOut, aluCon, aluRes, midSignalIn, midSignalOut, operandA, operandB, operandBReg, operandSel, offset);
	
	input clk, reset;
	input [WIDTH-1:0] instrIn;
	input [ALU_CON_WIDTH-1:0] aluCon;
	input [OFF_WIDTH-1:0] offset;
	reg [OFF_WIDTH-1:0] offsetReg;
	
	input operandSel;
	reg operandSelReg;
	
	always @(posedge clk)
		operandSelReg <= operandSel;
	
	output reg[WIDTH-1:0] instrOut;
	output [DATA_WIDTH-1:0] aluRes;
	
	input [MID_WIDTH-1:0] midSignalIn;
	output reg [MID_WIDTH-1:0] midSignalOut;
	
	always @(posedge clk) begin
		if(reset)
			midSignalOut <= {MID_WIDTH{1'b0}};
		else
			midSignalOut <= midSignalIn;
	end
	
	reg [ALU_CON_WIDTH-1:0] aluConReg;
	
	input [DATA_WIDTH-1:0] operandA, operandB;
	reg [DATA_WIDTH-1:0] operandAReg; 
	output reg [DATA_WIDTH-1:0] operandBReg;
	
	always @(posedge clk) begin
		operandAReg <= operandA;
		operandBReg <= operandB;
	end
	
	
	always @(posedge clk)
		aluConReg<=aluCon;
	
	wire [DATA_WIDTH-1:0] operandBSelected;
	wire [DATA_WIDTH-1:0] offSS;
	
	signExtend SE(offsetReg, offSS);
	assign operandBSelected = operandSelReg?offSS:operandBReg;
	alu aluUnit(.operandA(operandAReg), .operandB(operandBSelected), .aluCon(aluConReg), .result(aluRes));
	
	always@(posedge clk) begin
		if(reset)
			instrOut <= {WIDTH{1'b0}};
		else
			instrOut <= instrIn;
	end
		
	always@(posedge clk)
		offsetReg <= offset;

endmodule

