module mips_top(clk, reset);
input clk, reset;

//****************************************************************************************************
//****************************************************************************************************
//****************************************************************************************************
//************************************* PIPELINED MIPS PROCESSOR *************************************
//****************************************************************************************************
//****************************************************************************************************
//****************************************************************************************************

parameter INST_WIDTH=16;
parameter DATA_WIDTH=16;
parameter OFF_WIDTH=6;
parameter ADDR_WIDTH=8;
parameter ALU_CON_WIDTH=3;
parameter RF_WIDTH=3;
parameter opForwardSelWidth=2;

wire forSel;
wire [ADDR_WIDTH-1:0] addr;
wire [INST_WIDTH-1:0] IFout, IDout, EXout, MEMout, WBout;
wire [ALU_CON_WIDTH-1:0] aluCon;
wire [DATA_WIDTH-1:0] aluResEX, aluResMEM, aluResWB;
wire RFWriteEnID, RFWriteEnEX, RFWriteEnMEM, RFWriteEnWB;
wire [RF_WIDTH-1:0] op1ID, op2ID;

wire [opForwardSelWidth-1:0] opSel1, opSel2;
wire MEMWriteEnID, MEMWriteEnEX;
wire LDSelID, LDSelEX, LDSelMEM;
wire [RF_WIDTH-1:0] writeAddrID, writeAddrEX, writeAddrMEM, writeAddrWB;
wire [DATA_WIDTH-1:0] testRFData;
wire [OFF_WIDTH-1:0] offset;
wire [DATA_WIDTH-1:0] MEMReadData;
wire [DATA_WIDTH-1:0] dataMEM;

wire jump;

assign forSel=1'b0;

wire [DATA_WIDTH-1:0] operandA, operandB, operandBEX;
wire [DATA_WIDTH-1:0] operandAID, operandBID;
wire operandSel;
wire stallFor, stallHaz, stall;

//****************************************************************************************************
//****************************************************************************************************
//************************************* STALL AND FORWARD SIGNAL *************************************
//****************************************************************************************************
//****************************************************************************************************

assign stall = forSel?stallFor:stallHaz;

//****************************************************************************************************
//********************************************* IF STAGE *********************************************
//****************************************************************************************************
IF_stage #(.MEM_WIDTH(ADDR_WIDTH), .WIDTH(INST_WIDTH), .OFF_WIDTH(OFF_WIDTH))
			IF
			(.clk(clk), 
			 .stall(stall),
			 .reset(reset),
			 .addr(addr),
			 .instr(IFout),
			 .jump(jump),
			 .jumpOffset(offset));


//****************************************************************************************************
//********************************************* ID STAGE *********************************************
//****************************************************************************************************
ID_stage #(.ALU_CON_WIDTH(ALU_CON_WIDTH), .WIDTH(INST_WIDTH), .DATA_WIDTH(DATA_WIDTH),
           .OFF_WIDTH(OFF_WIDTH), .RF_WIDTH(RF_WIDTH))
			ID
			(.clk(clk),
			 .reset(reset),
			 .instrIn(IFout),
			 .instrReg(IDout),
			 .aluCon(aluCon), 
			 .RFWriteEn(RFWriteEnID),
			 .operandSel(operandSel),
			 .stall(stall),  
			 .offset(offset),
			 .jump(jump),
			 .operandA(operandAID), 
			 .MEMWriteEn(MEMWriteEnID),
			 .LDSel(LDSelID),
			 .op1(op1ID),
			 .op2(op2ID),
			 .RFWriteAddr(writeAddrID));

registerFile #(.RF_WIDTH(RF_WIDTH), .DATA_WIDTH(DATA_WIDTH))
		RF
		(.clk(clk),
		 .reset(reset), 
		 .readAddr1(op1ID),
		 .readAddr2(op2ID),
		 .readAddr3(op2ID),
		 .readData1(operandA),
	    .readData2(operandB),
		 .readData3(testRFData),
		 .writeEn(RFWriteEnWB),
		 .writeAddr(writeAddrWB),
		 .writeData(aluResWB));

assign dataMEM = LDSelMEM?MEMReadData:aluResMEM;

