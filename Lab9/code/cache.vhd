


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
          clk, WE   : in bit;
          address   : in bit_vector(3 downto 0);
          data_W    : in bit_vector(41 downto 0);

          data_R    : out bit_vector(42 downto 0));   
   end component;

begin 
    cacheController: cacheC
    port map(clk         => clk,
             validIn     => validIn,
             tagIn       => tagIn,
             instrIn     => imDataIn,
             imDataIn    => pcAddress,
             WE          => WE,
             pcEnableOut => pcEnable,
             indexOut    => indexOut,
             tagOut      => tagOut,
             instrucOut  => instructionAddress,
             imData      => cpu );

    cacheMemory: cacheM
    port map(indexIn     => indexOut,
             tagIn       => tagOut,
             clk         => clk,
             WE          => WE,
             InstIn      => imInsturction,
             InstrOut    => imDataIn,
             tagOut      => tagIn,
             validOut    => validIn);
 end;   


