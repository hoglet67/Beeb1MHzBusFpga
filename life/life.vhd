library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;

library unisim;
use unisim.vcomponents.all;

entity life is
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
        -- RAM
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
end life;

architecture Behavioral of life is

    -- H_TOTAL = 2200
    constant H_ACTIVE      : integer := 1920;
    constant H_SYNC_START  : integer := H_ACTIVE + 88;
    constant H_SYNC_END    : integer := H_SYNC_START + 44;
    constant H_TOTAL       : integer := H_SYNC_END + 148;

    -- V_TOTAL = 1125
    constant V_ACTIVE      : integer := 1080;
    constant V_SYNC_START  : integer := V_ACTIVE + 4;
    constant V_SYNC_END    : integer := V_SYNC_START + 5;
    constant V_TOTAL       : integer := V_SYNC_END + 36;

    -- Write Offset (effectively the pipeline depth, in 8-pixel units
    constant WR_OFFSET     : integer := (H_ACTIVE / 8) + 2;

    -- Write Offset when wrapping
    constant WR_WRAP       : integer := (H_ACTIVE * V_ACTIVE / 8) - WR_OFFSET;

    signal clk_pixel       : std_logic;

    signal h_counter       : unsigned(11 downto 0);
    signal v_counter       : unsigned(10 downto 0);
    signal h_counter_offset: unsigned(7 downto 0);
    signal v_counter_offset: unsigned(10 downto 0);

    signal red             : std_logic_vector(3 downto 0);
    signal green           : std_logic_vector(3 downto 0);
    signal blue            : std_logic_vector(3 downto 0);
    signal hsync           : std_logic;
    signal vsync           : std_logic;
    signal active          : std_logic;
    signal outline         : std_logic;

    signal ram_rd_addr     : unsigned(18 downto 0);
    signal ram_wr_addr     : unsigned(18 downto 0);
    signal ram_dout        : std_logic_vector(7 downto 0);
    signal ram_din         : std_logic_vector(7 downto 0);
    signal ram_wel_int     : std_logic;

    signal n11             : std_logic;
    signal n12             : std_logic;
    signal n13             : std_logic;
    signal n21             : std_logic;
    signal n22             : std_logic;
    signal n23             : std_logic;
    signal n31             : std_logic;
    signal n32             : std_logic;
    signal n33             : std_logic;

    signal n11_extended    : std_logic_vector(3 downto 0);
    signal n12_extended    : std_logic_vector(3 downto 0);
    signal n13_extended    : std_logic_vector(3 downto 0);
    signal n21_extended    : std_logic_vector(3 downto 0);
    signal n23_extended    : std_logic_vector(3 downto 0);
    signal n31_extended    : std_logic_vector(3 downto 0);
    signal n32_extended    : std_logic_vector(3 downto 0);
    signal n33_extended    : std_logic_vector(3 downto 0);

    signal neighbour_count : unsigned(3 downto 0);
    signal row1            : std_logic_vector(H_ACTIVE - 4 downto 0);
    signal row2            : std_logic_vector(H_ACTIVE - 4 downto 0);
    signal nextgen         : std_logic;
    signal nextgen1        : std_logic;
    signal nextgen2        : std_logic;
    signal nextgen3        : std_logic;
    signal nextgen4        : std_logic;
    signal nextgen8        : std_logic_vector(7 downto 0);

    signal selected        : std_logic;
    signal cpu_addr        : std_logic_vector(18 downto 0);
    signal cpu_wr_data     : std_logic_vector(7 downto 0);
    signal cpu_wr_pending  : std_logic;
    signal cpu_wr_pending1 : std_logic;
    signal cpu_wr_pending2 : std_logic;
    signal cpu_rd_data     : std_logic_vector(7 downto 0);
    signal cpu_rd_pending  : std_logic;
    signal cpu_rd_pending1 : std_logic;
    signal cpu_rd_pending2 : std_logic;
    signal control         : std_logic_vector(7 downto 0) := x"80";

begin

    ------------------------------------------------
    -- Clock Generation
    ------------------------------------------------

    -- 50MHz->150MHz, giving a frame rate of 60.606Hz

    inst_DCM : DCM
        generic map (
            CLKFX_MULTIPLY   => 3,
            CLKFX_DIVIDE     => 1,
            CLKIN_PERIOD     => 20.000,
            CLK_FEEDBACK     => "NONE"
            )
        port map (
            CLKIN            => clk50,
            CLKFB            => '0',
            RST              => '0',
            DSSEN            => '0',
            PSINCDEC         => '0',
            PSEN             => '0',
            PSCLK            => '0',
            CLKFX            => clk_pixel
            );

    ------------------------------------------------
    -- Video Timing
    ------------------------------------------------

    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then
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
                hsync <= '1';
            else
                hsync <= '0';
            end if;
            if v_counter >= V_SYNC_START and v_counter < V_SYNC_END then
                vsync <= '1';
            else
                vsync <= '0';
            end if;
            if h_counter < H_ACTIVE and v_counter < V_ACTIVE then
                active <= '1';
            else
                active <= '0';
            end if;
            if ((h_counter = 0 or h_counter = H_ACTIVE - 1) and v_counter < V_ACTIVE) or
               ((v_counter = 0 or v_counter = V_ACTIVE - 1) and h_counter < H_ACTIVE) then
                outline <= '1';
            else
                outline <= '0';
            end if;
        end if;
    end process;

    ------------------------------------------------
    -- Pixel Output
    ------------------------------------------------

    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then
            if outline = '1' then
                red   <= x"0";
                green <= x"F";
                blue  <= x"0";
            elsif active = '1' and n22 = '1' then
                red   <= x"F";
                green <= x"F";
                blue  <= x"F";
            else
                red   <= x"0";
                green <= x"0";
                blue  <= x"0";
            end if;
        end if;
    end process;

    ------------------------------------------------
    -- Life
    ------------------------------------------------

    n11_extended <= "000" & n11;
    n12_extended <= "000" & n12;
    n13_extended <= "000" & n13;
    n21_extended <= "000" & n21;
    n23_extended <= "000" & n23;
    n31_extended <= "000" & n31;
    n32_extended <= "000" & n32;
    n33_extended <= "000" & n33;

    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then
            if active = '1' then
                n33 <= ram_dout(7);
                n32 <= n33;
                n31 <= n32;
                row2 <= row2(row2'left - 1 downto 0) & n31;
                n23 <= row2(row2'left);
                n22 <= n23;
                n21 <= n22;
                row1 <= row1(row1'left - 1 downto 0) & n21;
                n13 <= row1(row1'left);
                n12 <= n13;
                n11 <= n12;
                neighbour_count <=
                    unsigned(n11_extended) +
                    unsigned(n12_extended) +
                    unsigned(n13_extended) +
                    unsigned(n21_extended) +
                    unsigned(n23_extended) +
                    unsigned(n31_extended) +
                    unsigned(n32_extended) +
                    unsigned(n33_extended);
                -- Using n21 here as neighbour_count is pipelined
                if neighbour_count = 3 or (n21 = '1' and neighbour_count = 2) then
                    nextgen <= '1';
                else
                    nextgen <= '0';
                end if;
                -- Pad so pipeline a multiple of 8 pixels deel
                nextgen1 <= nextgen;
                nextgen2 <= nextgen1;
                nextgen3 <= nextgen2;
                nextgen4 <= nextgen3;
                -- Accumulate 8 samples
                nextgen8 <= nextgen8(nextgen8'left - 1 downto 0) & nextgen4;
            end if;
        end if;
    end process;

    ------------------------------------------------
    -- RAM Address / Control Generation
    ------------------------------------------------

    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then

            -- Synchronize the RD/WR Pending signals from the 1MHz Domain
            if h_counter(1 downto 0) = 3 then
                cpu_rd_pending1 <= cpu_rd_pending;
                cpu_wr_pending1 <= cpu_wr_pending;
            end if;

            if h_counter = 0 and v_counter = 0 then
                ram_rd_addr <= (others => '0');
            elsif active = '1' and h_counter(2 downto 0) = 7 then
                ram_rd_addr <= ram_rd_addr + 1;
            end if;

            if ram_rd_addr < WR_OFFSET then
                ram_wr_addr <= ram_rd_addr + WR_WRAP;
            else
                ram_wr_addr <= ram_rd_addr - WR_OFFSET;
            end if;

            ram_dout <= ram_dout(6 downto 0) & '0';

            if active = '1' and h_counter(2) = '0' then
                -- Life Engine Read Cycle
                ram_cel <= '0';
                ram_addr <= std_logic_vector(ram_rd_addr);
                ram_oel <= '0';
                if h_counter(1 downto 0) = 3 then
                    ram_dout <= ram_data;
                end if;
            elsif active = '1' and h_counter(2) = '1' and control(7) = '1' then
                -- Life Engine Write Cyle
                ram_cel <= '0';
                ram_oel <= '1';
                ram_addr <= std_logic_vector(ram_wr_addr);
                if h_counter(1 downto 0) = 0 then
                    ram_din <= nextgen8;
                end if;
                if h_counter(1 downto 0) = 1 or h_counter(1 downto 0) = 2 then
                    ram_wel_int <= '0';
                else
                    ram_wel_int <= '1';
                end if;
            elsif h_counter(2) = '1' and control(7) = '0' and cpu_wr_pending2 /= cpu_wr_pending1 then
                -- Beeb Write Cyle
                ram_cel <= '0';
                ram_oel <= '1';
                ram_addr <= cpu_addr;
                if h_counter(1 downto 0) = 0 then
                    ram_din <= cpu_wr_data;
                end if;
                if h_counter(1 downto 0) = 1 or h_counter(1 downto 0) = 2 then
                    ram_wel_int <= '0';
                else
                    ram_wel_int <= '1';
                end if;
                if h_counter(1 downto 0) = 3 then
                    cpu_wr_pending2 <= cpu_wr_pending1;
                end if;
            else
                ram_cel <= '1';
                ram_oel <= '1';
                ram_wel_int <= '1';
                ram_addr <= (others => '1');
            end if;
        end if;
    end process;

    ram_wel  <= ram_wel_int;
    ram_data <= ram_din when ram_wel_int = '0' else (others => 'Z');

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
            if pgfc_n = '0' and bus_addr = x"A0" and rnw = '0' then
                control <= bus_data;
            end if;
            if pgfc_n = '0' and bus_addr = x"FF" and rnw = '0' then
                cpu_addr(18 downto 16) <= bus_data(2 downto 0);
                if bus_data(7 downto 3) = "11001" then
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
        end if;
    end process;

    bus_data <= selected & "0000" & cpu_addr(18 downto 16) when pgfc_n = '0' and bus_addr = x"FF" and rnw = '1' else
                                    cpu_addr(15 downto  8) when pgfc_n = '0' and bus_addr = x"FE" and rnw = '1' else
                                                   control when pgfc_n = '0' and bus_addr = x"A0" and rnw = '1' else
                                              cpu_rd_data  when pgfd_n = '0' and  selected = '1'  and rnw = '1' else
                 (others => 'Z');

    bus_data_oel <= '0' when clke = '1' and pgfc_n = '0' and (bus_addr = x"A0" or bus_addr = x"FE" or bus_addr = x"FF") else
                    '0' when clke = '1' and pgfd_n = '0' and selected = '1' else
                    '1';

    bus_data_dir <= rnw;

    ------------------------------------------------
    -- 1MHZ Bus FPGA Adapter Specific Stuff
    ------------------------------------------------

    irq          <= '0';
    nmi          <= '0';

    pmod0        <= blue & red;
    pmod1        <= '0' & '0' & vsync & hsync & green ;
    pmod2        <= (others => '1');

    led          <= sw1 or sw2;

    dac_cs_n     <= '1';
    dac_sck      <= '1';
    dac_sdi      <= '1';
    dac_ldac_n   <= '1';

end Behavioral;
