`timescale 1ns / 1ps

module ALU_tb;

  // Inputs
  reg [31:0] A;
  reg [31:0] B;
  reg [3:0] ALUC;

  // Outputs
  wire [31:0] Result;
  wire Zero;

  // Instantiate the Unit Under Test (UUT)
  ALU uut (
    .A(A), 
    .B(B), 
    .ALUC(ALUC), 
    .Result(Result), 
    .Zero(Zero)
  );

  initial begin
    // Initialize Inputs
    A = 0;
    B = 0;
    ALUC = 0;

    // Wait for global reset
    #100;
    
    // Add operation
    A = 32'd15; B = 32'd10; ALUC = 4'b0010; // A + B
    #10;
    $display("Add : A=%d, B=%d, Result=%d, Zero=%b", A, B, Result, Zero);

    // Subtract operation
    A = 32'd10; B = 32'd15; ALUC = 4'b0110; // A - B
    #10;
    $display("Sub : A=%d, B=%d, Result=%b, Zero=%b", A, B, Result, Zero);
    
    // AND operation
    A = 32'd12; B = 32'd5; ALUC = 4'b0000; // A & B
    #10;
    $display("AND : A=%d, B=%d, Result=%b, Zero=%b", A, B, Result, Zero);
    
    // OR operation
    A = 32'd12; B = 32'd5; ALUC = 4'b0001; // A | B
    #10;
    $display("OR  : A=%d, B=%d, Result=%b, Zero=%b", A, B, Result, Zero);

    // NOR operation
    A = 32'd12; B = 32'd5; ALUC = 4'b1100; // ~(A | B)
    #10;
    $display("NOR : A=%d, B=%d, Result=%b, Zero=%b", A, B, Result, Zero);

    // SLT operation (Set on Less Than)
    A = 32'd5; B = 32'd12; ALUC = 4'b0111; // A < B
    #10;
    $display("SLT : A=%d, B=%d, Result=%d, Zero=%b", A, B, Result, Zero);

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_ALU/tb_alu.vcd");
    $dumpvars(0, ALU_tb);
    $monitor("At time %t, A=%d, B=%d, ALUC=%b, Result=%d, Zero=%b",
              $time, A, B, ALUC, Result, Zero);
  end

endmodule