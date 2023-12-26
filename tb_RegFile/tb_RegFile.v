`timescale 1ns / 1ps

module RegFile_tb;

    // Inputs
    reg clock;
    reg RegWrite;
    reg [4:0] ReadReg1, ReadReg2, WriteReg;
    reg [31:0] WriteData;

    // Outputs
    wire [31:0] ReadData1, ReadData2;

    // Instantiate the Unit Under Test (UUT)
    RegFile uut (
        .clock(clock), 
        .WriteEnable(RegWrite), 
        .ReadReg1(ReadReg1), 
        .ReadReg2(ReadReg2), 
        .WriteReg(WriteReg), 
        .WriteData(WriteData), 
        .ReadData1(ReadData1), 
        .ReadData2(ReadData2)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // Clock with a period of 20ns
    end

    initial begin
        // Initialize Inputs
        RegWrite = 0;
        ReadReg1 = 0;
        ReadReg2 = 0;
        WriteReg = 0;
        WriteData = 0;

        // Wait for global reset to finish
        #100;

        // Write data to register 1
        RegWrite = 1;
        WriteReg = 5'b00001; // Write to register 1
        WriteData = 32'hA5A5A5A5;
        #20; // Wait for one clock cycle

        // Write data to register 2
        WriteReg = 5'b00010; // Write to register 2
        WriteData = 32'h5A5A5A5A;
        #20; // Wait for one clock cycle

        // Read from registers 1 and 2
        RegWrite = 0; // Disable writing
        ReadReg1 = 5'b00001; // Read from register 1
        ReadReg2 = 5'b00010; // Read from register 2
        #20; // Wait for one clock cycle

        // Finish the simulation
        $finish;
    end

    // Monitor changes and display
    initial begin
        $dumpfile("tb_RegFile/tb_reg_file.vcd");
        $dumpvars(0, RegFile_tb);
        $monitor("At time %t, clock = %b, RegWrite = %b, ReadReg1 = %d, ReadReg2 = %d, WriteReg = %d, WriteData = %h, ReadData1 = %h, ReadData2 = %h", 
                 $time, clock, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);
    end

endmodule