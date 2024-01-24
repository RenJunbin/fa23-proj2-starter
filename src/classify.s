.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
.data
.align 4
m0_0: .word -1
.align 4
m0_1: .word -1
.align 4
m1_0: .word -1
.align 4
m1_1: .word -1
.align 4
m2_0: .word -1
.align 4
m2_1: .word -1
.align 4
m3_0: .word -1
.align 4
m3_1: .word -1

.text
classify:
    ebreak
    addi sp, sp, -24
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s5, 4(sp)
    sw s6, 0(sp)

    li t0, 5
    blt a0, t0, error_argc
    
    lw s0, 0(a1)
    lw s1, 4(a1)
    lw s2, 8(a1)

    lw s5, 12(a1)
    mv s6, a2

    # Read pretrained m0
    mv a0, s0
    la a1, m0_0     # row
    la a2, m0_1     # col
    jal read_matrix
    mv s0, a0

    # Read pretrained m1
    mv a0, s1
    la a1, m1_0     # row
    la a2, m1_1     # col
    jal read_matrix
    mv s1, a0

    # Read input matrix
    mv a0, s2
    la a1, m2_0     # row
    la a2, m2_1     # col
    jal read_matrix
    mv s2, a0

    # Compute h = matmul(m0, input)     (m0_row, m3_col)
    lw t0, m0_0
    lw t1, m2_1

    mul a0, t0, t1
    mv s3, a0
    slli a0, a0, 2

    jal malloc

    mv s4, a0
    beq a0, zero, error_malloc

    mv a0, s0
    lw a1, m0_0
    lw a2, m1_0

    mv a3, s2
    lw a4, m1_0
    lw a5, m1_1

    mv a6, s4

    jal matmul    

    # Compute h = relu(h)

    mv a0, a6
    mv a1, s3
    jal relu


    # Compute o = matmul(m1, h)     (m1_row, m3_col)
    lw t0, m1_0
    lw t1, m2_1

    mul a0, t0, t1
    mv s3, a0
    slli a0, a0, 2

    jal malloc

    mv s4, a0
    li t0, 0
    beq a0, t0, error_malloc

    mv a0, s0
    lw a1, m0_0
    lw a2, m1_0

    mv a3, s2
    lw a4, m1_0
    lw a5, m1_1

    mv a6, s4

    jal matmul     


    # Write output matrix o
    mv a0, s5
    mv a1, a6
    lw a2, m1_0
    lw a3, m2_1

    jal write_matrix

    # Compute and return argmax(o)
    mv a0, s4
    mv a1, s3

    jal argmax

    # If enabled, print argmax(o) and newline
    li t0, 1
    bne s6, t0, 1f
    jal print_int
    li a0, '\n'
    jal print_char
1:
    lw s0, 20(sp)
    lw s1, 16(sp)
    lw s2, 12(sp)
    lw s3, 8(sp)
    lw s5, 4(sp)
    lw s6, 0(sp)
    
    addi sp, sp, 20
    jr ra

error_argc:
    li a0, 31
    j exit

error_malloc:
    li a0, 26
    j exit