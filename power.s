# ***************************************************************************
#
# * Program: Power calculator
# * Description: This program takes two inputs from the user 
#   (base and exponent) and outputs the result.
# 
#***************************************************************************

.data

    result: .asciz "\nResult: %llu\n"
    base_prompt: .asciz "\nPlease enter a positive number for a base: "
    exp_prompt: .asciz "\nPlease enter a positive number for an exponent: "
    input: .asciz "%llu"

.text

# ***************************************************************************
#
# * Subroutine: exp_base_input 
# * Description: This subroutine asks the user for an exponent and a base 
#   and stores them in registers:
#   base (as a qword) -> %rdx 
#   expontent (as a qword) -> %rax 
# 
#***************************************************************************
exp_base_input:
    #Prologue
    push %rbp
    mov %rsp, %rbp

    #Prompt user for exponent
    movq $base_prompt, %rdi
    call printf

    #Read exponent from user and save into rbx
    subq $16, %rsp      #allocate 8 bytes of memory (stack allignment) (for unsigned long)
    movq $0, %rax
    movq $input, %rdi   
    leaq -16(%rbp), %rsi
    call scanf
    

    #Prompt user for base
    movq $exp_prompt, %rdi
    call printf
    
    #Read base from user and save into rax
    subq $16, %rsp      #allocate another 8 bytes of memory (stack allignment) (for unsigned long)
    movq $input, %rdi
    leaq -32(%rbp), %rsi
    call scanf

    movq -16(%rbp), %rax
    movq -32(%rbp), %rdx

    addq $32, %rsp  #Dealocate memory



    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret

# ***************************************************************************
#
# * Subroutine: pow 
# * Description: This subroutine takes two arguments and computes an exponent (base^exp)
#   
# * Arguments:
#   base -> %rdi (as qword)
#   exp -> %rsi (as qword)
#   
# * Output:  
#   %rax
#
#***************************************************************************
pow:
    #Prologue
    push %rbp
    mov %rsp, %rbp
    movq %rdi, %rax # Moving the base parameter into %rax
    movq %rsi, %rcx # Moving the exp parameter into %rcx (counter)

    #Edge case where exponent is 0
    cmp $0, %rcx
    jle clean
#Multiply base by itself exp times
iter:
    cmp $1, %rcx  # Check whether the count is 1
    je done
    mulq %rdi   # If count is not yet 1: %rax * %rdi -> %rax
    dec %rcx    # Decrement counter
    jmp iter    # Loop

#Clean Up
clean:
    movq $1, %rax #Only reachable if the exponent is 0
done:
    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret

.global main

main:
    #Prologue
    push %rbp
    mov %rsp, %rbp
    
    call exp_base_input 


    #Supply parameter to pow
    movq %rax, %rdi   #base -> rdi
    movq %rdx, %rsi   #exponent -> rsi

    call pow

    #Print result
    mov %rax, %rsi      # Copy the result of pow to %rsi (1st parameter for printf)
    mov $result, %rdi   # Copy result text to %rdi (2nd parameter to printf)
    mov $0, %rax        # No args for printf
    call printf

    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret
