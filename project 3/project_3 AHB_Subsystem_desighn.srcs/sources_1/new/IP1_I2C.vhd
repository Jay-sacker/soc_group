library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_I2C is
    port (
        HCLK       : in  std_logic;    -- Clock for I2C
        HRESETn    : in  std_logic;    -- Reset for I2C
        HADDR      : in  std_logic_vector(31 downto 0);  -- Address bus for I2C
        HWRITE     : in  std_logic;    -- Write control for I2C
        HWDATA     : in  std_logic_vector(31 downto 0);  -- Write data for I2C
        HRDATA     : out std_logic_vector(31 downto 0);  -- Read data for I2C
        HREADY     : out std_logic;    -- Ready signal for I2C
        SDA        : inout std_logic;  -- Serial Data Line (bidirectional)
        SCL        : in std_logic      -- Serial Clock Line (input)
    );
end IP_I2C;

architecture Behavioral of IP_I2C is
begin
    -- Empty architecture for now
end Behavioral;
