# Re-initialize simulation   SingleCycle.do
#restart -force
restart -nowave
# Set up wave window

add wave clock
add wave -hex instruction
add wave -hex CurrentPC IncrPC BranchPC NextPC
add wave ALUfunc
add wave -hex ALUa ALUb ALUresult
add wave RegWrite
add wave -hex RegWriteData
add wave MemWrite
add wave -hex ReadData2
add wave -hex the_registers/registers instruction_memory/memory data_memory/memory

add wave pcWE
add wave -position end  sim:/singlecycle/cache_memory/pcEnable
add wave -position end  sim:/singlecycle/cache_memory/cacheController/WE
add wave -position end  sim:/singlecycle/cache_memory/cacheController/hit

# 300-ns, 50% duty cycle clock
force clock 1 0, 0 150 ns -repeat 300 ns
##########
# Put constants needed by program into data memory
##########
# put 0x00000000 at address 0x00000000:
force data_memory/memory(0) 16#00
force data_memory/memory(1) 16#00
force data_memory/memory(2) 16#00
force data_memory/memory(3) 16#00
# put 0x00000001 at address 0x00000004:
force data_memory/memory(4) 16#00
force data_memory/memory(5) 16#00
force data_memory/memory(6) 16#00
force data_memory/memory(7) 16#01
# put 0x00000002 at address 0x00000008:
force data_memory/memory(8) 16#00
force data_memory/memory(9) 16#00
force data_memory/memory(10) 16#00
force data_memory/memory(11) 16#02
##########
# Put program into instruction memory
#
# lw $t0,0($zero) = 100011 00000 01000 0000000000000000
#                 = 0x8c080000
force instruction_memory/memory(0) 16#8c
force instruction_memory/memory(1) 16#08
force instruction_memory/memory(2) 16#00
force instruction_memory/memory(3) 16#00
#
# lw $t1,4($zero) = 100011 00000 01001 0000000000000100
#               = 0x8c090004
force instruction_memory/memory(4) 16#8c
force instruction_memory/memory(5) 16#09
force instruction_memory/memory(6) 16#00
force instruction_memory/memory(7) 16#04
#
# lw $t2,8($zero) = 100011 00000 01010 0000000000001000
#                 = 0x8c0a0008
force instruction_memory/memory(8) 16#8c
force instruction_memory/memory(9) 16#0a
force instruction_memory/memory(10) 16#00
force instruction_memory/memory(11) 16#08
#
# lw $a0,12($zero) = 100011 00000 00100 0000000000001100
#                  = 0x8c04000c
force instruction_memory/memory(12) 16#8c
force instruction_memory/memory(13) 16#04
force instruction_memory/memory(14) 16#00
force instruction_memory/memory(15) 16#0c
#
# slt $t3,$t1,$a0 = 000000 01001 00100 01011 00000 101010
#                 = 0x0124582a
force instruction_memory/memory(16) 16#01
force instruction_memory/memory(17) 16#24
force instruction_memory/memory(18) 16#58
force instruction_memory/memory(19) 16#2a
#
# beq $t3,$zero,finish = 000100 01011 00000 0000000000000011
#                      = 0x11600003
force instruction_memory/memory(20) 16#11
force instruction_memory/memory(21) 16#60
force instruction_memory/memory(22) 16#00
force instruction_memory/memory(23) 16#03
#
# add $t0,$t0,$t1 = 000000 01000 01001 01000 00000 100000
#                 = 0x01094020
force instruction_memory/memory(24) 16#01
force instruction_memory/memory(25) 16#09
force instruction_memory/memory(26) 16#40
force instruction_memory/memory(27) 16#20
#
# add $t1,$t1,$t2 = 000000 01001 01010 01001 00000 100000
#                 = 0x012a4820
force instruction_memory/memory(28) 16#01
force instruction_memory/memory(29) 16#2a
force instruction_memory/memory(30) 16#48
force instruction_memory/memory(31) 16#20
#
# beq $zero,$zero,loop = 000100 00000 00000 1111111111111011
#                      = 0x1000fffb
force instruction_memory/memory(32) 16#10
force instruction_memory/memory(33) 16#00
force instruction_memory/memory(34) 16#ff
force instruction_memory/memory(35) 16#fb
#
# sw $t0,16($zero) = 101011 00000 01000 0000000000010000
#                      = 0xac080010
force instruction_memory/memory(36) 16#ac
force instruction_memory/memory(37) 16#08
force instruction_memory/memory(38) 16#00
force instruction_memory/memory(39) 16#10
##########
# Put input number n = 6 into data memory
#
force data_memory/memory(12) 16#00
force data_memory/memory(13) 16#00
force data_memory/memory(14) 16#00
force data_memory/memory(15) 16#06

