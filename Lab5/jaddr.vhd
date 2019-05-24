-- Jump address construction block (e.g., Fig 5.33 COD2e)

entity jaddr is
    port (pcMS4 : in bit_vector(3 downto 0);	     -- most significant 4 bits
                                                     -- of PC
	  jumpField : in bit_vector(25 downto 0);    -- 26-bit jump address field
	  jumpTarget : out bit_vector(31 downto 0)); -- full 32-bit jump
						     -- target address
end jaddr;

architecture dataflow of jaddr is
    
begin  -- dataflow

    jumpTarget <= pcMS4 & jumpField & "00" after 1 ns;
    
end dataflow;
