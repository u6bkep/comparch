-- 32-bit register element (with load control)
library ieee;
use ieee.std_logic_1164.all;

entity regld32 is
    port (clk,load : in bit;           -- clock, load control
          d : in bit_vector(31 downto 0);  -- data in
          q : out bit_vector(31 downto 0)); -- data out

end regld32;

architecture proc of regld32 is

begin  -- proc
    process (clk)
        
    begin  -- process
        if clk='1' and load='1' then
	    q <= d after 2 ns;
	end if;
    end process;
end proc;
