module opMux
	#(parameter rfWidth= 3, parameter opForwardSelWidth=2, parameter DATA_WIDTH=16)
	(selOp, dataID, dataEX, dataMEM, dataWB, dataOUT);

parameter IDSEL=2'd0;
parameter EXSEL=2'd1;
parameter MEMSEL=2'd2;
parameter WBSEL=2'd3;

input [DATA_WIDTH-1:0] dataID, dataEX, dataMEM, dataWB;
input [opForwardSelWidth-1:0] selOp;
output reg[DATA_WIDTH-1:0] dataOUT;

always @(*) begin
	case(selOp)
		IDSEL: dataOUT=dataID;
		EXSEL: dataOUT=dataEX;
		MEMSEL: dataOUT=dataMEM;
		WBSEL: dataOUT=dataWB;
		default: dataOUT=dataID;
	endcase
end

endmodule
