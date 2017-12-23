module forwarding#(parameter rfWidth= 3, parameter opForwardSelWidth=2)
	(en, op1, op2, rfWriteAddrEx, rfWriteAddrMem, rfWriteAddrWb,
	exWriteEn, memWriteEn, wbWriteEn, stall, selOp1, selOp2, isLoadInEx);

parameter IDSEL=2'd0;
parameter EXSEL=2'd1;
parameter MEMSEL=2'd2;
parameter WBSEL=2'd3;
	
input en;
input isLoadInEx;
input [rfWidth-1:0]op1,op2,rfWriteAddrEx,rfWriteAddrMem,rfWriteAddrWb;
input exWriteEn, memWriteEn, wbWriteEn;
output reg stall;
output reg[opForwardSelWidth-1:0] selOp1;
output reg[opForwardSelWidth-1:0] selOp2;

always @(*) begin
	stall = 1'b0;
	if(isLoadInEx && (((op1==rfWriteAddrEx && exWriteEn) && op1!=3'b0) ||  ((op2==rfWriteAddrEx && exWriteEn) && op2!=3'b0)) )
		stall = 1'b1;
end

always @(*) begin
	selOp1 = IDSEL;
	if(en && op1!=3'b0) begin
		if(op1==rfWriteAddrEx && exWriteEn)
			selOp1 = EXSEL;
		else if(op1==rfWriteAddrMem && memWriteEn)
			selOp1 = MEMSEL;
		else if(op1== rfWriteAddrWb && wbWriteEn)
			selOp1 = WBSEL;
	end
end

always @(*) begin
	selOp2 = IDSEL;
	if(en && op2!=3'b0) begin
		if(op2==rfWriteAddrEx && exWriteEn)
			selOp2 = EXSEL;
		else if(op2==rfWriteAddrMem && memWriteEn)
			selOp2 = MEMSEL;
		else if(op2== rfWriteAddrWb && wbWriteEn)
			selOp2 = WBSEL;
	end
end

endmodule
