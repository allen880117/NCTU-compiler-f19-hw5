  .file   "function.p"
  .option nopic

.bss
gv:
  .word 0

.text
gc:
  .word 2

.text
  .align  2
  .global product
  .type   product, @function

product:

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
  mulw t2, t1, t0
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
  mv   a0, t0

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size product, .-product

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
  mv   a0, t0

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size sum, .-sum

.text
  .align  2
  .global dot
  .type   dot, @function

dot:

  addi sp, sp, -64
  sd   ra, 56(sp)
  sd   s0, 48(sp)
  addi s0, sp, 64 

  sw   a0, -20(s0)
  sw   a1, -24(s0)
  sw   a2, -28(s0)
  sw   a3, -32(s0)
  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  lw   t0, -24(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, product
  addi sp, sp, -4
  sw   a0, 0(sp)
  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  lw   t0, -28(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  lw   t0, -32(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, product
  addi sp, sp, -4
  sw   a0, 0(sp)
  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, sum
  addi sp, sp, -4
  sw   a0, 0(sp)
  addi t0, s0, -36
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  lw   t0, -36(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0

  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size dot, .-dot

.text
  .align  2
  .global main
  .type   main, @function

main:

  addi sp, sp, -64
  sd   ra, 56(sp)
  sd   s0, 48(sp)
  addi s0, sp, 64 

  li  t0, 2
  sw  t0, -24(s0)

  li   t0, 2
  addi sp, sp, -4
  sw   t0, 0(sp)

  la   t0, gv
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  li   t0, 2
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

  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  la   t1, gc
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, product
  addi sp, sp, -4
  sw   a0, 0(sp)
  la   t0, gv
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  lw   t0, -24(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  jal  ra, product
  addi sp, sp, -4
  sw   a0, 0(sp)
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

  la   t1, gv
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
  jal  ra, print

  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0
  la   t1, gc
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a1, t0
  lw   t0, -20(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a2, t0
  lw   t0, -24(s0)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a3, t0
  jal  ra, dot
  addi sp, sp, -4
  sw   a0, 0(sp)
  la   t0, gv
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  lw   t1, 0(sp)
  addi sp, sp, 4
  sw   t1, 0(t0)

  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4
  sw   t0, 0(sp)

  lw   t0, 0(sp)
  addi sp, sp, 4
  mv   a0, t0   
  jal  ra, print


  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  jr   ra        
  .size main, .-main

