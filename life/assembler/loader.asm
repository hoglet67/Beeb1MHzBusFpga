include "constants.asm"

        LDA #'0'
        STA drive

        ;; Page the Life Engine hardware into &FDxx
        LDA #SELECTED
        STA &EE
        STA reg_selector

        ;; Selected the register page
        LDA #REGBASE
        STA reg_page_hi

        ;; Check the hardware is present
        LDA reg_magic_lo
        CMP #MAGIC_LO
        BNE hardware_missing
        LDA reg_magic_hi
        CMP #MAGIC_HI
        BEQ hardware_present
.hardware_missing
        JSR print_string
        EQUS "HD Life FPGA not detected", 10, 13
        NOP
        RTS

.hardware_present
        LDA reg_version_maj
        CMP #VERSION_EXPECTED
        BNE hardware_incompatible
        JMP hardware_compatible

.hardware_incompatible
        JSR print_string
        EQUS "HD Life FPGA mismatch detected:",10,13
        EQUS " expected FPGA version = "
        NOP
        LDA #VERSION_EXPECTED
        JSR print_hex2
        JSR print_string
        EQUS ".xx", 10, 13, " actual   FPGA version = "
        NOP
        LDA reg_version_maj
        JSR print_hex2
        LDA #'.'
        JSR OSWRCH
        LDA reg_version_min
        JSR print_hex2
        JMP OSNEWL

.hardware_compatible
        ;; Initialize the control defaukts
        LDA #0
        STA reg_control
        STA reg_speed

        ;; Disable the scaler
        JSR reset_scaler

        ;; Initialize the atom/beeb specific code
        JSR initialize

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
.loop1
        JSR print_string
        EQUS 13, "Press 0-3 to select another drive:  ", 127
        NOP
.loop2
        JSR read_key
        BCS loop2
        CMP #'0'
        BCC loop1
        CMP #'3'+1
        BCS loop1
        STA drive
}

.main
{
        JSR clear_display
        JSR print_string
        EQUS "Conway's Life on the HD Life FPGA at "
        NOP
        LDA reg_x_size
        JSR multiply_by_8
        LDA #0
        STA pad
        JSR PrDec16
        LDA #'x'
        JSR OSWRCH
        LDA reg_y_size
        JSR multiply_by_8
        LDA #0
        STA pad
        JSR PrDec16
        JSR print_string
        EQUS " with "
        NOP
        LDA reg_speed_max
        CLC
        ADC #&01
        STA num
        LDA #0
        STA pad
        JSR PrDec8
        JSR print_string
        EQUS " Pipeline Stages"
        NOP

        LDA #73
        JSR tab_to_col
        JSR print_string
        EQUS "Drive="
        NOP
        LDA drive
        ORA #'0'
        JSR OSWRCH

        JSR display_status

        JSR print_string
        EQUS 31,0,4
        NOP

        JSR index_patterns
        BCC save_last
        JMP no_patterns

.save_last
        STA last_pattern


        JSR display_prompt

.prompt
        JSR display_status

.wait_for_key

        JSR update_counts

        JSR tab_to_prompt

        JSR read_key
        BCS wait_for_key

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
        CMP #&8B
        BNE not_copy
        LDA #0
        STA reg_scaler_x_speed
        STA reg_scaler_y_speed
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
        BCC not_f03
        CMP #&83+1
        BCS not_f03
        AND #&03
        JSR clear_screen
        JMP prompt

.not_f03
        CMP #&84
        BNE not_f4
        JSR mask_toggle
        JMP prompt

.not_f4
        CMP #&85
        BNE not_f5
        JSR border_toggle
        JMP prompt

.not_f5
        CMP #'<'
        BEQ key_speed_dec
        CMP #','
        BNE not_comma
.key_speed_dec
        JSR speed_dec
        JMP prompt

.not_comma
        CMP #'>'
        BEQ key_speed_inc
        CMP #'.'
        BNE not_dot
.key_speed_inc
        JSR speed_inc
        JMP prompt

.not_dot
        CMP #'['
        BNE not_zin
        JSR zoom_inc
        JMP prompt

.not_zin
        CMP #']'
        BNE not_zout
        JSR zoom_dec
        JMP prompt

.not_zout
        ;; Shift Left - decrease pan X speed
        CMP #&9C
        BNE not_shift_left
        DEC reg_scaler_x_speed
        JMP prompt

.not_shift_left
        ;; Shift Right - increase pan X speed
        CMP #&9D
        BNE not_shift_right
        INC reg_scaler_x_speed
        JMP prompt

.not_shift_right
        ;; Shift Down - increase pan Y speed
        CMP #&9E
        BNE not_shift_down
        INC reg_scaler_y_speed
        JMP prompt

.not_shift_down
        ;; Shift Up - decrease pan Y speed
        CMP #&9F
        BNE not_shift_up
        DEC reg_scaler_y_speed
        JMP prompt

.not_shift_up
        CMP #&8C
        BNE not_left
        JSR pan_right
        JMP prompt

.not_left
        CMP #&8D
        BNE not_right
        JSR pan_left
        JMP prompt

.not_right
        CMP #&8E
        BNE not_down
        JSR pan_up
        JMP prompt

.not_down
        CMP #&8F
        BNE not_up
        JSR pan_down
        JMP prompt

.not_up
        CMP #'A'
        BCC notok
        CMP last_pattern
        BEQ ok
        BCS notok
.ok
        ;; Load pattern to current origin (A = pattern letter); don't clear the screep
        PHA
        JSR engine_stop
        PLA
        JSR load_pattern
.notok
        JMP prompt
}

