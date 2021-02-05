.data
#data for main
welcome:.asciiz "Hello !!! Welcome to my game! \n"
play: 	.asciiz "Would you like to play? \n"
yes:    .asciiz "->Press 1 for YES. \n"
no:	.asciiz	"->Press 2 for NO. \n"
choice:	.asciiz	"=>Your choice: "
goodbye:.asciiz "\n Goodbye... :( \n"
wa:	.asciiz	"\nWelcome Again \nLet's play... \n"
moves:	.asciiz	"You have 4 eligible moves... \n"
w:	.asciiz	"PRESS -W- TO MOVE UP. \n"
s:	.asciiz	"PRESS -S- TO MOVE DOWN. \n"
a:	.asciiz	"PRESS -A- TO MOVE LEFT. \n"
d:	.asciiz	"PRESS -D- TO MOVE RIGHT. \n"
e:	.asciiz "PRESS -E- TO SHOW SOLUTION. \n"
space:	.asciiz	"\n"
giveMove:   .asciiz "Give me your move: "
ineligible: .asciiz "==>INELIGIBLE MOVE! \n==>TRY AGAIN !!! \n"
wwcd:	.asciiz "\n WINNER WINNER CHICKEN DINNER !!! \n"

debug: .asciiz "debug\n\n"

#data for printLabyrinth
labyrinth: .asciiz "Labyrinth: \n"
temp:      .space 100


map:
	   .asciiz 		 	 "IPIIIIIIIIIIIIIIIIIII I....I....I.......I.I
										III.IIIII.I.I.III.I.I
										I.I.....I..I..I.....I
										I.I.III.II...II.I.III
										I...I...III.I...I...I
										IIIII.IIIII.III.III.I
										I.............I.I...I
										IIIIIIIIIIIIIII.I.III
										@...............I..II
										IIIIIIIIIIIIIIIIIIIII"

		.align 1

.text
main:
	addi $s0, $zero, 0		#int choice --> s0
	addi $s1, $zero, 1		#int startX = 1 -->s1
	add  $s2, $zero, $s1	#int index = startX  -->s2
	addi $s2, $zero, 1

	addi $v0, $zero, 4
	la $a0, welcome
	syscall
	addi $v0, $zero, 4
	la $a0, play
	syscall

	#USED REGISTERS: s0, s1, s2

do_while_label:
	addi $v0, $zero, 4
	la $a0, yes
	syscall
	addi $v0, $zero, 4
	la $a0, no
	syscall
	addi $v0, $zero, 4
	la $a0, choice
	syscall

	addi $v0, $zero, 5
	syscall
	add $t0, $zero, $v0

	addi $v0, $zero, 1
	move $a0, $t0
	syscall

	add $s0, $zero, $t0				#store choice to s0
	addi $t0, $zero, 1
	addi $t1, $zero, 2
	beq $s0, $t0, if_label_1	#if (choice(s0) = 1)
	beq $s0, $t1, if_label_2	#if (choice(s0) = 2)
	j do_while_label

	#USED REGISTERS: s0, s1, s2, t0, t1

if_label_2:
	addi $v0, $zero, 4
	la $a0, goodbye
	syscall
	addi $v0, $zero, 10
	syscall
if_label_1:
	addi $v0, $zero, 4
	la $a0, wa
	syscall
	addi $v0, $zero, 4
	la $a0, space
	syscall
	addi $v0, $zero, 4
	la $a0, moves
	syscall
	addi $v0, $zero, 4
	la $a0, w
	syscall
	addi $v0, $zero, 4
	la $a0, s
	syscall
	addi $v0, $zero, 4
	la $a0, a
	syscall
	addi $v0, $zero, 4
	la $a0, d
	syscall
	addi $v0, $zero, 4
	la $a0, e
	syscall
	addi $v0, $zero, 4
	la $a0, space
	syscall

	#USED REGISTERS: s0, s1, s2, t0, t1


while_label_1:
	addi $s7, $zero, 65						#s7 = @
	beq $s2, $s7, after_while

if_label_6_1:
	slt $t8, $s2, $zero					#if index<0
	bne $t8, $zero, after_if_6

	addi $s3, $zero, 231				#totalElements => s3

	sge $t8, $s2, $s3						#if index>=TotalElements(s3)
	bne $t8, $zero, after_if_6

	add $s3, $zero, $s2

	jal printLabyrinth

	#USED REGISTERS: s0, s1, s2, s3, s7, t0, t1, t8, t9

