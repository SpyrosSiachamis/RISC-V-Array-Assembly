.data
	a: .space 32 # a[] array with size 32 bytes
	prompt: .asciz "Give 8 numbers for the array in 8 lines"
	nl: .asciz "\n"
	line: .asciz "Line "
	space: .asciz ": "
	linebreak: .asciz "----------------------\n"
	whitespace: .asciz " "
.text
main:
	# set up registers for looping and starting print
	addi x24, x0, 8 # Set i=8
	add x25, x0,x0 # set counter to 0
	la x5, a # Load starting address of array a to x5
	la x10, prompt
	addi x17, x0, 4
	ecall
	#set up print vars
	la x10, nl
	la x18, line
	la x19, space
	ecall
loop: # Starting point for loop to add values into the array
	# print line
	addi x17, x0, 4
	add x10, x0, x18
	ecall
	#print line number
	addi x17,x0,1
	add x10, x0, x25
	ecall
	#print space:
	addi x17, x0, 4
	add x10,x0, x19
	ecall
	#read input
	addi x17, x0, 5 # read int code
	ecall # run syscall
	# store input to current address of array
	sw x10, 0(x5) 
	addi x5,x5,4 # move address +4bytes (4 due to int)
	# Increment counter and check for loop
	addi x25, x25, 1 # increment counter by 1
	blt x25, x24, loop # do while (counter<8)
backwards: #after loop ends, we print the array in reverse order and values multiplied by 6
	addi x25,x0, 8 #set counter to 8
	add x24,x0,x0 #set i = 0
	addi x5,x5, -4 # move back to last value 
	addi x17,x0,4
	la x10, linebreak
	ecall
loop2:
	lw x6,0(x5) # load value of current x5 pointer to x6
	add x6, x6,x6 # x+x=2x
	add x28,x6, x0 # store 2x value temporarily
	add x6, x6,x6 #2x+2x = 4x
	add x6, x6,x28 # 4x+2x = 6x
	add x10, x0, x6
	addi x17, x0, 1
	ecall
	#print space between nums
	addi x17, x0,4 
	la x10, whitespace
	ecall
	addi x5,x5,-4 # move pointer backwards
	addi x25,x25,-1 # deincrement counter
	bgt x25,x24,loop2
end:
	addi x17,x0,4
	la x10, nl
	ecall
	j main
