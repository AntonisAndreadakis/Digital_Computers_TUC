########################################################
# EXAMPLE1 : Fibonacci Numbers with recursion 
########################################################
#void main()
#{	int x = 9;
#	int return_value = fibo(x);
#	printf("The returned value is: %d\n",returned_value);
#}
#int fibo(int x)
#{
#	if(n <= 2)
#		return(1);
#	else
#		return(fib(n-1) + fib(n-2));
#}
##########################################################	
	.data
string: .asciiz "The result is:\n"
	
	.text	
main:
	
	li $t0, 4			#the fourth fibonacci number
	
	move $a0, $t0		#give the number as an argument
	jal fibo

	move $t7, $v0		#take the resulted value
	
	li $v0,4			#print string	
	la $a0, string
	syscall
	
	li $v0,1			#printf the final value
	move $a0,$t7		#
	syscall
	
	li $v0,10			#Exit
	syscall

fibo: 
	addi $sp,$sp,-12	#make space for three numbers the ra, the s0 which actually is the a0 and the s1
	sw $ra,0($sp)		#which actually is the returned value of the first function
	sw $s0,4($sp)
	sw $s1,8($sp)

	add $s0,$a0,$zero	#$s0 = $a0
	
	li $t0, 1				#load the value of 2
	bne $a0, $t0, else_0	#n == 1
	li $v0, 1				#return(1)
	j return_fibo
	
else_0:
	bne $a0, $0, else		#n == 0
	li $v0, 0				#return(0)
	j return_fibo
	
else:
	addi $a0, $s0, -1	#n-1
	jal fibo			#fib(n-1)
	
	move $s1, $v0		#the result of the first recursion put it to the s1 and store it
	
	addi $a0, $s0, -2	#fib(n-2)
	jal fibo
	
	add $v0, $s0, $v0	# return(fib(n-2) + fib(n-1))

return_fibo:
	lw $s1,8($sp)       #read registers from stack
	lw $s0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,12
	jr $ra