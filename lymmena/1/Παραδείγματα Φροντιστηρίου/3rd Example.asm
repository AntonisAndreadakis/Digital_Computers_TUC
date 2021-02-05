############################################################################
# EXAMPLE IF(complicated condition){...} 
############################################################################
# printf("Type an integer: ");
# scanf("%d",&x);
# if(x <= 100 && x >= 0)
# {
# 	x = x + 80;
# }
# if(x > 130 ||  x < -1)
# {
#	x = x - 60;
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
	
			#Copy the integer from the register $v0 to the register $t0
			move $t0, $v0;

			#load the value of condition on a register
			li $t1, 100
			li $t2, 0	
				
			#check if the value $t0 <= 100
			bgt $t0,$t1,end_condition1

			#check if the value $t0 >= 0
			blt $t0, $t2, end_conition1
condition1:
			#add the value of 80
			addi $t0, $t0, 80
			
end_condition1:
			#load the values 130 and -1 to the registers
			li $t3, 130
			li $t4, -1

first_subcondition:
			
			#check the first sub-condition x > 130
			ble $t0, $t3, second_subcondition
			j condition_body

second_subcondition:
			#check the second sub-condition x < -1
			bge $t0, $t4, end_condition2

condition2_body:
			#sub the value of -60
			addi $t0, $t0, -60

end_condition2:						
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
			
			

	