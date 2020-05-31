`ifdef VGA_1920_1200

   // H_TOTAL = 2080
   localparam H_ACTIVE      = 11'd1920;
   localparam H_SYNC_START  = H_ACTIVE + 48;
   localparam H_SYNC_END    = H_SYNC_START + 32;
   localparam H_TOTAL       = H_SYNC_END + 80;

   // V_TOTAL = 1235
   localparam V_ACTIVE      = 11'd1200;
   localparam V_SYNC_START  = V_ACTIVE + 3;
   localparam V_SYNC_END    = V_SYNC_START + 6;
   localparam V_TOTAL       = V_SYNC_END + 26;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b1;

   // Pixel Clock = 154MHz
   // DCM target = 77MHz, DCM actual = 77MHz
   localparam DCM_M         = 7;
   localparam DCM_D         = 2;
   localparam DCM_M2        = 11;
   localparam DCM_D2        = 25;

`endif

`ifdef VGA_1920_1200_NRB

   // Vesa DMT ID 45h

   // H_TOTAL = 2592
   localparam H_ACTIVE      = 11'd1920;
   localparam H_SYNC_START  = H_ACTIVE + 136;
   localparam H_SYNC_END    = H_SYNC_START + 200;
   localparam H_TOTAL       = H_SYNC_END + 336;

   // V_TOTAL = 1245
   localparam V_ACTIVE      = 11'd1200;
   localparam V_SYNC_START  = V_ACTIVE + 3;
   localparam V_SYNC_END    = V_SYNC_START + 6;
   localparam V_TOTAL       = V_SYNC_END + 36;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b1;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 193.25MHz
   // DCM target = 96.65MHz, DCM actual = 96.618357MHz
   localparam DCM_M         = 16;
   localparam DCM_D         = 9;
   localparam DCM_M2        = 25;
   localparam DCM_D2        = 23;

`endif

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

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 148.50MHz
   // DCM target = 74.25MHz, DCM actual = 74.25MHz
   localparam DCM_M         = 11;
   localparam DCM_D         = 8;
   localparam DCM_M2        = 27;
   localparam DCM_D2        = 25;

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

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 162.00MHz
   // DCM target = 81.00MHz, DCM actual = 81.00MHz
   localparam DCM_M         = 9;
   localparam DCM_D         = 5;
   localparam DCM_M2        = 9;
   localparam DCM_D2        = 10;

`endif

`ifdef VGA_1280_1024

   // H_TOTAL = 1688
   localparam H_ACTIVE      = 11'd1280;
   localparam H_SYNC_START  = H_ACTIVE + 48;
   localparam H_SYNC_END    = H_SYNC_START + 112;
   localparam H_TOTAL       = H_SYNC_END + 248;

   // V_TOTAL = 1066
   localparam V_ACTIVE      = 11'd1024;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 3;
   localparam V_TOTAL       = V_SYNC_END + 38;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 108.00MHz
   // DCM target = 54.00MHz, DCM actual = 54.00MHz
   localparam DCM_M         = 27;
   localparam DCM_D         = 25;
   localparam DCM_M2        = 0;
   localparam DCM_D2        = 0;

`endif

`ifdef VGA_1280_768

   // H_TOTAL = 1664
   localparam H_ACTIVE      = 11'd1280;
   localparam H_SYNC_START  = H_ACTIVE + 64;
   localparam H_SYNC_END    = H_SYNC_START + 128;
   localparam H_TOTAL       = H_SYNC_END + 192;

   // V_TOTAL = 798
   localparam V_ACTIVE      = 10'd768;
   localparam V_SYNC_START  = V_ACTIVE + 3;
   localparam V_SYNC_END    = V_SYNC_START + 7;
   localparam V_TOTAL       = V_SYNC_END + 20;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b1;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 79.50MHz
   // DCM target = 39.75MHz, DCM actual = 39.751552MHz
   localparam DCM_M         = 8;
   localparam DCM_D         = 7;
   localparam DCM_M2        = 16;
   localparam DCM_D2        = 23;

`endif

`ifdef VGA_1280_720

   // H_TOTAL = 1650
   localparam H_ACTIVE      = 11'd1280;
   localparam H_SYNC_START  = H_ACTIVE + 110;
   localparam H_SYNC_END    = H_SYNC_START + 40;
   localparam H_TOTAL       = H_SYNC_END + 220;

   // V_TOTAL = 750
   localparam V_ACTIVE      = 10'd720;
   localparam V_SYNC_START  = V_ACTIVE + 5;
   localparam V_SYNC_END    = V_SYNC_START + 5;
   localparam V_TOTAL       = V_SYNC_END + 20;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 74.25MHz
   // DCM target = 37.125MHz, DCM actual = 37.125MHz
   localparam DCM_M         = 11;
   localparam DCM_D         = 16;
   localparam DCM_M2        = 27;
   localparam DCM_D2        = 25;

`endif

`ifdef VGA_1024_768

   // H_TOTAL = 1344
   localparam H_ACTIVE      = 11'd1024;
   localparam H_SYNC_START  = H_ACTIVE + 24;
   localparam H_SYNC_END    = H_SYNC_START + 136;
   localparam H_TOTAL       = H_SYNC_END + 160;

   // V_TOTAL = 806
   localparam V_ACTIVE      = 10'd768;
   localparam V_SYNC_START  = V_ACTIVE + 3;
   localparam V_SYNC_END    = V_SYNC_START + 6;
   localparam V_TOTAL       = V_SYNC_END + 29;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b1;
   localparam V_POL         = 1'b1;

   // Pixel Clock = 65.00MHz
   // DCM target = 32.50MHz, DCM actual = 32.50MHz
   localparam DCM_M         = 13;
   localparam DCM_D         = 20;
   localparam DCM_M2        = 0;
   localparam DCM_D2        = 0;

`endif

`ifdef VGA_800_600

   // H_TOTAL = 1056
   localparam H_ACTIVE      = 11'd800;
   localparam H_SYNC_START  = H_ACTIVE + 40;
   localparam H_SYNC_END    = H_SYNC_START + 128;
   localparam H_TOTAL       = H_SYNC_END + 88;

   // V_TOTAL = 628
   localparam V_ACTIVE      = 10'd600;
   localparam V_SYNC_START  = V_ACTIVE + 1;
   localparam V_SYNC_END    = V_SYNC_START + 4;
   localparam V_TOTAL       = V_SYNC_END + 23;

   // Polarity 0=positive, 1=negative
   localparam H_POL         = 1'b0;
   localparam V_POL         = 1'b0;

   // Pixel Clock = 40.00MHz
   // DCM target = 20.00MHz, DCM actual = 20.00MHz
   localparam DCM_M         = 4;
   localparam DCM_D         = 10;
   localparam DCM_M2        = 0;
   localparam DCM_D2        = 0;

`endif
