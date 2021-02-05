#****************************************************************************************************************
#  Description:													*
#	Input(from keyboard) :  an arithmetic expression (with or without parenthesis) which includes		*
#				some or all the basic operations (addition,substraction,multiplication,division)*
#	Output(to screen)    :	the result of the arithmetic expression						*
#  Lesson: HRY201					                                                 	*
#  Lab: 5						                                                 	*
#  Authors: George Athanasiou & Nikos Maris                                                              	*
#  		                                                                              			*
#****************************************************************************************************************

				# Program Map
# data segment
# text segment
# main

# expression
# term
# element
# Get_Ready
# checkError
# ASCII_TO_BIN
# Load_Operation
# check_EOX
# EVAL
# PUSH_OP
# POP_OP
# PUSH_NUM
# POP_NUM
# ADDINT
# SUBINT
# MULINT
# DIVINT
# BIN_to_ASCII
# print_output
# atoi_loop
# skip_spaces

#*******************************************************************
#                                                                  *
#			data segment                               *
#                                                                  *
#*******************************************************************

	.data			# Storing the following data items in the data segment of memory
input:			.asciiz 	"Please enter an expression :"
output:			.asciiz 	"The answer is :"

	.align 2		# aligns memory to 4 bytes(4 bytes in a word) (useful for subroutines PUSH_NUM and POP_NUM)
EXP_BUF:		.space 256	# input string
reversed_string:	.space 256	# needed only for BIN_TO_ASCII subroutine
final_string:		.space 256	# output string

NUM_BUF:		.space 256	# buffer(used as a stack) that holds the operands
OP_BUF:			.space 256	# buffer(used as a stack) that holds the operators

# Messages printed on special cases
error1:			.asciiz		"\nThe input string is not appropriate!\n"
error2:			.asciiz		"\nOverflow!!!\n"
error3:			.asciiz		"\nBe careful, you divide with zero!This is impermissible!!!\n"
error4:			.asciiz		"\nUnbalanced parenthesis!\n"
error5:			.asciiz		"\nThe input number had more than 5 digits! Please try again!\n"
bye:			.asciiz		"\nAu revoir..."

	.globl EXP_BUF 		# user's input is global
	.globl main		# main must be global
	.globl expression
	.globl term
	.globl element
	.globl Get_Ready
	.globl checkError
	.globl ASCII_TO_BIN
	.globl Load_Operation
	.globl check_EOX
	.globl EVAL
	.globl PUSH_OP
	.globl POP_OP
	.globl PUSH_NUM
	.globl POP_NUM
	.globl ADDINT
	.globl SUBINT
	.globl MULINT
	.globl DIVINT
	.globl BIN_to_ASCII
	.globl print_output
	.globl atoi_loop
	.globl skip_spaces

#*******************************************************************
#								   *
#		          text segment			           *
#						                   *
#*******************************************************************

	.text		        # directive for the start of instructions / start of the program 

main:
	jal Get_Ready		# call subroutine to get information from the interface (by reading the input string)
	la $s0 , EXP_BUF	#********		Pointers' definition		     ************
	la $s5 , NUM_BUF	# It is recommented not to overwrite these 3 registers(pointers)!	*
	la $s7 , OP_BUF		#************************************************************************
	lb $t0 , 0($s0)		# s0 points at the beginning of the EXP_BUF, so $t0 is the first character of EXP_BUF

# searches for Q or (Q and '\n') at the beginning of EXP_BUF
	li $t7 , 81		# 81='Q'
	bne $t0 , $t7 , noQ	# if the first character of EXP_BUF is not 'Q' then branch to noQ
	li $t7 , 1		# t7 takes the value 1 which means that EXP_BUF begins with 'q' or 'Q'
	addi $s0 , $s0 , 1 	### s0 points at the next character of EXP_BUF
	lb $t0 , 0($s0)		# t0 is the second character of EXP_BUF
	li $t2 , 10		# 10='\n'
	beq $t0 , $t2 , Quit	# if the second character is '\n' then branch to Quit
	b noQuit		# t0 is not '\n' ,so branch to noQuit
noQ:	
# searches for q or (q and '\n') at the beginning of EXP_BUF
	li $t7 , 113		# 113='q'
	bne $t0 , $t7 , noQuit	# # if the first character of EXP_BUF is not 'q' then branch to noQ
	li $t7 , 1		# t7 takes the value 1 which means that EXP_BUF begins with 'q' or 'Q'
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF
	lb $t0 , 0($s0)		# t0 is the second character of EXP_BUF
	li $t2 , 10		# 10='\n'
	beq $t0 , $t2 , Quit	# if the second character is '\n' then branch to Quit
