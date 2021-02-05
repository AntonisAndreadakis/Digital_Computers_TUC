.data

	InputString:		.space 128
	Number1:		.space 128
	Number2:		.space 128
	IntermediateString: 	.space 128
	OutputString:		.space 128

	InputPrompt:	.asciiz "Please enter an expression: "
	OutputPrompt:	.asciiz "The answer is: "
	newline:	.asciiz "\n"
	invalid:	.asciiz "Invalid string entered."
	overflow:	.asciiz "Overflow error."

	.text
	.globl main

main:

#Global registers:
#$19/$s3=Operator
#$21/$s5=first integer
#$22/$s6=second integer
#$23/$s7=result

#Type prompt and read the string
	li	$v0,  4			#Load the system code for string printing
	la	$a0,  InputPrompt	#Load the input prompt in $a0
	syscall				#Do the syscall
	la $a0, InputString		#Load the address for the input string in $a0
	li $a1, 128			#Load the size of string to be read in $a1
	li $v0, 8			#Load the system code for string reading
	syscall				#Do the syscall

#################################################################################################################
#	Start of String Split											#
#################################################################################################################

#$s0=Start of input string
#$s1=Start of input string (first number)/Pointer to operator position in string
#$s2=Start of second number
#$s3=Operator flag
#$t3=Character read

	la $s0, InputString		#Initiate $s0 at the start of the input string
	la $s1, 0($s0)			#Initiate $s0 at the address in $s0

StringSplit:
	lb $t3, 0($s1)			#Load the first character of the string in register $t3
	bne $s1, $s0, Skip1stCharCheck	#If it isnt the first char skip the sign check
	beq $t3, '-', AcceptSign	#Accept the '-' if it is the first char
Skip1stCharCheck:
	blt $t3, '0', EndOfNum1		#Check if character is <='0'
	bgt $t3, '9', EndOfNum1		#Check if character is >='9'
AcceptSign:
	addi $s1, $s1, 1		#Increment string counter by 1
	b StringSplit			#Do loop again
EndOfNum1:
	lb $19, 0($s1)			#Load the first character of the string in register $19 (operator byte)
	la $s2, 0($s1)			#Load the adress of the string pointer in $s1
	addi $s2, $s2, 1		#Increment string pointer by 1, to make it point at the start of the second number
StringCopyNumber1:
	la $t0, Number1			#Load the start of the Number1 string in $t0
LoopNumber1:
	lb $t0, 0($s0)			#Load the byte at $s0 in the Number1 string
	addi $t0, $t0, 1		#Increment Number1 string pointer by 1
	addi $s0, $s0, 1		#Increment first number string pointer by 1
	bne $s0, $s1, LoopNumber1	#If first number string pointer isn't equal with operator string pointer do loop again
	lb $t0, 10			#Else load the \n char at the end of the Number1 string
GetOperator:
	lb $s3, 0($s1)			#Load the byte from the operator string pointer in $s3
StringCopyNumber2:	 		
	la $t0, Number2			#Load the start of the Number2 string in $t0
LoopNumber2:
	lb $t0, 0($s2)			#Load the byte at $s2 in the Number2 string
	addi $t0, $t0, 1		#Increment Number2 string pointer by 1
	addi $s2, $s2, 1		#Increment second number string pointer by 1
	bne $s2, 10, LoopNumber2	#If byte at second number string pointer isn't equal with \n char do loop again
	lb $t0, 10			#Else load the \n char at the end of the Number2 string

#################################################################################################################
#	End of String Split											#
#################################################################################################################

#Convert first string to integer

la $t0, Number1				#Load the Number1 string in $t0 (input register of AtoI routine)
jal AtoI_Start				#Do the routine
move $21, $20				#Move the integer from $20 (output register of AtoI routine) to $21

#Convert second string to integer

la $t0, Number2				#Load the Number2 string in $t0 (input register of AtoI routine)
jal AtoI_Start				#Do the routine
move $22, $20				#Move the integer from $20 (output register of AtoI routine) to $22

#Check Operator and go to respective label

beq $19, '+', Addition			#If the operator is '+' do the addition routine
beq $19, '-', Substraction		#If the operator is '-' do the substraction routine
beq $19, '*', Multiplication		#If the operator is '*' do the multiplication routine
beq $19, '/', Division			#If the operator is '/' do the division routine
b InvalidString

Addition:
jal ADDINT				#Do the addition routine
b PrintOutput				#and print the output

Substraction:
jal SUBINT				#Do the substraction routine
b PrintOutput				#and print the output

Multiplication:
jal MULINT				#Do the multiplication routine
b PrintOutput				#and print the output

Division:
jal DIVINT				#Do the division routine
b PrintOutput				#and print the output


#################################################################################################################
#	Start of Addition Routine										#
#################################################################################################################

ADDINT:

	jr $ra				#Return.
#################################################################################################################
#	End of Addition Routine											#
#################################################################################################################

