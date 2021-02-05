
.data

EXP_BUF: 	.space 128
string:   	.space 128
operation:	.asciiz "-+*/"
newline:	.asciiz "\n"
minus:		.asciiz "-"
zero:		.asciiz "0"
askoper:	.asciiz "Enter an operation : "
exception: 	.asciiz "Error occured!"
errorstr:	.asciiz "Divide by zero"
divzero:	.asciiz"0"
overstr:	.asciiz"Overflow!" 
operandstr:    	.asciiz"Illegal operand"
operationstr:	.asciiz"Illegal operation"

	
	.text
      	.globl main
main:
		
	jal input
	
	jal mainProcess
	

	move $s0, $v0

	beq $v1, $zero, noMinus
	
	
	# Print minus
	li	$v0, 4			# print string
	la	$a0, minus		# string to be printed is in "variable" minus
	syscall
	
	noMinus:
	move $a0, $s0
	jal toascii
	
	# Print the result string
	li   	$v0, 4 		# 4 is the code for print string 
	la   	$a0, string	# string to be printed is in "variable" askint
	syscall

	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	
	j main
	
ERROR:
	# Print an error
	li	$v0, 4		# print string
	la	$a0, exception	# string to be printed is in "variable" exception
	syscall
		
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall

EXIT:
	j main
	li	$v0, 10
	syscall

ERROR1:
	# Print an error
	li	$v0, 4		# print string
	la	$a0,errorstr	# string to be printed is in "variable" errorstr
	syscall
		
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	j	EXIT
	
	
ERROR2:
	# Print an error
	li	$v0, 4		# print string
	la	$a0,divzero	# string to be printed is in "variable" divzero
	syscall
		
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	j	EXIT

ERROR3:
	# Print an error
	li	$v0, 4		# print string
	la	$a0,operandstr	# string to be printed is in "variable" operandstr
	syscall
		
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	j	EXIT

ERROR4:
	# Print an error
	li	$v0, 4		 # print string
	la	$a0,operationstr # string to be printed is in "variable" operationstr
	syscall
	
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	j	EXIT

Overflow:
	# Print an error
	li	$v0, 4		# print string
	la	$a0,overstr	# string to be printed is in "variable" overflow
	syscall
		
	# Print a newline
	li	$v0, 4		# print string
	la	$a0, newline	# string to be printed is in "variable" newline
	syscall
	j	EXIT

input:
    	li	$t9, 10		# t9 is the multiplier 10
	move 	$s4, $zero
	move 	$s5, $zero
	move 	$t0, $zero	# initialize $t0 == zero
	move 	$s0, $zero	# initialize s0 to zero (no -)
		
	# Print the prompt
	li   	$v0, 4 		# 4 is the code print string 
	la   	$a0, askoper	# a0 is the string to be printed and gets value from "variable" askint
	syscall
		
	# Read in the string 
	li	$v0, 8		# 8 is the code for read string
	la	$a0, EXP_BUF	# read the string from the keyboard
	la	$a1, 128	
	syscall
		
		
	lb	$t1, operation($0)	# $t1 is the value of the 'minus' symbol
	lb	$t3, EXP_BUF($t0)	# $t3 is the first value of the string EXP_BUF
	
	move 	$s0, $zero
	move 	$t4, $t0
	beq	$t1, $t3, minuscheck
	j	iteration1

minuscheck:				# check if the first value is '-'
	addi 	$t0, $t0, 1		# go to the next number
	addi 	$s0, $s0, 1		# save '-'in $s0
	move 	$t4, $t0
		
iteration1:
	lb	$t3, EXP_BUF($t0)		
	li	$t2,48
	move 	$t8, $t2
	blt	$t3, $t2,process1		# if the character is out of range
	li	$t2,57
	bgt 	$t3, $t2,process1
		
atoi:		
	mul	$s4, $s4, $t9			# multiply $s4 by 10
	add	$s4, $s4, $t3			# add $t3 to $s4
	sub	$s4, $s4, $t8			# subtract '0' from $s4
	addi 	$t0, $t0, 1			# go to the next byte
	j	iteration1			# next iteration

process1:
	beq 	$t4, $t0, ERROR3
	lb	$t3, EXP_BUF($t0)
	move 	$t4, $zero
	lb 	$t2, operation($t4)
	beq 	$t2, $t3,tosub
	addi 	$t4, $t4, 1			# increase the counter
	lb 	$t2, operation($t4)
	beq 	$t2, $t3,toAdd
	addi 	$t4, $t4, 1			# increase the counter
	lb 	$t2, operation($t4)
	beq 	$t2, $t3, toMul
	addi 	$t4, $t4, 1			# increase the counter
	lb 	$t2, operation($t4)
	beq 	$t2, $t3, toDiv
	j ERROR4
		
