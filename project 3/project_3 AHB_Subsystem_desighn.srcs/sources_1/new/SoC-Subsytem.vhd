library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SoC_Subsystem is
    port (
        -- External CPU AHB Lite Interface
            HCLK_CPU    : in  std_logic;
            HRESETn_CPU : in  std_logic;
            HADDR_CPU     : in  std_logic_vector(31 downto 0);     -- 32-bit address bus
            HWRITE_CPU    : in  std_logic;                         -- Write signal (1 = write, 0 = read)
            HWDATA_CPU    : in  std_logic_vector(31 downto 0);     -- 32-bit data for write
            HRDATA_CPU    : out std_logic_vector(31 downto 0);     -- 32-bit data for read
            HREADY_CPU    : out std_logic;                         -- Indicates slave ready for transfer
            HRESP_CPU     : out std_logic;                         -- Transfer response (OKAY or ERROR)
            HSIZE_CPU     : in  std_logic_vector(2 downto 0);      -- 3-bit transfer size
            HBURST_CPU    : in  std_logic_vector(2 downto 0);      -- 3-bit burst type
            HTRANS_CPU    : in  std_logic_vector(1 downto 0);      -- 2-bit transfer type (IDLE, BUSY, NONSEQ, SEQ)
            HPROT_CPU     : in  std_logic_vector(3 downto 0);      -- 4-bit protection control signal
            HMASTLOCK_CPU : in  std_logic;                        -- Master lock signal (1 = locked, 0 = unlocked)

        -- SDA and SCL for I2C
        SDA1        : inout std_logic;   -- Serial Data Line (bidirectional)
        SCL1        : in std_logic;      -- Serial Clock Line (input)

        -- SPI specific signals
        MOSI2       : inout std_logic;   -- Master Out Slave In (bidirectional)
        MISO2       : inout std_logic;   -- Master In Slave Out (bidirectional)
        SCK2        : in std_logic;      -- Serial Clock (input)
        SS2         : out std_logic;     -- Slave Select (output)

        -- CCP specific pins
        Data        : in  std_logic_vector(7 downto 0); -- 8 Bit Data Bus (input)
        PIXCLK      : in std_logic; -- Pixel Clock
        HSYNC       : in std_logic; -- Horizontal Sync
        VSYNC       : in std_logic; -- Vertical Sync
        CCP_CLK        : out std_logic; --CCP Clock (output)

        -- UART specific signals
        TXD4        : out std_logic;      -- Transmit Data (output)
        RXD4        : in std_logic;       -- Receive Data (input)
        IRQ         : out std_logic;       -- Interrupt Request (output)

        -- SSI specific signals
        SSI_CLK     : out std_logic;      -- SSI Clock
        FSS         : out std_logic;      -- Frame Sync Select
        TXD5        : out std_logic;      -- Transmit Data (output)
        RXD5        : in std_logic;       -- Receive Data (input)

        -- SOSSI specific signals
        SCLK        : out std_logic;      -- SSOSSI Clock (output)
        SDOUT       : out std_logic;      -- Serial Data Out (output)
        SDIN        : in std_logic;       -- Serial Data In (input)
        TX_EN       : in std_logic;       -- Enable Transmission (input)
        RX_EN       : in std_logic;       -- Enable Reception (input)
        READY       : in std_logic        -- Ready for data (input)
        
    );
end SoC_Subsystem;

