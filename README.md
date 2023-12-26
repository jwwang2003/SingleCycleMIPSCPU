# Single Cycle MIPS CPU in Verilog (单周期CPU电路设计)

Implementing a **single cycle MIPS CPU** in Verilog with simulation and proof of correctness by **Jimmy Wang**.

# 📖 Table of Contents

# Modules & Documentation Tracker

[单周期MIPS CPU设计清单](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/%E5%8D%95%E5%91%A8%E6%9C%9FMIPS%20CPU%E8%AE%BE%E8%AE%A1%E6%B8%85%E5%8D%95%20bb37efadfd674268b367e7b34ea6a9b9.csv)

# 1️⃣ Modules Wiring Diagram | 部件和线路

![Wiring diagram given by the teacher](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1549512x.png)

Wiring diagram given by the teacher

![参考, a reference diagram found when researching online](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled.png)

参考, a reference diagram found when researching online

<aside>
💡 Labelled module and wiring diagram

![On the basis of the wiring diagram given by the teacher, all the modules and filenames for each component that makes up the MIPS CPU is labeled on the diagram. The entire CPU is connected together in the file called `MipsCPU.v`.](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled_11.jpg)

On the basis of the wiring diagram given by the teacher, all the modules and filenames for each component that makes up the MIPS CPU is labeled on the diagram. The entire CPU is connected together in the file called `MipsCPU.v`.

</aside>

---

# 2️⃣ Instruction Format and Handling | 指令格式和处理

Assuming our single-cycle MIPS computer is **little endian**, lets analyze an example command for a MIPS processor

`00221820		add: R3, R1, R2`

(`00221820`)_16 = (000000 00001 00010 00011 00000 100000)_2

Orange → OP code

Green → RS = 1

Blue → RT = 2

Purple → RD = 3

Red → SA = 0

Black → Func code

![Untitled](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%201.png)

## Proposed MIPS指令 Format

| #Bits | [31……26] | [25……21] | [20……16] | [15……11] | [10……6] | [5……0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | sa | func |
| I-Type | op | rs | rt | immediate |  |  |
| J-Type | op | target |  |  |  |  |
- **op** (opcode): The operation code of the instruction.
- **rs** (register source): The register number of the source operand.
- **rd** (register destination): The destination register number.
- **rt** (register target): Acts as a source register or a destination register, determined by the specific instruction.
- **func** (function): An extended operation code.
- **sa** (shift amount): Used by shift instructions, it defines the number of shift bits.
- **immediate**: A 16-bit immediate number.
- **target**: Used by jump instructions to generate the target address for the jump.

The section below is information extracted from the MIPS指令手册 and online regarding the specifics of each instruction that was required to implemented in our MIPS CPU. Each instruction is broken down into its purpose, the effect it has on different parts of the processor, and how the instruction or command is structured and any special things to pay attention to.

## 1️⃣ **Table 3-1 CPU Arithmetic Instructions**

### To Implement

- [x]  add → Add Word
- [x]  addi → Add Immediate Word
- [x]  slt → Set on Less Than
- [x]  slti → Set on Less Than Immediate
- [x]  sub → Subtract Word

| Mnemonic | Instruction |
| --- | --- |
| ADD | Add Word |
| ADDI | Add Immediate Word |
| ADDIU | Add Immediate Unsigned Word |
| ADDU | Add Unsigned Word |
| CLO | Count Leading Ones in Word |
| CLZ | Count Leading Zeros in Word |
| DIV | Divide Word |
| DIVU | Divide Unsigned Word |
| MADD | Multiply and Add Word to Hi, Lo |
| MADDU | Multiply and Add Unsigned Word to Hi, Lo |
| MSUB | Multiply and Subtract Word to Hi, Lo |
| MSUBU | Multiply and Subtract Unsigned Word to Hi, Lo |
| MUL | Multiply Word to GPR |
| MULT | Multiply Word |
| MULTU | Multiply Unsigned Word |
| SEB | Sign-Extend Byte |
| SEH | Sign-Extend Halftword |
| SLT | Set on Less Than |
| SLTI | Set on Less Than Immediate |
| SLTIU | Set on Less Than Immediate Unsigned |
| SLTU | Set on Less Than Unsigned |
| SUB | Subtract Word |
| SUBU | Subtract Unsigned Word |

## 5️⃣ **Table 3-5 CPU Logical Instructions**

### To Implement

- [x]  and → And
- [x]  andi → And Immediate
- [x]  or → Or
- [x]  ori → Or Immediate

| Mnemonic | Instruction |
| --- | --- |
| AND | And |
| ANDI | And Immediate |
| LUI | Load Upper Immediate |
| NOR | Not Or |
| OR | Or |
| ORI | Or Immediate |
| XOR | Exclusive Or |
| XORI | Exclusive Or Immediate |

