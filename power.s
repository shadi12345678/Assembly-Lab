# ***************************************************************************
#
# * Program: Power calculator
# * Description: This program takes two inputs from the user 
#   (base and exponent) and outputs the result.
# 
#***************************************************************************

.data

    result: .asciz "\nResult: %llu\n"
    base_prompt: .asciz "\nPlease enter a non-negative number for a base: "
    exp_prompt: .asciz "\nPlease enter a non-negative number for an exponent: "
    input: .asciz "%llu"

.text

# ***************************************************************************
#
# * Subroutine: base_exp_input 
# * Description: This subroutine asks the user for a base and an exponent 
#   and stores them in registers:
#   base (as a qword) -> %rax 
#   expontent (as a qword) -> %rdx 
# 
#***************************************************************************
base_exp_input:
    #Prologue
    push %rbp
    mov %rsp, %rbp

    #Prompt user for base
    movq $base_prompt, %rdi
    movq $0, %rax
    call printf

    #Read base from user and save into the stack
    subq $16, %rsp      #allocate 16 bytes of memory (stack allignment) (for unsigned long)
    movq $0, %rax
    movq $input, %rdi   
    leaq -16(%rbp), %rsi
    call scanf
    

    #Prompt user for exponent
    movq $exp_prompt, %rdi
    movq $0, %rax
    call printf
    
    #Read exponent from user and save into the stack
    subq $16, %rsp      #allocate another 16 bytes of memory (stack allignment) (for unsigned long)
    movq $0, %rax
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
# * In case of overflow returns the result (not accurate) immediately
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
    #Prologue is not needed because we dont call anything inside of the subroutine
    #push %rbp
    #mov %rsp, %rbp

    #Edge case where exponent is 0
    cmp $0, %rsi
    jle clean 

    
                    #rdi = base
    movq %rsi, %rcx # rcx = exp

    movq $1, %rsi   #=res = 1 
    movq $2, %r9    #for divisions


iter:
    cmpq $0, %rcx   #while exp > 0
    jle done

    movq $0, %rdx
    movq %rcx, %rax
    div %r9         # getting the exp % 2
    
    cmpq $1, %rdx
    je remainder
    jmp exit_remainder
    remainder:

    movq %rdi, %rax
    mulq %rsi           # res = res * base
    movq %rax, %rsi


    exit_remainder:

    movq %rdi, %rax
    mulq %rdi           #base = base *base
    movq %rax, %rdi

    movq $0, %rdx # clear rdx
    movq %rcx, %rax
    divq %r9             #exp = exp/2
    movq %rax, %rcx

    #shr $1, %rcx

jmp iter


#Clean Up
clean:
    movq $1, %rax #Only reachable if the exponent is 0
    ret
done:
    movq %rsi, %rax
    
    #Epilogue
    #mov %rbp, %rsp
    #pop %rbp
    
    ret

.global main

main:
    #Prologue
    push %rbp
    mov %rsp, %rbp
    
    call base_exp_input 

    #Supply parameter to pow
    movq %rax, %rdi   #base -> rdi
    movq %rdx, %rsi   #exponent -> rsi

    call pow

    #Print result
    movq $result, %rdi   # Copy result text to %rdi (1st parameter to printf)
    movq %rax, %rsi      # Copy the result of pow to %rsi (2nd parameter for printf)
    movq $0, %rax        # No args for printf
    call printf

    #Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret
