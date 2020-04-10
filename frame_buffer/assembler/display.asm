OSFIND       = &FFCE
OSGBPB       = &FFD1
OSARGS       = &FFDA

fd           = &80
pp           = &81
xsize        = &82
ysize        = &84
osargs_block = &86
ix           = &86
iy           = &88
tmp1         = &8A
tmp2         = &8B
rle_count    = &8C
rle_pixel    = &8D

org &2800

.start

    LDA #&40
    LDX #LO(filename)
    LDY #HI(filename)
    JSR OSFIND
    CMP #0
    BNE opened

    BRK
    EQUB 100
    EQUS "Failed to open file"
    EQUB 0

.opened
    STA fd

    ;; Read the header block
    JSR osgbpb_to_block

    LDA block+&1A
    CMP #2
    BEQ type_rle

    BRK
    EQUB 100
    EQUS "Unsupported file type"
    EQUB 0

.type_rle

    ;; Copy the X and Y size
    ;; TODO: This should take account of other values in the header
    LDX #3
.size_loop
    LDA block+&09,X
    STA xsize,X
    DEX
    BPL size_loop

    ;; Resolution is half the size...
    ;; The metadata says the size is 0x05FE x 0x047A which is 1534 x 1146.
    ;; But the resolution is actually 768 x 574, as you stated eariler in this thread.
    ;; It looks like the values stored in the header are in fact 2*(x_resolution - 1) and 2*(y_resolution - 1)
    ;; so x/y resolution = (metadata/2) + 1

    LDX #2
.half_loop
    LSR xsize+1,X
    ROR xsize,X
    INC xsize,X
    BNE xsize_no_wrap
    INC xsize+1,X
.xsize_no_wrap
    DEX
    DEX
    BPL half_loop

    ;; Seek to the start of Palette Data
    LDX #&02
    JSR seek_to_sector

    LDA #&C7
    STA &FCFF

    ;; Load the Red Palette
    LDA #&FC
    STA &FCFE
    JSR osgbpb_to_fd00

    ;; Load the Green Palette
    LDA #&FD
    STA &FCFE
    JSR osgbpb_to_fd00

    ;; Load the Blue Palette
    LDA #&FE
    STA &FCFE
    JSR osgbpb_to_fd00

    ;; Seek to the start of Pixel Data
    LDX block+&0D       ; Start Sector of Pixel - 1
    INX
    JSR seek_to_sector

    ;; Initialize ix, iy and pp to 0
    LDA #0
    STA ix
    STA ix+1
    STA iy
    STA iy+1
    STA pp

.rle_loop

    ;; When pp is 0, load the next block of data
    LDX pp
    BNE rle_pair

    ;; Read bext 256b of pixel data
    JSR osgbpb_to_block

    LDX #0

.rle_pair
    LDA block, X
    CLC
    ADC #1
    STA rle_count
    INX
    LDA block, X
    STA rle_pixel
    INX
    STX pp

.pixel_loop

    ;; Work around, skip pixels beyond X=640
    LDA ix+1
    CMP #HI(640)
    BCC x_in_range
    BNE skip_pixel_write
    LDA ix
    CMP #LO(640)
    BCS skip_pixel_write
.x_in_range

    ;; Work around, skip pixels beyond Y=480
    LDA iy+1
    CMP #HI(480)
    BCC y_in_range
    BNE skip_pixel_write
    LDA iy
    CMP #LO(480)
    BCS skip_pixel_write
.y_in_range

    LDX ix
    BNE skip_update_page

    ;; Whenever ix = 0, update the &FD00 page address from ix and iy
    LDA ix+1
    AND #&03
    STA tmp1
    LDA iy+1
    STA tmp2
    LDA iy
    ASL A
    ROL tmp2
    ASL A
    ROL tmp2
    ORA tmp1
    STA &FCFE
    LDA tmp2
    ORA #&C0
    STA &FCFF

.skip_update_page

    LDA rle_pixel
    STA &FD00,X

.skip_pixel_write

    ;; Update ix
    INC ix
    BNE ixcmp
    INC ix+1
.ixcmp
    LDA ix
    CMP xsize
    BNE rle_next
    LDA ix+1
    CMP xsize+1
    BNE rle_next

    ;; Set ix back to 0
    LDA #0
    STA ix
    STA ix+1

    ;; Update iy
.iyinc
    INC iy
    BNE iycmp
    INC iy+1
.iycmp
    LDA iy
    CMP ysize
    BNE rle_next
    LDA iy+1
    CMP ysize+1
    BNE rle_next

.exit
    ;; CLOSE and Exit
    LDA #&00
    LDY fd
    JMP OSFIND

.rle_next
    ;; Next RLE Pixel
    DEC rle_count
    BNE pixel_loop
    JMP rle_loop

.seek_to_sector
    LDA #0
    STA osargs_block+0
    STX osargs_block+1
    STA osargs_block+2
    STA osargs_block+3
    LDA #&01
    LDX #osargs_block
    LDY fd
    JMP OSARGS

.osgbpb_to_fd00
    LDA #&00
    STA osgbpb_params+1
    LDA #&FD
    STA osgbpb_params+2
    BNE osgbpb_to

.osgbpb_to_block
    LDA #LO(block)
    STA osgbpb_params+1
    LDA #HI(block)
    STA osgbpb_params+2
.osgbpb_to
    LDA fd
    STA osgbpb_params
    LDA #&00
    STA osgbpb_params+5
    LDA #&01
    STA osgbpb_params+6
    LDA #&04
    LDX #LO(osgbpb_params)
    LDY #HI(osgbpb_params)
    JMP OSGBPB

.osgbpb_params
    EQUB &00
    EQUD 0
    EQUD 0
    EQUD 0

    ALIGN &100
.block
    SKIP &100


.filename
    EQUS "TRAIN6", 13

.end

SAVE "display", start, end
