.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)

call_fopen:
    addi sp, sp, -4
    sw ra, 0(sp)
    li a1, 0
    call fopen
    lw ra, 0(sp)
    addi sp, sp, 4
    mv t0, a0       # t0 equals to the file descriptor
    bge a0, zero, call_malloc
    li a0, 27
    j exit

call_malloc:
    li a0, 8
    addi sp, sp, -4
    sw ra, 0(sp)
    call malloc
    lw ra, 0(sp)
    addi sp, sp, 4
    li t1, 1
    mv t2, a0       # t2 equals to the pointer
    bge a0, t1, call_fread
    li a0, 26
    j exit

call_fread:
    mv a0, t0
    mv a1, t2   # t2-> [3, 3]
    li a2, 8
    addi sp, sp, -8
    sw a2, 4(sp)
    sw ra, 0(sp)
    call fread
    lw a2, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8

    mv t3, a0
    beq t3, a2, call_next_malloc
    li a0, 29
    j exit

call_next_malloc:
    lw a0, 0(t2)
    lw a1, 4(t2)
    mul a0, a0, a1
    slli a0, a0, 2    # a0 indicates how many bytes will be read
    mv t3, a0           # move a0 to t3
    addi sp, sp, -8
    sw t3, 4(sp)
    sw ra, 0(sp)
    call malloc
    lw ra, 0(sp)
    lw t3, 4(sp)
    addi sp, sp, 8
    li t1, 1
    mv t5, a0       # t5 is the pointer
    bge a0, t1, call_next_fread
    li a0, 26
    j exit

call_next_fread:
    mv a0, t0   # t0 is the file descriptor
    mv a1, t5   # t5 -> buffer[]
    mv a2, t3   # how many bytes will be read
    addi sp, sp, -8
    sw a2, 4(sp)
    sw ra, 0(sp)
    call fread
    lw a2, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8

    mv t3, a0
    beq t3, a2, call_next_fclose
    li a0, 29
    j exit

call_next_fclose:
    mv a0, t0
    addi sp, sp, -4
    sw ra, 0(sp)
    call fclose
    lw ra, 0(sp)
    addi sp, sp, 4

    beq a0, zero, _end
    li a0, 28
    j exit    
_end:
    # Epilogue
    lw a0, 8(sp)
    lw a1, 4(sp)
    lw a2, 0(sp)
    addi sp, sp, 12

    lw t4, 0(t2)
    lw t6, 4(t2)
    sw t4, 0(a1)
    sw t6, 0(a2)

    mv a0, t5
    jr ra

