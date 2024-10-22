library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_CCP is
    port (
        -- AHB Lite Interface
        HCLK       : in  std_logic;
        HRESETn    : in  std_logic;
        HADDR      : in  std_logic_vector(31 downto 0);
        HWRITE     : in  std_logic;
        HWDATA     : in  std_logic_vector(31 downto 0);
        HRDATA     : out std_logic_vector(31 downto 0);
        HREADY     : out std_logic;

        -- CCP Specific Pins
        Data        : in  std_logic_vector(7 downto 0);
        PIXCLK     : in std_logic;      -- Pixel clock
        HSYNC      : in std_logic;      -- Horizontal sync
        VSYNC      : in std_logic;      -- Vertical sync
        MCLK       : out std_logic     -- Master clock
        
    );
end IP_CCP;

architecture Behavioral of IP_CCP is
begin
    -- Empty architecture for now
end Behavioral;
