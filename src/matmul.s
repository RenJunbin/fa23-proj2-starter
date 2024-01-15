.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
		li t0, 1
		blt a1, t0, ret38
		blt a2, t0, ret38

		blt a4, t0, ret38
		blt a5, t0, ret38

		bne a2, a4, ret38
		
		j outer_loop_start
ret38:
		li a0, 38
		j exit
    # Prologue
outer_loop_start:
		addi sp, sp, -32
		sw a6, 28(sp)
		sw a5, 24(sp)
		sw a4, 20(sp)
		sw a3, 16(sp)
		sw a2, 12(sp)
		sw a1, 8(sp)
		sw a0, 4(sp)
		sw ra, 0(sp)

		addi a0, a0, 0
		mv a1, a3
		addi a2, a2, 0
		li a3, 1
		li a4, 1
		call dot
inner_loop_start:
		










inner_loop_end:




outer_loop_end:


    # Epilogue


    jr ra