noQuit:
	
	move $t2 , $t0		# t2 hols the input character of skip_spaces subroutine
	jal skip_spaces		# call subroutine to skip the spaces of EXP_BUF
	addi $s0 , $s0 , 1	# s0 points at the character after the spaces,or at the next character(if there are no spaces)
	lb $t0 , 0($s0)		# t0 holds that character
# The process of EXP_BUF starts here
	jal expression		# call of a recursive-like subroutine

	jal POP_NUM		# pop buffer(used like stack) NUM_BUF to t2 (the result of the arithmetic expression)
	move $s4 , $t2		# s4 holds the inptu number of BIN_TO_ASCII subroutine
	jal BIN_to_ASCII	# converts the number from binary form to a string
	jal print_output	# prints the string (interface of the program with the user)
	
	li $t2 , 1		# (if t7 takes the value 1 ,it means that EXP_BUF begins with 'q' or 'Q')
	beq $t7 , $t2 , Quit	# if t7==1 then branch to Quit
	b main			# branch to main (recall of the program)

Quit:
	li $v0 , 4		# 4 means print string in system call code
	la $a0 , bye		# prints the string "\nAu revoir..."
	syscall
	
	li $v0, 10		# exits program
	syscall


#*****************************************************************************************************************
#		END	OF	MAIN
#*****************************************************************************************************************


#### Start of subroutine = expression
# inputs= 	s0 points at the beginning of the EXP_BUF,t0=A(the character),
##### note:	Conditionally,we have a recursive call (expression -> term -> element -> expression) and the recurcive relationship(grammar) is this:
#
# expression = expression + term | expression - term | term
# term = term * element | term / element | element
# element = ( expression ) | number
# number = integer between -99999 and 99999 (where the symbol | means or)
expression:
	# Prologue of subroutine
	sub $sp , $sp , 4	# push stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address

	jal term		# the subroutine term may return at the next of this line
exp_while:
	li $t2 , 43		# 43 = '+'
	beq $t0 , $t2 , addORsub# if t0=='+' ,branch to addORsub
	li $t2 , 45		# 45 = '-'
	beq $t0 , $t2 , addORsub# if t0=='-' ,branch to addORsub
	b exp_ifNOtrue		# t0 is neither '+' nor '-' ,so branch to exp_ifNOtrue
addORsub:
	move $s2 , $t0		# s2 is the argument of PUSH_OP
	jal PUSH_OP		# push '+' or '-' in the OP_BUF
	###
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF
	lb $t0 , 0($s0)		# t0 is the current character in which s0 points
	###
	jal term		# the subroutine term may return at the next of this line
	jal EVAL		# add or substract the last 2 number on NUM_BUF
	b exp_while

exp_ifNOtrue:
	# epilogue of subroutine
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)
	
	jr $ra
#### End of subroutine = expression

#												##########################


#### Start of subroutine = term
# inputs= 	t0=A
term:
	# Prologue of subroutine
	sub $sp , $sp , 4	# push stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address

	jal element		# the subroutine element may return at the next of this line
term_while:
	li $t2 , 42		# 42 = '*'
	beq $t0 , $t2 , mulORdiv# if t0=='*' branch to mulORdiv
	li $t2 , 47		# 47 = '/'
	beq $t0 , $t2 , mulORdiv# if t0=='/' branch to mulORdiv
	b term_ifNOtrue
mulORdiv:
	move $s2 , $t0		# s2 is the argument of PUSH_OP
	jal PUSH_OP
	###
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF
	lb $t0 , 0($s0)		# t0 is the current character in which s0 points
	###
	jal element		# the subroutine element may return at the next of this line
	jal EVAL		# multiply or divide the last 2 number on NUM_BUF
	b term_while
term_ifNOtrue:
	# epilogue of subroutine
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)
	
	jr $ra			# jump on register ra
#### End of subroutine = term

#												##########################


#### Start of subroutine = element
# inputs= 	t0=A
element:
	# Prologue of subroutine
	sub $sp , $sp , 4	# push stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address

	li $t2 , 40		# 40 = '('
	bne $t0 , $t2 , NO_left_parenth		# If A != "(" then branch to NO_left_parenth
	###
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF
	lb $t0 , 0($s0)		# A = the current character in which points s0
	###
	#***************************************
	jal expression		# recursive call
	#***************************************
	li $t2 , 41		# 41 = ')'
	beq $t0 , $t2 , right_parenth# If A == ")" then branch to right_parenth
	
	li $s6 , 4		# (so the number has more than 5 digits) s6=errorCode=1
	jal checkError		# call subroutine to print error message and branch to main
right_parenth:
	###
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF					#*****************by Maris-Athanasiou
	lb $t0 , 0($s0)		# t0 is the current character in which s0 points
	###
	b left_parenth
