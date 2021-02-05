.data

	EXP_BUF:		.space 256
	IntermediateString: 	.space 256
	OutputString:		.space 256

	InputPrompt:		.asciiz "Please enter an expression: "
	OutputPrompt:		.asciiz "The answer is: "
	newline:		.asciiz "\n"
	ErrorString:		.asciiz "Error: "
	ProgramTerminated:	.asciiz "User ended program."

.align 2
	NUM_BUF:		.space 256
	OP_BUF:			.space 256

.text
.globl main

#Global registers:
#$19/$s3=Operator
#$20/$s4=result/return register of BIN_TO_ASCCI and GET_OP
#$21/$s5=first integer
#$22/$s6=second integer

#$18/$s2=NUM_BUF stack pointer
#$23/$s7=OP_BUF stack pointer


#################################################################################################################
#	Start of main program											#
#################################################################################################################

main:

#Type prompt and read the string
	li $v0, 4			#Load the system code for string printing
	la $a0, InputPrompt		#Load the input prompt in $a0
	syscall				#Do the syscall
	la $a0, EXP_BUF			#Load the address for the input string in $a0
	li $a1, 128			#Load the size of string to be read in $a1
	li $v0, 8			#Load the system code for string reading
	syscall				#Do the syscall

#$t0=String pointer

	la $s2, NUM_BUF
	la $s7, OP_BUF
	la $t0, EXP_BUF
	lb $t1, 0($t0)
	
	jal SpaceSkipper
	
	bne $t1, 'Q', notQ
	move $20, $t1
	jal PUSH_NUM
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	jal SpaceSkipper
	beq $t1, '\n', Quit
notQ:

	bne $t1, 'q', notq
	move $20, $t1
	jal PUSH_NUM
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	jal SpaceSkipper
	beq $t1, '\n', Quit
notq:

	jal expression
	
	jal BIN_TO_ASCII		#Convert the result integer to ASCII

	la $a0, OutputPrompt		#Load the output prompt string in $a0
	li $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, OutputString		#Load the output string in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	la  $a0, newline		#Load the '\n' char in $a0
	li  $v0, 4			#Load the system code for string printing
	syscall				#Do the syscall
	
	jal POP_NUM
	beq $20, 'q', Quit
	beq $20, 'Q', Quit

	b main
	
Quit:

	li $v0, 4
	la $a0, ProgramTerminated
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 10
	syscall

#################################################################################################################
#	End of main program											#
#################################################################################################################

#################################################################################################################
#	Start of expression Routine										#
#################################################################################################################

expression:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal term
	
	jal SpaceSkipper
	
exp_while:
	beq $t1, '+', AddSub
	beq $t1, '-', AddSub
	b expression_return
AddSub:
	move $20, $t1
	jal PUSH_OP
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	
	jal term
	jal EVAL
	b exp_while

expression_return:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
#################################################################################################################
#	End of expression Routine										#
#################################################################################################################

#################################################################################################################
#	Start of term Routine											#
#################################################################################################################

term:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal element
	
	jal SpaceSkipper
	
term_while:
	beq $t1, '*', MulDiv
	beq $t1, '/', MulDiv
	b term_return
MulDiv:
	move $20, $t1
	jal PUSH_OP
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	
	jal element
	jal EVAL
	b term_while
	
term_return:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
#################################################################################################################
#	End of term Routine											#
#################################################################################################################

#################################################################################################################
#	Start of element Routine										#
#################################################################################################################

element:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal SpaceSkipper
	
	bne $t1, '(', NoLeftParentheses
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	jal expression
	
	beq $t1, ')' ParenthesesBalance
	b UnbalancedParentheses

NoLeftParentheses:	
	beq $t1, '-', AcceptMinus
	blt $t1, '0', NumberExpected
	bgt $t1, '9', NumberExpected
AcceptMinus:
	jal ASCII_TO_BIN
	jal PUSH_NUM
	jal GET_OP
	b element_return
	
