module signExtend #(parameter DATA_WIDTH=16, parameter OFF_WIDTH=6)(offset, fixed);
input [OFF_WIDTH-1:0] offset;
output reg [DATA_WIDTH-1:0] fixed;

always @(*) begin
	fixed = {{(DATA_WIDTH-OFF_WIDTH){offset[OFF_WIDTH-1]}},offset[OFF_WIDTH-1:0]};
end

endmodule
