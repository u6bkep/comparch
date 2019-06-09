-- Instruction Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity imem is
    
    port (index : in bit_vector(3 downto 0);
        TagIn : in bit_vector(9 downto 0);
        WE : in bit;
        InstIn : bit_vector(31 downto 0);

    InstOut : out bit_vector(31 downto 0);
        TagOut : out bit_vector (9 downto 0);
        Valid : out bit);

end imem;

architecture behave of imem is

    signal intAddress : natural;  -- unsigned integer address
    -- Type for memory (only 256+3 bytes implemented)
    --  (extra bytes needed in case of word accesses to last 3 bytes)
    type memoryType is array (0 to 15) of bit_vector(42 downto 0);
    -- Memory itself
    signal memory : memoryType;



begin  -- array
    intAddress <= conv_integer(to_stdlogicvector(ReadAddress(7 downto 0)));
    InstOut <= memory(intAddress)(31 downto 0);
    TagOut <= memory(intAddress)(41 downto 32);
    Valid <= memory(intAddress)()

    after 5 ns;
end behave;
