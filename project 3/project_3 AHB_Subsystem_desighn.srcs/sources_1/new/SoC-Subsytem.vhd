library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;  
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity SoC_Subsystem is
    port (
        -- External CPU AHB Lite Interface
        HCLK_CPU    : in  std_logic;
        HRESETn_CPU : in  std_logic;
        HADDR_CPU   : out std_logic_vector(31 downto 0);
        HWRITE_CPU  : out std_logic;
        HWDATA_CPU  : out std_logic_vector(31 downto 0);
        HRDATA_CPU  : in  std_logic_vector(31 downto 0);
        HREADY_CPU  : in  std_logic;

        -- SDA and SCL for I2C
        SDA1        : inout std_logic;   -- Serial Data Line (bidirectional)
        SCL1        : in std_logic;      -- Serial Clock Line (input)

        -- SPI specific signals
        MOSI2       : inout std_logic;   -- Master Out Slave In (bidirectional)
        MISO2       : inout std_logic;   -- Master In Slave Out (bidirectional)
        SCK2        : in std_logic;      -- Serial Clock (input)
        SS2         : out std_logic;     -- Slave Select (output)

        -- CCP specific pins
        Data        : in  std_logic_vector(7 downto 0);
        PIXCLK      : in std_logic;
        HSYNC       : in std_logic;
        VSYNC       : in std_logic;
        MCLK        : out std_logic;

        -- UART specific signals
        TXD4        : out std_logic;      -- Transmit Data (output)
        RXD4        : in std_logic;       -- Receive Data (input)

        -- SSI specific signals
        TXD5        : out std_logic;      -- Transmit Data (output)
        RXD5        : in std_logic;       -- Receive Data (input)

        -- SOSSI specific signals
        TXD6        : out std_logic;      -- Transmit Data (output)
        RXD6        : in std_logic        -- Receive Data (input)
    );
end SoC_Subsystem;

architecture Behavioral of SoC_Subsystem is

    -- Declare AHB_Arbiter component
    component AHB_Arbiter is
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
    end component;

    -- Internal AHB Lite Interface Signals for IP1 (I2C)
    signal HADDR1      : std_logic_vector(31 downto 0);
    signal HWRITE1     : std_logic;
    signal HWDATA1     : std_logic_vector(31 downto 0);
    signal HRDATA1     : std_logic_vector(31 downto 0);
    signal HREADY1     : std_logic;
    signal HCLK1       : std_logic;
    signal HRESETn1    : std_logic;

    -- Internal AHB Lite Interface Signals for IP2 (SPI)
    signal HADDR2      : std_logic_vector(31 downto 0);
    signal HWRITE2     : std_logic;
    signal HWDATA2     : std_logic_vector(31 downto 0);
    signal HRDATA2     : std_logic_vector(31 downto 0);
    signal HREADY2     : std_logic;
    signal HCLK2       : std_logic;
    signal HRESETn2    : std_logic;

    -- Internal AHB Lite Interface Signals for IP3 (CCP)
    signal HADDR3      : std_logic_vector(31 downto 0);
    signal HWRITE3     : std_logic;
    signal HWDATA3     : std_logic_vector(31 downto 0);
    signal HRDATA3     : std_logic_vector(31 downto 0);
    signal HREADY3     : std_logic;
    signal HCLK3       : std_logic;
    signal HRESETn3    : std_logic;

    -- Internal AHB Lite Interface Signals for IP4 (UART)
    signal HADDR4      : std_logic_vector(31 downto 0);
    signal HWRITE4     : std_logic;
    signal HWDATA4     : std_logic_vector(31 downto 0);
    signal HRDATA4     : std_logic_vector(31 downto 0);
    signal HREADY4     : std_logic;
    signal HCLK4       : std_logic;
    signal HRESETn4    : std_logic;

    -- Internal AHB Lite Interface Signals for IP5 (SSI)
    signal HADDR5      : std_logic_vector(31 downto 0);
    signal HWRITE5     : std_logic;
    signal HWDATA5     : std_logic_vector(31 downto 0);
    signal HRDATA5     : std_logic_vector(31 downto 0);
    signal HREADY5     : std_logic;
    signal HCLK5       : std_logic;
    signal HRESETn5    : std_logic;

    -- Internal AHB Lite Interface Signals for IP6 (SOSSI)
    signal HADDR6      : std_logic_vector(31 downto 0);
    signal HWRITE6     : std_logic;
    signal HWDATA6     : std_logic_vector(31 downto 0);
    signal HRDATA6     : std_logic_vector(31 downto 0);
    signal HREADY6     : std_logic;
    signal HCLK6       : std_logic;
    signal HRESETn6    : std_logic;

