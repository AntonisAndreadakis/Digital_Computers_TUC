########################################################
# EXAMPLE2 : Reverse String with recursion
########################################################
#void main()
#{	char str[100] = {'t','e','s','t','\n'};
#	char reverse_str[100];
#	char *point;
#	point = &x[0];
#	rev_point = &reverse_str[0]; 
#	reverse(point, rev_point);
#	
#}
#int reverse(char *ptr, char *rev_ptr)
#{
#	if(*ptr != '\n')
#		reverse(ptr++);
#	*rev_ptr = *ptr;
#	rev_ptr++; 
#}
##########################################################	
	.data
string: .space 100
reverse_str: .space 100
	.text	
main:
	
	la $a0, string		#$a0 = &string[0]
	li $v0, 8			#read string
	syscall
	
	la $a1, reverse_str	#rev_point = &reverse_str[0]
	jal reverse
	
	li $t1, 10
	sb $t1, 0($a1)
	
	la $a0, reverse_str
	li $v0,4
	syscall
	
	li $v0 ,10
	syscall
	
	
reverse:
	addi $sp,$sp,-8		#make space in the stack for 2 values
	sw $ra, 4($sp)		#store the values of $ra and the $a0
	sw $a0, 0($sp)
	
	li $t1, 10
	lb $t0, 0($a0)		#if(*ptr != '\n')
	beq $t0, $t1, end_if#
	
	addi $a0,$a0,1		#ptr++
	jal reverse
	
	lw $a0, 0($sp)		#when you return you should load the values of the specific call of the function 
	lw $ra, 4($sp)

end_if:
	addi $sp, $sp, 8	#free stack space
	lb $t0, 0($a0)		#*rev_ptr = *ptr;
	sb $t0, 0($a1)		#
	addi $a1, $a1, 1	#rev_ptr++; 
	jr $ra