NO_left_parenth:

	move $t2 , $t0
	jal skip_spaces		# call subroutine to skip the spaces of EXP_BUF
	###
	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF					#*****************by Maris-Athanasiou
	lb $t0 , 0($s0)		# t0 is(the input of ASCII_TO_BIN) the current character in which s0 points
	###
	jal ASCII_TO_BIN	# reads the "number" and returns it($t6)
	jal PUSH_NUM		# push number ($t6) in the NUM_BUF

	addi $s0 , $s0 , 1	### s0 points at the next character of EXP_BUF
	jal Load_Operation	# returns the operator ($s2)

	move $t0 , $s2		# A = the operator
left_parenth:
	
	# epilogue of subroutine
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)
	
	jr $ra
#### End of subroutine = element
#												##########################



#### Start of subroutine = Get_Ready
# overwrites= 	v0,a0,a1,t1,t2,s4
# inputs= 	1 message(input),1 buffer(EXP_BUF)
# outputs= 	s6(error_code is needed for all the program!)
Get_Ready:
										# print "Please enter an expression :"
	li $v0 , 4		# store the value 4 in the register v0
	la $a0 , input		# load the address of the string's first character	
	syscall			# (do the syscall) 4 is the print_string system call code

										# initializes EXP_BUF
	la $a0 , EXP_BUF	# initialize all the blocked memory(EXP_BUF) in order to save the input characters
	li $t2 , 1		# t2=counter
	li $t1 , 256		# t1 number of bytes of EXP_BUF

initializing_EXP_BUF:
	sb $0 , 0($a0)		# put zero in the byte where a0 points to
	addi $a0 , $a0 , 1	# a0 points to the next byte of the EXP_BUF
	addi $t2 , $t2 , 1	# counter = counter + 1
	bleu $t2 , $t1 , initializing_EXP_BUF	# if( counter<256 ) branch to initializing_EXP_BUF

										# initializes reversed_string
	la $a0 , reversed_string# initialize all the blocked memory(reversed_string) in order to save the input characters
	li $t2 , 1		# t2=counter
	li $t1 , 256		# t1 number of bytes of reversed_string

initializing_reversed_string:

	sb $0 , 0($a0)		# put zero in the byte where a0 points to
	addi $a0 , $a0 , 1	# a0 points to the next byte of the reversed_string
	addi $t2 , $t2 , 1	# counter = counter + 1
	bleu $t2 , $t1 , initializing_reversed_string	# if( counter<256 ) branch to initializing_reversed_string

										# initializes final_string
	la $a0 , final_string	# initialize all the blocked memory(final_string) in order to save the input characters
	li $t2 , 1		# t2=counter
	li $t1 , 256		# t1 number of bytes of final_string

initializing_final_string:

	sb $0 , 0($a0)		# put zero in the byte where a0 points to
	addi $a0 , $a0 , 1	# a0 points to the next byte of the final_string
	addi $t2 , $t2 , 1	# counter = counter + 1
	bleu $t2 , $t1 , initializing_final_string	# if( counter<256 ) branch to initializing_final_string

										# read the input string
	li $v0 , 8		# (so, after the loop)store the value 8 in the register v0
	li $a1 , 256		# maximum number of bytes to read
	la $a0 , EXP_BUF
	syscall			# (do the syscall) 8 is the read_string system call code which demands two arguments

	li $s6 , 0		# initialize s6=error_code (0 means that there is no problem)
	li $s4 , 0		# initialize the result number

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 
#### End of subroutine = Get_Ready

#												##########################


#### Start of subroutine = checkError
# overwrites=	t1,v0,a0	
# inputs= 	s6 and all the labels for special cases
# outputs= 	none
checkError:
	beqz $s6 , main		# if s6==0 it means that there is no problem,so branch to main(recall of the program)
	
	li $t1 , 1
	bne $s6 , $t1 ,go2	# if s6!=1 means that...,branch to go2(so,s6 is neither 0 nor 1)
	la $a0 , error1		# load the address of the string's first character (this string refer to this error)
	b printError
go2:				# s6 is 2 or 3 or 4(we have 5 special conditions and the zero condition=normal)

	li $t1 , 2
	bne $s6 , $t1 ,go3	# if s6!=2 means that...,branch to go3(finally,s6 is 3)
	la $a0 , error2		# load the address of the string's first character (this string refer to this error)
	b printError
go3:				# s6=3(we have 5 special conditions and the zero condition=normal)
	li $t1 , 3
	bne $s6 , $t1 ,go4	# if s6!=3 means that...,branch to go4(finally,s6 is 4)
	la $a0 , error3		# load the address of the string's first character (this string refer to this error)
	b printError
