-- Instruction Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cacheM is
    
    port (
          clk, WE   : in bit;
          address   : in bit_vector(3 downto 0);
          data_W    : in bit_vector(41 downto 0);

          data_R    : out bit_vector(42 downto 0));

end cacheM;

architecture behave of cacheM is
    
    signal intAddress : natural;  -- unsigned integer address
    -- Type for memory (only 256+3 bytes implemented)
    --  (extra bytes needed in case of word accesses to last 3 bytes)
    type memoryType is array (0 to 15) of bit_vector(42 downto 0);
    -- Memory itself
    signal memory : memoryType;
--    signal data: bit_vector(42 downto 0);
--    alias valid: bit is data(42);
--    alias tag: bit_vector(9 downto 0) is data(41 downto 32);
--    alias Instruction: bit_vector(31 downto 0) is data(31 downto 0);

begin  -- behave
    

     -- convert address to integer
    intAddress <= conv_integer(to_stdlogicvector(address));
   
    data_R <= memory(intAddress);


    process (clk)
    begin
        -- if rising edge of clock and WE, then write locations
        if clk = '1' and WE = '1' then
        memory(intAddress)  <= '1' & data_R;              

        end if;
    end process;
        
end behave;
