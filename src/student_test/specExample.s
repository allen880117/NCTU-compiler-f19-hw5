  .file   "specExample.p"
  .option nopic

.bss
a:
  .word 0

.text
d:
  .word 4

.text
  .align  2
  .global sum
  .type   sum, @function

sum:

  addi sp, sp, -64
  sd   ra, 56(sp)
  sd   s0, 48(sp)
  addi s0, sp, 64 

  sw   a0, -20(s0)
  sw   a1, -24(s0)
  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, -24(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  addw t2, t1, t0
  addi sp, sp, -4
  sw   t2, 0(sp)


  addi t0, s0, -28
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  lw   t0, -28(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0  ;_return_

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size sum, .-sum

.text
  .align  2
  .global main
  .type   main, @function

main:

  addi sp, sp, -64
  sd   ra, 56(sp)
  sd   s0, 48(sp)
  addi s0, sp, 64 

  li   t0, 4
  addi sp, sp, -4
  sw   t0, 0(sp)

  addi t0, s0, -20
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  li   t0, 6
  addi sp, sp, -4
  sw   t0, 0(sp)

  addi t0, s0, -24
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  jal  ra, read
  la   t0, a
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  sw   a0, 0(t0)

  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  la   t1, d
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, sum
  addi sp, sp, -4
  sw   a0, 0(sp)
  la   t0, a
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, -24(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  addw t2, t1, t0
  addi sp, sp, -4
  sw   t2, 0(sp)


  la   t1, d
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  mulw t2, t1, t0
  addi sp, sp, -4
  sw   t2, 0(sp)


  la   t0, a
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  li   t0, 40
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  bgt  t1, t0, L2


L1:
  j    L3
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

L2:
  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

L3:
L4:
  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  li   t0, 8
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  bge  t1, t0, L5


  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print

  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  li   t0, 1
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  addw t2, t1, t0
  addi sp, sp, -4
  sw   t2, 0(sp)


  addi t0, s0, -20
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  j    L4
L5:

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

