module Mux2(Q2, Extended32, ALUImm, ALU_B);
  input [31:0] Q2;
  input [31:0] Extended32;
  input ALUImm;
  output reg [31:0] ALU_B;

  always @(Q2, Extended32, ALUImm) begin
    case (ALUImm)
      0 : ALU_B <= Q2;
      1 : ALU_B <= Extended32;
    endcase
  end

  // always @(ALUSrc, ReadData2, Extend32) begin
	// 	case (ALUSrc)
	// 		0: ALU_B <= ReadData2 ;
	// 		1: ALU_B <= Extend32;
	// 	endcase
	// end
endmodule