ParenthesesBalance:
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	
element_return:
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

#################################################################################################################
#	End of element Routine											#
#################################################################################################################

#################################################################################################################
#	Start of Push/Pop Number/Operator Routines								#
#################################################################################################################
PUSH_NUM:

	addi $s2, $s2, 4
	sw $20, 0($s2)
	
	jr $ra

POP_NUM:
	
	lw $20, 0($s2)
	addi $s2, $s2, -4
	
	jr $ra

PUSH_OP:

	addi $s7, $s7, 4
	sw $20, 0($s7)
	
	jr $ra

POP_OP:

	lw $20, 0($s7)
	addi $s7, $s7, -4
	
	jr $ra

#################################################################################################################
#	End of Push/Pop Number/Operator Routines								#
#################################################################################################################
	
#################################################################################################################
#	Start of Evaluation Routine										#
#################################################################################################################

EVAL:

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal POP_OP
	move $19, $20

	beq $19, '+', Addition			#If the operator is '+' do the addition routine
	beq $19, '-', Substraction		#If the operator is '-' do the substraction routine
	beq $19, '*', Multiplication		#If the operator is '*' do the multiplication routine
	beq $19, '/', Division			#If the operator is '/' do the division routine
	b IllegalOperation
	
Addition:
	jal ADDINT				#Do the addition routine

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
Substraction:
	jal SUBINT				#Do the substraction routine

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

Multiplication:
	jal MULINT				#Do the multiplication routine

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

Division:
	jal DIVINT				#Do the division routine

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

#################################################################################################################
#	End of Evaluation Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Addition Routine										#
#################################################################################################################

ADDINT:

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal POP_NUM
	move $22, $20
	jal POP_NUM
	move $21, $20

	add $20, $21, $22		#Do the addition

	jal PUSH_NUM
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra				#Return.
#################################################################################################################
#	End of Addition Routine											#
#################################################################################################################

#################################################################################################################
#	Start of Substraction Routine										#
#################################################################################################################

SUBINT:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal POP_NUM
	move $22, $20
	jal POP_NUM
	move $21, $20
	
	sub $20, $21, $22		#Do the substraction

	jal PUSH_NUM

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra				#Return.

#################################################################################################################
#	End of Substraction Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Multiplication Routine										#
#################################################################################################################

MULINT:

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal POP_NUM
	move $22, $20
	jal POP_NUM
	move $21, $20

	li $s0, 1
	li $s1, 1
	li $t2, 0 	#initiate G
	li $t3, 0 	#initiate T
	li $t4, 0 	#initiate YG
	li $t5, 0 	#initiate X
	li $t6, 0 	#initiate I		

	bgtz $21, FirstNumberPositive	#if first number is greater than zero skip flag
	li $s0, -1			#else save -1
FirstNumberPositive:
	bgtz $22, SecondNumberPositive  #if second number is greater than zero skip flag
	li $s1, -1			#else save -1
SecondNumberPositive:	
	abs $21, $21			#use absolute value of number
	abs $22, $22			#use absolute value of number
	
LoopStart:
	and $t5, $22, 1			#checks when the 32th bit is 1
	bne $t5, 1, Skip1		#if X!=1 go to skip1
	add $t2, $t2, $21		#G=G+P 
Skip1:
	srl $22, $22, 1			#P=P>>1

	srl $t3, $t3, 1			#T=G0##(T>>1)
	and $t5, $t2, 1			
	bne $t5, 1, Skip2		
	or $t3, $t3, 2147483648
	b Skip22
Skip2:
	or $t3, $t3, 0
Skip22:
	srl $t2, $t2, 1			#G=YG##(G>>1)
	and $t5, $t4, 1
	bne $t5, 1, Skip3
	or $t2, $t2, 2147483648
	b Skip33
Skip3:
	or $t2, $t2, 0
