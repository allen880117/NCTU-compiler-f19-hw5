   .file   "specExample.p"
   .option nopic

.bss
a:
  .word 0

.bss
d:
  .word 4

.text
  .align  2
  .global main
  .type   main, @function

main:
  addi sp, sp, -64
  sd   ra, 56(sp) ; ra is 8bytes(64bits)
  sd   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi s0, sp, 64 

  ld   ra, 56(sp) ; ra is 8bytes(64bits)
  ld   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi sp, sp, 64
  jr   ra        

  .size main, .-main

