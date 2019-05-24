-- 32-bit 4-to-1 MUX (e.g., Fig 5.33 COD2e)
entity mux4x32 is
    port (Sel : in bit_vector(1 downto 0);		     -- select input
	  Din0,Din1,Din2,Din3 : in bit_vector(31 downto 0);  -- data inputs
	  Dout : out bit_vector(31 downto 0));		     -- data output
end mux4x32;

architecture dataflow of mux4x32 is
    
begin  -- dataflow

    with Sel select
	Dout <= 
	Din0 after 1 ns when "00",
	Din1 after 1 ns when "01",
    	Din2 after 1 ns when "10",
    	Din3 after 1 ns when "11";

end dataflow;
