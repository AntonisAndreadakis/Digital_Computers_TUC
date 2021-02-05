############################################################################
# EXAMPLE IF(...){...} 
#	    ELSE{....}
# Ask for an integer and if the value is greater than 100 then sub the value 
# of 80 else add the value of 60. Finally, print the new value.
############################################################################
# printf("Type an integer: ");
# scanf("%d",&x);
# if(x > 100)
# {
# 	x = x - 80;
# }
# else
# {
#	x = x + 60;
# }
# printf("The new value is: ");
# printf("%d\n",x);
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
			#Print the initial message
			li $v0,4
			la $a0, request
			syscall
		
			#Read the integer from the user
			li $v0,5
			syscall
	
			#Copy the integer from the register v0 to the register t0
			move $t0, $v0;

			#load the value of condition on a register
			li $t1, 100	
				
			#check if the value $t0 > 100
			ble $t0,$t1,else_code

if_code:			
			#sub the value of 80
			addi $t0, $t0, -80
			
			j end_condition		

else_code:
			#add the value of 60
			addi $t0, $t0, 60

end_condition:
			#Print the message for the new value
			li $v0,4
			la $a0, result
			syscall
			
			#Print the value of integer
			li $v0, 1
			move $a0, $t0
			syscall
			
			#Print the new line
			li $v0,4
			la $a0, newline
			syscall

			#Exit the program			
			li $v0,10
			syscall	
			
			

	