module segDecoder(num, segs);
	input [3:0] num;
	output [7:0] segs;
	reg [7:0] decode;
	assign segs = ~decode;

	always @(*)
	begin
		case(num)
		'd0:
			decode = 'h3F;	
		'd1:
			decode = 'h06;
		'd2:
			decode = 'h5B;
		'd3:
			decode = 'h4F;
		'd4:
			decode = 'h66;
		'd5:
			decode = 'h6D;
		'd6:
			decode = 'h7D;
		'd7:
			decode = 'h07;
		'd8:
			decode = 'h7F;
		'd9:
			decode = 'h6F;
		'd10:
			decode = 'h77;
		'd11:
			decode = 'h7C;
		'd12:
			decode = 'h39;
		'd13:
			decode = 'h5E;
		'd14:
			decode = 'h79;
		'd15:
			decode = 'h71;
		
		default: 
			decode = 'hFF;
		endcase
	end
endmodule
