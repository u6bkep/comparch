-- Basic Pipeliend Datapath

use work.mipspack.all;

entity pipelined is
    
    port (clock : in bit);

end pipelined;

architecture struct of pipelined is

    -- Control signals from "Control" block
    signal RegDst : bit;     -- select dest reg number
    signal Branch : bit;     -- asserted on beq
    signal MemRead : bit;    -- read data memory
    signal MemtoReg : bit;   -- select data memory to drive reg write data input
    signal ALUOp : bit_vector(1 downto 0);  -- 2-bit code to ALU control
    signal MemWrite : bit;   -- write data memory
    signal ALUSrc : bit;     -- select offset field to drive ALU b input
    signal RegWrite : bit;   -- write to register file
    signal SWp : bit;        -- store word + instruction control

    -- Other status/control signals from combinational parts
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
    --signal Instruction : bit_vector(31 downto 0);  -- "Instruction" output of IF_ID
    signal WriteRegister : bit_vector(4 downto 0);  -- write-register number
    signal WriteRegister_intermediate : bit_vector(4 downto 0);
    signal ALUa,ALUb : bit_vector(31 downto 0);    -- ALU "a" and "b" inputs
    signal ALUresult : bit_vector(31 downto 0);    -- ALU result output
    
    signal ReadData1: bit_vector(31 downto 0);     -- Read data 1 register output
    signal ReadData2: bit_vector(31 downto 0);     -- Read data 2 register output
    signal MemReadData : bit_vector(31 downto 0);  -- Read data output of memory
    signal RegWriteData : bit_vector(31 downto 0); -- Write data input to registers  
    
        -- Pipeline registers:
    signal IF_ID: bit_vector(63 downto 0);
    signal ID_EX: bit_vector(147 downto 0);
    signal EX_MEM: bit_vector(139 downto 0);
    signal MEM_WB: bit_vector(70 downto 0);
   
    -- Inputs of pipeline registers
    signal IF_ID_in: bit_vector(63 downto 0);
    signal ID_EX_in: bit_vector(147 downto 0);
    signal EX_MEM_in: bit_vector(139 downto 0);
    signal MEM_WB_in: bit_vector(70 downto 0);
    
    -- Instruction fetch (IF):
    signal Instruction_IM: bit_vector(31 downto 0); --Output of IMem
    
    --Instrucitn decode (ID):
    signal ReadAdrs1, ReadAdrs2: bit_vector(4 downto 0);
    signal Instruction : bit_vector(31 downto 0);  -- "Instruction" output of IF_ID

    -- I type instruction aliases for EX stage
    alias I_opcode : bit_vector(5 downto 0) is Instruction(31 downto 26);
    alias I_rs : bit_vector(4 downto 0) is Instruction(25 downto 21);
    alias I_rt : bit_vector(4 downto 0) is Instruction(20 downto 16);
    alias I_immediate : bit_vector(15 downto 0) is Instruction(15 downto 0);

    --Execution (EX):
    signal ALUOp_ID_EX: bit_vector(1 downto 0);
    signal ALUSrc_ID_EX : bit;
    signal RegDst_ID_EX: bit;
    signal SWp_ID_EX : bit;
    signal dataB: bit_vector(31 downto 0);
    signal Mux_aluA: bit_vector(1 downto 0);
    signal Mux_dataB: bit_vector(1 downto 0);
    signal alua_p4 : bit_vector(31 downto 0);
    
    --Memory access (MEM)
    signal ALUResult_EX_MEM: bit_vector(31 downto 0);
    signal ALUResult_EX_MEM_2 : bit_vector(31 downto 0);
    signal MemWrite_EX_MEM : bit;
    signal MemRead_EX_MEM: bit;
    signal Branch_EX_MEM : bit;
    signal WriteRegister_EX_MEM: bit_vector(4 downto 0);
    signal BranchPC_EX_MEM: bit_vector(31 downto 0);
    signal SWp_EX_MEM : bit;
    signal data_to_mem: bit_vector(31 downto 0);
    alias alua_p4_EX_MEM : bit_vector(31 downto 0) is EX_MEM(138 downto 107);
    
    --Write back (WB)
    signal MemtoReg_MEM_WB : bit;
    signal RegWrite_MEM_WB : bit;
    signal WriteRegister_MEM_WB: bit_vector(4 downto 0);
    signal ALUresult_MEM_WB, MemReadData_MEM_WB: bit_vector(31 downto 0);

    ---------------    

begin  -- struct

--***** Meaningful names are assigned to control signals:
ALUOp_ID_EX    <= ID_EX(146 downto 145);
ALUSrc_ID_EX   <= ID_EX(144);
RegDst_ID_EX   <= ID_EX(143);
SWp_ID_EX      <= ID_EX(147);
    
MemWrite_EX_MEM  <= EX_MEM(106);   
MemRead_EX_MEM   <= EX_MEM(105);  
Branch_EX_MEM    <= EX_MEM(104);
SWp_EX_MEM       <= EX_MEM(139);
    
MemtoReg_MEM_WB <= MEM_WB(70);   
RegWrite_MEM_WB <= MEM_WB(69);


--******************************************************************
--****** Input vectors of pipeline registers are formed here: ******
--********************* Fill in the blanks *************************
--*************** Use the concatenation operator "&" ***************
--**** Port map statements will help you find the right actuals ****

IF_ID_in    <= IncrPC & Instruction_IM;


Instruction <= IF_ID(31 downto 0);  -- To make code more readable