#################################################################################################################
#	Start of Substraction Routine										#
#################################################################################################################

SUBINT:

	jr $ra				#Return.

#################################################################################################################
#	End of Substraction Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Multiplication Routine										#
#################################################################################################################

MULINT:

	jr $ra				#Return.

#################################################################################################################
#	End of Multiplication Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Division Routine										#
#################################################################################################################

DIVINT:

	jr $ra				#Return.

#################################################################################################################
#	End of Division Routine											#
#################################################################################################################

#################################################################################################################
#	Start of ASCII to Integer Conversion Routine								#
#################################################################################################################

AtoI_Start:

# $t0=Input string pointer
# $t1=Character read
# $t2=String lenght counter
# $t3=Positive/Negative flag
# $t4=Overflow check
# $t5=Holds the 10 value
# $20=The integer

	li $t2, 0 			#Initiate length counter
	li $t3, 1 			#Initiate Positive/Negative Flag
	li $t5, 10			#Initiate $t5 at 10
	li $20, 0 			#Initiate integer

AtoI:
	lb $t1, 0($t0)			#Load the first character of the string in register $t1	
	bne $t1, ' ', SkipSpace		#if the char is not space skip space ignoring
	addi $t0, $t0, 1		#Else increment string pointer by 1
	b AtoI				#and repeat loop
SkipSpace:
	lb $t1, 0($t0)			#Load the char in $t1
	bne $t1, '-', PositiveNumber	#Check if char=='-'
	li $t3, -1			#Then load the -1 value in $t3
	addi $t0, $t0, 1		#and increment string pointer by 1
PositiveNumber:
	lb $t1, 0($t0)
	addi $t2, $t2, 1		#Increment string size
	addi $t0, $t0, 1		#Increment string pointer
	blt $t1, '0', EndOfString	#Check if character is >='0'
	bgt $t1, '9', EndOfString	#Check if character is <='9'
	mult $20, $t5			#Algorithm start: Multiply integer by 10
	mfhi $t4			#Check for overflow
	bnez $t4, OverflowError		#if true, report error
	mflo $20			#Else load multiplication result in register $20 (holds the integer)
	blt $20, $0, OverflowError	#Check for overflow, if true report error
	sub $t1, $t1, '0'		#Else continue with algorithm: Substract '0' from the character
	add $20, $20, $t1		#And add the result to the integer, store the sum in the integer register ($20)
	blt $20, $0, OverflowError	#Check for overflow, if true report error
	b PositiveNumber		#Repeat loop
EndOfString:
	sub $t0, $t0, 1			#Return string pointer to char after string end
	sub $t2, $t2, 1			#Decrease string size by 1
	beqz $t2, InvalidString		#If size=0 after the conversion an invalid string has been entered.
	bgt $t2, 5, InvalidString	#If size>5 then report a bad string
	beq $t3, 1, EndofAtoI		#If sign is not negative skip 2's complement conversion
	sub $20, $0, $20		#Else convert to 2's complement by sustracting the integer from 0.
EndOfAtoI:
	jr $ra				#Return.

#################################################################################################################
#	End of ASCII to Integer Conversion Routine								#
#################################################################################################################

#################################################################################################################
#	Start of Integer to ASCII Conversion Routine								#
#################################################################################################################

ItoA_Start:

# $t0=Indermediate string pointer
# $t1=Output string pointer 
# $t2=Division remainder/Last integer digit/Character to be moved
# $t3=Positive/Negative flag
# $t4=Holds the 10 value
# $t5=Start of intermediate string address
# $23=The integer

	la $t0, IntermediateString	#Initiate $t0 at the start of the intermediate string
	la $t1, OutputString		#Initiate $t1 at the start of the output string
	li $t2, 0			#Initiate $t2 at 0
	li $t3, 1			#Initiate Positive/Negative Flag
	li $t4, 10			#Initiate $t4 at 10
	la $t5, IntermediateString	#Initiate $t5 at the start of the intermediate string
ItoA:
	bgez $23, NotNegative		#If the number is positive, skip 2's complement conversion
	sub $23, $0, $23		#Else calculate the absolute value
	li $t3, -1			#And load the -1 value in register $t3
NotNegative:
	div $23, $t4			#Divide the integer by 10
	mfhi $t2			#Load the division remainder in $t2
	mflo $20			#Load the division quotient in $20
	addi $t2, $t2, '0'		#Add '0' to the integer, converting it to ASCII
	sb $t2, 0($t0)			#Store the last digit of the number in the intermediate string
	addi $t0, $t0, 1		#Increment intermediate string pointer by 1
	bnez $23, NotNegative		#If quotient!=0, do the loop again
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
	
	jr $ra				#Return.

#################################################################################################################
#	End of Integer to ASCII Conversion Routine								#
#################################################################################################################

#################################################################################################################
#	Error Reports												#
#################################################################################################################

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

#################################################################################################################
#	End of Program												#
#################################################################################################################