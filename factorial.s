# ***************************************************************************
#
# * Program: Factorial calculator
# * Description: This program takes one integer from a user and computes a factorial
#   
# 
#***************************************************************************

.data

    result: .asciz "\nResult: %llu\n"
    factorial_prompt: .asciz "\nPlease enter number that you want to compute factorial for: "
    input: .asciz "%llu"

.text






# ***************************************************************************
#
# * Subroutine: factorial 
# * Description: This subroutine takes one argument n and computes n! * mul
#   
# * Arguments:
#   n -> %rdi (as qword)
#   
#   
#   
# * Output:  
#   %rax
# * outputs accurate values up to 24 before 8 byte register begins to overflow
#***************************************************************************
factorial:
    #Prologue
    push %rbp
    mov %rsp, %rbp


    cmp  $1, %rdi         
    jle exit_factorial  #Check if rdi is 1 or less
    
    
    movq %rdi, %rax
    dec %rdi            #Calculate n*(n-1) and store in rax
    mulq %rdi

    pushq %rax          #Store the output of n*(n-1) on the stack (tmp)

    dec %rdi    #n = n-2
    call factorial

    
    popq %rsi   #store next tmp number in rsi
    mulq %rsi   # %rax is quaranteed to be 1 or a part of the n! computation

    jmp exit_factorial_epilogue #Make sure to jmp to epilogue 

    
exit_factorial:
    movq $1, %rax       #Special case set rax to 1

exit_factorial_epilogue:
    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret                 #Return




.global main

main:
    #Prologue
    push %rbp
    mov %rsp, %rbp
    
    #Ask user for input for factorial

    #Print prompt
    movq $factorial_prompt, %rdi 
    movq $0, %rax       
    call printf
    
    #Read value
    
    subq $64 ,%rsp  #Allocate a qword of memory (stack allignment) (for unsigned long long)
    movq $0, %rax
    movq $input, %rdi
    leaq -64(%rbp), %rsi 
    call scanf 

    movq -64(%rbp), %rdi #Store user input as parameter to factorial

    addq $64, %rsp  #Deallocate user input

    #Supply parameter to factorial
    #movq $6, %rdi   #supply n as an argument
    #movq $1, %rsi   #supply mul (1 at the start) as a second argument

    call factorial

    #Print result
    mov %rax, %rsi      # Copy the result of pow to %rsi (1st parameter for printf)
    mov $result, %rdi   # Copy result text to %rdi (2nd parameter to printf)
    mov $0, %rax        # No args for printf
    call printf

    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret
