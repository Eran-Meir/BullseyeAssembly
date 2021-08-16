#### 	Bullseye Assembly Game    ####
####  Written by Eran Meir      ####
.data
	bool: 			.space 3								 # for 3 chars we need 3 bytes
	guess: 			.space 4								 # 3 chars + 1 space char
	GetNumberText: 		.asciiz "\nGuess my number (bool array): "				 # Guess number text
	NumberExceptionText: 	.asciiz "\nIllegal input! Enter again.\n"				 # Illegal number text
	GoodInputText:		.asciiz "\nNice, good number input!\n"					 # Illegal number text
	GetGuessString: 	.asciiz "\nEnter your guess (guess array): " 				 # Guess number text
	CorrectGuessThreeB: 	.asciiz "\nWell done! You got 3 b's, bye! "				 # Guess number text
	AnotherGame:		.asciiz "\nWould you like to start another game? (y/n): "		 # Another Game text 
	ProperDecision:		.asciiz "\nPlease dont make this difficult for either of us, y or n?"    # Joking with my teacher
	bChar:			.asciiz "b"								 # b char
	pChar:			.asciiz "p"								 # p char
	nChar:			.asciiz "n"								 # p char
.text	
.globl main
main:
	la 	$a1,bool		# Set the address of bool array for the get_number function
	jal 	get_number		# Start from getting a number, then return here
	la 	$a2,guess		# Set the address of guess array for the get_guess function
start_guessing:
	addi	$t8,$zero,0		# $t8 is our b char counter and will be set to zero
	addi	$t8,$zero,0		# $t9 is our p char counter and will be set to zero
	jal 	get_guess		# Get Guess, now guess contains the 3 guess chars
	la 	$a1,bool		# Just to make sure, again: Set the address of bool array for the get_number function
	la 	$a2,guess		# Just to make sure, again: Set the address of guess array for the get_guess function
	jal 	compare			# Now that we have a guess compare both strings
end_of_tests:
	j 	exit
get_number:
	move 	$t4,$a1			# Get bool array address
	li	$v0, 4			# prompt get number text to the user
	la	$a0, GetNumberText	# Show the text
	syscall
	# Get and store first char
	li	$v0, 12 		# use syscall 12 to get char from the user
	syscall
	sb	$v0,0($t4)		# bool[0] = the character from the user
	# Get and store second char
	li 	$v0, 12 		# use syscall 12 to get char from the user
	syscall
	sb 	$v0,1($t4)		# bool[1] = the character from the user
	# Get and store third char
	li	$v0, 12 		# use syscall 12 to get char from the user
	syscall
	sb	$v0,2($t4)		# bool[2] = the character from the user
	# Check for correct input
	j 	check_input		# Now check the input
# Checking the input number for an array - either bool or guess
check_input:
	move	$t0,$a1			# Load address of the array to check array into t0 register
	lb	$t1, 0($t0)		# t1 = array[0]
	lb	$t2, 1($t0)		# t2 = array[1]  
	lb	$t3, 2($t0)		# t3 = array[2]
	beq	$t1,$t2,illegal_input	# Illegal input if array[0] == array[1] (can be either bool or guess array)
	beq	$t1,$t3,illegal_input	# Illegal input if array[0] == array[2] (can be either bool or guess array)
	beq	$t2,$t3,illegal_input	# Illegal input if array[1] == array[2] (can be either bool or guess array)
	blt     $t1,'0',illegal_input	# Illegal input if less than '0'
	bgt     $t1,'9',illegal_input	# Illegal input if more than '9'
	blt     $t2,'0',illegal_input	# Illegal input if less than '0'
	bgt     $t2,'9',illegal_input	# Illegal input if more than '9'
	blt     $t3,'0',illegal_input	# Illegal input if less than '0'
	bgt     $t3,'9',illegal_input	# Illegal input if more than '9'
	li 	$v0, 4 			# print string
	la 	$a0, GoodInputText 	# If we got here then we obviously have a good input
	syscall	
	jr 	$ra			# Go back to main
# If the input is illegal
illegal_input:
	li 	$v0, 4 			# print get number
	la 	$a0, NumberExceptionText
	syscall
	beq	$a3,1,get_guess		# If we came from get_guess and not from get number then we jump back to get_guess
	j 	get_number		# Else, we are in get_number, then go back to get number
# Get guess string from user
get_guess:
	move 	$t4,$a2			# Get guess array address
	li 	$v0, 4			# prompt get guess text to the user
	la 	$a0, GetGuessString	# Guess string text
	syscall
	#################################
	# To issue Syscall 8 we need to set the following:
	# $a0 = address of input buffer
	# $a1 = maximum number of characters to read	
	#################################
	li 	$v0,8			# Get the Guess String from the user
	move 	$a0,$t4			# Set $a0 to be the address of the guess array
	li 	$a1,4			# Guess space is 3 chars + null thus, 4
	syscall				# Now guess contains 3 chars that were entered from the user
	la	$a1,guess		# Set $a1 to be guess's address, we want to check the input
	li	$a3,1			# Notify to the input that we come from get_guess and not from get_number
	j 	check_input		# Check the input for guess