go4:				# s6=3(we have 5 special conditions and the zero condition=normal)
	li $t1 , 4
	bne $s6 , $t1 ,go5	# if s6!=4 means that...,branch to go5(finally,s6 is 5)
	la $a0 , error4		# load the address of the string's first character (this string refer to this error)
	b printError

go5:				# s6=5(we have 5 special conditions and the zero condition=normal)
	la $a0 , error5		# load the address of the string's first character (this string refer to this error)
	b printError

printError:									# print the appropriate error message
	li $v0 , 4		# store the value 4 in the register v0
	syscall			# (do the syscall) 4 is the print_string system call code
	b main			# branch to main(recall of the program)
#### End of subroutine = checkError
#												##########################



#### Start of subroutine = ASCII_TO_BIN
# overwrites=	t1,t2,t3,t4,t5	
# inputs= 	s0(pointer at EXP_BUF)
# outputs= 	t6(the number in binary form),s0 points at the end of the number

ASCII_TO_BIN:
	# prologue 
	sub $sp , $sp , 4	# PUSH stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address of subroutine ASCII_TO_BIN
	
	lb $t3 , 0($s0)		# load byte of EXP_BUF (in which $s0 points), at $t3				****start of t3 life
	li $t2 , 45		# t2 = '-'
	bne $t3 , $t2 , positive1st	# if(t3!='-') branch to positive1st

	addi $s0 , $s0 , 1	# (so,the first "number" is negative) s0 points to the next byte of the EXP_BUF
	lb $t4 , 0($s0)		# load the first character of the first "number" ($s0 points at EXP_BUF), at $t4

	li $t6 , 0		# initialize t6 which is the number in binary form
	li $t5 , 0		# initialize t5=counter
	jal atoi_loop		# call subroutine to convert the number from ASCII to binary(the subroutine is a loop)
	
	li $t2 , 6		# t2=6 (atoi_loop examines at most 5 digits and the next character)
	bleu $t5, $t2 , notBigNegNum1st	# if(t5<=6) branch to notBigNum
	li $s6 , 5		# (so the number has more than 5 digits) s6=errorCode=1
	jal checkError		# call subroutine to print error message and branch to main

notBigNegNum1st:
	li $t2 , -1		# (so the first number has at most 5 digits) t2=-1
	mul $t6 , $t6 , $t2	# multiple t6 with -1 (without checking for overflow)

positive1st:
	li $t2 , 45		# t1 = '-'
	beq $t3 , $t2 , binOutput1st	# if(t3=='-') branch to binOutput1st					****end of t3 life

	move $t4 , $t3		# (so,the first "number" is positive) moves (t3) the first charascter of the number to (t4) the input of ASCII_to_BIN
	li $t6 , 0		# initialize t6 which is the first number in binary form
	li $t5 , 0		# initialize t5=counter
	jal atoi_loop		# call subroutine to convert the number from ASCII to binary(the subroutine is a loop)
	
	li $t2 , 6		# t1=6 (atoi_loop examines at most 5 digits and the next character)
	bleu $t5, $t2 , binOutput1st	# if(t5<=6) branch to binOutput1st
	li $s6 , 5	        # (so the number has more than 5 digits) s6=errorCode=1
	jal checkError		# call subroutine to print error message and branch to main

binOutput1st:
	# epilogue 
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)
	
	sub $s0 , $s0 , 1
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 
#### End of subroutine = ASCII_TO_BIN

#												##########################


#### Start of subroutine = Load_Operation
# overwrites=	t1,t2
# inputs= 	s0(pointer at the operator)
# outputs= 	s2(the operator in ASCII form)
Load_Operation:
	# prologue of subroutine
	sub $sp , $sp , 4	# push stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address

	lb $t2 , 0($s0)		# load the input character for the operation at $t2

	jal skip_spaces		# call subroutine to skip the spaces of EXP_BUF
	addi $s0 , $s0 , 1

	li $t1 , 43
	bne $t2 , $t1 , noADD	# if t2!='+' branch to noADD
	li $s2 , 43		# (so t2=='+')set s2='+'
	b t2_is_OK
noADD:
	li $t1 , 45
	bne $t2 , $t1 , noSUB	# if t2!='-' branch to noSUB
	li $s2 , 45		# (so t2=='-')set s2='-'
	b t2_is_OK
noSUB:
	li $t1 , 42
	bne $t2 , $t1 , noMUL	# if t2!='*' branch to noMUL
	li $s2 , 42		# (so t2=='*')set s2='*'
	b t2_is_OK
noMUL:
	li $t1 , 47
	bne $t2 , $t1 , noDIV	# if t2!='/' branch to noDIV
	li $s2 , 47		# (so t2=='/')set s2='/'
	b t2_is_OK
#----->here we can check for parenthesis
noDIV:
	li $t1 , 41		# 41 = ')'
	bne $t2 , $t1 , else	# if t2!=')' branch to no_right_par
	li $s2 , 41		# ( so t2==')' )set s2=')'
	b t2_is_OK
