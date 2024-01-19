.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue

call_fopen:
    addi sp, sp, -20
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw ra, 12(sp)
    
    addi a1, zero, 1
    call fopen

    mv t0, a0
    
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    bge a0, zero, first_call_fwrite
    li a0, 27
    j exit

first_call_fwrite:
    addi sp, sp, -24
    sw a2, 0(sp)
    sw a3, 4(sp)
    sw ra, 8(sp)
    sw t0, 12(sp)
    sw a1, 16(sp)

    mv a1, sp
    li a2, 2
    li a3, 4
    mv t1, a2
    sw t1, 20(sp)

    call fwrite

    lw a2, 0(sp)
    lw a3, 4(sp)
    lw ra, 8(sp)
    lw t0, 12(sp)
    lw a1, 16(sp)
    lw t1, 20(sp)
    addi sp, sp, 24

    beq a0, t1, call_fflush
    li a0, 30
    j exit

call_fflush:
    addi sp, sp, -20
    sw a2, 0(sp)
    sw a3, 4(sp)
    sw ra, 8(sp)
    sw a1, 12(sp)
    sw t0, 16(sp)

    mv a0, t0
    call fflush

    lw a2, 0(sp)
    lw a3, 4(sp)
    lw ra, 8(sp)
    lw a1, 12(sp)
    lw t0, 16(sp)
    addi sp, sp, 20
    beq a0, zero, next_call_fwrite

next_call_fwrite:
    addi sp, sp, -20
    sw a2, 0(sp)
    sw a3, 4(sp)
    sw ra, 8(sp)
    sw a1, 12(sp)
    
    mv a0, t0
    mul a2, a2, a3
    slli a2, a2, 2
    mv t1, a2
    sw t1, 16(sp)
    li a3, 4
    call fwrite

    lw a2, 0(sp)
    lw a3, 4(sp)
    lw ra, 8(sp)
    lw a1, 12(sp)
    lw t1, 16(sp)
    addi sp, sp, 20

    beq a0, t1, next_call_fflush
    li a0, 30
    j exit

next_call_fflush:
    addi sp, sp, -20
    sw a2, 0(sp)
    sw a3, 4(sp)
    sw ra, 8(sp)
    sw a1, 12(sp)
    sw t0, 16(sp)

    mv a0, t0
    call fflush

    lw a2, 0(sp)
    lw a3, 4(sp)
    lw ra, 8(sp)
    lw a1, 12(sp)
    lw t0, 16(sp)
    addi sp, sp, 20
    beq a0, zero, call_fclose

call_fclose:
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

    jr ra

fopen_error:
    li a0, 27
    j exit

fwrite_error:
    li a0, 30
    j exit

wclose_error:
    li a0, 28
    j exit