if_label_7:
	la $s5, map 							#store map to s5
	add $t5, $zero, $s5				#temporary move map from s5 to t5
	addi $t3, $s2, 1					# t3 = s2 - 1
	add $t6, $t5, $t3
	beq $t6, $s7, after_if_7

	addi $v0, $zero, 4
	la $a0, giveMove
	syscall
	addi $v0, $zero, 5
	syscall
	add $a1, $zero, $v0				#store $v0 to $a1 (userInput)

	#USED REGISTERS: s0, s1, s2, s3, s5, s7, t0, t1, t3, t5, t8, t9, a1

after_if_7:

if_label_8:									# -W- CASE
	addi $t2, $zero, 87
	bne $a1, $t2, after_if_8_1

	#USED REGISTERS: s0, s1, s2, s3, s5, s7, t0, t1, t2, t3, t5, t8, t9, a1


if_label_8_1:
	add $t6, $zero, $s5				#temporary move map from s5 to t6

	addi $t0, $zero, -21

	add $t7, $s2, $t0				  #t7 = s2 - 21
	add $t9, $t6, $t7					#save to t9 map[s2-W]

	addi $t1, $zero, 73

	bne $t9, $t1, after_if_8_1
	addi $v0, $zero, 4
	la $a0, ineligible
	syscall
	j if_label_6_1

	#USED REGISTERS: s0, s1, s2, s3, s5, s7, t0, t1, t3, t5, t8, t9, a1


after_if_8_1:
	add $t4, $zero, $s5			#temporarily move map from s5 to t4
	add $t1, $t4, $s2				#map[s2]

	addi $t5, $zero, 42

	add $t1, $zero, $t5			#map[s2] = *
	addi $t6, $zero, -21
	add $s2, $s2, $t6

else_lbl_1:
	add $t0, $zero, $s5			#temporarily move map from s5 to t0
	add $t1, $s5, $s2				#map[s2]
	bne $t1, 64, after_lbl_1
	add  $t1, $zero, 37
	jal printLabyrinth
	addi $v0, $zero, 4
	la $a0, wwcd
	syscall
	addi $t0, $zero, 0
	add $v0, $zero, $t0

after_lbl_1:
	add $t1, $s5, $s2	#map[s2]
	addi $t2, $t1, 80
	jal printLabyrinth
	j if_label_6_1

after_if_8:
if_label_9:									# -S- CASE
	addi $t0, $zero, 83
	bne $a1, $t0, after_if_9_1

if_label_9_1:
	add $t1, $zero, $s5				#temporary move map from s5 to t1

	addi $t2, $zero, 21
	add $t3, $s2, $t2				  #t3 = s2 + 21
	add $t4, $t1, $t3					#save to t4: map[s2-W]

	addi $t5, $zero, 73

	bne $t4, $t5, after_if_9_1
	addi $v0, $zero, 4
	la $a0, ineligible
	syscall
	j if_label_6_1

after_if_9_1:
	add $t0, $zero, $s5			#temporarily move map from s5 to t0
	add $t1, $t0, $s2				#map[s2]

	addi $t5, $zero, 42
	add $t1, $zero, $t5			#map[s2] = *
	addi $t6, $zero, +21
	add $s2, $s2, $t6

else_lbl_2:
	add $t0, $zero, $s5			#temporarily move map from s5 to t0
	add $t1, $t0, $s2				#map[s2]
	addi $t2, $zero, 64
	bne $t1, $t2, after_lbl_2
	addi $t3, $zero, 37
	add  $t1, $zero, $t3
	jal printLabyrinth
	addi $v0, $zero, 4
	la $a0, wwcd
	syscall
	addi $t0, $zero, 0
	add $v0, $zero, $t0
	syscall

after_lbl_2:
	add $t1, $s5, $s2				#map[s2]
	addi $t3, $zero, 80
	add $t1, $zero, $t3
	jal printLabyrinth
	j if_label_6_1

after_if_9:
if_label_10:				# -A- CASE
	addi $t0, $zero, 65
	bne $a1, $t0, after_if_9

if_label_10_1:
	addi $t1, $zero, $s5		#temporary move map from s5 to t1

	addi $t2, $zero, -1
	add $t3, $s2, $t2			#t3 = s2-1
	add $t4, $t1, $t3			#save to t4: map[s2-1]

	addi $t5, $zero, 73
	bne $t4, $t5, after_if_10_1
	addi $v0, $zero, 4
	la $a0, ineligible
	syscall
	j if_label_6_1

after_if_10_1:
	add $t0, $zero, $s5		#temporary move map from s5 to t0
	add $t1, $t0, $s2 		#map[s2]
	add $t5, $zero, 42
	add $t1, $zero, $t5		#map[s2] = *
	addi $t6, $zero, -1
	add $s2, $s2, $t6

