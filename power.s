/**
 * The pow subroutine calculates powers
 * of non-negative bases and exponents.
 *
 * Arguments:
 *
 * base - the exponential base
 * exp  - the exponent
 *
 * Return value: 'base' raised to the power of 'exp'.
 */
// int pow(int base, int exp) {
// 	int total = 1;
// 	// ...
// 	return total;
// }

// RDI -> base
// RSI -> exp
.data

    result: .asciz "Result: %u\n"
    base_prompt: .asciz "\nPlease enter a positive number for a base: "
    exp_prompt: .asciz "\nPlease enter a positive number for an exponent: "
    input: .asciz "%ld"

.text

inout:
    # prologue
    pushq %rbp
    movq %rsp, %rbp

    movq $0, %rax              # no vector registers in use for printf
    movq $exp_prompt, %rdi         # param1: prompt string
    call printf                # print prompt

    subq $32, %rsp             # reserve space on stack for input

    movq $0, %rax              # no vector registers in use for scanf
    movq $input, %rdi          # param1: input format string
    leaq -16(%rbp), %rsi       # param2: address of reserved space    
    call scanf                 # read user input

    movq -16(%rbp), %rsi       # load input value into RSI

    movq $base_prompt, %rdi         # param1: prompt string
    call printf                # print prompt

    movq $0, %rax              # no vector registers in use for scanf
    movq $input, %rdi          # param1: input format string
    leaq -16(%rbp), %rsi       # param2: address of reserved space    
    call scanf                 # read user input

    movq -16(%rbp), %rdi       # load input value into RSI
    
    movq %rbp, %rsp             # restore stack pointer
    popq %rbp                  # restore base pointer
    ret


pow:
    // Prologue
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax
    movq %rsi, %rcx
iter:

    cmp $1, %rcx
    je done
    mulq %rdi
    dec %rcx
    jmp iter
done:

    movq %rbp, %rsp
    popq %rbp
    ret

.global main

main:

    push %rbp
    mov %rsp, %rbp
    
    call inout
    call pow
    mov %rax, %rsi
    mov $result, %rdi
    call printf
    call exit

    mov %rbp, %rsp
    pop %rbp