else:
	jal check_EOX		# searches if t2 is one of these--> q,Q,'\n','='
	move $s2 , $t2		# check_EOX returns $t2
t2_is_OK:
	addi $s0 , $s0 , 1	# s0 points to the next byte of the EXP_BUF

	lb $t2 , 0($s0)		# load the input character for the operation at $t2

	jal skip_spaces		# call subroutine to skip the spaces of EXP_BUF

	# epilogue of subroutine
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 
#### End of subroutine = Load_Operation

#												##########################


#### Start of subroutine = check_EOX
# overwrites=	t1
# inputs=	t2(EOX character)
# outputs= 	none
check_EOX:

	li $t1 , 81		# t1='Q'	( capital q )
	bne $t2 , $t1 , not_Q	# if(t2!='Q') branch to not_Q
	li $v0 , 4		# 4 means print string in system call code
	la $a0 , bye		# prints the string "\nAu revoir..."
	syscall
	li $v0 , 10		# 10 means exit in system call code
	syscall			# au revoir...
not_Q:
	li $t1 , 113		# t1='q'	( lower-case q )
	bne $t2 , $t1 , not_q	# if(t2!='q') branch to not_q
	li $v0 , 4		# 4 means print string in system call code
	la $a0 , bye		# prints the string "\nAu revoir..."
	syscall
	li $v0 , 10		# 10 means exit in system call code
	syscall			# au revoir...
not_q:
	li $t1 , 61		# t1= '='
	beq $t2 , $t1 , arithmetic_exp	# if(t2 ==  '=') branch to arithmetic_exp(the input string is OK)
	li $t1 , 10		# t1=10='\n'
	beq $t2 , $t1 , arithmetic_exp	# if(t2=='\n') branch to arithmetic_exp(the input string is OK)
	li $s6 , 1		# (so the 2nd number doesn't finish with '\n') s6=errorCode=1
	jal checkError		# call subroutine to print error message and branch to main

arithmetic_exp:	
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 
#### End of subroutine = check_EOX

#												##########################


#### Start of subroutine = EVAL
# overwrites=	s1-s7,t1-t4
# inputs= 	s5(pointer at NUM_BUF),s7(pointer at OP_BUF)
# outputs= 	(the result is in NUM_BUF)

EVAL:
	# prologue 
	sub $sp , $sp , 4	# PUSH stack by 4 bytes
	sw $ra , 0($sp)		# saves the return address of subroutine

	jal POP_NUM		# pop buffer(used like stack) NUM_BUF to t2 (the second number)
	move $s3 , $t2		# s3 holds the second number of the requested calculation
	
	jal POP_NUM		# pop buffer(used like stack) NUM_BUF to t2 (the first number)
	move $s1 , $t2		# s1 holds the first number of the requested calculation
	
	jal POP_OP		# pop buffer(used like stack) OP_BUF to t2 (the operation code)
	move $s2 , $t2		# s2 holds the operation code
#_________________________________________________________________________________ start of calculation
	li $t1 , 43
	bne $s2 , $t1 , noADDINT	#******** if s2!='+' branch to noADDINT
	jal ADDINT
noADDINT:			
	li $t1 , 45
	bne $s2 , $t1 , noSUBINT	# if s2!='-' branch to noSUBINT
	jal SUBINT
noSUBINT:
	li $t1 , 42
	bne $s2 , $t1 , noMULINT	# if s2!='*' branch to noMULINT
	jal MULINT
noMULINT:
	li $t1 , 47
	bne $s2 , $t1 , noDIVINT	# if s2!='/' branch to noDIVINT
	jal DIVINT
noDIVINT:
#_________________________________________________________________________________ end of calculation

	move $t6 , $s4
	jal PUSH_NUM		# pop buffer(used like stack) NUM_BUF to t2 (the second number)

	# epilogue of subroutine 
	lw $ra , 0($sp)		# pop stack (the return address)
	addi $sp , $sp , 4	# restore sp into its value(before the call of the subroutine)

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main

#### End of subroutine = EVAL

#												##########################


