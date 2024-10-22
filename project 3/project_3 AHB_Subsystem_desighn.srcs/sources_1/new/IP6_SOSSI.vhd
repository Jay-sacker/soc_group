library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_SOSSI is
    port (
        HCLK       : in  std_logic;
        HRESETn    : in  std_logic;
        HADDR      : in  std_logic_vector(31 downto 0);
        HWRITE     : in  std_logic;
        HWDATA     : in  std_logic_vector(31 downto 0);
        HRDATA     : out std_logic_vector(31 downto 0);
        HREADY     : out std_logic;
        clk        : 
    );
end IP_SOSSI;

architecture Behavioral of IP_SOSSI is
begin
    -- Empty architecture for now
end Behavioral;
