# ===========
# HEADER PART
# ===========
  .file   "bool.p"
  .option nopic


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
  .global main
  .type   main, @function

main:

  addi sp, sp, -64 # STACKING: PUSH APPEND
  sd   ra, 56(sp)  # STACKING: SAVE ra
  sd   s0, 48(sp)  # STACKING: SAVE s0
  addi s0, sp, 64  # STACKING: MOVE s0

  li   t0 , 1                 # local constant: load immediate
  sw   t0 , -28(s0)           # local_constant: save immediate
  li   t0 , 0                 # local constant: load immediate
  sw   t0 , -32(s0)           # local_constant: save immediate
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
  bnez t0 , L8     
  li   t1 , 1      
  j    L9 
L8:
  li   t1 , 0      
  j    L9 
L9:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L6                # if: jump to else
L5:
  li   t0 , 32                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L7                     # if: jump to end
L6:
  li   t0 , 33                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L7:
# GIVE THE VALUE
  la   t1 , gd                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L13    
  li   t1 , 1      
  j    L14
L13:
  li   t1 , 0      
  j    L14
L14:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L11               # if: jump to else
L10:
  li   t0 , 22                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L12                    # if: jump to end
L11:
  li   t0 , 121               # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L12:
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
  beqz  t0 , L21    
  j   L20
L20:
  beqz  t1 , L23    
  j   L22
L22:
  li   t2 , 1      
  j    L18
L21:
L23:
  li   t2 , 0      
  j    L18
L18:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L24    
  li   t1 , 1      
  j    L25
L24:
  li   t1 , 0      
  j    L25
L25:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L16               # if: jump to else
L15:
  li   t0 , 55                # constant_value: give value
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
  li   t0 , 21                # constant_value: give value
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
# GIVE THE VALUE
  la   t1 , jj                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L32    
  j   L31
L32:
  beqz  t1 , L34    
  j   L33
L34:
  li   t2 , 0      
  j    L29
L31:
L33:
  li   t2 , 1      
  j    L29
L29:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L27               # if: jump to else
L26:
  li   t0 , 56                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L28                    # if: jump to end
L27:
  li   t0 , 17                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L28:
  li   t0 , 1                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
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
  li   t0 , 0                 # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# GIVE THE ADDRESS
  addi t0 , s0     , -24      # var_ref: give address
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
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  lw   t1 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz  t0 , L41    
  j   L40
L40:
  beqz  t1 , L43    
  j   L42
L42:
  li   t2 , 1      
  j    L38
L41:
L43:
  li   t2 , 0      
  j    L38
L38:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L36               # if: jump to else
L35:
  li   t0 , 77                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L37                    # if: jump to end
L36:
L37:
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
  beqz  t0 , L50    
  j   L49
L49:
  beqz  t1 , L52    
  j   L51
L51:
  li   t2 , 1      
  j    L47
L50:
L52:
  li   t2 , 0      
  j    L47
L47:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L45               # if: jump to else
L44:
  li   t0 , 78                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L46                    # if: jump to end
L45:
L46:
# GIVE THE VALUE
  lw   t0 , -28(s0)           # var_ref: give value
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
  lw   t0 , -32(s0)           # var_ref: give value
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

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