else_lbl_3:
	add $t0, $zero, $s5		#temporary move map from s5 to t0
	add $t1, $t0, $s2			#map[s2]
	addi $t2, $zero, 64
	bne $t1, $t2, after_lbl_3
	addi $t3, $zero, 37
	add $t1, $zero, $t3
	jal printLabyrinth
	addi $v0, $zero, 4
	la $a0, wwcd
	syscall
	add $t0, $zero, 0
	add $v0, $zero, 0
	syscall

after_lbl_3:
	add $t0, $zero, $s5		#temporary move map from s5 to t0
	add $t1, $t0, $s2			#map[s2]
	addi $t3, $zero, 80
	add $t1, $zero, $t3
	jal printLabyrinth
	j if_label_6_1

after_if_10:
if_label_11:				# -D- CASE
	addi $t0, $zero, 68
	bne $a1, $t0, after_if_9

if_label_11_1:
	add $t1, $zero, $s5		#temporary move map from s5 to t1

	addi $t2, $zero, 1
	add $t3, $s2, $t1		#t3 = s2+1
	add $t4, $t1, $t3		#save to t4: map[s2+1]
	addi $t5, $zero, 73
	bne $t4, $t5, after_if_10_1
	addi $v0, $zero, 4
	la $a0, ineligible
	syscall
	j if_label_6_1

after_if_11_1:
	add $t0, $zero, $s5		#temporary move map from s5 to t0
	add $t1, $t0, $s2			#map[s2]
	add $t5, $zero, 42
	add $t1, $zero, $t5		#map[s2] = *
	addi $t6, $zero, 1
	add $s2, $s2, $t6

else_lbl_4:
	add $t0, $zero, $s5		#temporary move map from s5 to t0
	add $t1, $t0, $s2			#map[s2]
	addi $t2, $zero, 64
	bne $t1, $t2, after_lbl_4
	addi $t3, $zero, 37
	add $t1, $zero, $t3
	jal printLabyrinth
	addi $v0, $zero, 4
	la $a0, wwcd
	syscall
	add $t0, $zero, 0
	add $v0, $zero, 0
	syscall


after_if_4:
	add $t0, $zero, $s5
	add $t1, $t0, $s2
	addi $t3, $zero, 80
	add $t1, $zerp, $t3
	jal printLabyrinth
	j if_label_6_1


after_if_6:

after_while:
	jr $ra


printLabyrinth:
	addi $t0, $zero, 0	#i=0
	addi $t1, $zero, 0	#j=0
	addi $t2, $zero, 0	#k=0

	addi $v0, $zero, 4
	la $a0, labyrinth
	syscall

if_label_3:
	addi $t3, $zero, 11
	sge $t8, $t0, $t3
	beq $t8, $zero, after_if_3

if_label_4:
	addi $t4, $zero, 21
	sge $t9, $t1, $t4
	beq $t9, $zero, after_if_4

if_label_5:
	bne $t2, $s3, else_label_5

	la $s6, temp 									#store temp to s6
	add $t5, $zero, $s6						#temporarily store $s6 to $t5

	add $t3, $t5, $t1							#temp[t1]
	addi $t6, $zero, 80
	add $t3, $zero, $t6						#temp[t1] = P
	j cond

else_label_5:
	la $s5, map 					#store map to s5
	add $t8, $zero, $s5		#temporarily store $s5 to $t8
	add $t7, $t8, $t2			#map[t2]
	add $t3, $zero, $t7 	#temp[t1] = map[t2]

cond:
	addi $t3, $zero, 1
	add $t2, $t2, $t3			#k = k+1
	add $t1, $t1, $t3			#j = j+1
	j if_label_4

after_if_4:
	add $t5, $t1, $t3
	add $t6, $s6, $t5			  #temp[t1+1]
	add $t6, $zero, $zero 	#temp[t1+1] = '\0'

	addi $v0, $zero, 4
	la $a0, temp
	syscall


	addi $t3, $zero, 1
	addi $t4, $zero, 0
	add $t1, $zero, $t4
	add $t0, $t0, $t3
	j if_label_3

after_if_3:
	addi $v0, $zero, 4
	la $a0, space
	syscall

	addi $v0, $zero, 10
	syscall

leep:
	addi $t0, $zero, 0
	addi $t1, $zero, 0
for_loop:
	slte $t2, $t1, $t0
	beq $t2, $zero, after_loop
	addi $t3, $zero, 1
	add $t1, $t1, $t3
	j for_loop

after_loop:
	add $t1, $t1, $t3

	addi $v0, $zero, 10
	syscall
