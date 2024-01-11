.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    ebreak
    # Prologue
		li t0, 1
		bge a2, t0, c0
		li a0, 36
		j exit
c0:
		blt a3, t0, c2
		blt a4, t0, c2
		j init
c2:
		li a0, 37
		j exit
init:
		li t0, -1
		mv t1, zero
		mv t2, zero
		mv t3, zero
		mv t4, zero
loop_start:
		addi t0, t0, 1				# t0 is loop index, t0 is 0 initially.
		bge t0, a2, loop_end		# if (t0 >= a2) goto loop_end
loop_continue:
	# load a0[t0 * a3 * 4] and a1[t0 * a4 * 4] to t1, t2
		mul t1, t0, a3
		slli t1, t1, 2
		mul t2, t0, a4
		slli t2, t2, 2

		add a0, a0, t1
		add a1, a1, t2
		lw t1, 0(a0)
		lw t2, 0(a1)

	# t3 = t1 * t2
		mul t3, t1, t2
	# t4 = t4 + t3
		add t4, t4, t3

		j loop_start
loop_end:

	mv a0, t4
    # Epilogue


    jr ra
