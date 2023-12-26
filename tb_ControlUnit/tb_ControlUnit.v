`timescale 1ns / 1ps

module ControlUnit_tb;

  // Inputs
  reg Zero;
  reg [5:0] OP;
  reg [5:0] Func;

  // Outputs
  wire Jump, Branch;
  wire Mem2Reg, WriteMem, WriteReg;
  wire [3:0] ALUC;
  wire ALUImm;
  wire REGRT, SEXT;

  // Instantiate the Unit Under Test (UUT)
  ControlUnit uut (
    .Zero(Zero), 
    .OP(OP), 
    .Func(Func), 
    .Jump(Jump), 
    .Branch(Branch), 
    .Mem2Reg(Mem2Reg), 
    .WriteMem(WriteMem), 
    .WriteReg(WriteReg), 
    .ALUC(ALUC), 
    .ALUImm(ALUImm),
    .REGRT(REGRT), 
    .SEXT(SEXT)
  );

  initial begin
    // Initialize Inputs
    Zero = 0;
    OP = 0;
    Func = 0;

    // Wait 100 ns for global reset to finish
    #100;
    
    // R-type instruction (add)
    OP = 6'b000000;
    Func = 6'b100000; // add function code
    #10;
    $display("R-type (add): Jump=%b, Branch=%b, WriteReg=%b, ALUC=%b", Jump, Branch, WriteReg, ALUC);

    // I-type instruction (addi)
    OP = 6'b001000; // addi opcode
    #10;
    $display("I-type (addi): Jump=%b, Branch=%b, WriteReg=%b, ALUC=%b, ALUImm=%b, SEXT=%b", Jump, Branch, WriteReg, ALUC, ALUImm, SEXT);

    // J-type instruction (j)
    OP = 6'b000010; // j opcode
    #10;
    $display("J-type (j): Jump=%b, Branch=%b, WriteReg=%b", Jump, Branch, WriteReg);

    // Branch instruction (beq)
    OP = 6'b000100; // beq opcode
    Zero = 1; // Assume condition is true
    #10;
    $display("Branch (beq): Jump=%b, Branch=%b, WriteReg=%b, Zero=%b", Jump, Branch, WriteReg, Zero);

    // Load instruction (lw)
    OP = 6'b100011; // lw opcode
    #10;
    $display("Load (lw): Jump=%b, Branch=%b, Mem2Reg=%b, WriteReg=%b", Jump, Branch, Mem2Reg, WriteReg);

    // Finish the simulation
    $finish;
  end
  
  // Monitor changes and display
  initial begin
    $dumpfile("tb_ControlUnit/tb_control_unit.vcd");
    $dumpvars(0, ControlUnit_tb);

    $monitor("At time %t, OP=%b, Func=%b, Jump=%b, Branch=%b, Mem2Reg=%b, WriteMem=%b, WriteReg=%b, ALUC=%b, ALUImm=%b, REGRT=%b, SEXT=%b",
              $time, OP, Func, Jump, Branch, Mem2Reg, WriteMem, WriteReg, ALUC, ALUImm, REGRT, SEXT);
  end

endmodule