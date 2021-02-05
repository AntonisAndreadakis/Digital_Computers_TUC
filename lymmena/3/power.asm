########################################################
# EXAMPLE1 : Power(x,y) = x^y
########################################################
#void main()
#{	int x = 9;
#	int n = 10;
#	int return_value = power(x, n);
#	printf("The returned value is: %d\n",returned_value);
#}
#int power(int x, int n)
#{
#	if(n == 0)
#		return(1);
#	else
#		return(x*power(x,n-1));
#}
##########################################################	
	.data
string: .asciiz "The result is:\n"
	
	.text	
main:
	
	li $t0, 3			#$t0 = x
	li $t1, 2			#$t1 = n
	move $a0, $t0		#move the values as arguments of the function
	move $a1, $t1
	jal power			#call the function

	move $t2, $v0		#$t2 = final_result
	
	li $v0,4			#print string	
	la $a0, string
	syscall
	
	li $v0,1			#printf the final value
	move $a0,$t2		#
	syscall
	
	li $v0,10			#Exit
	syscall
	

power: 
	addi $sp,$sp,-12	#make space in the stack for 3 values
	sw $ra, 8($sp)		#store the values of $ra and the two arguments
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	
	
	bne $a1, $0, else	#n == 0
	li $v0, 1			#return(1)
	addi $sp, $sp, 12	#delete the final space froma the stack as the recursion stops
	j return_power		#go to the epilogue of the function
	
else:
	addi $a1, $a1, -1	#give as a new argument to the function the value n-1 
	jal power			#call power recursively
	
	lw $a0, 0($sp)		#when you return you should load the values of the specific call of the function 
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12   #free the space from the stack
	
	mul $v0, $v0, $a0	#result = x * power(x,n-1)
						#the value of the power(x,n-1) is returned at the $v0 register
						#the result is put in the $v0 register because it will be returned to the previous call 
return_power:
	jr $ra				#jump to the previous call
	
	