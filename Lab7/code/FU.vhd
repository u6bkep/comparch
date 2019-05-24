library IEEE;
use IEEE.std_logic_1164.all;
use work.mipspack.all;
-- Fowarding Unit

entity FU is
    port (rt_EX,rs_EX, WriteRegister_MEM, WriteRegister_WB : in bit_vector(4 downto 0);
          RegWrite_MEM, RegWrite_WB : in bit;
	  Mux_aluA, Mux_dataB : out bit_vector(1 downto 0));
end FU;

architecture dataflow of FU is
    
begin  -- dataflow
      
     Mux_aluA_FUSub : FUSub
     port map(rt_EX, WriteRegister_MEM, WriteRegister_WB, RegWrite_MEM, RegWrite_WB, Mux_aluA);

     Mux_dataB_FUSub : FUSub
     port map(rs_EX, WriteRegister_MEM, WriteRegister_WB, RegWrite_MEM, RegWrite_WB, Mux_dataB);

end dataflow;