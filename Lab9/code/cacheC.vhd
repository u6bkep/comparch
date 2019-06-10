-- 32-bit Adder
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cacheC is
    port (clk, validIn: in bit;
    	tagIn: in bit_vector(9 downto 0);
        instrIn, imDataIn: in bit_vector(31 downto 0);
        
     WE, pcEnableOut, validOut: out bit;
     indexOut: out bit_vector(3 downto 0);
     tagOut: out bit_vector(9 downto 0);             
    instrucOut, imData : out bit_vector(31 downto 0));
end cacheC;

architecture behave of cacheC is

signal tagCompare: bit;
signal hit : bit;
signal timer : std_logic_vector(0 to 4):= "00000";  

begin  -- behave
imData <= instrIn;    
indexOut <= instrIn(5 downto 2);
tagOut <= instrIn(15 downto 6);

tagCompare <= '1' when tagIn = instrIn(15 downto 6);
hit <= tagCompare and validIn;

instrucOut <= imDataIn when hit = '1' else
	             "00000000000000000000000000000000";

pcEnableOut <= '1' when hit = '1' else
	                    '0';
process(clk)
	begin
	if clk = '1' and hit = '1' then
           WE <='0';
           timer <= "00000";
           validOut <= '0';
           end if;

    if clk = '1' and hit = '0' then
            timer <= timer + 1;
            WE <= '0';
            validOut <= '0';
            end if;
    if timer = "10100" then
           WE <= '1';
           timer <= "00000";
           validOut <= '1';
           end if;
end process;

end behave;

