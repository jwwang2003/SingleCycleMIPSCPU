`timescale 1ns / 1ps

module ShiftLeft2_tb;
  // Inputs
  reg [31:0] ShiftIn;

  // Outputs
  wire [31:0] ShiftOut;

  // Instantiate the Unit Under Test (UUT)
  ShiftLeft2 uut (
    .ShiftIn(ShiftIn), 
    .ShiftOut(ShiftOut)
  );

  initial begin
    // Initialize Inputs
    ShiftIn = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    ShiftIn = 32'h00000001; // Test with the smallest non-zero value
    #10; // Wait for 10 ns

    ShiftIn = 32'h40000000; // Test with a value that, when shifted left by 2, should not overflow
    #10; // Wait for 10 ns

    ShiftIn = 32'hC0000000; // Test with a value that will cause the two most significant bits to overflow when shifted
    #10; // Wait for 10 ns

    ShiftIn = 32'hFFFFFFFF; // Test with all bits set to 1
    #10; // Wait for 10 ns

    ShiftIn = 32'h80000000; // Test with the most significant bit set to 1 (to see the effect on sign bit)
    #10; // Wait for 10 ns

    ShiftIn = 32'h7FFFFFFF; // Test with the largest positive 32-bit integer
    #10; // Wait for 10 ns

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_ShiftLeft2/tb_shift_left_2.vcd");
    $dumpvars(0, ShiftLeft2_tb);
    $monitor("At time %t, ShiftIn = %h (hex), ShiftOut = %h (hex)",
              $time, ShiftIn, ShiftOut);
  end

endmodule