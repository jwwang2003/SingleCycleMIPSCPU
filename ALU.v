module ALU (
  // inputs
  A, B, ALUC,
  // outputs
  Zero, Result
);
  // 32-bit registers;
  input [31:0] A;
  input [31:0] B;

  input [3:0] ALUC;         // ALUC
  output reg[31:0] Result;  // ALU output
  output Zero;
  assign Zero = (Result == 0);
  
  always @(ALUC, A, B) begin
    case(ALUC)
      // Arithmetic operations
      // add 0010 (2)
      4'b0010: Result = A + B;
      // substract 0110 (6)
      4'b0110: Result = A - B;
      
      // Logical operations
      // and 0000 (0)
      4'b0000: Result = A & B;
      // or 0001 (1)
      4'b0001: Result = A | B;
      // nor 1100 (12)
      4'b1100: Result = ~(A | B);

      // Comparison operations
      // set on less than (stl, stli) 0111 (7)
      4'b0111: Result = A < B ? 1 : 0;

      default: Result = 0;
    endcase
  end
endmodule