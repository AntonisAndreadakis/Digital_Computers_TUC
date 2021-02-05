############################################################################
# EXAMPLE while
############################################################################
# scanf("%d",&x);
# scanf("%d",&step);
# sum = 0;
# while(x < 100)
# {
#	sum = sum + x;	
# 	x = x + step;
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
			
			#($t0 = x)
			move $t0, $v0

			#Ask the second integer
			li $v0,4
			la $a0, request
			syscall
		
			#Read the integer from the user
			li $v0,5
			syscall
			
			#($t1 = step)
			move $t1, $v0
			
			#($t2 = sum = 0)
			li $t2, 0

			#load the value $t3 = 100 
			li $t3, 100

loop:
			bge $t0, $t3, end_loop
			
			#sum = sum + x
			add $t2,$t2,$t0
		
			#x = x + step
			add $t0, $t0, $t1
			
			j loop

end_loop:
			#Print the message for the new value
			li $v0,4
			la $a0, result
			syscall
			
			#Print the value of integer
			li $v0, 1
			move $a0, $t2
			syscall
			
			#Print the new line
			li $v0,4
			la $a0, newline
			syscall

			#Exit the program			
			li $v0,10
			syscall	
			
			

	