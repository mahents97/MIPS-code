# MIPS01 Palindrome assignment
# Mahents Ravelomanantsoa - COSC3303-01 SP2020
# This program takes a string of alphanumeric characters and reports whether or not it is a palindrome

.data
prompt:			    .asciiz "\n \n Please enter a character string or press Enter to exit:"
output:			    .asciiz "The string '"
is_palindrome:		.asciiz "' is a palindrome."
is_not_palindrome:	.asciiz "' is not a palindrome."
the_string:		    .space 1024
new_string:		    .space 1024

.text
start:
	# print the prompt
	addi $v0, $zero, 4
	la $a0, prompt
	syscall
	# read the string
	addi $v0, $zero, 8
	la $a0, the_string
	la $a1, 1024
	syscall
	# check the input
	lb $s0, the_string # get the content of the string
	addi $t0, $zero, '\n' # store new line character in $t0
	beq $s0, $t0, exit # exit if Enter was pressed
	
		        addi $s1, $zero, 0 # initialize counter $s1 to get length of the string
		        addi $t1, $zero, 0 # initialize counter $t1 to keep track of current position
		        addi $t2, $zero, ' ' # store space character in $t2
		        la $s0, the_string # get the address of the string
		        la $s2, new_string # get the address of the new string that will store the string without space and in lowercase
remove_space:	lb $t3, 0($s0) # load character of the string into $t3
		        beq $t3, $t0, remove_newline # remove new line char and start the palindrome check when new line is encountered
		        beq $t3, $t2, next_char # skip if character is a space
		        ble $t3, 90, to_lowercase # change to lowercase if character is uppercase	
return:		    sb $t3, 0($s2) # concatenate the non-space lowercase character into the new string
		        addi $s2, $s2, 1 # increment address of new string
		        addi $s1, $s1, 1 # increment $s1 to get the length of the new string
		        j next_char

to_lowercase:	addi $t3, $t3, 32 # converts uppercase to lowercase
		        j return

next_char:	    addi $t1, $t1, 1 # increment counter $t1
		        addi $s0, $s0, 1 # increment address of the string
		        j remove_space

remove_newline:	addi $t3, $zero, '\0' # replaces the new line character with a null for aesthetic purposes of the ouptut
		        sb $t3, ($s0) # load that change into the address of the string
start_palindrome:	div $t0, $s1, 2 # find the middle index of the string
			        addi $t0, $t0, 1 # add 1 in case the length is odd
			        la $t4, new_string # load the starting address of the new string into $t4 for manipulation
			        la $s2, new_string # reload the starting address of the new string into $s2 and don't change $s2
			        addi $t1, $zero, 1 # intialize a counter for position of character to check
			        li $v1, 1 # initially set $v1 as true (i.e. string is a palindrome)
check_palindrome:	beq $t1, $t0, exit_palindrome # exit if the middle index of the string is reached
			        lb $s3, 0($t4) # load the character from left side position of string
			        sub $t2, $s1, $t1 # get the index of the corresponding right side
			        add $t3, $s2, $t2 # add the index from right side of string to address
			        lb $s4, 0($t3) # load character from the right side position of string
			        beq $s3, $s4, inc_palindrome # if characters are the same, go to increment palindrome to continue
			        li $v1, 0 # change $v1 to false (i.e. string is not a palindrome)
			        j exit_palindrome	
inc_palindrome:	addi $t1, $t1, 1 # increment the position to check
		        addi $t4, $t4, 1 # increment the address
		        j check_palindrome
			
exit_palindrome:	# prints the output
			        addi $v0, $zero, 4
			        la $a0, output
			        syscall
			        # prints the string
			        addi $v0, $zero, 4
			        la $a0, the_string
			        syscall
			        # picks the right output to print
			        beqz $v1, result_false
			        beq $v1, 1, result_true
return_result:		syscall
			        j start

result_false:	la $a0, is_not_palindrome # to print "is not a palindrome."
		        j return_result
result_true:	la $a0, is_palindrome # to print "is a palindrome."
		        j return_result

exit: 	li $v0, 10
	    syscall
