# ===========
# HEADER PART
# ===========
  .file   "Array.p"
  .option nopic


# GLOBAL VARIABLE ARRAY
.bss
gd:
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
.align 2

# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global gg
  .type   gg, @function

gg:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sd   a0 , -24(s0)           # param_save_to_local
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: array, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  ld   t0 , -24(s0)           # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  ld   t0 , -24(s0)           # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: arrray, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L1                     # return: jump to unstacking
L1:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size gg, .-gg


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

  jal  ra, read  # read: jump to read
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  addi t0 , s0     , -24      # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -3       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   a0, 0(t0)  # read: move ret_val to var_ref
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  addi t0 , s0     , -24      # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -3       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: arrray, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
  li   t0 , 7                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
  li   t0 , 8                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
  li   t0 , 9                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 4                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  addi t0 , s0     , -24      # var_ref: get array base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # function_call: move param
  jal  ra , gg                # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: array, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: array, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
  li   t0 , 4                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t0 , gd                # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -1       # var_ref: minus dimension lower bound
  li   t2 , 12                # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: array, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

