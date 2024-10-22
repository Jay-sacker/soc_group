library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_SSI is
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
        
        SSI_CLK    : out std_logic;    -- SSI Clock
        FSS        : out std_logic;    -- Frame Sync Select
        TXD        : out std_logic;    -- Transmit Data
        RXD        : in std_logic      -- Receive Data
    );
end IP_SSI;

architecture Behavioral of IP_SSI is
begin
    -- Empty architecture for now
end Behavioral;