<aside>
💡 Page 26 (MIPS指令集）

</aside>

### And

`AND rf, rs, rt`

OP - **000000**, RS(5), RT(5), RD(5), 00000, FUNC - **100100** (AND)

- register type command
- bitwise logical AND
- R-type instruction → REGRT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![Untitled](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%202.png)

---

### And Immediate

`ANDI rt, rs, immediate`

OP - ************001100************, RS(5), RT(5), Immediate (16)

- immediate type command
- bitwise logical AND with a constant (immediate) contained within the command
- I-type instruction → REGRT = 1
- zero-extend ⇒ SEXT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| I-Type | op | rs | rt | immediate | immediate | immediate |

![Untitled](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%203.png)

---

### Or

`OR rd, rs, rt`

OP - ************000000************, RS(5), RT(5), RD(5), 00000, FUNC - **100101** (OR)

- register type command
- bitwise logical OR
- R-type instruction ⇒ REGRT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![WX20231220-182755@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1827552x.png)

---

### Or Immediate

`ORI rt, rs, immediate`

OP - ************001101************, RS(5), RT(5), Immediate (16)

- register type command
- bitwise logical OR
- I-type instruction ⇒ REGRT = 1
- zero-extend ⇒ SEXT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![WX20231220-182812@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1828122x.png)

## Arithmetic and Logical Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| add | 100000 | f $d, $s, $t | $d = $s + $t |
| addu | 100001 | f $d, $s, $t | $d = $s + $t |
| addi | 001000 | f $d, $s, i | $d = $s + SE(i) |
| addiu | 001001 | f $d, $s, i | $d = $s + SE(i) |
| and | 100100 | f $d, $s, $t | $d = $s & $t |
| andi | 001100 | f $d, $s, i | $t = $s & ZE(i) |
| div | 011010 | f $s, $t | lo = $s / $t; hi = $s % $t |
| divu | 011011 | f $s, $t | lo = $s / $t; hi = $s % $t |
| mult | 011000 | f $s, $t | hi:lo = $s * $t |
| multu | 011001 | f $s, $t | hi:lo = $s * $t |
| nor | 100111 | f $d, $s, $t | $d = ~($s | $t) |
| or | 100101 | f $d, $s, $t | $d = $s | $t |
| ori | 001101 | f $d, $s, i | $t = $s | ZE(i) |
| sll | 000000 | f $d, $t, a | $d = $t << a |
| sllv | 000100 | f $d, $t, $s | $d = $t << $s |
| sra | 000011 | f $d, $t, a | $d = $t >> a |
| srav | 000111 | f $d, $t, $s | $d = $t >> $s |
| srl | 000010 | f $d, $t, a | $d = $t >>> a |
| srlv | 000110 | f $d, $t, $s | $d = $t >>> $s |
| sub | 100010 | f $d, $s, $t | $d = $s - $t |
| subu | 100011 | f $d, $s, $t | $d = $s - $t |
| xor | 100110 | f $d, $s, $t | $d = $s ^ $t |
| xori | 001110 | f $d, $s, i | $d = $s ^ ZE(i) |

### Add Word

`ADD rd, rs, rt`

OP - **000000**, RS(5), RT(5), RD(5), 00000, FUNC - **100000** (ADD)

- Register type command
- R-type instruction ⇒ REGRT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![Untitled](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%204.png)

---

### Add Immediate Word

`ADDI rt, rs, immediate`

OP - **001000**, RS(5), RT(5), Immediate (16)

- The command contains a value, and we add it to the source register value and store it in the target register.
- Immediate type command
- I-type command → REGRT = 1
- Sign extend → SEXT = 1

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| I-Type | op | rs | rt | immediate | immediate | immediate |

![Untitled](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%205.png)

---

### Subtract Word

`SUB rd, rs, rt`

OP - **000000**, RS(5), RT(5), RD(5), 00000, FUNC - **100010** (SUB)

- register type command
- subtract 32-bit integers

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![WX20231220-182844@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1828442x.png)

---

## Constant-Manipulating Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| lhi | 011001 | o $t, immed32 | HH ($t) = i |
| llo | 011000 | o $t, immed32 | LH ($t) = i |

## Comparison Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| slt | 101010 | f $d, $s, $t | $d = ($s < $t) |
| sltu | 101001 | f $d, $s, $t | $d = ($s < $t) |
| slti | 001010 | f $d, $s, i | $t = ($s < SE(i)) |
| sltiu | 001001 | f $d, $s, i | $t = ($s < SE(i)) |

<aside>
💡 Page 24 (MIPS指令集）

</aside>

### Set on Less Than

`SLT rd, rs, rt`

OP - **000000**, RS(5), RT(5), RD(5), 00000, FUNC - **101010** (SLT)

- record the result of a less-than comparison
- register type command
- R-type instruction ⇒ REGRT = 0

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![WX20231220-190742@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1907422x.png)

---

### Set on Less Than Immediate

`SLTI rt, rs, immediate`

OP - 001010, RS(5), RT(5), immediate (16)

- immediate type command
- record the result of a less-than comparison with a constant
- I-type instruction ⇒ REGRT = 1
- sign-extend ⇒ SEXT = 1

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| R-Type | op | rs | rt | rd | 0 | func |

![WX20231220-190807@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1908072x.png)

## 2️⃣ **Table 3-2 CPU Branch and Jump Instructions**

### To Implement

- [x]  J → Jump

| Mnemonic | Instruction |
| --- | --- |
| B | Unconditional Branch |
| BAL | Branch and Link |
| BEQ | Branch on Equal |
| BGEZ | Branch on Greater Than or Equal to Zero |
| BGEZAL | Branch on Greater Than or Equal to Zero and Link |
| BGTZ | Branch on Greater Than Zero |
| BLEZ | Branch on Less Than or Equal to Zero |
| BLTZ | Branch on Less Than Zero |
| BLTZAL | Branch on Less Than Zero and Link |
| BNE | Branch on Not Equal |
| J | Jump |
| JAL | Jump and Link |
| JALR | Jump and Link Register |
| JALR.HB | Jump and Link Register with Hazard Barrier |
| JR | Jump Register |
| JR.HB | Jump Register with Hazard Barrier |

<aside>
💡 Page 25 (MIPS指令集）

</aside>

## Branch Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| beq | 000100 | o $s, $t, label | if ($s == $t) pc += i << 2 |
| bgtz | 000111 | o $s, label | if ($s > 0) pc += i << 2 |
| blez | 000110 | o $s, label | if ($s <= 0) pc += i << 2 |
| bne | 000101 | o $s, $t, label | if ($s != $t) pc += i << 2 |

## Jump Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| j | 000010 | o label | pc += i << 2 |
| jal | 000011 | o label | $31 = pc; pc += i << 2 |
| jalr | 001001 | o labelR | $31 = pc; pc = $s |
| jr | 001000 | o labelR | pc = $s |

### Jump

`J target`

OP - **000010**, instr_index (26)

- jump type command
- branch within the current 256 MB-aligned region

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| J-Type | op | instr_index | instr_index | instr_index | instr_index | instr_index |

![WX20231220-191011@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1910112x.png)

## 3️⃣ **Table 3-3 CPU Instruction Control Instructions**

### To Implement

- [x]  NOP → No operation

| Mnemonic | Instruction |
| --- | --- |
| EHB | Execution Hazard Barrier |
| NOP | No Operation |
| SSNOP | Superscalar No Operation |

## 4️⃣ **Table 3-4 CPU Load, Store, and Memory Control Instructions**

### To Implement

- [x]  sw → Store Word
- [x]  lw → Load Word

| Mnemonic | Instruction |
| --- | --- |
| LB | Load Byte |
| LBU | Load Byte Unsigned |
| LH | Load Halfword |
| LHU | Load Halfword Unsigned |
| LL | Load Linked Word |
| LW | Load Word |
| LWL | Load Word Left |
| LWR | Load Word Right |
| PREF | Prefetch |
| SB | Store Byte |
| SC | Store Conditional Word |
| SH | Store Halfword |
| SW | Store Word |
| SWL | Store Word Left |
| SWR | Store Word Right |
| SYNC | Synchronize Shared Memory |
| SYNCI | Synchronize Caches to Make Instruction Writes Effective |

---

## Data Movement Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| mfhi | 010000 | f $d | $d = hi |
| mflo | 010010 | f $d | $d = lo |
| mthi | 010001 | f $s | hi = $s |
| mtlo | 010011 | f $s | lo = $s |

## Exception and Interrupt Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| trap | 011010 | o i | Dependent on OS; different values for immed26 specify different operations. |

<aside>
💡 [http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html](http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html)

</aside>

### No Operation

`NOP`

![WX20231220-191104@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1911042x.png)

---

### Load Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| lb | 100000 | o $t, i ($s) | $t = SE (MEM [$s + i]:1) |
| lbu | 100100 | o $t, i ($s) | $t = ZE (MEM [$s + i]:1) |
| lh | 100001 | o $t, i ($s) | $t = SE (MEM [$s + i]:2) |
| lhu | 100101 | o $t, i ($s) | $t = ZE (MEM [$s + i]:2) |
| lw | 100011 | o $t, i ($s) | $t = MEM [$s + i]:4 |

![WX20231220-191230@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1912302x.png)

### Load Word

`LW rt, offset (base)`

OP - **100011**， base (5), RT (5), offset (16)

- immediate type command
- to load a word from memory as a signed value
- I-type instruction ⇒ REGRT = 1
- sign-extend ⇒ SEXT = 1

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| I-Type | op | base | rt | offset | offset | offset |

## Store Instructions

| Instruction | Opcode/Function | Syntax | Operation |
| --- | --- | --- | --- |
| sb | 101000 | o $t, i ($s) | MEM [$s + i]:1 = LB ($t) |
| sh | 101001 | o $t, i ($s) | MEM [$s + i]:2 = LH ($t) |
| sw | 101011 | o $t, i ($s) | MEM [$s + i]:4 = $t |

![WX20231220-191207@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231220-1912072x.png)

### Store Word

`SW rt, offset (base)`

OP - **101011**, base (5), RT(5), offset (16)

- immediate type command
- to store a word to memory
- I-type instruction ⇒ REGRT = 1
- sign-extend ⇒ SEXT = 1

| Bits | [31…26] | [25…21] | [20…16] | [15…11] | [10…6] | [5…0] |
| --- | --- | --- | --- | --- | --- | --- |
| I-Type | op | base | rt | offset | offset | offset |

## Handling R-type and I-type Instructions (and CPU Control, etc.)

When implementing a MIPS CPU in Verilog, distinguishing between R-type and I-type instructions is crucial because they have different formats and operational semantics. The best way to distinguish between them is by examining the opcode field, which is the most significant 6 bits of the instruction. Here's how you can do it:

### **Opcode Field:**

- **R-type Instructions**: These have an opcode of **`000000`** (0 in decimal). The function of the instruction is further determined by the 6-bit function field at the end of the instruction. R-type instructions are used for arithmetic and logical operations that involve registers, such as **`add`**, **`sub`**, **`and`**, **`or`**, etc.
- **I-type Instructions**: These have a non-zero opcode that specifies the operation. I-type instructions are used for immediate arithmetic, load and store operations, and branches. Examples include **`addi`**, **`lw`**, **`sw`**, **`beq`**, and **`bne`**.

### Example **Implementation in Verilog:**

You can implement a simple decoder in Verilog that checks the opcode to determine the instruction type. Here's a conceptual snippet:

```verilog
verilogCopy code
module InstructionDecoder(
    input [31:0] instruction,
    output reg isRType,
    output reg isIType
);
    always @(instruction) begin
        // Check the opcode field
        case (instruction[31:26]) // Opcode is the most significant 6 bits
            6'b000000: begin
                // Opcode 0 indicates an R-type instruction
                isRType = 1;
                isIType = 0;
            end
            default: begin
                // Non-zero opcodes indicate I-type instructions
                isRType = 0;
                isIType = 1;
            end
        endcase
    end
endmodule
```

### **Considerations:**

- **Extendability**: As you expand your MIPS implementation, you might introduce J-type (jump) instructions or other special types. Ensure your design can accommodate these by adding more outputs or logic to handle different opcodes.
- **Control Unit**: In a typical MIPS CPU, the control unit uses the opcode (and sometimes function code) to generate control signals that dictate the operation of other components like the ALU, multiplexers, and memory units. Your opcode decoding logic will play a crucial role in this control signal generation.
- **Function Field for R-type**: If you're decoding an R-type instruction, you'll often need to look at the function field to determine the exact operation (like add, subtract, etc.). Make sure your design accounts for this additional decoding step.

By carefully examining the opcode field and implementing a decoder that distinguishes between R-type and I-type instructions, you can effectively control the flow of operations in your MIPS CPU and ensure instructions are executed correctly. This approach provides a clear and efficient method for handling the diverse set of instructions MIPS supports.

A similar approach can be used of J-type instructions because Jump instructions have different OP codes that are different from the patterns of R-type and I-type instructions. In general, if its not R-type or I-type then check if its a jump, branch, or something else.

![Snipped taken from ControlUnit.v](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(9).png)

Snipped taken from ControlUnit.v

In our implementation of the control unit, we first check if OP is equal to zero because that would indicate it is a R-type command. If it is then we check the FUNC code and handle the operation respectively. If OP is not zero then its either a I-type of J-type instruction. Since they all have a unique OP code, we can handle each of them using `case` and that concludes this portion of handling R-type, I-Type, and J-Type instructions in our control unit module.

---

# 3️⃣ Implementation | 实现思路

## Muxes

- mux1
    - handles the signal **********REGRT********** from the Control Unit
    - decides whether **RT** or **RC** is used for the write register
    - Note: ********SEXT******** connects to the **SignExtention** module, this signal indicates whether to do ****************************sign extension**************************** or ************************0 extension************************
- mux2
    - handles signal from ************ALUIMM************, which stands for ALU immediate
    - if the current command is a I-type (immediate type), then we fetch the immediate value from the **instruction memory (Inst. mem)** instead of from the register file
- mux3
    - handles signal from ************SHIFT************ which is required by shift instructions
        - it defines the number of shift bits
    - responsible for making bit shifts
- mux4
    - handles signal from ******BRANCH******
    - responsible for **branching**
- mux5
    - handles signal from ********JUMP********
    - mux4 and mux5 works in tandem to implement the jump function
- mux6
    - handles signal from ************M2REG************
    - controls whether the data from the current selected **memory address** is written from the to the **register**

## Why is the `clock` only connected to `PC` and `Register`

In a MIPS CPU, the clock is a critical signal that synchronizes operations across the entire processor. However, it might seem like the clock is only connected to the registers and Program Counter (PC) because these components are the primary elements that need to operate in sync with the clock edges. Here's a more detailed breakdown of why this is:

### Program Counter (PC):

- **Synchronization**: The PC is updated every clock cycle to point to the next instruction. To ensure this happens in a controlled and synchronized manner, the PC is typically updated on the rising edge of the clock.
- **Stability**: The clock ensures that the PC only updates at specific, predictable times, preventing instability or race conditions.

### Registers:

- **Data Integrity**: Registers store the current state (data) of the CPU. To maintain data integrity, it's crucial that updates to registers occur synchronously. This means writing new data to a register or reading the current state only happens at specific times dictated by the clock.
- **Synchronization**: Many operations in the CPU depend on the data from these registers. Having them update in sync with the clock ensures that all parts of the CPU are working with the most current and correct data.

### Other Components:

While it might seem like only the PC and registers are connected to the clock, virtually all sequential elements in the CPU are clocked. This includes:

- **Memory Units**: While the actual memory array might not have a clock input, the control signals that dictate memory read and write operations are generated based on the clock. This ensures that memory operations are synchronized with the rest of the CPU.
- **ALU**: While the ALU itself might perform operations combinatorially, the results are often captured into registers or used to update the PC, both of which are clocked.
- **Control Unit**: The control unit generates signals based on the current instruction. These signals are often synchronized with the clock to ensure they change only at specific, predictable times.

### Why It Might Seem Otherwise:

- **Combinatorial Logic**: Many parts of a CPU (like the ALU or certain parts of the control logic) are combinational logic. They perform operations based on their current inputs, without an explicit clock. However, the results of these operations usually go into clocked elements (like registers or the PC).
- **Simplicity in Diagrams**: In many diagrams or simplified models of a CPU, the clock might only be shown connected to the registers and PC for clarity, even though, in reality, it affects the entire operation of the processor.

In a MIPS CPU, the clock is fundamentally important for synchronizing the entire operation of the processor. While it might be most visibly connected to the registers and PC, its influence extends throughout the CPU. Every operation occurs in sync with the clock cycles, ensuring orderly and predictable execution of instructions. The clock is the heartbeat of the CPU, and all sequential operations are tied to its rhythm.

## SEXT & REGRT

In the MIPS CPU architecture, the `SEXT` (Sign-Extend/Zero-Extend) and `REGRT` signals are part of the control logic that determines how instructions are executed, particularly in how operands are prepared and how the destination register is chosen. Here's how each one functions:

### 1. SEXT (Sign-Extend/Zero-Extend):

- **Purpose**: The `SEXT` signal is used to determine how immediate values (constants specified within instructions) are treated when they are used in 32-bit operations. MIPS instructions often operate on 32-bit data, but immediate values in instructions might not be 32 bits long.
- **Function with MIPS Instructions**:
    - **Sign-Extend**: This is typically used with arithmetic operations and load/store instructions involving immediate values. For instance, if you have a 16-bit immediate in an `addi` instruction, it needs to be extended to 32 bits to correctly perform arithmetic in the ALU. Sign-extension ensures that if the immediate is intended as a negative value (signified by the most significant bit being 1), the extended 32-bit representation maintains the same numerical value.
    - **Zero-Extend**: Used with instructions where the immediate is unsigned or where only bitwise operations are performed. For example, logical instructions like `andi` or `ori` might use zero-extension to avoid changing the logical interpretation of the bit pattern.
- **Function with the ALU**: The `SEXT` signal influences the data fed into the ALU. It doesn't directly control the ALU's operations but affects the operand the ALU receives. The correct extension of immediate values is crucial for the ALU to produce accurate results.
- **0 for Zero-Extend**: Assigning a value of 0 to the **`SEXT`** signal is often used to represent zero extension. In this mode, the shorter immediate value is extended to the required width by padding it with zeros. This is typically used for unsigned values or when the numerical value should not be affected by sign extension (like with logical operations).
- **1 for Sign-Extend**: Assigning a value of 1 to the **`SEXT`** signal is commonly used to represent sign extension. In this mode, the shorter immediate value is extended to the required width by replicating its most significant bit (the sign bit) in all the new bits. This is typically used for signed values where maintaining the sign (positive or negative) in the extended value is crucial.

### 2. REGRT (Select rd/rt):

- **Purpose**: The `REGRT` signal is used to determine the destination register for the result of an instruction. In MIPS, different instructions use different fields in the instruction format to specify the destination register.
- **Function with MIPS Instructions**:
    - **R-type Instructions**: These instructions specify their destination register in the `rd` field. The `REGRT` signal is typically **deasserted (0)** for these instructions, indicating that the `rd` field should be used.
    - **I-type Instructions**: Many immediate or branch instructions specify their destination register in the `rt` field. For these instructions, the `REGRT` signal is typically **asserted (1)**, indicating that the `rt` field should be used as the destination.
- **Function with the ALU and Register File**: While the `REGRT` signal doesn't directly affect the ALU's operations, it's crucial for ensuring that the result of the ALU's operation is stored in the correct register. The signal is used by the register file, not the ALU, to route the output back to the correct register.

### Summary:

- `SEXT` affects how immediate values are treated before they reach the ALU, ensuring they are correctly interpreted as either signed or unsigned 32-bit numbers.
- `REGRT` determines the target register for the result of an operation, which is critical for ensuring that the results of ALU operations are stored in the intended location.

In a MIPS CPU, these signals are part of the control unit's outputs. The control unit decodes the opcode and function code of each instruction and sets these signals accordingly to ensure correct execution.

- For R-type instructions `REGRT` is 0
- For I-type instructions `REGRT` is 1
- SEXT depends on the instruction being executed, checks the MIPS指令 handbook
    - In our project, sign-extend ⇒ SEXT = 0
    - zero-extend ⇒ SEXT = 1

## ALUC (Arithmetic-logic Unit Control)

In the MIPS architecture, the ALU (Arithmetic Logic Unit) performs a variety of functions based on the instructions being executed. The ALU control codes are determined by the ALU Control Unit, which interprets the opcode and function field from the instruction to generate the appropriate control signal for the ALU. Here's a breakdown of common MIPS ALU functions and their typical ALU control codes:

### Arithmetic Operations

1. **Add (for `add`, `addi`, `lw`, `sw`)**:
    - Function: Adds two numbers.
    - ALU Control Code: Often `0010` (2).
2. **Subtract (for `sub`, `beq`, `bne`)**:
    - Function: Subtracts one number from another.
    - ALU Control Code: Often `0110` (6).

### Logical Operations:

1. **AND (for `and`, `andi`)**:
    - Function: Performs a bitwise AND.
    - ALU Control Code: Often `0000` (0).
2. **OR (for `or`, `ori`)**:
    - Function: Performs a bitwise OR.
    - ALU Control Code: Often `0001` (1).
3. **NOR (for `nor`)**:
    - Function: Performs a bitwise NOR.
    - ALU Control Code: Often `1100` (12).

### Comparison Operations

1. **Set on Less Than (for `slt`, `slti`)**:
    - Function: Sets the destination to 1 if the first operand is less than the second operand (signed comparison).
    - ALU Control Code: Often `0111` (7).

### Shift Operations

1. **Shift Left Logical (for `sll`)**:
    - Function: Shifts a word to the left by a specified number of bits, filling the emptied bits with 0.
    - ALU Control Code: Can vary, not typically assigned a standard code since it might be handled separately from the ALU.
2. **Shift Right Logical (for `srl`)**:
    - Function: Shifts a word to the right by a specified number of bits, filling the emptied bits with 0.
    - ALU Control Code: Can vary, similar to `sll`.

### Additional Notes

- The actual ALU control codes can vary depending on the specific implementation of the MIPS processor. The values provided here are typical examples.
- The ALUOp signals from the control unit, along with the function field (`FuncCode`) of the instruction, determine the specific operation to be performed by the ALU. This is particularly true for R-type instructions where different operations have the same opcode but are differentiated by the function field.
- In addition to the operations listed above, the MIPS ALU can perform other functions as required by specific instructions or specific implementations of the architecture.

When designing an ALU for a MIPS processor, the control codes and corresponding operations must be carefully defined and implemented to ensure correct execution of all instructions.

---

## Program Counter & Instruction Memory & Register File

An in-depth analysis of the `PC.v` (Program Counter), `InstMem.v` (Instruction Memory), and `RegFile.v` (Register File) modules

### PC.v (Program Counter)

**Purpose:**
The Program Counter (PC) is crucial in controlling the sequence of executed instructions. It holds the address of the next instruction to be fetched from the instruction memory.

**Typical Structure:**

- **Input:**
    - **Next PC Value (PCin):** The updated address for the next instruction, which could be sequential or the result of a branch/jump.
    - **Control Signals (Clock, reset):** May include signals to reset the PC or to indicate a jump/branch.
- **Output:**
    - **Current Address (PCout):** The address of the current instruction to be fetched.

**Functionality:**

- **Sequential Update:** Normally, the PC increments by a fixed amount (e.g., 4 in a 32-bit MIPS) each cycle to fetch the next instruction.
- **Branches/Jumps:** For non-sequential flow (like branches and jumps), the PC is loaded with a new address.
- **Reset:** On reset, the PC might be set to a predefined address, often the start of the program.

**Importance:**
The PC is essential for the CPU's sequential operation and handling control flow changes. It ensures instructions are fetched in the **correct order**.

![carbon (3).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(3).png)

![carbon (5).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(5).png)

### InstMem.v (Instruction Memory)

**Purpose:**
Instruction Memory stores the program's instructions that the CPU executes. It's read-only during normal operation.

**Typical Structure:**

- **Input:**
    - **Address:** Provided by the PC to fetch the next instruction.
- **Output:**
    - **Instruction:** The binary code of the instruction at the given address.

**Functionality:**

- **Fetch:** On each cycle, the instruction at the address specified by the PC is fetched and sent to the decoding stage.
- **Initialization:** Often, instruction memory is preloaded with a program during initialization or loaded through a separate process before execution.

**Importance:**
Instruction Memory is critical for providing a steady and correct sequence of instructions for the CPU to execute. It's a fundamental component for the fetch stage of the instruction cycle.

### RegFile.v (Register File)

**Purpose:**
The Register File is a small, fast storage area within the CPU that holds temporary data and operands for instructions.

**Typical Structure:**

- **Inputs:**
    - **Read Register Addresses:** Indicate which registers to read.
    - **Write Register Address and Data:** Indicate where and what data to write.
    - **Control Signals:** Like write enable, indicating when to write data.
- **Outputs:**
    - **Read Data:** The data from the requested registers.

**Functionality:**

- **Read:** Typically, the register file allows two registers to be read simultaneously in a single clock cycle.
- **Write:** Writing usually occurs on the rising or falling edge of the clock and is controlled by a write enable signal.
- **Zero Register:** Often, there's a dedicated register (like `$zero` in MIPS) that is hardwired to 0 and cannot be overwritten.

**Importance:**
Registers provide fast access to operands and are crucial for the CPU's operation. They hold immediate data for operations, results from the ALU, and temporary values needed during instruction execution.

![carbon (4).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(4).png)

### Connecting the Modules:

In a MIPS CPU:

- The `PC` sends the address to `InstMem`, which returns the current instruction.
- The instruction might dictate operations involving registers, so `InstMem` interacts with the `RegFile` to read operands or write results.
- The `PC` also updates based on the instruction, especially for branches and jumps, which might involve values from the `RegFile`.

### Conclusion:

These modules work together to drive the fundamental operation of fetching and executing instructions in a MIPS CPU. The `PC` determines the sequence of execution, `InstMem` provides the instructions, and `RegFile` offers fast access to operands and storage for results.

---

![carbon (10).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(10).png)

## Control Unit

The `ControlUnit.v` module you've provided is central to the MIPS CPU's operation. It interprets the current instruction's opcode and function fields to generate control signals that direct the flow of data and the operation of other modules. Let's break down how this Control Unit works and how it ties into the overall MIPS architecture.

### Overview of the Control Unit:

In a MIPS CPU, the Control Unit (CU) is responsible for generating signals based on the current instruction type (R, I, or J). These signals control aspects like ALU operations, memory access, and register writes.

### Inputs:

1. **Zero:** A flag typically from the ALU to indicate a zero result, used in branching decisions.
2. **OP (Opcode):** The primary identifier for the type of instruction being executed.
3. **Func (Function):** An additional field used with R-type instructions to determine the exact operation.

### Outputs:

1. **Jump, Branch:** Control signals for jumping and branching.
2. **Mem2Reg, WriteMem, WriteReg:** Determine where to write data (to register or memory) and whether to write.
3. **ALUC (ALU Control):** Specifies the operation the ALU should perform.
4. **Shift, ALUImm:** Indicate whether the operation is a shift or uses an immediate value.
5. **REGRT, SEXT:** Determine register destination and sign extension for immediate values.

### Functional Analysis:

The module is essentially a big combinational logic block implemented with a case statement that checks the opcode (`OP`) of the current instruction. Based on the opcode, it sets the control signals accordingly.

### R-type Instructions (OP = 000000):

- **Function Field Decoding:** Further decoding is done using the `Func` field to determine the exact ALU operation (like add, subtract, etc.).
- **Control Signals:** Set to enable the ALU operation, writing to the register, etc. The control signals are specifically tuned for operations that involve the ALU and registers.

### I-type Instructions:

- **ALUC:** Set based on the specific operation (like add immediate, load word, etc.).
- **ALUImm:** Enabled to indicate the ALU should use an immediate value.
- **SEXT:** Determines whether to sign-extend the immediate value.
- **Control Signals:** Adjusted to accommodate operations that involve immediate values, memory access, or branches.

### J-type Instructions (e.g., Jump):

- **Control Signals:** Set to initiate a jump. Other signals are disabled as they're not relevant for a jump operation.

### Special Cases:

- **NOP (No Operation):** Detected with a specific condition and ensures all control signals indicate no operation.
- **Undefined/Illegal Operations:** Default or error state is set for unexpected `Func` codes.

### Tying with MIPS Architecture:

In the MIPS CPU, the Control Unit is the decision-making heart. Here's how it interacts with the architecture:

1. **Instruction Fetch and Decode:** The CU (Control Unit) takes part of the fetched instruction (opcode and function) and decodes it.
2. **Signal Generation:** It generates control signals that orchestrate how data moves through the CPU and how other units like the ALU, memory, and registers operate.
3. **Synchronizing Operations:** By adjusting signals based on instruction types, it ensures the correct sequence of actions for each instruction.

### Importance:

The Control Unit's design directly impacts the CPU's efficiency and capability. Its ability to decode instructions and generate accurate control signals is crucial for the correct and efficient execution of programs.

### Summary:

- effectively decodes instructions and generates the necessary control signals for the MIPS CPU
- showcases typical combinational logic approach to control signal generation in synchronous digital systems
- by carefully setting these signals, it ensures the CPU operates correctly, whether it's performing arithmetic operations, accessing memory, or changing the flow of execution with jumps and branches.

---

## Memory (DataMemory.v)

In a MIPS architecture CPU, whether the data memory is explicitly connected to the clock depends on the specific implementation and the type of memory being used. Here's how it generally breaks down:

### Synchronous Memory

- **Synchronous memory** operates in sync with the system clock. Examples include Synchronous DRAM (SDRAM).
- **Clock Connection**: In systems using synchronous memory, the memory is indeed connected to the clock. The clock signal is used to **coordinate** read and write operations, ensuring they occur at predictable times in relation to other system operations.

### Asynchronous Memory

- **Asynchronous memory** does not rely on the system clock to coordinate its operations. Classic examples include older types of RAM like SRAM or certain types of **flash memory**.
- **No Direct Clock Connection**: Asynchronous memory doesn't need a direct connection to the system clock for its basic read/write operations. However, the rest of the system (like the control unit or the memory interface logic) will still be clocked and will thus ensure that memory operations are initiated at appropriate times.

### In a Typical MIPS Single-Cycle CPU

- **Data Memory Access Timing**: In a single-cycle MIPS CPU, each instruction, including those that access memory (like `lw` and `sw`), is completed in one clock cycle. The timing of the memory access is controlled by the rest of the CPU, which operates synchronously. This means the memory access starts and completes within one cycle, and the control signals dictating a memory read or write are synchronized with the system clock.
- **Clock to Memory Interface**: While the memory itself might not have a clock input (especially if it's asynchronous), the interface controlling the memory access will be synchronized with the system clock. This interface will ensure that read and write signals are correctly timed.

### Conclusion

- **Synchronous Systems**: In systems using synchronous memory, the data memory is indeed connected to the clock.
- **Asynchronous Systems**: In systems with asynchronous memory, the memory doesn't need to be connected to the clock, but the control signals for memory access will be synchronized with the system clock.
- **MIPS Single-Cycle CPU**: In a single-cycle CPU, even if the data memory isn't explicitly clocked, the control signals that orchestrate memory access are synchronized with the system clock to ensure correct operation.

When designing or studying a specific MIPS CPU implementation, always refer to the documentation or specifications to understand how memory is being handled in that particular context.

![carbon (11).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(11).png)

---

## Register File & Data Memory & ALU

The `RegFile.v`, `DataMemory.v`, and `ALU.v` modules are fundamental components of the MIPS CPU architecture. Each plays a crucial role in executing instructions and managing data flow within the CPU. Let's dive into each module's functionality, how they interact, and their roles in executing different types of instructions.

### RegFile.v (Register File)

**Purpose:** The Register File acts as a small, fast storage area within the CPU, holding temporary data and operands for instructions.

**Inputs/Outputs:**

- **Inputs:** `clock`, `WriteEnable`, `ReadReg1`, `ReadReg2`, `WriteReg`, `WriteData`.
- **Outputs:** `ReadData1`, `ReadData2`.

**Functionality:**

- **Reading:** On any given clock cycle, two registers can be read simultaneously (`ReadReg1`, `ReadReg2`), providing operands for ALU operations.
- **Writing:** When `WriteEnable` is active, data (`WriteData`) is written to the specified register (`WriteReg`) at the rising edge of the `clock`.
- **Initialization:** Registers are initialized to zero or predefined values for simulation or debug purposes.

**Role in MIPS:**

- **Arithmetic/Logical Instructions:** Source operands for ALU operations are read, and results are written back to the destination register.
- **Control Instructions:** Register values might be used to determine branch conditions or jump addresses.

### DataMemory.v (Data Memory)

**Purpose:** Data Memory stores and retrieves data used by the program, such as variables and array elements.

**Inputs/Outputs:**

- **Inputs:** `clock`, `address`, `WriteEnable`, `WriteData`.
- **Outputs:** `MemData`.

**Functionality:**

- **Writing:** When `WriteEnable` is active, `WriteData` is written to the memory location specified by the `address`.
- **Reading:** Data from the specified `address` is continuously read and presented at `MemData`.
- **Addressing:** Uses a subset of the address (`address[6:2]`) to access word-aligned memory locations.

**Role in MIPS:**

- **Load/Store Instructions:** Load instructions read data from memory into registers, while store instructions write data from registers to memory.

### ALU.v (Arithmetic Logic Unit)

**Purpose:** The ALU performs all arithmetic and logical operations.

**Inputs/Outputs:**

- **Inputs:** `A`, `B` (operands), `ALUC` (control code).
- **Outputs:** `Result`, `Zero` (zero flag).

**Functionality:**

- **Arithmetic Operations:** Performs addition (`0010`) and subtraction (`0110`).
- **Logical Operations:** Performs AND (`0000`), OR (`0001`), and NOR (`1100`).
- **Comparison Operations:** Performs set on less than (`0111`).
- **Zero Flag:** Indicates if the result of the operation is zero.

**Role in MIPS:**

- **Execution Phase:** Executes arithmetic, logical, and comparison operations as part of instruction execution.

![carbon (12).png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(12).png)

### Data Flow and Instruction Execution:

Here's how data flows between these modules and how various instructions utilize them:

1. **Arithmetic and Logical Instructions (e.g., add, sub, and, or):**
    - **RegFile:** Source operands are read from specified registers.
    - **ALU:** Performs the specified operation on the operands.
    - **RegFile:** The result is written back to the destination register.
2. **Load/Store Instructions (e.g., lw, sw):**
    - **Load (lw):**
        - **RegFile:** Base address is read from the specified register.
        - **ALU:** Calculates the effective address by adding the base address and offset.
        - **DataMemory:** Data is read from the calculated address.
        - **RegFile:** Data is written back to the target register.
    - **Store (sw):**
        - **RegFile:** Base address and data to store are read from specified registers.
        - **ALU:** Calculates the effective address.
        - **DataMemory:** Data is written to the calculated address.
3. **Control Instructions (e.g., beq, j):**
    - **Branch (beq):**
        - **RegFile:** Operands for comparison are read.
        - **ALU:** Performs subtraction to determine if operands are equal.
        - If equal (and the zero flag is set), the program counter is updated to the target address (handled by the control unit and PC, not directly within these modules).
    - **Jump (j):**
        - The program counter is directly updated to the target address (handled by the control unit and PC).

### Conclusion:

In the MIPS architecture, these three modules work in concert to execute a wide range of instructions. The Register File provides fast access to operands and stores results. The ALU performs all necessary arithmetic and logical operations, and Data Memory handles all interactions with the program's data. Control signals from the Control Unit dictate the operations and data flow based on the current instruction, ensuring the CPU operates correctly and efficiently. The interplay between these modules forms the heart of instruction execution, enabling the CPU to perform complex tasks and run programs.

---

## Non-Blocking (`<=`) vs Blocking (`=`) Assignment

In Verilog, the choice between using `<=` (non-blocking assignment) and `=` (blocking assignment) depends on the context of the variable assignment and the type of module you are implementing. Understanding when to use each is crucial for creating correct and reliable hardware descriptions.

### Non-Blocking Assignment (`<=`):

- **When to Use**: Non-blocking assignments are typically used in **sequential logic**, such as within `always @(posedge clock)` blocks. Sequential logic includes flip-flops and registers where the outputs change synchronously with the clock signal.
- **Behavior**: Non-blocking assignments allow all the right-hand side evaluations to complete before updating the left-hand side simultaneously. This behavior mimics real hardware more closely, where updates due to a clock edge don't immediately affect other operations happening on that same clock edge.
- **Typical Use Cases in MIPS**:
    - **Program Counter (PC)**: When updating the PC value on a clock edge.
    - **Register File**: When writing new data into a register on a clock edge.
    - **Any Sequential Elements**: Anywhere you have registers or memory elements that should update synchronously with the clock.

### Blocking Assignment (`=`):

- **When to Use**: Blocking assignments are typically used in **combinatorial logic** within `always @*` or `always @(<sensitivity list>)` blocks. Combinatorial logic includes gates and other structures where outputs change immediately as inputs change, with no regard for the clock.
- **Behavior**: Blocking assignments execute in the order they are written and complete before the next assignment begins. This can lead to unintended consequences in sequential logic but is generally what you want in combinatorial logic.
- **Typical Use Cases in MIPS**:
    - **ALU Operations**: For operations combining inputs like addition, subtraction, etc., which are inherently combinatorial.
    - **Decoding Logic**: Such as in a control unit where the output depends directly on various combinations of the current inputs.
    - **Intermediate Combinatorial Calculations**: Anywhere you're combining or manipulating signals to produce immediate results based on the current inputs.

### Guidelines for Use in Your Modules:

- **Program Counter (PC)**: Likely uses `<=` for updating the PC value because it's a sequential operation happening on a clock edge.
- **ALU (Arithmetic Logic Unit)**: Generally uses `=` for internal calculations because ALU operations are combinatorial.
- **Register File**: Uses `<=` for writing data to registers (a sequential operation), but reading data (a combinatorial operation) might use `=`.
- **Data Memory**: If it's synchronous, writing to or reading from memory might use `<=`, depending on how you've structured your memory access. Asynchronous memory might use `=` for immediate reads, with writes controlled by a clocked process.
- **Control Unit**: Likely uses `=` for most operations because it's usually combinatorial, **decoding** instructions and setting control signals based on the current inputs.

### Important Considerations:

- **Simulation vs. Synthesis**: While both blocking and non-blocking assignments will behave similarly in synthesis (turning into hardware), they can behave very differently in simulation. Misusing them can lead to simulation-synthesis mismatches, where your simulated design behaves one way and the synthesized hardware behaves another.
- **Readability and Debugging**: Consistent use of `=` for combinatorial logic and `<=` for sequential logic can make your code more readable and easier to debug. It helps others (and future you) quickly understand the intended behavior of each part of your code.

In summary, use non-blocking assignments (`<=`) for sequential logic to correctly model hardware behavior where multiple updates occur based on a clock edge. Use blocking assignments (`=`) for combinatorial logic where outputs immediately reflect changes in inputs. Following these guidelines will help ensure that your Verilog modules function as intended in both simulation and synthesis.

---

## Tying Everything Together

The nine Verilog files corresponding to the modules of our MIPS CPU. These files are:

- `ALU.v`
- `ControlUnit.v`
- `DataMemory.v`
- `InstMem.v`
- `MipsCPU.v`
- `PC.v`
- `RegFile.v`
- `ShiftLeft2.v`
- `SignExtend.v`

Next, I'll analyze the contents of the `MipsCPU.v` file, as it should provide insights into how the other modules (`ALU`, `ControlUnit`, `DataMemory`, `InstMem`, `PC`, `RegFile`, `ShiftLeft2`, `SignExtend`) are interconnected to create a working MIPS CPU.

The `MipsCPU.v` file appears to be the top-level module that integrates all the other components of the MIPS CPU. Here's a breakdown of the connections and functionality described in the first part of the file:

### Module Definition and Inputs:

- **Module Name:** `MipsCPU`
- **Inputs:** `clock` and `reset` signals.

### Internal Connections and Components:

1. **Program Counter (PC):**
    - **Module:** `PC`
    - **Inputs:** `clock`, `reset`, and `PCin` (the next program counter value).
    - **Output:** `PCout` (the current address).
    - **Functionality:** Keeps track of the address of the next instruction. It's likely to increment by 4 for sequential execution (as indicated by `PCin = Mux5_Out + 4`).
2. **Instruction Memory (InstMem):**
    - **Module:** `InstMem`
    - **Inputs:** `clock` and `addr` (address to fetch the instruction from, provided by `PCout`).
    - **Output:** `inst` (the fetched instruction).
    - **Functionality:** Stores the program's instructions and provides the current instruction based on the program counter's address.
3. **Control Unit:**
    - **Module:** `ControlUnit`
    - **Inputs:** Various parts of the instruction (`inst[31:26]` for the opcode and `inst[5:0]` for the function code), and the `Zero` flag (likely from the ALU).
    - **Outputs:** Control signals like `Jump`, `Branch`, `Mem2Reg`, `WriteMem`, `WriteReg`, `ALUC`, `ALUImm`, `Shift`, `REGRT`, `SEXT`.
    - **Functionality:** Generates control signals to orchestrate the operation of the CPU based on the current instruction.
4. **Multiplexers and Sign Extension:**
    - **Modules:** `Mux1` and `SignExtend`
    - **Purpose:** To determine the write register (`ND`) and to extend immediate values (`Extended32`) for I-type instructions.

### Preliminary Analysis:

From the initial portion of the `MipsCPU.v` file, it's evident that this module serves as the central unit where all other modules are interconnected. The program counter and instruction memory work together to fetch instructions. The control unit decodes these instructions and generates control signals that dictate how other modules like the ALU, register file, and data memory should operate. Multiplexers and sign extension units handle specific decisions and data modifications necessary for instruction execution.

Next, I'll continue analyzing the rest of the `MipsCPU.v` file to provide a more comprehensive understanding of how the modules are connected and work together to create a functional MIPS CPU.

The `MipsCPU.v` module continues to describe how the various components of the MIPS CPU are interconnected. Here's a further breakdown of the connections and functionality:

### Register File (RegFile):

- **Module:** `RegFile`
- **Inputs:**
    - `clock`: System clock.
    - `WriteEnable` (from `WriteReg`): Signal to enable writing to the register.
    - `ReadReg1`, `ReadReg2`: Specified registers to read (from instruction bits).
    - `WriteReg` (from `ND`): Specifies which register to write to.
    - `WriteData` (from `Mux6_Out`): Data to write to the register.
- **Outputs:** `ReadData1` (to `Q1`), `ReadData2` (to `Q2`).
- **Functionality:** Reads data from or writes data to registers based on the instruction and control signals.

### ALU:

- **Module:** `ALU`
- **Inputs:**
    - `ALUC`: Control code determining the operation to perform.
    - `A` (from `ALU_A`), `B` (from `ALU_B`): Operands for the ALU operations.
- **Outputs:** `Result` (the result of the operation), `Zero` (a flag indicating if the result is zero).
- **Functionality:** Performs arithmetic and logical operations based on the ALU control code.

### Multiplexers and Shift Operations:

- **Mux2, Mux3, Mux4, Mux5, Mux6:** These multiplexers determine various paths for data based on control signals, such as whether to use immediate values or register data, and which address to jump or branch to.
- **ShiftLeft2:** Shifts the input left by 2 bits, typically used for address calculations in branch and jump instructions.

### Data Memory (DataMemory):

- **Module:** `DataMemory`
- **Inputs:**
    - `clock`: System clock.
    - `address` (from `Result`): Address to read from or write to.
    - `WriteEnable` (from `WriteMem`): Control signal for writing to memory.
    - `WriteData` (from `Q2`): Data to write into memory.
- **Output:** `MemData` (data read from memory).
- **Functionality:** Stores and retrieves data used by the CPU, handling load and store instructions.

### Data Flow and Instruction Execution:

1. **Fetching and Decoding:**
    - The `PC` module provides the address to the `InstMem` module, which fetches the current instruction.
    - The `ControlUnit` decodes the instruction and sends control signals to other parts of the CPU.
2. **Executing:**
    - Source operands are fetched from the `RegFile`.
    - The `ALU` performs computations based on the control signals and operands.
    - For memory-related instructions, the `DataMemory` module is accessed to load or store data.
3. **Writing Back:**
    - The results of computations or data loaded from memory are written back to the `RegFile`.
4. **Branching and Jumping:**
    - Control signals from the `ControlUnit` along with ALU flags and multiplexer logic determine the next value of the program counter, handling branches and jumps.

### Conclusion:

The `MipsCPU.v` module is a comprehensive representation of how the MIPS CPU is structured. It interconnects various components like the ALU, Control Unit, Data Memory, and Register File to fetch, decode, execute, and write back instructions in a coordinated manner. Multiplexers and shift units manage data paths and address calculations, while the program counter ensures sequential instruction execution and handles control flow changes. This orchestrated activity allows the MIPS CPU to perform a wide range of operations, from arithmetic and logical computations to memory access and control flow management.

---

# ⭐ About the Project & Running the CPU

Visual Studio, [ICARUS Verilog](https://github.com/steveicarus/iverilog), and [GTKWave](https://github.com/gtkwave/gtkwave) was used for the implementation of this CPU. All the **verilog files** for the components are located in the root of the project folder and the **documentation** and **test bench** for each component (except muxes) are located the folders starting with `tb_componentname`.

![WX20231223-130038@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231223-1300382x.png)

## Why IVerilog (ICARUS Verilog) over Vivado?

ICARUS Verilog is an open-source Verilog simulation and synthesis tool, widely recognized for its simulation capabilities of Verilog or SystemVerilog designs. As part of the GNU project, it's favored in academic and hobbyist settings due to its cost-free nature and compatibility across various platforms like Linux, Windows, and macOS. While it can perform some synthesis tasks through external tools, ICARUS Verilog is primarily known for its robust simulation features and operates via command line, making it suitable for scripting and automation.

On the other hand, Vivado Design Suite by Xilinx is a comprehensive software suite designed for synthesis and analysis of HDL designs, specifically targeting their own FPGAs. It provides an integrated development environment with advanced tools for design entry, simulation, synthesis, and implementation. Vivado caters to a broad user base, from students using the free WebPACK edition to professionals leveraging its full feature set in paid versions. Unlike ICARUS Verilog, Vivado is specifically tailored for Xilinx hardware and includes a GUI, making it more accessible and versatile for various FPGA development tasks. While ICARUS Verilog is ideal for those requiring a straightforward, cost-effective simulation tool, Vivado offers a more extensive suite of features for in-depth FPGA development, especially for users working with Xilinx products.

Another factor is that Vivado is only supported on x86 processors running Linux or Windows, but MacOS is not supported, especially ones using apple silicon. IVerilog and GTKWave is open source and can be easily recompiled to run on apple silicon so this was the only solution that worked on my Macbook Pro using the M1 CPU.

## What is GTKWave?

GTKWave is a waveform viewer that is commonly used for viewing the simulation results of digital circuits. Originally developed for Linux systems, it's now available on multiple platforms, including Windows and macOS. GTKWave supports various file formats produced by simulation tools, allowing users to view and analyze the timing of signals within their digital designs.

The primary purpose of GTKWave is to provide a graphical interface where engineers and designers can examine the changes in signal values over time, as produced by hardware description language (HDL) simulators like Verilog or VHDL. By loading the waveform data into GTKWave, users can navigate through the simulation timeline, zoom in on specific events, track signal relationships, and more. It's particularly valuable for debugging complex digital circuits, verifying that the logic behaves as expected, and ensuring timing requirements are met.

GTKWave stands out for its capability to handle large waveform files efficiently and its rich set of features like signal reordering, searching, and filtering, which help users analyze and interpret their simulation data effectively. It's a vital tool in the digital design and verification process, especially for those working with open-source or various HDL simulation environments.

![Picture of how GTKWave looks like on MacOS Sonoma](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231223-0015522x.png)

Picture of how GTKWave looks like on MacOS Sonoma

## Installing Prerequisites

### Install ICARUS Verilog

[GitHub - steveicarus/iverilog: Icarus Verilog](https://github.com/steveicarus/iverilog#buildinginstalling-icarus-verilog-from-source)

### Install GTKWave

[GitHub - gtkwave/gtkwave: GTKWave is a fully featured GTK+ based wave viewer for Unix and Win32 which reads LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog VCD/EVCD files and allows their viewing.](https://github.com/gtkwave/gtkwave#building-gtkwave-from-source)

## Building and Simulating the CPU

```bash
# Simply execute the shell file in the root of the project directory
# It would first compile all the verilog files for the MIPS cpu together
# And then a testbench file would be generated and GTKWave would be opened with the waveforms
./run.sh

# Or running manually...
iverilog -o cpu testbench.v Mux1.v Mux2.v Mux3.v Mux4.v Mux5.v Mux6.v MipsCPU.v PC.v InstMem.v RegFile.v DataMemory.v ControlUnit.v ALU.v ShiftLeft2.v SignExtend.v
vvp cpu

gtkwave tb_mips_cpu.vcd &
```

The commands you've provided are part of a workflow for simulating and analyzing a digital design (like a MIPS CPU) using Verilog tools on a Unix-like system. Here's what each command does:

### 1. Compiling the Design: `iverilog`

```
iverilog -o cpu testbench.v Mux1.v Mux2.v Mux3.v Mux4.v Mux5.v Mux6.v MipsCPU.v PC.v InstMem.v RegFile.v DataMemory.v ControlUnit.v ALU.v ShiftLeft2.v SignExtend.v
```

- **`iverilog`**: This is the Icarus Verilog compiler. It compiles Verilog files into a format that can be executed or simulated.
- **`o cpu`**: This option specifies the output file name (`cpu`) for the compiled simulation. This file will be an executable.
- **`testbench.v Mux1.v ... SignExtend.v`**: These are the source Verilog files. They likely include the design of your MIPS CPU (`MipsCPU.v`), various multiplexers (`Mux1.v`, etc.), the program counter (`PC.v`), instruction and data memory modules (`InstMem.v` and `DataMemory.v`), a control unit (`ControlUnit.v`), the ALU (`ALU.v`), and other components like shifters and sign extenders. `testbench.v` is probably the testbench file that instantiates the CPU and applies stimuli to it for simulation.

This command compiles all the Verilog files into an executable simulation model named `cpu`.

### 2. Running the Simulation: `vvp`

```
vvp cpu
```

- **`vvp`**: This is the Icarus Verilog runtime engine. It runs the simulation model created by `iverilog`.
- **`cpu`**: This is the name of the compiled simulation model you created in the previous step.

This command runs the simulation. During the simulation, `testbench.v` will apply various inputs to your MIPS CPU model over time, and the behavior (outputs, internal states) will be recorded. Often, test benches are designed to write this information to a file in Value Change Dump (VCD) format, which might be the case here with `tb_mips_cpu.vcd`.

### 3. Viewing the Results: `gtkwave`

```
gtkwave tb_mips_cpu.vcd &
```

- **`gtkwave`**: This is a waveform viewer program used to visualize simulation results.
- **`tb_mips_cpu.vcd`**: This is the VCD file likely generated by your testbench during simulation. It contains a record of how signals in your design changed over time.
- **`&`**: In Unix-like systems, this runs the command in the background, allowing you to continue using the terminal.

This command opens the VCD file in GTKWave, allowing you to visually analyze how the signals in your MIPS CPU changed over the course of the simulation. This is crucial for verifying the correctness of your design, understanding its behavior, and debugging issues.

![A dump of all the initial register, instruction, and memory at the start of the simulation](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/carbon_(8).png)

A dump of all the initial register, instruction, and memory at the start of the simulation

---

# 4️⃣ Testing

## What To Test?

To test and verify the correctness and validity of each instruction in your MIPS single-cycle CPU, you'll need to create a series of test instructions that individually exercise each operation and a few that demonstrate combined behavior. Below is a list of potential instructions for each operation to help us come up with a program that can test the validity of each instruction. Make sure to initialize the register values before testing:

### Initialize Registers (to use in subsequent tests):

```
addi $t0, $zero, 5    # $t0 = 5
addi $t1, $zero, 10   # $t1 = 10
addi $t2, $zero, 15   # $t2 = 15
addi $t3, $zero, 20   # $t3 = 20
```

But these exact values were not used in our future test program, this was just for brainstorming.

### Arithmetic Instructions:

1. **add** - Add:
    - `add $t4, $t0, $t1` # $t4 = $t0 + $t1 = 5 + 10
2. **sub** - Subtract:
    - `sub $t5, $t2, $t1` # $t5 = $t2 - $t1 = 15 - 10
3. **addi** - Add immediate:
    - `addi $t6, $t0, 10` # $t6 = $t0 + 10 = 5 + 10
4. **slt** - Set less than:
    - `slt $t7, $t0, $t1` # $t7 = 1 if $t0 < $t1 else 0 (Should set $t7 to 1)
5. **slti** - Set less than immediate:
    - `slti $t8, $t1, 5` # $t8 = 1 if $t1 < 5 else 0 (Should set $t8 to 0)

### Logical Instructions:

1. **and** - Logical AND:
    - `and $t4, $t0, $t1` # $t4 = $t0 & $t1
2. **or** - Logical OR:
    - `or $t5, $t2, $t1` # $t5 = $t2 | $t1
3. **andi** - AND immediate:
    - `andi $t6, $t0, 3` # $t6 = $t0 & 3
4. **ori** - OR immediate:
    - `ori $t7, $t1, 2` # $t7 = $t1 | 2

### Memory Instructions:

1. **sw** - Store word:
    - `sw $t2, 0($t0)` # Store $t2 into address 0 + contents of $t0
2. **lw** - Load word:
    - `lw $t3, 0($t0)` # Load word from address 0 + contents of $t0 into $t3

### Control Flow Instructions:

1. **j** - Jump (to a label named `target`):
    - `j target` # Jump to instruction labeled `target`
2. **nop** - No operation:
    - `nop` # No operation (can be used to observe delay or default behavior)

### Testing Sequence and Verification:

- **Sequential Test**: Run the instructions sequentially to ensure each one works individually.
- **Dependency Test**: Create instruction sequences where the output of one instruction is used as input to another. This will help verify that data is being correctly passed through the registers.
- **Boundary Conditions**: Test boundary conditions like zero, maximum, and minimum integer values, especially for arithmetic and comparison operations.
- **Jump Test**: Ensure the jump instruction correctly changes the program counter (PC) and that subsequent instructions are from the new PC location.
- **Memory Test**: After storing values with `sw`, use `lw` to load them back and verify they match.

### Things to Note:

- **Register Initialization**: Make sure the registers used in testing are initialized to known values before starting the tests.
- **Memory Initialization**: Initialize memory locations that will be used by `sw` and `lw` instructions.
- **Observation**: Use a simulator to step through each instruction and observe the changes in registers and memory. Check that the values match your expectations based on the instruction being executed.

## Let’s Start Testing!

The code snippets on the right come from `RegFile.v` and `DataMem.v`. In the ********init******** blocks, we declared some initial values, and these values would be used later on when running our demonstration code. In this part of 

```verilog
// some random initial values
    reg_mem[0] = 0;
    reg_mem[1] = 8;
    reg_mem[2] = 20;
```

```verilog
// initial values
		Mem[0] = 5;
		Mem[1] = 6;
		Mem[2] = 7;
```

### Hex Instructions

```
20040000
20240000
20440000
00000000
8C030000
8C040004
8C050008
8C06000C
00000000
AC00000C
AC010010
AC020014
00000000
8C03000C
8C040010
8C050014
00000000
20C60000
20260005
20C60000
00000000
00223020
20C60000
00000000
00C13822
20E70000
00000000
0007402A
21080000
28E90005
21290000
28E90019
21290000
00000000
00800824
20210000
00820825
20210000
30C00007
20000000
34E10002
20210000
00000000
0800000F
00000000
```

### Instructions explained

```
20040000 - 001000 00000 00100 00000 00000 000000 # addi $r0, $r4, 0 check values of reg
20240000 - 001000 00001 00100 00000 00000 000000 # addi $r1, $r4, 0
20440000 - 001000 00010 00100 00000 00000 000000 # addi $r2, $r4, 0
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
8C030000 - 100011 00000 00011 00000 00000 000000 # lw $r3, 0($r0)
8C040004 - 100011 00000 00100 00000 00000 000100 # lw $r4, 4($r0)
8C050008 - 100011 00000 00101 00000 00000 001000 # lw $r5, 8($r0)
8C06000C - 100011 00000 00110 00000 00000 001100 # lw $r6, 12($r0) nothing should be here
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
AC00000C - 101011 00000 00000 00000 00000 001100 # sw $r0, 12($r0)
AC010010 - 101011 00000 00001 00000 00000 010000 # sw $r1, 16($r0)
AC020014 - 101011 00000 00010 00000 00000 010100 # sw $r2, 20($r0)
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
8C03000C - 100011 00000 00111 00000 00000 001100 # lw $r6, 12($r0) check the values of data mem
8C040010 - 100011 00000 00111 00000 00000 010000 # lw $r6, 16($r0)
8C050014 - 100011 00000 00111 00000 00000 010100 # lw $r6, 20($r0)
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
20C60000 - 001000 00110 00110 00000 00000 000000 # addi $r6, $r6, 0
20260005 - 001000 00001 00110 00000 00000 000101 # addi $r1, $r6, 5
20C60000 - 001000 00110 00110 00000 00000 000000 # addi $r6, $r6, 0
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
00223020 - 000000 00001 00010 00110 00000 100000 # add $r1, $r2, $r6
20C60000 - 001000 00110 00110 00000 00000 000000 # addi $r6, $r6, 0
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
00C13822 - 000000 00110 00001 00111 00000 100010 # sub $r6, $r1, $r7
20E70000 - 001000 00111 00111 00000 00000 000000 # addi $r7, $r7, 0
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
0007402A - 000000 00000 00111 01000 00000 101010 # slt $r0, $r7, $r8
21080000 - 001000 01000 01000 00000 00000 000000 # addi $r8, $r8, 0 check what's in $r8
28E90005 - 001010 00111 01001 00000 00000 000101 # slti $t7, $t9, 5
21290000 - 001000 01001 01001 00000 00000 000000 # addi $r9, $r9, 0 check what's in $r9
28E90019 - 001010 00111 01001 00000 00000 011001 # slti $t7, $t9, 25
21290000 - 001000 01001 01001 00000 00000 000000 # addi $r9, $r9, 0 check what's in $r9
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
00800824 - 000000 00100 00000 00001 00000 100100 # and $r4, $r0, $r1
20210000 - 001000 00001 00001 00000 00000 000000 # addi $r1, $r1, 0 check what's in $r1
00820825 - 000000 00100 00010 00001 00000 100101 # or $r5, $r2, $r1
20210000 - 001000 00001 00001 00000 00000 000000 # addi $r1, $r1, 0 check what's in $r1
30C00007 - 001100 00110 00000 00000 00000 000111 # andi $r6, $r0, 7
20000000 - 001000 00000 00000 00000 00000 000000 # addi $r0, $r0, 0 check what's in $r0
34E10002 - 001101 00111 00001 00000 00000 000010 # ori $t7, $t1, 2
20210000 - 001000 00001 00001 00000 00000 000000 # addi $r1, $r1, 0 check what's in $r1
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
0800000F - 000010 00000 00000 00000 00000 001111 # j 0xF -> 15
00000000 - 000000 00000 00000 00000 00000 000000 # NOP
```

### Reviewing Waveform Results

![WX20231224-181847@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1818472x.png)

0ns~40ns is given for the initialization of all the instruction memory, register data, and memory data

---

![WX20231224-181907@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1819072x.png)

**Instruction**: 0x**20040000**

`addi $r0, $r4, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20040000 | 001000 | 00000 | 00100 | 00000 | 00000 | 000000 |

Adds 0 to $r0 and stores the result in $r4. Since $r0’s initial value is 0, this does nothing to $r4.

No change ($r0 & $r4 is 0).

The purpose of `addi` with an immediate value of 0 is just to **check the value** in the register. $r4 is just a temporary register.

Observe that: `Q1 = 0x0`

![WX20231224-181915@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1819152x.png)

**Instruction**: 0x**20240000**

`addi $r1, $r4, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20240000 | 001000 | 00001 | 00100 | 00000 | 00000 | 000000 |

Adds 0 to $r1  and stores the result in $r4.

Sets $r4 to $r1 + 0 (initially 0 → 8).

Observe that: `Q1 = 0x8`

![WX20231224-181922@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1819222x.png)

**Instruction**: 0x**20440000**

`addi $r1, $r4, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20440000 | 001000 | 00001 | 00100 | 00000 | 00000 | 000000 |

Adds 0 to $r2 and stores the result in $r4.

Sets $r4 to $r2 + 0 (initially 0 → 20).

Observe that: `Q1 = 0x14`

---

**Demonstrating `lw` → Load word instruction**

![WX20231224-181932@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1819322x.png)

**Instruction**: 0x**8C030000**

`lw $r3, 0($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C030000 | 100011 | 00000 | 00011 | 00000 | 00000 | 000000 |

Loads word from memory address 0 into $r3.

Loads 5 into $r3 from memory address 0.

Observe that: `MemData = 0x5` & `Mux6_Out = 0x5.`

`Mux6_Out` contains the value that would be saved to the register.

![WX20231224-183117@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1831172x.png)

**Instruction**: 0x**8C040004**

`lw $r4, 4($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C040004 | 100011 | 00000 | 00100 | 00000 | 00000 | 000100 |

Loads word from memory address 4 into $r4.

Loads 6 into $r4 from memory address 4.

Observe that: `MemData = 0x6` & `Mux6_Out = 0x6.`

`Mux6_Out` contains the value that would be saved to the register.

![WX20231224-181953@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1819532x.png)

********Instruction********: 0x**8C050008**

`lw $r5, 8($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C050008 | 100011 | 00000 | 00101 | 00000 | 00000 | 001000 |

Loads word from memory address 8 into $r5.

Loads 7 into $r5 from memory address 8.

Observe that: `MemData = 0x7` & `Mux6_Out = 0x7`

![WX20231224-182005@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820052x.png)

**********************Instruction**********************: 0x**8C06000C**

`lw $r6, 12($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C06000C | 100011 | 00000 | 00110 | 00000 | 00000 | 001100 |

Loads word from memory address 12 into $r6.

Loads 0 into $r6 from memory address 12 (default).

Observe that: `MemData = 0x0` & `Mux6_Out = 0x0`

The value is 0 because there is nothing stored at 12 so 0 is the default value.

This section shows that `sw` instruction works as intended.

---

**Demonstrating `sw` → Store word instruction**

![WX20231224-182011@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820112x.png)

**********************Instruction**********************: 0x**AC00000C**

`sw $r0, 12($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0xAC00000C | 101011 | 00000 | 00000 | 00000 | 00000 | 001100 |

Stores the content of $r0 into memory address 12.

Stores 0 (from $r0) into memory address 12.

Observe that: `N2 = 0` & `Q2 = 0x0`

![WX20231224-182017@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820172x.png)

**********************Instruction**********************: 0x**AC010010**

`sw $r1, 16($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0xAC010010 | 101011 | 00000 | 00001 | 00000 | 00000 | 010000 |

Stores the content of $r1 into memory address 16.

Stores 8 (from $r1) into memory address 16.

Observe that: `N2 = 1` & `Q2 = 0x8`

![WX20231224-182023@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820232x.png)

************************Instruction************************: 0x**AC020014**

`sw $r2, 20($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0xAC020014 | 101011 | 00000 | 00010 | 00000 | 00000 | 010100 |

Stores the content of $r2 into memory address 20.

Stores 20 (from $r2) into memory address 20.

Observe that: `N2 = 2` & `Q2 = 0x14`

- Note that N2 denotes the register whose value is being read and then stored into memory, and of course the value read from N2 is 20.

---

**Verifying the values stored previously by `sw`**

![WX20231224-182046@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820462x.png)

**Instruction**: 0x**8C03000C**

`lw $r6, 12($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C03000C | 100011 | 00000 | 00111 | 00000 | 00000 | 001100 |

Loads word from memory address 12 into $r6.

Loads 0 (from memory address 12) into $r6.

Observe that: `MemData = 0x0`

![WX20231224-182052@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820522x.png)

**Instruction**: 0x**8C040010**

`lw $r6, 16($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C040010 | 100011 | 00000 | 00111 | 00000 | 00000 | 010000 |

Loads word from memory address 16 into $r6.

Loads 8 (from memory address 16) into $r6.

Observe that: `MemData = 0x8`

![WX20231224-182058@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1820582x.png)

**Instruction**: 0x**8C050014**

`lw $r6, 20($r0)`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x8C050014 | 100011 | 00000 | 00111 | 00000 | 00000 | 010100 |

Loads word from memory address 20 into $r6.

Loads 20 (from memory address 20) into $r6.

Observe that: `MemData = 0x14`

This section verified the values stored in memory by the previous section, therefore showing that `sw` instruction works as intended.

---

**Demonstrating `addi` → ADD instruction (immediate)**

![WX20231224-182104@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821042x.png)

**********************Instruction**********************: 0x**20C60000**

`addi $r6, $r6, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20C60000 | 001000 | 00110 | 00110 | 00000 | 00000 | 000000 |

Adds 0 to $r6 and stores the result back in $r6.

No change to $r6.

![WX20231224-182110@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821102x.png)

**********************Instruction**********************: 0x**20260005**

`addi $r1, $r6, 5`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20260005 | 001000 | 00001 | 00110 | 00000 | 00000 | 000101 |

Adds 5 to $r6 and stores the result in $r1.

Sets $r1 to 5 ($r6 + 5).

![WX20231224-182118@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821182x.png)

**********************Instruction**********************: 0x**20C60000**

`addi $r6, $r6, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20C60000 | 001000 | 00110 | 00110 | 00000 | 00000 | 000000 |

Adds 0 to $r6 and stores the result back in $r6.

No change to $r6.

This sections shows `addi` instruction working as normal

---

**Demonstrating `add` → Add word instruction**

![WX20231224-182125@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821252x.png)

**********************Instruction**********************: 0x**00223020**

`add $r1, $r2, $r6`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x00223020 | 000000 | 00001 | 00010 | 00110 | 00000 | 100000 |

Adds $r2 and $r6, and stores the result in $r1.

Sets $r6 to $r1 + $r2 (8 + 20 = 28).

![WX20231224-182131@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821312x.png)

**********************Instruction**********************: 0x**20C60000**

`addi $r6, $r6, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20C60000 | 001000 | 00110 | 00110 | 00000 | 00000 | 000000 |

Adds 0 to $r6 and stores the result back in $r6.

Verify that $r6 current value indeed is 0x1C or 28 in decimal form

This sections shows `add` instruction working as normal

---

**Demonstrating `sub` → Sub word instruction**

![WX20231224-182139@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821392x.png)

************************Instruction************************: 0x**00C13822**

`sub $r6, $r1, $r7`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x00C13822 | 000000 | 00110 | 00001 | 00111 | 00000 | 100010 |

Subtracts $r6 (28) from $r1 (8) and stores the result in $r7 (28 - 8 = 20).

Observe that: `RESULT = 0x14`

![WX20231224-182153@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1821532x.png)

************************Instruction************************: 0x**20E70000**

`addi $r7, $r7, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20E70000 | 001000 | 00111 | 00111 | 00000 | 00000 | 000000 |

Adds 0 to $r7 and stores the result in $r7.

This instruction lets us check the value inside $r7

Observe that: both `Q1 & Q2 = 0x14`

This sections shows `sub` instruction working as normal

---

**Demonstrating `stl` & `stli`→ Set Less Than (& immediate)**

![WX20231224-182210@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822102x.png)

**********************Instruction**********************: 0x0007402A

`slt $r0, $r7, $r8`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x0007402A | 000000 | 00000 | 00111 | 01000 | 00000 | 101010 |

Sets $r8 to 1 if $r0 is less than $r7, otherwise 0.

`$r0 = 0` and `$r7 = 0x14`, 0 < 20 so $r8 should be set to 1

Observe that: `RESULT = 0x1`

![WX20231224-182219@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822192x.png)

************************Instruction************************: 0x**21080000**

`addi $r8, $r8, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x21080000 | 001000 | 01000 | 01000 | 00000 | 00000 | 000000 |

Adds 0 to $r8 and stores the result in $r8.

Checks the value stored in $r8

Observe that: `Q1 & Q2 = 0x1`

![WX20231224-182228@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822282x.png)

************************Instruction************************: 0x**28E90005**

`slti $r7, $r9, 5`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x28E90005 | 001010 | 00111 | 01001 | 00000 | 00000 | 000101 |

Sets $r9 to 1 if $r7 is less than 5, otherwise 0.

`$r7 = 0x14` or 20, which is more than 5. So $r9 should be set to 0.

Observe that: `RESULT = 0x0`.

![WX20231224-182234@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822342x.png)

**********************Instruction**********************: 0x**21290000**

`addi $r9, $r9, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x21290000 | 001000 | 01001 | 01001 | 00000 | 00000 | 000000 |

Adds 0 to $r9 and stores the result in $r9.

Checks the value stored in $r9

Observe that: `Q1 & Q2 = 0x0`

![WX20231224-182240@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822402x.png)

******Instruction******: 0x**28E90019**

`slti $r7, $r9, 25`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x28E90019 | 001010 | 00111 | 01001 | 00000 | 00000 | 011001 |

Sets $r9 to 1 if $r7 is less than 25, otherwise 0.

`$r7 = 0x14` or 20, which indeed is less than 25.

Observe that: `RESULT = 0x1`.

![WX20231224-182249@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1822492x.png)

************Instruction************: 0x**21290000**

`addi $r9, $r9, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x21290000 | 000000 | 00100 | 00000 | 00001 | 00000 | 100100 |

Adds 0 to $r9 and stores the result in $r9.

Checks the value stored in $r9

Observe that: `Q1 & Q2 = 0x1`

This sections shows `stl` & `stli` instruction working as normal

---

**Demonstrating `and`, `andi`, `or`, `ori` → Logical AND and OR instruction (& immediate)**

![WX20231224-182309@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823092x.png)

************************Instruction************************: 0x**00800824**

`and $r4, $r0, $r1`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x00800824 | 000000 | 00100 | 00000 | 00001 | 00000 | 100100 |

Performs a bitwise AND between $r0 and $r1 and stores the result in $r4.

![WX20231224-182321@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823212x.png)

************************Instruction************************: 0x**20210000**

`addi $r1, $r1, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20210000 | 001000 | 00001 | 00001 | 00000 | 00000 | 000000 |

Adds 0 to $r1 and stores the result in $r1.

![WX20231224-182327@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823272x.png)

************************Instruction************************: 0x**00820825**

`or $r5, $r2, $r1`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x00820825 | 000000 | 00100 | 00010 | 00001 | 00000 | 100101 |

Performs a bitwise OR between $r2 and $r1 and stores the result in $r5.

![WX20231224-182334@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823342x.png)

************************Instruction************************: 0x**20210000**

`addi $r1, $r1, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20210000 | 001000 | 00001 | 00001 | 00000 | 00000 | 000000 |

Adds 0 to $r1 and stores the result in $r1.

![WX20231224-182340@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823402x.png)

************************Instruction************************: 0x**30C00007**

`andi $r6, $r0, 7`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x30C00007 | 001100 | 00110 | 00000 | 00000 | 00000 | 000111 |

Performs a bitwise AND between $r0 and the immediate 7, storing the result in $r6.

![WX20231224-182347@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823472x.png)

************************Instruction************************: 0x**20000000**

`addi $r0, $r0, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20000000 | 001000 | 00000 | 00000 | 00000 | 00000 | 000000 |

Adds 0 to $r0, which has no effect since $r0 is always 0.

![WX20231224-182355@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1823552x.png)

************************Instruction************************: 0x**34E10002**

`ori $t7, $t1, 2`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x34E10002 | 001000 | 00001 | 00001 | 00000 | 00000 | 000000 |

Performs a bitwise OR between $t1 and the immediate 2, storing the result in $t7.

![WX20231224-182401@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1824012x.png)

************************Instruction************************: 0x**20210000**

`addi $r1, $r1, 0`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x20210000 | 001000 | 00001 | 00001 | 00000 | 00000 | 000000 |

Adds 0 to $r1 and stores the result in $r1.

This section showed the logical AND `and`and OR `or` instructions and their immediate forms (`andi` & `ori`) working properly

---

**Demonstrating `j` → Jump instruction**

![WX20231224-182409@2x.png](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/WX20231224-1824092x.png)

************************Instruction************************: 0x**0800000F**

`j 0xF`

| HEX Instruction | Opcode (6 bits) | Source 1 (5 bits) | Source 2/Dest (5 bits) | Destination (5 bits) | Shift (5 bits) | Function/Immediate (6/16 bits) |
| --- | --- | --- | --- | --- | --- | --- |
| 0x0800000F | 000010 | 00000 | 00000 | 00000 | 00000 | 001111 |

Jumps 15 instructions ahead of the current program counter, no change to registers or memory.

PC jumped from **0xB0 → 0xF0**. 0xF0 - 0xAC = **0x40** (240 – 172 = **64**), which is 0xF << 2 = 0x**3C** (15 * 4 = 60 + 4)

Therefore, we jumped 60 bytes which is exactly what the command said and then the ******+4****** is the PC adding 4 bytes to the instruction address at every clock cycle

This section showed the jump (`j`) instruction working correctly

---

# 5️⃣ Future Plans & Take Away (心得)

The current MIPS CPU is only a single-cycle CPU with a limited set of instructions (the ones that were required for this project). Later on in my free time, I plan to implement a more complete set of instructions to potentially build a fully functioning CPU that could execute instructions. Attached below is a list of instructions and their operations that I plan to add to this processor:

> Instructions to implement:
> 
> 
> 
> | OpType Name |  | Type | Syntax Binary Remark |  |  |
> | --- | --- | --- | --- | --- | --- |
> | Arithmetic | Add | R | add $d,$s,$t | 000000 sssss ttttt ddddd 00000 100000 |  |
> |  | Add unsigned | R | addu $d,$s,$t | 000000 sssss ttttt ddddd 00000 100001 |  |
> |  | Subtract | R | sub $d,$s,$t | 000000 sssss ttttt ddddd 00000 100010 |  |
> |  | Subtract unsigned | R | subu $d,$s,$t | 000000 sssss ttttt ddddd 00000 100011 |  |
> |  | Add immediate | I | addi $t,$s,C | 001000 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Add immediate unsigned | I | addiu $t,$s,C | 001001 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Multiply | R | mult $s,$t | 000000 sssss ttttt ddddd 00000 011000 | (HI,LO) = (64-bit) $s * $t |
> |  | Multiply unsigned | R | multu $s,$t | 000000 sssss ttttt ddddd 00000 011001 | (HI,LO) = (64-bit) $s * $t |
> |  | Divide | R | div $s,$t | 000000 sssss ttttt ddddd 00000 011010 | LO = $s / $t, HI = $s % $t |
> |  | Divide unsigned | R | divu $s,$t | 000000 sssss ttttt ddddd 00000 011011 | LO = $s / $t, HI = $s % $t |
> | Logical | And | R | and $d,$s,$t | 000000 sssss ttttt ddddd 00000 100100 |  |
> |  | And immediate | I | andi $t,$s,C | 001100 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Or | R | or $d,$s,$t | 000000 sssss ttttt ddddd 00000 100101 |  |
> |  | Or immediate | I | ori $t,$s,C | 001101 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Exclusive or | R | xor $d,$s,$t | 000000 sssss ttttt ddddd 00000 100110 |  |
> |  | Nor | R | nor $d,$s,$t | 000000 sssss ttttt ddddd 00000 100111 |  |
> |  | Set on less than | R | slt $d,$s,$t | 000000 sssss ttttt ddddd 00000 101010 |  |
> |  | Set on less than unsigned | R | sltu $d,$s,$t | 000000 sssss ttttt ddddd 00000 101011 |  |
> |  | Set on less than immediate | I | slti $t,$s,C | 001010 sssss ttttt CCCCC CCCCC CCCCCC |  |
> | Bitwise Shift | Shift left logical immediate | R | sll $d,$t,shamt | 000000 sssss ttttt ddddd 00000 000000 | $d = $t << shamt |
> |  | Shift right logical immediate | R | srl $d,$t,shamt | 000000 sssss ttttt ddddd 00000 000010 | $d = {16’b0, $t >> shamt} |
> |  | Shift right arithmetic immediate | R | sra $d,$t,shamt | 000000 sssss ttttt ddddd 00000 000011 | $d = {{16{t[31]}}, $t >> shamt} |
> |  | Shift left logical | R | sllv $d,$t,$s | 000000 sssss ttttt ddddd 00000 000100 | $d = $t << $s |
> |  | Shift right logical | R | srlv $d,$t,$s | 000000 sssss ttttt ddddd 00000 000110 | $d = {16’b0, $t >> $s} |
> |  | Shift right arithmetic | R | srav $d,$t,$s | 000000 sssss ttttt ddddd 00000 000111 | $d = {{16{t[31]}}, $t >> $s} |
> | Data Transfer | Load word | I | lw $t,C($s) | 100011 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Load halfword | I | lh $t,C($s) | 100001 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Load halfword unsigned | I | lhu $t,C($s) | 100101 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Load byte | I | lb $t,C($s) | 100000 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Load byte unsigned | I | lbu $t,C($s) | 100100 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Store word | I | sw $t,C($s) | 101011 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Store half | I | sh $t,C($s) | 101001 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Store byte | I | sb $t,C($s) | 101000 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Load upper immediate | I | lui $t,C | 001111 00000 ttttt CCCCC CCCCC CCCCCC |  |
> |  | Move from high | R | mfhi $d | 000000 00000 00000 ddddd 00000 010000 |  |
> |  | Move from low | R | mflo $d | 000000 00000 00000 ddddd 00000 010010 |  |
> | Conditional branch | Branch on equal | I | beq $s,$t,C | 000100 sssss ttttt CCCCC CCCCC CCCCCC |  |
> |  | Branch on not equal | I | bne $s,$t,C | 000101 sssss ttttt CCCCC CCCCC CCCCCC |  |
> | Unconditional jump | Jump | J | jC | 000010 CCCCC CCCCC CCCCC CCCCC CCCCCC | addr = {PC_plus_4[31:28], C << 2} |
> |  | Jump register | R | jr $s | 000000 sssss 00000 00000 00000 001000 |  |
> |  | Jump and link | J | jal C | 000011 CCCCC CCCCC CCCCC CCCCC CCCCCC | addr = {PC_plus_4[31:28], C << 2} |

In MIPS architecture, instructions can be executed using different approaches, with Single-Cycle and Pipelined being two primary methodologies. Each has distinct characteristics and performance implications. If time permits, I am also very interesting in reimplementing the MIPS CPU using a pipeline architecture instead of single-cycle. Here is a brief summary of what these two approaches are and their pros and cons:

> Single-Cycle vs Pipelined MIPS
> 
> 
> ### Single-Cycle MIPS:
> 
> **Definition**:
> 
> - In a Single-Cycle MIPS processor, each instruction is executed in one complete clock cycle. This means the processor completes all stages of instruction execution (Fetch, Decode, Execute, Memory access, and Write back) in one clock cycle before moving on to the next instruction.
> 
> **Characteristics**:
> 
> - **Simplicity**: The design is relatively simple and straightforward. It's easy to understand and implement, making it an excellent educational tool.
> - **Longer Clock Cycle**: To accommodate all stages of instruction execution in one cycle, the clock period must be long enough to fit the slowest instruction. This generally leads to a slower overall clock speed.
> - **Resource Underutilization**: Functional units like the ALU or memory are idle for most of the cycle, leading to inefficient resource utilization.
> 
> **Performance**:
> 
> - The performance is limited by the longest stage in the instruction execution. The entire processor must wait for the slowest operation to complete, which can significantly limit the clock speed and overall throughput.
> 
> ### Pipelined MIPS:
> 
> **Definition**:
> 
> - A Pipelined MIPS processor divides the instruction execution process into separate stages, with each stage completing a part of the instruction. As soon as one stage completes its task, it passes the instruction to the next stage and begins working on the next instruction. This process is akin to an assembly line.
> 
> **Characteristics**:
> 
> - **Increased Throughput**: Multiple instructions are processed simultaneously at different stages of the pipeline, significantly increasing instruction throughput.
> - **Complexity**: The design is more complex than a single-cycle processor, requiring mechanisms to handle hazards (situations where the next instruction depends on the result of the current one).
> - **Shorter Clock Cycle**: Each stage of the pipeline can be shorter, allowing for a faster clock rate and improved performance.
> 
> **Performance**:
> 
> - Pipelining can dramatically increase the number of instructions completed per unit time. However, its efficiency can be affected by pipeline stalls (delays) due to data hazards, control hazards, and structural hazards.
> 
> ### Key Differences:
> 
> 1. **Throughput**: Pipelining increases instruction throughput by processing multiple instructions simultaneously, whereas single-cycle processes one instruction per cycle.
> 2. **Clock Cycle**: Single-cycle MIPS has a longer clock cycle to accommodate the slowest stage, while pipelined MIPS has shorter cycles, leading to potentially higher clock speeds.
> 3. **Complexity**: Pipelined MIPS is more complex, requiring additional logic to handle various hazards and ensure correct operation.
> 4. **Resource Utilization**: Pipelining improves resource utilization by keeping most of the CPU's parts busy most of the time, unlike single-cycle where resources are under-utilized.
> 5. **Latency**: In a pipelined processor, the latency for a single instruction might be longer (as it passes through all pipeline stages), but the overall throughput is higher due to concurrent processing.
> 
> While Single-Cycle MIPS is simpler and easier to understand, it's not practical for high-performance systems due to its limited speed and poor resource utilization. Pipelined MIPS, despite its complexity, is widely used in practice as it offers significantly higher throughput and better performance, making it a **cornerstone** of modern CPU design.
> 

In addition to implementing simulated versions of a MIPS processor using code, we can also implement it using hardware components by designing each module in a circuit instead of simulating their behavior on a machine. We can experiment with clocks, simple memories, registers, adder circuits, and all the small logic gates that we have learned throughout the course. All these things come together behind the scenes in a Verilog but if we were to implement these with hardware and simple electronic parts, then we must implement every tiny detail in a module. It would be very cool to build a CPU using electronic components and wires on a breadboard like this one for example:

![[https://www.reddit.com/r/ElectricalEngineering/comments/14j0qwy/my_expanded_version_of_ben_eaters_8bit_breadboard/](https://www.reddit.com/r/ElectricalEngineering/comments/14j0qwy/my_expanded_version_of_ben_eaters_8bit_breadboard/)
A fully featured 8-bit CPU with memory, IO, and more!](Single%20Cycle%20MIPS%20CPU%20in%20Verilog%20(%E5%8D%95%E5%91%A8%E6%9C%9FCPU%E7%94%B5%E8%B7%AF%E8%AE%BE%E8%AE%A1)%209df84b1f9e8746149b309d32fa3933c4/Untitled%206.png)

[https://www.reddit.com/r/ElectricalEngineering/comments/14j0qwy/my_expanded_version_of_ben_eaters_8bit_breadboard/](https://www.reddit.com/r/ElectricalEngineering/comments/14j0qwy/my_expanded_version_of_ben_eaters_8bit_breadboard/)
A fully featured 8-bit CPU with memory, IO, and more!

A project of still scale may be too grand for now but I think starting small and slowly putting more and more knowledge and experience together, one day I will also be able to accomplish this. I hope I can implement my MIPS CPU using electronic components and breadboard one day in the future when I have time and this project has really sparked my interest in perusing more things in electrical engineering field as a software major because hardware and software goes hand in hand to create a working machine.

Programming and implementing a MIPS single-cycle CPU in Verilog offers a wealth of knowledge and experience, providing valuable insights into computer architecture, digital design, and the intricacies of hardware description languages. Here's an overview of the things I have taken away while doing this project and knowledge gained from running simulations:

### 1. **Understanding of Computer Architecture**:

- **Processor Design**: Learn the fundamental components of a CPU, including ALU, register file, control unit, and data paths.
- **Instruction Set Architecture (ISA)**: Gain a deep understanding of how instructions are decoded and executed, and how different types of instructions (arithmetic, logical, control flow) impact the hardware.
- **Execution Cycle**: Understand the steps involved in instruction fetching, decoding, execution, memory access, and write-back.

### 2. **Digital Logic and Circuit Design**:

- **Combinatorial and Sequential Logic**: Develop skills in designing and implementing both types of logic circuits, which are foundational in all digital hardware.
- **Timing and Synchronization**: Learn about clocking, synchronization, and the importance of timing in sequential circuits.
- **Resource Utilization**: Understand how to efficiently use hardware resources and the trade-offs involved in different design choices.

### 3. **Proficiency in Verilog**:

- **Hardware Description Language (HDL)**: Gain proficiency in Verilog, an industry-standard HDL, enhancing your ability to design and simulate complex digital systems.
- **Best Practices**: Learn best practices for coding in Verilog, including how to write clean, maintainable, and efficient code.
- **Simulation and Debugging**: Develop skills in simulating digital circuits, observing waveforms, and debugging based on simulation results.

### 4. **Problem-Solving and Debugging Skills**:

- **Troubleshooting**: Improve your ability to troubleshoot and debug complex systems by identifying and fixing issues in your MIPS implementation.
- **Critical Thinking**: Enhance your critical thinking and problem-solving skills as you figure out how to translate the MIPS architecture into an efficient hardware design.

### 5. **Systems Thinking**:

- **Big Picture Understanding**: Learn to understand and appreciate how individual components interact and come together to form a complete, functioning system.

### 6. **Real-World Application and Appreciation**:

- **Appreciation for Modern CPU Design**: Develop a greater appreciation for the complexity and sophistication of modern processors.
- **Foundation for Advanced Topics**: Lay a strong foundation for exploring more advanced topics in computer architecture in the future, such as pipelining, cache design, and multi-core systems.

Implementing a MIPS single-cycle CPU in Verilog is a comprehensive learning experience that touches upon various aspects of computer engineering. It's not just an academic exercise; the skills and understanding you develop are directly applicable to fields such as hardware design, system architecture, and more.