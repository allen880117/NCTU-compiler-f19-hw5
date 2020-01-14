# ===========
# HEADER PART
# ===========
  .file   "fp.p"
  .option nopic


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

  lui  a5 , %hi(.LC1)
  flw  fa5, %lo(.LC1)(a5)
  fsw  fa5, -20(s0)         
  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main


  .section .rodata
  .align 2
.LC1:
  .float 3.500000

