
.data
#data for main
menu: .asciiz "\n What do you want to do? \n"
menu1: .asciiz "1. Print pyramid. \n"
menu2: .asciiz "2. Check if a number is even or odd. \n"
menu3: .asciiz "3. Multiply numbers by four. \n"
menu4: .asciiz "4. Change uppers and lowers letters. \n"
choice: .asciiz "Please enter your choice: "
space1: .asciiz "\n"
error: .asciiz " \n The number you have entered is invalid. Try again. \n"

#data for function 1
numOfRows: .asciiz "Enter the number of rows you want: "
positiveCheck: .asciiz "Please enter only positive numbers. \n"
totalSum: .asciiz "The result of all elements added is: \n"
space: .asciiz "\n"
tab: .asciiz "\t"

#data for function 2
enterNumber: .asciiz "Give the number you want to check \n"
even: .asciiz "The number is even \n"
odd: .asciiz "The number is odd \n"

#data for function 3
arrayA: .space 20
	.align 2
arrayB: .space 20 
	.align 2
giveNums: .asciiz "Give me the 5 numbers you want to multiply by 5. \n"
enterNum: .asciiz "Enter the number: "
input: .asciiz " --- INPUT --- \n"
output: .asciiz " --- OUTPUT --- \n"
result: .asciiz "\n --- The result is: "
newLine: .asciiz "\n"

#data for function 4 
array_a:.space 100
	.align 1
array_b:.space 100
	.align 1
enterStr: .asciiz "Please enter the string you want: "
modifiedStr: .asciiz "The modified string is: \n" 


.text

#MAIN
main_while_1: 

	addi $t0, $zero ,0	#print Menu
	addi $v0, $zero, 4
	la $a0, menu
	syscall
	addi $v0, $zero, 4
	la $a0, menu1
	syscall
	addi $v0, $zero, 4
	la $a0, menu2
	syscall
	addi $v0, $zero, 4
	la $a0, menu3
	syscall 
	addi $v0, $zero, 4
	la $a0, menu4
	syscall
	addi $v0, $zero, 4
	la $a0, choice 
	syscall 
	li $v0, 5
	syscall
	add $t0, $zero, $v0		#store choice to $t0
after_if_1a:	
	addi $t1, $zero, 1	
	bne $t0, $t1, after_if_2	#if choice=1, run this part
	addi $v0, $zero, 4
	la $a0, space1
	syscall
	jal printPyramid 
	
	j main_while_1
	
after_if_2:
	addi $t1, $zero, 2
	bne $t0, $t1, after_if_3	#if choice=2, run this part
	addi $v0, $zero, 4
	la $a0, space1
	syscall
	jal checkNumber
	
	j main_while_1
	
after_if_3:
	addi $t1, $zero, 3 
	bne $t0, $t1, after_if_4	#if choice=3, run this part 
	addi $v0, $zero, 4
	la $a0, giveNums
	syscall 
	addi $v0, $zero, 4
	la $a0, input
	syscall 
	la $s1, arrayA			#store array A[0] to s1
	la $s2, arrayB			#store array B[0] to s2
	
	add $t7, $zero, $s1		#temporary store s1 to t7 
	addi $t8, $zero, 0
	addi $t9, $zero, 5
if_label_2_1:				#while loop to enter 5 numbers and to store them in arrayA
	sge $t5, $t8, $t9
	bne $t5, $zero, after_if_2_1
	
	addi $v0, $zero, 4
	la $a0, enterNum
	syscall
	addi $v0, $zero, 5
	syscall
	add $t3, $zero, $v0
	sw $t3, 0($t7)
	addi $t7, $t7, 4
	addi $t8, $t8, 1
	j if_label_2_1
	
after_if_2_1:
	la $s2, arrayB

	add $t7, $zero, $s1
	
	jal multiplyNum
	
	add $t7, $zero, $s2
	
	addi $v0, $zero, 4
	la $a0, output
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 5
if_label_2_2:

	sge $t5, $t0, $t1
	bne $t5, $zero, main_while_1
	
	addi $v0, $zero, 4
	la $a0, result
	syscall
	lw $a0, 0($s2)
	addi $v0, $zero, 1
	syscall
	
	addi $s2, $s2, 4 
	addi $t0, $t0, 1
	
	j if_label_2_2
	
after_if_4:
	addi $t1, $zero, 4
	bne $t0, $t1, after_if_6	#if choice=4, run this part
	
	la $s4, array_a
	la $s5, array_b

	addi $v0, $zero, 4
	la $a0, enterStr
	syscall
	
	addi $v0, $zero, 8
	la $a0, array_a
	addi $a1, $zero, 100
	syscall
	
	la $s5, array_b
	add $t7, $zero, $s4
	add $a0, $zero, $s4

	jal modifyString

	add $t7, $zero, $s5

	addi $v0, $zero, 4
	la $a0, modifiedStr
	syscall 	
	li $v0, 4
	la $a1, array_b
	addi $a2, $zero, 100
	#move $s5, $a0
	syscall 
	
	
	#li $v0, 4
	#la $a1, array_b 
	#syscall 
	
	j main_while_1

after_if_5: 
	addi $t1, $zero, 4
	bne $t0, $t1, after_if_6 
	li $v0, 10
	syscall
	
after_if_6:
	addi $t1, $zero, 4
	li $v0, 4
	la $a0, error
	syscall
	bgt $t0, $t1, main_while_1
	