;;           1111111111222222222233333333334444444444555555555566666666667777777777
;; 01234567890123456789012345678901234567890123456789012345678901234567890123456789

;; Conway's Life on the HD Life Engine with 8 pipeline stages               Drive=0
;; Generation=123456  Cells=123456  X=0000,Y=0000  Zoom=Off  Speed=8x  Msk=0  Brd=1

.update_counts
{

        ;; Update generation count
        LDA #31
        JSR OSWRCH
        LDA #11
        JSR OSWRCH
        LDA #2
        JSR OSWRCH
        LDA reg_gens
        STA num
        LDA reg_gens + 1
        STA num + 1
        LDA reg_gens + 2
        AND #&0F
        STA num + 2
        ;; Print 6 digits
        JSR PrDec20

        ;; Update cells count
        LDA #31
        JSR OSWRCH
        LDA #25
        JSR OSWRCH
        LDA #2
        JSR OSWRCH
        LDA reg_cells
        STA num
        LDA reg_cells + 1
        STA num + 1
        LDA reg_cells + 2
        AND #&0F
        STA num + 2
        ;; Print 6 digits
        JSR PrDec20

        ;; Update x offset
        LDA #31
        JSR OSWRCH
        LDA #35
        JSR OSWRCH
        LDA #2
        JSR OSWRCH
        LDA reg_scaler_x_origin
        STA num
        LDA reg_scaler_x_origin + 1
        LSR A
        ROR num
        LSR A
        ROR num
        STA num + 1
        ;; Print 4 digits
        JSR PrDec12

        ;; Update y offset
        LDA #31
        JSR OSWRCH
        LDA #42
        JSR OSWRCH
        LDA #2
        JSR OSWRCH
        LDA reg_scaler_y_origin
        STA num
        LDA reg_scaler_y_origin + 1
        LSR A
        ROR num
        LSR A
        ROR num
        STA num + 1
        ;; Print 4 digits
        JMP PrDec12
}

