`timescale 1ns / 1ps

module SignExtend_tb;

  // Inputs
  reg [15:0] inst15_0;
  reg SEXT;

  // Outputs
  wire [31:0] Extend32;

  // Instantiate the Unit Under Test (UUT)
  SignExtend uut (
    .inst15_0(inst15_0), 
    .SEXT(SEXT), 
    .Extend32(Extend32)
  );

  initial begin
    // Initialize Inputs
    inst15_0 = 0;
    SEXT = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Test Case 1: Zero Extension with positive value
    SEXT = 0; // Zero extension
    inst15_0 = 16'h0001; // Smallest positive number
    #10;

    // Test Case 2: Zero Extension with highest positive value
    inst15_0 = 16'h7FFF; // Largest positive number for 16-bit halfword
    #10;

    // Test Case 3: Sign Extension with negative value
    SEXT = 1; // Sign extension
    inst15_0 = 16'h8000; // Smallest negative number (sign bit is one)
    #10;

    // Test Case 4: Sign Extension with -1
    inst15_0 = 16'hFFFF; // -1 in two's complement
    #10;

    // Test Case 5: Sign Extension with a mid-range negative number
    inst15_0 = 16'hF000; // Some negative number
    #10;

    // Test Case 6: Zero Extension with all bits set to 1
    SEXT = 0; // Zero extension
    inst15_0 = 16'hFFFF; // All bits set to 1
    #10;

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_SignExtend/tb_sign_extend.vcd");
    $dumpvars(0, SignExtend_tb);
    $monitor("At time %t, inst15_0 = %h (hex), SEXT = %b, Extend32 = %h (hex)",
              $time, inst15_0, SEXT, Extend32);
  end

endmodule