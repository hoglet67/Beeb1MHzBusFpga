org &1900

include "constants.asm"

.start

        JSR print_string

        EQUB 22, 4
        EQUS "Conway Life for the BBC Micro", 10, 10, 13
        EQUS "Using the FPGA Engine", 10, 10, 13
        NOP

        JSR index_patterns
        STA last_pattern

        LDA #10
        JSR OSWRCH

.prompt
        JSR print_string
        EQUB 13
        EQUS "Press key A-"
        NOP

        LDA last_pattern
        JSR OSWRCH

        JSR print_string
        EQUS " to load pattern:  ", 127
        NOP

        JSR OSRDCH
        JSR OSWRCH

        CMP #' '
        BNE not_space
        LDA &FCA0
        EOR #&40
        STA &FCA0
        JMP prompt

.not_space
        CMP #'A'
        BCC prompt
        CMP last_pattern
        BEQ ok
        BCS prompt
.ok
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
        JSR load_pattern

        ; Start the Life Engine
        LDA &FCA0
        ORA #&80
        STA &FCA0
.wait2
        BIT &FCA0
        BPL wait2

        JMP prompt

include "rle_reader_fpga.asm"

include "rle_utils.asm"

include "utils.asm"

include "indexer.asm"

.end

SAVE "", start, end
