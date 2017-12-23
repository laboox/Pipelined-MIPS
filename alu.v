module alu #(parameter DATA_WIDTH=16, parameter ALU_CON_WIDTH=3)(operandA, operandB, aluCon, result);
	input [DATA_WIDTH-1:0] operandA, operandB;
	input [ALU_CON_WIDTH-1:0] aluCon;
	output reg [DATA_WIDTH-1:0] result;
	
	always @(*) begin
		case(aluCon) 
			'd0: result = operandA + operandB;
			'd1: result = operandA - operandB;
			'd2: result = operandA & operandB;
			'd3: result = operandA | operandB;
			'd4: result = operandA ^ operandB;
			'd5: result = operandA << operandB;
			'd6: result = operandA >> operandB;
			'd7: result = operandA >>> operandB;
			default: result=operandA;
		endcase
	end
	
endmodule