Skip33:
	li $t4, 0			#YG=0
	add $t6, $t6, 1			#i=i+1
	bne $t6, 31, LoopStart		#Repeat loop
	srl $t3, $t3, 1			
	
	bne $t2, $0, Overflow

#Set sign correctly

	bne $s0, -1, s1			
	neg $t3, $t3
s1:
	bne $s1, -1, s2
	neg $t3, $t3
s2:
	move $20, $t3

	jal PUSH_NUM

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra				#Return.

#################################################################################################################
#	End of Multiplication Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Division Routine										#
#################################################################################################################
DIVINT:

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $a2, $t0
	move $a3, $t1

	jal POP_NUM
	move $22, $20
	jal POP_NUM
	move $21, $20

	li $s0, 1
	li $s1, 1

	bgtz $21, DIV_FirstNumberPositive
	li $s0, -1
DIV_FirstNumberPositive:
	bgtz $22, DIV_SecondNumberPositive
	li $s1, -1
DIV_SecondNumberPositive:	
	abs $21, $21
	abs $22, $22

	
	move $t0, $zero			#initialize to zero the quotient
	move $t1, $zero			#initialize to zero the remainder
	move $t2, $22			#t2 is the divisor
	move $t3, $21			#t3 is the dividend
	li $t4, -2147483648 		#t4 is used to count divident(or divisor)digits
	li $t5, -3			#initialize to -1 the digit counter(dividend)
	li $t7, -3			#initialize to -1 the digit counter(divisor)
	move $t6, $zero			#initialize to zero the help register
	li $t9,-2			#t9 takes a value in order to make the q0=0
	li $t8,1			#t8 takes a value in order to make the q0=1

	beqz $t2, DivideByZero
	bgt $t2, $t3, exitDiv
		
counterDividend:
	move $a0, $t5			#load the first argument
	li $a1, 1			#load the second argument
	add $v0, $a0, $a1
	move $t5, $v0			#store the first argument
	and $t6, $t3, $t4
	srl $t4, $t4, 1
	beqz $t6, counterDividend
	sllv $t3, $t3, $t5
	move $t6, $zero			#initialize to zero the help register		
	li $t4, -2147483648 		#t4 is used to count dividend digits

counterDivisor:
	move $a0, $t7			#load the first argument
	li $a1, 1			#load the second argument
	add $v0, $a0, $a1	
	move $t7, $v0			#store the first argument
	and $t6,$t2,$t4
	srl $t4,$t4,1
	beqz $t6,counterDivisor
	sllv $t2,$t2,$t7
	move $t6, $zero			#initialize to zero the help register		
	move $a0, $t7			#load the first argument
	move $a1, $t5			#load the second argument
	sub $v0, $a0, $a1	
	move $t6, $v0			#store the first argument
	move $a0, $t6			#load the first argument
	li $a1, 1			#load the second argument
	add $v0, $a0, $a1	
	move $t6, $v0			#store the first argument
	move $t1,$t3
	li $t5, 1			#from now on $t5 is i counter

iterateDiv:
	move $a0, $t1			#load the first argument
	move $a1, $t2			#load the second argument
	sub $v0, $a0, $a1
	move $t1, $v0			#store the first argument
	bltz	$t1,RemNeg	

RemPos:
	sll $t0,$t0,1
	or $t0, $t0, $t8		#use or to make the first digit equal to 1
	blt $t5,$t6,iterationEnd
	j exitDiv

RemNeg:
	move $a0, $t1			#load the first argument
	move $a1, $t2			#load the second argument
	add $v0, $a1, $a0
	move $t1, $v0			#store the first argument
	sll $t0,$t0,1
	and $t0, $t0, $t9		#use or to make the first digit equal to 0
	beq $t5,$t6,exitDiv	

iterationEnd:
	sll $t1,$t1,1			#shift remainder one pos left
	move $a0, $t5			#load the first argument
	li $a1, 1			#load the second argument
	add $v0, $a1, $a0	
	move $t5, $v0			#store the first argument
	j iterateDiv	

