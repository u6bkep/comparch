.data
A:  .word  8, 2, 6, 12, 8, 7, 6, 2, 6, 5, 6
.text
main:

#t0 PointerGlobal
#t1 ArrayPointer
#t2 DecisionBool
#t3 InnerPointerOffset
#t4 index pointer
#t5 duplicate counter
#s0 pointer to start 0f A
#s1 lenth of A
#s2 MaxCounterGlobal
#s3 output

# Description:
# searches array A for the number with the most duplicates

        la  $s0, A
        li  $s1, 11

        add $s1, $s1, $s1       #increment index pointer by 11 twice
        add $s1, $s1, $s1
        add $s2, $zero, $zero   #clear MaxCounterGlobal
        add $t0, $zero, $zero   #clear PointerGlobal

outer:
        add $t4, $s0, $t0       #get address of A
        lw $t4, 0($t4)          #load A[index pointer]
        add $t5, $zero, $zero   #clear duplicate counter
        add $t1, $zero, $zero   #clear ArrayPointer

inner:
        add $t3, $s0, $t1       #load next word from A
        lw $t3, 0($t3)
        bne $t3, $t4, skip      #if A[i] != A[i+n] goto skip

        addi $t5, $t5, 1        #else increment duplicate counter
skip:   addi $t1, $t1, 4        #increment ArrayPointer by one word
        bne $t1, $s1, inner

        slt $t2, $t5, $s2       #if MaxCounterGlobal > duplicate counter goto next
        bne $t2, $zero, next
        add $s2, $t5, $zero     #else load duplicate counter into MaxCounterGlobal
        add $s3, $t4, $zero     #load index pointer into output

next:
        addi $t0, $t0, 4        
        bne $t0, $s1, outer
        nop