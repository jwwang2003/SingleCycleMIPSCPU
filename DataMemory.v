module DataMemory (
	clock, address,
	WriteEnable,
	WriteData, MemData
	);

	// WriteEnable decides whether WriteData is going to be written into data memory
	// WriteData contains the values from Q2 of the register file module
	// MemData is the ouptut of whatever that is read from the memory at said address
	input clock, WriteEnable;
	input [31:0] address;
	input [31:0] WriteData; 
	
	// Stores the data read from memory at address[6:2]
	// MemData is the ouptut
	output [31:0] MemData;

	// Memory register
	reg [31:0] Mem[0:10000]; //32 bits memory with 128 entries

	integer i;

	initial begin
		// Initialize memory banks with 0
		$display("[DEBUG] Initializing data memory");
		for(i = 0; i < 128; ++i)
			Mem[i] = 0;

		// initial values
		Mem[0] = 5;
		Mem[1] = 6;
		Mem[2] = 7;

		// Initialize memory banks with 0
		for(i = 0; i < 128; ++i)
			$display("[DEBUG] DataMem[%d] -> HEX:%h BINARY:%b", i, Mem[i], Mem[i]);
	end

	// why [6:2]?
	/*
		Address[6:2] is used instead of address[6:0] because of how memory is addressed in the system.

		Word-Aligned Access: As in the MIPS architecture, memory is often accessed in terms of words, not individual bytes. A word in many systems is 4 bytes (or 32 bits). To access a word-aligned address, you would only need the higher bits of the address, not the lower two bits, because the lower two bits would be 00 for any word-aligned address.

		Memory Indexing: The Mem array is declared with 128 entries, each 32 bits wide. The index to this array needs to reflect word addressing, not byte addressing. Given that each entry is 4 bytes wide, by taking address[6:2], you effectively divide the byte address by 4 (or shift right by 2), converting a byte address into a word address. This means you're indexing into the array in word increments, not byte increments.

		Address Range: The use of address[6:2] assumes that the addresses are supplied in byte-addressable format, which is typical for MIPS and many other architectures. If the memory has 128 entries of 32-bit words, then the total byte-addressable range is 128 * 4 bytes. However, since you're accessing it by words, you only need 128 different addresses, which is what address[6:2] gives you: a range of 0 to 127 in word-sized steps.
	*/
	
	always @(posedge clock) begin
		// Writing to memory
		if (WriteEnable == 1)
			Mem[address[6:2]] = WriteData;
	end

	assign MemData = Mem[address[6:2]];
	// always @(posedge clock) begin
	// 	MemData = Mem[address[6:2]];
	// end
	
	// always @(negedge clock) begin
	// 	// Reading from memory
	// 	if (MemRead == 1)
	// 		ReadData <= Mem[address[6:2]];
	// end	
endmodule