#FUNCTION 1
printPyramid:

do_while_label:
while_1A:
	addi $v0, $zero, 4
	la $a0, numOfRows
	syscall
	addi $v0, $zero, 5
	syscall
	add $s1, $zero, $v0
	
	slt $t8, $zero, $s1
	bne $t8, $zero, after_label_1
	addi $v0, $zero, 4
	la $a0, positiveCheck
	syscall
	j while_1A

after_label_1:

	addi $t0, $zero, 1
	addi $t1, $zero, 1
	add $t4, $zero, $zero 
	add $t5, $zero, $zero
	add $t2, $zero, $s1
for_label_1: 
	slt $t8, $t2, $t0
	bne $t8, $zero, after_for_1
	addi $t1, $zero, 1
for_label_2:
	
	slt $t8, $t0, $t1
	bne $t8, $zero, after_for_2 
	addi $v0, $zero, 1
	add $a0, $zero, $t1
	syscall
	addi $v0, $zero, 4
	la $a0, tab
	syscall
	addi $t1, $t1, 1
	j for_label_2
after_for_2:
	addi $t0, $t0,1
	addi $v0, $zero, 4
	la $a0, space
	syscall
	j for_label_1
after_for_1:	
	addi $v0, $zero, 4
	la $a0, totalSum
	syscall
 	
 	addi $t1, $s1, 1
	mult $t1, $s1
	mflo $t1
	srl  $t1, $t1, 1
	
	addi $v0, $zero, 1
	add $a0, $zero, $t1
	syscall
	
	addi $v0, $zero, 4
	la $a0, space
	syscall
	jr $ra
	
#FUNCTION 2
checkNumber:
while1B: 
	addi $v0, $zero, 4
	la $a0, enterNumber
	syscall 
	addi $v0, $zero, 5
	syscall 
	add $s2, $v0, $zero
	
if_label_1:
	addi $t8,$t8,-1
	addi $t9,$zero, 0
	sge $t5, $s2, $t9
	bne $t5, $zero, after_if_1
	mul $s2, $s2, -1
	
after_if_1:
	add $t0, $s2, $zero
	
if_label_2:
	blt $t0, 2, if_label_3
	addi $t0, $t0, -2
	j if_label_2 
if_label_3:
	bne  $t0, $zero, else_label
	addi $v0, $zero, 4
	la $a0, even 
	syscall
	j after_cond
else_label:
	addi $v0, $zero, 4
	la $a0, odd
	syscall
	
after_cond:
	jr $ra


#FUNCTION 3
multiplyNum:
		
	add $t8, $zero, $s1	#move arrayA to register t8
	add $t9, $zero, $s2	#move arrayB to register t9
	
	addi $t4, $zero, 0	#output = 0
	addi $t0, $zero, 0	#i = 0
	addi $t1, $zero, 5
if_label_1c: 
	
	sge $t5, $t0, $t1
	bne $t5, $zero, end_if_1
	addi $t2, $zero, 0
	lw $t3, 0($t8)	#input = A[0]

	sll  $t3, $t3, 2 #multiply by 2^2

#if_label_2c:
#	li $t4, 0	#j = 0
#	bge $t3, $t1, end_if_2
#	add $t4, $t4, $t3
#	addi $t4, $t4, 1
#	j if_label_2c

end_if_2: 
	sw $t3, 0($t9)
	addi $t9, $t9, 4
	addi $t8, $t8, 4
	addi $t0, $t0, 1
	addi $t4, $zero, 0
	j if_label_1c
end_if_1: 
	#move $s1, $t8
	#move $s2, $t9
	
	jr $ra
	
#FUNCTION 4
modifyString:
	addi $t0, $zero, 0
	#move $t8, $s4	#move array_a to t8
	#move $t9, $s5	#move array_b to t9
	
	
	addi $t1, $zero, 100
if_label_1d:
	move $t8, $s4
	move $t9, $s5
	sge $t5, $t0, $t1
	bne $t5, $zero, end_if
if_label_2d:
	lb  $t2, 0($t8)
	addi $t3, $zero, 64
	addi $t4, $zero, 91
	sle  $t5, $t2, $t3
	bne $t5, $zero, else_lbl_1d
	#addi $t4, $zero, 91
	sge $t6, $t2, $t4
	bne $t6, $zero, else_lbl_1d
	lb  $t7, 0($t9)
	addi $t6, $zero, 32
	add $t7, $t2, $t6
	addi $t2, $t2, 1
	addi $t7, $t7, 1
	addi $t0, $t0, 1
	j if_label_1d
else_lbl_1d:
	
	addi $t3, $zero, 96
	ble $t2, $t3, else_lbl_2d
	sle $t5, $t2, $t3
	bne $t5, $zero, else_lbl_2d
	addi $t4, $zero, 123
	bge $t2, $t4, else_lbl_2d
	sge $t6, $t2, $t4
	bne $t6, $zero, else_lbl_2d
	
	addi $t6, $zero, -32
	add $t5, $t2, $t6
	addi $t2, $t2, 1
	addi $t5, $t5, 1
	addi $t0, $t0, 1
	j if_label_1d
else_lbl_2d:
	
	la $t5, ($t2)
	addi $t0, $t0, 1
	j if_label_1d
end_if:

	
	jr $ra
  
	
	
	
	
	


