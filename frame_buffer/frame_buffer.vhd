library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;

library unisim;
use unisim.vcomponents.all;

entity frame_buffer is
    port (
        -- System oscillator
        clk50        : in    std_logic;
        -- BBC 1MHZ Bus
        clke         : in    std_logic;
        rnw          : in    std_logic;
        rst_n        : in    std_logic;
        pgfc_n       : in    std_logic;
        pgfd_n       : in    std_logic;
        bus_addr     : in    std_logic_vector (7 downto 0);
        bus_data     : inout std_logic_vector (7 downto 0);
        bus_data_dir : out   std_logic;
        bus_data_oel : out   std_logic;
        nmi          : out   std_logic;
        irq          : out   std_logic;
        -- SPI DAC
        dac_cs_n     : out   std_logic;
        dac_sck      : out   std_logic;
        dac_sdi      : out   std_logic;
        dac_ldac_n   : out   std_logic;
        -- RAM (unused)
        ram_addr     : out   std_logic_vector(18 downto 0);
        ram_data     : inout std_logic_vector(7 downto 0);
        ram_cel      : out   std_logic;
        ram_oel      : out   std_logic;
        ram_wel      : out   std_logic;
        -- Misc
        pmod0        : out   std_logic_vector(7 downto 0);
        pmod1        : out   std_logic_vector(7 downto 0);
        pmod2        : out   std_logic_vector(3 downto 0);
        sw1          : in    std_logic;
        sw2          : in    std_logic;
        led          : out   std_logic
    );
end frame_buffer;

architecture Behavioral of frame_buffer is

    -- VGA timings are approximage
    -- H: 640 + 16 + 96 + 48 = 800
    -- V: 480 + 11 + 2 + 31  = 524
    -- 25,000,000 / 800 / 524 = 59.64Hz

    constant BORDER        : integer := 1;


    constant H_ACTIVE      : integer := 640;
    constant H_SYNC_START  : integer := H_ACTIVE + 16;
    constant H_SYNC_END    : integer := H_SYNC_START + 96;
    constant H_TOTAL       : integer := H_SYNC_END + 48;

    constant V_ACTIVE      : integer := 480;
    constant V_SYNC_START  : integer := V_ACTIVE + 11;
    constant V_SYNC_END    : integer := V_SYNC_START + 2;
    constant V_TOTAL       : integer := V_SYNC_END + 31;

    signal ram_page        : std_logic_vector(10 downto 0);

    signal cpu_addr        : std_logic_vector(18 downto 0);
    signal cpu_rd_pending  : std_logic;
    signal cpu_rd_pending1 : std_logic;
    signal cpu_rd_pending2 : std_logic;
    signal cpu_rd_done     : std_logic;
    signal cpu_wr_pending  : std_logic;
    signal cpu_wr_pending1 : std_logic;
    signal cpu_wr_pending2 : std_logic;

    signal cpu_wr_data     : std_logic_vector(7 downto 0);
    signal cpu_rd_data     : std_logic_vector(7 downto 0);

    signal selected        : std_logic;

    signal clk_video       : std_logic;
    signal clk_div         : std_logic;

    signal red             : std_logic_vector(3 downto 0);
    signal green           : std_logic_vector(3 downto 0);
    signal blue            : std_logic_vector(3 downto 0);
    signal hsync           : std_logic;
    signal vsync           : std_logic;
    signal active          : std_logic;
    signal outline         : std_logic;

    signal h_counter       : unsigned(9 downto 0);
    signal v_counter       : unsigned(9 downto 0);


