-- Instruction Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cacheM is
    
<<<<<<< HEAD
    port (index : in bit_vector(3 downto 0);
        TagIn : in bit_vector(9 downto 0);
        WE : in bit;
        InstIn : bit_vector(31 downto 0);

    InstOut : out bit_vector(31 downto 0);
        TagOut : out bit_vector (9 downto 0);
        Valid : out bit);
=======
    port (
          indexIn : in bit_vector(3 downto 0);
          tagIn : in bit_vector(9 downto 0);
          clk,WE: in bit;
          InstIn: bit_vector(31 downto 0);


          InstrOut: out bit_vector(31 downto 0);
          tagOut: out bit_vector(9 downto 0);
          validOut: out bit);  
>>>>>>> Ethan

end cacheM;

architecture behave of cacheM is
    
    signal intAddress : natural;  -- unsigned integer address
    -- Type for memory (only 256+3 bytes implemented)
    --  (extra bytes needed in case of word accesses to last 3 bytes)
    type memoryType is array (0 to 15) of bit_vector(42 downto 0);
    -- Memory itself
    signal memory : memoryType;
    signal data: bit_vector(42 downto 0);
    alias valid: bit is data(42);
    alias tag: bit_vector(9 downto 0) is data(41 downto 32);
    alias Instruction: bit_vector(31 downto 0) is data(31 downto 0);

begin  -- behave
    

     -- convert address to integer
    intAddress <= conv_integer(to_stdlogicvector(indexIn));
   
    data <= memory(intAddress);

    validOut <= valid;
    tagOut<= tag;
    InstrOut <= Instruction;      


    process (clk)
    begin
        -- if rising edge of clock and WE, then write locations
        if clk = '1' and WE = '1' then
        memory(intAddress)  <= '1' & tagIn & InstIn;              

<<<<<<< HEAD


begin  -- array
    intAddress <= conv_integer(to_stdlogicvector(ReadAddress(7 downto 0)));
    InstOut <= memory(intAddress)(31 downto 0);
    TagOut <= memory(intAddress)(41 downto 32);
    Valid <= memory(intAddress)()

    after 5 ns;
=======
        end if;
    end process;
        
>>>>>>> Ethan
end behave;
