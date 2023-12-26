module Mux4 (
	PC, ADD_0,
	Jump, Mux4_Out
);
	input [31:0] PC;
	input [31:0] ADD_0;
	input wire Jump;

	output reg [31:0] Mux4_Out;
	
	always @(PC, ADD_0, Jump) begin
		case (Jump)
			0 : Mux4_Out <= PC;
			1 : Mux4_Out <= ADD_0;
		endcase
	end
endmodule