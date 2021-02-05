.data
.globl main
.globl Print_String
.globl Read_String
.globl Write_ch
.globl Read_ch
.globl UpperConv
.globl string

mess:    .asciiz "Please give the string: "
mes:	 .asciiz "Converted to: "
newline: .asciiz "\n"

string:  .align 2
	     .space 80      

.text

main:
	
	la $a0, mess						# mess is the first string to be printed
	jal Print_String					# go to Print_String funcion
	
	la $a0, string						# load the address of string[80] array to the $a0
	jal Read_String						# go to Read_String funcion
	
	la $a0, string						# load the new string - argument
	
	la $a0,newline
	jal Print_String
	
	la $a0, mes							# mess is the first string to be printed
	jal Print_String					# go to Print_String funcion
	
	la $a0, string						# load the address of string[80] array to the $a0
	
	jal UpperConv						# go to UpperConv function so as to convert the lower letters to upper letter
	
	move $a0,$v0						# $a0 is the first character of new array of upper characters		
	jal Print_String	

	li  $v0, 10                 		# system call to exit of program
	syscall

############################################################

Print_String:

	addi $sp, $sp, 4					# create space to the stack for the return address
	sw $ra, 0($sp)						# save the return address

	move $t2, $a0						# move to $t2 the content of the $a0 that is the string to be printed
	li $t1, 0
loop_print:
	add $t3, $t1, $t2					# move the $t2 to $t3
	lb $a0, 0($t3)						# load the first character
	jal Write_ch						# print this character via Write_ch function
	
	beq $a0, 0, after_loop_print		# check if this character is \0 			
	beq $a0, 10, after_loop_print		# check if this character is \n
	
	addi $t1, $t1, 1					# go to next character
	j loop_print
after_loop_print:

	lw $ra, 0($sp)						# load from stack the return address
	addi $sp, $sp, -4
	jr $ra

############################################################
Read_String:
	
	addi $sp, $sp, 4					# create space to the stack for the return address
	sw $ra, 0($sp)						# save the return address
	la $s0, string						# load the address of string[80] array
	li $t5, 0							# $t5 is a help counter and become zero 
	
read:
	
	jal Read_ch							# go to Read_String function so as to read a character
	sb $v0, string($t5)					# save the character to string array
	
	beq $v0,0,after_read_loop			# check if this character is \0
	beq $v0,10,after_read_loop			# check if this character is \n
	
	addi $t5,$t5, 1						# go to next character
	
	move $a0, $v0						# move the return value to argument for Write_ch function
	
	jal Write_ch						# print this character via Write_ch function
	
	j read
	
after_read_loop:
	
	
	lw $ra, 0($sp)						# load from stack the return address
	addi $sp, $sp, -4
	jr $ra


############################################################
Write_ch:
										# character in $a0
	lw $t0, 0xffff0008					# load the transimitter (console) control 

	andi $t0, $t0, 1					# get the ready bit via and operation
	beq $t0,$0,Write_ch					# check the ready bit
	sw $a0, 0xffff000c					# store to transimitter data the character and make this an argument

	jr $ra

############################################################

Read_ch:

	lb $t0,0xffff0000					# load the Receiver (keyboard) control 

    andi $t0,$t0,1						# get the ready bit via and operation
	beq  $t0,$0,Read_ch					# check the ready bit
	lb   $v0,0xffff0004           		# load the pushed character from receiver data and return this

	jr $ra
	
############################################################

UpperConv:
	
	addi $sp $sp, 4
	sw $ra, 0($sp)
	li $t2, 0							# these registers ($t2,t3,t4) will be usable as counters or pointers to the string[80] array
	li $t3, 0
	li $t4, 0
	
Upper_loop:								# this loop helps to count the length of string

	bge $t3, 80 , end_upper_loop
	add $t5, $a0, $t3					# take the string[$t5]
	lb $t6, 0($t5)						# read/load the string[$t5]
	beq $t6, 3, end_if_upper			# this condition checks if character is \0 counter is $t4
	addi $t4, $t4, 1					# raise the counter which counts the length
end_if_upper:
	
	addi $t3, $t3, 1					# $t3 is the loop counter
	j Upper_loop

end_upper_loop:	

	li $t5, 0							# initialize the $t5 to use again as counter
while_loop_upper:						# this loop access the string[80] array
	bge $t2, $t4, end_while_loop_upper	
	add $t5, $a0, $t2					# $t5 is the address of string[$t2]
	lb $t7, 0($t5)						# load the string[$t2]
	blt $t7, 97, end_if_upper_3			# this condition checks if the character is in the lower letter range [97-122]
	bgt $t7, 122, end_if_upper_3		# this condition if this character is upper [>122]
	addi $t7, $t7, -32					# in case of success make this character upper [upper = lower - 32]
	sb $t7, 0($t5)						# store this character in array
end_if_upper_3:

	addi $t2, $t2, 1					# add the while counter so as to go to the next character
	j while_loop_upper
end_while_loop_upper:

	la $v0,string
	lw $ra, 0($sp)
	addi $sp, $sp, -4
	jr $ra

############################################################