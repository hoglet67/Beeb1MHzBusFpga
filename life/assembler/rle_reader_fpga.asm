;; ************************************************************
;; rle_reader()
;; ************************************************************
;;
;; This version writes to the FPGA 1MHz Bus
;;
;; params
;; - handle = open file handle for raw RLE data

.rle_reader
{
        JSR parse_rle_header

        LDA #REGBASE            ; page in the registers
        STA reg_page_hi

        JSR offset_pattern      ; uses registers
        JSR calc_fb_limits      ; uses registers

        JSR init_yy
        JSR wrap_yy
        JSR init_xx
        JSR wrap_xx
        JSR zero_count
.loop
        LDA byte
        BEQ done
        CMP #'!'
        BEQ done
        CMP #' '                ; skip over white space
        BEQ continue
        CMP #10                 ; skip over <NL>
        BEQ continue
        CMP #13                 ; skip over <CR>
        BEQ continue
        CMP #'0'                ; RLE count
        BCC not_digit
        CMP #'9'+1
        BCC digit
.not_digit
        CMP #'b'                ; dead cell
        BEQ insert_blanks
        CMP #'o'                ; live cell
        BEQ insert_cells
        CMP #'$'                ; end of line
        BEQ insert_eols

        ;; probably an error, but continue anyway....

.continue
        JSR rle_next_byte
        JMP loop

.done
        LDA #REGBASE            ; page in the registers
        STA reg_page_hi
        RTS

.digit
        AND #&0F
        TAX
        JSR count_times_10      ; othewise multiply by 10
        TXA
        CLC
        ADC count               ; and add the digit
        STA count
        LDA count + 1
        ADC #0
        STA count + 1
        JMP continue

.insert_cells
        JSR default_count

.cells_loop1
        ; Calculate the FB address of xx,yy and set the paging registers appropriately
        JSR set_framebuffer_address

.cells_loop2
        LDA count
        ORA count + 1
        BEQ continue

        ; Set Cell at xx, yy; increment the framebuffer address
        JSR set_cell_in_framebuffer

        M_INCREMENT xx
        M_DECREMENT count

        ; Ensure X stays within the bounds, as efficiently as possible
        LDA xx
        CMP x_limit
        LDA xx + 1
        SBC x_limit + 1
        BCC cells_loop2
        LDA #0
        STA xx
        STA xx + 1

        JMP cells_loop1

.insert_blanks
        JSR default_count
        LDA xx
        CLC
        ADC count
        STA xx
        LDA xx + 1
        ADC count + 1
        STA xx + 1
        JSR wrap_xx
        JSR zero_count
        JMP continue

.insert_eols
        JSR default_count
        LDA yy
        CLC
        ADC count
        STA yy
        LDA yy + 1
        ADC count + 1
        STA yy + 1
        ;; need to wrap yy at reg_y_size (==1200/8 in 1600x1200 mode)
        JSR wrap_yy
        JSR init_xx
        JSR wrap_xx
        JSR zero_count
        JMP continue
}

.wrap_xx
{
        ; Is xx <= 0
        BIT xx + 1
        ; Yes, then correct
        BMI add_limit
        ; Is xx >= FB width
        LDA xx
        CMP x_limit
        LDA xx + 1
        SBC x_limit + 1
        ; Yes, the correct
        BCS sub_limit
        RTS
.sub_limit
        ;; Correct by subtracting FB width from xx
        LDA xx
        SBC x_limit
        STA xx
        LDA xx + 1
        SBC x_limit + 1
        STA xx + 1
        ;; Loop back in case further correction is needed
        JMP wrap_xx
.add_limit
        ; Correct by adding FB width to xx
        LDA xx
        CLC
        ADC x_limit
        STA xx
        LDA xx + 1
        ADC x_limit + 1
        STA xx + 1
        ;; Loop back in case further correction is needed
        JMP wrap_xx
}

.wrap_yy
{
        ; Is yy <= 0
        BIT yy + 1
        ; Yes, then correct
        BMI add_limit
        ; Is yy >= FB height
        LDA yy
        CMP y_limit
        LDA yy + 1
        SBC y_limit + 1
        ; Yes, the correct
        BCS sub_limit
        RTS
.sub_limit
        ;; Correct by subtracting FB height from yy
        LDA yy
        SBC y_limit
        STA yy
        LDA yy + 1
        SBC y_limit + 1
        STA yy + 1
        ;; Loop back in case further correction is needed
        JMP wrap_yy
.add_limit
        ; Correct by adding FB height to yy
        LDA yy
        CLC
        ADC y_limit
        STA yy
        LDA yy + 1
        ADC y_limit + 1
        STA yy + 1
        ;; Loop back in case further correction is needed
        JMP wrap_yy
}

