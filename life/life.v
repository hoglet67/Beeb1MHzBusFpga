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
   localparam H_ACTIVE      = 1920;
   localparam H_SYNC_START  = H_ACTIVE + 88;
   localparam H_SYNC_END    = H_SYNC_START + 44;
   localparam H_TOTAL       = H_SYNC_END + 148;

   // V_TOTAL = 1125
   localparam V_ACTIVE      = 1080;
   localparam V_SYNC_START  = V_ACTIVE + 4;
   localparam V_SYNC_END    = V_SYNC_START + 5;
   localparam V_TOTAL       = V_SYNC_END + 36;

   // DCM
   localparam DCM_M         = 3;
   localparam DCM_D         = 2;

`endif

`ifdef VGA_1600_1200

   // H_TOTAL = 2160
   localparam H_ACTIVE      = 1600;
   localparam H_SYNC_START  = H_ACTIVE + 64;
   localparam H_SYNC_END    = H_SYNC_START + 192;
   localparam H_TOTAL       = H_SYNC_END + 304;

   // V_TOTAL = 1250
   localparam V_ACTIVE      = 1200;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 3;
   localparam V_TOTAL       = V_SYNC_END + 46;

   // DCM
   localparam DCM_M         = 13;
   localparam DCM_D         = 8;

`endif

`ifdef VGA_800_600

   // H_TOTAL = 1056
   localparam H_ACTIVE      = 800;
   localparam H_SYNC_START  = H_ACTIVE + 40;
   localparam H_SYNC_END    = H_SYNC_START + 128;
   localparam H_TOTAL       = H_SYNC_END + 88;

   // V_TOTAL = 628
   localparam V_ACTIVE      = 600;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 4;
   localparam V_TOTAL       = V_SYNC_END + 23;

   // DCM
   localparam DCM_M         = 4;
   localparam DCM_D         = 10;

