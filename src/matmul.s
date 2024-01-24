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
		
		j init
ret38:
		li a0, 38
		j exit
    # Prologue

init:
		addi sp, sp, -36
		sw s7, 32(sp)
		sw s6, 28(sp)
		sw s5, 24(sp)
		sw s4, 20(sp)
		sw s3, 16(sp)
		sw s2, 12(sp)
		sw s1, 8(sp)
		sw s0, 4(sp)
		sw sp, 0(sp)

		mv s1, zero				# i = 0
outer_loop_start:
		bge s1, a1, ret		# if (i >= a1) goto ret
		mul s0, s1, a2
		slli s0, s0, 2
		add s0, s0, a0
		mv s5, zero
inner_loop_start:
		bge s5, a5, outer_loop_end	# if (j >= a5) goto outer_loop_end

		mul s6, s1, a5
		add s6, s6, s5
		slli s6, s6, 2
		add s6, s6, a6
		slli s7, s5, 2
		add s3, a3, s7
call_dot:
		addi sp, sp, -32
		sw a6, 28(sp)
		sw a5, 24(sp)
		sw a4, 20(sp)
		sw a3, 16(sp)
		sw a2, 12(sp)
		sw a1, 8(sp)
		sw a0, 4(sp)
		sw ra, 0(sp)

		mv a0, s0
		mv a1, s3
		li a3, 1
		mv a4, a5

		jal dot

	  mv t6, a0

		lw ra, 0(sp)    
	  lw a0, 4(sp)    
	  lw a1, 8(sp)    
	  lw a2, 12(sp)    
	  lw a3, 16(sp)    
	  lw a4, 20(sp)    
	  lw a5, 24(sp)    
	  lw a6, 28(sp)

		addi sp, sp, 32    
		
		sw t6, 0(s6)
inner_loop_end:
		addi s5, s5, 1
		j inner_loop_start
outer_loop_end:
		addi s1, s1, 1
		j outer_loop_start

    # Epilogue
ret:
		lw sp, 0(sp)
	  lw s0, 4(sp)   
	  lw s1, 8(sp)  
	  lw s2, 12(sp) 
	  lw s3, 16(sp) 
	  lw s4, 20(sp) 
	  lw s5, 24(sp) 
	  lw s6, 28(sp)
	  lw s7, 32(sp)
	addi sp, sp, 36
		
		jr ra