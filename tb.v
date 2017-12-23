
module tb;
reg clk, rst;
integer clkNum=0, stallNum=0;
mips_top uut(clk, rst);

initial begin
	clk=1'b0;
	repeat(2000) begin 
		#5 clk = !clk;
		if(clk) begin
			clkNum=clkNum+1;
			if(uut.stall)
				stallNum = stallNum+1;
		end
	end
end

initial begin
	rst=1'b1;
	# 10 rst =1'b0;
end

endmodule
