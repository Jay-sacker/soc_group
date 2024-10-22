library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_CCP is
    port (

        -- AHB Lite Interface
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

        -- CCP Specific Pins
        Data        : in  std_logic_vector(7 downto 0);
        PIXCLK     : in std_logic;      -- Pixel clock
        HSYNC      : in std_logic;      -- Horizontal sync
        VSYNC      : in std_logic;      -- Vertical sync
        CCP_CLK       : out std_logic     -- CCP clock
        
    );
end IP_CCP;

architecture Behavioral of IP_CCP is
begin
    -- Empty architecture for now
end Behavioral;
