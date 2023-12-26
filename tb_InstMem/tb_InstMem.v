`timescale 1ns / 1ps

module InstMem_tb;

  // Inputs
  reg clock;
  reg [31:0] addr;

  // Outputs
  wire [31:0] inst;

  // Instantiate the Unit Under Test (UUT)
  InstMem uut (
    .clock(clock), 
    .addr(addr), 
    .inst(inst)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #10 clock = ~clock; // Toggle clock every 10 ns
  end

  initial begin
    // Initialize Inputs
    addr = 0;

    // Wait for global reset
    #100;
    
    // Test Case 1: Read instruction at address 0
    addr = 0; // Address 0 corresponds to Mem[0]
    #20; // Wait for two clock cycles

    // Test Case 2: Read instruction at address 4
    addr = 4; // Address 4 corresponds to Mem[1] due to word alignment (addr[31:2])
    #20;

    // Test Case 3: Read instruction at address 8
    addr = 8; // Address 8 corresponds to Mem[2]
    #20;

    // Test Case 4: Read instruction at address 12
    addr = 12; // Address 12 corresponds to Mem[3]
    #20;

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_InstMem/tb_inst_mem.vcd");
    $dumpvars(0, InstMem_tb);
    $monitor("At time %t, Address = %h, Instruction = %h",
              $time, addr, inst);
  end

endmodule