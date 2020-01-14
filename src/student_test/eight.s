# ===========
# HEADER PART
# ===========
  .file   "eight.p"
  .option nopic


# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global fun
  .type   fun, @function

fun:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  lw   t1 , 80(s0)            # param_save_to_local: stack load
  sw   t1 , -20(s0)           # param_save_to_local: save
  lw   t1 , 72(s0)            # param_save_to_local: stack load
  sw   t1 , -24(s0)           # param_save_to_local: save
  lw   t1 , 64(s0)            # param_save_to_local: stack load
  sw   t1 , -28(s0)           # param_save_to_local: save
  lw   t1 , 56(s0)            # param_save_to_local: stack load
  sw   t1 , -32(s0)           # param_save_to_local: save
  lw   t1 , 48(s0)            # param_save_to_local: stack load
  sw   t1 , -36(s0)           # param_save_to_local: save
  lw   t1 , 40(s0)            # param_save_to_local: stack load
  sw   t1 , -40(s0)           # param_save_to_local: save
  lw   t1 , 32(s0)            # param_save_to_local: stack load
  sw   t1 , -44(s0)           # param_save_to_local: save
  lw   t1 , 24(s0)            # param_save_to_local: stack load
  sw   t1 , -48(s0)           # param_save_to_local: save
  lw   t1 , 16(s0)            # param_save_to_local: stack load
  sw   t1 , -52(s0)           # param_save_to_local: save
  lw   t1 , 8(s0)             # param_save_to_local: stack load
  sw   t1 , -56(s0)           # param_save_to_local: save
  lw   t1 , 0(s0)             # param_save_to_local: stack load
  sw   t1 , -60(s0)           # param_save_to_local: save
# READ
# GIVE THE ADDRESS
  addi t0 , s0     , -64      # var_ref: give address
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  jal  ra, read_real  # read: jump to read_real
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  fsw  fa0, 0(t0)  # read: move ret_val to var_ref
# READ END
# GIVE THE VALUE
  lw   t0 , -64(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  fmv.w.x fa0, t0                # print: move param to fa0
  jal  ra , print_real           # print: jump to print_real
# PRINT END
# GIVE THE VALUE
  lw   t0 , -20(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -24(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -32(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
# GIVE THE VALUE
  lw   t0 , -20(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -24(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -32(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -36(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -40(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -44(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -48(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -52(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -56(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -60(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addw t2 , t1     , t0       # binary_op: arithmatic expression
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L1                     # return: jump to unstacking
L1:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size fun, .-fun


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

  # function_call: move param, over-eight
  li   t0 , 11                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 10                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 9                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 8                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 7                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 6                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 5                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 4                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  jal  ra , fun               # function_call: jump to function
  addi sp , sp     , 88       # pop_param
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  addi t0 , s0     , -20      # var_ref: give address
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  lw   t0 , -20(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

