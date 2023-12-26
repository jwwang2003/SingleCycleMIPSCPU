module SignExtend (
    input wire [15:0] inst15_0,
    input wire SEXT, // Add an input to control sign extension or zero extension
    output reg [31:0] Extend32
);
	always @(inst15_0 or SEXT) begin
		if (SEXT) begin
			// Perform sign extension
			Extend32[31:16] <= {16{inst15_0[15]}}; // Replicate the sign bit across the upper 16 bits
			Extend32[15:0] <= inst15_0;
		end else begin
			// Perform zero extension
			Extend32[31:16] <= 16'h0000; // Fill the upper 16 bits with 0's
			Extend32[15:0] <= inst15_0;
		end
	end
endmodule

// Old
// module SignExtend (inst15_0, Extend32);
// 	// input is a 15-bit value
// 	// the effect of the output is that we extend the value to 32-bit
// 	input [15:0] inst15_0;
// 	output reg [31:0] Extend32;

// 	always @(inst15_0) begin
// 		Extend32[31:0] <= inst15_0[15:0];
// 	end
// endmodule