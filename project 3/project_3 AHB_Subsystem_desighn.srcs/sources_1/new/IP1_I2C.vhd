library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_I2C is
    port (
        HCLK          : in  std_logic;                         -- AHB clock signal
        HRESETn       : in  std_logic; 
        HADDR      : std_logic_vector(31 downto 0);
        HWRITE     : std_logic;                    
        HWDATA     : std_logic_vector(31 downto 0);
        HRDATA     : std_logic_vector(31 downto 0);
        HREADYOUT  : std_logic;                    
        HRESP      : std_logic;                    
        HSIZE      : std_logic_vector(2 downto 0); 
        HBURST     : std_logic_vector(2 downto 0); 
        HTRANS     : std_logic_vector(1 downto 0); 
        HPROT      : std_logic_vector(3 downto 0); 
        HMASTLOCK  : std_logic; 
        
        
        SDA        : inout std_logic;  -- Serial Data Line (bidirectional)
        SCL        : in std_logic      -- Serial Clock Line (input)
    );
end IP_I2C;

architecture Behavioral of IP_I2C is
begin
    -- Empty architecture for now
end Behavioral;
