.data
string: .asciiz "This is a null-terminated ascii string."

.text
main:
        addi $sp, $sp, -4
        sw $ra, ($sp)

        la $a0,string

        li $a1,'i'
        jal xcount

        lw $ra, 0($sp)
        addi $sp, $sp, 4
return: jr $ra




xfind:  
        add $t0, $a0, $zero             #load values from calling function
        add $t1, $a1, $zero
        add $v1, $a1, $zero             #load the charactor to find into into the return location


xfind_loop:
        lbu $t3, 0($t0)
        beq $t3, $t1, xfind_found       #if pointing to the desired charactor, return
        beq $t3, $zero, xfind_end_str   #if at end of string return

        addi $t0, $t0, 1                #point to next charactor
        j xfind_loop

xfind_end_str:
        add $v1, $zero, $zero           #set output charactor to 0 to indicate not found
        j xfind_return

xfind_found:
        add $v0, $t0, $zero             #set output pointer to current pointer
        add $v1, $a1, $zero             #load the charactor to find into into the return location

xfind_return:
        jr $ra                          #return


xcount:
        addi $sp, $sp, -4               #push return address to statck
        sw $ra, ($sp)
        addi $sp, $sp, -4               #push s0 to use as hitCounter
        sw $s0, 0($sp)

        add $s0, $zero, $zero           #clear hitCounter



xcount_loop:
        jal xfind
        beq $v1, $zero, xcount_return   #if not found

        addi $a0, $v0, 1                #next loop point to the charactor after the las one found

        addi $s0, $s0, 1              #increment hitCounter
        jal xcount_loop


xcount_return:

        add $v0, $s0, $zero             #move hitCounter to return value

        lw $s0, 0($sp)                  #pop s0 from the stack
        addi $sp, $sp, 4
        lw $ra, 0($sp)                  #pop return addres from the stack
        addi $sp, $sp, 4
        jr $ra                          #return
