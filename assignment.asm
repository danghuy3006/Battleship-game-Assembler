.data 

board1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

board2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

hit: .asciiz "HIT !!!!!!!! \n"

prompt_one_win:	.asciiz "Player 1 won!! -- Press 0 to play again --"
prompt_two_win:	.asciiz "Player 2 won!! -- Press 0 to play again --"
combat_prompt:	.asciiz "It's combat time\n"

invalid_input:	.asciiz "Your input may have been incorrect, please re-input the value\n"

ship_overlap:	.asciiz "Your ship coordinate may have been overlapped/out-ranged, please re-input from the beginning\n"

newline: .asciiz "\n"

menu:	.asciiz " ***** Welcome to Battle Ship game >( ' v ' x)< *****\n- Choose 1 to open the instruction.\n- Choose 2 to play game.\nYour choice: "

one_insert_2x1: .asciiz "Player 1 input ship 2x1: \n"
one_insert_3x1: .asciiz "Player 1 input ship 3x1: \n"
one_insert_4x1: .asciiz "Player 1 input ship 4x1: \n"
one_display:	.asciiz "\nGrid of player 1: \n" 

two_insert_2x1: .asciiz "Player 2 input ship 2x1: \n"
two_insert_3x1: .asciiz "Player 2 input ship 3x1: \n"
two_insert_4x1: .asciiz "Player 2 input ship 4x1: \n"
two_display:	.asciiz "\nGrid of player 2: \n" 

re_input: .asciiz "Please carefully check if your set up is correct, incorrect set up will affect the gameplay:\n1. Choose 1 for resetting the ships.\n2. Choose 2 for moving to the next process.\nYour choice: "

instruct: .asciiz "\nINSTRUCTION\nSet up:\n1. Each player places their ships on their 7x7 grid. The ships vary in size: 1 ship of length 4, 2 ships of length 3, and 3 ships of length 2.\n2. Ships cannot overlap or extend beyond the grid. Ships are only horizontal or vertical.\n3. The game uses the following coordinate system: columns and rows are numbered 0-6 (e.g. 1 4, 2 5).\n\nInput rule:\n1. Players will input row-value first, then column-value. Each value is separated by enter button.\n2. Two enters are inputted consecutively or backspace/delete without any value will execute the game.\n\nGameplay:\n1. Players place their ships by inputting the coordinate of bow and stern of the ship.\n2. Players take turn to announce their shots by stating the coordinates of the target (e.g. 3 2).\n3. If the shot hit the opponent's ship-box, the system will announce HIT!!!\n\nWinning:\nAll the squares of all opponent ships have been hit, the first player did that win the game.\n\nMap:\n   0  1  2  3  4  5  6\n  --------------------\n0| 0  0  0  0  0  0  0\n1| 0  0  0  0  0  0  0\n2| 0  0  0  0  0  0  0\n3| 0  0  0  0  0  0  0\n4| 0  0  0  0  0  0  0\n5| 0  0  0  0  0  0  0\n6| 0  0  0  0  0  0  0\n\nLET THE GAME BEGIN !\n\n"

one_shot: .asciiz "Player 1 shoot: \n"
two_shot: .asciiz "Player 2 shoot: \n"

top_view: .asciiz "-------------\n"
bot_view: .asciiz "-------------\nContinuing input:\n"


.text
main:
	la $a0, menu
	li $v0, 4
	syscall

	li $v0, 5
	syscall

	beq $v0, 1, instruction
	beq $v0, 2, play
	
	jal invalid_prompt
	j main	
instruction:

	la $a0, instruct
	li $v0, 4
	syscall
	
	j play
	

play:
# Initialize
	la $t7, board1
	li $t1, 7
	li $t2, 7
	jal initialize
#-------------------------------------------------------------------------------------
# P1 input

	li $t5,1
player1_2x1:

	li $v0, 4
	la $a0, one_insert_2x1
	syscall
	
	jal input_coordinate
	jal CheckValid_1
	beq $s1, $s3, horizontal2x1
	beq $s2, $s4, vertical2x1
	
	jal invalid_prompt
	
	j player1_2x1
horizontal2x1:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 1, pass2x1
	
	jal invalid_prompt
	
	j player1_2x1
	
vertical2x1:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 1, pass2x1
	
	jal invalid_prompt
	
	j player1_2x1

pass2x1:
	jal player_1_insert_ship_2x1
	
	li $v0, 4
	la $a0, top_view
	syscall
	
	la $t7, board1
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, bot_view
	syscall
	
	addi $t5, $t5, 1
	blt $t5, 4, player1_2x1
