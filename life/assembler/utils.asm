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


.PrDec24
        LDY #24                  ; Offset to powers of ten
        BNE PrDec

.PrDec20
        LDY #20                  ; Offset to powers of ten
        BNE PrDec

.PrDec16
        LDA #0
        STA num + 2
        LDY #16                 ; Offset to powers of ten
        BNE PrDec

.PrDec12
        LDA #0
        STA num + 2
        LDY #12                 ; Offset to powers of ten
        BNE PrDec

.PrDec8
        LDA #0
        STA num + 1
        STA num + 2
        LDY #8                  ; Offset to powers of ten

.PrDec
{
.PrDecLp1
        LDX #&FF
        SEC                     ; Start with digit=-1
.PrDecLp2
        LDA num+0
        SBC PrDecTens+0,Y
        STA num+0               ; Subtract current tens
        LDA num+1
        SBC PrDecTens+1,Y
        STA num+1
        LDA num+2
        SBC PrDecTens+2,Y
        STA num+2
        INX
        BCS PrDecLp2            ; Loop until <0
        LDA num+0
        ADC PrDecTens+0,Y
        STA num+0               ; Add current tens back in
        LDA num+1
        ADC PrDecTens+1,Y
        STA num+1
        LDA num+2
        ADC PrDecTens+2,Y
        STA num+2
        TXA
        BNE PrDecDigit          ; Not zero, print it
        LDA pad
        BNE PrDecPrint
        BEQ PrDecNext           ; pad<>0, use it
.PrDecDigit
        LDX #'0'
        STX pad                 ; No more zero padding
        ORA #'0'                ; Print this digit
.PrDecPrint
        JSR OSWRCH
.PrDecNext
        DEY
        DEY
        DEY
        DEY
        BPL PrDecLp1            ; Loop for next digit
        RTS

.PrDecTens
        EQUD 1
        EQUD 10
        EQUD 100
        EQUD 1000
        EQUD 10000
        EQUD 100000
        EQUD 1000000
        EQUD 10000000
}

;; ************************************************************
;; Print A as two hex digits
;; ************************************************************

.print_hex2
{
    PHA
    LSR A
    LSR A
    LSR A
    LSR A
    JSR hex1
    PLA
.hex1
    AND #&0F
    CMP #&0A
    BCC hex2
    ADC #&06
.hex2
    ORA #&30
    JMP OSWRCH
}

;; ************************************************************
;; 8 bit multiplier in A
;; 16-bit muliplicand in zero page X, X+1
;; ************************************************************

.multiply_8_by_16
{
    STA multiplier
    LDA 0, X
    STA multiplicand
    LDA 1, X
    STA multiplicand + 1
    LDA #0
    STA multiplicand + 2
    STA accumulator
    STA accumulator + 1
    STA accumulator + 2

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
    RTS
}
