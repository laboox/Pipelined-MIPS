module PC#(parameter MEM_WIDTH=8)(clk, reset, PCOut, PCIn, load, en);
  input clk, reset, load, en;
  input [MEM_WIDTH-1:0] PCIn;
  output [MEM_WIDTH-1:0] PCOut;
  
  reg [MEM_WIDTH-1:0] count;
  
  assign PCOut = count;
  
  always@(posedge clk)
  begin  
   if(reset)
		count <= {MEM_WIDTH{1'b0}};
	else if(en) begin
		if(load)
			count <= count+PCIn;
		else
			count <= count + 1;
	end
  end
endmodule
