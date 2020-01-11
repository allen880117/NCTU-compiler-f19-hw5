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
  lw   t1, -20(s0)

  lw   t0, -24(s0)

  addw t1, t1, t0

  addi t0, s0, -28

  sw   t1, 0(t0)

  lw   t0, -28(s0)

  mv   a0, t0


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

  li   t1, 4

  addi t0, s0, -20

  sw   t1, 0(t0)

  li   t1, 6

  addi t0, s0, -24

  sw   t1, 0(t0)

  la   t0, a

  jal  ra, read
  sw   a0, 0(t0)

  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0
  jal  ra, print

  lw   t0, -20(s0)

  mv   a0, t0
  la   t0, d
  lw   t0, 0(t0)

  mv   a1, t0
  jal  ra, sum
  mv   t1, a0
  la   t0, a

  sw   t1, 0(t0)

  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0
  jal  ra, print

  lw   t1, -20(s0)

  lw   t0, -24(s0)

  addw t1, t1, t0

  la   t0, d
  lw   t0, 0(t0)

  mulw t1, t1, t0

  la   t0, a

  sw   t1, 0(t0)

  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0
  jal  ra, print

  la   t1, a
  lw   t1, 0(t1)

  li   t0, 40

  bgt  t1, t0, L2

L1:
  la   t0, a
  lw   t0, 0(t0)

  mv   a0, t0
  jal  ra, print

  j    L3
L2:
  lw   t0, -20(s0)

  mv   a0, t0
  jal  ra, print

L3:
L4:
  lw   t1, -20(s0)

  li   t0, 8

  bge  t1, t0, L5

  lw   t0, -20(s0)

  mv   a0, t0
  jal  ra, print

  lw   t1, -20(s0)

  li   t0, 1

  addw t1, t1, t0

  addi t0, s0, -20

  sw   t1, 0(t0)

  j    L4
L5:

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

