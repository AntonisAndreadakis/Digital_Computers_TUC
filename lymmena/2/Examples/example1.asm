########################################################
# EXAMPLE : Variable Declaration and Table addressing
########################################################
#void main()
#{
#	int x = 6;
#	int y = 9;
#	int array[2] = {7,8};
#	int table[2][2];
#
#	table[0][0] = x;
#	table[0][1] = y;
#	table[1][0] = array[0] + x;
#	table[1][1] = array[1] + y;
#	printf("%d\n%d\n%d\n%d\n",table[0][0],table[0][1],table[1][0],table[1][1]);
#}
##########################################################	
	.data
newline: .asciiz "\n"
	
x:	.word 6
y:	.word 9
	
	.align 2
array:
	.word 7,8
	
	.align 2
table:
	.space 16	

	.text	
main:
	
	la $t0, x		# $t0 = &x
	lw $t1,0($t0)	# $t1 = x
	
	la $t2, table	# $t2 = &table[0][0]
	sw $t1,0($t2)	# table[0][0] = x
	
	la $t3, y		# $t3 = &y
	lw $t4,0($t3)	# $t4 = y
	
	sw $t4,4($t2)	# table[0][1] = y

	la $t0, array	# $t0 = &array[0]
	lw $t5,0($t0)	# $t5 = array[0]
	
	add $t5,$t5,$t1	# $t5 = array[0] + x
	sw $t5,8($t2)	# table[1][0] = array[0] + x

	lw $t5,4($t0)	# $t5 = array[1]
	add $t5,$t5,$t4	# $t5 = array[1] + y
	
	sw $t5,12($t2)	# table[1][1] = array[0] + x

	li $v0,1		#printf table[0][0]
	lw $a0,0($t2)	#$a0 = table[0][0]
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall
	
	li $v0,1		#printf table[0][1]
	lw $a0,4($t2)	#$a0 = table[0][1]
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1		#printf table[1][0]
	lw $a0,8($t2)	#$a0 = table[1][0]
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall

	li $v0,1		#printf table[1][1]
	lw $a0,12($t2)	#$a0 = table[1][1]
	syscall

	li $v0,4		#print a newline	
	la $a0, newline
	syscall
	
	li $v0, 10
	syscall