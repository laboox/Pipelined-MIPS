module hazard#(parameter rfWidth= 3)(op1,op2,rfWriteAddrEx,rfWriteAddrMem,rfWriteAddrWb,exWriteEn,memWriteEn,wbWriteEn,stall);
input [rfWidth-1:0]op1,op2,rfWriteAddrEx,rfWriteAddrMem,rfWriteAddrWb;
input exWriteEn, memWriteEn, wbWriteEn;
output reg stall;
always @(*)
begin
stall=0;
if((((op1==rfWriteAddrEx && exWriteEn) || (op1==rfWriteAddrMem && memWriteEn) || (op1== rfWriteAddrWb && wbWriteEn)) && op1!=3'b0) ||
 (((op2==rfWriteAddrEx && exWriteEn) || (op2==rfWriteAddrMem && memWriteEn) || (op2== rfWriteAddrWb && wbWriteEn)) && op2!=3'b0))
	stall=1;

end
endmodule
