-- 4-bit 4-to-1 MUX for ucode sequencer (Fig. C.16, COD2e)
entity mux4x4 is
    port (Sel : in bit_vector(1 downto 0);		     -- select input
	  Din0,Din1,Din2,Din3 : in bit_vector(3 downto 0);   -- data inputs
	  Dout : out bit_vector(3 downto 0));		     -- data output
end mux4x4;

architecture dataflow of mux4x4 is
    
begin  -- dataflow

    with Sel select
	Dout <= 
	Din0 after 1 ns when "00",
	Din1 after 1 ns when "01",
    	Din2 after 1 ns when "10",
    	Din3 after 1 ns when "11";

end dataflow;