architecture Behavioral of SoC_Subsystem is

    -- Declare AHB_Arbiter component
    component AHB_Arbiter is
        port (
            -- AHB Lite Interface signals from each IP
        -- AHB Lite Master Interface (CPU)

            HCLK          : in  std_logic;                         -- AHB clock signal
            HRESETn       : in  std_logic;                         -- AHB reset (active low)
            HADDR_CPU     : in  std_logic_vector(31 downto 0);     -- 32-bit address bus
            HWRITE_CPU    : in  std_logic;                         -- Write signal (1 = write, 0 = read)
            HWDATA_CPU    : in  std_logic_vector(31 downto 0);     -- 32-bit data for write
            HRDATA_CPU    : out std_logic_vector(31 downto 0);     -- 32-bit data for read
            HREADY_CPU    : out std_logic;                         -- Indicates slave ready for transfer
            HRESP_CPU     : out std_logic;                         -- Transfer response (OKAY or ERROR)
            HSIZE_CPU     : in  std_logic_vector(2 downto 0);      -- 3-bit transfer size
            HBURST_CPU    : in  std_logic_vector(2 downto 0);      -- 3-bit burst type
            HTRANS_CPU    : in  std_logic_vector(1 downto 0);      -- 2-bit transfer type (IDLE, BUSY, NONSEQ, SEQ)
            HPROT_CPU     : in  std_logic_vector(3 downto 0);      -- 4-bit protection control signal
            HMASTLOCK_CPU : in  std_logic;                         -- Master lock signal (1 = locked, 0 = unlocked)
            
            -- (I2C) 
            HSEL_S1       : in  std_logic;                         -- Slave select signal
            HADDR_S1      : out  std_logic_vector(31 downto 0);     -- Address bus from slave
            HWRITE_S1     : out  std_logic;                         -- Write signal from slave (1 = write, 0 = read)
            HSIZE_S1      : out  std_logic_vector(2 downto 0);      -- Transfer size from slave
            HBURST_S1     : out  std_logic_vector(2 downto 0);      -- Burst type from slave
            HPROT_S1      : out  std_logic_vector(3 downto 0);      -- 4-bit protection control signal
            HTRANS_S1     : out  std_logic_vector(1 downto 0);      -- Transfer type from slave
            HMASTLOCK_S1  : out  std_logic;                         -- Master lock signal from slave
            HREADYOUT_S1  : in  std_logic;                          -- Slave ready signal to master
            HRESP_S1      : in  std_logic;                          -- Transfer response from slave
            HRDATA_S1     : in  std_logic_vector(31 downto 0);      -- Data bus for read operations to slave
            HWDATA_S1     : out  std_logic_vector(31 downto 0);     -- Data bus for write operations from slave
            HREADY_S1     : out  std_logic;                         -- Ready signal from master to slave
            
            -- (SPI) 
            HSEL_S2       : in  std_logic;
            HADDR_S2      : out  std_logic_vector(31 downto 0);
            HWRITE_S2     : out  std_logic;
            HSIZE_S2      : out  std_logic_vector(2 downto 0);
            HBURST_S2     : out  std_logic_vector(2 downto 0);
            HPROT_S2      : out  std_logic_vector(3 downto 0);
            HTRANS_S2     : out  std_logic_vector(1 downto 0);
            HMASTLOCK_S2  : out  std_logic;
            HREADYOUT_S2  : in  std_logic;
            HRESP_S2      : in  std_logic;
            HRDATA_S2     : in  std_logic_vector(31 downto 0);
            HWDATA_S2     : out  std_logic_vector(31 downto 0);
            HREADY_S2     : out  std_logic;
            
            -- (CCP)
            HSEL_S3       : in  std_logic;
            HADDR_S3      : out  std_logic_vector(31 downto 0);
            HWRITE_S3     : out  std_logic;
            HSIZE_S3      : out  std_logic_vector(2 downto 0);
            HBURST_S3     : out  std_logic_vector(2 downto 0);
            HPROT_S3      : out  std_logic_vector(3 downto 0);
            HTRANS_S3     : out  std_logic_vector(1 downto 0);
            HMASTLOCK_S3  : out  std_logic;
            HREADYOUT_S3  : in  std_logic;
            HRESP_S3      : in  std_logic;
            HRDATA_S3     : in  std_logic_vector(31 downto 0);
            HWDATA_S3     : out  std_logic_vector(31 downto 0);
            HREADY_S3     : out  std_logic;
            
            -- (UART) 
            HSEL_S4       : in  std_logic;
            HADDR_S4      : out  std_logic_vector(31 downto 0);
            HWRITE_S4     : out  std_logic;
            HSIZE_S4      : out  std_logic_vector(2 downto 0);
            HBURST_S4     : out  std_logic_vector(2 downto 0);
            HPROT_S4      : out  std_logic_vector(3 downto 0);
            HTRANS_S4     : out  std_logic_vector(1 downto 0);
            HMASTLOCK_S4  : out  std_logic;
            HREADYOUT_S4  : in  std_logic;
            HRESP_S4      : in  std_logic;
            HRDATA_S4     : in  std_logic_vector(31 downto 0);
            HWDATA_S4     : out  std_logic_vector(31 downto 0);
            HREADY_S4     : out  std_logic;
            
            --(SSI) 
            HSEL_S5       : in  std_logic;
            HADDR_S5      : out  std_logic_vector(31 downto 0);
            HWRITE_S5     : out  std_logic;
            HSIZE_S5      : out  std_logic_vector(2 downto 0);
            HBURST_S5     : out  std_logic_vector(2 downto 0);
            HPROT_S5      : out  std_logic_vector(3 downto 0);
            HTRANS_S5     : out  std_logic_vector(1 downto 0);
            HMASTLOCK_S5  : out  std_logic;
            HREADYOUT_S5  : in  std_logic;
            HRESP_S5      : in  std_logic;
            HRDATA_S5     : in  std_logic_vector(31 downto 0);
            HWDATA_S5     : out  std_logic_vector(31 downto 0);
            HREADY_S5     : out  std_logic;
            
            -- (SOSSI) 
            HSEL_S6       : in  std_logic;
            HADDR_S6      : out  std_logic_vector(31 downto 0);
            HWRITE_S6     : out  std_logic;
            HSIZE_S6      : out  std_logic_vector(2 downto 0);
            HBURST_S6     : out  std_logic_vector(2 downto 0);
            HPROT_S6      : out  std_logic_vector(3 downto 0);
            HTRANS_S6     : out  std_logic_vector(1 downto 0);
            HMASTLOCK_S6  : out  std_logic;
            HREADYOUT_S6  : in  std_logic;
            HRESP_S6      : in  std_logic;
            HRDATA_S6     : in  std_logic_vector(31 downto 0);
            HWDATA_S6     : out  std_logic_vector(31 downto 0);
            HREADY_S6     : out  std_logic
        );
    end component;

    -- Internal AHB Lite Interface Signals for IP1 (I2C)
    signal HSEL_S1     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR1      : std_logic_vector(31 downto 0);
    signal HWRITE1     : std_logic;
    signal HWDATA1     : std_logic_vector(31 downto 0);
    signal HRDATA1     : std_logic_vector(31 downto 0);
    signal HREADYOUT1  : std_logic;
    signal HRESP1      : std_logic;
    signal HSIZE1      : std_logic_vector(2 downto 0);
    signal HBURST1     : std_logic_vector(2 downto 0);
    signal HTRANS1     : std_logic_vector(1 downto 0);
    signal HPROT1      : std_logic_vector(3 downto 0);
    signal HMASTLOCK1  : std_logic;
    signal HREADY1  : std_logic;

    -- Internal AHB Lite Interface Signals for IP2 (SPI)
    signal HSEL_S2     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR2      : std_logic_vector(31 downto 0);
    signal HWRITE2     : std_logic;
    signal HWDATA2     : std_logic_vector(31 downto 0);
    signal HRDATA2     : std_logic_vector(31 downto 0);
    signal HREADYOUT2  : std_logic;
    signal HRESP2      : std_logic;
    signal HSIZE2      : std_logic_vector(2 downto 0);
    signal HBURST2     : std_logic_vector(2 downto 0);
    signal HTRANS2     : std_logic_vector(1 downto 0);
    signal HPROT2      : std_logic_vector(3 downto 0);
    signal HMASTLOCK2  : std_logic;
    signal HREADY2     : std_logic;

    -- Internal AHB Lite Interface Signals for IP3 (CCP)
    signal HSEL_S3     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR3      : std_logic_vector(31 downto 0);
    signal HWRITE3     : std_logic;
    signal HWDATA3     : std_logic_vector(31 downto 0);
    signal HRDATA3     : std_logic_vector(31 downto 0);
    signal HREADYOUT3  : std_logic;
    signal HRESP3      : std_logic;
    signal HSIZE3      : std_logic_vector(2 downto 0);
    signal HBURST3     : std_logic_vector(2 downto 0);
    signal HTRANS3     : std_logic_vector(1 downto 0);
    signal HPROT3      : std_logic_vector(3 downto 0);
    signal HMASTLOCK3  : std_logic;
    signal HREADY3  : std_logic;

    -- Internal AHB Lite Interface Signals for IP4 (UART)
    signal HSEL_S4     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR4      : std_logic_vector(31 downto 0);
    signal HWRITE4     : std_logic;
    signal HWDATA4     : std_logic_vector(31 downto 0);
    signal HRDATA4     : std_logic_vector(31 downto 0);
    signal HREADYOUT4  : std_logic;
    signal HRESP4      : std_logic;
    signal HSIZE4      : std_logic_vector(2 downto 0);
    signal HBURST4     : std_logic_vector(2 downto 0);
    signal HTRANS4     : std_logic_vector(1 downto 0);
    signal HPROT4      : std_logic_vector(3 downto 0);
    signal HMASTLOCK4  : std_logic;
    signal HREADY4     : std_logic;

    -- Internal AHB Lite Interface Signals for IP5 (SSI)
    signal HSEL_S5     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR5      : std_logic_vector(31 downto 0);
    signal HWRITE5     : std_logic;
    signal HWDATA5     : std_logic_vector(31 downto 0);
    signal HRDATA5     : std_logic_vector(31 downto 0);
    signal HREADYOUT5  : std_logic;
    signal HRESP5      : std_logic;
    signal HSIZE5      : std_logic_vector(2 downto 0);
    signal HBURST5     : std_logic_vector(2 downto 0);
    signal HTRANS5     : std_logic_vector(1 downto 0);
    signal HPROT5      : std_logic_vector(3 downto 0);
    signal HMASTLOCK5  : std_logic;
    signal HREADY5     : std_logic;

    -- Internal AHB Lite Interface Signals for IP6 (SOSSI)
    signal HSEL_S6     : std_logic;  -- Slave select signal for Slave 1 (I2C)
    signal HADDR6      : std_logic_vector(31 downto 0);
    signal HWRITE6     : std_logic;
    signal HWDATA6     : std_logic_vector(31 downto 0);
    signal HRDATA6     : std_logic_vector(31 downto 0);
    signal HREADYOUT6  : std_logic;
    signal HRESP6      : std_logic;
    signal HSIZE6      : std_logic_vector(2 downto 0);
    signal HBURST6     : std_logic_vector(2 downto 0);
    signal HTRANS6     : std_logic_vector(1 downto 0);
    signal HPROT6      : std_logic_vector(3 downto 0);
    signal HMASTLOCK6  : std_logic;
    signal HREADY6     : std_logic;

