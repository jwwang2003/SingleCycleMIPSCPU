`timescale 1ns / 1ps

module DataMemory_tb;
  // Inputs
  reg clock;
  reg WriteEnable;
  reg [6:0] address;
  reg [31:0] WriteData;

  // Outputs
  wire [31:0] MemData;

  // Instantiate the Unit Under Test (UUT)
  DataMemory uut (
    .clock(clock), 
    .address(address),
    .WriteEnable(WriteEnable),
    .WriteData(WriteData), 
    .MemData(MemData)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock; // Toggle every 5 ns
  end

  initial begin
    // Initialize Inputs
    WriteEnable = 0;
    address = 0;
    WriteData = 0;

    // Wait for global reset
    #100;

    // Test Case 1: Write data to address 0
    WriteEnable = 1; // Enable writing
    address = 7'h00; // Address 0
    WriteData = 32'hA5A5A5A5; // Some arbitrary data
    #10; // Wait for one clock cycle

    // Test Case 2: Read data from address 0
    WriteEnable = 0; // Disable writing to read
    #10; // Wait for one clock cycle

    // Test Case 3: Write data to another address
    WriteEnable = 1;
    address = 7'h20; // Address 32 (which corresponds to Mem[4] due to address[6:2])
    WriteData = 32'h12345678; // Some different arbitrary data
    #10;

    // Test Case 4: Read data from the new address
    WriteEnable = 0;
    #10;

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_DataMemory/tb_data_memory.vcd");
    $dumpvars(0, DataMemory_tb);
    $monitor("At time %t, Address = %h, WriteEnable = %b, WriteData = %h, MemData = %h",
              $time, address, WriteEnable, WriteData, MemData);
  end

endmodule