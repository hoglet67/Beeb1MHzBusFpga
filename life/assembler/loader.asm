org &1900

include "constants.asm"

.start
        LDA #'0'
        STA drive

        JSR reset_scaler

        ;; Set the cursor keys to return &87-&8B
        LDA #&04
        LDX #&01
        LDY #&00
        JSR OSBYTE

        ;; Set function keys to return &80+n
        LDA #&E1
        LDX #&80
        LDY #&00
        JSR OSBYTE

        ;; Show something nice while indexing RLE files
        LDA #1
        JSR clear_screen
        JSR engine_start
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
        JSR read_key
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

        JSR print_string
        EQUS "Z/X/CURSOR/TAB=pan/zoom, SPACE=stop/start, RETURN=step, COPY=mask edges", 10, 13
        NOP

.prompt
        JSR display_prompt
        JSR read_key
        CMP #'0'
        BCC not_drive
        CMP #'3'+1
        BCS not_drive
        STA drive
        JMP main                ; main will reindex the new disk

.not_drive
        CMP #&09
        BNE not_tab
        JSR reset_scaler
        JMP prompt

.not_tab
        CMP #&87
        BNE not_copy
        JSR mask_toggle
        JMP prompt

.not_copy
        CMP #' '
        BNE not_space
        JSR engine_toggle
        JMP prompt

.not_space
        CMP #&0D
        BNE not_return
        JSR engine_step
        JMP prompt

.not_return
        CMP #&80
        BCC not_fn
        CMP #&83+1
        BCS not_fn
        AND #&03
        JSR clear_screen
        JMP prompt

.not_fn
        CMP #'Z'
        BNE not_z
        JSR zoom_inc
        JMP prompt

.not_z
        CMP #'X'
        BNE not_x
        JSR zoom_dec
        JMP prompt

.not_x
        CMP #&88
        BNE not_left
        JSR pan_left
        JMP prompt

.not_left
        CMP #&89
        BNE not_right
        JSR pan_right
        JMP prompt

.not_right
        CMP #&8A
        BNE not_down
        JSR pan_down
        JMP prompt

.not_down
        CMP #&8B
        BNE not_up
        JSR pan_up
        JMP prompt

.not_up
        CMP #'A'
        BCC notok
        CMP last_pattern
        BEQ ok
        BCS notok
.ok
        PHA
        LDA #&00                ; Clear to blank
        JSR clear_screen
        PLA                     ; create initial pattern
        JSR load_pattern
.notok
        JMP prompt
}


.display_prompt
{

        JSR print_string
        EQUB 13
        EQUS "0-3=select drive, F1-F3=random, A-"
        NOP

        LDA last_pattern
        JSR OSWRCH

        JSR print_string
        EQUS "=load pattern:  ", 127
        NOP
        RTS
}

.read_key
{
        JSR OSRDCH
        BCS escape
        CMP #&20
        BCC exit
        CMP #&7F
        BCS exit
        JSR OSWRCH
        .exit
        RTS
.escape
        LDA #&7E
        JSR OSBYTE
        LDA #&E1
        LDX #&01
        LDY #&00
        JSR OSBYTE
        LDA #&04
        LDX #&00
        LDY #&00
        JSR OSBYTE
        LDA #22
        JSR OSWRCH
        LDA #7
        JSR OSWRCH
        LDX #<cmd1
        LDY #>cmd1
        JSR OSCLI
        LDX #<cmd2
        LDY #>cmd2
        JSR OSCLI
        PLA
        PLA
        RTS
.cmd1
        EQUS "DRIVE 0", 13
.cmd2
        EQUS "DIR $", 13
}

.engine_start
{
        LDA reg_control
        ORA #ctrl_running
        STA reg_control
.wait
        BIT reg_status
        BPL wait
        RTS
}

.engine_stop
{
        LDA reg_control
        AND #&FF-ctrl_running
        STA reg_control
.wait
        BIT reg_status
        BMI wait
        RTS
}

