-- 4-bit register element for ucode sequencer PC (Fig. C.16, COD2e)
library ieee;
use ieee.std_logic_1164.all;

entity reg4 is
    port (clk : in bit;           -- clock
          d : in bit_vector(3 downto 0);  -- data in
          q : out bit_vector(3 downto 0)); -- data out

end reg4;

architecture proc of reg4 is

begin  -- proc
    process (clk)
        
    begin  -- process
        if clk='1' then
	    q <= d after 1 ns;
	end if;
    end process;
end proc;
