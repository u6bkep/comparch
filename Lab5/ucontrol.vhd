-- Microprogrammed MIPS control unit (Fig. C.15/C.16 COD2e)

use work.mipspack.all;

entity ucontrol is
    port (clock : in bit;
	  Opcode : in bit_vector(5 downto 0);         -- instruction opcode field
	  Controls : inout bit_vector(17 downto 0));  -- control signals
end ucontrol;

architecture struct of ucontrol is
    
    signal CurrentuPC,IncruPC,NextuPC : bit_vector(3 downto 0);
    signal dROM1Out,dROM2Out : bit_vector(3 downto 0);
    signal Zero : bit_vector(3 downto 0) := "0000";
    signal One : bit_vector(3 downto 0) := "0001";

begin  -- struct

    -- ucode ROM
    urom : rom16x18
	port map (CurrentuPC,Controls);
    -- uprogram counter
    uPC : reg4
	port map (clock,NextuPC,CurrentuPC);
    -- uPC incrementer
    adder : add4
	port map (CurrentuPC,One,IncruPC);
    -- Dispatch ROM 1
    dROM1 : rom64x4
	port map (Opcode,dROM1Out);
    -- Dispatch ROM 2
    dROM2 : rom64x4
	port map (Opcode,dROM2Out);
    -- uPC input MUX
    uPC_mux : mux4x4
	port map (Controls(1 downto 0),Zero,dROM1Out,dROM2Out,IncruPC,NextuPC);
    
end struct;
