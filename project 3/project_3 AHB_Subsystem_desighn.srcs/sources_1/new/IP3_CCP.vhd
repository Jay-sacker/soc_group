library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_CCP is
    port (

        -- AHB Lite Interface
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
