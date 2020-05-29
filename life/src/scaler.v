module scaler
  (
   // From the life engine
   clk_in,
   life_d,
   life_active,
   life_h_counter,
   life_v_counter,

   // Parameters definging window on the life playfield
   scaler_border,
   scaler_x_origin,
   scaler_y_origin,
   scaler_zoom,

   // Video output
   clk_out,
   clken_out,
   hsync,
   vsync,
   pixel
   );

   input           clk_in;
   input [1:0]     life_d;
   input           life_active;
   input [11:0]    life_h_counter;
   input [10:0]    life_v_counter;

   input           scaler_border;
   input [10:0]    scaler_x_origin;
   input [10:0]    scaler_y_origin;
   input [2:0]     scaler_zoom;

   input           clk_out;
   input           clken_out;
   output reg      vsync = 0;
   output reg      hsync = 0;
   output reg      pixel = 0;

   // These define the size of the life playfield
   parameter H_LIFE = 0;
   parameter V_LIFE = 0;

   // These control the video timings of the
   parameter H_ACTIVE = 0;
   parameter H_SYNC_START = 0;
   parameter H_SYNC_END = 0;
   parameter H_TOTAL = 0;

   parameter V_ACTIVE = 0;
   parameter V_SYNC_START = 0;
   parameter V_SYNC_END = 0;
   parameter V_TOTAL = 0;


   // Scaler parameters
   reg [8:0]           scaler_w = 0;
   reg [9:0]           scaler_h = 0;
   reg [10:0]          scaler_x_lo_tmp = 0;
   reg [10:0]          scaler_x_hi_tmp = 0;
   reg [10:0]          scaler_y_lo_tmp = 0;
   reg [10:0]          scaler_x_lo = 0;
   reg [10:0]          scaler_x_hi = 0;
   reg [10:0]          scaler_y_lo = 0;
   reg [3:0]           scaler_inc_x_mask = 0;
   reg [3:0]           scaler_inc_y_mask = 1; // To prevent Xilinx warning

   // Scaler write pipeline
   reg                 scaler_active0 = 0;
   reg                 scaler_active1 = 0;
   reg                 scaler_active2 = 0;
   reg [9:0]           scaler_y_count0 = 0;
   reg                 scaler_rst0 = 0;
   reg                 scaler_rst1 = 0;
   reg                 scaler_x_in_range0 = 0;
   reg                 scaler_wr1 = 0;
   reg                 scaler_wr2 = 0;
   reg                 scaler_wr3 = 0;
   reg [1:0]           scaler_bdr0 = 0;
   reg [1:0]           scaler_bdr1 = 0;
   reg [1:0]           scaler_bdr2 = 0;
   reg [1:0]           scaler_odd_din3 = 0;
   reg [1:0]           scaler_eve_din3 = 0;

   reg [8:0]           scaler_wr_addr_x2 = 0;
   reg [17:0]          scaler_wr_addr_y2 = 0;
   reg [17:0]          scaler_wr_addr3 = 0;
   reg                 scaler_din_last = 0;



   // Scaler RAM
   reg [1:0]           scaler_ram[0:262143];
   reg                 scaler_bank = 0;

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


   // Video Timing
   reg [10:0]          h_counter_next = 0;
   reg [10:0]          h_counter = 0;
   reg [10:0]          v_counter_next = 0;
   reg [10:0]          v_counter = 0;
   reg                 active = 0;
   reg                 blank = 0;
   reg [3:0]           hsync0 = 0;
   reg [3:0]           vsync0 = 0;
   reg [3:0]           blank0 = 0;

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

   always @(posedge clk_in) begin

      case (scaler_zoom)
        3'b100:
          begin
             scaler_w <= H_ACTIVE / 16; // units of two-pixels
             scaler_h <= V_ACTIVE / 8;
             scaler_inc_x_mask <= 4'b0111;
             scaler_inc_y_mask <= 4'b0111;
          end
        3'b011:
          begin
             scaler_w <= H_ACTIVE / 8; // units of two-pixels
             scaler_h <= V_ACTIVE / 4;
             scaler_inc_x_mask <= 4'b0011;
             scaler_inc_y_mask <= 4'b0011;
          end
        3'b010:
          begin
             scaler_w <= H_ACTIVE / 4;  // units of two-pixels
             scaler_h <= V_ACTIVE / 2;
             scaler_inc_x_mask <= 4'b0001;
             scaler_inc_y_mask <= 4'b0001;
          end
        default:
          begin
             scaler_w <= H_ACTIVE / 2;  // units of two-pixels
             scaler_h <= V_ACTIVE;
             scaler_inc_x_mask <= 4'b0000;
             scaler_inc_y_mask <= 4'b0000;
          end
      endcase

      // Calculate x,y of top left corner (only allow changes when scaler not running)
      if (scaler_y_count0 == 0) begin
         // Ignore the fractional bits
         scaler_x_lo_tmp <= scaler_x_origin[10:0] - scaler_w;
         scaler_x_hi_tmp <= scaler_x_origin[10:0] + scaler_w;
         scaler_y_lo_tmp <= scaler_y_origin[10:0] - scaler_h[9:1];
      end

      // Correct for wrapping
      if (scaler_x_lo_tmp < H_LIFE)
        scaler_x_lo <= scaler_x_lo_tmp;
      else
        scaler_x_lo <= scaler_x_lo_tmp + H_LIFE;
      if (scaler_x_hi_tmp <= H_LIFE)
        scaler_x_hi <= scaler_x_hi_tmp;
      else
        scaler_x_hi <= scaler_x_hi_tmp - H_LIFE;
      if (scaler_y_lo_tmp < V_LIFE)
        scaler_y_lo <= scaler_y_lo_tmp;
      else
        scaler_y_lo <= scaler_y_lo_tmp + V_LIFE;

   end


   // *************************************************************************
   // *** Write Pipeline
   // *************************************************************************

   always @(posedge clk_in) begin

      // *************************************************************************
      // *** Write Pipeline stage 0 (only this stage uses h_counter/v_counter and active)
      // *************************************************************************

      // Double buffer bank selection
      if (life_h_counter == 0 && life_v_counter == 0) begin
        if (scaler_zoom < 3'b010) begin
          scaler_bank <= 1'b0;
        end else begin
          scaler_bank <= !scaler_bank;
        end
      end

      // When to start capturing
      scaler_rst0 <= 1'b0;
      if (life_active) begin
         if (scaler_x_lo < scaler_x_hi) begin
            // The window doesn't cross the L/R boundary
            if (life_h_counter == {1'b0, scaler_x_lo[10:1], 1'b0}) begin
               if (life_v_counter == scaler_y_lo) begin
                  scaler_rst0 <= 1'b1;
                  scaler_y_count0 <= scaler_h;
               end else if (|scaler_y_count0) begin
                  scaler_y_count0 <= scaler_y_count0 - 1'b1;
               end
            end
         end else begin
            if (life_h_counter == 0) begin
               if (life_v_counter == scaler_y_lo) begin
                  scaler_rst0 <= 1'b1;
                  scaler_y_count0 <= scaler_h;
               end else if (|scaler_y_count0) begin
                  scaler_y_count0 <= scaler_y_count0 - 1'b1;
               end
            end
         end
      end

      if (scaler_x_lo < scaler_x_hi) begin
         scaler_x_in_range0 <= (life_h_counter >= {1'b0, scaler_x_lo[10:1], 1'b0}) && (life_h_counter < {1'b0, scaler_x_hi[10:1], 1'b0});
      end else begin
         scaler_x_in_range0 <= (life_h_counter >= {1'b0, scaler_x_lo[10:1], 1'b0}) || (life_h_counter < {1'b0, scaler_x_hi[10:1], 1'b0});
      end

      scaler_bdr0 <= (life_v_counter == 0 || life_v_counter == V_LIFE - 1) ? {2{scaler_border}} : 2'b00;
      scaler_active0     <= life_active;

      // *************************************************************************
      // *** Write Pipeline stage 1, uses outputs of stage 0
      // *************************************************************************

      scaler_wr1  <= scaler_x_in_range0 && |scaler_y_count0 && scaler_active0;
      scaler_rst1 <= scaler_rst0;
      scaler_bdr1 <= scaler_bdr0;
      scaler_active1     <= scaler_active0;

      // *************************************************************************
      // *** Write Pipeline stage 2, uses outputs of stage 1
      // *************************************************************************

      // Scaler write address
      if (scaler_x_lo < scaler_x_hi) begin
         // The window doesn't cross the L/R boundary
         if (scaler_rst1) begin
            scaler_wr_addr_x2 <= 0;
            scaler_wr_addr_y2 <= {scaler_bank, 17'b0};
         end else if (scaler_wr1) begin
            if (scaler_wr_addr_x2 >= scaler_w - 1'b1) begin
               scaler_wr_addr_x2 <= 0;
            end else begin
               scaler_wr_addr_x2 <= scaler_wr_addr_x2 + 1'b1;
            end
            if (scaler_wr_addr_x2 + 1'b1 == scaler_w) begin
               scaler_wr_addr_y2 <= scaler_wr_addr_y2 + scaler_w;
            end
         end
      end else begin
         // The window crosses the L/R boundary
         if (scaler_rst1) begin
            scaler_wr_addr_x2 <= scaler_w - scaler_x_hi[9:1];
            scaler_wr_addr_y2 <= {scaler_bank, 17'b0};
         end else if (scaler_wr1) begin
            if (scaler_wr_addr_x2 >= scaler_w - 1'b1) begin
               scaler_wr_addr_x2 <= 0;
            end else begin
               scaler_wr_addr_x2 <= scaler_wr_addr_x2 + 1'b1;
            end
            if (scaler_wr_addr_x2 + 1'b1 == scaler_w - scaler_x_hi[10:1]) begin
               scaler_wr_addr_y2 <= scaler_wr_addr_y2 + scaler_w;
            end
         end
      end

      // Add in the the L/R boundart
      if (scaler_x_lo[0]) begin
         if (scaler_active1 && !scaler_active2)
           scaler_bdr2 <= scaler_bdr1 | {scaler_border, 1'b0};
         else if (scaler_active1 && !scaler_active0)
           scaler_bdr2 <= scaler_bdr1 | {1'b0, scaler_border};
         else
           scaler_bdr2 <= scaler_bdr1;
      end else begin
         if (scaler_active1 && !scaler_active2)
           scaler_bdr2 <= scaler_bdr1 | {2{scaler_border}};
         else
           scaler_bdr2 <= scaler_bdr1;
      end

      scaler_wr2  <= scaler_wr1;
      scaler_active2     <= scaler_active1;

      // *************************************************************************
      // *** Write Pipeline stage 3, uses outputs of stage 2
      // *************************************************************************

      // Capture the right pixel in the previous sample. This happens to work correctly
      // even at the wrap point, because extras reads of the last/first columns are
      // inserted before/after the active line so the life engine works properly.
      scaler_din_last <= life_d[0];

      // At odd pixel offets, the two output pixels need to be taken from adjacent samples
      scaler_odd_din3 <= {scaler_din_last, life_d[1]} | scaler_bdr2;

      // At even pixel offsets, the two output pixels in the display sample are correctly aligned
      scaler_eve_din3 <= life_d[1:0] | scaler_bdr2;

      scaler_wr_addr3 <= scaler_wr_addr_y2 + scaler_wr_addr_x2;
      scaler_wr3      <= scaler_wr2;

      // *************************************************************************
      // *** Scaler RAM Write
      // *************************************************************************
      if (scaler_wr3)
        scaler_ram[scaler_wr_addr3] <= scaler_x_lo[0] ? scaler_eve_din3 : scaler_odd_din3;

   end


   // *************************************************************************
   // *** Scaler Read Pipeline
   // *************************************************************************

   always @(posedge clk_out) begin
      if (clken_out) begin

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
   end

   // =================================================
   // Video Timing
   // =================================================

   always @(h_counter or v_counter) begin
      if (h_counter == H_TOTAL - 1'b1) begin
         h_counter_next = 0;
         if (v_counter == V_TOTAL - 1)
           v_counter_next = 0;
         else
           v_counter_next = v_counter + 1'b1;
      end else begin
         v_counter_next = v_counter;
         h_counter_next = h_counter + 1'b1;
      end
   end

   always @(posedge clk_out) begin
      if (clken_out) begin
         h_counter <= h_counter_next;
         v_counter <= v_counter_next;
         active    <= h_counter_next < H_ACTIVE && v_counter_next < V_ACTIVE;
         // TODO: the pipelining needs rework here
         { hsync,  hsync0} <= {hsync0, (h_counter >= H_SYNC_START && h_counter < H_SYNC_END)};
         { vsync,  vsync0} <= {vsync0, (v_counter >= V_SYNC_START && v_counter < V_SYNC_END)};
         { blank,  blank0} <= {blank0, (h_counter >= H_ACTIVE || v_counter >= V_ACTIVE)};
         pixel <= scaler_dout & !blank;
      end
   end

endmodule
