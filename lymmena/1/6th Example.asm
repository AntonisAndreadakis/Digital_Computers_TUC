############################################################################
# EXAMPLE combination for, if
############################################################################
# scanf("%d",&step_down);
# scanf("%d",&step_up);
# sum = 0;
# for(v = 0; v < 20; v++)
# {
#	if(sum >= 0 && sum < 100)
#	{
#		sum = sum + step_up;	
#	}
#	else
#	{
#		sum = sum - step_down;	
#	}
# }
# printf("The new value is: ");
# printf("%d\n",sum);
############################################################################

			.data

			.globl request
			.globl result

request:  		.asciiz "Type an integer : "
result:  		.asciiz "The new value is : "
newline:		.asciiz "\n"

			.text
			.globl main

main:   
			#Ask the first integer
			li $v0,4
			la $a0, request
			syscall
		
			#Read the integer from the user
			li $v0,5
			syscall
			
			#($t0 = step_up)
			move $t0, $v0

			#Ask the second integer
			li $v0,4
			la $a0, request
			syscall
		
			#Read the integer from the user
			li $v0,5
			syscall
			
			#($t1 = step_down)
			move $t1, $v0
			
			#$t4 = sum
			li $t4, 0
			
			#$t5 = 100
			li $t5, 100
			
			#load the initial value of the loop ($t2 = v)
			li $t2, 0	
			
			#load the upper value of the loop ($t3 = 20)
			li $t3, 20	
			
loop:	
			#v < 20
			bge $t2,$t3,end_loop
			
			#sum >= 0
			blt $t4,$0,else_code
			
			#sum < 0
			bge $t4,$t5,else_code
			
			#sum = sum + step_up
			add $t4, $t4, $t0
			j end_condition
			

else_code:		
			#sum = sum - step_down
			sub $t4,$t4,$t1

end_condition:
			
			#v++
			addi $t2,$t2,1			
			j loop
end_loop:
			#Print the message for the new value
			li $v0,4
			la $a0, result
			syscall
			
			#Print the value of integer
			li $v0, 1
			move $a0, $t4
			syscall
			
			#Print the new line
			li $v0,4
			la $a0, newline
			syscall

			#Exit the program			
			li $v0,10
			syscall			