begin
    -- Instantiate IP1 (I2C)
    IP1_I2C: entity work.IP_I2C
        port map (
            HCLK       => HCLK1,
            HRESETn    => HRESETn1,
            HADDR      => HADDR1,
            HWRITE     => HWRITE1,
            HWDATA     => HWDATA1,
            HRDATA     => HRDATA1,
            HREADY     => HREADY1,
            SDA        => SDA1,
            SCL        => SCL1
        );

    -- Instantiate IP2 (SPI)
    IP2_SPI: entity work.IP_SPI
        port map (
            HCLK       => HCLK2,
            HRESETn    => HRESETn2,
            HADDR      => HADDR2,
            HWRITE     => HWRITE2,
            HWDATA     => HWDATA2,
            HRDATA     => HRDATA2,
            HREADY     => HREADY2,
            MOSI       => MOSI2,
            MISO       => MISO2,
            SCK        => SCK2,
            SS         => SS2
        );

    -- Instantiate IP3 (CCP) with CCP-specific pins
    IP3_CCP: entity work.IP_CCP
        port map (
            HCLK       => HCLK3,
            HRESETn    => HRESETn3,
            HADDR      => HADDR3,
            HWRITE     => HWRITE3,
            HWDATA     => HWDATA3,
            HRDATA     => HRDATA3,
            HREADY     => HREADY3,
            Data       => Data,
            PIXCLK     => PIXCLK,
            HSYNC      => HSYNC,
            VSYNC      => VSYNC,
            MCLK       => MCLK
        );

    -- Instantiate IP4 (UART)
    IP4_UART: entity work.IP_UART
        port map (
            HCLK       => HCLK4,
            HRESETn    => HRESETn4,
            HADDR      => HADDR4,
            HWRITE     => HWRITE4,
            HWDATA     => HWDATA4,
            HRDATA     => HRDATA4,
            HREADY     => HREADY4,
            TXD        => TXD4,
            RXD        => RXD4
        );

    -- Instantiate IP5 (SSI)
    IP5_SSI: entity work.IP_SSI
        port map (
            HCLK       => HCLK5,
            HRESETn    => HRESETn5,
            HADDR      => HADDR5,
            HWRITE     => HWRITE5,
            HWDATA     => HWDATA5,
            HRDATA     => HRDATA5,
            HREADY     => HREADY5,
            TXD        => TXD5,
            RXD        => RXD5
        );

    -- Instantiate IP6 (SOSSI)
    IP6_SOSSI: entity work.IP_SOSSI
        port map (
            HCLK       => HCLK6,
            HRESETn    => HRESETn6,
            HADDR      => HADDR6,
            HWRITE     => HWRITE6,
            HWDATA     => HWDATA6,
            HRDATA     => HRDATA6,
            HREADY     => HREADY6,
            TXD        => TXD6,
            RXD        => RXD6
        );

-- Instantiate the Arbiter component to handle AHB arbitration
ARBITER: AHB_Arbiter
    port map (
        -- Clock and reset (use a common clock and reset for the arbiter)
        HCLK       => HCLK_CPU,       -- Use CPU clock or another clock as needed
        HRESETn    => HRESETn_CPU,    -- Use CPU reset or another reset as needed

        -- Connect internal AHB interfaces of each IP to the arbiter
        HADDR1    => HADDR1, HWRITE1 => HWRITE1, HWDATA1 => HWDATA1, HRDATA1 => HRDATA1, HREADY1 => HREADY1,
        HADDR2    => HADDR2, HWRITE2 => HWRITE2, HWDATA2 => HWDATA2, HRDATA2 => HRDATA2, HREADY2 => HREADY2,
        HADDR3    => HADDR3, HWRITE3 => HWRITE3, HWDATA3 => HWDATA3, HRDATA3 => HRDATA3, HREADY3 => HREADY3,
        HADDR4    => HADDR4, HWRITE4 => HWRITE4, HWDATA4 => HWDATA4, HRDATA4 => HRDATA4, HREADY4 => HREADY4,
        HADDR5    => HADDR5, HWRITE5 => HWRITE5, HWDATA5 => HWDATA5, HRDATA5 => HRDATA5, HREADY5 => HREADY5,
        HADDR6    => HADDR6, HWRITE6 => HWRITE6, HWDATA6 => HWDATA6, HRDATA6 => HRDATA6, HREADY6 => HREADY6,

        -- Connect the CPU AHB Lite interface
        HADDR_CPU => HADDR_CPU, HWRITE_CPU => HWRITE_CPU, HWDATA_CPU => HWDATA_CPU, HRDATA_CPU => HRDATA_CPU, HREADY_CPU => HREADY_CPU
    );
end Behavioral;