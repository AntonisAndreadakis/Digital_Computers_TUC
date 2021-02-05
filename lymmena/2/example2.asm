########################################################
# EXAMPLE : Tables multiplication
########################################################
#void main()
#{
#	int a[3][3] = {{1,2,3},{4,5,6},{7,8,9}};
#	int b[3][3] = {{10,11,12},{13,14,15},{16,17,18}};
#	int result[3][3];
#	sum_table(&a[0][0], &b[0][0], &result[0][0], 3, 3);
#	printf("%d",result[0][0]);
#}
#void sum_table(int **a, int **b, int **result, int x, int y)
#{
#	int number = 0;	
#	int i, j;
#	for(i = 0; i < x; i++)
#	{	
#		for(j = 0; j < x; j++)
#		{	
#			number = 0;
#			for(k = 0; k < y; k++)
#			{
#				number = number + a[i][k]*b[k][j];
#			}
#			result[i][j] = number;
#		}
#	}	
#}
##########################################################	
	.data
newline: .asciiz "\n"

a_table:	.word 1,2,3,4,5,6,7,8,9
b_table:	.word 10,11,12,13,14,15,16,17,18
		.align 2

result:
	.space 36	

	.text	
	.globl main
main:
	la $a0, a_table	#$a0 = &a_table[0][0]
	la $a1, b_table	#$a1 = &b_table[0][0]
	la $a2, result	#$a2 = &result[0][0]
	li $a3, 3		#$a3 = x = 3
	li $s0, 3		#$s0 = y = 3
	li $s1, 4
	jal sum_table
	
	li $v0,1
	lw $a0,0($a2)
	syscall
	
	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,4($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,8($a2)
	syscall
	
	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,12($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,16($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,20($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,24($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,28($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1
	lw $a0,32($a2)
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0, 10
	syscall
	
sum_table:
	
	
	move $t0, $a0	#$t0 = &a_table[0][0]
	move $t1, $a1	#$t1 = &b_table[0][0]
	move $t2, $a2	#$t2 = &result[0][0]
	move $t3, $a3	#$t3 = x and $s0 = y
	
	li $t4, 0		#$t4 = number 
	li $t5, 0		#$t5 = i
	li $t6, 0		#$t6 = j 
	li $t7, 0		#$t7 = k
	
loop_i:	
	
	bge $t5, $t3, end_loop_i	# i < x
	li $t6, 0				#j = 0

loop_j:
	bge $t6, $t3, end_loop_j	# j < x
	li $t4, 0				#number = 0 	
	li $t7, 0				#k = 0

loop_k:	
	bge $t7,$s0, end_loop_k		# k < y
	
	mul $t8, $t5, $s0			#
	add $t8, $t8, $t7			#$t8 = i*y + k
	mul $t8, $t8, $s1			#$t8 = 4 bytes * $t8
	add $t8, $t8, $t0			#$t8 -> &a[i][k]
	lw	$t8,0($t8)			#$t8 = a[i][k]
	
	mul $t9, $t7, $t3			#
	add $t9, $t9, $t6			#$t9 = k*x + j
	mul $t9, $t9, $s1			#$t8 = 4 bytes * $t8
	add $t9, $t9, $t1			#$t9 -> &b[k][j]
	lw $t9,0($t9)			#$t9 = b[k][j]
	
	mul $t8, $t8, $t9			# $t8 = a_table[i][k]*b_table[k][j]
	add $t4,$t4,$t8			#number = number + $t8
	addi $t7,$t7,1			#k++
	j loop_k

end_loop_k:
	
	mul  $t8, $t5, $t3		#
	add  $t8, $t8, $t6		#$t8 = i*x+j
	mul $t8, $t8, $s1			#$t8 = 4 bytes * $t8
	add  $t8, $t8, $t2		#$t8 -> &result[i][j]
	sw   $t4,0($t8)			#result[i][j] = number
	addi $t6,$t6,1			#j++
	j loop_j

end_loop_j:
	addi $t5,$t5,1			#i++
	j loop_i

end_loop_i:
	jr $ra
	
	