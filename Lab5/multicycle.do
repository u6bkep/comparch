# Re-initialize simulation
# restart -force
restart -nowave

# Set up wave window
add wave -position end  sim:/multicycle/clock
add wave -position end  sim:/multicycle/Controls
add wave -position end  sim:/multicycle/Zero
add wave -position end  sim:/multicycle/PCLoad
add wave -position end  sim:/multicycle/PCWCandZ
add wave -position end  sim:/multicycle/ALUoperation
add wave -position end  sim:/multicycle/NextPC
add wave -position end  sim:/multicycle/CurrentPC
add wave -position end  sim:/multicycle/MemAddr
add wave -position end  sim:/multicycle/MemData
add wave -position end  sim:/multicycle/Instruction
add wave -position end  sim:/multicycle/MDROut
add wave -position end  sim:/multicycle/WriteRegister
add wave -position end  sim:/multicycle/RegWriteData
add wave -position end  sim:/multicycle/ExtOffset
add wave -position end  sim:/multicycle/SLOffset
add wave -position end  sim:/multicycle/Four
add wave -position end  sim:/multicycle/ReadData1
add wave -position end  sim:/multicycle/ReadData2
add wave -position end  sim:/multicycle/AOut
add wave -position end  sim:/multicycle/BOut
add wave -position end  sim:/multicycle/ALUa
add wave -position end  sim:/multicycle/ALUb
add wave -position end  sim:/multicycle/ALUresult
add wave -position end  sim:/multicycle/ALUOut
add wave -position end  sim:/multicycle/JumpAddr
add wave -position end  sim:/multicycle/RegDst
add wave -position end  sim:/multicycle/RegWrite
add wave -position end  sim:/multicycle/ALUSrcA
add wave -position end  sim:/multicycle/ALUSrcB
add wave -position end  sim:/multicycle/ALUOp
add wave -position end  sim:/multicycle/PCSource
add wave -position end  sim:/multicycle/MemtoReg
add wave -position end  sim:/multicycle/IRWrite
add wave -position end  sim:/multicycle/MemWrite
add wave -position end  sim:/multicycle/MemRead
add wave -position end  sim:/multicycle/IorD
add wave -position end  sim:/multicycle/PCWriteCond
add wave -position end  sim:/multicycle/PCWrite
add wave -position 15  sim:/multicycle/the_registers/registers
add wave -position 10  sim:/multicycle/memory/memory

# 400-ns, 50% duty cycle clock
force clock 1 0, 0 200 ns -repeat 400 ns
##########
#
# ******* Put uprogram into ucode ROM  *********
#
force control/urom/memory(0) 16#25023
force control/urom/memory(1) 16#00062
force control/urom/memory(2) 16#00051
force control/urom/memory(3) 16#0C003
force control/urom/memory(4) 16#00808
force control/urom/memory(5) 16#0A000
force control/urom/memory(6) 16#00113
force control/urom/memory(7) 16#0000C
force control/urom/memory(8) 16#10290
force control/urom/memory(9) 16#20400
##########
# ********  Set up dispatch ROMs  *********
#
# Dispatch ROM 1 gives next ucode address after 0001
#
force control/dROM1/memory(2#000000) 2#0110    
# R-type opcode

force control/dROM1/memory(2#000010) 2#1001    
# j opcode

force control/dROM1/memory(2#000100) 2#1000    
# beq opcode

force control/dROM1/memory(2#100011) 2#0010    
# lw opcode

force control/dROM1/memory(2#101011) 2#0010    
# sw opcode

#
# Dispatch ROM 2 gives next ucode address after 0010
force control/dROM2/memory(2#100011) 2#0011   
# lw opcode

force control/dROM2/memory(2#101011) 2#0101    
# sw opcode

##########
# ********** Put program into instruction memory ***********
#
# lw $t0,40($zero) 
#                 
force memory/memory(0) 16#8C
force memory/memory(1) 16#08
force memory/memory(2) 16#00
force memory/memory(3) 16#28
#
# lw $t1,44($zero) 
#               
force memory/memory(4) 16#8C
force memory/memory(5) 16#09
force memory/memory(6) 16#00
force memory/memory(7) 16#2C
#
# lw $t2,48($zero) 
#                 
force memory/memory(8) 16#8C
force memory/memory(9) 16#0A
force memory/memory(10) 16#00
force memory/memory(11) 16#30
#
# lw $a0,52($zero) 
#                  
force memory/memory(12) 16#8C
force memory/memory(13) 16#04
force memory/memory(14) 16#00
force memory/memory(15) 16#34
#
# slt $t3,$t1,$a0 
#                  
force memory/memory(16) 16#01
force memory/memory(17) 16#24
force memory/memory(18) 16#58
force memory/memory(19) 16#2A
#
# beq $t3,$zero,finish 
#                      
force memory/memory(20) 16#11
force memory/memory(21) 16#60
force memory/memory(22) 16#00
force memory/memory(23) 16#04
#
# add $t0,$t0,$t1 
#                  
force memory/memory(24) 16#01
force memory/memory(25) 16#09
force memory/memory(26) 16#40
force memory/memory(27) 16#20
#
# add $t1,$t1,$t2 
#                 
force memory/memory(28) 16#01
force memory/memory(29) 16#2A
force memory/memory(30) 16#48
force memory/memory(31) 16#20
#
# beq $zero,$zero,loop 
#                      
force memory/memory(32) 16#10
force memory/memory(33) 16#00
force memory/memory(34) 16#FF
force memory/memory(35) 16#FC
#
# sw $t0,56($zero) 
#                      
force memory/memory(36) 16#AC
force memory/memory(37) 16#08
force memory/memory(38) 16#00
force memory/memory(39) 16#38
##########
# ********** Put constants needed by program into memory *after* program
##########
# constant 0
force memory/memory(40) 16#00
force memory/memory(41) 16#00
force memory/memory(42) 16#00
force memory/memory(43) 16#00
#
# constant 1
force memory/memory(44) 16#00
force memory/memory(45) 16#00
force memory/memory(46) 16#00
force memory/memory(47) 16#01
#
# constant 2
force memory/memory(48) 16#00
force memory/memory(49) 16#00
force memory/memory(50) 16#00
force memory/memory(51) 16#02
##########
# ********** Put input number n = 6 into memory after constants
#
force memory/memory(52) 16#00
force memory/memory(53) 16#00
force memory/memory(54) 16#00
force memory/memory(55) 16#06

run 10us