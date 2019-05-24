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
force -deposit the_registers/registers(2) 16#00000001
force -deposit the_registers/registers(3) 16#00000002
force -deposit the_registers/registers(4) 16#00000000
force -deposit the_registers/registers(5) 16#00000000

force -deposit the_registers/registers(6) 16#00000000
force -deposit the_registers/registers(8) 16#00000000
force -deposit the_registers/registers(9) 16#00000000

force -deposit the_registers/registers(11) 16#00000000
force -deposit the_registers/registers(12) 16#00000000
force -deposit the_registers/registers(14) 16#00000000

force -deposit the_registers/registers(15) 16#00000000
force -deposit the_registers/registers(17) 16#00000000
force -deposit the_registers/registers(18) 16#00000000

force -deposit the_registers/registers(20) 16#00000000
force -deposit the_registers/registers(21) 16#00000000
force -deposit the_registers/registers(23) 16#00000000

####################################
# Put constant needed by program into data memory
# put 0xe000a003 at address 0x00000008:
#
force data_memory/memory(0) 16#00
force data_memory/memory(4) 16#08

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
# add $4,$1, $1 = 
#                 = 0x00212020
force instruction_memory/memory(4) 16#00
force instruction_memory/memory(5) 16#21
force instruction_memory/memory(6) 16#20
force instruction_memory/memory(7) 16#20
#
# add $4,$4, $1 
#                 = 0x00812020
force instruction_memory/memory(8) 16#00
force instruction_memory/memory(9) 16#81
force instruction_memory/memory(10) 16#20
force instruction_memory/memory(11) 16#20
#
# add $4,$1, $4 
#                 = 0x00242020
force instruction_memory/memory(12) 16#00
force instruction_memory/memory(13) 16#24
force instruction_memory/memory(14) 16#20
force instruction_memory/memory(15) 16#20
#
# lw $1, -8($4) 
#                 = 0x8C81FFF8
force instruction_memory/memory(16) 16#8C
force instruction_memory/memory(17) 16#81
force instruction_memory/memory(18) 16#FF
force instruction_memory/memory(19) 16#F8
#
# sw $4, -12($4) 
#                 = 0xAC84FFF4
force instruction_memory/memory(20) 16#AC
force instruction_memory/memory(21) 16#84
force instruction_memory/memory(22) 16#FF
force instruction_memory/memory(23) 16#F4
#
# add $1,$1, $1 
#                 = 0x00210820
force instruction_memory/memory(24) 16#00
force instruction_memory/memory(25) 16#21
force instruction_memory/memory(26) 16#08
force instruction_memory/memory(27) 16#20
#
# add $0,$1, $1 
#                 = 0x00210020
force instruction_memory/memory(28) 16#00
force instruction_memory/memory(29) 16#21
force instruction_memory/memory(30) 16#00
force instruction_memory/memory(31) 16#20
#
# add $4,$0, $0 
#                 = 0x00002020
force instruction_memory/memory(32) 16#00
force instruction_memory/memory(33) 16#00
force instruction_memory/memory(34) 16#20
force instruction_memory/memory(35) 16#20
#
# lw $4, ($4) 
#                 = 0xAC840000
force instruction_memory/memory(36) 16#AC
force instruction_memory/memory(37) 16#84
force instruction_memory/memory(38) 16#00
force instruction_memory/memory(39) 16#00
#
# sw $2, 3($2) 
#                 = 0xAC420003
force instruction_memory/memory(40) 16#AC
force instruction_memory/memory(41) 16#42
force instruction_memory/memory(42) 16#00
force instruction_memory/memory(43) 16#03
#
# sw $4,-8($4) 
#                 = 0xAC84FFF8
force instruction_memory/memory(44) 16#AC
force instruction_memory/memory(45) 16#84
force instruction_memory/memory(46) 16#FF
force instruction_memory/memory(47) 16#F8
#
# add $4,$3, $0 
#                 = 0x00602020
force instruction_memory/memory(48) 16#00
force instruction_memory/memory(49) 16#60
force instruction_memory/memory(50) 16#20
force instruction_memory/memory(51) 16#20
#
# sw $4, 2($4) 
#                 = 0xAC840002
force instruction_memory/memory(52) 16#AC
force instruction_memory/memory(53) 16#84
force instruction_memory/memory(54) 16#00
force instruction_memory/memory(55) 16#02
#
# sw $4, -2($4) 
#                 = 0xAC84FFFE
force instruction_memory/memory(56) 16#AC
force instruction_memory/memory(57) 16#84
force instruction_memory/memory(58) 16#FF
force instruction_memory/memory(59) 16#FE



