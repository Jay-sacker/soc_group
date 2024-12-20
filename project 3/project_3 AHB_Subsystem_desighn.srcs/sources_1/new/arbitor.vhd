library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AHB_Arbiter is
    port (
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
            HSEL_S1       : out  std_logic;                         -- Slave select signal
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
            HSEL_S2       : out  std_logic;
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
            HSEL_S3       : out  std_logic;
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
            HSEL_S4       : out  std_logic;
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
            HSEL_S5       : out  std_logic;
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
            HSEL_S6       : out  std_logic;
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
end AHB_Arbiter;

architecture Behavioral of AHB_Arbiter is
    signal arb_state : integer range 0 to 5 := 0;  -- Round-robin state
    
begin

    -- CPU AHB Master
    process (HCLK, HRESETn)
    begin
        if HRESETn = '0' then
            arb_state <= 0;
            HSEL_S1 <= '0'; HSEL_S2 <= '0'; HSEL_S3 <= '0';
            HSEL_S4 <= '0'; HSEL_S5 <= '0'; HSEL_S6 <= '0';
        elsif rising_edge(HCLK) then
        -- Clear all HSEL signals initially
            HSEL_S1 <= '0'; HSEL_S2 <= '0'; HSEL_S3 <= '0';
            HSEL_S4 <= '0'; HSEL_S5 <= '0'; HSEL_S6 <= '0';
            --Round Robin Arbitration Logic
            case arb_state is
                when 0 =>
                    
                        -- Grant access to  (I2C)
                         
                        HADDR_S1        <= HADDR_CPU;
                        HWDATA_S1       <= HWDATA_CPU;
                        HWRITE_S1       <= HWRITE_CPU;
                        HSIZE_S1        <= HSIZE_CPU;
                        HBURST_S1       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S1;
                        HREADY_CPU      <= HREADYOUT_S1;
                        HTRANS_S1       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S1;
                        HPROT_S1        <= HPROT_CPU;
                        HMASTLOCK_S1    <= HMASTLOCK_CPU;
                     -- IP 1 is finished with its transfer
                     -- Move on to next IP in sequence
                    if HREADYOUT_S1 = '1' then
                        arb_state <= 1;
                    end if;
                 
                when 1 =>
               
                        HADDR_S2        <= HADDR_CPU;
                        HWDATA_S2       <= HWDATA_CPU;
                        HWRITE_S2       <= HWRITE_CPU;
                        HSIZE_S2        <= HSIZE_CPU;
                        HBURST_S2       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S2;
                        HREADY_CPU      <= HREADYOUT_S2;
                        HTRANS_S2       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S2;
                        HPROT_S2        <= HPROT_CPU;
                        HMASTLOCK_S2    <= HMASTLOCK_CPU;
                    --IP 2 has finished its transfer
                    if HREADYOUT_S2 = '1' then
                        arb_state <= 2;
                    end if;
                when 2 =>
                    
                        HADDR_S3        <= HADDR_CPU;
                        HWDATA_S3       <= HWDATA_CPU;
                        HWRITE_S3       <= HWRITE_CPU;
                        HSIZE_S3        <= HSIZE_CPU;
                        HBURST_S3       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S3;
                        HREADY_CPU      <= HREADYOUT_S3;
                        HTRANS_S3       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S3;
                        HPROT_S3        <= HPROT_CPU;
                        HMASTLOCK_S3    <= HMASTLOCK_CPU;
                    if HREADYOUT_S3 = '1' then
                        arb_state <= 3;
                    end if;
                when 3 =>
                   
                        HADDR_S4        <= HADDR_CPU;
                        HWDATA_S4       <= HWDATA_CPU;
                        HWRITE_S4       <= HWRITE_CPU;
                        HSIZE_S4        <= HSIZE_CPU;
                        HBURST_S4       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S4;
                        HREADY_CPU      <= HREADYOUT_S4;
                        HTRANS_S4       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S4;
                        HPROT_S4        <= HPROT_CPU;
                        HMASTLOCK_S4    <= HMASTLOCK_CPU;
                    if HREADYOUT_S4 = '1' then
                        arb_state <= 4;
                    end if;
                when 4 =>
                    
                        HADDR_S5        <= HADDR_CPU;
                        HWDATA_S5       <= HWDATA_CPU;
                        HWRITE_S5       <= HWRITE_CPU;
                        HSIZE_S5        <= HSIZE_CPU;
                        HBURST_S5       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S5;
                        HREADY_CPU      <= HREADYOUT_S5;
                        HTRANS_S5       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S5;
                        HPROT_S5        <= HPROT_CPU;
                        HMASTLOCK_S5    <= HMASTLOCK_CPU;
                    if HREADYOUT_S5 = '1' then
                        arb_state <= 5;
                    end if;
                when 5 =>
                    
                        HADDR_S6        <= HADDR_CPU;
                        HWDATA_S6       <= HWDATA_CPU;
                        HWRITE_S6       <= HWRITE_CPU;
                        HSIZE_S6        <= HSIZE_CPU;
                        HBURST_S6       <= HBURST_CPU;
                        HRDATA_CPU      <= HRDATA_S6;
                        HREADY_CPU      <= HREADYOUT_S6;
                        HTRANS_S6       <= HTRANS_CPU;
                        HRESP_CPU       <= HRESP_S6;
                        HPROT_S6        <= HPROT_CPU;
                        HMASTLOCK_S6    <= HMASTLOCK_CPU; 
                    if HREADYOUT_S6 = '1' then
                        arb_state <= 0;
                    end if;
                when others =>
                    arb_state <= 0;
            end case;
        end if;
    end process;

end Behavioral;
