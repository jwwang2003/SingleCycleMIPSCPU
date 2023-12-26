`timescale 1ns / 1ps

module testbench;
  reg clock, reset;

  initial begin
    $dumpfile("tb_mips_cpu.vcd");
    $dumpvars(0, testbench);
    #1000 $finish; // Comment out for a longer execution time
  end

  initial begin
    reset = 1; // Assert reset initially
    #40;
    reset = 0; // Deassert reset to start PC incrementing

    clock = 0;
    forever #10 clock = ~clock; // Generate a clock with period 20ns
  end
  
  MipsCPU mipsCPU(
    .clock(clock),
    .reset(reset)
  );
endmodule