tosub:
	li 	$s1, 0
	j selection

toAdd:
	li 	$s1, 1
	j selection

toMul:
	li 	$s1, 2
	j selection

toDiv:
	li 	$s1, 3
		
selection:
	addi 	$t0, $t0, 1			# go to the next byte
	lb	$t3, EXP_BUF($t0)
	move 	$t4, $t0
	beq	$t1, $t3, minuscheck1		# check if there is a preceding '-'
	j	iteration2

minuscheck1:
	addi 	$t0, $t0, 1			# go to the next number
	addi 	$s0, $s0, 2			# save the '-' in $s0 
	move 	$t4, $t0

iteration2:
	lb	$t3, EXP_BUF($t0)	
	li 	$t2,48
	move	$t8, $t2
	blt	$t3, $t2, process2		# if the character is out of range
	li 	$t2,57
	bgt 	$t3, $t2, process2
		
atoi2:		
	mul	$s5, $s5, $t9			# multiply $s4 by 10
	add	$s5, $s5, $t3			# add $t3 to $s4
	sub	$s5, $s5, $t8			# subtract '0' from $s5
	addi 	$t0, $t0, 1			# go to the next byte
	j	iteration2				# next iteration

process2:
	beq 	$t4, $t0, ERROR3
	lb	$t3, EXP_BUF($t0)		
	lb	$t2, newline($zero)
	bne 	$t3, $t2, ERROR
	li	$t9, 99999
	bgtu 	$s4, $t9,ERROR3 
	bgtu	$s5, $t9, ERROR3
	jr $ra

mainProcess:
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$t0, 0
	beq 	$s1, $t0, subL
	li	$t0, 1
	beq 	$s1, $t0, addL
	li	$t0, 2
	beq 	$s1, $t0, mulL	
	li	$t0, 3
	beq 	$s1, $t0, divL
		
subL:
	li	$t0, 0
	beq $s0, $t0, subL0
	li	$t0, 1
	beq $s0, $t0, subL1
	li	$t0, 2
	beq $s0, $t0, subL2
	li	$t0, 3
	beq $s0, $t0, subL3
				
subL0:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal SUBINT	
	li	$v1, 0
	j end
			
subL1:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal ADDINT
	li	$v1, 1		#store 1 to the $v1 return value if there is an overflow
	j end
subL2:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal 	ADDINT
	li	$v1, 0
	j 	end
		
subL3:			
	move $a1, $s4		# $a1 is the first argument
	move $a0, $s5		# $a0 is the second argument
	jal 	SUBINT
	li	$v1, 0
	j end

addL:
	li	$t0, 0
	beq $s0, $t0, addL0
	li	$t0, 1
	beq $s0, $t0, addL1
	li	$t0, 2
	beq $s0, $t0, addL2
	li	$t0, 3
	beq $s0, $t0, addL3	
			
addL0:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal ADDINT
	li	$v1, 0
	j end
			
addL1:
	move $a1, $s4		# $a1 is the first argument
	move $a0, $s5		# $a0 is the second argument
	jal SUBINT
	li	$v1, 0
	j end

addL2:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal SUBINT
	li	$v1, 0
	j end

addL3:
	move $a0, $s4		# $a0 is the first argument
	move $a1, $s5		# $a1 is the second argument
	jal ADDINT
	li	$v1, 1		#store 1 to the $v1 return value if there is an overflow
	j end
			
mulL:
	li	$t0, 0
	beq $s0, $t0, mulL1
	li	$t0, 2
	beq $s0, $t0, mulL2
	li	$t0, 1
	beq $s0, $t0, mulL2
	li	$t0, 3
	beq $s0, $t0, mulL1
		
		
mulL1:
	move $a0, $s4		#t2 is the multiplier
	move $a1, $s5		#t3 is the multiplicand
	jal MULINT
	li	$v1, 0
	j end
	
mulL2:
	move $a0, $s4		#t2 is the multiplier
	move $a1, $s5		#t3 is the multiplicand
	jal MULINT
	li	$v1, 1		#store 1 to the $v1 return value if there is an overflow
	j end	

