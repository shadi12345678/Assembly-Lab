.text

result: .asciz "\nResult: %u\n"

.include "helloWorld.s"

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

	# your code goes here
	movq (%rdi), %rsi	# load the first quadword of the message into rsi
	movq %rsi, %rdi
	shl $16, %rdi
	shr $32, %rdi
	movq %rdi, %rbx
	movq %rsi, %rdi
	shl $48, %rdi
	shr $56, %rdi
	movq %rdi, %rcx
	movq %rsi, %rdi
	shl $56, %rdi
	shr $56, %rdi
	movq %rdi, %rdx





	movq $0, %rax
	movq %rdx, %rsi
	movq $result, %rdi
	call printf


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
