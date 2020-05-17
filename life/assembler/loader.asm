org &1900

include "constants.asm"

.start
        LDA #'0'
        STA drive
        JMP main

.no_patterns
{
        JSR print_string
        EQUS "No patterns on the current drive", 10, 10
        NOP
.loop
        JSR print_string
        EQUS 13, "Press 0-3 to select another drive:  ", 127
        NOP
        JSR OSRDCH
        JSR OSWRCH
        CMP #'0'
        BCC loop
        CMP #'3'+1
        BCS loop
        STA drive
}

.main
{
        JSR print_string
        EQUB 22, 0
        EQUS "Conway Life for the BBC Micro", 10, 10, 13
        EQUS "Using the FPGA Engine"
        NOP
        LDA #72
        JSR tab_to_col
        JSR print_string
        EQUS "Drive: "
        NOP
        LDA drive
        JSR OSWRCH
        JSR OSNEWL

        JSR index_patterns
        BCC save_last
        JMP no_patterns

.save_last
        STA last_pattern

        LDA #10
        JSR OSWRCH

.prompt
        JSR print_string
        EQUB 13
        EQUS "Press 0-3 to select drive, A-"
        NOP

        LDA last_pattern
        JSR OSWRCH

        JSR print_string
        EQUS " to load pattern:  ", 127
        NOP

        JSR OSRDCH
        JSR OSWRCH

        CMP #'0'
        BCC not_drive
        CMP #'3'+1
        BCS not_drive
        STA drive
        JMP main

.not_drive
        CMP #' '
        BNE not_space
        LDA reg_control
        EOR #&40
        STA reg_control
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
        LDA reg_control
        AND #&7F
        STA reg_control
.wait1
        BIT reg_control
        BMI wait1

        JSR clear_screen

        PLA                     ; create initial pattern
        JSR load_pattern

        ; Start the Life Engine
        LDA reg_control
        ORA #&80
        STA reg_control
.wait2
        BIT reg_control
        BPL wait2

        JMP prompt
}

include "rle_reader_fpga.asm"

include "rle_utils.asm"

include "utils.asm"

include "indexer.asm"

.end

SAVE "", start, end
