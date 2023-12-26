`timescale 1ns / 1ps

module PC_tb;

  // Inputs
  reg clock;
  reg reset;
  reg [31:0] PCin;

  // Outputs
  wire [31:0] PCout;

  // Instantiate the Unit Under Test (UUT)
  PC uut (
    .clock(clock), 
    .reset(reset), 
    .PCin(PCin), 
    .PCout(PCout)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #10 clock = ~clock; // Generate a clock with period 20ns
  end

  initial begin
    // Initialize Inputs
    reset = 1;
    PCin = 0;

    // Wait for global reset
    #100;
    
    // Release the reset and set initial PC value
    reset = 0;
    PCin = 32'h00000000; // Start from address 0
    #20;

    // Check PC incrementing
    PCin = PCout; // Should increment by 4 each cycle
    #20;
    PCin = PCout;
    #20;
    PCin = PCout;
    #20;

    // Test the reset functionality
    reset = 1; // Assert reset
    #20;
    reset = 0; // Deassert reset
    PCin = 32'h00000020; // Set a different start address
    #20;

    // Check if PC increments from the new value
    PCin = PCout;
    #20;
    PCin = PCout;
    #20;

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_PC/tb_pc.vcd");
    $dumpvars(0, PC_tb);
    $monitor("At time %t, Reset = %b, PCin = %h, PCout = %h",
              $time, reset, PCin, PCout);
  end

endmodule