library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_SPI is
    port (
        HCLK       : in  std_logic;                         -- AHB clock signal
        HRESETn    : in  std_logic; 
        HADDR      : in  std_logic_vector(31 downto 0);
        HWRITE     : in  std_logic;                    
        HWDATA     : in  std_logic_vector(31 downto 0);
        HRDATA     : out std_logic_vector(31 downto 0);
        HREADYOUT  : out std_logic;                    
        HRESP      : out std_logic;                    
        HSIZE      : in  std_logic_vector(2 downto 0); 
        HBURST     : in  std_logic_vector(2 downto 0); 
        HTRANS     : in  std_logic_vector(1 downto 0); 
        HPROT      : in  std_logic_vector(3 downto 0); 
        HMASTLOCK  : in  std_logic; 
        HREADY     : in  std_logic; 
        HSELx      : in  std_logic;
        
        
        MOSI       : out std_logic;  -- Master Out Slave In
        MISO       : in std_logic;  -- Master In Slave Out
        SCK        : out std_logic;     -- Serial Clock
        SS         : out std_logic     -- Slave Select
    );
end IP_SPI;

architecture Behavioral of IP_SPI is
begin
    -- Empty architecture for now
end Behavioral;