ID_EX_in <= SWp & ALUOp & ALUSrc & RegDst & MemWrite & MemRead & 
            Branch & MemtoReg & RegWrite
            & IF_ID(63 downto 32) &  ReadData1 & ReadData2 & ExtOffset & 
            Instruction(25 downto 21) 
            & Instruction(20 downto 16);

--Before and after
--ALUOp & ALUSrc & RegDst & MemWrite & MemRead & 
--Branch & MemtoReg & RegWrite & IF_ID(63 downto 32 ) & ReadData1 & ReadData2 & ExtOffset & Instruction(25 downto 21) & Insturction(20 downto 16);



EX_MEM_in <=alua_p4 & SWp_ID_EX & ID_EX(142 downto 140) & ID_EX(139 downto 138) & BranchPC & zero & ALUresult & dataB & WriteRegister;



-- NOTE: MemReadData is output of data memory.
-- NOTE: ALUResult_EX_MEM <= EX_MEM(68 downto 37);

WriteRegister_EX_MEM <= EX_MEM(4 downto 0);

MEM_WB_in <= EX_MEM(103 downto 102) & ALUResult_EX_MEM_2 & MemReadData & WriteRegister_EX_MEM;



-- **** On every clock edge pipeline registers are loaded: ****
PROCESS (clock)
begin
   If (clock'event and clock = '1') then
      IF_ID  <= IF_ID_in;
      ID_EX  <= ID_EX_in;
      EX_MEM <= EX_MEM_in;
      MEM_WB <= MEM_WB_in;
   End If;
End Process;

--*******************************************************
--************ Port Map statements are here: ************

    program_counter : pc
	port map (clock,NextPC,CurrentPC);
	    
	       
    instruction_memory : imem
	port map (CurrentPC,Instruction_IM);
	    
	    
    pc_adder : add
	port map (CurrentPC,Four,IncrPC);
	    
	    
    offset_shifter : sl2
	port map (ID_EX(41 downto 10),SLOffset);
	    
	    
    branch_adder : add
	port map (ID_EX(137 downto 106),SLOffset,BranchPC);
	    
	   
	BranchPC_EX_MEM <= EX_MEM(101 downto 70);
    pc_mux : mux32
	port map (PCSrc,IncrPC,BranchPC_EX_MEM,NextPC);
	    
	   
	 ReadAdrs1 <= Instruction(25 downto 21);
	 ReadAdrs2 <= Instruction(20 downto 16);
	 WriteRegister_MEM_WB <= MEM_WB(4 downto 0);
	  
    the_registers : registers
	port map (clock,RegWrite_MEM_WB,
		  ReadAdrs1,ReadAdrs2,
		  MEM_WB(4 downto 0),
		  RegWriteData,ReadData1,ReadData2);		  
	
    reg_mux : mux5
	port map (RegDst_ID_EX,
		  ID_EX(4 downto 0), ID_EX(25 downto 21),
		  WriteRegister_intermediate);

    reg_mux_2 : mux5
    port map(SWp, 
        WriteRegister_intermediate, ID_EX(9 downto 5),
        WriteRegister);

	  
    sign_extend : signext
	port map (Instruction(15 downto 0),ExtOffset);
	    
	    
    ALU_mux : mux32
	port map (ALUSrc_ID_EX, dataB ,ID_EX(41 downto 10),ALUb);
	    
	    
    --alua <= ID_EX(105 downto 74);
    
    the_ALU : alu
	port map (ALUa,ALUb,ALUfunc,ALUresult,Zero);
	    
	     
    data_to_mem <= EX_MEM(36 downto 5);
    ALUResult_EX_MEM <= EX_MEM(68 downto 37);
    
    data_memory : dmem
	 port map (clock,MemWrite_EX_MEM,MemRead_EX_MEM,ALUResult_EX_MEM,
	 data_to_mem,MemReadData);   
	 ALUresult_MEM_WB <= MEM_WB(68 downto 37);
	 MemReadData_MEM_WB <= MEM_WB(36 downto 5);
	   
    
    mem_data_mux : mux32
	port map (MemtoReg_MEM_WB,ALUresult_MEM_WB,MemReadData_MEM_WB,RegWriteData);
    
	    
    control_block : control
	port map (Instruction(31 downto 26),
		  RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,SWp,ALUOp);
		  
		  
    ALUcontrol_block : ALUcontrol
	port map (ID_EX(15 downto 10),ALUOp_ID_EX,ALUfunc);
	      
 
    and_gate : and2
	port map (Branch_EX_MEM,EX_MEM(69),PCSrc);

    forwardingUnit: FU
    port map(ID_EX(4 downto 0), ID_EX(9 downto 5), EX_MEM(4 downto 0), MEM_WB(4 downto 0),
            EX_MEM(102), MEM_WB(69), Mux_aluA, Mux_dataB);

    aluA_mux : mux4x32
    port map(Mux_aluA, ID_EX(105 downto 74), RegWriteData, ALUResult_EX_MEM, ALUResult_EX_MEM,
             ALUa);

    datab_mux : mux4x32
    port map(Mux_dataB, ID_EX(73 downto 42), RegWriteData, ALUResult_EX_MEM, ALUResult_EX_MEM,
            dataB);            

    SWp_ALUresault_mux : mux32
    port map(SWp,
        ALUResult_EX_MEM, alua_p4_EX_MEM,
        ALUResult_EX_MEM_2);

    alua_p4_adder : add
    port map(ALUa, X"00000004", alua_p4);



end struct;