begin

    ------------------------------------------------
    -- Clocking
    ------------------------------------------------

    clk_video <= clk50;

    process(clk_video)
    begin
        if rising_edge(clk_video) then
            clk_div <= not clk_div;
        end if;
    end process;

    ------------------------------------------------
    -- Video Timing
    ------------------------------------------------
    process(clk_video)
    begin
        if rising_edge(clk_video) then
            if clk_div = '1' then
                if h_counter = H_TOTAL - 1 then
                    h_counter <= (others => '0');
                    if v_counter = V_TOTAL - 1 then
                        v_counter <= (others => '0');
                    else
                        v_counter <= v_counter + 1;
                    end if;
                else
                    h_counter <= h_counter + 1;
                end if;
                if h_counter >= H_SYNC_START and h_counter < H_SYNC_END then
                    hsync <= '0';
                else
                    hsync <= '1';
                end if;
                if v_counter >= V_SYNC_START and v_counter < V_SYNC_END then
                    vsync <= '0';
                else
                    vsync <= '1';
                end if;
                if h_counter >= 0 and h_counter < H_ACTIVE  and
                    v_counter >= 0 and v_counter < V_ACTIVE then
                    active <= '1';
                else
                    active <= '0';
                end if;
                if h_counter < BORDER or h_counter >= H_ACTIVE - BORDER or
                   v_counter < BORDER or v_counter >= V_ACTIVE - BORDER then
                    outline <= '1';
                else
                    outline <= '0';
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------
    -- SRAM Interface
    ------------------------------------------------

    process(clk_video)
    begin
        if rising_edge(clk_video) then

            -- Synchronize the RD/WR Pending signals from the 1MHz Domain
            cpu_rd_pending1 <= cpu_rd_pending;
            cpu_wr_pending1 <= cpu_wr_pending;

            if clk_div = '0' and active = '1' then
                -- Video Read Cycle
                ram_addr        <= std_logic_vector(v_counter(8 downto 0)) & std_logic_vector(h_counter);
                ram_data        <= (others => 'Z');
                ram_cel         <= '0';
                ram_oel         <= '0';
                ram_wel         <= '1';
            elsif cpu_rd_pending2 /= cpu_rd_pending1 then
                -- CPU Read Cycle
                ram_addr        <= cpu_addr;
                ram_data        <= (others => 'Z');
                ram_cel         <= '0';
                ram_oel         <= '0';
                ram_wel         <= '1';
                cpu_rd_done     <= '1';
                cpu_rd_pending2 <= cpu_rd_pending1;
            elsif cpu_wr_pending2 /= cpu_wr_pending1 then
                -- CPU Write Cycle
                ram_addr        <= cpu_addr;
                ram_data        <= cpu_wr_data;
                ram_cel         <= '0';
                ram_oel         <= '1';
                ram_wel         <= '0';
                cpu_wr_pending2 <= cpu_wr_pending1;
            else
                -- IDLE cycle
                ram_addr     <= (others => '0');
                ram_data     <= (others => 'Z');
                ram_cel      <= '1';
                ram_oel      <= '1';
                ram_wel      <= '1';
            end if;

            -- Handle the data from a video read cycle
            if clk_div = '1' then
                if active = '1' then
                    if outline = '1' then
                        red   <= x"F";
                        green <= x"F";
                        blue  <= x"F";
                    else
                        red   <= ram_data(2 downto 0) & '0';
                        green <= ram_data(5 downto 3) & '0';
                        blue  <= ram_data(7 downto 6) & "00";
                    end if;
                else
                    red   <= (others => '0');
                    green <= (others => '0');
                    blue  <= (others => '0');
                end if;
            end if;

            -- Handle the data from a CPU read cycle
            if cpu_rd_done = '1' then
                cpu_rd_data <= ram_data;
                cpu_rd_done <= '0';
            end if;

        end if;
    end process;

    ------------------------------------------------
    -- 1MHz Bus Interface
    ------------------------------------------------

    process(clke, rst_n)
    begin
        if rst_n = '0' then
            selected <= '0';
        elsif falling_edge(clke) then
            if pgfc_n = '0' and bus_addr = x"FE" and rnw = '0' then
                cpu_addr(15 downto 8) <= bus_data;
            end if;
            if pgfc_n = '0' and bus_addr = x"FF" and rnw = '0' then
                cpu_addr(18 downto 16) <= bus_data(2 downto 0);
                if bus_data(7 downto 3) = "11000" then
                    selected <= '1';
                else
                    selected <= '0';
                end if;
            end if;
            if selected = '1' and pgfd_n = '0' and rnw = '0' then
                cpu_wr_pending <= not cpu_wr_pending;
                cpu_wr_data <= bus_data;
            end if;
        end if;
    end process;

    process(clke)
    begin
        if rising_edge(clke) then
            if selected = '1' and pgfd_n = '0' then
                cpu_addr(7 downto 0) <= bus_addr;
            end if;
            if selected = '1' and pgfd_n = '0' and rnw = '1' then
                cpu_rd_pending <= not cpu_rd_pending;
            end if;
        end if;
    end process;


    bus_data <= selected & selected & "000" & cpu_addr(18 downto 16) when pgfc_n = '0' and bus_addr = x"FF" and rnw = '1' else
                cpu_addr(15 downto  8) when pgfc_n = '0' and bus_addr = x"FE" and rnw = '1' else
                cpu_addr( 7 downto  0) when pgfc_n = '0' and bus_addr = x"FD" and rnw = '1' else
                cpu_wr_data            when pgfc_n = '0' and bus_addr = x"FC" and rnw = '1' else
                cpu_rd_data            when pgfd_n = '0' and selected = '1'   and rnw = '1' else
                (others => 'Z');

    bus_data_oel <= not clke;

--    bus_data_oel <= '0' when selected = '1' and rnw = '1' and pgfd_n = '0' else
--                    '1';

    ------------------------------------------------
    -- 1MHZ Bus FPGA Adapter Specific Stuff
    ------------------------------------------------

    irq          <= '0';
    nmi          <= '0';

    bus_data_dir <= rnw;

    pmod0        <= blue & red;
    pmod1        <= '0' & '0' & vsync & hsync & green ;
    pmod2        <= (others => '1');

    led          <= sw1 or sw2;

    dac_cs_n     <= '1';
    dac_sck      <= '1';
    dac_sdi      <= '1';
    dac_ldac_n   <= '1';


end Behavioral;
