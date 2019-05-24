## Re-initialize simulation   
restart -nowave

## Set up wave window
add wave clock

## IF Stage
add wave -hex Instruction_IM
add wave -hex CurrentPC IncrPC BranchPC_EX_MEM NextPC
add wave -hex  instruction_memory/memory

## ID Stage
add wave -hex Instruction
add wave -hex ReadAdrs1 ReadData1  ReadAdrs2 ReadData2
add wave -hex ExtOffset


## EX Stage
add wave ALUOp_ID_EX ALUSrc_ID_EX RegDst_ID_EX
add wave ALUfunc
add wave -hex ALUa ALUb ALUresult WriteRegister 


## MEM Stage
add wave MemWrite_EX_MEM MemRead_EX_MEM  Branch_EX_MEM 
add wave -hex  ALUResult_EX_MEM WriteRegister_EX_MEM data_to_mem
add wave -hex  data_memory/memory
    

## WB Stage
add wave MemtoReg_MEM_WB RegWrite_MEM_WB
add wave -hex ALUResult_MEM_WB WriteRegister_MEM_WB RegWriteData
add wave -hex the_registers/registers 

# 300-ns, 50% duty cycle clock
force clock 1 0, 0 150 ns -repeat 300 ns
##########

# Put constants needed by program into RF
# "deposit" option lets you overwrite register contents

force -deposit the_registers/registers(1) 16#00000000
force -deposit the_registers/registers(2) 16#00000003
force -deposit the_registers/registers(3) 16#00000004
force -deposit the_registers/registers(4) 16#00000000
force -deposit the_registers/registers(5) 16#00000006

force -deposit the_registers/registers(6) 16#00000007
force -deposit the_registers/registers(8) 16#00000009
force -deposit the_registers/registers(9) 16#0000000a

force -deposit the_registers/registers(11) 16#0000000c
force -deposit the_registers/registers(12) 16#0000000d
force -deposit the_registers/registers(14) 16#0000000f

force -deposit the_registers/registers(15) 16#00000010
force -deposit the_registers/registers(17) 16#00000012
force -deposit the_registers/registers(18) 16#00000013

force -deposit the_registers/registers(20) 16#00000015
force -deposit the_registers/registers(21) 16#00000016
force -deposit the_registers/registers(23) 16#00000017

####################################
# Put constant needed by program into data memory
# put 0xe000a003 at address 0x00000008:
#
force data_memory/memory(8) 16#e0
force data_memory/memory(9) 16#00
force data_memory/memory(10) 16#a0
force data_memory/memory(11) 16#03

#####################################
# Put program into instruction memory
#
# add $1,$2, $3 = 000000 00010 00011 00001 00000 100000
#                 = 0x00430820
force instruction_memory/memory(0) 16#00
force instruction_memory/memory(1) 16#43
force instruction_memory/memory(2) 16#08
force instruction_memory/memory(3) 16#20
#
# add $4,$5, $6 = 000000 00101 00110 00100 00000 100000
#               = 0x00a62020
force instruction_memory/memory(4) 16#00
force instruction_memory/memory(5) 16#a6
force instruction_memory/memory(6) 16#20
force instruction_memory/memory(7) 16#20
#
# add $7,$4, $9 = 000000 00100 01001 00111 00000 100000
#                 = 0x00893820
force instruction_memory/memory(8) 16#00
force instruction_memory/memory(9) 16#89
force instruction_memory/memory(10) 16#38
force instruction_memory/memory(11) 16#20
#
# add $10,$11, $12  = 000000 01011 01100 01010 00000 100000
#                  = 0x016c5020
force instruction_memory/memory(12) 16#01
force instruction_memory/memory(13) 16#6c
force instruction_memory/memory(14) 16#50
force instruction_memory/memory(15) 16#20
#
# add $13,$14, $1 = 000000 01110 00001 01101 00000 100000
#                 = 0x01c16820
force instruction_memory/memory(16) 16#01
force instruction_memory/memory(17) 16#c1
force instruction_memory/memory(18) 16#68
force instruction_memory/memory(19) 16#20
#

# lw $10,8($zero) = 100011 00000 01010 0000000000001000
#                 = 0x8c0a0008
force instruction_memory/memory(20) 16#8c
force instruction_memory/memory(21) 16#0a
force instruction_memory/memory(22) 16#00
force instruction_memory/memory(23) 16#08
#
# sw $8,16($zero) = 101011 00000 01000 0000000000010000
#                      = 0xac080010
force instruction_memory/memory(24) 16#ac
force instruction_memory/memory(25) 16#08
force instruction_memory/memory(26) 16#00
force instruction_memory/memory(27) 16#10



