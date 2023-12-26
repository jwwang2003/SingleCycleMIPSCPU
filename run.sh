#!/bin/sh
iverilog -o cpu testbench.v Mux1.v Mux2.v Mux3.v Mux4.v Mux5.v Mux6.v MipsCPU.v PC.v InstMem.v RegFile.v DataMemory.v ControlUnit.v ALU.v ShiftLeft2.v SignExtend.v && vvp cpu
gtkwave tb_mips_cpu.vcd &