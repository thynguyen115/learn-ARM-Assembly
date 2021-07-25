@ Describe hardware to the assembler
   .arch    armv6             @ armv6 instruction set
   .cpu     cortex-a53        @ cpu type
   .syntax  unified           @ allow modern syntax
@ Imports/Exports: Define external funcs, magic numbers
   .extern  printf
   .global  main
   
   .equ     FP_OFFSET, 4      @ stack frame setup
   .equ     EXIT_SUCCESS, 0   @ return 0 if success
   
