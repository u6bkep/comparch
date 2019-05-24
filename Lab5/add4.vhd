-- 4-bit add element for ucode sequencer (Fig. C.16, COD2e)
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity add4 is
    
    port (a,b : in bit_vector(3 downto 0);
	  sum : out bit_vector(3 downto 0));

end add4;

architecture behave of add4 is
begin  -- behave
    sum <= to_bitvector(to_stdlogicvector(a) + to_stdlogicvector(b))
	   after 2 ns;  		-- assume full carry lookahead
end behave;