# done insert 2x1 --------------------------------------------------

	li $t5, 1

player1_3x1:

	li $v0, 4
	la $a0, one_insert_3x1
	syscall
	
	jal input_coordinate
	jal CheckValid_1
	
	beq $s1, $s3, horizontal3x1
	beq $s2, $s4, vertical3x1
	
	jal invalid_prompt
	
	j player1_3x1
horizontal3x1:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 2, pass3x1
	
	jal invalid_prompt
	
	j player1_3x1
	
vertical3x1:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 2, pass3x1
	
	jal invalid_prompt
	
	j player1_3x1

pass3x1:
					
	jal player_1_insert_ship_3x1
	
	li $v0, 4
	la $a0, top_view
	syscall
	
	la $t7, board1
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, bot_view
	syscall
	
	addi $t5, $t5, 1
	blt $t5, 3, player1_3x1
# done insert 3x1-------------------------------------
player1_4x1:
	li $v0, 4
	la $a0, one_insert_4x1
	syscall

	jal input_coordinate
	jal CheckValid_1
	beq $s1, $s3, horizontal4x1
	beq $s2, $s4, vertical4x1
	
	jal invalid_prompt
	
	j player1_4x1
horizontal4x1:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 3, pass4x1
	
	jal invalid_prompt
	
	j player1_4x1
	
vertical4x1:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 3, pass4x1
	
	jal invalid_prompt
	
	j player1_4x1

pass4x1:	
	jal player_1_insert_ship_4x1
# done insert 4x1
# display 	
	la $a0, one_display
	li $v0, 4
	syscall

	la $t7, board1
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, newline
	syscall
# check check
system1:
	li $v0, 4
	la $a0, re_input
	syscall 
	
	li $v0, 5
	syscall
	
	beq $v0, 1, play
	beq $v0, 2, next_1
	
	jal invalid_prompt
	j system1
	
next_1:

	li $t1, 50
	jal erasing
	
play_2:
#-------------------------------------------------------------------------------------
# Initialize
	la $t7, board2
	li $t1, 7
	li $t2, 7
	jal initialize

# P2 input	

	li $t5,1
player2_2x1:
	
	li $v0, 4
	la $a0, two_insert_2x1
	syscall
	
	jal input_coordinate
	jal CheckValid_2
	
	beq $s1, $s3, horizontal2x1_2
	beq $s2, $s4, vertical2x1_2
	
	jal invalid_prompt
	
	j player2_2x1
horizontal2x1_2:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 1, pass2x1_2
	
	jal invalid_prompt
	
	j player2_2x1
	
vertical2x1_2:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 1, pass2x1_2
	
	jal invalid_prompt
	
	j player2_2x1

pass2x1_2:
	
	jal player_2_insert_ship_2x1
	
	li $v0, 4
	la $a0, top_view
	syscall
	
	la $t7, board2
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, bot_view
	syscall
	
	addi $t5, $t5, 1
	blt $t5, 4, player2_2x1
# done insert 2x1------------------------------------------------------------

	li $t5, 1

player2_3x1:

	li $v0, 4
	la $a0, two_insert_3x1
	syscall

	jal input_coordinate
	jal CheckValid_2	
	
	beq $s1, $s3, horizontal3x1_2
	beq $s2, $s4, vertical3x1_2
	
	jal invalid_prompt
	
	j player2_3x1
horizontal3x1_2:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 2, pass3x1_2
	
	jal invalid_prompt
	
	j player2_3x1
	
vertical3x1_2:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 2, pass3x1_2
	
	jal invalid_prompt
	
	j player2_3x1

pass3x1_2:
	
	jal player_2_insert_ship_3x1
	
	li $v0, 4
	la $a0, top_view
	syscall
	
	la $t7, board2
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, bot_view
	syscall
	
	addi $t5, $t5, 1
	blt $t5, 3, player2_3x1
# done insert 3x1-------------------------------------
player2_4x1:
	li $v0, 4
	la $a0, two_insert_4x1
	syscall
	
	jal input_coordinate
	jal CheckValid_2
	
	beq $s1, $s3, horizontal4x1_2
	beq $s2, $s4, vertical4x1_2
	
	jal invalid_prompt
	
	j player2_4x1
horizontal4x1_2:
	sub $t2, $s2, $s4
	abs $t1, $t2
	beq $t1, 3, pass4x1_2
	
	jal invalid_prompt
	
	j player2_4x1
	
vertical4x1_2:
	sub $t2, $s1, $s3
	abs $t1, $t2
	beq $t1, 3, pass4x1_2
	
	jal invalid_prompt
	
	j player2_4x1

