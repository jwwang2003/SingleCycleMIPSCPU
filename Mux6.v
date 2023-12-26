module Mux6 (
  Mem2Reg,
  Result, MemData,
  Output
);
  input Mem2Reg;      
  input [31:0] Result;  // 0
  input [31:0] MemData; // 1
  
  output reg [31:0] Output;

  always @(*) begin
		case (Mem2Reg)
			0: Output <= Result;
			1: Output <= MemData;
		endcase
	end
endmodule