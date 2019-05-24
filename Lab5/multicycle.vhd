-- Multicycle datapath based on Fig 5.28 COD3e.
-- All control-block outputs are inputs to this model.

use work.mipspack.all;

entity multicycle is

    port (clock : in bit);

end multicycle;

architecture struct of multicycle is
    -- Control signals from control block
    signal Controls : bit_vector(17 downto 0);
    alias PCWrite : bit is Controls(17);
    alias PCWriteCond : bit is Controls(16);
    alias IorD : bit is Controls(15);
    alias MemRead : bit is Controls(14);
    alias MemWrite : bit is Controls(13);
    alias IRWrite : bit is Controls(12);
    alias MemtoReg : bit is Controls(11);
    alias PCSource : bit_vector(1 downto 0) is Controls(10 downto 9);
    alias ALUOp : bit_vector(1 downto 0) is Controls(8 downto 7);
    alias ALUSrcB : bit_vector(1 downto 0) is Controls(6 downto 5);
    alias ALUSrcA : bit is Controls(4);
    alias RegWrite : bit is Controls(3);
    alias RegDst : bit is Controls(2);
    --alias AddrCtl : bit_vector(1 downto 0) is Controls(1 downto 0);

    -- Other status/control signals
    signal Zero : bit;                             -- indicates "0" result from ALU
    signal PCLoad : bit;                           -- PC load control input
    signal PCWCandZ : bit;			   -- PCWriteCond AND Zero
    signal ALUoperation : bit_vector(2 downto 0);  -- 3-bit ALU control code

    -- Data signals
    signal NextPC : bit_vector(31 downto 0);       -- input to PC
    signal CurrentPC : bit_vector(31 downto 0);    -- output of PC
    signal MemAddr : bit_vector(31 downto 0);      -- memory address input
    signal MemData : bit_vector(31 downto 0);      -- memory data output
    signal Instruction : bit_vector(31 downto 0);  -- output of instruction register
    signal MDROut : bit_vector(31 downto 0);       -- output of memory data
					           -- register
    signal WriteRegister : bit_vector(4 downto 0); -- write-register number
    signal RegWriteData : bit_vector(31 downto 0); -- Write data input to registers
    signal ExtOffset : bit_vector(31 downto 0);    -- sign-extended branch offset
    signal SLOffset : bit_vector(31 downto 0);     -- branch offset shifted left 2
    signal Four : bit_vector(31 downto 0) := X"00000004";  -- constant
    signal ReadData1: bit_vector(31 downto 0);     -- Read data 1 register output
    signal ReadData2: bit_vector(31 downto 0);     -- Read data 2 register output
    signal AOut,BOut : bit_vector(31 downto 0);    -- Outputs of A and B registers
    signal ALUa,ALUb : bit_vector(31 downto 0);    -- ALU "a" and "b" inputs
    signal ALUresult : bit_vector(31 downto 0);    -- ALU result output
    signal ALUOut : bit_vector(31 downto 0);       -- Output of ALUOut register
    signal JumpAddr : bit_vector(31 downto 0);     -- Jump address

begin  -- struct


-- **************** Place your port map statements here *********************

    control : ucontrol
	port map (clock, Instruction(31 downto 26), Controls);
    program_counter : regld32
	port map (clock, PCLoad, NextPC, CurrentPC);
    mem_addr_mux : mux32
	port map (IorD, CurrentPC, ALUOut, MemAddr);
    memory : dmem
	port map (clock, MemWrite , MemRead, MemAddr, BOut, MemData);
    IR : regld32
	port map (clock, IRWrite, MemData, Instruction);
    MDR : reg32
	port map (clock, MemData, MDROut);
    reg_mux : mux5
	port map (RegDst, Instruction(20 downto 16), Instruction(15 downto 11), WriteRegister);
    reg_write_mux : mux32
	port map (MemtoReg, ALUOut, MDROut, RegWriteData);
    the_registers : registers
	port map (clock, RegWrite, Instruction(25 downto 21), Instruction(20 downto 16), WriteRegister, RegWriteData, ReadData1, ReadData2);
    reg_A : reg32
	port map (clock, ReadData1, AOut);
    reg_B : reg32
	port map (clock, ReadData2, BOut);
    sign_extend : signext
	port map (Instruction(15 downto 0), ExtOffset);
    offset_shifter : sl2
	port map (ExtOffset, SLOffset);
    ALUa_mux : mux32
	port map (ALUSrcA, CurrentPC, AOut, ALUa);
    ALUb_mux : mux4x32
	port map (ALUSrcB, BOut, Four, ExtOffset, SLOffset, ALUb);
    ALUcontrol_block : ALUcontrol
	port map (Instruction(5 downto 0), ALUOp, ALUoperation);
    the_ALU : alu
	port map (ALUa, ALUb, ALUoperation, ALUresult, Zero);
    ALU_Out_reg : reg32
	port map (clock, ALUresult, ALUOut);
    jaddr_block : jaddr
	port map (CurrentPC(31 downto 28), Instruction(25 downto 0), JumpAddr);
    pc_mux : mux4x32
	port map (PCSource, ALUresult, ALUOut, JumpAddr, ALUOut, NextPC);
    and_gate : and2
	port map (Zero, PCWriteCond, PCWCandZ);
    or_gate : or2
	port map (PCWCandZ, PCWrite, PCLoad);

end struct;