begin
    -- Instantiate IP1 (I2C)
    IP1_I2C: entity work.IP_I2C
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR1,
            HWRITE     => HWRITE1,
            HWDATA     => HWDATA1,
            HRDATA     => HRDATA1,
            HREADYOUT  => HREADYOUT1,
            HRESP      => HRESP1,
            HSIZE      => HSIZE1,
            HBURST     => HBURST1,
            HTRANS     => HTRANS1,
            HPROT      => HPROT1,
            HMASTLOCK  => HMASTLOCK1,
            HREADY     => HREADY1,
            HSELx      => HSEL_s1,
            SDA        => SDA1,
            SCL        => SCL1
        );

    -- Instantiate IP2 (SPI)
    IP2_SPI: entity work.IP_SPI
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR2,
            HWRITE     => HWRITE2,
            HWDATA     => HWDATA2,
            HRDATA     => HRDATA2,
            HREADYOUT  => HREADYOUT2,
            HRESP      => HRESP2,
            HSIZE      => HSIZE2,
            HBURST     => HBURST2,
            HTRANS     => HTRANS2,
            HPROT      => HPROT2,
            HMASTLOCK  => HMASTLOCK2,
            HREADY     => HREADY2,
            HSELx      => HSEL_s2,
            MOSI       => MOSI2,
            MISO       => MISO2,
            SCK        => SCK2,
            SS         => SS2
        );

    -- Instantiate IP3 (CCP) with CCP-specific pins
    IP3_CCP: entity work.IP_CCP
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR3,
            HWRITE     => HWRITE3,
            HWDATA     => HWDATA3,
            HRDATA     => HRDATA3,
            HREADYOUT  => HREADYOUT3,
            HRESP      => HRESP3,
            HSIZE      => HSIZE3,
            HBURST     => HBURST3,
            HTRANS     => HTRANS3,
            HPROT      => HPROT3,
            HMASTLOCK  => HMASTLOCK3,
            HREADY     => HREADY3,
            HSELx      => HSEL_s3,
            Data       => Data,
            PIXCLK     => PIXCLK,
            HSYNC      => HSYNC,
            VSYNC      => VSYNC,
            CCP_CLK    => CCP_CLK
        );

    -- Instantiate IP4 (UART)
    IP4_UART: entity work.IP_UART
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR4,
            HWRITE     => HWRITE4,
            HWDATA     => HWDATA4,
            HRDATA     => HRDATA4,
            HREADYOUT  => HREADYOUT4,
            HRESP      => HRESP4,
            HSIZE      => HSIZE4,
            HBURST     => HBURST4,
            HTRANS     => HTRANS4,
            HPROT      => HPROT4,
            HMASTLOCK  => HMASTLOCK4,
            HREADY     => HREADY4,
            HSELx      => HSEL_s4,
            TXD        => TXD4,
            RXD        => RXD4,
            IRQ        => IRQ
        );

    -- Instantiate IP5 (SSI)
    IP5_SSI: entity work.IP_SSI
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR5,
            HWRITE     => HWRITE5,
            HWDATA     => HWDATA5,
            HRDATA     => HRDATA5,
            HREADYOUT  => HREADYOUT5,
            HRESP      => HRESP5,
            HSIZE      => HSIZE5,
            HBURST     => HBURST5,
            HTRANS     => HTRANS5,
            HPROT      => HPROT5,
            HMASTLOCK  => HMASTLOCK5,
            HREADY     => HREADY5,
            HSELx      => HSEL_s5,
            SSI_CLK    => SSI_CLK,
            FSS        => FSS,
            TXD        => TXD5,
            RXD        => RXD5
        );

    -- Instantiate IP6 (SOSSI)
    IP6_SOSSI: entity work.IP_SOSSI
        port map (
            HCLK       => HCLK_CPU,
            HRESETn    => HRESETn_CPU,
            HADDR      => HADDR6,
            HWRITE     => HWRITE6,
            HWDATA     => HWDATA6,
            HRDATA     => HRDATA6,
            HREADYOUT  => HREADYOUT6,
            HRESP      => HRESP6,
            HSIZE      => HSIZE6,
            HBURST     => HBURST6,
            HTRANS     => HTRANS6,
            HPROT      => HPROT6,
            HMASTLOCK  => HMASTLOCK6,
            HREADY     => HREADY6,
            HSELx      => HSEL_s6,
            SCLK       => SCLK,
            SDOUT      => SDOUT,
            SDIN       => SDIN,
            TX_EN      => TX_EN,
            RX_EN      => RX_EN,
            READY      => READY
        );

