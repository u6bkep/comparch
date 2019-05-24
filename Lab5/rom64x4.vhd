-- Dispatch table for ucode sequencer (Fig C.16 COD2e)
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom64x4 is
    
    port (Address : in bit_vector(5 downto 0);
          Data : out bit_vector(3 downto 0));

end rom64x4;

architecture behave of rom64x4 is

    signal intAddress : natural;  -- unsigned integer address
    -- Type for memory
    type memoryType is array (0 to 63) of bit_vector(3 downto 0);
    -- Memory itself
    signal memory : memoryType;

begin  -- array
    
    intAddress <= conv_integer(to_stdlogicvector(Address));
    Data <= memory(intAddress) after 5 ns;
    
end behave;
