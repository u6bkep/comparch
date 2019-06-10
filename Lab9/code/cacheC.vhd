-- 32-bit Adder
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cacheC is
    port (clk           : in bit;
          cacheM_data_R : in bit_vector(42 downto 0);
          current_PC    : in bit_vector(31 downto 0);
          iMem_data     : in bit_vector(31 downto 0);

          cacheM_Address: out bit_vector(3 downto 0);
          cacheM_data_W : out bit_vector(41 downto 0);
          instruction   : out bit_vector(31 downto 0);
          iMem_address  : out bit_vector(31 downto 0);
          PC_WE         : out bit;
          cacheM_WE     : out bit);
end cacheC;

architecture behave of cacheC is

signal tagCompare: bit;
signal hit : bit;
signal timer : std_logic_vector(0 to 4):= "00000";

alias valid : bit is cacheM_data_R(42);
alias tag_R : bit_vector(9 downto 0) is cacheM_data_R(41 downto 32);
alias data_R: bit_vector(31 downto 0) is cacheM_data_R(31 downto 0);
alias tag_W : bit_vector(9 downto 0) is cacheM_data_W(41 downto 32);
alias data_W: bit_vector(31 downto 0)is cacheM_data_W(31 downto 0);
alias tag_PC: bit_vector(9 downto 0) is current_PC(15 downto 6);
alias index : bit_vector(3 downto 0) is current_PC(5 downto 2);

begin  -- behave

tag_W <= tag_PC;
tagCompare <= '1' when tag_R = tag_PC;
hit <= (valid and tagCompare);

instruction <=  data_R when hit = '1' else
                     "00000000000000000000000000000000";
PC_WE <= not hit;

cacheM_Address <= index;
data_W <= iMem_data;
iMem_address <= current_PC;

--instrucOut <= imDataIn when hit = '1' else
	--             "00000000000000000000000000000000";

--pcEnableOut <= '1' when hit = '1' else
--	                    '0';

--process(clk)
--	begin
--	if clk = '1' and hit = '1' then
--           WE <='0';
 --          timer <= "00000";
  --         validOut <= '0';
 --          end if;

 --   if clk = '1' and hit = '0' then
  --          timer <= timer + 1;
  --          WE <= '0';
  --         validOut <= '0';
    --        end if;
   -- if timer = "10100" then
        --   WE <= '1';
  --
         --  validOut <= '1';
         --  end if;
--end process;


PROCESS (clk)
BEGIN
	if clk = '1' THEN
		IF timer = "10100" THEN timer <= "00000";
		ELSIF timer = "00000" and hit = '1' then timer <= "00000";
		ELSE timer <= timer + 1;
		END IF;
	END IF;
END PROCESS;


     cacheM_WE  <= '1' WHEN timer = "10100" ELSE '0';

end behave;

