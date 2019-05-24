
#description:
# add up all the odd numbers to caltulate perfect squares


main:   addi $t0, $zero, 0      #initialize accumulator to 0
        addi $t1, $zero, 1      #initialize CurrentInt to 1
        addi $s0, $zero, 9      #initialize MaxInt to 9

loop:   slt  $t2, $s0, $t1      
        bne $t2, $zero, finish  #if MaxInt < CurrentInt jump to finish
        add $t0, $t0, $t1       #increment CurrentInt by 2 each loop, accumulating in accumulator
        addi $t1, $t1, 2        
        j loop                  #repeat loop


finish: add $s1, $t0, $zero     #stores final answer in output
        nop