divL:
	li	$t0, 0
	beq 	$s0, $t0, divL1
	li	$t0, 1
	beq 	$s0, $t0, divL2
	li	$t0, 2
	beq 	$s0, $t0, divL2	
	li	$t0, 3
	beq 	$s0, $t0, divL1	
	

divL1:
	move 	$a0, $s4		# $a0 is the Dividend
	move 	$a1, $s5		# $a1 is the Divisor
	beqz 	$a1, ERROR1
	bgtu 	$a1, $a0, ERROR2
	jal DIVINT
	li	$v1, 0
	j end
	
divL2:	
	move 	$a0, $s4		# $a0 is the Dividend
	move 	$a1, $s5		# $a1 is the Divisor
	beqz 	$a1, ERROR1
	bgtu 	$a1, $a0, ERROR2
	jal 	DIVINT
	li	$v1, 1
	j end
	
end:
	lw	$ra, 0($sp)		#restore the return address
	addi 	$sp, $sp, 4		#restore the stack pointer
	jr 	$ra			#return to the caller procedure
		

toascii:
	la  $a1,string	 # load the address of string into a1	

itoa:
	move $t0,$a0	 # move the number into t0	
	move $t3,$a1	 # move the address of string into t3
	bgez $a0,nonNeg	 # if number is positive goto label
	sub  $a0,$0,$a0	 # else calculate the absolute value	

nonNeg:
	li  $t2,10       # load the value 10 into t2

itoaLoop:
	div $a0,$t2        # do the division 
	mfhi $t1       	   # move the quotient into t1 
	mflo $a0	   # move the reminder into a0
	addi $t1,$t1,48    # do the addition
	sb  $t1,0($a1)     # store the number
	add $a1,$a1,1      # increase pointer
	bnez $a0,itoaLoop  # if (reminder !=0) do the loop again
	bgez $t0,nonNeg2   # check the sign, if positive goto label
	li  $t1,'-'        # load the negative sign
	sb  $t1,0($a1)     # store the sign
	addi $a1,$a1,1     # increase pointer	

nonNeg2:
	sb  $0,0($a1)      # store the "\n"
	move $a0,$t3       # prepare to do the reversion

reverse:
	addi $t2,$a0,-1    # j=s-1
	lbu  $t3,1($t2)    # while ( *(j+1) )
	beqz $t3,endStrlen

strlenLoop:
	addi $t2,$t2,1	   # j++	
	lbu  $t3,1($t2)
	bnez $t3,strlenLoop

endStrlen:		       # now j = &s[ strlen(s)-1 ]
	bge  $a0,$t2,endReverse # while ( i<j )

reverseLoop:                    # {
	lbu  $t3,($a0)          #    $t3=*i
	lbu  $t4,($t2)		#    $t4=*j	
	sb   $t3,($t2)	        #    *i=$t4
	sb   $t4,($a0)          #    *j=$t3
	addi $a0,$a0,1          #     i++
	addi $t2,$t2,-1         #     j--
	blt  $a0,$t2,reverseLoop

endReverse:
	 jr $ra
	

#Add Function
ADDINT:
	add $v0, $a0, $a1
	jr $ra			#return to the caller procedure

#Sub Function
SUBINT:
	sub $v0, $a0, $a1
	jr $ra			#return to the caller procedure

# Multiplication function
MULINT:
	move $t0, $zero		#initialize to zero (G)
	move $t1, $zero		#initialize to zero (T)
	move $t2, $a0		#t2 is the multiplier
	move $t3, $a1		#t3 is the multiplicand
	
	addi $sp, $sp, -4
	sw	$ra, 0($sp)
		
	li $t4, 2			#initilize $t4 to 2
	li $t7, 32			#iterate for 32 times; counter($t7)

	#the multiplication loop
iterateMUL:				
	remu $t5, $t2, $t4		#see if the last number($t2) is 0 or 1
	beqz $t5, mulShift		#if it is zero no operation
	move $a0, $t0			#load the first argument
	move $a1, $t3			#load the second argument
	jal ADDINT			#call the ADDINT procedure
	move $t0, $v0			#store the first argument
	move $t6, $v1			#store the second argument
mulShift:
	srl	$t2, $t2, 1		#shift right the multiplier
	srl	$t1, $t1, 1		#shift right the (T)
	remu 	$t5, $t0, $t4		#see if the last number($t0) is 0 or 1		
	li	$t9, 2147483648
	beqz 	$t5, shiftZero		#if it is zero no operation
	or	$t1, $t1, $t9		#use or to make the first digit of T equal to 1
