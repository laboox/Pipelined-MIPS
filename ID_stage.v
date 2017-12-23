module ID_stage
	#(parameter ALU_CON_WIDTH=3, parameter WIDTH, parameter DATA_WIDTH=16, parameter OFF_WIDTH=6, parameter RF_WIDTH=3)
	(clk, reset, stall, instrIn, instrReg, aluCon, RFWriteEn, MEMWriteEn, operandSel, offset, jump, operandA, LDSel, op1, op2, RFWriteAddr);

	input clk, reset;
	input stall;
	input [WIDTH-1:0] instrIn;
	output reg[WIDTH-1:0] instrReg;
	output reg[ALU_CON_WIDTH-1:0] aluCon;
	output reg RFWriteEn;
	output reg MEMWriteEn;
	output [RF_WIDTH-1:0] RFWriteAddr;
	
	output reg jump;
	reg jumpPrev;
	output [OFF_WIDTH-1:0] offset;
	input [DATA_WIDTH-1:0] operandA;
	
	wire [3:0] opcode;
	
	assign offset = instrReg[5:0];
	assign RFWriteAddr = instrReg[11:9];
	
	always @(*) begin
		jump = 1'b0;
		if(opcode==4'b1100 && operandA==16'b0 && !jumpPrev && !stall)
			jump = 1'b1;
	end
	
	always @(posedge clk) begin
		if(reset)
			jumpPrev <= 1'b0;
		else if(!stall)
			jumpPrev <= jump;
	end
	
	output LDSel;
	assign LDSel=(opcode=='d10);
	
	output operandSel;
	assign operandSel=(opcode=='d9 || opcode=='d10 || opcode=='d11);

	output [RF_WIDTH-1:0] op1, op2;
	assign op1 = instrReg[08:06];
	assign op2 = (opcode=='d11)?instrReg[11:09]:instrReg[05:03];
	
	assign opcode = instrReg[15:12];

	always@(posedge clk) begin
		if(reset)
			instrReg <= {WIDTH{1'b0}};
		else begin
			if(!stall)
				instrReg <= instrIn;		
		end
	end

	always@(*) begin
		case(opcode)
			'd0: aluCon='d0;
			'd1: aluCon='d0;
			'd2: aluCon='d1;
			'd3: aluCon='d2;
			'd4: aluCon='d3;
			'd5: aluCon='d4;
			'd6: aluCon='d5;
			'd7: aluCon='d6;
			'd8: aluCon='d7;
			'd9: aluCon='d0;
			'd10: aluCon='d0;
			'd11: aluCon='d0;
			default: aluCon='d0;
		endcase
	end

	always@(*) begin
		RFWriteEn = 1'b0;
		if(((4'd1<=opcode && opcode<=4'd9) || opcode==4'd6 || opcode=='d10) && !stall && !jumpPrev)
			RFWriteEn = 1'b1;
	end
	
	always @(*) begin
		MEMWriteEn = 1'b0;
		if(opcode=='d11 && !stall && !jumpPrev)
			MEMWriteEn=1'b1;
	end

endmodule
