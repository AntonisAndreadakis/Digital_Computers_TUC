############################################################################
# EXAMPLE for(){...} 
############################################################################
# sum = 0;
# for(x = 10; x < 200; x++)
# {
#	a = x - 3;	
# 	sum = sum + a;
# }
# printf("The new value is: ");
# printf("%d\n",sum);
############################################################################

			.data

			.globl result

result:  		.asciiz "The new value is : "
newline:		.asciiz "\n"

			.text
			.globl main

main:   
			#register $t1 is the variable sum
			li $t1, 0

			#load the initial value of the loop ($t0 = x)
			li $t0, 10			
			
			#load the value of 200
			li $t2, 200
loop:			
			#check if the condition is true
			bge $t0, $t2, end_loop
			
			#calculate the value a ($t3 = a)
			addi $t3, $t0, -3
			
			#sum = sum + a;
			add $t1, $t1, $t3

			#x++
			addi $t0, $t0, 1
			j loop

end_loop:
			#Print the message for the new value
			li $v0,4
			la $a0, result
			syscall
			
			#Print the value of integer
			li $v0, 1
			move $a0, $t1
			syscall
			
			#Print the new line
			li $v0,4
			la $a0, newline
			syscall

			#Exit the program			
			li $v0,10
			syscall	
			
			

	