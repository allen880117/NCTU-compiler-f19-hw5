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
  bnez t0 , L4     
  li   t1 , 1      
  j    L5 
L4:
  li   t1 , 0      
  j    L5 
L5:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L2                # if: jump to else
L1:
  li   t0 , 32                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L3                     # if: jump to end
L2:
  li   t0 , 33                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L3:
# GIVE THE VALUE
  la   t1 , gd                # var_ref: load address
  lw   t0 , 0(t1)             # var_ref: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L9     
  li   t1 , 1      
  j    L10
L9:
  li   t1 , 0      
  j    L10
L10:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L7                # if: jump to else
L6:
  li   t0 , 22                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L8                     # if: jump to end
L7:
  li   t0 , 121               # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L8:
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
  beqz  t0 , L17    
  j   L16
L16:
  beqz  t1 , L19    
  j   L18
L18:
  li   t2 , 1      
  j    L14
L17:
L19:
  li   t2 , 0      
  j    L14
L14:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  bnez t0 , L20    
  li   t1 , 1      
  j    L21
L20:
  li   t1 , 0      
  j    L21
L21:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t1 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L12               # if: jump to else
L11:
  li   t0 , 55                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L13                    # if: jump to end
L12:
  li   t0 , 21                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L13:
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
  beqz  t0 , L28    
  j   L27
L28:
  beqz  t1 , L30    
  j   L29
L30:
  li   t2 , 0      
  j    L25
L27:
L29:
  li   t2 , 1      
  j    L25
L25:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L23               # if: jump to else
L22:
  li   t0 , 56                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L24                    # if: jump to end
L23:
  li   t0 , 17                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
L24:
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
  beqz  t0 , L37    
  j   L36
L36:
  beqz  t1 , L39    
  j   L38
L38:
  li   t2 , 1      
  j    L34
L37:
L39:
  li   t2 , 0      
  j    L34
L34:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L32               # if: jump to else
L31:
  li   t0 , 77                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L33                    # if: jump to end
L32:
L33:
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
  beqz  t0 , L46    
  j   L45
L45:
  beqz  t1 , L48    
  j   L47
L47:
  li   t2 , 1      
  j    L43
L46:
L48:
  li   t2 , 0      
  j    L43
L43:
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t2 , 0(sp)             # ____8bytes stack push 2
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  beqz t0 , L41               # if: jump to else
L40:
  li   t0 , 78                # constant_value: give value
  addi sp , sp     , -8       # ____8bytes stack push 1
  sw   t0 , 0(sp)             # ____8bytes stack push 2
# PRINT
  lw   t0 , 0(sp)             # ____stack top
  addi sp , sp     , 8        # ____8bytes stack pop
  mv   a0 , t0                # print: move param to a0
  jal  ra , print             # print: jump to print
# PRINT END
  j    L42                    # if: jump to end
L41:
L42:

  ld   ra, 56(sp)  # UNSTACKING: LOAD ra
  ld   s0, 48(sp)  # UNSTACKING: LOAD s0
  addi sp, sp, 64  # UNSTACKING: POP
  jr   ra          # UNSTACKING: JUMP ra
  .size main, .-main