compare:
	move	$t0,$a1			# Load address of the bool to $t0
	move	$t1,$a2			# Load address of the guess to $t1
	addi	$t8,$zero,0		# $t8 is our b char counter and will be set to zero
	addi	$t9,$zero,0		# $t9 is our p char counter and will be set to zero
	lb	$t2,0($t0)		# $t2 = bool[0]
	lb	$t3,1($t0)		# $t3 = bool[1]
	lb	$t4,2($t0)		# $t4 = bool[2]
	lb	$t5,0($t1)		# $t5 = guess[0]
	lb	$t6,1($t1)		# $t6 = guess[1]
	lb	$t7,2($t1)		# $t7 = guess[2]
# We need to check 3x3 = 9 times, while 3 out of 9 is for b char, and 6 out of 9 is for p char
# Do we have the same indexes which have equal values? if so, print the letter b
test_first_b:
	beq	$t2,$t5,printBChar1	# if bool[0] == guess[0] goto printBChar
test_second_b:
	beq	$t3,$t6,printBChar2	# if bool[1] == guess[1] goto printBChar
test_third_b:
	beq	$t4,$t7,printBChar3	# if bool[2] == guess[2] goto printBChar
test_three_b:
	beq	$t8,3,exit_three_b	# We got 3 b's exit
# Do we have equal values on different indexes? if so, print the letter p
# Note that we don't have repetetive values on the same array (111, 112, 122 etc are illegal inputs)
test_first_p:
	beq	$t2,$t6,printPChar1	# if bool[0] == guess[1] 
	beq	$t2,$t7,printPChar1	# if bool[0] == guess[2] 
test_second_p:	
	beq	$t3,$t5,printPChar2	# if bool[1] == guess[0]
	beq	$t3,$t7,printPChar2	# if bool[1] == guess[2]
test_third_p:	
	beq	$t4,$t5,printPChar3	# if bool[2] == guess[0] 
	beq	$t4,$t7,printPChar3	# if bool[2] == guess[1] 
test_n:
	bnez	$t8,start_guessing	# if we've counted a b then we don't need to place an n letter
	bnez	$t9,start_guessing	# if we've counted a p then we don't need to place an n letter
printNChar:
	li 	$v0, 4			# we need to print n
	la 	$a0, nChar		# print n
	syscall	
	j	start_guessing		# Go back to main
printBChar1:
	addi 	$t8,$t8,1		# increment t8 by 1 t8=t8+1
	li 	$v0, 4			# prompt the string
	la 	$a0, bChar		# print b
	syscall
	j	test_second_b
printBChar2:
	addi 	$t8,$t8,1		# increment t8 by 1 t8=t8+1
	li 	$v0, 4			# prompt the string
	la 	$a0, bChar		# print b
	syscall
	j	test_third_b
printBChar3:
	addi 	$t8,$t8,1		# increment t8 by 1 t8=t8+1
	li 	$v0, 4			# prompt the string
	la 	$a0, bChar		# print b
	syscall
	j 	test_three_b		# see if we've got 3 b. if not, afterwards it'll go to the first p test
printPChar1:
	addi 	$t9,$t9,1		# increment t9 by 1 t9=t9+1
	li 	$v0, 4			# prompt the string
	la 	$a0, pChar		# print p
	syscall
	j 	test_second_p
printPChar2:
	addi 	$t9,$t9,1		# increment t9 by 1 t9=t9+1
	li 	$v0, 4			# prompt the string
	la 	$a0, pChar		# print p
	syscall
	j 	test_third_p
printPChar3:
	addi 	$t9,$t9,1		# increment t9 by 1 t9=t9+1
	li 	$v0, 4			# prompt the string
	la 	$a0, pChar		# print p
	syscall
	j	start_guessing		# we don't need to go to test_n cause we know that we've printed a p here.
	
# End the program
exit_three_b:
	li 	$v0, 4			# prompt the string
	la 	$a0, CorrectGuessThreeB	# Congratulate user for the amazing achievment 
	syscall
	j exit				# Finish the game
enter_choice:
	li 	$v0, 4			# prompt the string
	la 	$a0, ProperDecision	# enter proper choice
	syscall
exit:
	li 	$v0, 4			# prompt the string
	la 	$a0, AnotherGame	# Another game?
	syscall
	li	$v0, 12 		# use syscall 12 to get char from the user
	syscall
	move 	$t0,$v0			# Set the char to $t0
	beq	$t0,'y',main
	beq	$t0,'n',quit		# done for real
	bne	$t0,'y',enter_choice	# Enter a proper decision
quit:
	li	$v0, 10			# call code for exit
	syscall				# execute by the os

