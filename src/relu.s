.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0, zero, 1
    bge a1, t0, loop_start
    li a0, 36
    j loop_end
loop_start:
    addi a1, a1, -1
    blt a1, zero, loop_end
loop_continue:
    slli t0, a1, 2
    add t3, a0, t0
    lw t1, 0(t3)
    bge t1, zero, loop_start
    sw zero, 0(t3)
    j loop_start
    

loop_end:


    # Epilogue


    jr ra
