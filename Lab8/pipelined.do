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
#                 = 0x00430820
force instruction_memory/memory(0) 16#FE
force instruction_memory/memory(1) 16#81
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
