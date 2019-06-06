-- single-cycle datapath
-- you will add a cache to single-cycle MIPS as explained in lab handout.

use work.mipspack.all;

entity SingleCycle is
    port (clock : in bit);
end SingleCycle;

architecture struct of SingleCycle is

    -- Control signals from "Control" block
    signal RegDst : bit;     -- select dest reg number
    signal Branch : bit;     -- asserted on beq
    signal MemRead : bit;    -- read data memory
    signal MemtoReg : bit;   -- select data memory to drive reg write data input
    signal ALUOp : bit_vector(1 downto 0);  -- 2-bit code to ALU control
    signal MemWrite : bit;   -- write data memory
    signal ALUSrc : bit;     -- select offset field to drive ALU b input
    signal RegWrite : bit;   -- write to register file

    -- Other status/control signals
    signal Zero : bit;       -- indicates "0" result from ALU
    signal PCSrc : bit;      -- select branch target address to load into PC
    signal ALUfunc : bit_vector(2 downto 0);  -- 3-bit ALU control code

    -- Data signals
    signal CurrentPC : bit_vector(31 downto 0);    -- output of PC
    signal NextPC : bit_vector(31 downto 0);       -- input to PC
    signal Four : bit_vector(31 downto 0) := X"00000004";  -- constant
    signal IncrPC : bit_vector(31 downto 0);       -- output of PC-increment adder
    signal ExtOffset : bit_vector(31 downto 0);    -- sign-extended branch offset
    signal SLOffset : bit_vector(31 downto 0);     -- branch offset shifted left 2
    signal BranchPC : bit_vector(31 downto 0);     -- output of branch-offset adder
    signal Instruction : bit_vector(31 downto 0);  -- output of instruction memory
    signal WriteRegister : bit_vector(4 downto 0);  -- write-register number
    signal ALUa,ALUb : bit_vector(31 downto 0);    -- ALU "a" and "b" inputs
    signal ALUresult : bit_vector(31 downto 0);    -- ALU result output
    signal ReadData2: bit_vector(31 downto 0);     -- Read data 2 register output
    signal MemReadData : bit_vector(31 downto 0);  -- Read data output of memory
    signal RegWriteData : bit_vector(31 downto 0); -- Write data input to registers

begin  -- struct

    program_counter : pc
	port map (clock,NextPC,CurrentPC);
    instruction_memory : imem
	port map (CurrentPC,Instruction);
    pc_adder : add
	port map (CurrentPC,Four,IncrPC);
    offset_shifter : sl2
	port map (ExtOffset,SLOffset);
    branch_adder : add
	port map (IncrPC,SLOffset,BranchPC);
    pc_mux : mux32
	port map (PCSrc,IncrPC,BranchPC,NextPC);
    the_registers : registers
	port map (clock,RegWrite,
		  Instruction(25 downto 21),
		  Instruction(20 downto 16),
		  WriteRegister,
		  RegWriteData,ALUa,ReadData2);
    reg_mux : mux5
	port map (RegDst,
		  Instruction(20 downto 16),Instruction(15 downto 11),
		  WriteRegister);
    sign_extend : signext
	port map (Instruction(15 downto 0),ExtOffset);
    ALU_mux : mux32
	port map (ALUSrc,ReadData2,ExtOffset,ALUb);
    the_ALU : alu
	port map (ALUa,ALUb,ALUfunc,ALUresult,Zero);
    data_memory : dmem
	port map (clock,MemWrite,MemRead,ALUresult,ReadData2,MemReadData);
    mem_data_mux : mux32
	port map (MemtoReg,ALUresult,MemReadData,RegWriteData);
    control_block : control
	port map (Instruction(31 downto 26),
		  RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp);
    ALUcontrol_block : ALUcontrol
	port map (Instruction(5 downto 0),ALUOp,ALUfunc);
    and_gate : and2
	port map (Branch,Zero,PCSrc);

end struct;




