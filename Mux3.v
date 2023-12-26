module Mux3(Q1, SA, SHIFT, ALU_A);
  input [31:0] Q1;
  input [4:0] SA;
  input SHIFT;
  output reg [31:0] ALU_A;

  always @(Q1, SA, SHIFT) begin
    case (SHIFT)
      0 : ALU_A <= Q1;
      1 : ALU_A <= SA;
    endcase
  end

  // always @(ALUSrc, ReadData2, Extend32) begin
	// 	case (ALUSrc)
	// 		0: ALU_B <= ReadData2;
	// 		1: ALU_B <= Extend32;
	// 	endcase
	// end
endmodule