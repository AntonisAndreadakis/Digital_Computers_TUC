##################################################################################
#Addition of two tables
#################################################################################
#int A[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
#int B[3][3] = {11, 12, 13, 14, 15, 16, 17, 18, 19};
#int C[3][3];
#main()
#{
#	addition(&A[0][0], &B[0][0], &C[0][0]);
#	//print the result	
#}
#void addition(int **A, int **B, int **C)
#{
#	int i, j;
#	for(i = 0; i < 3; i++)
#	{
#		for(j = 0; j < 3; j++)
#		{
#			C[i][j] = A[i][j] + B[i][j];
#		}
#	}
####################################################################################



.data

A : .word 1 2 3 4 5 6 7 8 9
B : .word 11 12 13 14 15 16 17 18 19
C : .space 36
spac: .asciiz " "
.text

main : 
		la $a0, A
		la $a1, B
		la $a2, C
		jal addition
		
		la $t0, C
		li $t1, 0

###################PRIINT RESULTS########################
loop:	
		bge $t1, 9, end_loop
		lw $t2, 0($t0)
		move $a0, $t2
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, spac
		syscall
		addi $t0, $t0, 4
		addi $t1, $t1, 1
		j  loop
#############################################################
end_loop:
		li $v0, 10
		syscall
		
addition:
		
		li $t0, 0	#i
		li $t3, 3	#number of columns
		li $t5, 3	
		li $t6, 4
		
loop_for1 :	bge $t0, $t3, end_for1
			
			li $t1, 0	#j = 0
loop_for2 : bge $t1, $t3, end_for2
			
			mul $t4, $t0, $t5		# x * columns
			add $t4, $t4, $t1		# x * columns + y
			mul $t4, $t4, $t6		# (x * columns + y) * 4
			add $t7, $t4, $a0		# $t7 = initial_address + (x * columns + y) * 4 = address A[x][y]
			lw $s0, 0($t7)			# $s0 = A[x][y]
			
			add $t8, $t4, $a1		# $t8 = address B[x][y]
			lw $s1, 0($t8)			# $s1 = B[x][y]
			
			add $s0, $s0, $s1		# $s0 = A[x][y] + B[x][y]
			add $t9, $t4, $a2		# $t9 = address C[x][y]
			
			sw $s0, 0($t9)			# C[x][y] = A[x][y] + B[x][y]
			
			addi $t1, $t1, 1		#j++
			j loop_for2
end_for2:
			addi $t0, $t0, 1		#i++
			j loop_for1
end_for1:
			jr $ra
			
			
