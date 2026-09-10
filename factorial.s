# ***************************************************************************
#
# * Program: Factorial calculator
# * Description: This program takes one integer from a user and computes a factorial
#   
# 
#***************************************************************************

.data

    result: .asciz "\nResult: %u\n"
    factorial_prompt: .asciz "\nPlease enter number that you want to compute factorial for: "
    input: .asciz "%ld"

.text



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
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax # Moving the base parameter into %rax
    movq %rsi, %rcx # Moving the exp parameter into %rcx (counter)

    #Edge case where exponent is 0
    cmp $0, %rcx
    je clean
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
    movq %rbp, %rsp
    popq %rbp
    ret




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
#
#***************************************************************************
factorial:
    
    cmp  $1, %rdi         
    jle exit_factorial  #Check if rdi is 1 or less
    
    
    movq %rdi, %rax
    dec %rdi            #Calculate n*(n-1) and store in rax
    mulq %rdi

    pushq %rax          #Store the output of n*(n-1) on the stack (tmp)

    dec %rdi    #n = n-2
    call factorial

    
    popq %rdi   #store next tmp number in rdi
    mulq %rdi   # %rax is quaranteed to be 1 or a part of the n! computation
    ret

    
exit_factorial:
    movq $1, %rax       #Special case set rax to 1
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
    
    subq $16 ,%rsp  #Allocate a word of memory (stack allignment)
    movq $0, %rax
    movq $input, %rdi
    leaq -16(%rbp), %rsi 
    call scanf 

    movq -16(%rbp), %rdi #Store user input as parameter to factorial

    addq $16, %rsp  #Deallocate user input

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
