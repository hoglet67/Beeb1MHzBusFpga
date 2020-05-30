module MultiBootLoader
  (
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
   input [7:0]       bus_data;
   output            bus_data_dir;
   output            bus_data_oel;
   output            nmi;
   output            irq;
   // RAM
   output [18:0]     ram_addr;
   input [7:0]       ram_data;
   output            ram_cel;
   output            ram_oel;
   output            ram_wel;
   // Misc
   output [7:0]      pmod0;
   output [7:0]      pmod1;
   inout [7:0]       pmod2;
   input             sw1;
   input             sw2;
   output            led;


   reg [1:0]         clk;

   reg [15:0]        icap_din;
   reg               icap_ce;
   reg               icap_wr;

   reg [15:0]        ff_icap_din_reversed;
   reg               ff_icap_ce;
   reg               ff_icap_wr;

   reg [15:0]  MBT_REBOOT = 16'h0000;

   ICAP_SPARTAN6 ICAP_SPARTAN6_inst
     (
      .BUSY      (),                      // Busy output
      .O         (),                      // 16-bit data output
      .CE        (ff_icap_ce),            // Clock enable input
      .CLK       (clk[0]),                // Clock input
      .I         (ff_icap_din_reversed),  // 16-bit data input
      .WRITE     (ff_icap_wr)             // Write input
      );


   //  -------------------------------------------------
   //  --  State Machine for ICAP_SPARTAN6 MultiBoot  --
   //  --   sequence.                                 --
   //  -------------------------------------------------


   parameter
     IDLE     = 0,
     SYNC_H   = 1,
     SYNC_L   = 2,

     CWD_H    = 3,
     CWD_L    = 4,

     GEN1_H   = 5,
     GEN1_L   = 6,

     GEN2_H   = 7,
     GEN2_L   = 8,

     GEN3_H   = 9,
     GEN3_L   = 10,

     GEN4_H   = 11,
     GEN4_L   = 12,

     GEN5_H   = 13,
     GEN5_L   = 14,

     NUL_H    = 15,
     NUL_L    = 16,

     MOD_H    = 17,
     MOD_L    = 18,

     HCO_H    = 19,
     HCO_L    = 20,

     RBT_H    = 21,
     RBT_L    = 22,

     NOOP_0   = 23,
     NOOP_1   = 24,
     NOOP_2   = 25,
     NOOP_3   = 26;


   reg [4:0]   state = IDLE;
   reg [4:0]   next_state;

   always @(MBT_REBOOT or state or pmod2)
     begin: COMB

        case (state)

          IDLE:
            begin
               if (MBT_REBOOT==16'hffff)
                 begin
                    next_state  = SYNC_H;
                    icap_ce     = 0;
                    icap_wr     = 0;
                    icap_din    = 16'hAA99;  // Sync word part 1
                 end
               else
                 begin
                    next_state  = IDLE;
                    icap_ce     = 1;
                    icap_wr     = 1;
                    icap_din    = 16'hFFFF;  // Null data
                 end
            end

          SYNC_H:
            begin
               next_state  = SYNC_L;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h5566;    // Sync word part 2
            end

          SYNC_L:
            begin
               next_state  = GEN1_H;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h3261;    //  Write to GENERAL_1 Register....
            end

          GEN1_H:
            begin
               next_state  = GEN1_L;
               icap_ce     = 0;
               icap_wr     = 0;

               // multiboot loader - 0x000000 -
               // design 1111      - 0x054000 - 1920 x 1080
               // design 1110      - 0x0a8000 - 1600 x 1200
               // design 1101      - 0x0fc000 - 1280 x 1024
               // design 1100      - 0x150000 - 1280 x  768
               // design 1011      - 0x1a4000 - 1280 x  720
               // design 1010      - 0x1f8000 - 1024 x  768
               // design 1001      - 0x24c000 -  800 x  600
               // design 1000      - 0x2a0000 - spare
               // design 0111      - 0x2f4000 - spare
               // design 0110      - 0x348000 - spare
               // design 0101      - 0x39c000 - spare

               case (pmod2[3:0])
                 4'b1111: icap_din = 16'h4000;
                 4'b1110: icap_din = 16'h8000;
                 4'b1101: icap_din = 16'hc000;
                 4'b1100: icap_din = 16'h0000;
                 4'b1011: icap_din = 16'h4000;
                 4'b1010: icap_din = 16'h8000;
                 4'b1001: icap_din = 16'hc000;
                 4'b1000: icap_din = 16'h0000;
                 4'b0111: icap_din = 16'h4000;
                 4'b0110: icap_din = 16'h8000;
                 4'b0101: icap_din = 16'hc000;
                 default: icap_din = 16'h4000;
               endcase

            end

          GEN1_L:
            begin
               next_state  = GEN2_H;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h3281;    //  Write to GENERAL_2 Register....
            end

          GEN2_H:
            begin
               next_state  = GEN2_L;
               icap_ce     = 0;
               icap_wr     = 0;

               case (pmod2[3:0])
                 4'b1111: icap_din = 16'h0305;
                 4'b1110: icap_din = 16'h030a;
                 4'b1101: icap_din = 16'h030f;
                 4'b1100: icap_din = 16'h0315;
                 4'b1011: icap_din = 16'h031a;
                 4'b1010: icap_din = 16'h031f;
                 4'b1001: icap_din = 16'h0324;
                 4'b1000: icap_din = 16'h032a;
                 4'b0111: icap_din = 16'h032f;
                 4'b0110: icap_din = 16'h0334;
                 4'b0101: icap_din = 16'h0339;
                 default: icap_din = 16'h0305;
               endcase

            end

          GEN2_L:
            begin
               next_state  = RBT_H;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h30A1;      //  Write to Command Register....
            end

          RBT_H:
            begin
               next_state  = RBT_L;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h000E;      // REBOOT Command issued....  value = 0x000E
            end

          RBT_L:
            begin
               next_state  = NOOP_0;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h2000;    //  NOOP
            end

          NOOP_0:
            begin
               next_state  = NOOP_1;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h2000;    // NOOP
            end

          NOOP_1:
            begin
               next_state  = NOOP_2;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h2000;    // NOOP
            end

          NOOP_2:
            begin
               next_state  = NOOP_3;
               icap_ce     = 0;
               icap_wr     = 0;
               icap_din    = 16'h2000;    // NOOP
            end

          NOOP_3:
            begin
               next_state  = IDLE;
               icap_ce     = 1;
               icap_wr     = 1;
               icap_din    = 16'h1111;    // NULL value
            end

          default:
            begin
               next_state  = IDLE;
               icap_ce     = 1;
               icap_wr     = 1;
               icap_din    = 16'h1111;    //  16'h1111"
            end

        endcase
     end

   // Clock ICAP_SPARTAN6 and the state machine with clocks that are 90deg phase apart.
   //
   // This is an attempt to cure some reconfiguration unreliability.
   //
   // The problem is that ICAP_SPARTAN2 isn't treated by the Xilinx tools as a synchronous
   // component, so when clocked off the same clock there can be timing issues.
   //
   // The below clocking patten runs the clock at 8MHz (half what it was before).
   //
   // It ensures there is plenty of setup and hold time margin for signals passing
   // between ICAP_SPARTAN6 and the state machine, regardless of which clk edge is used
   // ICAP_SPARTAN6.
   //
   // See this link for some related discussion:
   // https://forums.xilinx.com/t5/Spartan-Family-FPGAs/20Mhz-limitation-for-ICAP-SPARTAN6/td-p/238060
   //
   // NOTE: I'm hedging here, as this bug is quite difficult to reproduce, and changing almost anything
   // (e.g. connecting state to the test pins) causes the problem to go away.
   //
   // At worst this change should be harmless!
   //
   // Dave Banks - 18/07/2017

   always@(posedge clk50) begin
      if (clk == 2'b00)
        clk <= 2'b10;
      else if (clk == 2'b10)
        clk <= 2'b11;
      else if (clk == 2'b11)
        clk <= 2'b01;
      else
        clk <= 2'b00;
   end

   // Give a bit of delay before starting the state machine
   always @(posedge clk[1]) begin
      if (MBT_REBOOT == 16'hffff) begin
         state <= next_state;
      end else begin
         MBT_REBOOT <= MBT_REBOOT + 1'b1;
         state <= IDLE;
      end
   end


   always @(posedge clk[1]) begin:   ICAP_FF
      // need to reverse bits to ICAP module since D0 bit is read first
      ff_icap_din_reversed[0]  <= icap_din[7];
      ff_icap_din_reversed[1]  <= icap_din[6];
      ff_icap_din_reversed[2]  <= icap_din[5];
      ff_icap_din_reversed[3]  <= icap_din[4];
      ff_icap_din_reversed[4]  <= icap_din[3];
      ff_icap_din_reversed[5]  <= icap_din[2];
      ff_icap_din_reversed[6]  <= icap_din[1];
      ff_icap_din_reversed[7]  <= icap_din[0];
      ff_icap_din_reversed[8]  <= icap_din[15];
      ff_icap_din_reversed[9]  <= icap_din[14];
      ff_icap_din_reversed[10] <= icap_din[13];
      ff_icap_din_reversed[11] <= icap_din[12];
      ff_icap_din_reversed[12] <= icap_din[11];
      ff_icap_din_reversed[13] <= icap_din[10];
      ff_icap_din_reversed[14] <= icap_din[9];
      ff_icap_din_reversed[15] <= icap_din[8];
      ff_icap_ce  <= icap_ce;
      ff_icap_wr  <= icap_wr;
   end

   // =================================================
   // 1MHZ Bus FPGA Adapter Specific Stuff
   // =================================================

   assign irq          = 1'b0;
   assign nmi          = 1'b0;

   assign pmod0        = 8'h00;
   assign pmod1        = 8'h00;

   assign pmod2[7:4]   = 4'h0;
   assign pmod2[3:0]   = 4'hZ;

   assign led          = sw1 | sw2;

   assign bus_data_dir = 1'b0;
   assign bus_data_oel = 1'b1;

   assign ram_addr     = 19'h0;
   assign ram_cel      = 1'b1;
   assign ram_oel      = 1'b1;
   assign ram_wel      = 1'b1;

endmodule