pass4x1_2:
			
	jal player_2_insert_ship_4x1
# done insert 4x1
# display 
	li $v0, 4
	la $a0, two_display
	syscall
		
	la $t7, board2
	li $t1, 7
	li $t2, 7
	jal display_loop
	
	li $v0, 4
	la $a0, newline
	syscall
# check check 2
system2:
	li $v0, 4
	la $a0, re_input
	syscall 
	
	li $v0, 5
	syscall
	
	beq $v0, 1, play_2
	beq $v0, 2, next_2
	
	jal invalid_prompt
	j system2

next_2:
	li $t1, 50
	jal erasing

combat:
	li $v0, 4
	la $a0, combat_prompt
	syscall
#-------------------------------------------------------------------------------------
# IT'S COMBAT TIME
	li $t5, 0
	li $t8, 16
	li $t9, 16
Fighting:
	li $v0, 4
	la $a0, one_shot
	syscall
	
	jal input_combat
	
	bltz $s1, nofight1
	bgt $s1, 6, nofight1
	
	bltz $s2, nofight1
	bgt $s2, 6, nofight1
	
	
	j canfight1
	
nofight1:
	jal invalid_prompt
	
	j Fighting
canfight1:
	
	jal calculate_offset
	jal player1_fire
	
	jal check_win
Fighting2:
	li $v0, 4
	la $a0, two_shot
	syscall

	jal input_combat
	
	bltz $s1, nofight2
	bgt $s1, 6, nofight2
	
	bltz $s2, nofight2
	bgt $s2, 6, nofight2
		
	j canfight2
	
nofight2:
	jal invalid_prompt
	
	j Fighting2
	
canfight2:
	
	jal calculate_offset
	jal player2_fire
	
	jal check_win
	
	
	j Fighting

#-------------------------------------------------------------------------------------
exit:
	li $v0,10
	syscall	
	
# Below is Function part --------------------------------------------------------------
###########################################################################################
CheckValid_1:
	li $s0, 6
	
	bltz $s1, Invalid_1
	bgt $s1, $s0, Invalid_1  
	
	bltz $s2, Invalid_1
	bgt $s2, $s0, Invalid_1
	
	bltz $s3, Invalid_1
	bgt $s3, $s0, Invalid_1
	
	bltz $s4, Invalid_1
	bgt $s4, $s0, Invalid_1
	
	j valid_1
	
Invalid_1:
	j overlap_1
	
valid_1:
	jr $ra 

###########################################################################################
CheckValid_2:
	li $s0, 6
	
	bltz $s1, Invalid_2
	bgt $s1, $s0, Invalid_2  
	
	bltz $s2, Invalid_2
	bgt $s2, $s0, Invalid_2
	
	bltz $s3, Invalid_2
	bgt $s3, $s0, Invalid_2
	
	bltz $s4, Invalid_2
	bgt $s4, $s0, Invalid_2
	
	j valid_2	
	
Invalid_2:
	j overlap_2
	
valid_2:
	jr $ra 
			
##########################################################################
		
display_loop:
	lb $a0, 0($t7)  
 	li $v0, 1      
 	syscall

 	addi $t7, $t7, 4 
    	addi $t2, $t2, -1
    	
    	bnez $t2, display_loop  

    	li $v0, 4    
    	la $a0, newline   
    	syscall

    	li $t2, 7        
    	addi $t1, $t1, -1  

    	bnez $t1, display_loop 
    	
    	jr $ra

####################################################################################
input_coordinate:

	li $v0, 5
	syscall
	move $s1, $v0	
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	li $v0, 5
	syscall
	move $s3, $v0
	
	li $v0, 5
	syscall
	move $s4, $v0
	
	jr $ra
##################################################################################
input_combat:

	li $v0, 5
	syscall
	move $s1, $v0	
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	jr $ra
	
###################################################################################
calculate_offset:	
	li $t5, 7
	mul $s3, $s1, $t5
	add $s3, $s3, $s2
	mul $s3, $s3, 4
	
	jr $ra

###################################################################################	
player1_fire:
	lw $s4, board2($s3)
	beq $s4, 1, correct_1
	beqz $s4, incorrect_1
correct_1:
	addi $s4, $s4, -1
	sw $s4, board2($s3)
	addi $t8, $t8, -1
	
	li $v0, 4
	la $a0, hit
	syscall
	
	j incorrect_1
incorrect_1:
	jr $ra
###################################################################################	
player2_fire:
	lw $s4, board1($s3)
	beq $s4, 1, correct_2
	beqz $s4, incorrect_2
