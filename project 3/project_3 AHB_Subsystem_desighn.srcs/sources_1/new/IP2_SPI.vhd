library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_SPI is
    port (
        HCLK       : in  std_logic;
        HRESETn    : in  std_logic;
        HADDR      : in  std_logic_vector(31 downto 0);
        HWRITE     : in  std_logic;
        HWDATA     : in  std_logic_vector(31 downto 0);
        HRDATA     : out std_logic_vector(31 downto 0);
        HREADY     : out std_logic;
        MOSI       : inout std_logic;  -- Master Out Slave In
        MISO       : inout std_logic;  -- Master In Slave Out
        SCK        : in std_logic;     -- Serial Clock
        SS         : out std_logic     -- Slave Select
    );
end IP_SPI;

architecture Behavioral of IP_SPI is
begin
    -- Empty architecture for now
end Behavioral;
