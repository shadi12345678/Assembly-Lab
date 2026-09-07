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

.text

pow:
    push %rbp
    mov %rsp, %rbp

    mov %rdi, %rax
    mov %rsi, %rcx
    cmp $0, %rcx
    je done
    mulq %rdi
    dec %rcx
    jmp pow
done:

    mov %rbp, %rsp
    pop %rbp
    ret

.global main

main:

    push %rbp
    mov %rsp, %rbp

    call exit

    mov %rbp, %rsp
    pop %rbp