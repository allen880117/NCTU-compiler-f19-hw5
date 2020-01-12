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
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -24(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  addw t2, t1, t0
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t2, 0(sp)  # 32BITS STACK PUSH STEP2
  addi t0, s0, -28
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  lw   t0, -28(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  j    L1
L1:

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
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  addi t0, s0, -20
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  li   t0, 6
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  addi t0, s0, -24
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  jal  ra, read
  la   t0, a
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   a0, 0(t0)
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t1, d
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, sum
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t0, a
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -24(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  addw t2, t1, t0
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t2, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t1, d
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mulw t2, t1, t0
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t2, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t0, a
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  li   t0, 40
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  bgt  t1, t0, L3
L2:
  la   t1, a
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  j    L4
L3:
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
L4:
L5:
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  li   t0, 8
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  bge  t1, t0, L6
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  li   t0, 1
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  addw t2, t1, t0
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t2, 0(sp)  # 32BITS STACK PUSH STEP2
  addi t0, s0, -20
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  j    L5
L6:

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

