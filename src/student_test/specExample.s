;==================================================
  ;_HEADER_PART_
;==================================================
  .file   "specExample.p"
  .option nopic

;_GLOBAL_VARIABLE_
.bss
a:
  .word 0

;_GLOBAL_CONSTANT_
.bss
d:
  .word 4

;==================================================
  ;_MAIN_/_FUNCTION_
;==================================================
.text
  .align  2
  .global sum
  .type   sum, @function

sum:

  ;_STACKING_
  addi sp, sp, -64
  sd   ra, 56(sp) ; ra is 8bytes(64bits)
  sd   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi s0, sp, 64 

  sw   a0, -20(s0)  ;PARAM
  sw   a1, -24(s0)  ;PARAM
  ;_VARIABLE_REFERENCE_: a
  lw   t1, -20(s0)

  ;_VARIABLE_REFERENCE_: b
  lw   t0, -24(s0)

  addw t1, t1, t0  ;_BINARY_OP

  ;_VARIABLE_REFERENCE_: c  ;_give_addr
  addi t0, s0, -28

  sw   t1, 0(t0)  ;_assignment

  ;_VARIABLE_REFERENCE_: c
  lw   t0, -28(s0)

  mv   a0, t0  ;_return_

  ;_UNSTACKING_
  ld   ra, 56(sp) ; ra is 8bytes(64bits)
  ld   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi sp, sp, 64
  jr   ra        
  .size sum, .-sum

;==================================================
  ;_MAIN_/_FUNCTION_
;==================================================
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

  li   t1, 4  ;_constant_value

  ;_VARIABLE_REFERENCE_: b  ;_give_addr
  addi t0, s0, -20

  sw   t1, 0(t0)  ;_assignment

  li   t1, 6  ;_constant_value

  ;_VARIABLE_REFERENCE_: c  ;_give_addr
  addi t0, s0, -24

  sw   t1, 0(t0)  ;_assignment

  ;_VARIABLE_REFERENCE_: a  ;_give_addr
  la   t0, a

  jal  ra, read  ; call function 'read'
  sw   a0, 0(t0) ; save the return value to 'a'

  ;_VARIABLE_REFERENCE_: a
  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

  ;_VARIABLE_REFERENCE_: b
  lw   t0, -20(s0)

  mv   a0, t0
  ;_VARIABLE_REFERENCE_: d
  la   t0, d
  lw   t0, 0(t0)

  mv   a1, t0
  jal  ra, sum
  mv   t1, a0
  ;_VARIABLE_REFERENCE_: a  ;_give_addr
  la   t0, a

  sw   t1, 0(t0)  ;_assignment

  ;_VARIABLE_REFERENCE_: a
  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

  ;_VARIABLE_REFERENCE_: b
  lw   t1, -20(s0)

  ;_VARIABLE_REFERENCE_: c
  lw   t0, -24(s0)

  addw t1, t1, t0  ;_BINARY_OP

  ;_VARIABLE_REFERENCE_: d
  la   t0, d
  lw   t0, 0(t0)

  mulw t1, t1, t0  ;_BINARY_OP

  ;_VARIABLE_REFERENCE_: a  ;_give_addr
  la   t0, a

  sw   t1, 0(t0)  ;_assignment

  ;_VARIABLE_REFERENCE_: a
  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

  ;_VARIABLE_REFERENCE_: a
  la   t1, a
  lw   t1, 0(t1)

  li   t0, 40  ;_constant_value

  bgt  t1, t0, L2  ;_BINARY_OP

L1:
  ;_VARIABLE_REFERENCE_: a
  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

  j    L3
L2:
  ;_VARIABLE_REFERENCE_: b
  lw   t0, -20(s0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

L3:
L4:
  ;_VARIABLE_REFERENCE_: b
  lw   t1, -20(s0)

  li   t0, 8  ;_constant_value

  bge  t1, t0, L5  ;_BINARY_OP

  ;_VARIABLE_REFERENCE_: b
  lw   t0, -20(s0)

  mv   a0, t0    ; copy value from 't0' to 'a0'
  jal  ra, print ; call function 'print'

  ;_VARIABLE_REFERENCE_: b
  lw   t1, -20(s0)

  li   t0, 1  ;_constant_value

  addw t1, t1, t0  ;_BINARY_OP

  ;_VARIABLE_REFERENCE_: b  ;_give_addr
  addi t0, s0, -20

  sw   t1, 0(t0)  ;_assignment

  j    L4
L5:

  ;_UNSTACKING_
  ld   ra, 56(sp) ; ra is 8bytes(64bits)
  ld   s0, 48(sp) ; s0 is 8bytes(64bits)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