-- Instantiate the Arbiter component to handle AHB arbitration
ARBITER: AHB_Arbiter
    port map (
        -- Clock and reset
        HCLK       => HCLK_CPU,       
        HRESETn    => HRESETn_CPU,    

        -- Connect internal AHB interfaces of each IP to the arbiter
        HADDR_S1     => HADDR1,     HWRITE_S1    => HWRITE1,    HWDATA_S1    => HWDATA1,    HRDATA_S1    => HRDATA1, 
        HREADYOUT_S1 => HREADYOUT1, HRESP_S1     => HRESP1,     HSIZE_S1     => HSIZE1,     HBURST_S1    => HBURST1, 
        HTRANS_S1    => HTRANS1,    HPROT_S1     => HPROT1,     HMASTLOCK_S1 => HMASTLOCK1, HSEL_S1 => HSEL_S1, 
        HREADY_s1 => HREADY1,

        HADDR_S2     => HADDR2,     HWRITE_S2    => HWRITE2,    HWDATA_S2    => HWDATA2,    HRDATA_S2    => HRDATA2, 
        HREADYOUT_S2 => HREADYOUT2, HRESP_S2     => HRESP2,     HSIZE_S2     => HSIZE2,     HBURST_S2    => HBURST2, 
        HTRANS_S2    => HTRANS2,    HPROT_S2     => HPROT2,     HMASTLOCK_S2 => HMASTLOCK2, HSEL_S2 => HSEL_S2,
        HREADY_s2 => HREADY2,

        HADDR_S3     => HADDR3,     HWRITE_S3    => HWRITE3,    HWDATA_S3    => HWDATA3,    HRDATA_S3    => HRDATA3, 
        HREADYOUT_S3 => HREADYOUT3, HRESP_S3     => HRESP3,     HSIZE_S3     => HSIZE3,     HBURST_S3    => HBURST3, 
        HTRANS_S3    => HTRANS3,    HPROT_S3     => HPROT3,     HMASTLOCK_S3 => HMASTLOCK3, HSEL_S3 => HSEL_S3,
        HREADY_s3 => HREADY3,

        HADDR_S4     => HADDR4,     HWRITE_S4    => HWRITE4,    HWDATA_S4    => HWDATA4,    HRDATA_S4    => HRDATA4, 
        HREADYOUT_S4 => HREADYOUT4, HRESP_S4     => HRESP4,     HSIZE_S4     => HSIZE4,     HBURST_S4    => HBURST4, 
        HTRANS_S4    => HTRANS4,    HPROT_S4     => HPROT4,     HMASTLOCK_S4 => HMASTLOCK4, HSEL_S4 => HSEL_S4,
        HREADY_s4 => HREADY4,

        HADDR_S5     => HADDR5,     HWRITE_S5    => HWRITE5,    HWDATA_S5    => HWDATA5,    HRDATA_S5    => HRDATA5, 
        HREADYOUT_S5 => HREADYOUT5, HRESP_S5     => HRESP5,     HSIZE_S5     => HSIZE5,     HBURST_S5    => HBURST5, 
        HTRANS_S5    => HTRANS5,    HPROT_S5     => HPROT5,     HMASTLOCK_S5 => HMASTLOCK5, HSEL_S5 => HSEL_S5,
        HREADY_s5 => HREADY5,

        HADDR_S6     => HADDR6,     HWRITE_S6    => HWRITE6,    HWDATA_S6    => HWDATA6,    HRDATA_S6    => HRDATA6, 
        HREADYOUT_S6 => HREADYOUT6, HRESP_S6     => HRESP6,     HSIZE_S6     => HSIZE6,     HBURST_S6    => HBURST6, 
        HTRANS_S6    => HTRANS6,    HPROT_S6     => HPROT6,     HMASTLOCK_S6 => HMASTLOCK6, HSEL_S6 => HSEL_S6,
        HREADY_s6 => HREADY6,

        -- Connect the CPU AHB Lite interface
        HADDR_CPU     => HADDR_CPU, 
        HWRITE_CPU    => HWRITE_CPU, 
        HWDATA_CPU    => HWDATA_CPU, 
        HRDATA_CPU    => HRDATA_CPU, 
        HRESP_CPU     => HRESP_CPU,
        HREADY_CPU    => HREADY_CPU,
        HSIZE_CPU     => HSIZE_CPU, 
        HBURST_CPU    => HBURST_CPU, 
        HTRANS_CPU    => HTRANS_CPU, 
        HPROT_CPU     => HPROT_CPU, 
        HMASTLOCK_CPU => HMASTLOCK_CPU
    );

end Behavioral;