.display_status
{

        JSR print_string
        EQUS 31,  0, 2, "Generation="
        EQUS 31, 17, 2, "  Cells="
        EQUS 31, 31, 2, "  X="
        EQUS 31, 39, 2, ",Y="
        EQUS 31, 46, 2, "  Zoom="
        NOP
        LDX reg_scaler_zoom
        LDA zoom_table0, X
        JSR OSWRCH
        LDA zoom_table1, X
        JSR OSWRCH
        LDA zoom_table2, X
        JSR OSWRCH

        JSR print_string
        EQUS "  Speed="
        NOP
        LDA reg_speed
        AND #&0F
        CLC
        ADC #&1
        STA num
        LDA #0
        STA pad
        JSR PrDec4

        JSR print_string
        EQUS "x  Msk="
        NOP
        LDA reg_control
        AND #ctrl_mask
        JSR print_boolean

        JSR print_string
        EQUS "  Bdr="
        NOP
        LDA reg_control
        AND #ctrl_border
        JMP print_boolean

.zoom_table0
        EQUS "O2481"
.zoom_table1
        EQUS "fxxx6"
.zoom_table2
        EQUS "f   x"
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
        JSR engine_stop
        JSR engine_start
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

.border_toggle
{
        LDA reg_control
        EOR #ctrl_border
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

.speed_inc
{
        ;; Bits 0-3 are speed, allowing upto 16 stages
        LDA reg_speed
        AND #&0F
        CMP reg_speed_max
        BEQ exit
        INC reg_speed
.exit
        RTS
}

.speed_dec
{
        ;; Bits 0-3 are speed, allowing upto 16 stages
        LDA reg_speed
        AND #&0F
        BEQ exit
        DEC reg_speed
.exit
        RTS
}


.pan_right
{
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA jump_amount, X
        LDX #<reg_scaler_x_origin
        LDY reg_x_size
        JMP pan_decrement
}

.pan_left
{
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA jump_amount, X
        LDX #<reg_scaler_x_origin
        LDY reg_x_size
        JMP pan_increment
}

.pan_down
{
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA jump_amount, X
        LDX #<reg_scaler_y_origin
        LDY reg_y_size
        JMP pan_decrement
}

.pan_up
{
        LDA reg_scaler_zoom
        AND #&07
        TAX
        LDA jump_amount, X
        LDX #<reg_scaler_y_origin
        LDY reg_y_size
        JMP pan_increment
}

; A is the 8-bit amount to increment by
; X indicates the register in page reg_jim to update
; Y indicates the limit div 8
.pan_increment
{

        ; tmp = A, zero-extendeded to 16 bits
        STA tmp
        LDA #0
        STA tmp + 1

        ; perform a 16-bit addition
        CLC
        LDA reg_jim, X
        ADC tmp
        STA accumulator
        LDA reg_jim + 1, X
        ADC tmp + 1
        STA accumulator + 1

        ; calculate limit in tmp, and compare accumulator against it
        JSR calc_limit_and_compare
        BCC less_than_limit

        ; subtract limit to accumlator to wrap around correctly
        SEC
        LDA accumulator
        SBC tmp
        STA accumulator
        LDA accumulator + 1
        SBC tmp + 1
        STA accumulator + 1

.less_than_limit
        ; Write registers back
        JSR wait_for_vsync
        LDA accumulator
        STA reg_jim, X
        LDA accumulator + 1
        STA reg_jim + 1, X
        RTS
}

; A is the 8-bit amount to decrement by
; X indicates the register in page reg_jim to update
; Y indicates the limit div 8
.pan_decrement
{

        ; tmp = A, zero-extendeded to 16 bits
        STA tmp
        LDA #0
        STA tmp + 1

        ; perform a 16-bit subraction
        SEC
        LDA reg_jim, X
        SBC tmp
        STA accumulator
        LDA reg_jim + 1, X
        SBC tmp + 1
        STA accumulator + 1

        ; calculate limit in tmp, and compare accumulator against it
        JSR calc_limit_and_compare
        BCC less_than_limit

        ; add limit to accumlator to wrap around correctly
        CLC
        LDA accumulator
        ADC tmp
        STA accumulator
        LDA accumulator + 1
        ADC tmp + 1
        STA accumulator + 1

.less_than_limit
        ; Write registers back
        JSR wait_for_vsync
        LDA accumulator
        STA reg_jim, X
        LDA accumulator + 1
        STA reg_jim + 1, X
        RTS
}

.calc_limit_and_compare
{
        ; calculate limit: tmp = limit_div_8 * 8
        LDA #0
        STA tmp+1
        TYA
        ASL A
        ROL tmp + 1
        ASL A
        ROL tmp + 1
        ASL A
        ROL tmp + 1
        ASL A           ; Two more for FP rep
        ROL tmp + 1
        ASL A
        ROL tmp + 1
        STA tmp
        ; 16-bit compare agaist limit
        LDA accumulator
        CMP tmp
        LDA accumulator + 1
        SBC tmp + 1
        RTS
}

.jump_amount
    EQUB &00    ; zoom off
    EQUB &20    ; 800x600
    EQUB &10    ; 400x300
    EQUB &08    ; 200x150
    EQUB &04    ; 100x75
    EQUB &00    ; undefined zoom
    EQUB &00    ; undefined zoom
    EQUB &00    ; undefined zoom

.reset_scaler
{
        ;; Set the default scaler zoom to none
        LDA #DEFAULT_ZOOM
        STA reg_scaler_zoom

        LDA #0
        STA reg_scaler_x_speed
        STA reg_scaler_y_speed

        ;; Set the default scaler X origin to half the screen width
        LDA #0
        STA tmp
        LDA reg_x_size
        ASL A
        ROL tmp
        ASL A
        ROL tmp
        ASL A      ; Two more for FP rep
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
        ASL A      ; Two more for FP rep
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
        ; Set the clear flag in the engine, plus the cleat type
        AND #&03
        STA tmp
        LDA reg_control
        AND #&FC
        ORA tmp
        ORA #ctrl_clear
        STA reg_control
        ; Step the engine exactly once
        JSR engine_step
        ; Reset the clear flag
        LDA reg_control
        AND #&FC-ctrl_clear
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
