.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
		li t0, 1									# t0 = 1
		addi t1, zero, -1					# t1 = -1
		mv t3, zero
		mv t4, zero
		mv t5, zero
		mv t6, zero
		bge a1, t0, loop_start		# if (a1 >= 1) goto loop_start
		li a0, 36									# else ra = 36
		j exit										# exit()
		
loop_start:
		addi t1, t1, 1						# t1 = t1 + 1
		bge t1, a1, loop_end			# if (t1 >= a1) goto loop_end
		bge t5, t3, loop_continue
		mv t5, t3
		mv t6, t4
loop_continue:
		# t3 and t4 are used to store the value and the index
		slli t0, t1, 2						# t0 = t1 * 4
		add t2, a0, t0						# t2 = ptr + t1 * 4
		lw t3, 0(t2)							# t3 = *t2
		mv t4, t1									# t4 = t1

		j loop_start		

loop_end:
    # Epilogue
        mv a0, t6
    jr ra
