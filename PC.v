module PC (
  clock, reset,
  PCin, PCout
);
  // PC - program counter

  input wire clock, reset;
  input wire [31:0] PCin;

  output reg [31:0] PCout;

  // Initialize the PC to zero or a specific starting address
  initial PCout = 32'h00000000;

 always @(posedge clock or posedge reset) begin
    if (reset) begin
      // Reset PC to the starting address
      PCout <= 32'h00000000;
    end else begin
      // Update PC to PCin or increment by 4
      // This assumes that PCin is appropriately set by the controlling logic

      // #2; // delay 2 time units
      // PCout <= PCin + 4;
      PCout <= PCin;
    end
  end
      
  /*
  Why do we add 4?

  The program counter or PC register holds the address of the current instruction. MIPS instructions are each four bytes long, so the PC should be incremented by four to read the next instruction in sequence.

  4 bytes (1 byte = 8 bits) => 4 * 8 = 32 bits
  */
endmodule