#### Start of subroutine = PUSH_OP
# overwrites = 
# inputs = s2(the operatot in ASCII form),s7(pointer at OP_BUF)
# outputs =
PUSH_OP:
	sb $s2 , 0($s7)		# store the register t6(the number) at the OP_BUF
	addi $s7 , $s7 , 4	# s7 points at the byte after the stored number

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = PUSH_OP
#												##########################
#### Start of subroutine = POP_OP
# overwrites=	
# inputs= 	s7(pointer at OP_BUF)
# outputs= 	t2(the operatot in ASCII form)
POP_OP:
	sub $s7 , $s7 , 4	# s7 points at the byte before the loaded number
	lb $t2 , 0($s7)		# load the word from OP_BUF to register t2
	
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = POP_OP
#												##########################
#### Start of subroutine = PUSH_NUM
# overwrites = 
# inputs = t6(number),s5(pointer at the buffer)
# outputs =
PUSH_NUM:
	sw $t6 , 0($s5)		# store the register t6(the number) at the NUM_BUF
	addi $s5 , $s5 , 4	# s5 points at the byte after the stored number

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = PUSH_NUM
#												##########################
#### Start of subroutine = POP_NUM
# overwrites=	
# inputs= 	s5(pointer at NUM_BUF)
# outputs= 	t2(the number)
POP_NUM:
	sub $s5 , $s5 , 4	# s5 points at the byte before the loaded number
	lw $t2 , 0($s5)		# load the word from NUM_BUF to register t2

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = POP_NUM
#												##########################
#### Start of subroutine = ADDINT
# overwrites=				# the program prints error1 if any number has more than 5 digits
# inputs= 	s1,s3			# so the result may have at most 6 digits which can be always stored in a 32-bit register
# outputs= 	s4			# therefore there is no need for overflow
ADDINT:
	add $s4 , $s1 , $s3
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = ADDINT
#												##########################
#### Start of subroutine = SUBINT
# overwrites=				# the program prints error1 if any number has more than 5 digits
# inputs= 	s1,s3			# so the result may have at most 6 digits which can be always stored in a 32-bit register
# outputs= 	s4			# therefore there is no need for overflow
SUBINT:
	sub $s4 , $s1 , $s3
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = SUBINT

#												##########################


#### Start of subroutine = MULINT
# overwrites=	t1( temporary register ),t2(counter),t3( temporary register ),t4(Gamma)
# inputs= 	s1,s3
# outputs= 	s4(T is needed after the subroutine MULINT ,so it is saved in a callee-save register(s4))
MULINT:

	li $t1 , 0		# t1=sign of s1		(0 for positives and 1 for negatives)
	li $t3 , 0		# t3=sign of s3

	bgez $s1 , no_negative_s1	# if( s1>=0 ) branch to  no_negative_s1
	li $t1 , 1
	abs $s1 , $s1		# we will use the absolute value of s1

no_negative_s1:
	bgez $s3 , no_negative_s3	# if( s3>=0 ) branch to  no_negative_s3
	li $t3 , 1
	abs $s3 , $s3		# we will use the absolute value of s3

no_negative_s3:
	xor $t3 , $t1 , $t3	# the sign of the result is the xor function of the 2 signs

	li $t2 , 1		# t2 = counter = 1
	li $t4 , 0		# Gamma
	li $s4 , 0		# initialization of s4
#********************************************************************************************* start of the loop of multiplication
loop:
	li $t1 , 1		# (in binary form) t1=00...01
	and $t1 , $t1 , $s3	# t1 = 00...0(R0)
	beqz $t1 , R0_is_0	# if (R0==0) branch to R0_is_0

	add $t4 , $t4 , $s1	# Gamma = Gamma + P

R0_is_0:
	srl $s4 , $s4 , 1	# T>>1
	li $t1 , 1		# (in binary form) t1=00...01
	and $t1 , $t1 , $t4	# t1 = 00...0(Gamma0)
	sll $t1 , $t1 , 31	# t1 shifts left by the distance=31
	add $s4 , $s4 , $t1	# the MSB of T is Gamma0(the MSB of t1)

	srl $t4 , $t4 , 1	# Gamma>>1
	srl $s3 , $s3 , 1	# R>>1

	addi $t2 , $t2 , 1	# counter = counter + 1
	li $t1 , 32
	bleu $t2 , $t1 , loop	# if(counter<=32) branch to loop
#********************************************************************************************* end of the loop of multiplication

	beqz $t4 , no_Overflow	# if( Gamma==0 ) branch to no_Overflow

	li $s6 ,2		# (so we have overflow) error_code=2
	jal checkError		# call subroutine to print error message and branch to main

no_Overflow:
	beqz $t3 , no_negative_s4	# if( t3==0 ) branch to no_negative_s4
	li $t4 , -1
	mul $s4 , $s4 , $t4	# s4 = (-1)*s4 (there is no overflow)

no_negative_s4:
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = MULINT

#												##########################


#### Start of subroutine = DIVINT
# overwrites=	t1( x = number of significant bits of Y , counter of main_loop),t2(holds the sign of s3 and of the result)
#		t3( y = number of significant bits of K )
#		t4( temp. use and v = x-y+1 ),
# inputs= 	s1(Y=dividend) , s3(K=divider) ,
# outputs= 	s4(holds 31 and then it is P=quotient)
DIVINT:

	bnez $s3 , no_div_with_0# if( s3!=0 ) branch to no_div_with_0
	li $s6 ,3		# division with zero (s6=error_code=3)
	jal checkError		# call subroutine to print error message and branch to main

