


entity cache is
      port(clk: in bit;
           current_PC, iMem_data : in bit_vector(31 downto 0);
          
           iMem_address, instruction: out bit_vector(31 downto 0);
           PC_WE : out bit);
end cache;

architecture behavior of cache is
signal cacheM_WE: bit;
signal cacheM_Address: bit_vector(3 downto 0);
signal cacheM_data_R : bit_vector(42 downto 0);
signal cacheM_data_W : bit_vector(41 downto 0);

component cacheC
	port(clk           : in bit;
       cacheM_data_R : in bit_vector(42 downto 0);
       current_PC    : in bit_vector(31 downto 0);
       iMem_data     : in bit_vector(31 downto 0);

       cacheM_Address: out bit_vector(3 downto 0);
       cacheM_data_W : out bit_vector(41 downto 0);
       instruction   : out bit_vector(31 downto 0);
       iMem_address  : out bit_vector(31 downto 0);
       PC_WE         : out bit;
       cacheM_WE     : out bit);
  end component;

component cacheM
   port (clk, WE   : in bit;
         address   : in bit_vector(3 downto 0);
         data_W    : in bit_vector(41 downto 0);

         data_R    : out bit_vector(42 downto 0));   
   end component;

begin 
    cacheController: cacheC
    port map(clk, cacheM_data_R, current_PC, iMem_data,
            cacheM_Address, cacheM_data_W, instruction,
            iMem_address, PC_WE, cacheM_WE);

    cacheMemory: cacheM
    port map(clk, cacheM_WE, cacheM_Address, 
            cacheM_data_W, cacheM_data_R);
 end;   