shiftZero:
	srl	$t0, $t0, 1		#shift right the (G)
	beqz 	$t6, mulloOp
	#or	$t0, $t0, $t9		#use or to make the first digit of G equal to 1
mulloOp:
	addi $t7, $t7, -1		#subtract 1 to the counter($t7)
	bnez $t7, iterateMUL		#stop or continue iteration	
	move $v0, $t1			#pass the return value
	move $v1, $zero			#load 0 to the $v1 return value
	beqz $t0, mulEnd
	li $v1, 1			#store 1 to the $v1 return value if there is an overflow
mulEnd:
	bnez $t0, ERROR			
	li $t8, 99999
	bgt $v0, $t8,Overflow
epilogue:	
	lw	$ra, 0($sp)		#restore the return address
	addi 	$sp, $sp, 4		#restore the stack pointer
	jr $ra				#return to the caller procedure

# Division function
DIVINT:
	move $t0, $zero		#initialize to zero the quotient
	move $t1, $zero		#initialize to zero the remainder
	move $t2, $a1		#t2 is the divisor
	move $t3, $a0		#t3 is the dividend
	li   $t4, -2147483648 	#t4 is used to count divident(or divisor)digits
	li   $t5, -3		#initialize to -1 the digit counter(dividend)
	li   $t7, -3		#initialize to -1 the digit counter(divisor)
	move $t6, $zero		#initialize to zero the help register
	li   $t9,-2		#t9 takes a value in order to make the q0=0
	li   $t8,1		#t8 takes a value in order to make the q0=1
	addi $sp, $sp, -4
	sw	$ra, 0($sp)
		
counterDividend:
	move    $a0, $t5	#load the first argument
	li      $a1, 1		#load the second argument
	jal ADDINT		#call the ADDINT procedure
	move    $t5, $v0	#store the first argument
	and	$t6, $t3, $t4
	srl	$t4, $t4, 1
	beqz	$t6, counterDividend
	sllv	$t3, $t3, $t5
	move $t6, $zero		#initialize to zero the help register		
	li   $t4, -2147483648 	#t4 is used to count dividend digits

counterDivisor:
	move    $a0, $t7	#load the first argument
	li      $a1, 1		#load the second argument
	jal ADDINT		#call the ADDINT procedure
	move    $t7, $v0	#store the first argument
	and	$t6,$t2,$t4
	srl	$t4,$t4,1
	beqz	$t6,counterDivisor
	sllv	$t2,$t2,$t7
	move $t6, $zero		#initialize to zero the help register		
	move $a0, $t7		#load the first argument
	move $a1, $t5		#load the second argument
	jal SUBINT		#call the ADDINT procedure
	move $t6, $v0		#store the first argument
	move    $a0, $t6	#load the first argument
	li      $a1, 1		#load the second argument
	jal ADDINT		#call the ADDINT procedure
	move    $t6, $v0	#store the first argument
	move	$t1,$t3
	li	$t5, 1		#from now on $t5 is i counter

iterateDiv:
	move $a0, $t1		#load the first argument
	move $a1, $t2		#load the second argument
	jal SUBINT		#call the ADDINT procedure
	move $t1, $v0		#store the first argument
	bltz	$t1,RemNeg	

RemPos:
	sll	$t0,$t0,1
	or	$t0, $t0, $t8	#use or to make the first digit equal to 1
	blt	$t5,$t6,iterationEnd
	j	exitDiv

RemNeg:
	move    $a0, $t1	#load the first argument
	move    $a1, $t2	#load the second argument
	jal ADDINT		#call the ADDINT procedure
	move    $t1, $v0	#store the first argument
	sll	$t0,$t0,1
	and	$t0, $t0, $t9	#use or to make the first digit equal to 0
	beq	$t5,$t6,exitDiv	

iterationEnd:
	sll	$t1,$t1,1	#shift remainder one pos left
	move    $a0, $t5	#load the first argument
	li      $a1, 1		#load the second argument
	jal ADDINT		#call the ADDINT procedure
	move    $t5, $v0	#store the first argument
	j	iterateDiv	

exitDiv:
	
	lw	$ra, 0($sp)	#restore the return address
	addi 	$sp, $sp, 4	#restore the stack pointer
	move 	$v0, $t0	
	move 	$v1, $zero	#load 0 to the $v1 return value if there is no overflow
	jr 	$ra	
