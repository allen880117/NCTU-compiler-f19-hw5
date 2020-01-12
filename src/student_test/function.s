# ===========
# HEADER PART
# ===========
  .file   "function.p"
  .option nopic


# GLOBAL VARIABLE
.bss
gv:
  .word 0

# GLOBAL CONSTANT
.text
gc:
  .word 2

# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global product
  .type   product, @function

product:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sw   a0, -20(s0)  # __param_save_to_local
  sw   a1, -24(s0)  # __param_save_to_local
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
  mulw t2, t1, t0
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

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size product, .-product


# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global sum
  .type   sum, @function

sum:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sw   a0, -20(s0)  # __param_save_to_local
  sw   a1, -24(s0)  # __param_save_to_local
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
  j    L2
L2:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size sum, .-sum


# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global dot
  .type   dot, @function

dot:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sw   a0, -20(s0)  # __param_save_to_local
  sw   a1, -24(s0)  # __param_save_to_local
  sw   a2, -28(s0)  # __param_save_to_local
  sw   a3, -32(s0)  # __param_save_to_local
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -24(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, product
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -28(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -32(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, product
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, sum
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  addi t0, s0, -36
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  lw   t0, -36(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  j    L3
L3:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size dot, .-dot


# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global main
  .type   main, @function

main:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  li   t0, 2  # __local constant: load immediate
  sw   t0, -24(s0)  # __local_constant: save immediate
  li   t0, 2
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t0, gv
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  li   t0, 2
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
  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t1, gc
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, product
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t0, gv
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -24(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, product
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
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
  la   t1, gv
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
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print
  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t1, gc
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -20(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, -24(s0)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a3, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a2, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a1, t0
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0
  jal  ra, dot
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   a0, 0(sp)  # 32BITS STACK PUSH STEP2
  la   t0, gv
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  lw   t1, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  sw   t1, 0(t0)
  la   t1, gv
  lw   t0, 0(t1)
  addi sp, sp, -4 # 32BITS STACK PUSH STEP1
  sw   t0, 0(sp)  # 32BITS STACK PUSH STEP2
  lw   t0, 0(sp)  # 32BITS STACK TOP
  addi sp, sp, 4  # 32BITS STACK POP
  mv   a0, t0   
  jal  ra, print

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

