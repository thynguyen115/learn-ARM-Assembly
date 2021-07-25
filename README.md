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

## Label:
- Tells the memory address
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
  - push from high to low memory
- `pop {reg list}`
  - pop from low to high memory  

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