.engine_toggle
{
        BIT reg_control
        BMI engine_stop
        BPL engine_start
}

.engine_step
{
        JSR wait_for_vsync
        JSR engine_start
        JSR wait_for_vsync
        JSR engine_stop
        RTS
}

.mask_toggle
{
        LDA reg_control
        EOR #ctrl_mask
        STA reg_control
        RTS
}

.zoom_dec
{
        LDX reg_scaler_zoom
        CPX #MIN_ZOOM
        BCC exit
        BEQ exit
        DEX
        JSR wait_for_vsync
        STX reg_scaler_zoom
.exit
        RTS
}

.zoom_inc
{
        LDX reg_scaler_zoom
        CPX #MAX_ZOOM
        BCS exit
        INX
        JSR wait_for_vsync
        STX reg_scaler_zoom
.exit
        RTS
}

.pan_right
{
        JSR wait_for_vsync
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA reg_scaler_x_origin
        SEC
        SBC jump_amount, X
        STA reg_scaler_x_origin
        LDA reg_scaler_x_origin + 1
        SBC #&00
        STA reg_scaler_x_origin + 1
        RTS
}

.pan_left
{
        JSR wait_for_vsync
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA reg_scaler_x_origin
        CLC
        ADC jump_amount, X
        STA reg_scaler_x_origin
        LDA reg_scaler_x_origin + 1
        ADC #&00
        STA reg_scaler_x_origin + 1
        RTS
}

.pan_down
{
        JSR wait_for_vsync
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA reg_scaler_y_origin
        SEC
        SBC jump_amount, X
        STA reg_scaler_y_origin
        LDA reg_scaler_y_origin + 1
        SBC #&00
        STA reg_scaler_y_origin + 1
        RTS
}

.pan_up
{
        JSR wait_for_vsync
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA reg_scaler_y_origin
        CLC
        ADC jump_amount, X
        STA reg_scaler_y_origin
        LDA reg_scaler_y_origin + 1
        ADC #&00
        STA reg_scaler_y_origin + 1
        RTS
}

.jump_amount
    EQUB &00    ; zoom off
    EQUB &08    ; 800x600
    EQUB &04    ; 400x300
    EQUB &02    ; 200x150
    EQUB &01    ; 100x75
    EQUB &00    ; undefined zoom
    EQUB &00    ; undefined zoom
    EQUB &00    ; undefined zoom



.reset_scaler
{
        ;; Set the default scaler zoom to none
        LDA #DEFAULT_ZOOM
        STA reg_scaler_zoom

        ;; Set the default scaler X origin to half the screen width
        LDA #0
        STA tmp
        LDA reg_x_size
        ASL A
        ROL tmp
        ASL A
        ROL tmp
        STA reg_scaler_x_origin
        LDA tmp
        STA reg_scaler_x_origin + 1

        ;; Set the default scaler Y origin to half the screen height
        LDA #0
        STA tmp
        LDA reg_y_size
        ASL A
        ROL tmp
        ASL A
        ROL tmp
        STA reg_scaler_y_origin
        LDA tmp
        STA reg_scaler_y_origin + 1
        RTS
}

; A = 0 - Clear to 0
; A = 1 - Clear to low density random
; A = 2 - Clear to medium density random
; A = 3 - Clear to high density random
;
; Leaves the engine in the stopped state

.clear_screen
{
        AND #&03
        STA tmp
        LDA reg_control
        AND #&FC
        ORA tmp
        ORA #ctrl_clear+ctrl_running
        JSR wait_for_vsync
        STA reg_control
        AND #&FC-ctrl_clear-ctrl_running
        JSR wait_for_vsync
        STA reg_control
        RTS
}

; Wait for the 0-1 edge of VSYNC
.wait_for_vsync
{
.loop1
        BIT reg_status
        BVS loop1
.loop2
        BIT reg_status
        BVC loop2
        RTS
}


include "rle_reader_fpga.asm"

include "rle_utils.asm"

include "utils.asm"

include "indexer.asm"

.end

SAVE "", start, end
