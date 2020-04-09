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

    constant op_fill       : std_logic_vector(7 downto 0) := x"00";
    constant op_char       : std_logic_vector(7 downto 0) := x"01";

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
    signal bl_selected     : std_logic;

    signal clk_video       : std_logic;
    signal clk_video_n     : std_logic;
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

    -- Blitter registers
    signal bl_src_addr     : std_logic_vector(18 downto 0);
    signal bl_src_xinc     : std_logic_vector(15 downto 0); -- treated as signed
    signal bl_src_yinc     : std_logic_vector(15 downto 0); -- treated as signed
    signal bl_dst_addr     : std_logic_vector(18 downto 0);
    signal bl_dst_xinc     : std_logic_vector(15 downto 0); -- treated as signed
    signal bl_dst_yinc     : std_logic_vector(15 downto 0); -- treated as signed
    signal bl_xcount       : std_logic_vector(9 downto 0);
    signal bl_ycount       : std_logic_vector(9 downto 0);
    signal bl_param        : std_logic_vector(7 downto 0);
    signal bl_op           : std_logic_vector(7 downto 0);

    -- Sign extended versions
    signal bl_src_xinc_ext : std_logic_vector(18 downto 0);
    signal bl_src_yinc_ext : std_logic_vector(18 downto 0);
    signal bl_dst_xinc_ext : std_logic_vector(18 downto 0);
    signal bl_dst_yinc_ext : std_logic_vector(18 downto 0);

    -- Start of next line
    signal tmp_src_addr    : std_logic_vector(18 downto 0);
    signal tmp_dst_addr    : std_logic_vector(18 downto 0);

    -- Tempory X/Y counters for the block
    signal tmp_xcount      : std_logic_vector(9 downto 0);
    signal tmp_ycount      : std_logic_vector(9 downto 0);

    -- Current blitter RAM address
    signal bl_ram_src_addr : std_logic_vector(18 downto 0);
    signal bl_ram_dst_addr : std_logic_vector(18 downto 0);

    -- Blitter state
    type bl_state_type is (
        idle,
        rd_pending,
        wr_pending,
        inc
        );

    signal bl_state      : bl_state_type;
    signal bl_rd_done    : std_logic;
    signal bl_wr_done    : std_logic;
    signal bl_data       : std_logic_vector(7 downto 0);
    signal bl_debug      : std_logic_vector(7 downto 0);

    signal bl_start      : std_logic;
    signal bl_start1     : std_logic;
    signal bl_start2     : std_logic;

    signal bl_fill_op    : std_logic;
    signal bl_char_op    : std_logic;

    signal rom_data      : std_logic_vector(7 downto 0);
    signal char_data     : std_logic_vector(7 downto 0);
    signal char_row      : std_logic_vector(2 downto 0);
    signal char_col      : std_logic_vector(2 downto 0);
    signal char_addr     : std_logic_vector(9 downto 0);

    signal bl_wr_done_lookahead : std_logic;

    signal ram_wel_int   : std_logic;
    signal ram_doel      : std_logic_vector (7 downto 0);
    signal ram_din       : std_logic_vector (7 downto 0);
    signal ram_dout      : std_logic_vector (7 downto 0);

