


entity cache is
      port(clk: in bit;
           pcAddress, imInsturction : in bit_vector(31 downto 0);
          
           instructionAddress,cpu: out bit_vector(31 downto 0);
           pcEnable : out bit);
end cache;



architecture behavior of cache is
signal validIn, WE, validOut: bit;
signal tagIn, tagOut: bit_vector(9 downto 0);
signal imDataIn: bit_vector(31 downto 0);
signal indexOut: bit_vector(3 downto 0);



component cacheC
	port(clk, validIn: in bit;
    	tagIn: in bit_vector(9 downto 0);
        instrIn, imDataIn: in bit_vector(31 downto 0);
        
     WE, pcEnableOut: out bit;
     indexOut: out bit_vector(3 downto 0);
     tagOut: out bit_vector(9 downto 0);             
    instrucOut, imData : out bit_vector(31 downto 0));
  end component;

component cacheM
   port (
          indexIn : in bit_vector(3 downto 0);
          tagIn : in bit_vector(9 downto 0);
          clk,WE: in bit;
          InstIn: bit_vector(31 downto 0);


          InstrOut: out bit_vector(31 downto 0);
          tagOut: out bit_vector(9 downto 0);
          validOut: out bit);   
   end component;

begin 
    cacheController: cacheC
    port map(clk, validIn, tagIn, imDataIn, pcAddress,
      WE, pcEnable, indexOut, tagOut, instructionAddress, cpu );

    cacheMemory: cacheM
    port map(indexOut, tagOut, clk, WE,imInsturction, 
      imDataIn, tagIn, validIn);
 end;   