`endif

   // Row width, excluding neighbour cells
   localparam ROW_WIDTH     = H_ACTIVE - 4;

   // Write Offset (effectively the pipeline depth, in 8-pixel units
   localparam WR_OFFSET     = (H_ACTIVE / 8) + 4;

   // Write Offset when wrapping
   localparam WR_WRAP       = (H_ACTIVE * V_ACTIVE / 8) - WR_OFFSET;

   // Video Pipeline Delay (inc SRAM) in clk_pixel cycles
   localparam VPD           = 2;

   // Life Pipeline Delay in pixels (must be >= 8)
   localparam LPD           = 15;

   wire                clk0;
   wire                clk_pixel;
   wire                clk_pixel_n;
   reg [11:0]          h_counter_next;
   reg [11:0]          h_counter;
   reg [10:0]          v_counter_next;
   reg [10:0]          v_counter;

   wire [3:0]          red;
   wire [3:0]          green;
   wire [3:0]          blue;
   reg                 active;
   reg                 hsync;
   reg                 vsync;
   reg                 blank;
   reg                 border;
   reg [VPD:0]         hsync0; // +1 delay, to compensate for the DDR registers on RGB
   reg [VPD:0]         vsync0; // +1 delay, to compensate for the DDR registers on RGB
   reg [VPD-1:0]       blank0;
   reg [VPD-1:0]       border0;
   reg [7:0]           mask;
   wire [11:0]         rgb;
   reg [11:0]          rgb0;
   reg [11:0]          rgb1;

   reg [2:0]           scaler_zoom = 0; // no zoom
   reg [10:0]          scaler_x_origin = H_ACTIVE / 2;
   reg [10:0]          scaler_y_origin = V_ACTIVE / 2;

   reg [17:0]          scaler_rd_addr_x;
   reg [17:0]          scaler_rd_addr_y;
   reg [17:0]          scaler_rd_addr;
   reg [17:0]          scaler_wr_addr;
   reg [1:0]           scaler_ram[0:262143];
   reg [8:0]           scaler_line;
   reg [10:0]          scaler_x_lo;
   reg [10:0]          scaler_x_hi;
   reg [10:0]          scaler_y_lo;
   reg [10:0]          scaler_y_hi;
   reg [3:0]           scaler_inc_x_mask;
   reg [3:0]           scaler_inc_y_mask;
   reg                 scaler_wr_rst;
   reg                 scaler_wr;
   reg [2:0]           scaler_din;
   reg [1:0]           scaler_dout2;
   reg                 scaler_dout;
   reg                 scaler_rd_rst_x;
   reg                 scaler_rd_rst_y;
   reg                 scaler_rd_inc_x;
   reg                 scaler_rd_inc_y;
   reg                 scaler_pix_sel0;
   reg                 scaler_pix_sel1;

   reg [18:0]          life_rd_addr;
   reg [18:0]          life_wr_addr;
   wire [18:0]         life_wr_offset = WR_OFFSET;
   wire [18:0]         life_wr_wrap = WR_WRAP;
   reg [7:0]           life_dout;
   reg [7:0]           display_dout;

   reg                 beeb_rd;
   reg                 write_n;

   reg [7:0]           ram_din;

   reg                 n11, n12, n13, n14;
   reg                 n21, n22, n23, n24;
   reg                 n31, n32, n33, n34;

   reg                 n22_last;
   reg                 n23_last;

   reg                 running;

   reg [3:0]           neighbour_count1;
   reg [3:0]           neighbour_count0;
   reg [ROW_WIDTH-1:0] row1;
   reg [ROW_WIDTH-1:0] row2;
   reg [1:0]           nextgen;
   reg [LPD-1:0]       nextgen8;

   reg                 selected;
   reg [18:0]          cpu_addr;
   reg [7:0]           cpu_wr_data;
   reg                 cpu_wr_pending;
   reg                 cpu_wr_pending1;
   reg                 cpu_wr_pending2;
   reg [7:0]           cpu_rd_data;
   reg                 cpu_rd_pending;
   reg                 cpu_rd_pending1;
   reg                 cpu_rd_pending2;
   reg [7:0]           control = 8'h80;

   wire                ctrl_running     = control[7];
   wire                ctrl_mask        = control[6];
   wire                ctrl_clear       = control[5];
   wire [1:0]          ctrl_clear_type  = control[1:0];

   wire [7:0]          status = { running, vsync, 6'b000000};

   wire [7:0]          width_div_8 = H_ACTIVE / 8;
   wire [7:0]          height_div_8 = V_ACTIVE / 8;

   reg [7:0]           clear_wr_data;
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
   // Scaler
   // =================================================


   always @(posedge clk_pixel) begin

      // TODO:
      //    - this all assumes a 1600x1200 display
      //    - I think the contants could be derived from H/V_ACTIVE / zoom factor
      //    - the verilog is a bit repetitive

      // No attempt had been made to control the latency through the scaler
      // so it's possible that the window will be a few pixels out horizonal in absolute accuracy

      // Zoom = 0; window is 1600x1200 pixels (scaler bypassed)
      // Zoom = 1; window is 800x600 pixels
      // Zoom = 2; window is 400x300 pixels
      // Zoom = 3; window is 200x150 pixels
      // Zoom = 4; window is 100x75 pixels

      case (scaler_zoom)
        3'b100:
          begin
             // For writes, centre/crop the window
             if (scaler_x_origin < 50) begin
                scaler_x_lo <= 0;
                scaler_x_hi <= 100;
             end else if (scaler_x_origin >= H_ACTIVE - 50) begin
                scaler_x_lo <= H_ACTIVE - 100;
                scaler_x_hi <= H_ACTIVE;
             end else begin
                scaler_x_lo <= scaler_x_origin - 6'd50;
                scaler_x_hi <= scaler_x_origin + 6'd50;
             end
             if (scaler_y_origin < 37) begin
                scaler_y_lo <= 0;
                scaler_y_hi <= 75;
             end else if (scaler_y_origin >= V_ACTIVE - 38) begin
                scaler_y_lo <= V_ACTIVE - 75;
                scaler_y_hi <= V_ACTIVE;
             end else begin
                scaler_y_lo <= scaler_y_origin - 6'd37;
                scaler_y_hi <= scaler_y_origin + 6'd38;
             end
             // For reads
             scaler_line <= 9'd50;
             scaler_inc_x_mask <= 4'b1110;
             scaler_inc_y_mask <= 4'b1111;
          end
        3'b011:
          begin
             // For writes, centre/crop the window
             if (scaler_x_origin < 100) begin
                scaler_x_lo <= 0;
                scaler_x_hi <= 200;
             end else if (scaler_x_origin >= H_ACTIVE - 100) begin
                scaler_x_lo <= H_ACTIVE - 200;
                scaler_x_hi <= H_ACTIVE;
             end else begin
                scaler_x_lo <= scaler_x_origin - 7'd100;
                scaler_x_hi <= scaler_x_origin + 7'd100;
             end
             if (scaler_y_origin < 75) begin
                scaler_y_lo <= 0;
                scaler_y_hi <= 150;
             end else if (scaler_y_origin >= V_ACTIVE - 75) begin
                scaler_y_lo <= V_ACTIVE - 150;
                scaler_y_hi <= V_ACTIVE;
             end else begin
                scaler_y_lo <= scaler_y_origin - 7'd75;
                scaler_y_hi <= scaler_y_origin + 7'd75;
             end
             // For reads
             scaler_line <= 9'd100;
             scaler_inc_x_mask <= 4'b0110;
             scaler_inc_y_mask <= 4'b0111;
          end
        3'b010:
          begin
             // For reads
             // For writes, centre/crop the window
             if (scaler_x_origin < 200) begin
                scaler_x_lo <= 0;
                scaler_x_hi <= 400;
             end else if (scaler_x_origin >= H_ACTIVE - 200) begin
                scaler_x_lo <= H_ACTIVE - 400;
                scaler_x_hi <= H_ACTIVE;
             end else begin
                scaler_x_lo <= scaler_x_origin - 8'd200;
                scaler_x_hi <= scaler_x_origin + 8'd200;
             end
             if (scaler_y_origin < 150) begin
                scaler_y_lo <= 0;
                scaler_y_hi <= 300;
             end else if (scaler_y_origin >= V_ACTIVE - 150) begin
                scaler_y_lo <= V_ACTIVE - 300;
                scaler_y_hi <= V_ACTIVE;
             end else begin
                scaler_y_lo <= scaler_y_origin - 8'd150;
                scaler_y_hi <= scaler_y_origin + 8'd150;
             end
             scaler_line <= 9'd200;
             scaler_inc_x_mask <= 4'b0010;
             scaler_inc_y_mask <= 4'b0011;
          end
        default:
          begin
             // For writes, centre/crop the window
             if (scaler_x_origin < 400) begin
                scaler_x_lo <= 0;
                scaler_x_hi <= 800;
             end else if (scaler_x_origin >= H_ACTIVE - 400) begin
                scaler_x_lo <= H_ACTIVE - 800;
                scaler_x_hi <= H_ACTIVE;
             end else begin
                scaler_x_lo <= scaler_x_origin - 9'd400;
                scaler_x_hi <= scaler_x_origin + 9'd400;
             end
             if (scaler_y_origin < 300) begin
                scaler_y_lo <= 0;
                scaler_y_hi <= 600;
             end else if (scaler_y_origin >= V_ACTIVE - 300) begin
                scaler_y_lo <= V_ACTIVE - 600;
                scaler_y_hi <= V_ACTIVE;
             end else begin
                scaler_y_lo <= scaler_y_origin - 9'd300;
                scaler_y_hi <= scaler_y_origin + 9'd300;
             end
             // For reads
             scaler_line <= 9'd400;
             scaler_inc_x_mask <= 4'b0000;
             scaler_inc_y_mask <= 4'b0001;
          end
      endcase

      // When to reset the scaler wr address
      scaler_wr_rst <= h_counter == {1'b0 & scaler_x_lo[10:1], 1'b0} &&
                       v_counter == scaler_y_lo;

      // When to write/increment the scaler wr address
      scaler_wr <= h_counter >= {scaler_x_lo[10:1], 1'b0} && h_counter < {1'b0, scaler_x_hi[10:1], 1'b0} &&
                   v_counter >= scaler_y_lo && v_counter < scaler_y_hi;

      // Scaler write address
      if (scaler_wr_rst)
        scaler_wr_addr <= 0;
      else if (scaler_wr)
        scaler_wr_addr <= scaler_wr_addr + 1'b1;

      // Capture 3 pixels
      scaler_din <= {scaler_din[0], display_dout[7:6]};

      // Scaler write
      if (scaler_wr)
        scaler_ram[scaler_wr_addr] <= scaler_x_lo[0] ? scaler_din[1:0] : scaler_din[2:1];

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
      if (scaler_rd_rst_y)
        scaler_rd_addr_y <= 0;
      else if (scaler_rd_inc_y)
        scaler_rd_addr_y <= scaler_rd_addr_y + scaler_line;

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
   // Life
   // =================================================

   always @(posedge clk_pixel) begin

      if (active) begin
         n34 <= life_dout[6];
         n33 <= life_dout[7];
         n32 <= n34;
         n31 <= n33;
         row2 <= {row2[ROW_WIDTH-3:0], n31, n32};
         n24 <= row2[ROW_WIDTH-2];
         n23 <= row2[ROW_WIDTH-1];
         n22 <= n24;
         n21 <= n23;
         row1 <= {row1[ROW_WIDTH-3:0], n21, n22};
         n14 <= row1[ROW_WIDTH-2];
         n13 <= row1[ROW_WIDTH-1];
         n12 <= n14;
         n11 <= n13;
         neighbour_count1 <= n11 + n12 + n13 +
                             n21       + n23 +
                             n31 + n32 + n33;
         neighbour_count0 <= n12 + n13 + n14 +
                             n22       + n24 +
                             n32 + n33 + n34;
         n22_last <= n22;
         n23_last <= n23;

         // Using n22_last here as neighbour_count1 is pipelined
         nextgen[1] <= (neighbour_count1 == 3) || (n22_last && (neighbour_count1 == 2));

         // Using n23_last here as neighbour_count0 is pipelined
         nextgen[0] <= (neighbour_count0 == 3) || (n23_last && (neighbour_count0 == 2));

         // Accumulate 8 pixels, and delay to a multiple of 8 pixels
         nextgen8 <= {nextgen8[LPD-3:0], nextgen};
      end
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

      // Update RAM Read Address
      if (h_counter == H_TOTAL - 2 && v_counter == V_TOTAL - 1) begin
         life_rd_addr <= 0;
         running <= ctrl_running;
      end else if (active && h_counter[2:1] == 2'b00) begin
         life_rd_addr <= life_rd_addr + 1'b1;
      end

      // Update RAM Write Address to an offset from the read address
      if (life_rd_addr < WR_OFFSET)
        life_wr_addr <= life_rd_addr + life_wr_wrap;
      else
        life_wr_addr <= life_rd_addr - life_wr_offset;

      // --------------------------------------------------
      // Memory Cycle 1
      //     h_counter == 2'b00 and 2'b01
      //
      // used for:
      //     life (i.e. display) reads
      // --------------------------------------------------

      if (h_counter[2:1] == 2'b00) begin
         if (active) begin
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

      if (active) begin
         if (h_counter[2:1] == 2'b10) begin
            // Capture Data from Life Read Cycle for life engine (during active part of line active)
            life_dout <= ram_data;
         end else begin
            // Shift two pixels (during active part of line active)
            life_dout <= {life_dout[5:0], 2'b0};
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
         if (active && running) begin
            // Start Life Engine Write Cyle
            ram_cel  <= 1'b0;
            ram_oel  <= 1'b1;
            ram_addr <= life_wr_addr;
            ram_din  <= ctrl_clear ? clear_wr_data : (nextgen8[LPD-1:LPD-8] & mask);
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
           scaler_x_origin[10:8] <= bus_data[2:0];
         if (!pgfc_n && bus_addr == 8'hA6 && !rnw)
           scaler_y_origin[7:0] <= bus_data;
         if (!pgfc_n && bus_addr == 8'hA7 && !rnw)
           scaler_y_origin[10:8] <= bus_data[2:0];
         if (!pgfc_n && bus_addr == 8'hA8 && !rnw)
           scaler_zoom <= bus_data[2:0];
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
                     (!pgfc_n && bus_addr == 8'hA5 && rnw) ? {5'b0, scaler_x_origin[10:8]}         :
                     (!pgfc_n && bus_addr == 8'hA6 && rnw) ?  scaler_y_origin[7:0]                 :
                     (!pgfc_n && bus_addr == 8'hA7 && rnw) ? {5'b0, scaler_y_origin[10:8]}         :
                     (!pgfc_n && bus_addr == 8'hA8 && rnw) ? {5'b0, scaler_zoom}                   :
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