opMux opMux1
	(.selOp(opSel1),
    .dataID(operandA),
    .dataEX(aluResEX),
	 .dataMEM(dataMEM),
	 .dataWB(aluResWB),
	 .dataOUT(operandAID));
	 
opMux opMux2
	(.selOp(opSel2),
  	 .dataID(operandB),
	 .dataEX(aluResEX),
	 .dataMEM(dataMEM),
	 .dataWB(aluResWB),
	 .dataOUT(operandBID));

//****************************************************************************************************
//********************************************* EX STAGE *********************************************
//****************************************************************************************************
EX_stage #(.RF_WIDTH(RF_WIDTH), .ALU_CON_WIDTH(ALU_CON_WIDTH), .DATA_WIDTH(DATA_WIDTH),
           .MID_WIDTH(RF_WIDTH+3), .OFF_WIDTH(OFF_WIDTH))
			EX
			(.clk(clk),
			 .reset(reset),
			 .instrIn(IDout),
			 .instrOut(EXout),
			 .aluCon(aluCon),
			 .aluRes(aluResEX),
			 .midSignalIn({RFWriteEnID, MEMWriteEnID, LDSelID, writeAddrID}),
			 .midSignalOut({RFWriteEnEX, MEMWriteEnEX, LDSelEX, writeAddrEX}),
			 .operandA(operandAID),
			 .operandB(operandBID),
			 .operandBReg(operandBEX),
			 .operandSel(operandSel),
			 .offset(offset));




//****************************************************************************************************
//******************************************** MEM STAGE *********************************************
//****************************************************************************************************
MEM_stage #(.DATA_WIDTH(DATA_WIDTH), .MID_WIDTH(DATA_WIDTH+RF_WIDTH+2))
			MEM
			(.clk(clk),
			 .reset(reset),
			 .instrIn(EXout),
			 .instrOut(MEMout),
			 .midSignalIn({RFWriteEnEX, aluResEX[DATA_WIDTH-1:0], LDSelEX, writeAddrEX}), 
			 .midSignalOut({RFWriteEnMEM, aluResMEM[DATA_WIDTH-1:0], LDSelMEM, writeAddrMEM}),
			 .addr(aluResEX),
			 .readData(MEMReadData),
			 .writeData(operandBEX),
			 .writeEn(MEMWriteEnEX));



//****************************************************************************************************
//********************************************* WB STAGE *********************************************
//****************************************************************************************************
WB_stage #(.DATA_WIDTH(DATA_WIDTH), .RF_WIDTH(RF_WIDTH))
			WB
			(.clk(clk),
			 .reset(reset),
			 .instrIn(MEMout),
			 .instrOut(WBout),
			 .RFWriteEnIn(RFWriteEnMEM),
			 .RFWriteEnOut(RFWriteEnWB),
			 .aluResIn(aluResMEM),
			 .aluResOut(aluResWB),
			 .writeAddrIn(writeAddrMEM),
			 .writeAddrOut(writeAddrWB),
			 .LDSel(LDSelMEM),
			 .MEMReadData(MEMReadData));


//**************************************** HAZARD DETECTION UNIT *************************************
hazard hz (
	.op1(op1ID),
	.op2(op2ID),
	.rfWriteAddrMem(writeAddrMEM),
	.rfWriteAddrEx(writeAddrEX),
	.rfWriteAddrWb(writeAddrWB),
	.memWriteEn(RFWriteEnMEM),
	.exWriteEn(RFWriteEnEX),
	.wbWriteEn(RFWriteEnWB),
	.stall(stallHaz)
);

//******************************************* FORWARDING UNIT ****************************************
forwarding fw (
	.en(forSel),
	.op1(op1ID),
	.op2(op2ID),
	.rfWriteAddrMem(writeAddrMEM),
	.rfWriteAddrEx(writeAddrEX),
	.rfWriteAddrWb(writeAddrWB),
	.memWriteEn(RFWriteEnMEM),
	.exWriteEn(RFWriteEnEX),
	.wbWriteEn(RFWriteEnWB),
	.stall(stallFor),
	.selOp1(opSel1),
	.selOp2(opSel2),
	.isLoadInEx(LDSelEX)
);

endmodule
