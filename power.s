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

.text

pow:
    // Prologue
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax
    movq %rsi, %rcx
iter:

    cmp $0, %rcx
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
    
    mov $2, %rdi
    mov $3, %rsi
    call pow
    mov %rax, %rsi
    mov $result, %rdi
    call printf
    call exit

    mov %rbp, %rsp
    pop %rbp