begin

    ------------------------------------------------
    -- Blitter
    ------------------------------------------------

    -- Sign extend the increment values from 16 to 19 bits
    bl_src_xinc_ext <= bl_src_xinc(15) & bl_src_xinc(15) & bl_src_xinc(15) & bl_src_xinc;
    bl_src_yinc_ext <= bl_src_yinc(15) & bl_src_yinc(15) & bl_src_yinc(15) & bl_src_yinc;
    bl_dst_xinc_ext <= bl_dst_xinc(15) & bl_dst_xinc(15) & bl_dst_xinc(15) & bl_dst_xinc;
    bl_dst_yinc_ext <= bl_dst_yinc(15) & bl_dst_yinc(15) & bl_dst_yinc(15) & bl_dst_yinc;

    -- Decode the blitter ops
    bl_fill_op <= '1' when bl_op = op_fill else '0';
    bl_char_op <= '1' when bl_op = op_char else '0';

    process(clk_video)
    begin
        if rising_edge(clk_video) then

            -- Synchronise the write of the bl_op register from the 1MHz bus domain
            bl_start1 <= bl_start;
            bl_start2 <= bl_start1;

            case bl_state is
                when idle =>
                    if bl_start1 = '1' and bl_start2 = '0' then
                        bl_ram_src_addr <= bl_src_addr;
                        bl_ram_dst_addr <= bl_dst_addr;
                        tmp_src_addr    <= std_logic_vector(unsigned(bl_src_addr) + unsigned(bl_src_yinc_ext));
                        tmp_dst_addr    <= std_logic_vector(unsigned(bl_dst_addr) + unsigned(bl_dst_yinc_ext));
                        tmp_xcount      <= bl_xcount;
                        tmp_ycount      <= bl_ycount;
                        if bl_fill_op = '1' then
                            bl_state    <= wr_pending;
                        else
                            bl_state    <= rd_pending;
                        end if;
                    end if;

                when rd_pending =>
                    if bl_rd_done = '1' then
                        bl_state      <= wr_pending;
                    end if;

                when wr_pending =>
                    if bl_wr_done_lookahead = '1' then
                        bl_state      <= inc;
                    end if;

                when inc =>
                    if unsigned(tmp_xcount) = 0 then
                        -- Next line
                        tmp_xcount      <= bl_xcount;
                        tmp_ycount      <= std_logic_vector(unsigned(tmp_ycount) - 1);
                        bl_ram_src_addr <= tmp_src_addr;
                        bl_ram_dst_addr <= tmp_dst_addr;
                        tmp_src_addr    <= std_logic_vector(unsigned(tmp_src_addr) + unsigned(bl_src_yinc_ext));
                        tmp_dst_addr    <= std_logic_vector(unsigned(tmp_dst_addr) + unsigned(bl_dst_yinc_ext));
                    else
                        -- Same line
                        tmp_xcount      <= std_logic_vector(unsigned(tmp_xcount) - 1);
                        bl_ram_src_addr <= std_logic_vector(unsigned(bl_ram_src_addr) + unsigned(bl_src_xinc_ext));
                        bl_ram_dst_addr <= std_logic_vector(unsigned(bl_ram_dst_addr) + unsigned(bl_dst_xinc_ext));
                    end if;
                    -- Next state
                    if unsigned(tmp_xcount) = 0 and unsigned(tmp_ycount) = 0 then
                        bl_state <= idle;
                    elsif bl_fill_op = '1' then
                        bl_state <= wr_pending;
                    else
                        bl_state <= rd_pending;
                    end if;
            end case;
        end if;
    end process;


    process(bl_state, bl_rd_done, bl_wr_done)
    begin
        case bl_state is
            when idle =>
                bl_debug(3 downto 0) <= x"0";
            when rd_pending =>
                bl_debug(3 downto 0) <= x"1";
            when wr_pending =>
                bl_debug(3 downto 0) <= x"2";
            when inc =>
                bl_debug(3 downto 0) <= x"3";
        end case;
        bl_debug(7 downto 4) <= "00" & bl_rd_done & bl_wr_done;
    end process;

    ------------------------------------------------
    -- Clocking
    ------------------------------------------------

    clk_video <= clk50;
    clk_video_n <= not clk50;

    process(clk_video)
    begin
        if rising_edge(clk_video) then
            clk_div <= not clk_div;
        end if;
    end process;

    ------------------------------------------------
    -- Character
    ------------------------------------------------

    -- Counts run 7..0
    char_col  <= std_logic_vector(unsigned(tmp_xcount(2 downto 0)));
    char_row  <= std_logic_vector(7 - unsigned(tmp_ycount(2 downto 0)));
    char_addr <= bl_param(6 downto 0) & char_row;

    char_rom_inst : entity work.char_rom port map (
        clock    => clk_video,
        addressA => char_addr,
        QA       => rom_data);

    char_data <= x"ff" when rom_data(to_integer(unsigned(char_col))) = '1' else x"00";

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

    -- Indicates when the next cycle could be used for the blitter write cycle
    -- This eliminates one cycle of latency between the two state machines, and
    -- doubles the fill rate from 12.5Mpixels/sec to 25.0Mpixels/sec.
    bl_wr_done_lookahead <= '1' when clk_div = '1' and (cpu_rd_pending1 = cpu_rd_pending2) and (cpu_wr_pending1 = cpu_wr_pending2) else '0';

    process(clk_video)
    begin
        if rising_edge(clk_video) then

            -- Synchronize the RD/WR Pending signals from the 1MHz Domain
            cpu_rd_pending1 <= cpu_rd_pending;
            cpu_wr_pending1 <= cpu_wr_pending;

            -- bl_done defaults to '0'
            bl_rd_done <= '0';
            bl_wr_done <= '0';

            if clk_div = '0' and active = '1' then
                -- Video Read Cycle
                ram_addr        <= std_logic_vector(v_counter(8 downto 0)) & std_logic_vector(h_counter);
                ram_din         <= (others => '0');
                ram_cel         <= '0';
                ram_oel         <= '0';
                ram_wel_int     <= '1';
            elsif cpu_rd_pending2 /= cpu_rd_pending1 then
                -- CPU Read Cycle
                ram_addr        <= cpu_addr;
                ram_din         <= (others => '0');
                ram_cel         <= '0';
                ram_oel         <= '0';
                ram_wel_int     <= '1';
                cpu_rd_done     <= '1';
                cpu_rd_pending2 <= cpu_rd_pending1;
            elsif cpu_wr_pending2 /= cpu_wr_pending1 then
                -- CPU Write Cycle
                ram_addr        <= cpu_addr;
                ram_din         <= cpu_wr_data;
                ram_cel         <= '0';
                ram_oel         <= '1';
                ram_wel_int     <= '0';
                cpu_wr_pending2 <= cpu_wr_pending1;
            elsif bl_state = wr_pending and bl_wr_done = '0' then
                -- Blitter Write Cycle
                ram_addr    <= bl_ram_dst_addr;
                if bl_fill_op = '1' then
                    ram_din  <= bl_param;
                elsif bl_char_op = '1' then
                    ram_din  <= char_data;
                else
                    ram_din  <= bl_data;
                end if;
                ram_cel     <= '0';
                ram_oel     <= '1';
                ram_wel_int <= '0';
                bl_wr_done  <= '1';
            elsif bl_state = rd_pending and bl_rd_done = '0' then
                -- Blitter Read Cycle
                ram_addr    <= bl_ram_src_addr;
                ram_din     <= (others => '0');
                ram_cel     <= '0';
                ram_oel     <= '0';
                ram_wel_int <= '1';
                bl_rd_done  <= '1';
            else
                -- IDLE cycle
                ram_addr     <= (others => '0');
                ram_din      <= (others => '0');
                ram_cel      <= '1';
                ram_oel      <= '1';
                ram_wel_int  <= '1';
            end if;

            -- Handle the data from a blitter read cycle
            if bl_rd_done = '1' then
                bl_data <= ram_dout;
            end if;

            -- Handle the data from a video read cycle
            if clk_div = '1' then
                if active = '1' then
                    if outline = '1' then
                        red   <= x"F";
                        green <= x"F";
                        blue  <= x"F";
                    else
                        red   <= ram_dout(2 downto 0) & '0';
                        green <= ram_dout(5 downto 3) & '0';
                        blue  <= ram_dout(7 downto 6) & ram_dout(6) & '0';
                    end if;
                else
                    red   <= (others => '0');
                    green <= (others => '0');
                    blue  <= (others => '0');
                end if;
            end if;

            -- Handle the data from a CPU read cycle
            if cpu_rd_done = '1' then
                cpu_rd_data <= ram_dout;
                cpu_rd_done <= '0';
            end if;

        end if;
    end process;

    ------------------------------------------------
    -- SRAM I/O Drivers
    ------------------------------------------------

    ram_wel_ddr : ODDR2
        port map (
            Q  => ram_wel,
            C0 => clk_video_n,
            C1 => clk_video,
            CE => '1',
            D0 => ram_wel_int,
            D1 => '1',
            R  => '0',
            S  => '0'
            );

    gen_sram_data_io: for i in 0 to 7 generate
        -- replicate the ODDR2 for each data bit, because of limited routing
        oddr2x : ODDR2
            port map (
                Q  => ram_doel(i),
                C0 => clk_video_n,
                C1 => clk_video,
                CE => '1',
                D0 => ram_wel_int,
                D1 => '1',
                R  => '0',
                S  => '0'
                );
        -- the active low tristate connects directly to the IOBUFT in the same IOB
        iobufx : IOBUF
            generic map (
                DRIVE => 8
                )
            port map (
                O  => ram_dout(i),
                I  => ram_din(i),
                IO => ram_data(i),
                T  => ram_doel(i)
                );
    end generate;

    ------------------------------------------------
    -- 1MHz Bus Interface
    ------------------------------------------------

    process(clke, rst_n)
    begin
        if rst_n = '0' then
            selected <= '0';
            bl_selected <= '0';
        elsif falling_edge(clke) then
            bl_start <= '0';
            if selected = '1' and cpu_addr(18 downto 8) = "11111111111" then
                bl_selected <= '1';
            else
                bl_selected <= '0';
            end if;
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
            if bl_selected = '1' and pgfd_n = '0' and rnw = '0' then
                case bus_addr is
                    when x"00" =>
                        bl_src_addr(7 downto 0) <= bus_data;
                    when x"01" =>
                        bl_src_addr(15 downto 8) <= bus_data;
                    when x"02" =>
                        bl_src_addr(18 downto 16) <= bus_data(2 downto 0);
                    when x"04" =>
                        bl_src_xinc(7 downto 0) <= bus_data;
                    when x"05" =>
                        bl_src_xinc(15 downto 8) <= bus_data;
                    when x"06" =>
                        bl_src_yinc(7 downto 0) <= bus_data;
                    when x"07" =>
                        bl_src_yinc(15 downto 8) <= bus_data;
                    when x"08" =>
                        bl_dst_addr(7 downto 0) <= bus_data;
                    when x"09" =>
                        bl_dst_addr(15 downto 8) <= bus_data;
                    when x"0A" =>
                        bl_dst_addr(18 downto 16) <= bus_data(2 downto 0);
                    when x"0C" =>
                        bl_dst_xinc(7 downto 0) <= bus_data;
                    when x"0D" =>
                        bl_dst_xinc(15 downto 8) <= bus_data;
                    when x"0E" =>
                        bl_dst_yinc(7 downto 0) <= bus_data;
                    when x"0F" =>
                        bl_dst_yinc(15 downto 8) <= bus_data;
                    when x"10" =>
                        bl_xcount(7 downto 0) <= bus_data;
                    when x"11" =>
                        bl_xcount(9 downto 8) <= bus_data(1 downto 0);
                    when x"12" =>
                        bl_ycount(7 downto 0) <= bus_data;
                    when x"13" =>
                        bl_ycount(9 downto 8) <= bus_data(1 downto 0);
                    when x"14" =>
                        bl_param <= bus_data;
                    when x"15" =>
                        bl_op <= bus_data;
                        bl_start <= '1';
                    when others =>
                end case;
            elsif selected = '1' and pgfd_n = '0' and rnw = '0' then
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

    bus_data <= selected & bl_selected & "000" & cpu_addr(18 downto 16) when   pgfc_n = '0' and bus_addr = x"FF" and rnw = '1' else
                             cpu_addr(15 downto  8) when                       pgfc_n = '0' and bus_addr = x"FE" and rnw = '1' else
                             cpu_addr( 7 downto  0) when                       pgfc_n = '0' and bus_addr = x"FD" and rnw = '1' else
                                        cpu_wr_data when                       pgfc_n = '0' and bus_addr = x"FC" and rnw = '1' else
                            bl_src_addr(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"00" and rnw = '1' else
                           bl_src_addr(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"01" and rnw = '1' else
                "00000" & bl_src_addr(18 downto 16) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"02" and rnw = '1' else
                                              x"00" when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"03" and rnw = '1' else
                            bl_src_xinc(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"04" and rnw = '1' else
                           bl_src_xinc(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"05" and rnw = '1' else
                            bl_src_yinc(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"06" and rnw = '1' else
                           bl_src_yinc(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"07" and rnw = '1' else
                            bl_dst_addr(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"08" and rnw = '1' else
                           bl_dst_addr(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"09" and rnw = '1' else
                "00000" & bl_dst_addr(18 downto 16) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0A" and rnw = '1' else
                                              x"00" when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0B" and rnw = '1' else
                            bl_dst_xinc(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0C" and rnw = '1' else
                           bl_dst_xinc(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0D" and rnw = '1' else
                            bl_dst_yinc(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0E" and rnw = '1' else
                           bl_dst_yinc(15 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"0F" and rnw = '1' else
                              bl_xcount(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"10" and rnw = '1' else
                   "000000" & bl_xcount(9 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"11" and rnw = '1' else
                              bl_ycount(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"12" and rnw = '1' else
                   "000000" & bl_ycount(9 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"13" and rnw = '1' else
                                           bl_param when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"14" and rnw = '1' else
                                              bl_op when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"15" and rnw = '1' else
                             tmp_xcount(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"18" and rnw = '1' else
                  "000000" & tmp_xcount(9 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"19" and rnw = '1' else
                             tmp_ycount(7 downto 0) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"1A" and rnw = '1' else
                  "000000" & tmp_ycount(9 downto 8) when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"1B" and rnw = '1' else
                                           bl_debug when bl_selected = '1' and pgfd_n = '0' and bus_addr = x"1C" and rnw = '1' else
                                              x"AA" when bl_selected = '1' and pgfd_n = '0'                      and rnw = '1' else
                                       cpu_rd_data  when    selected = '1' and pgfd_n = '0'                      and rnw = '1' else
                 (others => 'Z');

    -- TODO: Fix this to allow sharing with other 1MHz devices
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
