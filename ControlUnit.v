module ControlUnit (
  // inputs
  Zero, OP, Func,
  // outputs
  Jump, Branch,
  Mem2Reg, WriteMem, WriteReg,
  ALUC, Shift, ALUImm,
  REGRT, SEXT
);
  // SEXT   符号扩展 / 0扩展
  // REGRT  选择 rd / rt

  input Zero;
  input [5:0] OP;
  input [5:0] Func;

  output reg Jump, Branch;
  output reg Mem2Reg, WriteMem, WriteReg;
  output reg [3:0] ALUC;
  output reg Shift, ALUImm;

  output reg REGRT, SEXT;

  always @(*) begin
    case (OP)
      // R-type instruction (all have 0 for OP code)
      // Add, Sub, And, Or, Slt
      6'b000000: begin
        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 0;
        Shift     = 0;

        // Determined to be R-type instruction -> REGRT = 0
        REGRT = 0; // 0 means that result is written back to rd register
        SEXT  = 0;  // not used in R-type instructions but lets default it to 0 anyways
        case (Func)
          6'b000000: begin
            // NOP instruction
            // the whole command is filled with 0s (OP = 000000, Func = 000000)

            // 参考
            // if (/* condition that checks for NOP specifically */) begin
            //     // Ensure all control signals indicate no operation
            //     RegWrite = 0;
            //     MemWrite = 0;
            //     // ... set other control signals to NOP behavior ...
            // end else begin
            //     // It's a real 'sll' instruction, set control signals accordingly
            //     // ... 
            // end

            if(Zero == 1) begin
              // Ensure all control signals indicate no operation
              ALUC      = 0;

              REGRT     = 0;
              SEXT      = 0;

              Jump      = 0;
              Branch    = 0;
              Mem2Reg   = 0;
              WriteMem  = 0;
              WriteReg  = 0;
              ALUImm    = 0;
              Shift     = 0;
            end else begin
              // It's a real 'sll' instruction, set control signals accordingly
              // ... 
              // Implementation not required -> can implement later
            end
          end
          6'b100000: begin
            // add
            ALUC = 4'b0010;
          end
          6'b100010: begin
            // sub
            ALUC = 4'b0110;
          end
          6'b100100: begin
            // and
            ALUC = 4'b0000;
          end
          6'b100101: begin
            // or
            ALUC = 4'b0001;
          end
          6'b101010: begin
            // slt - set on less than
            ALUC = 4'b0111;
          end
          default: ALUC <= 15; //should not happen -> undefined or illegal operation
        endcase
      end
      // All non R-type instructions (I-type & J-type)
      // Addi
      6'b001000: begin
        ALUC      = 4'b0010;

        REGRT     = 1;   // I-type instruction
        SEXT      = 1;   // sign extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 1;
        Shift     = 0;
      end
      // Andi - And immediate
      6'b001100: begin
        ALUC      = 4'b0000;

        REGRT     = 1;   // I-type instruction
        SEXT      = 0;   // zero extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 1;
        Shift     = 0;
      end
      // Ori
      6'b001101: begin
        ALUC      = 4'b0001;

        REGRT     = 1; // I-type instruction
        SEXT      = 0;  // zero extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 1;
        Shift     = 0;
      end
      // slti - set on less than immediate
      6'b001010: begin
        // comparison (7)
        ALUC      = 4'b0111;

        REGRT     = 1;     // I-type instruction
        SEXT      = 1;     // sign extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 1;
        Shift     = 0;
      end
      // j - jump
      6'b000010: begin
        ALUC      = 0;   // the jump instruction does not use the ALU unit

        // Does not use REGRT or SEXT, but we can set them to
        // low for good practice maybe, instead of leaving them hanging around
        REGRT     = 0;
        SEXT      = 0;

        Jump      = 1;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 0;
        WriteReg  = 0;
        ALUImm    = 0;
        Shift     = 0;
      end
      // lw - load word
      6'b100011: begin
        ALUC      = 4'b0010;

        REGRT     = 1;   // I-type instruction
        SEXT      = 1;   // sign extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 1;
        WriteMem  = 0;
        WriteReg  = 1;
        ALUImm    = 1;
        Shift     = 0;
      end
      // sw - store word
      6'b101011: begin
        ALUC      = 4'b0010;

        REGRT     = 1;   // I-type instruction
        SEXT      = 1;   // sign extend

        Jump      = 0;
        Branch    = 0;
        Mem2Reg   = 0;
        WriteMem  = 1;
        WriteReg  = 0;
        ALUImm    = 1;
        Shift     = 0;
      end
    endcase
  end
endmodule