no_div_with_0:
	li $t4 , 0		# t4=sign of s1		(0 for positives and 1 for negatives)
	li $t2 , 0		# t2=sign of s3

	bgez $s1 , positive_s1	# if( s1>=0 ) branch to positive_s1
	li $t4 , 1
	abs $s1 , $s1		# we will use the absolute value of s1

positive_s1:
	bgez $s3 , positive_s3	# if( s3>=0 ) branch to positive_s3
	li $t2 , 1
	abs $s3 , $s3		# we will use the absolute value of s3

positive_s3:
	xor $t2 , $t4 , $t2	# the sign of the result is the xor function of the 2 signs
	
	bge $s1 , $s3 , s1_greater_or_equal_to_s3	# if( s1>=s3 ) branch to s1_greater_or_equal_to_s3
	li $s4 , 0		# s1<s3 => s1/s3=0
	b positive_s4
s1_greater_or_equal_to_s3:
#**************************************************************************************** calculation of the significant bits of s1
	li $t1 , 0		# x=0
	move $t4 , $s1		# saves temporarily s1 into t4

loop_x:
	srl $t4 , $t4 , 1	# shifts right t4 by the distance=1
	addi $t1 , $t1 , 1	# x = x+1
	bnez $t4 , loop_x	# if( t4!=0 ) branch to loop_x
#**************************************************************************************** end of calculation of the significant bits of s1

#**************************************************************************************** calculation of the significant bits of s3
	li $t3 , 0		# y=0
	move $t4 , $s3		# saves temporarily s3 into t4

loop_y:
	srl $t4 , $t4 , 1	# shifts right t4 by the distance=1
	addi $t3 , $t3 , 1	# y = y+1
	bnez $t4 , loop_y	# if( t4!=0 ) branch to loop_y
#**************************************************************************************** end of calculation of the significant bits of s3

	li $s4 , 31
	sub $t4 , $s4 , $t1	# t4 = 31-x
	sllv $s1 , $s1 , $t4	# shifts left Y by the distance=31-x

	sub $t4 , $s4 , $t3	# t4 = 31-y
	sllv $s3 , $s3 , $t4	# shifts left K by the distance=31-y

	sub $t4 , $t1 , $t3	# t4 = x-y	(end of x's life)
	addi $t4 , $t4 , 1	# v = t4 = (x-y)+1

	li $t1 , 1		# counter = 1	(t1 was the register for x)
	li $s4 , 0		# P=0 (initialize of the result)
#**************************************************************************************** start of the main loop of division
main_loop:
	sll $s4 , $s4 , 1	# shifts left P by the distance=1
	bltu $s1 , $s3 , smaller# if( Y < K ) branch to smaller

	subu $s1 , $s1 , $s3	# Y = Y-K
	add $s4 , $s4 , 1	# P = P+1

smaller:
	beq $t1 , $t0 , last_loop	# if( counter == v ) branch to last_loop
	sll $s1 , $s1 , 1	# shifts left Y by the distance=1

last_loop:
	addi $t1 , $t1 , 1	# counter = counter+1
	bleu $t1 , $t4 , main_loop	#if( counter <= v ) branch to main_loop
#**************************************************************************************** end of the main loop
	beqz $t2 , positive_s4	# if( t2==0 ) branch to positive_s4
	li $t4 , -1
	mul $s4 , $s4 , $t4	# s4 = (-1)*s4 (there is no overflow)

positive_s4:
	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = DIVINT

#												##########################

#### Start of subroutine = BIN_to_ASCII
# overwrites=	t1,t2,t3,t4,(reversed_string buffer)
# inputs= 	s4(number)
# outputs= 	final_string
BIN_to_ASCII:
	bgez $s4 , itoA_start	# if(s4>=0) branch to itoA_start
	li $t1 , 45		# (so s4<0 )t1 holds '-'
	li $t2 , -1
	mul $s4 , $s4 , $t2	# multiple s4 with -1 (without checking overflow)

itoA_start:
	la $t2 , reversed_string# t2 is a pointer at reversed_string
	li $t3 , 10		# t3=='\n'
	sb $t3  0($t2)		# store '\n' at the beginning of the buffer (reversed_string)

