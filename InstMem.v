// Instruction memory

module InstMem(clock, addr, inst);
  input clock;
  input [31:0] addr;

  output reg [31:0] inst;

  // Stores a 128 array of 32-bit instructions
  reg [31:0] Mem [0:127];

  integer i;

  initial begin
    for(i = 0; i < 127; i = i + 1) begin
      Mem[i] = 0;
    end

    $display("[DEBUG] Reading instructions from Instruction.txt");
    
    // Syntax for readmemh
    // $readmemh("hex_memory_file.mem", memory_array, [start_address], [end_address])
    $readmemh("Instruction.txt", Mem);
    
    // Debug
    for(i = 0; i < 127; i = i + 1)
      $display("[DEBUG] InstMem[%d] -> HEX:%h BINARY:%b, %b, %b, %b, %b, %b, %b", i, Mem[i], Mem[i], Mem[i][31:26], Mem[i][25:21], Mem[i][20:16], Mem[i][15:11], Mem[i][10:6], Mem[i][5:0]);
  end

  always @(posedge clock) begin
    inst <= Mem[addr[31:2]];
  end
endmodule
