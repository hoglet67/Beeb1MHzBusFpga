.index_patterns
{
        ; Select the drive
        LDX #<star_drive_n
        LDY #>star_drive_n
        JSR OSCLI

        ; Set the directory to R
        LDX #<star_dir_r
        LDY #>star_dir_r
        JSR OSCLI

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

.star_dir_r
        EQUB "DIR R", 13

.star_drive_n
        EQUB "DRIVE "
}
.drive
        EQUB "0", 13


.print_metadata
{
        LDA #' '
        JSR OSWRCH
        JSR OSWRCH

        LDA #&0D              ; Set a default name/author of NULL
        STA rle_name
        STA rle_author

        TYA
        PHA

        TXA
        PHA

        LDX #&00
        STX fast_flag
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
        LDX #&80
        STX fast_flag
        JSR open_pattern
        JSR rle_next_byte       ; rle_reader expects first byte of file read
        JSR rle_reader
}

.close_pattern
{
        BIT fast_flag
        BMI fast
        LDA #&00                ; close the file
        LDY handle
        JSR OSFIND
.fast
        RTS
}

.open_pattern
{
        TAY
        LDA nameptr_lo, Y
        STA tmp
        TAX
        LDA nameptr_hi, Y
        STA tmp + 1
        TAY
        BIT fast_flag
        BMI fast
        LDA #&40
        JSR OSFIND
        CMP #&00                ; returns file handle in A, or 0 if not found
        BEQ not_found_error
        STA handle              ; save the file handle
        RTS
.fast
        JSR rle_open_fast
        BCS not_found_error
        RTS
}

.not_found_error
{
        JSR print_string
        EQUS "Not found: "
        LDY #&FF
.loop
        INY
        LDA (tmp), Y
        JSR OSASCI
        CMP #&0D
        BNE loop
        RTS
}

.read_current_directory
{

        LDA #&00
        LDX #13
.clearloop1
        STA osgbpb_block - 1, X
        DEX
        BNE clearloop1

.clearloop2
        STA filenames, X
        DEX
        BNE clearloop2

        ; Read all 31 filenames in one go
        LDA #31
        STA osgbpb_num

        ;
        LDA #<filenames
        STA osgbpb_data
        LDA #>filenames
        STA osgbpb_data + 1

        ; Read the Disc Catalog using OSGBPB A=&08
        LDA #&08
        LDX #<osgbpb_block
        LDY #>osgbpb_block
        JSR OSGBPB

        ; Extract Pointers to each string

        LDX #0 ; index into the filenames table
        LDY #0 ; index into the nameptr tables
.exloop
        LDA filenames, X    ; load the length byte
        BEQ exdone
        INX
        TXA
        STA nameptr_lo, Y   ; LSB of start of filename
        DEX
        LDA #>filenames
        STA nameptr_hi, Y   ; MSN of start of filename
        TXA
        SEC
        ADC filenames, X    ; A = X + length byte + 1
        PHA
        LDA #&0D
        STA filenames, X    ; Overwrite length byte with a &0D terminator
        PLA
        TAX                 ; X points to length byte of next filename
        INY                 ; move to next nameptr index
        BNE exloop
.exdone
        LDA #&0D
        STA filenames, X    ; Overwrite the zero length byte with a &0D terminator
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

; ==================================================
; Data
; ==================================================


.osgbpb_block

.osgbpb_handle
        EQUB 0
.osgbpb_data
        EQUD 0
.osgbpb_num
        EQUD 0
.osgbpb_sequental_ptr
        EQUD 0


        ALIGN 256

.filenames
        SKIP 256


.arrlo
.nameptr_lo
        SKIP 32

.arrhi
.nameptr_hi
        SKIP 32
