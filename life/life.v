//`define VGA_1920_1080

`define VGA_1600_1200

//`define VGA_800_600

module life (
             // System oscillator
             clk50,
             // BBC 1MHZ Bus
             clke,
             rnw,
             rst_n,
             pgfc_n,
             pgfd_n,
             bus_addr,
             bus_data,
             bus_data_dir,
             bus_data_oel,
             nmi,
             irq,
             // SPI DAC
             dac_cs_n,
             dac_sck,
             dac_sdi,
             dac_ldac_n,
             // RAM
             ram_addr,
             ram_data,
             ram_cel,
             ram_oel,
             ram_wel,
             // Misc
             pmod0,
             pmod1,
             pmod2,
             sw1,
             sw2,
             led
             );

   // System oscillator
   input             clk50;
   // BBC 1MHZ Bus
   input             clke;
   input             rnw;
   input             rst_n;
   input             pgfc_n;
   input             pgfd_n;
   input [7:0]       bus_addr;
   inout [7:0]       bus_data;
   output            bus_data_dir;
   output            bus_data_oel;
   output            nmi;
   output            irq;
   // SPI DAC
   output            dac_cs_n;
   output            dac_sck;
   output            dac_sdi;
   output            dac_ldac_n;
   // RAM
   output reg [18:0] ram_addr;
   inout [7:0]       ram_data;
   output reg        ram_cel;
   output reg        ram_oel;
   output reg        ram_wel;
   // Misc
   output [7:0]      pmod0;
   output [7:0]      pmod1;
   output [3:0]      pmod2;
   input             sw1;
   input             sw2;
   output            led;

`ifdef VGA_1920_1080

   // H_TOTAL = 2200
   localparam H_ACTIVE      = 11'd1920;
   localparam H_SYNC_START  = H_ACTIVE + 88;
   localparam H_SYNC_END    = H_SYNC_START + 44;
   localparam H_TOTAL       = H_SYNC_END + 148;

   // V_TOTAL = 1125
   localparam V_ACTIVE      = 11'd1080;
   localparam V_SYNC_START  = V_ACTIVE + 4;
   localparam V_SYNC_END    = V_SYNC_START + 5;
   localparam V_TOTAL       = V_SYNC_END + 36;

   // DCM
   localparam DCM_M         = 3;
   localparam DCM_D         = 2;

`endif

`ifdef VGA_1600_1200

   // H_TOTAL = 2160
   localparam H_ACTIVE      = 11'd1600;
   localparam H_SYNC_START  = H_ACTIVE + 64;
   localparam H_SYNC_END    = H_SYNC_START + 192;
   localparam H_TOTAL       = H_SYNC_END + 304;

   // V_TOTAL = 1250
   localparam V_ACTIVE      = 11'd1200;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 3;
   localparam V_TOTAL       = V_SYNC_END + 46;

   // DCM
   localparam DCM_M         = 13;
   localparam DCM_D         = 8;

`endif

