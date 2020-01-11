  ;_HEADER_PART_
  .file   "variableConstant.p"
  .option nopic

;_GLOBAL_VARIABLE_
.bss
gv:
  .word 0

;_GLOBAL_CONSTANT_
.bss
gc:
  .word 2

;_MAIN_/_FUNCTION_
.text
  .align  2
  .global main
  .type   main, @function

main:
  ;_STACKING_
  addi sp, sp, -64
  sd   ra, 56(sp) ; ra is 8bytes(64bits)
  sd   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi s0, sp, 64 

  ;_LOCAL_CONSTANT_
  li  t0, 4
  sw  t0, -24(s0)

  ;_UNSTACKING_
  ld   ra, 56(sp) ; ra is 8bytes(64bits)
  ld   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