correct_2:
	addi $s4, $s4, -1
	sw $s4, board1($s3)
	addi $t9, $t9, -1
	
	li $v0, 4
	la $a0, hit
	syscall
	
	j incorrect_2
incorrect_2:
	jr $ra	
###################################################################################
check_win:
	
	beqz $t8, one_win
	beqz $t9, two_win
	    	
    	jr $ra		
###################################################################################
player_1_insert_ship_2x1:
	
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)  
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	jr $ra
####################################################################################
player_1_insert_ship_3x1:
	
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	add $s7, $s1, $s3 
	mul $s7, $s7, $t3
	add $s7, $s7, $s2
	add $s7, $s7, $s4
	mul $s7, $s7, 2
	
	lw $s6, board1($s7)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s7)	
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	jr $ra
#################################################################################   P1 
player_1_insert_ship_4x1:
	beq $s1, $s3, row_ship4x1_1
	beq $s2, $s4, column_ship4x1_1
	j exit
row_ship4x1_1:
	blt $s2, $s4, less_than_1_x 
	j greater_than_1_x
less_than_1_x:
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
			
	addi $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	j end_player_1_insert_ship_4x1	
	
greater_than_1_x:
	li $t3, 7
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	j end_player_1_insert_ship_4x1	
	
column_ship4x1_1:
	blt $s1, $s3, less_than_1_y
	j greater_than_1_y
less_than_1_y:
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s1, $s1, 1
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s1, $s1, 1
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
			
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	j end_player_1_insert_ship_4x1	
	
greater_than_1_y:
	li $t3, 7
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s3, $s3, 1
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	addi $s3, $s3, 1
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board1($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_1
	sw $s6, board1($s5)
	
	j end_player_1_insert_ship_4x1	
		
end_player_1_insert_ship_4x1:	
	jr $ra		
		
##############################################################		
player_2_insert_ship_2x1:
	
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)  
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	jr $ra
####################################################################################
player_2_insert_ship_3x1:
	
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	add $s7, $s1, $s3 
	mul $s7, $s7, $t3
	add $s7, $s7, $s2
	add $s7, $s7, $s4
	mul $s7, $s7, 2
	
	lw $s6, board2($s7)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s7)	
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	jr $ra
#################################################################################   
player_2_insert_ship_4x1:
	beq $s1, $s3, row_ship4x1_2
	beq $s2, $s4, column_ship4x1_2
	j exit
row_ship4x1_2:
	blt $s2, $s4, less_than_2_x 
	j greater_than_2_x
less_than_2_x:
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
			
	addi $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	j end_player_2_insert_ship_4x1	
	
greater_than_2_x:
	li $t3, 7
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	j end_player_2_insert_ship_4x1	
	
column_ship4x1_2:
	blt $s1, $s3, less_than_2_y
	j greater_than_2_y
less_than_2_y:
	li $t3,7
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s1, $s1, 1
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s1, $s1, 1
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
			
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	j end_player_2_insert_ship_4x1	
	
greater_than_2_y:
	li $t3, 7
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s3, $s3, 1
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	addi $s3, $s3, 1
	
	mul $s5,$s3,$t3
	add $s5, $s5, $s4
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	mul $s5,$s1,$t3
	add $s5, $s5, $s2
	mul $s5, $s5, 4
	
	lw $s6, board2($s5)
	addi $s6, $s6, 1
	bgt $s6, 1, overlap_2
	sw $s6, board2($s5)
	
	j end_player_2_insert_ship_4x1	
		
end_player_2_insert_ship_4x1:	
	jr $ra		
		
##############################################################	
one_win:
	la $a0, prompt_one_win
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, main
	
	 j exit
############################################################### 	
two_win:
	la $a0, prompt_two_win
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, main
	
	 j exit
###############################################################
overlap_1:
	li $v0, 4
	la $a0, ship_overlap
	syscall
	
	j play
###############################################################
overlap_2:
	li $v0, 4
	la $a0, ship_overlap
	syscall
	
	j play_2
##############################################################
initialize:
	sw $0, 0($t7)  

 	addi $t7, $t7, 4 
    	addi $t2, $t2, -1
    	
    	bnez $t2, initialize 

    	li $t2, 7        
    	addi $t1, $t1, -1  

    	bnez $t1, initialize
    	
    	jr $ra
##############################################################
erasing:
	li $v0, 4
	la $a0, newline
	syscall
	addi $t1, $t1, -1
	bgtz $t1, erasing
	
	jr $ra
###############################################################
invalid_prompt:
	li $v0, 4
	la $a0, invalid_input
	syscall
	
	jr $ra
################################################################
