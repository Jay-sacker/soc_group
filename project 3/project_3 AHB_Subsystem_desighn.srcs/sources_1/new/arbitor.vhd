library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AHB_Arbiter is
    port (
        -- AHB Lite Interface signals from each IP
        HADDR1     : in  std_logic_vector(31 downto 0);
        HWRITE1    : in  std_logic;
        HWDATA1    : in  std_logic_vector(31 downto 0);
        HRDATA1    : out std_logic_vector(31 downto 0);
        HREADY1    : out std_logic;

        HADDR2     : in  std_logic_vector(31 downto 0);
        HWRITE2    : in  std_logic;
        HWDATA2    : in  std_logic_vector(31 downto 0);
        HRDATA2    : out std_logic_vector(31 downto 0);
        HREADY2    : out std_logic;

        HADDR3     : in  std_logic_vector(31 downto 0);
        HWRITE3    : in  std_logic;
        HWDATA3    : in  std_logic_vector(31 downto 0);
        HRDATA3    : out std_logic_vector(31 downto 0);
        HREADY3    : out std_logic;

        HADDR4     : in  std_logic_vector(31 downto 0);
        HWRITE4    : in  std_logic;
        HWDATA4    : in  std_logic_vector(31 downto 0);
        HRDATA4    : out std_logic_vector(31 downto 0);
        HREADY4    : out std_logic;

        HADDR5     : in  std_logic_vector(31 downto 0);
        HWRITE5    : in  std_logic;
        HWDATA5    : in  std_logic_vector(31 downto 0);
        HRDATA5    : out std_logic_vector(31 downto 0);
        HREADY5    : out std_logic;

        HADDR6     : in  std_logic_vector(31 downto 0);
        HWRITE6    : in  std_logic;
        HWDATA6    : in  std_logic_vector(31 downto 0);
        HRDATA6    : out std_logic_vector(31 downto 0);
        HREADY6    : out std_logic;

        -- CPU AHB Lite Interface
        HADDR_CPU  : out std_logic_vector(31 downto 0);
        HWRITE_CPU : out std_logic;
        HWDATA_CPU : out std_logic_vector(31 downto 0);
        HRDATA_CPU : in  std_logic_vector(31 downto 0);
        HREADY_CPU : in  std_logic;

        -- Clock and reset
        HCLK       : in  std_logic;
        HRESETn    : in  std_logic
    );
end AHB_Arbiter;

architecture Behavioral of AHB_Arbiter is
    signal arb_state : integer range 0 to 5 := 0;  -- Round-robin state
    signal grant     : std_logic_vector(5 downto 0); -- Grant signal for each IP

begin

    process (HCLK, HRESETn)
    begin
        if HRESETn = '0' then
            arb_state <= 0;
            grant <= (others => '0');
        elsif rising_edge(HCLK) then
            case arb_state is
                when 0 =>
                    if HWRITE1 = '1' then
                        -- Grant access to 12C IP
                        grant <= "000001";
                        HADDR_CPU  <= HADDR1;
                        HWRITE_CPU <= HWRITE1;
                        HWDATA_CPU <= HWDATA1;
                        HRDATA1    <= HRDATA_CPU;
                        HREADY1    <= HREADY_CPU;
                    else
                        arb_state <= 1;
                    end if;
                when 1 =>
                    if HWRITE2 = '1' then
                        -- Grant access to SPI IP
                        grant <= "000010";
                        HADDR_CPU  <= HADDR2;
                        HWRITE_CPU <= HWRITE2;
                        HWDATA_CPU <= HWDATA2;
                        HRDATA2    <= HRDATA_CPU;
                        HREADY2    <= HREADY_CPU;
                    else
                        arb_state <= 2;
                    end if;
                when 2 =>
                    if HWRITE3 = '1' then
                        -- Grant access to CCP IP
                        grant <= "000100";
                        HADDR_CPU  <= HADDR3;
                        HWRITE_CPU <= HWRITE3;
                        HWDATA_CPU <= HWDATA3;
                        HRDATA3    <= HRDATA_CPU;
                        HREADY3    <= HREADY_CPU;
                    else
                        arb_state <= 3;
                    end if;
                when 3 =>
                    if HWRITE4 = '1' then
                        -- Grant access to UART IP
                        grant <= "001000";
                        HADDR_CPU  <= HADDR4;
                        HWRITE_CPU <= HWRITE4;
                        HWDATA_CPU <= HWDATA4;
                        HRDATA4    <= HRDATA_CPU;
                        HREADY4    <= HREADY_CPU;
                    else
                        arb_state <= 4;
                    end if;
                when 4 =>
                    if HWRITE5 = '1' then
                        -- Grant access to SSI IP
                        grant <= "010000";
                        HADDR_CPU  <= HADDR5;
                        HWRITE_CPU <= HWRITE5;
                        HWDATA_CPU <= HWDATA5;
                        HRDATA5    <= HRDATA_CPU;
                        HREADY5    <= HREADY_CPU;
                    else
                        arb_state <= 5;
                    end if;
                when 5 =>
                    if HWRITE6 = '1' then
                        -- Grant access to SOSSI IP
                        grant <= "100000";
                        HADDR_CPU  <= HADDR6;
                        HWRITE_CPU <= HWRITE6;
                        HWDATA_CPU <= HWDATA6;
                        HRDATA6    <= HRDATA_CPU;
                        HREADY6    <= HREADY_CPU;
                    else
                        arb_state <= 0; -- Go back to I2C IP
                    end if;
                when others =>
                    arb_state <= 0;
            end case;
        end if;
    end process;

end Behavioral;
