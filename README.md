# Learn ARM-Assembly
(CSE 30, Summer 1/2021, Professor Cao, UCSD)

## Register names
- __temp reg__: 
  - r0-r3: function arguments and return value; r0 = func(r0, r1, r2, r3)
  - r12 used by C dynamically linked library
- __preserved regs__: r4-10: safe for function calls; r7 = used for passing syscal #
- __special use regs__:
  - r11 = fp = frame pointer
  - r13 = sp = stk pointer
  - r14 = lr = linked reg
  - r15 = pc = program counter

## Source.s
- Except for .arch, .cpu, .syntax, others are optional
  - .extern: import name to use locally
  - .equ something, value
  - .end: things after .end are ignored (optional, recommended)
  - .bss: global zero fill memory (names, sizes, alignment)
  - .data: global specified initialized memory (names, sizes, alignment)
  - .section .rodata: global initialized read only memeory (names, sizes, alignment)
  - .text: function export, program entry

---------------------------------------------------------------
## Label:
- Tell the memory address
- Put anywhere in source file (code or data segments)
- Must not be numeric
- Case sensitive
- Ex: `label: ....`
  - `label: .asciz  "text" `
  -        `.equ  LABEL_LEN, . - label`   @ dot(.) is the current address; this line finds len(string) 

## Directives
- tell assembler directions on how to translate the file
- do not generate machine instructions
- but specify memory alignment, generate symbols, reserve space, initialize contents
- Ex: .align = aligns data/code to some specific memory boundary 

## .align
- slide 5, last pg
- Note: 1 byte = 8 bits, half-word = 2 bytes = 16 bits, word = 4 bytes = 32 bits
- `.align 1`
  - for 2^1 = 2 bytes
  - ex: `label: .hword value` @ hword = half-word, 2-byte short int, `short label = value`;
- `.align 2` 
  - for 2^2 = 4 bytes, ex: `label: .word value` @ means int label = value; or `label: .single value` @ means float label
  - for arrays: skip address forward, ex: `label: .skip 400` @ means int label[100], 100 * 4 = 400 bytes
- `.align 3`
  - for 2^3 = 8 bytes
  - ex: `label: .quad value` @ means long long label = 0L; 8-byte long
  - ex: `label: .double value` @ double label; 8-byte double float
- other cases without .align:
  - `label: .asciz "text"` @ means char label[] = "text";
  - `label: .byte 'A', 0x41, 0` @ means char label[] = {'A', 'A', 0};
  - `label: .skip 1`, skip 1 byte
 
## Function call:
-  `bl function_name`
  - bl = branch with link  
  - save the memory address of the following instruction (after the func call) into lr
- r0 = func(r0, r1, r2, r3)
  - each param <= 4 bytes; if > 4 byte ==> pass a pointer to the param 

## Return after func call:
- `bx lr`
  - bx = branch and exchange 

## Save/Restore preserved regs:
- `push {reg list}`
  - push from high to low memory (i.e. if `push {r4-r8, fp, lr}`, then r4 is at lower memory than lr
- `pop {reg list}`
  - pop from low to high memory
- Pop and push lists should have the same increasing order (r_i then fp, lr at last)
- Top of stack: push -(#regs * 4); pop +(#regs * 4)
- len(reg list) % 2 == 0 (for now)

## FP_OFFSET:
- locate fp from sp
  -  (1) __set__ fp at bottom of the stack frame so we have a fixed point to later locate stack data
  -  (2) __restore__ sp to the address where we do push{} so that regs will be restored in the correct values
- `.equ FP_OFFSET, num`
  - Where "num" = #regs saved * 4 - 4 = (#regs saved - 1) * 4 (b/c we don't include lr)
    - Ex: #regs saved = 9 ==> num = 9 * 4 - 4 = 32 
- Beginning: `add fp, sp, FP_OFFSET`   @ fp = sp + FP_OFFSET
- At end: `sub sp, fp, FP_OFFSET`      @ sp = fp - FP_OFFSET

## Branching:
- Do not branch to a func
- `b label`
- Singed: `beq` (brached if ==), `bne` (!=), `bgt` (>), `bge` (>=), `blt` (<), `ble` (<=)
- Unsigned: `beq` (branched if ==), `bne` (!=), `bhi` (>), `bhs` (>=), `blo` (<), `bls` (<=)
- Nearest label branches: "xb" or "xf" (slide 6, pg. 26)
  - x = a number (~label)
  - b = backward (preceding the branch instruction) 
  - f = forward (following the branch instruction)
  - Ex: `1f`: go to the nearest label "1" after the instruction that uses it
  - Ex: `1b`: go back to the nearest label "1" before the instruction that uses it
  - should not reuse the number ("x") to avoid confusion
  
## Compare:
- `cmp reg, #imm8` @ #imm8 is a const in [-256, 255]; ex: `cmp r3, 0`
- `cmp reg1, reg2`; ex: `cmp r3, r4`

## Load/Store instructions:
- `ldr dest, source` (slide 6, pg. 34)
  - Note: source could be [Rbase{,#+/- imm12}], where #imm12:= const in [-2048, 2047] 
    -  `ldr r1, =label`     @ x = &label
    -  `ldr r1, [fp, -4]`   @ x = * (fp - 4 bytes)
    -  `ldr r1, =label+4`   @ x = &(label) + 4 bytes
    -  `ldr r1, [r0, r2]`   @ x = * (r0 + r2)
  - More: `ldrb` (load a byte/char (by default, char in ARM is unsigned), `ldrh` (load a half-word = 16 bits), `ldr` (load a word = 32 bits) 
- `str source, dest` (slide 6, pg. 35)
    -  `str r1, =label`     @ * label = r1
    -  `str r1, [fp, -4]`   @ * (fp - 4 bytes) = r1
    -  `str r1, =label+4`   @ x = &(label + 4 bytes) = r1
    -  `str r1, [r0, r2]`   @ * (r0 + r2) = r1
-------------------------------------------------------------------
## Flags:
- N (negative; MSB == '1')
- Z (zero result)
- C (carry out from the shifter is '1'; addition result > 2^32; subtraction result ? 0)
- V (overflow caused by instruction)

## Machine Code
- encoded in 0s, 1s

## Assembly Language: 
- Symbolic version of machine language
- Line oriented
- Organized into columns (source file)
- All arm instructions: 32-bit long, 4-byte aligeed, lower 2 bits of address are 00

## Assembly Process
- 2 passes (slide 5, pg.31)
  - 1st: assign memory addr to label
  - 2nd: convert assembly instructions, data def --> binary