exitDiv:

	move $20, $t0	
	move $v1, $zero			#load 0 to the $v1 return value if there is no overflow

	bne $s0, -1, DIV_s1			
	neg $20, $20
DIV_s1:
	bne $s1, -1, DIV_s2
	neg $20, $20
DIV_s2:

	jal PUSH_NUM

	move $t0, $a2
	move $t1, $a3
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

#################################################################################################################
#	End of Division Routine											#
#################################################################################################################

#################################################################################################################
#	Start of ASCII to Integer Conversion Routine								#
#################################################################################################################

ASCII_TO_BIN:

	addi $sp, $sp, -4
	sw $ra, 0($sp)

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
	jal SpaceSkipper
	
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
	bnez $t4, Overflow		#if true, report error
	mflo $20			#Else load multiplication result in register $20 (holds the integer)
	blt $20, $0, Overflow		#Check for overflow, if true report error
	sub $t1, $t1, '0'		#Else continue with algorithm: Substract '0' from the character
	add $20, $20, $t1		#And add the result to the integer, store the sum in the integer register ($20)
	blt $20, $0, Overflow		#Check for overflow, if true report error
	b PositiveNumber		#Repeat loop
EndOfString:
	sub $t0, $t0, 1			#Return string pointer to char after string end
	lb $t1, 0($t0)
	sub $t2, $t2, 1			#Decrease string size by 1
	beqz $t2, IllegalOperand	#If size=0 after the conversion an invalid string has been entered.
	bgt $t2, 5, IllegalOperand	#If size>5 then report a bad string
	beq $t3, 1, EndOfAtoI		#If sign is not negative skip 2's complement conversion
	sub $20, $0, $20		#Else convert to 2's complement by sustracting the integer from 0.
EndOfAtoI:
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra				#Return.

#################################################################################################################
#	End of ASCII to Integer Conversion Routine								#
#################################################################################################################

#################################################################################################################
#	Start of Get Operator Routine										#
#################################################################################################################

GET_OP:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal SpaceSkipper
	
	beq $t1, '+', Operator_OK	#If the operator is '+' Op is ok
	beq $t1, '-', Operator_OK	#If the operator is '-' Op is ok
	beq $t1, '*', Operator_OK	#If the operator is '*' Op is ok
	beq $t1, '/', Operator_OK	#If the operator is '/' Op is ok
	beq $t1, ')', Operator_OK
	beq $t1, '\n', Operator_OK
	b IllegalOperation
Operator_OK:	

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
#################################################################################################################
#	End of Get Operator Routine										#
#################################################################################################################

#################################################################################################################
#	Start of Integer to ASCII Conversion Routine								#
#################################################################################################################

BIN_TO_ASCII:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

# $t0=Indermediate string pointer
# $t1=Output string pointer 
# $t2=Division remainder/Last integer digit/Character to be moved
# $t3=Positive/Negative flag
# $t4=Holds the 10 value
# $t5=Start of intermediate string address
# $20=The integer

	jal POP_NUM

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
	

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra				#Return.

#################################################################################################################
#	End of Integer to ASCII Conversion Routine								#
#################################################################################################################

SpaceSkipper:
	
	bne $t1, ' ', SpaceSkipperReturn
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	b SpaceSkipper
SpaceSkipperReturn:
	jr $ra

#################################################################################################################
#	Start of Error Reports											#
#################################################################################################################

IllegalOperand:
	li $t0, 1
	b Error
IllegalOperation:
	li $t0, 2
	b Error
DivideByZero:
	li $t0, 3
	b Error
Overflow:
	li $t0, 4
	b Error
UnbalancedParentheses:
	li $t0, 5
	b Error
NumberExpected:
	li $t0, 6
	b Error

Error:
	la $a0, ErrorString
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la  $a0, newline
	li  $v0, 4
	syscall
	
	b main

#################################################################################################################
#	End of Error Reports											#
#################################################################################################################