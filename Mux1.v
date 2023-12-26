module Mux1(regTar, regDest, REGRT, ND);
	// ND <==> WriteRegister;
	// regTar		=> [20...16]
	// regDest	=> [15...11]
	input [20:16] regTar;		// rt -> register target
	input [15:11] regDest;	// rd -> register destination
	input REGRT;						// REGRT = 0 (write to rd) for R-type instructions
													// REGRT = 1 (write to rt) for I-type instructions

	output reg [4:0] ND;

	always @(REGRT, regTar, regDest) begin
		case(REGRT) 
			0 : ND <= regDest;
			1 : ND <= regTar;
		endcase
	end
endmodule