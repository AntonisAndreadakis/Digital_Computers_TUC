# Lab 2
# Description: Converts an number from ASCII format to integer and back to ASCII and prints the result.
# Authors:
# Vasileios Vasilikos AM: 2003030005
# Georgios Pierrhs AM: 2003030033

.data
	InputString: 		.space 128 	#Reserve 128 bytes for the input string
	IntermediateString: 	.space 128 	#Reserve 128 bytes for the intermediate string
	OutputString:		.space 128	#Reserve 128 bytes for the output string

	InputPrompt:	.asciiz "Please enter a number: "
	OutputPrompt:	.asciiz "The original number is: "
	test:		.asciiz "Negative number"
	newline:	.asciiz "\n"
	invalid:	.asciiz "Invalid string entered."
	overflow:	.asciiz "Overflow error."

	.text
	.globl main

main:


#Type prompt and read the string
	li	$v0,  4			#Load the system code for string printing
	la	$a0,  InputPrompt	#Load the input prompt in $a0
	syscall				#Do the syscall
	la $a0, InputString		#Load the address for the input string in $a0
	li $a1, 128			#Load the size of string to be read in $a1
	li $v0, 8			#Load the system code for string reading
	syscall				#Do the syscall

#Start of ASCII to integer conversion

# $t0=Input string pointer
# $t1=Character read
# $t2=String lenght counter
# $t3=Positive/Negative flag
# $t4=Overflow check
# $t5=Holds the 10 value
# $20=The integer

	la $t0, InputString		#Initiate $t0 at the start of the input string
	li $t2, 0 			#Initiate length counter
	li $t3, 1 			#Initiate Positive/Negative Flag
	li $t5, 10			#Initiate $t5 at 10
	li $20, 0 			#Initiate integer

AtoI:
	lb $t1, 0($t0)			#Load the first character of the string in register $t1
	beq $t1, '\n', EndOfString	#Check for '\n' char, if true go to end of string
	beq $t1, '+', InvalidString	#Check for '+' char, if true report bad string
	addi $t0, $t0, 1		#Else increment string pointer by 1
	addi $t2, $t2, 1		#Increment string size by 1
	beq $t3, -1, PositiveNumber	#If sign has already been checked and found negative skip recheck
	bne $t1, '-', PositiveNumber	#if first character is not '-' skip negative number handling code
	bne $t2, 1, InvalidString	#Else if the '-' is not the first char, report a bad string
	li $t3, -1			#Else load value -1 in register $t3
	b AtoI				#And continue reading string
PositiveNumber:
	blt $t1, '0', InvalidString	#Check if character is >='0'
	bgt $t1, '9', InvalidString	#Check if character is <='9'
	mult $20, $t5			#Algorithm start: Multiply integer by 10
	mfhi $t4			#Check for overflow
	bnez $t4, OverflowError		#if true, report error
	mflo $20			#Else load multiplication result in register $20 (holds the integer)
	blt $20, $0, OverflowError	#Check for overflow, if true report error
	sub $t1, $t1, '0'		#Else continue with algorithm: Substract '0' from the character
	add $20, $20, $t1		#And add the result to the integer, store the sum in the integer register ($20)
	blt $20, $0, OverflowError	#Check for overflow, if true report error
	b AtoI				#Repeat loop
EndOfString:
	beqz $t2, InvalidString		#If size=0 after the conversion an invalid string has been entered.
	blt $t2, 6, LenghtOK		#If size<6 then lenght is ok
	bne $t2, 6, InvalidString	#Else if size!=6 then report a bad string
	bne $t3, -1, InvalidString	#Else if number is not negative report a bad string
LenghtOK:
	beq $t3, 1, EndofAtoI		#If sign is not negative skip 2's complement conversion
	sub $20, $0, $20		#Else convert to 2's complement by sustracting the integer from 0.
	
#End of ASCII to Integer conversion
EndofAtoI:
b StartofAtoI				#Begin Integer to ASCII conversion

#Start of Integer to ASCII conversion
StartofAtoI:

# $t0=Indermediate string pointer
# $t1=Output string pointer 
# $t2=Division remainder/Last integer digit/Character to be moved
# $t3=Positive/Negative flag
# $t4=Holds the 10 value
# $t5=Start of intermediate string address
# $20=The integer

	la $t0, IntermediateString	#Initiate $t0 at the start of the intermediate string
	la $t1, OutputString		#Initiate $t1 at the start of the output string
	li $t2, 0			#Initiate $t2 at 0
	li $t3, 1			#Initiate Positive/Negative Flag
	li $t4, 10			#Initiate $t4 at 10
	la $t5, IntermediateString	#Initiate $t5 at the start of the intermediate string
ItoA:
	bgez $20, NotNegative		#If the number is positive, skip 2's complement conversion
	sub $20, $0, $20		#Else calculate the absolute value
	li $t3, -1			#And load the -1 value in register $t3
NotNegative:
	div $20, $t4			#Divide the integer by 10
	mfhi $t2			#Load the division remainder in $t2
	mflo $20			#Load the division quotient in $20
	addi $t2, $t2, '0'		#Add '0' to the integer, converting it to ASCII
	sb $t2, 0($t0)			#Store the last digit of the number in the intermediate string
	addi $t0, $t0, 1		#Increment intermediate string pointer by 1
	bnez $20, NotNegative		#If quotient!=0, do the loop again
AddSign:
	sub $t0, $t0, 1			#Decrease intermediate string pointer by 1 (to set it at the end of the string)
	bne $t3, -1, Reverse		#If number is positive, skip sign adding
	li $t2, '-'			#Else load the '-' char in $t2
	sb $t2, 0($t1)			#Load the sign in the output string
	addi $t1, $t1, 1		#And increment output string pointer by 1
Reverse:
	beq $t0, $t5, EndReverse	#If the Intermediate string pointer points at the beginning of the string end loop
	lb $t2, 0($t0)			#Load the byte from the intermediate string in register $t2
	sb $t2, 0($t1)			#Load the byte from register $t2 in the output string
	sub $t0, $t0, 1			#Decrease intermediate string pointer by 1
	addi $t1, $t1, 1		#Increase output string pointer by 1
	b Reverse			#Do loop again
EndReverse:
	lb $t2, 0($t0)			#Else put the last char in $t2
	sb $t2, 0($t1)			#Load the char from register $t2 in the output string
	addi $t1, $t1, 1		#Increment the output string pointer by 1
	sb $0, 0($t1)			#And add the string termination char '\0'
	b EndofItoA			#And go to end of conversion

#End of Integer to ASCII conversion
EndofItoA:
b TypeOutput				#Type the output

TypeOutput:
	la $a0, OutputPrompt		#Load the output prompt string in $a0
	li $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, OutputString		#Load the output string in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, newline		#Load the '\n' char in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	b EndOfProgram			#Go to end of program		

InvalidString:
	la  $a0, invalid		#Load the prompt for invalid string in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, newline		#Load the '\n' char in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	b EndOfProgram			#Go to program end
OverflowError:
	la  $a0, overflow		#Load the prompt for overflow error in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, newline		#Load the '\n' char in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall

#Exit program
EndOfProgram:
	li $v0, 10			#Load the system code for program exit
	syscall				#Do the syscall           