itoAloop:
	div $s4 , $t3		# division : integer / 10  	(register t3 is kept for this operation)
	mfhi $t4		# t4 = remainder
	mflo $s4		# s4 = quotient
	addi $t4 , $t4 , 48	# eg. 1 + 48 = '1'
	
	sub $t2 , $t2 , 1	# t2 shifts one position to the left ( little endian representation )
	sb $t4 , 0($t2)		# eg. stores (t4) the character '1' at byte in which $t2 points	

	bnez $s4 , itoAloop	# if(s4!=0) branch to itoAloop

	li $t3 , 45
	bne $t1 , $t3 , reverse_start	# if(t1!='-') branch to reverse_start
	sub $t2 , $t2 , 1	# t2 shifts one position to the left ( little endian representation )
	sb $t1 , 0($t2)		# (so s4<0)stores '-' at byte in which $t2 points(after the last character of the reversed_string)

reverse_start:
	la $t3 , final_string	# t3 is a pointer at final_string(which is the string to be printed)

reverseLoop:
	lb $t1 , 0($t2)		# load the byte in which $t2 points, at $t1
	sb $t1 , 0($t3)		# store $t1 in the byte in which $t3 points

	addi $t2 , $t2 , 1	# t2 shifts one position to the right( little endian representation ),to the previous address
	addi $t3 , $t3 , 1	# t3 shifts one position to the right( big endian representation ), to the next address
	li $t4 , 10		# t4 = '\n'
	bne $t1 , $t4 , reverseLoop	# if(t1!='\n') branch to reverseLoop

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 

#### End of subroutine = BIN_to_ASCII

#												##########################


#### Start of subroutine = print_output
# overwrites=	v0,a0
# inputs= 	1 message(output),1 buffer(final_string)
# outputs= 	
print_output:

	li $v0 , 4		# store the value 4 in the register v0
	la $a0 , output		# load the address of the string's first character	
	syscall			# (do the syscall) 4 is the print_string system call code

	li $v0 , 4		# store the value 4 in the register v0
	la $a0 , final_string	# load the address of the string's first character	
	syscall			# (do the syscall) 4 is the print_string system call code

	jr $ra			# (return to main) jump on register $ra which saves the address where Program Counter stopped in main 
#### End of subroutine = print_output

#												##########################


#### Start of subroutine = atoi_loop
# overwrites= 	t1,t2
# inputs= 	t6,t5(counter),t4(the current character of the "number"),s0(pointer at the current character of the EXP_BUF)
# outputs= 	t6(is the first number in binary form),t5
atoi_loop:	
	addi $t5 , $t5 , 1	# increase counter

	li $t1 , 0		# t1=0 ,t1 is a flag if an inappropriate character is read(not '0',...,'9')
	li $t2 , 48		# t2 = 48 = '0'
	slt $t1 , $t4 , $t2	# set t1=1 if t4<'0'
	bnez $t1 , check	# if t1!=0 branch to check

	li $t2 , 57		# t2 = 57 = '9'
	sgt $t1 , $t4 , $t2	# set t1=1 if t4>'9'
	bnez $t1 , check	# if t1!=0 branch to check

stringOK:
	li $t2 , 10		# t2=10
	mult $t6 , $t2		# t6 = t6*10
	mflo $t6		# t6 is the result of the multiplication(the product)
	mfhi $t1		# check for overflow				<------for 5 decimal digits we won't have!!!
	beqz $t1, noOverflow	# if t1==0 there is no overflow
	li $s6 ,2		# (so we have overflow) error_code=2
	jal checkError		# call subroutine to print error message and branch to main

noOverflow:

	sub $t4 , $t4 , 48	# $t4 = $t4 - 48
	add $t6 , $t6 , $t4	# $t6 = $t6 + $t4
	addi $s0 , $s0 , 1	# s0 points to the next byte of the EXP_BUF
	lb $t4 , 0($s0)		# load a character of the "number" stored at EXP_BUF
	b atoi_loop		# branch to atoi_loop (all this subroutine is a loop)
return:
	jr $ra			# (return to a subroutine) jump on register $ra which saves the address where Program Counter stopped in the subroutine 
check:
	li $t2 , 1
	bne $t5 , $t2 , return
	li $s6 , 1
	jal checkError
#### End of subroutine = atoi_loop

#												##########################


#### Start of subroutine = skip_spaces
# overwrites = 	$t1(temporary)
# inputs = t2(character, $s0(pointer to the character of EXP_BUF)
# outputs = none
###### note: s0 doesn't point at the next character after the spaces(if they exist)
skip_spaces:

	li $t1 , 32		# t1=32=' '
	bne $t2 , $t1 , no_more_space	# if t2!=' ' branch to no_more_space
	addi $s0 , $s0 , 1	# s0 points at the next byte of EXP_BUF
	lb $t2 , 0($s0)
	b skip_spaces

no_more_space:
	sub $s0 , $s0 , 1
	jr $ra			# (return to a subroutine) jump on register $ra which saves the address where Program Counter stopped in the subroutine 

#### End of subroutine = skip_spaces


