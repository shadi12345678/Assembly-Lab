.data

    result: .asciz "\nResult: %u\n"
    base_prompt: .asciz "\nPlease enter a positive number for a base: "
    exp_prompt: .asciz "\nPlease enter a positive number for an exponent: "
    input: .asciz "%ld"

.text

inout:
    #Prologue
    pushq %rbp
    movq %rsp, %rbp

    #Prompt user for exponent
    movq $exp_prompt, %rdi
    call printf

    #Read exponent from user and save into rbx
    subq $16, %rsp
    movq $0, %rax
    movq $input, %rdi
    leaq -8(%rbp), %rsi
    call scanf
    movq -8(%rbp), %rbx

    #Prompt user for base
    movq $base_prompt, %rdi
    call printf

    #Read base from user and save into rax
    movq $input, %rdi
    leaq -16(%rbp), %rsi
    call scanf
    movq -16(%rbp), %rax

    #Epilogue
    movq %rbp, %rsp
    popq %rbp
    ret


pow:
    #Prologue
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

    movq %rax, %rdi   # base → rdi
    movq %rbx, %rsi   # exponent → rsi

    call pow

    mov %rax, %rsi
    mov $result, %rdi
    call printf
    call exit

    mov %rbp, %rsp
    pop %rbp