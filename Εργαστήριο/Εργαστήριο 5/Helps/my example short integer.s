.data
.globl array
.globl Correct_Input
.globl Correct_Answer
.globl Information_Loss_Input
.globl Information_Loss_Answer

Correct_Input: .asciiz "Give input (matching the short value range): "
Correct_Answer: .asciiz "Correct short without information loss: "
Information_Loss_Input: .asciiz "\nGive input (larger than the short value range): "
Information_Loss_Answer: .asciiz "Print input as a short (notice the information loss): "

array: .align 2
	   .space 200

.text
.globl main
main:

la $s2, array    #s2 is the beginning address of the array

move $t1, $s2

li $v0, 4		 #Print message
la $a0, Correct_Input
syscall

li $v0, 5		       # Read input
syscall

move $s0, $v0          # s0 is the input

srl $s1, $s0, 4	       # s1 holds the top byte
andi $s0, $s0, 0x000F  # s0 hold the bottom byte

sb $s1,0($t1)	       # Store the bytes in the memory in the correct order
sb $s0,1($t1)

lb $s3,0($t1)	       # s3 holds the top byte
lb $s4,1($t1)	       # s4 holds the bottom byte

sll $s3, $s3, 4
or $s4, $s3, $s4

li $v0, 4
la $a0, Correct_Answer
syscall

li $v0, 1
move $a0, $s4
syscall

li $v0, 10
syscall