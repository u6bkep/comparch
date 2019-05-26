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
add wave -hex  sim:/pipelined/SWp


## EX Stage
add wave ALUOp_ID_EX ALUSrc_ID_EX RegDst_ID_EX
add wave ALUfunc
add wave -hex ALUa ALUb ALUresult WriteRegister 
add wave -hex  sim:/pipelined/SWp_ID_EX\


## MEM Stage
add wave MemWrite_EX_MEM MemRead_EX_MEM  Branch_EX_MEM 
add wave -hex  ALUResult_EX_MEM WriteRegister_EX_MEM data_to_mem
add wave -hex  data_memory/memory
add wave -hex sim:/pipelined/SWp_EX_MEM
    

## WB Stage
add wave MemtoReg_MEM_WB RegWrite_MEM_WB
add wave -hex ALUResult_MEM_WB WriteRegister_MEM_WB RegWriteData
add wave -hex the_registers/registers 

add wave -position 25  sim:/pipelined/ALUResult_EX_MEM_2

# 300-ns, 50% duty cycle clock
force clock 1 0, 0 150 ns -repeat 300 ns
##########

# Put constants needed by program into RF
# "deposit" option lets you overwrite register contents

force -deposit the_registers/registers(1) 16#00000003
force -deposit the_registers/registers(2) 16#00000004
force -deposit the_registers/registers(3) 16#00000006
force -deposit the_registers/registers(4) 16#00000008
force -deposit the_registers/registers(5) 16#00000009

####################################
# Put constant needed by program into data memory
# put 0xe000a003 at address 0x00000008:
#
#force data_memory/memory(4) 16#08

#####################################
# Put program into instruction memory
#
# sw+ $1, ($20)
#                 = 0xFE810000
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#81
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# sw+ $2, ($20)   = 0xFE820000
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#81
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# sw+ $3, ($20)   = 0xFE830000
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#83
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# NOOP   = 0x00000000
force instruction_memory/memory(0) 16#00
force instruction_memory/memory(1) 16#00
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# sw+ $4, ($20)   = 0xFE840000
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#84
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# sw+ $5, ($20)   = 0xFE850000
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#85
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#