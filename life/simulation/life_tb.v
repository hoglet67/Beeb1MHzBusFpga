`timescale 1ns / 1ps

module life_tb();

   parameter   LIFE_INIT_FILE    = "life.mem";

   reg [7:0]  mem [ 0:524287 ];

   reg         clk50;
   reg         clke;

   reg         rnw;
   reg         rst_n;
   reg         pgfc_n;
   reg         pgfd_n;
   reg [7:0]   bus_addr;
   wire [7:0]  bus_data;
   wire [7:0]  bus_data_in;
   reg [7:0]   bus_data_out;

   wire [18:0] ram_addr;
   wire [7:0]  ram_data;
   wire        ram_cel;
   wire        ram_oel;
   wire        ram_wel;
   wire [7:0]  ram_data_in;
   reg [7:0]   ram_data_out;

   wire [7:0]  pmod0;
   wire [7:0]  pmod1;
   integer     i;

   task write_reg;
      input [7:0] addr;
      input [7:0] data;
      begin
         @(negedge clke);
         #100;
         bus_addr = addr;
         bus_data_out = data;
         rnw = 1'b0;
         pgfc_n = 1'b0;
         @(negedge clke);
         #100;
         rnw = 1'b1;
         pgfc_n = 1'b1;
      end
   endtask

   task write_fd;
      input [7:0] addr;
      input [7:0] data;
      begin
         @(negedge clke);
         #100;
         bus_addr = addr;
         bus_data_out = data;
         rnw = 1'b0;
         pgfd_n = 1'b0;
         @(negedge clke);
         #100;
         rnw = 1'b1;
         pgfd_n = 1'b1;
      end
   endtask

   task write_ram;
      input [17:0] addr;
      input [7:0] data;
      begin
         write_reg(8'hFF, 8'hC8 | addr[17:16]);
         write_reg(8'hFE, addr[15:8]);
         write_fd(addr[7:0], data);
      end
   endtask

life
   DUT
     (

      // System oscillator
      .clk50(clk50),
      // BBC 1MHZ Bus
      .clke(clke),
      .rnw(rnw),
      .rst_n(rst_n),
      .pgfc_n(pgfc_n),
      .pgfd_n(pgfd_n),
      .bus_addr(bus_addr),
      .bus_data(bus_data),
      .bus_data_dir(),
      .bus_data_oel(),
      .nmi(),
      .irq(),
      // SPI DAC
      .dac_cs_n(),
      .dac_sck(),
      .dac_sdi(),
      .dac_ldac_n(),
      // RAM
      .ram_addr(ram_addr),
      .ram_data(ram_data),
      .ram_cel(ram_cel),
      .ram_oel(ram_oel),
      .ram_wel(ram_wel),
      // Misc
      .pmod0(pmod0),
      .pmod1(pmod1),
      .pmod2(),
      .sw1(),
      .sw2(),
      .led()
      );

   initial begin

      $dumpvars;

      // Initialize, otherwise it messes up when probing for roms
      for (i = 0; i < 262144; i = i + 1)
        mem[i] = 0;

      // initialize cclock
      clk50 = 1'b0;
      clke  = 1'b0;

      // initialize other miscellaneous inputs
      pgfc_n <= 1'b1;
      pgfd_n <= 1'b1;
      bus_addr <= 8'h00;
      bus_data_out <= 8'h00;
      rnw <= 1'b1;

      //external rest
      rst_n  = 1'b1;
      @(negedge clke)
      rst_n  = 1'b0;
      @(negedge clke)
      rst_n  = 1'b1;

      // load the memory image
      // $readmemh(LIFE_INIT_FILE, mem);

      mem[12'h897] = 8'h55;
      mem[12'h95f] = 8'h15;
      mem[12'ha72] = 8'h05;
      mem[12'haef] = 8'h01;
      mem[12'h7d0] = 8'hAA;
      mem[12'h898] = 8'hA8;
      mem[12'h960] = 8'h20;
      mem[12'ha28] = 8'h80;

      write_reg(8'hA4, 8'h3C);
      write_reg(8'hA5, 8'h18);
      write_reg(8'hA6, 8'hBC);
      write_reg(8'hA7, 8'h00);
      write_reg(8'hA8, 8'h04);  // Zoom mode 4 (window 100x75)

      write_reg(8'hA0, 8'h00);  // Stopped

      // Wait 0.5ms for first few lines
      #(500 * 1000);

      $finish;

   end

   assign bus_data_in = bus_data;
   assign bus_data = rnw ? 8'hZZ : bus_data_out;

   always
     #10 clk50 = !clk50;

   always
     #500 clke = !clke;

   assign ram_data_in = ram_data;
   assign ram_data = (!ram_cel && !ram_oel && ram_wel) ? ram_data_out : 8'hZZ;

   always @(posedge ram_wel)
     if (ram_cel == 1'b0)
       mem[ram_addr] <= ram_data_in;

   always @(ram_addr)
     ram_data_out <= mem[ram_addr];

endmodule
