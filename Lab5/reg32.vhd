-- 32-bit register element (no load control)
library ieee;
use ieee.std_logic_1164.all;

entity reg32 is
    port (clk : in bit;           -- clock
          d : in bit_vector(31 downto 0);  -- data in
          q : out bit_vector(31 downto 0)); -- data out

end reg32;

architecture proc of reg32 is

begin  -- proc
    process (clk)
        
    begin  -- process
        if clk='1' then
	    q <= d after 2 ns;
	end if;
    end process;
end proc;
