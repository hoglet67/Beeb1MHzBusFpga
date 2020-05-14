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

    constant BORDER        : integer := 1;

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

    signal clk_pixel       : std_logic;

    signal h_counter       : unsigned(11 downto 0);
    signal v_counter       : unsigned(10 downto 0);

    signal red             : std_logic_vector(3 downto 0);
    signal green           : std_logic_vector(3 downto 0);
    signal blue            : std_logic_vector(3 downto 0);
    signal hsync           : std_logic;
    signal vsync           : std_logic;
    signal active          : std_logic;
    signal outline         : std_logic;

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
    end process;

    ------------------------------------------------
    -- Pixel Output
    ------------------------------------------------

    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then
            if active = '1' then
                if outline = '1' then
                    red   <= x"F";
                    green <= x"F";
                    blue  <= x"F";
                else
                    red   <= x"7";
                    green <= x"7";
                    blue  <= x"7";
                end if;
            else
                red   <= (others => '0');
                green <= (others => '0');
                blue  <= (others => '0');
            end if;
        end if;
    end process;

    ------------------------------------------------
    -- 1MHZ Bus FPGA Adapter Specific Stuff
    ------------------------------------------------

    irq          <= '0';
    nmi          <= '0';

    bus_data_dir <= '1';
    bus_data_oel <= '1';
    bus_data     <= (others => 'Z');

    pmod0        <= blue & red;
    pmod1        <= '0' & '0' & vsync & hsync & green ;
    pmod2        <= (others => '1');

    led          <= sw1 or sw2;

    dac_cs_n     <= '1';
    dac_sck      <= '1';
    dac_sdi      <= '1';
    dac_ldac_n   <= '1';

    ram_addr     <= (others => '1');
    ram_data     <= (others => 'Z');
    ram_cel      <= '1';
    ram_oel      <= '1';
    ram_wel      <= '1';

end Behavioral;
