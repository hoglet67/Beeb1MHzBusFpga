;; ************************************************************
;; Print String
;; ************************************************************

.print_string
{
        PLA
        STA tmp
        PLA
        STA tmp + 1

        LDY #0
.loop
        INC tmp
        BNE nocarry
        INC tmp + 1
.nocarry
        LDA (tmp), Y
        BMI done
        JSR OSWRCH
        JMP loop
.done
        JMP (tmp)
}


;; ************************************************************
;; Tab to column A
;; ************************************************************

.tab_to_col
{
    STA tmp
.loop
    LDA #&86
    JSR OSBYTE
    CPX tmp
    BCS done
    LDA #' '
    JSR OSWRCH
    JMP loop
.done
    RTS
 }

;; ************************************************************
;; Print 16-bit decimal number
;; ************************************************************

;  On entry, num=number to print
;            pad=0 or pad character (eg '0' or ' ')
;  On entry at PrDec16Lp1,
;            Y=(number of digits)*2-2, eg 8 for 5 digits
;  On exit,  A,X,Y,num,pad corrupted
;  Size      69 bytes

.PrDec16
{
        LDY #8                  ; Offset to powers of ten
.PrDec16Lp1
        LDX #&FF
        SEC                     ; Start with digit=-1
.PrDec16Lp2
        LDA num+0
        SBC PrDec16Tens+0,Y
        STA num+0               ; Subtract current tens
        LDA num+1
        SBC PrDec16Tens+1,Y
        STA num+1
        INX
        BCS PrDec16Lp2          ; Loop until <0
        LDA num+0
        ADC PrDec16Tens+0,Y
        STA num+0               ; Add current tens back in
        LDA num+1
        ADC PrDec16Tens+1,Y
        STA num+1
        TXA
        BNE PrDec16Digit        ; Not zero, print it
        LDA pad
        BNE PrDec16Print
        BEQ PrDec16Next         ; pad<>0, use it
.PrDec16Digit
        LDX #'0'
        STX pad                 ; No more zero padding
        ORA #'0'                ; Print this digit
.PrDec16Print
        JSR OSWRCH
.PrDec16Next
        DEY
        DEY
        BPL PrDec16Lp1          ; Loop for next digit
        RTS

.PrDec16Tens
        EQUW 1
        EQUW 10
        EQUW 100
        EQUW 1000
        EQUW 10000
}
