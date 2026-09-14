
.text

.include "final.s"
#.include "./dcd_msg/helloWorld.s"
#.include "./dcd_msg/abc_sorted.s"


.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	movq $0, %r8 			# set index = 0 for the first iteration

	movq $8, %r11			#size of 1 chunk

	

	subq $16384, %rsp	# Make a buffer for 16384 bytes (characters)
	movq %rsp, %rsi		# rsi -> location where the character can be placed
	
	
	

	section_loop:
	
	movq %rdi, %r10 	# cur_pointer = data[0]   (data pointer for block with index 0)

	movq %r8, %rax		
	mulq %r11			#calculate index * 8 (move the pointer 8 bytes based on the index)


	addq %rax, %r10	# data_ptr + index * 8	
						# cur_pointer = data[index] (adress)

	#movq (%r10), %rsi	# tmp = data[index] (value)

	movq (%r10), %r8
	shl $16, %r8
	shr $32, %r8	# get index and store in r8
		

	movq (%r10), %rcx
	shl $48, %rcx
	shr $56, %rcx	# get amount and store in rcx

			
	movq (%r10), %r9
	shl $56, %r9
	shr $56, %r9	# get char and store in r9
			
		
		
	#rcx -> amount
	#r8	-> index
	#r9 ->char

	decode_iter:
		cmp $0, %rcx
		je	exit_loop
		
		#push character to the buffer
		
		movb %r9b, (%rsi) #move the character to the buffer
		inc %rsi
		
		loop decode_iter
		


	exit_loop:
	
	cmp $0, %r8
	je end_decode	#if next index is 0 finish decoding

	jmp section_loop

	end_decode:
	#push terminator character to the buffer
	
	movb $0, (%rsi) 
	inc %rsi


	movq $0, %rax
	movq %rsp, %rdi		#start to print from the bottom of the stack
	call printf
	
	addq $16384, %rsp	#Dealocate the buffer

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program
