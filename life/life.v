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

   // Row width, excluding neighbour cells
   localparam ROW_WIDTH     = H_ACTIVE - 3;

   // Write Offset (effectively the pipeline depth, in 8-pixel units
   localparam WR_OFFSET     = (H_ACTIVE / 8) + 2;

   // Write Offset when wrapping
   localparam WR_WRAP       = (H_ACTIVE * V_ACTIVE / 8) - WR_OFFSET;

   wire              clk_pixel;
   reg [11:0]        h_counter;
   reg [7:0]         h_counter_offset;
   reg [10:0]        v_counter;
   reg [10:0]        v_counter_offset;

   reg [3:0]         red;
   reg [3:0]         green;
   reg [3:0]         blue;
   reg               hsync;
   reg               vsync;
   reg               active;
   reg               outline;

   reg [18:0]        ram_rd_addr;
   reg [18:0]        ram_wr_addr;
   reg [7:0]         ram_dout;
   reg [7:0]         ram_din;

   reg               n11;
   reg               n12;
   reg               n13;
   reg               n21;
   reg               n22;
   reg               n23;
   reg               n31;
   reg               n32;
   reg               n33;

   reg [3:0]         neighbour_count;
   reg [ROW_WIDTH-1:0] row1;
   reg [ROW_WIDTH-1:0] row2;
   reg                 nextgen;
   reg                 nextgen1;
   reg                 nextgen2;
   reg                 nextgen3;
   reg                 nextgen4;
   reg [7:0]           nextgen8;

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

   // =================================================
   // Clock Generation
   // =================================================

   // 50MHz->150MHz, giving a frame rate of 60.606Hz

   DCM
     #(
       .CLKFX_MULTIPLY   (3),
       .CLKFX_DIVIDE     (1),
       .CLKIN_PERIOD     (20.000),
       .CLK_FEEDBACK     ("NONE")
       )
   DCM1
     (
      .CLKIN            (clk50),
      .CLKFB            (1'b0),
      .RST              (1'b0),
      .DSSEN            (1'b0),
      .PSINCDEC         (1'b0),
      .PSEN             (1'b0),
      .PSCLK            (1'b0),
      .CLKFX            (clk_pixel)
      );

   // =================================================
   // Video Timing
   // =================================================

   always @(posedge clk_pixel) begin
      if (h_counter == H_TOTAL - 1) begin
         h_counter <= 0;
         if (v_counter == V_TOTAL - 1)
           v_counter <= 0;
         else
           v_counter <= v_counter + 1'b1;
      end else begin
         h_counter <= h_counter + 1'b1;
      end

      hsync <= (h_counter >= H_SYNC_START && h_counter < H_SYNC_END);
      vsync <= (v_counter >= V_SYNC_START && v_counter < V_SYNC_END);

      active <= (h_counter < H_ACTIVE && v_counter < V_ACTIVE);

      outline <= ((h_counter == 0 || h_counter == (H_ACTIVE - 1)) && v_counter < V_ACTIVE) ||
                 ((v_counter == 0 || v_counter == (V_ACTIVE - 1)) && h_counter < H_ACTIVE);

   end // always @ (posedge clk_pixel)

   // =================================================
   // Pixel Output
   // =================================================

   always @(posedge clk_pixel) begin
      if (outline) begin
         red   <= 4'h0;
         green <= 4'hF;
         blue  <= 4'h0;
      end else if (active && n22) begin
         red   <= 4'hF;
         green <= 4'hF;
         blue  <= 4'hF;
      end else begin
         red   <= 4'h0;
         green <= 4'h0;
         blue  <= 4'h0;
      end
   end // always @ (posedge clk_pixel)

   // =================================================
   // Life
   // =================================================

   always @(posedge clk_pixel) begin
      if (active) begin
         n33 <= ram_dout[7];
         n32 <= n33;
         n31 <= n32;
         row2 <= {row2[ROW_WIDTH-2:0], n31};
         n23 <= row2[ROW_WIDTH-1];
         n22 <= n23;
         n21 <= n22;
         row1 <= {row1[ROW_WIDTH-2:0], n21};
         n13 <= row1[ROW_WIDTH-1];
         n12 <= n13;
         n11 <= n12;
         neighbour_count <= n11 + n12 + n13 +
                            n21       + n23 +
                            n31 + n32 + n33;
         // Using n21 here as neighbour_count is pipelined
         nextgen <= (neighbour_count == 3) || (n21 && (neighbour_count == 2));

         // Pad so pipeline a multiple of 8 pixels deel
         nextgen1 <= nextgen;
         nextgen2 <= nextgen1;
         nextgen3 <= nextgen2;
         nextgen4 <= nextgen3;
         // Accumulate 8 samples
         nextgen8 <= {nextgen8[6:0], nextgen4};
      end // if (active)
   end // always @ (posedge clk_pixel)

   // =================================================
   // RAM Address / Control Generation
   // =================================================

   always @(posedge clk_pixel) begin

      // Synchronize the RD/WR Pending signals from the 1MHz Domain
      if (h_counter[1:0] == 3) begin
         cpu_rd_pending1 <= cpu_rd_pending;
         cpu_wr_pending1 <= cpu_wr_pending;
      end

      if (h_counter == 0 && v_counter == 0)
        ram_rd_addr <= 0;
      else if (active && h_counter[2:0] == 7)
        ram_rd_addr <= ram_rd_addr + 1'b1;

      if (ram_rd_addr < WR_OFFSET)
        ram_wr_addr <= ram_rd_addr + WR_WRAP;
      else
        ram_wr_addr <= ram_rd_addr - WR_OFFSET;

      ram_dout <= {ram_dout[6:0], 1'b0};

      if (active && !h_counter[2]) begin
         // Life Engine Read Cycle
         ram_cel <= 1'b0;
         ram_addr <= ram_rd_addr;
         ram_oel <= 1'b0;
         if (h_counter[1:0] == 3)
           ram_dout <= ram_data;
      end else if (active && h_counter[2] && control[7]) begin
         // Life Engine Write Cyle
         ram_cel <= 1'b0;
         ram_oel <= 1'b1;
         ram_addr <= ram_wr_addr;
         if (h_counter[1:0] == 0)
           ram_din <= nextgen8;
         if (h_counter[1:0] == 1 || h_counter[1:0] == 2)
           ram_wel <= 1'b0;
         else
           ram_wel <= 1'b1;
      end else if (h_counter[2] && !control[7] && cpu_wr_pending2 != cpu_wr_pending1) begin
         // Beeb Write Cyle
         ram_cel <= 1'b0;
         ram_oel <= 1'b1;
         ram_addr <= cpu_addr;
         if (h_counter[1:0] == 0)
           ram_din <= cpu_wr_data;
         if (h_counter[1:0] == 1 || h_counter[1:0] == 2)
           ram_wel <= 1'b0;
         else
           ram_wel <= 1'b1;
         if (h_counter[1:0] == 3)
           cpu_wr_pending2 <= cpu_wr_pending1;
      end else begin
         ram_cel <= 1'b1;
         ram_oel <= 1'b1;
         ram_wel <= 1'b1;
         ram_addr <= 19'h7FFFF;
      end // else: !if(h_counter(2) && !control(7) && cpu_wr_pending2 != cpu_wr_pending1)
   end // always @ (posedge clk_pixel)

   assign ram_data = ram_wel ? 8'hZZ : ram_din;

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
      end // else: !if(!rst_n)
   end // always @ (negedge clke or negedge rst_n)

   always @(posedge clke)
     if (selected && !pgfd_n)
       cpu_addr[7:0] <= bus_addr;


   assign bus_data = (!pgfc_n && bus_addr == 8'hFF && rnw) ? {selected, 4'b0000, cpu_addr[18:16]} :
                     (!pgfc_n && bus_addr == 8'hFE && rnw) ? cpu_addr[15:8]                       :
                     (!pgfc_n && bus_addr == 8'hA0 && rnw) ? control                              :
                     (!pgfd_n && selected          && rnw) ? cpu_rd_data                          :
                     8'hZZ;

   assign bus_data_oel = !(
                           (clke && !pgfc_n && (bus_addr == 8'hA0 || bus_addr == 8'hFE || bus_addr == 8'hFF)) ||
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