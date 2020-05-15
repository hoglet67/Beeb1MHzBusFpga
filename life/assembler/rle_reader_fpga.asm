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
        JSR offset_pattern
        JSR init_yy
        JSR init_xx
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
.cells_loop
        LDA count
        ORA count + 1
        BEQ continue

        ; Set Cell at xx, yy
        JSR set_cell_in_framebuffer

        M_INCREMENT xx
        M_DECREMENT count
        JMP cells_loop

.insert_blanks
        JSR default_count
        LDA xx
        CLC
        ADC count
        STA xx
        LDA xx + 1
        ADC count + 1
        STA xx + 1
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
        JSR init_xx
        JSR zero_count
        JMP continue
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
        LDA #<X_ORIGIN          ; on exit pat_width contains the X coord to load the pattern at
        SEC
        SBC pat_width
        STA pat_width
        LDA #>X_ORIGIN
        SBC pat_width + 1
        STA pat_width + 1
        LDA #<Y_ORIGIN          ; on exit pat_depth contains the Y coord to load the pattern at
        SEC
        SBC pat_depth
        STA pat_depth
        LDA #>Y_ORIGIN
        SBC pat_depth + 1
        STA pat_depth + 1
        RTS
}

; Need to compute (yy * row_width_in_bytes) + (xx / 8)

.set_cell_in_framebuffer
{
    TXA
    PHA
    TYA
    PHA

    LDA yy
    STA multiplicand
    LDA yy + 1
    STA multiplicand + 1
    LDA #0
    STA multiplicand + 2
    STA accumulator
    STA accumulator + 1
    STA accumulator + 2
    LDA #(X_WIDTH / 8)
    STA multiplier

.loop
    LDA multiplier
    BEQ done
    LSR multiplier
    BCC next

    CLC
    LDA accumulator
    ADC multiplicand
    STA accumulator
    LDA accumulator + 1
    ADC multiplicand + 1
    STA accumulator + 1
    LDA accumulator + 2
    ADC multiplicand + 2
    STA accumulator + 2

.next
    ASL multiplicand
    ROL multiplicand + 1
    ROL multiplicand + 2
    JMP loop

.done
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

    LDA xx
    AND #&07
    TAY

    ;; Set the bit in the frame buffer
    LDA accumulator + 2
    AND #&07
    ORA #BASE
    STA &FCFF
    LDA accumulator + 1
    STA &FCFE
    LDX accumulator
    LDA &FD00,X
    ORA mask, Y
    STA &FD00,X

    PLA
    TAY
    PLA
    TAX

    RTS

.mask
    EQUB &80, &40, &20, &10, &08, &04, &02, &01
}
