org &2000

include "constants.asm"

.start

        JSR print_string

        EQUB 22, 4
        EQUS "Conway Life for the BBC Micro", 10, 10, 13
        EQUS "Using the FPGA Engine", 10, 10, 13
        NOP

        JSR list_patterns
        PHA

        JSR print_string
        EQUB 10, 13
        EQUS "Press key A-"
        NOP

        PLA
        JSR OSWRCH

        JSR print_string
        EQUS " for initial pattern:"
        NOP

        JSR OSRDCH
        JSR OSWRCH

        PHA

        ; Stop the Life Engine
        LDA &FCA0
        AND #&7F
        STA &FCA0
.wait1
        BIT &FCA0
        BMI wait1


        JSR clear_screen

        PLA                     ; create initial pattern
        JSR draw_pattern

        ; Start the Life Engine
        LDA &FCA0
        ORA #&80
        STA &FCA0
.wait2
        BIT &FCA0
        BPL wait2


        JMP start


include "patterns.asm"

include "rle_reader_fpga.asm"

include "rle_utils.asm"

include "utils.asm"

.end

SAVE "", start, end
