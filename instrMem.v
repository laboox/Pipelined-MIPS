module instrMem#(parameter MEM_WIDTH=8, parameter WIDTH=16)(addr, instr);
  input [MEM_WIDTH-1:0] addr;
  output reg[WIDTH-1:0] instr;
  
  reg [WIDTH-1:0] memory [2**MEM_WIDTH-1:0];
  
  initial $readmemb("instructions", memory);
    
  always@(*)
  begin
    instr = memory[addr];
  end
endmodule

