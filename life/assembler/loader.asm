org &2000

include "constants.asm"

.start

        ; Save the file handle of the RLE file
        STY handle

        ; Stop the Life Engine
        LDA &FCA0
        AND #&7F
        STA &FCA0
.wait1
        BIT &FCA0
        BMI wait1

        ; Clear the Screen
        JSR clear

        JSR rle_reader

        JSR OSRDCH

        ; Start the Life Engine
        LDA &FCA0
        ORA #&80
        STA &FCA0
.wait2
        BIT &FCA0
        BPL wait2

        RTS


include "rle_reader_fpga.asm"

include "rle_utils.asm"


.clear
{
        LDA #BASE
        STA &FCFF
        LDX #0
        LDY #0
.loop1
        STX &FCFE
        LDA #0
.loop2
        STA &FD00,Y
        INY
        BNE loop2
        INX
        BNE loop1
        LDA &FCFF
        CLC
        ADC #1
        ORA #BASE
        STA &FCFF
        CMP #BASE + 1 + ((X_WIDTH * Y_WIDTH) DIV &80000)
        BNE loop1
        RTS
}

.end

SAVE "", start, end
