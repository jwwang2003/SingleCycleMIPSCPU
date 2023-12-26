module Mux5 (
	Shifted_Addr, Mux4_Out,
	Branch, Mux5_Out
);

	input [31:0] Shifted_Addr, Mux4_Out;
	input Branch;	
	
	output reg [31:0] Mux5_Out;
	
	initial begin
		Mux5_Out = 0;
	end
	
	always @(*) begin
		case (Branch)
			0: Mux5_Out = Mux4_Out;
			1: Mux5_Out = Shifted_Addr;
		endcase
	end
endmodule