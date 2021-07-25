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

## Label:
- Tells the memory address
- Put anywhere in source file (code or data segments)
- Must not be numeric
- Case sensitive
- Ex: `label: ....`
  - `label: .asciz  "text"`
  -        `.equ  LABEL_LEN, . - label`   @ dot(.) is the current address; this line finds len(string) 

## Directives
- tell assembler directions on how to translate the file
- do not generate machine instructions
- but specify memory alignment, generate symbols, reserve space, initialize contents
- Ex: .align = aligns data/code to some specific memory boundary 

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
