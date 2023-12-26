module RegFile (
  clock, WriteEnable,   // CK, WE
  ReadReg1, ReadReg2,   // N1, N2
  WriteReg, WriteData,  // ND, DI
  ReadData1, ReadData2  // Q1, Q2
);

  input clock;
  input WriteEnable;

  input [4:0] ReadReg1, ReadReg2, WriteReg;
  input [31:0] WriteData;

  output [31:0] ReadData1, ReadData2;

  // An array of 32 32-bit registers
  reg [31:0] reg_mem [0:31]; 

  integer i;
  
  initial begin
    $display("[DEBUG] Initializing register file");
    for(i = 0; i < 31; i = i + 1)
      reg_mem[i] = 0;
    
    // some random initial values
    reg_mem[0] = 0;
    reg_mem[1] = 8;
    reg_mem[2] = 20;

    // Debug
    for(i = 0; i < 31; i = i + 1)
      $display("[DEBUG] RegMem[%d] -> HEX:%h BINARY:%b", 
      i, 
      reg_mem[i], 
      reg_mem[i]);
  end

  assign ReadData1 = reg_mem[ReadReg1];
  assign ReadData2 = reg_mem[ReadReg2];

  always @(posedge clock) begin
    // Similar to WE (write enable)
    if (WriteEnable == 1)
      // at addr WriteReg, write in WriteData into register memory
      reg_mem[WriteReg] <= WriteData;
  end
endmodule