.calc_fb_limits
{
        LDA reg_x_size
        JSR multiply_by_8
        LDA tmp
        STA x_limit
        LDA tmp + 1
        STA x_limit +1
        LDA reg_y_size
        JSR multiply_by_8
        LDA tmp
        STA y_limit
        LDA tmp + 1
        STA y_limit +1
        RTS
}

.init_xx
{
        LDA pat_width           ; pat_width holds the x coord to load at
        STA xx
        LDA pat_width + 1
        STA xx + 1
        RTS
}

.init_yy
{
        LDA pat_depth           ; pat_depth holds the y coord to load at
        STA yy
        lda pat_depth + 1
        STA yy + 1
        RTS
}

.zero_count
{
        LDA #0
        STA count
        STA count + 1
        RTS
}

.default_count
{
        LDA count               ; test if count still zero
        ORA count + 1
        BNE return
        LDA #1                  ; if so, default to 1
        STA count
.return
        RTS
}

.offset_pattern
{
        LSR pat_width + 1       ; divide the pattern size in half
        ROR pat_width
        LSR pat_depth + 1
        ROR pat_depth

        ;; x_origin is 11.2 FP format
        LDA reg_scaler_x_origin
        STA tmp
        LDA reg_scaler_x_origin + 1
        LSR A
        ROR tmp
        LSR A
        ROR tmp
        STA tmp+1

        LDA tmp                 ; on exit pat_width contains the X coord to load the pattern at
        SEC
        SBC pat_width
        STA pat_width
        LDA tmp + 1
        SBC pat_width + 1
        STA pat_width + 1

        ;; y_origin is 11.2 FP format
        LDA reg_scaler_y_origin
        STA tmp
        LDA reg_scaler_y_origin + 1
        LSR A
        ROR tmp
        LSR A
        ROR tmp
        STA tmp+1

        LDA tmp                 ; on exit pat_depth contains the Y coord to load the pattern at
        SEC
        SBC pat_depth
        STA pat_depth
        LDA tmp + 1
        SBC pat_depth + 1
        STA pat_depth + 1
        RTS
}

.multiply_by_8
{
        STA tmp
        LDA #0
        STA tmp + 1
        ASL tmp
        ROL tmp + 1
        ASL tmp
        ROL tmp + 1
        ASL tmp
        ROL tmp + 1
        RTS
}

; Compute (yy * row_width_in_bytes) + (xx / 8) and set the paging registers

.set_framebuffer_address
{
    TXA
    PHA

    LDA #REGBASE            ; page in the registers
    STA reg_page_hi

    LDA reg_x_size
    LDX #yy
    JSR multiply_8_by_16

    ;; accumulator += x/8
    LDA xx
    STA multiplicand
    LDA xx + 1
    STA multiplicand + 1
    LSR multiplicand + 1
    ROR multiplicand
    LSR multiplicand + 1
    ROR multiplicand
    LSR multiplicand + 1
    ROR multiplicand
    CLC
    LDA accumulator
    ADC multiplicand
    STA accumulator
    LDA accumulator + 1
    ADC multiplicand + 1
    STA accumulator + 1
    LDA accumulator + 2
    ADC #0
    STA accumulator + 2

    LDA accumulator + 2
    AND #&07
    ORA #RAMBASE
    STA reg_page_hi
    LDA accumulator + 1
    STA reg_page_lo

    PLA
    TAX
    RTS
}

.set_cell_in_framebuffer
{
    TXA
    PHA

    LDA xx
    AND #&07
    TAY

    LDX accumulator
    LDA reg_jim, X
    ORA mask, Y
    STA reg_jim, X

    CPY #7
    BNE exit
    INC accumulator
    BNE exit
    CLC
    LDA accumulator + 1
    ADC #1
    STA accumulator + 1
    STA reg_page_lo
    BCC exit
    LDA accumulator + 2
    ADC #0
    STA accumulator + 2
    STA reg_page_hi

.exit
    PLA
    TAX
    RTS

.mask
    EQUB &80, &40, &20, &10, &08, &04, &02, &01
}
