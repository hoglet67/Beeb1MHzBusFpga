.index_patterns
{
        JSR read_current_directory

        LDX #0   ; X is index of the lowest element
        DEY      ; Y is index of the highest element

        BMI prnone  ; exit with C=1 if no patterns

        ; Push the letter of the last pattern (as the return value)
        TYA
        CLC
        ADC #'A'
        PHA

        ;; Set the sort comparator
        LDA #<strcmp
        STA comp + 1
        LDA #>strcmp
        STA comp + 2

        ; Sort them alphabetically
        JSR quicksort

        ; Print them out
        LDX #0
.prloop1
        LDA nameptr_lo, X
        STA tmp
        LDA nameptr_hi, X
        STA tmp + 1
        ORA tmp
        BEQ prdone

        TXA
        CLC
        ADC #'A'
        JSR OSWRCH
        LDA #'.'
        JSR OSWRCH
        LDA #' '
        JSR OSWRCH

        LDY #&00
.prloop2
        LDA (tmp), Y
        CMP #&0D
        BEQ prmeta
        JSR OSWRCH
        INY
        BNE prloop2

.prmeta
        JSR print_metadata

        ; Next filename
        INX
        BNE prloop1
.prdone
        PLA
        CLC
        RTS
.prnone
        SEC
        RTS

}

.print_metadata
{
        LDA #12
        JSR tab_to_col

        LDA #&0D              ; Set a default name/author of NULL
        STA rle_name
        STA rle_author

        TYA
        PHA

        TXA
        PHA

IF FASTLOAD
        LDX #&00
        STX fast_flag
ENDIF
        JSR open_pattern      ; Pass filename index in A

        JSR rle_next_byte
        JSR parse_rle_header  ; Parse the header to extract the name

        JSR close_pattern     ; close the RLE file


        LDX #&00
.loop1
        LDA rle_name, X
        CMP #&0D
        BEQ done1
        JSR OSWRCH
        INX
        BNE loop1
.done1

        LDA #50
        JSR tab_to_col

        LDX #&00
.loop2
        LDA rle_author, X
        CMP #&0D
        BEQ done2
        JSR OSWRCH
        INX
        BNE loop2
.done2

        LDA #70
        JSR tab_to_col
        LDA pat_width
        STA num
        LDA pat_width + 1
        STA num + 1
        LDA #' '
        STA pad
        JSR PrDec16

        LDA #75
        JSR tab_to_col
        LDA pat_depth
        STA num
        LDA pat_depth + 1
        STA num + 1
        LDA #' '
        STA pad
        JSR PrDec16

        PLA
        TAX
        PLA
        TAY
        RTS
}


.load_pattern
{
        SEC
        SBC #'A'
IF FASTLOAD
        LDX #&80
        STX fast_flag
ENDIF
        JSR open_pattern
        JSR rle_next_byte       ; rle_reader expects first byte of file read
        JSR rle_reader
}

.close_pattern
{
IF FASTLOAD
        BIT fast_flag
        BMI exit
ENDIF
        LDA #&00                ; close the file
        LDY handle
        JSR OSFIND
.exit
        RTS
}

.open_pattern
{
        TAY
        LDA nameptr_lo, Y
        STA filename
        TAX
        LDA nameptr_hi, Y
        STA filename + 1
        TAY
IF FASTLOAD
        BIT fast_flag
        BMI fast
ENDIF
        LDA #&40
        JSR OSFIND
        CMP #&00                ; returns file handle in A, or 0 if not found
        BEQ not_found_error
        STA handle              ; save the file handle
        RTS
IF FASTLOAD
.fast
        JSR rle_open_fast
        BCS not_found_error
        RTS
ENDIF
}

.not_found_error
{
        JSR print_string
        EQUB 13, 10, "Not found: "
        NOP
        LDY #&FF
.loop
        INY
        LDA (filename), Y
        JSR OSASCI
        CMP #&0D
        BNE loop
        RTS
}


; ==================================================
; http://c64os.com/post/?p=58
; X -> lo
; Y -> hi
; ==================================================
.quicksort
{
     sty tmp
     cpx tmp
     bcc sort
     rts

.sort
     tya
     pha ;Stash hi
     txa
     pha ;Stash lo

     jsr partition

     pla
     tax ;Restore lo
     tya
     pha ;Stash mid index

     beq skip ; DMB: corner case if Y=0, as it goes negative

     dey ;mid index minus 1
     jsr quicksort ;Recurse

.skip
     pla
     tax ;Restore mid index
     pla
     tay ;Restore hi

     inx ;mid index plus 1
     jmp quicksort
}

; ==================================================
; X -> lo
; Y -> hi
; Y <- mid index
; ==================================================
.partition

     lda arrlo,y
     sta piv
     lda arrhi,y
     sta piv+1

     sty chk+1
     txa
     tay
     dex

.loop
     lda arrlo,y
     sta tmp
     lda arrhi,y
     sta tmp+1

.comp
     jsr $ffff ;Comparator, self-mod
     bcs *+6
     inx
     jsr swap

     iny
.chk
     cpy #$ff ;hi, self-mod
     bne loop

     inx
     jsr swap

     txa
     tay
     rts


; ==================================================
; X -> index a
; Y -> index b
; ==================================================
.swap
{
     lda arrlo,x
     sta tmp
     lda arrhi,x
     sta tmp+1

     lda arrlo,y
     sta arrlo,x
     lda arrhi,y
     sta arrhi,x

     lda tmp
     sta arrlo,y
     lda tmp+1
     sta arrhi,y

     rts
}

; ==================================================
; tmp -> pointer to item to compare with pivot
; piv -> pointer to pivot
; ==================================================
.strcmp

{
     sty out+1
     ldy #$ff

.loop
     iny
     lda (tmp),y
     cmp (piv),y
     beq loop

.out
     ldy #$ff ;self-mod
     rts
}
