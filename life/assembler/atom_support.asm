ALIGN 256

.filenames

SKIP 256

.arrlo
.nameptr_lo

SKIP 64

.arrhi
.nameptr_hi

SKIP 64

.d_filename

SKIP 32

;; ************************************************************
;; initialize
;; ************************************************************

.initialize
{
        ;; Check for the GODIL
        LDA godil + &0F
        AND #&F0
        CMP #&10
        BNE bad1

        ;; Check for VGA80 mode
        LDA godil + &00
        BPL bad2

        RTS

.bad1
        JSR print_string
        EQUS "ERROR: GODIL REQUIRED", 13
        NOP
        PLA
        PLA
        RTS

.bad2
        JSR print_string
        EQUS "ERROR: GODIL VGA80 MODE REQUIRED", 13
        NOP
        PLA
        PLA
        RTS
}

;; ************************************************************
;; read_key
;; ************************************************************

;; Poll keyboard
;;
;; On exit:
;;    If no key pressed, return C=1
;;    If a key is pressed, return C=0 and A=ASCII of key
;;
;; if escape is detected, then pop an address from the stack and return
.read_key
{
        LDA #&20
        BIT &B001
        BEQ escape

        JSR &FE71
        BCS released

        CPY last_key    ; is last key still pressed
        BEQ exitc1
        STY last_key

        TYA
        JSR map_key

        CMP #&20
        BCC exitc0
        CMP #&7F
        BCS exitc0
        JSR OSWRCH
.exitc0
        CLC
        RTS

.released
        LDA #&FF
        STA last_key
.exitc1
        SEC
        RTS

.escape
        LDA #&0C
        JSR OSWRCH
        PLA
        PLA
        RTS
}

.map_key
{
        ;; Pass return through
        CMP #&0D
        BEQ exit
        ;; Map         LR cursor to &8D (right)
        ;; Map Shift + LR cursor to &8C (left)
        CMP #&06
        BNE not_lr
        LDA #&8D
        JMP combine_shift_ctrl
.not_lr
        ;; Map         UD cursor to &8F (up)
        ;; Map Shift + UD cursor to &8E (down)
        CMP #&07
        BNE not_ud
        LDA #&8F
        JMP combine_shift_ctrl
.not_ud
        ;; Map copy to &8B (up)
        CMP #&0E
        BNE not_copy
        LDA #&8B
        RTS
.not_copy
        ;; Map lock to &09 (tab)
        CMP #&05
        BNE not_lock
        LDA #&09
        RTS
.not_lock
        ;; Map [
        CMP #&01
        BNE not_zin
        LDA #'['
        RTS
.not_zin
        ;; Map ]
        CMP #&03
        BNE not_zout
        LDA #']'
        RTS
.not_zout
        ;; Correct to ASCII by adding &20
        CLC
        ADC #&20
        ;; Map 4-9 (&34-&39) to F0-F5 (&80-&85)
        CMP #'4'
        BCC exit
        CMP #'9' + 1
        BCS exit
        ADC #&4C
.exit
        RTS
}

; Toggle bit 0 if shift is pressed
; Toggle bit 4 if ctrl is pressed
.combine_shift_ctrl
{
        BIT &B001
        BMI not_shift
        EOR #&01
.not_shift
        BVS not_ctrl
        EOR #&10
.not_ctrl
        RTS
}

;; ************************************************************
;; Clear display and turn off cursor
;; ************************************************************

.clear_display
{
        LDA #12
        JSR OSWRCH
        LDY &E0
        LDA (&DE),Y
        EOR &E1
        STA (&DE),Y
        LDA #&00
        STA &E1
        RTS
}

;; ************************************************************
;; Display prompt
;; ************************************************************

.display_prompt
{
        JSR print_string
        EQUS 31,0,38,"CURSOR/LOCK/COPY=pan, []=zoom, SPACE=stop/start, RETURN=step, <>=speed", 10, 13
        EQUS "0-3=drive, 4=clear, 5-7=random, 8=mask, 9=border, A-"
        NOP

        LDA last_pattern
        JSR OSWRCH

        JSR print_string
        EQUS "=load pattern:"
        NOP
        RTS
}

;; ************************************************************
;; Tab to prompt
;; ************************************************************
.tab_to_prompt
{
        JSR print_string
        EQUS 31,67,39,32,127
        NOP
        RTS
}

;; ************************************************************
;; Tab to column A
;; ************************************************************

.tab_to_col
{
        STA &E0
        RTS
}

;; ************************************************************
;; read_current_directory
;; ************************************************************

;; Select the drive/directory
;; Load pointers to the filenames into nameptr_lo, nameptr_hi
;; Return with Y = number of filenames
.read_current_directory
{
        ;; Save the old value of OSWRCH
        LDA WRCVEC
        PHA
        LDA WRCVEC + 1
        PHA

        ;; Update OSWRCH to point to capture_cat
        LDA #<capture_cat
        STA WRCVEC
        LDA #>capture_cat
        STA WRCVEC + 1

        ;; Initialize all the working variables
        LDX #0
        STX file_count
        STX file_ptr
        STX file_base
        STX file_state

        ;; *CAT <N>
.loop
        LDA star_cat_n, X
        STA &0100,X
        INX
        CMP #&0D
        BNE loop
        JSR OSCLI

        ;; Restore the old value of WRCVEC
        PLA
        STA WRCVEC + 1
        PLA
        STA WRCVEC

        ;; Load return values
        LDY file_count
        LDA #0
        STA nameptr_lo, Y
        STA nameptr_hi, Y
        RTS
}

;; Currently this uses a 256b block of memory for filenames
;; (i.e. keep the number of files per RLE folder less than 32)
.capture_cat
{
        PHA
        TXA
        PHA
        TSX
        LDA &0102,X

        ;; Always ignore line feed
        CMP #&0A
        BEQ exit

        BIT file_state
        BMI skipping

        ;; If we encounter a < character skip this as a directory
        CMP #'<'
        BEQ skip_directory

        ;; Save the filename
        LDX file_ptr
        STA filenames, X
        INX
        STX file_ptr

        ;; Have we reached the end?
        CMP #&0D
        BNE exit

        ;; Add the filename into the list
        LDX file_count
        LDA file_base
        STA nameptr_lo, X
        LDA #>filenames
        STA nameptr_hi, X
        INX
        STX file_count
        LDX file_ptr
        STX file_base
        BNE exit

.skip_directory
        LDA #&80
        STA file_state

.skipping
        CMP #&0D
        BNE exit
        LDA #&00
        STA file_state

.exit
        PLA
        TAX
        PLA
        RTS
}

.star_cat_n
        EQUS "CAT "

;; ************************************************************
;; Current "drive"
;; ************************************************************

.drive
        EQUS "0", 13

;; ************************************************************
;; OSFIND
;; ************************************************************

.OSFIND
{
    CMP #0
    BEQ close

    ; #40 -> C=1 for reading
    ; #80 -> C=0 for writing

    EOR #&80
    ASL A

    PHA

    ;; Construct a file name with the RLE folder pre-pended
    ;; e.g. 0/NOAHARK
    STX osfind_block
    STY osfind_block + 1
    LDA drive
    STA d_filename
    LDA #'/'
    STA d_filename + 1
    LDY #0
.loop
    LDA (osfind_block), Y
    STA d_filename + 2, Y
    INY
    CMP #&0D
    BNE loop

    LDA #<d_filename
    STA osfind_block
    LDA #>d_filename
    STA osfind_block + 1

    PLA

    LDX #osfind_block
    JMP OSFIND_ATOM

.close
    JMP OSSHUT_ATOM
}
