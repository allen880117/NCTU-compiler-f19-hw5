# ===========
# HEADER PART
# ===========
  .file   "bool.p"
  .option nopic


# GLOBAL VARIABLE ARRAY
.bss
gar:
  .word 0
  .word 0
.align 2

# GLOBAL VARIABLE
.bss
gd:
  .word 0
.align 2

# GLOBAL CONSTANT
.text
jj:
  .word 1
.align 2

# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global botest
  .type   botest, @function

botest:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sw   a0 , -20(s0)           # param_save_to_local
# GIVE THE VALUE
  lw   t0 , -20(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L3                # if: jump to else
L2:
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L1                     # return: jump to unstacking
  j    L4                     # if: jump to end
L3:
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L1                     # return: jump to unstacking
L4:
L1:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size botest, .-botest


# ===============
# MAIN / FUNCTION
# ===============
.text
  .align  2
  .global arrtest
  .type   arrtest, @function

arrtest:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  sd   a0 , -24(s0)           # param_save_to_local
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  ld   t0 , -24(s0)           # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , 0        # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
  li   t0 , 0                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  ld   t0 , -24(s0)           # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , 0        # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: arrray, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  ld   t0 , -24(s0)           # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , 0        # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  lw   t0 , 0(t0)             # var_ref: arrray, give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L12    
  j   L11
L11:
  beqz  t1 , L14    
  j   L13
L13:
  li   t2 , 1      
  j    L9 
L12:
L14:
  li   t2 , 0      
  j    L9 
L9:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L7                # if: jump to else
L6:
  li   t0 , 1719              # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L5                     # return: jump to unstacking
  j    L8                     # if: jump to end
L7:
  li   t0 , 1555              # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # return: move ret_val
  j    L5                     # return: jump to unstacking
L8:
L5:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size arrtest, .-arrtest


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

  li   t0 , 1                 # local constant: load immediate
  sw   t0 , -36(s0)           # local_constant: save immediate
  li   t0 , 0                 # local constant: load immediate
  sw   t0 , -40(s0)           # local_constant: save immediate
  li   t0 , 0                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gd                # var_ref: give address
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  la   t1 , jj                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L18    
  li   t1 , 1      
  j    L19
L18:
  li   t1 , 0      
  j    L19
L19:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L16               # if: jump to else
L15:
  li   t0 , 32                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L17                    # if: jump to end
L16:
  li   t0 , 33                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L17:
# GIVE THE VALUE
  la   t1 , gd                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L23    
  li   t1 , 1      
  j    L24
L23:
  li   t1 , 0      
  j    L24
L24:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L21               # if: jump to else
L20:
  li   t0 , 22                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L22                    # if: jump to end
L21:
  li   t0 , 121               # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L22:
# GIVE THE VALUE
  la   t1 , gd                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t1 , jj                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L31    
  j   L30
L30:
  beqz  t1 , L33    
  j   L32
L32:
  li   t2 , 1      
  j    L28
L31:
L33:
  li   t2 , 0      
  j    L28
L28:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L34    
  li   t1 , 1      
  j    L35
L34:
  li   t1 , 0      
  j    L35
L35:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L26               # if: jump to else
L25:
  li   t0 , 55                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L27                    # if: jump to end
L26:
  li   t0 , 21                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L27:
# GIVE THE VALUE
  la   t1 , gd                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t1 , jj                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L42    
  j   L41
L42:
  beqz  t1 , L44    
  j   L43
L44:
  li   t2 , 0      
  j    L39
L41:
L43:
  li   t2 , 1      
  j    L39
L39:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L37               # if: jump to else
L36:
  li   t0 , 56                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L38                    # if: jump to end
L37:
  li   t0 , 17                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L38:
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  addi t0 , s0     , -28      # var_ref: give address
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
  li   t0 , 0                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  addi t0 , s0     , -32      # var_ref: give address
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -36(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L51    
  j   L50
L50:
  beqz  t1 , L53    
  j   L52
L52:
  li   t2 , 1      
  j    L48
L51:
L53:
  li   t2 , 0      
  j    L48
L48:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L46               # if: jump to else
L45:
  li   t0 , 77                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L47                    # if: jump to end
L46:
L47:
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  lw   t0 , -32(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L60    
  j   L59
L59:
  beqz  t1 , L62    
  j   L61
L61:
  li   t2 , 1      
  j    L57
L60:
L62:
  li   t2 , 0      
  j    L57
L57:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L55               # if: jump to else
L54:
  li   t0 , 78                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L56                    # if: jump to end
L55:
L56:
# GIVE THE VALUE
  lw   t0 , -36(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # function_call: move param
  jal  ra , botest            # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
# GIVE THE VALUE
  lw   t0 , -40(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # function_call: move param
  jal  ra , botest            # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
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
# ASSIGNMENT
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
  jal  ra , arrtest           # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gar               # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  la   t0 , gar               # var_ref: get array base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # function_call: move param
  jal  ra , arrtest           # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  li   t0 , 0                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  li   t0 , 2                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  la   t0 , gar               # var_ref: get array base
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  addi t1 , t1     , -2       # var_ref: minus dimension lower bound
  li   t2 , 4                 # var_ref: get dimension width
  mulw t1 , t1     , t2       # var_ref: calculate offset
  addw t0 , t0     , t1       # var_ref: add offset to base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# ASSIGNMENT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  sw   t1 , 0(t0)             # assign
# GIVE THE VALUE
  la   t0 , gar               # var_ref: get array base
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # function_call: move param
  jal  ra , arrtest           # function_call: jump to function
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   a0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  li   t0 , 4                 # constant_value: give value
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
  beqz t0 , L64               # if: jump to else
L63:
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L65                    # if: jump to end
L64:
L65:
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE VALUE
  la   t0 , gar               # var_ref: get array base
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
  bnez t0 , L69    
  li   t1 , 1      
  j    L70
L69:
  li   t1 , 0      
  j    L70
L70:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L67               # if: jump to else
L66:
  li   t0 , 3                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L68                    # if: jump to end
L67:
L68:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

