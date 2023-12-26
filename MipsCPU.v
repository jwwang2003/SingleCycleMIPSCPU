module MipsCPU (
	clock, reset
);
	input clock, reset;

	wire [31:0] PCin;
	wire [31:0] PCout;

	// For simplicity, assume PCin is always PCout + 4 (sequential execution)
	assign PCin = Mux5_Out + 4;

	// Instantiate the Program Counter
	PC pc_0 (
			.clock(clock),
			.reset(reset),
			.PCin(PCin),
			.PCout(PCout)
	);

	wire [31:0] inst;
	InstMem instMem_0 (
		.clock(clock),
		.addr(PCout),
		.inst(inst)
	);

	wire Zero, Jump, Branch;
	wire Mem2Reg, WriteMem, WriteReg;
	wire [3:0] ALUC;
	wire Shift, ALUImm;
	wire REGRT, SEXT;

	ControlUnit controlUnit_0 (
		.Zero(Zero),
		.OP(inst[31:26]),
		.Func(inst[5:0]),
		.Jump(Jump),
		.Branch(Branch),
		.Mem2Reg(Mem2Reg),
		.WriteMem(WriteMem),
		.WriteReg(WriteReg),
		.ALUC(ALUC),
		.ALUImm(ALUImm),
		.Shift(Shift),
		.REGRT(REGRT),
		.SEXT(SEXT)
	);

	wire [4:0] ND; // WriteRegister equivalent
	Mux1 mux1_0 (
		.regTar(inst[20:16]),
		.regDest(inst[15:11]),
		.REGRT(REGRT),
		.ND(ND)
	);

	wire [31:0] Extended32;
	SignExtend sign_extend_0 (
		.inst15_0(inst[15:0]),
		.SEXT(SEXT),
		.Extend32(Extended32)
	);

	wire [4:0] N1, N2;
	assign N1 = inst[25:21];
	assign N2 = inst[20:16];
	wire [31:0] Q1, Q2;
	RegFile regfile_0 (
		.clock(clock),
		.WriteEnable(WriteReg),
		.ReadReg1(N1),		// N1
		.ReadReg2(N2),		// N2
		.WriteReg(ND),	// Write to register (ND or WriteReigster equiv.)
		.WriteData(Mux6_Out),
		.ReadData1(Q1),		// Q1
		.ReadData2(Q2)		// Q2
	);

	wire [31:0] ALU_B;	// temp storage for ALU_B value
	Mux2 mux2_0 (
		.Q2(Q2),
		.Extended32(Extended32),
		.ALUImm(ALUImm),
		.ALU_B(ALU_B)
	);

	wire [31:0] ALU_A;	// temp storage for ALU_B value
	Mux3 mux3_0 (
		.Q1(Q1),
		.SA(inst[10:6]),
		.SHIFT(Shift),
		.ALU_A(ALU_A)
	);

	wire [31:0] Result;
	ALU ALU_0 (
		.ALUC(ALUC),
		.A(ALU_A),
		.B(ALU_B),
		.Zero(Zero),
		.Result(Result)
	);

	wire [31:0] ShiftOut;
	ShiftLeft2 shift_left2_0 (
		.ShiftIn(Extended32),
		.ShiftOut(ShiftOut)
	);

	wire [31:0] ADD_0;
	assign ADD_0 = ShiftOut + PCout;

	wire [31:0] Mux4_Out;
	Mux4 mux4_0 (
		.PC(PCout),
		.ADD_0(ADD_0),
		.Jump(Jump),
		.Mux4_Out(Mux4_Out)
	);

	wire [31:0] Shifted_Addr;
	assign Shifted_Addr = inst[25:0] << 2;

	wire [31:0] Mux5_Out;
	Mux5 mux5_0 (
		.Shifted_Addr(Shifted_Addr),
		.Mux4_Out(Mux4_Out),
		.Branch(Branch),
		.Mux5_Out(Mux5_Out)
	);

	wire [31:0] MemData;
	DataMemory data_memory_0 (
		.clock(clock),
		.address(Result),
		.WriteEnable(WriteMem),
		.WriteData(Q2),
		.MemData(MemData)
	);

	wire [31:0] Mux6_Out;
	Mux6 mux6_0 (
		.Mem2Reg(Mem2Reg),
		.Result(Result),
		.MemData(MemData),
		.Output(Mux6_Out)
	);
endmodule