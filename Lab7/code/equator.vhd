-- Fowarding Unit

entity equator is
    port (in1, in2: in bit_vector(4 downto 0);
	  outSignal : out bit);
end equator;

architecture dataflow of equator is
    
begin  -- dataflow
    
            
    outSignal <= '1' when in1 = in2 else '0';

end dataflow;