`ifdef VGA_800_600

   // H_TOTAL = 1056
   localparam H_ACTIVE      = 10'd800;
   localparam H_SYNC_START  = H_ACTIVE + 40;
   localparam H_SYNC_END    = H_SYNC_START + 128;
   localparam H_TOTAL       = H_SYNC_END + 88;

   // V_TOTAL = 628
   localparam V_ACTIVE      = 10'd600;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 4;
   localparam V_TOTAL       = V_SYNC_END + 23;

   // DCM
   localparam DCM_M         = 4;
   localparam DCM_D         = 10;

`endif

   // Number of rows in life playfield
   localparam NR            = V_ACTIVE;

   // Number of (byte) cols in life playfield
   localparam NC            = H_ACTIVE / 8;

   // Write Offset, must be a whole number of rows
   localparam WR_OFFSET     = NC;

   // Write Offset when wrapping
   localparam WR_WRAP       = (NC * NR) - NC;

   // Video Pipeline Delay (inc SRAM) in clk_pixel cycles
   localparam VPD           = 2;

   // Scaler fractional bits
   localparam SFB           = 2;

   // Life Pipeline Delay (in bytes)
   localparam LPD           = 3;

   // Fixed point versions of H_ACTIVE and V_ACTIVE
   localparam H_ACTIVE_FP   = {H_ACTIVE, {SFB{1'b0}}};
   localparam V_ACTIVE_FP   = {V_ACTIVE, {SFB{1'b0}}};

   // Clocks
   wire                clk0;
   wire                clk_pixel;
   wire                clk_pixel_n;

   // Video Timing
   reg [11:0]          h_counter_next = 0;
   reg [11:0]          h_counter = 0;
   reg [10:0]          v_counter_next = 0;
   reg [10:0]          v_counter = 0;
   reg                 last_vsync1 = 0;
   reg                 last_vsync2 = 0;
   reg                 active = 0;
   reg                 hsync = 0;
   reg                 vsync = 0;
   reg                 blank = 0;
   reg                 border = 0;
   reg [VPD:0]         hsync0 = 0; // +1 delay, to compensate for the DDR registers on RGB
   reg [VPD:0]         vsync0 = 0; // +1 delay, to compensate for the DDR registers on RGB
   reg [VPD-1:0]       blank0 = 0;
   reg [VPD-1:0]       border0 = 0;
   reg [7:0]           mask = 0;

   // RGB
   reg [11:0]          rgb0 = 0;
   reg [11:0]          rgb1 = 0;
   wire [11:0]         rgb;
   wire [3:0]          red;
   wire [3:0]          green;
   wire [3:0]          blue;

   // Scaler Registers
   reg [2:0]           scaler_zoom = 0;                    // 0 = fully zoomed out (scaler bypassed)
   reg [10+SFB:0]      scaler_x_origin = H_ACTIVE_FP / 2;  // 11.2 fixed point
   reg [10+SFB:0]      scaler_y_origin = V_ACTIVE_FP / 2;  // 11.2 fixed point
   wire [10+SFB:0]     scaler_x_next;                      // 11.2 fixed point
   wire [10+SFB:0]     scaler_y_next;                      // 11.2 fixed point
   reg [7:0]           scaler_x_speed = 0;                 // 6.2 fixed point
   reg [7:0]           scaler_y_speed = 0;                 // 6.2 fixed point

   // Scaler parameters
   reg [8:0]           scaler_w = 0;
   reg [9:0]           scaler_h = 0;
   reg [10:0]          scaler_x_lo_tmp = 0;
   reg [10:0]          scaler_y_lo_tmp = 0;
   reg [10:0]          scaler_x_lo = 0;
   reg [10:0]          scaler_y_lo = 0;
   reg [3:0]           scaler_inc_x_mask = 0;
   reg [3:0]           scaler_inc_y_mask = 0;

   // Scaler write pipeline
   reg                 active0 = 0;
   reg                 active1 = 0;
   reg                 active2 = 0;
   reg [8:0]           scaler_x_count0 = 0;
   reg [9:0]           scaler_y_count0 = 0;
   reg                 scaler_rst0 = 0;
   reg                 scaler_rst1 = 0;
   reg                 scaler_rst2 = 0;
   reg                 scaler_wr1 = 0;
   reg                 scaler_wr2 = 0;
   reg                 scaler_wr3 = 0;
   reg [1:0]           scaler_bdr0 = 0;
   reg [1:0]           scaler_bdr1 = 0;
   reg [1:0]           scaler_bdr2 = 0;
   reg [2:0]           scaler_din3 = 0;
   reg [17:0]          scaler_wr_addr3 = 0;

   // Scaler RAM
   reg [1:0]           scaler_ram[0:262143];
   reg                 scaler_bank = 0;

   // Scaler read pipeline
   reg [17:0]          scaler_rd_addr_x = 0;
   reg [17:0]          scaler_rd_addr_y = 0;
   reg [17:0]          scaler_rd_addr = 0;
   reg                 scaler_rd_rst_x = 0;
   reg                 scaler_rd_rst_y = 0;
   reg                 scaler_rd_inc_x = 0;
   reg                 scaler_rd_inc_y = 0;
   reg                 scaler_pix_sel0 = 0;
   reg                 scaler_pix_sel1 = 0;
   reg [1:0]           scaler_dout2 = 0;
   reg                 scaler_dout = 0;

   // Life Pipeline
   reg                 life_clken = 0;
   reg                 life_rd_active = 0;
   wire [18:0]         life_rd_addr;
   reg [7:0]           life_rd_data = 0;
   reg                 life_wr_active = 0;
   reg [(LPD-1)*19-1:0]life_wr_addr0 = 0;
   reg [18:0]          life_wr_addr = 0;
   wire [7:0]          life_wr_data;
   reg [18:0]          life_col_addr = 0;
   reg [18:0]          life_row_addr = 0;
   wire [18:0]         life_wr_offset = WR_OFFSET;
   wire [18:0]         life_wr_wrap = WR_WRAP;
   reg [7:0]           display_dout = 0;
   reg                 running = 0;

   // Memory Controller
   reg                 beeb_rd = 0;
   reg                 write_n = 0;
   reg [7:0]           ram_din = 0;

   // 1MHz Bus
   reg                 selected = 0;
   reg [18:0]          cpu_addr = 0;
   reg [7:0]           cpu_wr_data = 0;
   reg                 cpu_wr_pending = 0;
   reg                 cpu_wr_pending1 = 0;
   reg                 cpu_wr_pending2 = 0;
   reg [7:0]           cpu_rd_data = 0;
   reg                 cpu_rd_pending = 0;
   reg                 cpu_rd_pending1 = 0;
   reg                 cpu_rd_pending2 = 0;
   reg [7:0]           control = 8'h00;

   wire                ctrl_running     = control[7];
   wire                ctrl_mask        = control[6];
   wire                ctrl_clear       = control[5];
   wire                ctrl_border      = control[4];
   wire [1:0]          ctrl_clear_type  = control[1:0];

   wire [7:0]          status = { running, vsync, 6'b000000};

   wire [7:0]          width_div_8 = H_ACTIVE / 8;
   wire [7:0]          height_div_8 = V_ACTIVE / 8;

   reg [7:0]           clear_wr_data = 0;
   reg [30:0]          prbs0 = 31'h12345678; // pick different seeds at random
   reg [30:0]          prbs1 = 31'h49987ffe;
   reg [30:0]          prbs2 = 31'h2fe457aa;

   genvar              i;

   // =================================================
   // Clock Generation
   // =================================================

   // 50MHz->150.0MHz giving a frame rate of 60.606Hz @ 1920x1080
   // 50MHz->162.5MHz giving a frame rate of 60.185Hz @ 1600x1200
   // 50MHz-> 40.0MHz giving a frame rate of 60.317Hz @  800x600

   DCM
     #(
       .CLKFX_MULTIPLY   (DCM_M),
       .CLKFX_DIVIDE     (DCM_D),
       .CLKIN_PERIOD     (20.000),
       .CLK_FEEDBACK     ("1X")
       )
   DCM1
     (
      .CLKIN            (clk50),
      .CLKFB            (clk0),
      .RST              (1'b0),
      .DSSEN            (1'b0),
      .PSINCDEC         (1'b0),
      .PSEN             (1'b0),
      .PSCLK            (1'b0),
      .CLKFX            (clk_pixel),
      .CLKFX180         (clk_pixel_n),
      .CLKDV            (),
      .CLK2X            (),
      .CLK2X180         (),
      .CLK0             (clk0),
      .CLK90            (),
      .CLK180           (),
      .CLK270           (),
      .LOCKED           (),
      .PSDONE           (),
      .STATUS           ()
      );

   // =================================================
   // Video Timing
   // =================================================

   always @(h_counter or v_counter) begin
      if (h_counter == H_TOTAL - 2) begin
         h_counter_next = 0;
         if (v_counter == V_TOTAL - 1)
           v_counter_next = 0;
         else
           v_counter_next = v_counter + 1'b1;
      end else begin
         v_counter_next = v_counter;
         // Step the h_counter in units of two pixels
         // (this means the LSB is not used, and will likely generate a warning)
         h_counter_next = h_counter + 2'b10;
      end
   end


   always @(posedge clk_pixel) begin
      h_counter <= h_counter_next;
      v_counter <= v_counter_next;

      // Active lags h_counter by one cycle
      active    <= h_counter_next < H_ACTIVE && v_counter_next < V_ACTIVE;

      // Skew the video control outputs by VPD clocks to compensate for the video pipeline delay
      // (the other way of doing this would be with pipeline registers)
      { hsync,  hsync0} <= {hsync0, (h_counter >= H_SYNC_START && h_counter < H_SYNC_END)};
      { vsync,  vsync0} <= {vsync0, (v_counter >= V_SYNC_START && v_counter < V_SYNC_END)};
      { blank,  blank0} <= {blank0, (h_counter >= H_ACTIVE || v_counter >= V_ACTIVE)};
      {border, border0} <= {border0, ((h_counter == 0 || h_counter == H_ACTIVE - 2) && (v_counter < V_ACTIVE)) ||
                                     ((v_counter == 0 || v_counter == V_ACTIVE - 1) && (h_counter < H_ACTIVE))};
   end

   // =================================================
   // Scaler (TODO: make this a seperate module)
   // =================================================


   always @(posedge clk_pixel) begin

      // No attempt had been made to control the latency through the scaler
      // so it's possible that the window will be a few pixels out horizonal in absolute accuracy

      // Example at 1600x1200:
      // Zoom = 0; window is 1600x1200 pixels (scaler bypassed)
      // Zoom = 1; window is 800x600 pixels
      // Zoom = 2; window is 400x300 pixels
      // Zoom = 3; window is 200x150 pixels
      // Zoom = 4; window is 100x75 pixels

      // *************************************************************************
      // *** Parameters (depend only on registers, so are considered fixed)
      // *************************************************************************

      case (scaler_zoom)
        3'b100:
          begin
             scaler_w <= H_ACTIVE / 32; // units of two-pixels
             scaler_h <= V_ACTIVE / 16;
             scaler_inc_x_mask <= 4'b1110;
             scaler_inc_y_mask <= 4'b1111;
          end
        3'b011:
          begin
             scaler_w <= H_ACTIVE / 16; // units of two-pixels
             scaler_h <= V_ACTIVE / 8;
             scaler_inc_x_mask <= 4'b0110;
             scaler_inc_y_mask <= 4'b0111;
          end
        3'b010:
          begin
             scaler_w <= H_ACTIVE / 8;  // units of two-pixels
             scaler_h <= V_ACTIVE / 4;
             scaler_inc_x_mask <= 4'b0010;
             scaler_inc_y_mask <= 4'b0011;
          end
        default:
          begin
             scaler_w <= H_ACTIVE / 4;  // units of two-pixels
             scaler_h <= V_ACTIVE / 2;
             scaler_inc_x_mask <= 4'b0000;
             scaler_inc_y_mask <= 4'b0001;
          end
      endcase

      // Calculate x,y of top left corner (only allow changes when scaler not running)
      if (scaler_x_count0 == 0 && scaler_y_count0 == 0) begin
         // Ignore the fractional bits
         scaler_x_lo_tmp <= scaler_x_origin[10+SFB:SFB] - scaler_w;
         scaler_y_lo_tmp <= scaler_y_origin[10+SFB:SFB] - scaler_h[9:1];
      end

      // Correct for wrapping
      if (scaler_x_lo_tmp < H_ACTIVE)
        scaler_x_lo <= scaler_x_lo_tmp;
      else
        scaler_x_lo <= scaler_x_lo_tmp + H_ACTIVE;
      if (scaler_y_lo_tmp < V_ACTIVE)
        scaler_y_lo <= scaler_y_lo_tmp;
      else
        scaler_y_lo <= scaler_y_lo_tmp + V_ACTIVE;

      // *************************************************************************
      // *** Write Pipeline stage 0 (only this stage uses h_counter/v_counter and active)
      // *************************************************************************

      // Double buffer bank selection
      if (h_counter == 0 && v_counter == 0) begin
        if (scaler_zoom < 3'b010) begin
          scaler_bank <= 1'b0;
        end else begin
          scaler_bank <= !scaler_bank;
        end
      end

      // When to reset the scaler wr address
      // (i.e. at top left corner of capture window)
      scaler_rst0 <= h_counter == {1'b0, scaler_x_lo[10:1], 1'b0} && v_counter == scaler_y_lo;

      // When to write/increment the scaler wr address
      // (i.e. whether a pixel falls within the capture window)
      if (active) begin
         if (h_counter == {1'b0, scaler_x_lo[10:1], 1'b0}) begin
            scaler_x_count0 <= scaler_w;
            if (v_counter == scaler_y_lo) begin
               scaler_y_count0 <= scaler_h;
            end else if (|scaler_y_count0) begin
               scaler_y_count0 <= scaler_y_count0 - 1'b1;
            end
         end else if (|scaler_x_count0) begin
            scaler_x_count0 <= scaler_x_count0 - 1'b1;
         end
      end

      scaler_bdr0  <= { ((v_counter == 0) || (v_counter == V_ACTIVE - 1) || (h_counter ==            0)) && ctrl_border,
                        ((v_counter == 0) || (v_counter == V_ACTIVE - 1) || (h_counter == H_ACTIVE - 2)) && ctrl_border};
      active0      <= active;

      // *************************************************************************
      // *** Write Pipeline stage 1, uses outputs of stage 0
      // *************************************************************************

      scaler_wr1  <= |scaler_x_count0 && |scaler_y_count0 && active0;
      scaler_rst1 <= scaler_rst0;
      scaler_bdr1 <= scaler_bdr0;
      active1     <= active0;

      // *************************************************************************
      // *** Write Pipeline stage 2, uses outputs of stage 1
      // *************************************************************************

      scaler_wr2  <= scaler_wr1;
      scaler_rst2 <= scaler_rst1;
      scaler_bdr2 <= scaler_bdr1;
      active2     <= active1;

      // *************************************************************************
      // *** Write Pipeline stage 3, uses outputs of stage 2
      // *************************************************************************

      // Scaler write address
      if (scaler_rst2)
        scaler_wr_addr3 <= {scaler_bank, 17'h00000};
      else if (scaler_wr2)
        scaler_wr_addr3 <= scaler_wr_addr3 + 1'b1;

      // Capture 3 pixels
      if (active2)
        scaler_din3 <= {scaler_din3[0], display_dout[7:6] | scaler_bdr2};
      scaler_wr3  <= scaler_wr2;

      // *************************************************************************
      // *** Scaler RAM Write
      // *************************************************************************
      if (scaler_wr3)
        scaler_ram[scaler_wr_addr3] <= scaler_x_lo[0] ? scaler_din3[1:0] : scaler_din3[2:1];

      // When to reset the scaler rd address
      scaler_rd_rst_x <= h_counter == H_ACTIVE;
      scaler_rd_rst_y <= v_counter == V_TOTAL - 1;

      // When to increment the scaler rd addess
      scaler_rd_inc_x <= ((h_counter[3:0] & scaler_inc_x_mask) == scaler_inc_x_mask) && active;
      scaler_rd_inc_y <= ((v_counter[3:0] & scaler_inc_y_mask) == scaler_inc_y_mask) && h_counter == H_ACTIVE;

      // X component of scaler read address (bit 0 of this selects the one of the pixel pair)
      if (scaler_rd_rst_x)
        scaler_rd_addr_x <= 0;
      else if (scaler_rd_inc_x)
        scaler_rd_addr_x <= scaler_rd_addr_x + 1'b1;

      // Y component of scaler read address
      // (this happens at the end of the frame, so bank is the bank that has just been written)
      if (scaler_rd_rst_y)
        scaler_rd_addr_y <= {scaler_bank, 17'h00000};
      else if (scaler_rd_inc_y)
        scaler_rd_addr_y <= scaler_rd_addr_y + scaler_w;

      // Scaler read address
      scaler_rd_addr  <= scaler_rd_addr_x[17:1] + scaler_rd_addr_y;
      scaler_pix_sel0 <= scaler_rd_addr_x[0];

      // Scaler read
      scaler_dout2    <= scaler_ram[scaler_rd_addr];
      scaler_pix_sel1 <= scaler_pix_sel0;

      // Output of the scaler is a single pixel
      scaler_dout <= scaler_pix_sel1 ? scaler_dout2[0] : scaler_dout2[1];

   end

   // =================================================
   // Pixel Output
   // =================================================

   wire rescale = |scaler_zoom;

   always @(negedge clk_pixel) begin
      if ((!blank) && (rescale ? scaler_dout : display_dout[7])) begin
         rgb1 <= 12'hFFF;
      end else if (border) begin
         if (ctrl_mask)
           rgb1 <= 12'hF00;
         else
           rgb1 <= 12'h0F0;
      end else begin
         rgb1 <= 12'h000;
      end
      if ((!blank) && (rescale ? scaler_dout : display_dout[6])) begin
         rgb0 <= 12'hFFF;
      end else if (border) begin
         if (ctrl_mask)
           rgb0 <= 12'hF00;
         else
           rgb0 <= 12'h0F0;
      end else begin
         rgb0 <= 12'h000;
      end
   end

   // Use ODDR2 registers to output pixels at 2x clk_pixel
   generate
      for (i = 0; i < 12; i = i + 1) begin : b_rgb
        ODDR2 oddr2_rgb (
                   .Q  (rgb[i]),
                   .C0 (clk_pixel_n),
                   .C1 (clk_pixel),
                   .CE (1'b1),
                   .D0 (rgb0[i]),
                   .D1 (rgb1[i]),
                   .R  (1'b0),
                   .S  (1'b0)
                );
      end
   endgenerate

   assign red   = rgb[11:8];
   assign green = rgb[ 7:4];
   assign blue  = rgb[ 3:0];


   // =================================================
   // Life Pipeline
   // =================================================

   life_pipeline #(NC + LPD) lp
     (.clk       (clk_pixel),
      .clken     (life_clken),
      .read_data (life_rd_data),
      .write_data(life_wr_data));

   // =================================================
   // Life Address Generation
   // =================================================

   assign life_rd_addr = life_row_addr + life_col_addr;

   always @(posedge clk_pixel) begin

      // life_rd_addr = 0 (Row0, Col0) needs to coincide with h/v_counter = 0
      //
      // Row sequence is NR+2:
      //    NR-1, 0, 1, 2, ..., NR-1, 0, <idle during vsync>
      // (i.e. the first and last rows are read twice)
      // NR = V_ACTIVE
      //
      // Col sequence is NC+2:
      //    NC-1, 0, 1, 2, ..., NC-1, 0, <idle during hsync>
      // (i.e. the first and last cols are read twice)
      // NC = H_ACTIVE / 8
      //

      // Life reads are active for NC+2 cols and NR+2 rows compared to the video
      life_rd_active <= (h_counter_next < (NC + 2) * 8) && (v_counter_next < (NR + 2));

      // Life writes are active for NC cols and NR rows, but skewed by a couple of cycles
      life_wr_active <= (h_counter_next >= 3 * 8) && (h_counter_next < (NC + 3) * 8) && (v_counter_next < NR);

      // Increment on the 11 cycle, so address stable when next memory cycles start
      if (h_counter[2:1] == 2'b11) begin
         if (life_rd_active) begin
            // Generate the column part of the address
            if (h_counter[11:3] == NC)
              life_col_addr <= NC - 1;
            else if (life_col_addr == NC - 1)
              life_col_addr <= 0;
            else
              life_col_addr <= life_col_addr + 1'b1;
            // Generate the row part of the address
            if (h_counter[11:3] == NC)
              if (v_counter == NR)
                life_row_addr <= (NR - 1) * NC;
              else if (life_row_addr == (NR - 1) * NC)
                life_row_addr <= 0;
              else
                life_row_addr <= life_row_addr + NC;
         end
      end

      // Skew life_wr_addr by the byte delay through the life pipeline, plus a whole row
      if (h_counter[2:1] == 2'b11)
        if (life_rd_addr < WR_OFFSET)
          {life_wr_addr, life_wr_addr0} <= {life_wr_addr0, life_rd_addr + life_wr_wrap};
        else
          {life_wr_addr, life_wr_addr0} <= {life_wr_addr0, life_rd_addr - life_wr_offset};


      // Life pipeline clocked for the overlap of read and write (to flush the
      life_clken <= (h_counter[2:1] == 2'b10) && (life_rd_active || life_wr_active);

      // Synchronize running changes with the final write of the playfield
      if (life_wr_addr == NC * NR - 1)
        running <= ctrl_running;

   end

   // =================================================
   // RAM Address / Control Generation
   // =================================================

   always @(posedge clk_pixel) begin

      // Synchronize the RD/WR Pending signals from the 1MHz Domain
      if (h_counter[2:1] == 2'b01) begin
         cpu_rd_pending1 <= cpu_rd_pending;
         cpu_wr_pending1 <= cpu_wr_pending;
      end

      // --------------------------------------------------
      // Memory Cycle 1
      //     h_counter == 2'b00 and 2'b01
      //
      // used for:
      //     life (i.e. display) reads
      // --------------------------------------------------

      if (h_counter[2:1] == 2'b00) begin
         if (life_rd_active) begin
            // Start Life Engine Read Cycle
            ram_cel  <= 1'b0;
            ram_oel  <= 1'b0;
            write_n  <= 1'b1;
            ram_addr <= life_rd_addr;
         end else begin
            // Idle Cycle
            ram_cel  <= 1'b1;
            ram_oel  <= 1'b1;
            write_n  <= 1'b1;
            ram_addr <= 19'h7FFFF;
         end
      end

      if (life_rd_active) begin
         if (h_counter[2:1] == 2'b10) begin
            // Capture Data from Life Read Cycle for life engine (during active part of line active)
            life_rd_data <= ram_data;
         end
      end

      if (h_counter[2:1] == 2'b10) begin
         // Capture Data from Life Read Cycle for display
         display_dout <= ram_data;
      end else begin
         // Shift two pixels regardless, this avoids right column display artifacts
         display_dout <= {display_dout[5:0], 2'b0};
      end

      // Compute the mask for the next write cycle (to prevent wrapping)
      //  (v_counter is 1 line ahead of the write address)
      //  (h_counter is 2 bytes ahead of the write address)
      if (h_counter[2:1] == 2'b01) begin
         if (ctrl_mask && v_counter == 1)
           // Top
           mask <= 8'h00;
         else if (ctrl_mask && v_counter == 0)
           // Bottom
           mask <= 8'h00;
         else if (ctrl_mask && h_counter[11:3] == 3)
           // Left
           mask <= 8'h7f;
         else if (ctrl_mask && h_counter[11:3] == 2)
           // Right
           mask <= 8'hfe;
         else
           // No masking
           mask <= 8'hff;
      end

      // --------------------------------------------------
      // Memory Cycle 2
      //     h_counter == 2'b10 and 2'b11
      //
      // used for:
      //     life writes (highest priority)
      //     beeb reads
      //     beeb writes (lowest priority)
      // --------------------------------------------------

      if (h_counter[2:1] == 2'b10) begin
         beeb_rd <= 1'b0;
         if (life_wr_active && running) begin
            // Start Life Engine Write Cyle
            ram_cel  <= 1'b0;
            ram_oel  <= 1'b1;
            ram_addr <= life_wr_addr;
            ram_din  <= ctrl_clear ? clear_wr_data : (life_wr_data & mask);
            write_n  <= 1'b0;
         end else if (cpu_rd_pending2 != cpu_rd_pending1) begin
            // Start Beeb Read Cyle
            ram_cel  <= 1'b0;
            ram_oel  <= 1'b0;
            ram_addr <= cpu_addr;
            write_n  <= 1'b1;
            cpu_rd_pending2 <= cpu_rd_pending1;
            beeb_rd  <= 1'b1; // delay reading of beeb data a cycle
         end else if (cpu_wr_pending2 != cpu_wr_pending1) begin
            // Start Beeb Write Cyle
            ram_cel  <= 1'b0;
            ram_oel  <= 1'b1;
            ram_addr <= cpu_addr;
            ram_din  <= cpu_wr_data;
            write_n  <= 1'b0;
            cpu_wr_pending2 <= cpu_wr_pending1;
         end else begin
            // Idle Cycle
            ram_cel  <= 1'b1;
            ram_oel  <= 1'b1;
            write_n  <= 1'b1;
            ram_addr <= 19'h7FFFF;
         end
      end

      // Capture Data from Beeb Read Cycle
      if (h_counter[2:1] == 2'b00 && beeb_rd) begin
         beeb_rd     <= 1'b0;
         cpu_rd_data <= ram_data;
      end

      // In all cases, de-assert write in the second half of the write cycle
      if (h_counter[2:1] == 2'b11) begin
         write_n <= 1'b1;
      end

   end

   // Actual write strobe is skewed by half a clock, so it is in the middle of the pair of cycles
   always @(negedge clk_pixel) begin
      ram_wel = write_n;
   end

   // Only drive the ram data bus when ram_wel is asserted
   assign ram_data = ram_wel ? 8'hZZ : ram_din;

   // =================================================
   // Data generator for clearing
   // =================================================

   always @(posedge clk_pixel) begin
      case (ctrl_clear_type)
        2'b01:
          clear_wr_data <= prbs0[7:0] & prbs1[7:0] & prbs2[7:0];
        2'b10:
          clear_wr_data <= prbs0[7:0] & prbs1[7:0];
        2'b11:
          clear_wr_data <= prbs0[7:0];
        default:
          clear_wr_data <= 8'h00;
      endcase
      // Generate two bits at a time
      prbs0 <= {prbs0[28:0], prbs0[27] ^ prbs0[30], prbs0[26] ^ prbs0[29]};
      prbs1 <= {prbs1[28:0], prbs1[27] ^ prbs1[30], prbs1[26] ^ prbs1[29]};
      prbs2 <= {prbs2[28:0], prbs2[27] ^ prbs2[30], prbs2[26] ^ prbs2[29]};
   end

   // =================================================
   // 1MHz Bus Interface
   // =================================================

   assign scaler_x_next = scaler_x_origin + {{(3+SFB){scaler_x_speed[7]}}, scaler_x_speed};
   assign scaler_y_next = scaler_y_origin + {{(3+SFB){scaler_y_speed[7]}}, scaler_y_speed};

   always @(negedge clke or negedge rst_n) begin
      if (!rst_n) begin
         selected <= 1'b0;
      end else begin
         if (!pgfc_n && bus_addr == 8'hFE && !rnw)
           cpu_addr[15:8] <= bus_data;
         if (!pgfc_n && bus_addr == 8'hA0 && !rnw)
           control <= bus_data;
         if (!pgfc_n && bus_addr == 8'hA4 && !rnw)
           scaler_x_origin[7:0] <= bus_data;
         if (!pgfc_n && bus_addr == 8'hA5 && !rnw)
           scaler_x_origin[10+SFB:8] <= bus_data[2+SFB:0];
         if (!pgfc_n && bus_addr == 8'hA6 && !rnw)
           scaler_y_origin[7:0] <= bus_data;
         if (!pgfc_n && bus_addr == 8'hA7 && !rnw)
           scaler_y_origin[10+SFB:8] <= bus_data[2+SFB:0];
         if (!pgfc_n && bus_addr == 8'hA8 && !rnw)
           scaler_zoom <= bus_data[2:0];
         if (!pgfc_n && bus_addr == 8'hA9 && !rnw)
           scaler_x_speed <= bus_data;
         if (!pgfc_n && bus_addr == 8'hAA && !rnw)
           scaler_y_speed <= bus_data;
         if (!pgfc_n && bus_addr == 8'hFF && !rnw) begin
            cpu_addr[18:16] <= bus_data[2:0];
            if (bus_data[7:3] == 5'b11001)
              selected <= 1'b1;
            else
              selected <= 1'b0;
         end
         if (selected && !pgfd_n && !rnw) begin
            cpu_wr_pending <= !cpu_wr_pending;
            cpu_wr_data <= bus_data;
         end
         last_vsync1 <= vsync;
         last_vsync2 <= last_vsync1;
         if (last_vsync1 && !last_vsync2) begin
            // Auto-pan scaler_x_origin, correctly wrapping
            if (scaler_x_next < H_ACTIVE_FP)
              scaler_x_origin <= scaler_x_next;
            else if (scaler_x_speed[7])
              scaler_x_origin <= scaler_x_next + H_ACTIVE_FP;
            else
              scaler_x_origin <= scaler_x_next - H_ACTIVE_FP;
            // Auto-pan scaler_y_origin, correctly wrapping
            if (scaler_y_next < V_ACTIVE_FP)
              scaler_y_origin <= scaler_y_next;
            else if (scaler_y_speed[7])
              scaler_y_origin <= scaler_y_next + V_ACTIVE_FP;
            else
              scaler_y_origin <= scaler_y_next - V_ACTIVE_FP;
         end
      end
   end

   always @(posedge clke) begin
      if (selected && !pgfd_n)
        cpu_addr[7:0] <= bus_addr;
      if (selected && !pgfd_n && rnw)
        cpu_rd_pending <= !cpu_rd_pending;
   end

   assign bus_data = (!pgfc_n && bus_addr == 8'hFF && rnw) ? {selected, 4'b0000, cpu_addr[18:16]}  :
                     (!pgfc_n && bus_addr == 8'hFE && rnw) ?  cpu_addr[15:8]                       :
                     (!pgfc_n && bus_addr == 8'hA0 && rnw) ?  control                              :
                     (!pgfc_n && bus_addr == 8'hA1 && rnw) ?  status                               :
                     (!pgfc_n && bus_addr == 8'hA2 && rnw) ?  width_div_8                          :
                     (!pgfc_n && bus_addr == 8'hA3 && rnw) ?  height_div_8                         :
                     (!pgfc_n && bus_addr == 8'hA4 && rnw) ?  scaler_x_origin[7:0]                 :
                     (!pgfc_n && bus_addr == 8'hA5 && rnw) ?  scaler_x_origin[10+SFB:8]            :
                     (!pgfc_n && bus_addr == 8'hA6 && rnw) ?  scaler_y_origin[7:0]                 :
                     (!pgfc_n && bus_addr == 8'hA7 && rnw) ?  scaler_y_origin[10+SFB:8]            :
                     (!pgfc_n && bus_addr == 8'hA8 && rnw) ?  scaler_zoom                          :
                     (!pgfc_n && bus_addr == 8'hA9 && rnw) ?  scaler_x_speed                       :
                     (!pgfc_n && bus_addr == 8'hAA && rnw) ?  scaler_y_speed                       :
                     (!pgfd_n && selected          && rnw) ?  cpu_rd_data                          :
                     8'hZZ;

   assign bus_data_oel = !(
                           (clke && !pgfc_n && (bus_addr[7:4] == 4'hA || bus_addr == 8'hFE || bus_addr == 8'hFF)) ||
                           (clke && !pgfd_n && selected));

   assign bus_data_dir = rnw;

   // =================================================
   // 1MHZ Bus FPGA Adapter Specific Stuff
   // =================================================

   assign irq          = 1'b0;
   assign nmi          = 1'b0;

   assign pmod0        = {blue , red};
   assign pmod1        = {2'b00, vsync, hsync, green};
   assign pmod2        = 4'b1111;

   assign led          = sw1 | sw2;

   assign dac_cs_n     = 1'b1;
   assign dac_sck      = 1'b1;
   assign dac_sdi      = 1'b1;
   assign dac_ldac_n   = 1'b1;

endmodule

// =================================================
// Life Pipeline (now byte wide with clock enable)
// =================================================

module life_pipeline
  (
   clk,
   clken,
   read_data,
   write_data
   );

   input clk;
   input clken;
   input [7:0] read_data;
   output reg [7:0] write_data;

   // N = the number of cycles the pipeline is active for per line
   //     (the should be NC + 2 + LPD)
   //
   parameter    N = 0;

   // D internally is the length of the row delay element
   // The -3 is because of the 3 bytes in a,b,c
   localparam   D = (N-3)*8;

   reg [23:0]   a;
   reg [23:0]   b;
   reg [16:0]   c;
   wire [7:0]   d;

   reg [D-1:0]  row1;
   reg [D-1:0]  row2;

   genvar       i;

   generate
      for (i = 0; i < 8; i = i + 1) begin : b_cell
         life_cell c
               (.top(a[i+9:i+7]),
                .middle(b[i+9:i+7]),
                .bottom(c[i+9:i+7]),
                .result(d[i]));
         end
   endgenerate

   always @(posedge clk)
     if (clken) begin
        a          <= {a[15:0], read_data};
        row1       <= {row1[D-9:0], a[23:16]};
        b          <= {b[15:0], row1[D-1:D-8]};
        row2       <= {row2[D-9:0], b[23:16]};
        c          <= {c[8:0], row2[D-1:D-8]};
        write_data <= d;
     end

endmodule

module life_cell
  (
   top,
   middle,
   bottom,
   result
   );
   input [2:0] top;
   input [2:0] middle;
   input [2:0] bottom;
   output result;

   function [2:0] partial_sum;
      input [3:0] partial;
      case (partial)
        // 1-cell
        4'b0001 : partial_sum = 3'b001;
        4'b0010 : partial_sum = 3'b001;
        4'b0100 : partial_sum = 3'b001;
        4'b1000 : partial_sum = 3'b001;
        // 2-cells
        4'b1100 : partial_sum = 3'b010;
        4'b1001 : partial_sum = 3'b010;
        4'b0011 : partial_sum = 3'b010;
        4'b0110 : partial_sum = 3'b010;
        4'b0101 : partial_sum = 3'b010;
        4'b1010 : partial_sum = 3'b010;
        // 3-cells
        4'b1110 : partial_sum = 3'b011;
        4'b1101 : partial_sum = 3'b011;
        4'b1011 : partial_sum = 3'b011;
        4'b0111 : partial_sum = 3'b011;
        // 4-cells
        4'b1111 : partial_sum = 3'b100;
        // 0 cells
        default : partial_sum = 3'b000;
      endcase
   endfunction

   wire [2:0] p1 = partial_sum({   top, middle[2]});
   wire [2:0] p2 = partial_sum({bottom, middle[0]});
   wire [3:0] sum = p1 + p2;

   assign result = (sum == 2) ? middle[1] :
                   (sum == 3) ? 1'b1      :
                   1'b0 ;
endmodule
