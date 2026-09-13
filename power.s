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

    movq $2 , %r11      #Used later for multiplication by 2
    #rdi -> base
    movq %rsi, %rcx # Moving the exp parameter into %rcx (counter)
    movq $1, %r9    # end_res = 1

reset_pow:
    movq $1, %rsi # cur_base = 1
    movq %rdi, %r8 # res = base


outer_iter_pow:
    cmpq $0, %rcx   #If rcx is 0 return
    je done

    inner_iter_pow:
        movq %rsi, %r10     #store original cur_base without multiplication
        movq %rsi, %rax
        mulq %r11             #cur_base *=2
        movq %rax, %rsi

        cmpq %rsi, %rcx 
        jl after_inner_iter_pow #if exp < cur_base done with loop

        cmpq %r10, %rax
        jl after_inner_iter_pow  #if cur_base overflowed we know that cur_base is higher so exit loop too


        movq %r8, %rax
        mulq %r8           #res*=res
        movq %rax, %r8 
    jmp inner_iter_pow
    after_inner_iter_pow:
        movq %rcx , %rax
        div %r10        #exp = exp % cur_base
        movq %rdx, %rcx

        movq %r9, %rax
        mulq %r8       #end_res *=res
        movq %rax, %r9
        
        jmp reset_pow

    jmp outer_iter_pow

#Clean Up
clean:
    movq $1, %rax #Only reachable if the exponent is 0
    ret
done:
    movq %r9, %rax
    
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
