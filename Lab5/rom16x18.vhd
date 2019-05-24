-- uprogram ROM for ucode sequencer (Fig C.15 COD2e)
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom16x18 is
    
    port (Address : in bit_vector(3 downto 0);
          Data : out bit_vector(17 downto 0));

end rom16x18;

architecture behave of rom16x18 is

    signal intAddress : natural;  -- unsigned integer address
    -- Type for memory
    type memoryType is array (0 to 15) of bit_vector(17 downto 0);
    -- Memory itself
    signal memory : memoryType;

begin  -- array
    
    intAddress <= conv_integer(to_stdlogicvector(Address));
    Data <= memory(intAddress) after 5 ns;
    
end behave;
