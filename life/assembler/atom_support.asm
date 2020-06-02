ALIGN 256

.filenames

.file0
    EQUS    "49768M", 13

.file1
    EQUS    "ACORN", 13

.file2
    EQUS    "BLSHIP1", 13

.file3
    EQUS    "BLSTACK", 13

.file4
    EQUS    "BREEDR1", 13

.file5
    EQUS    "BREEDR2", 13

.file6
    EQUS    "BUNN9", 13

.file7
    EQUS    "DIEHARD", 13

.file8
    EQUS    "FERPRIM", 13

.file9
    EQUS    "FLYWING", 13

.file10
    EQUS    "GLIDER", 13

.file11
    EQUS    "HALFMAX", 13

.file12
    EQUS    "IGHOTEL", 13

.file13
    EQUS    "NOAHARK", 13

.file14
    EQUS    "P160DRT", 13

.file15
    EQUS    "PISHIP1", 13

.file16
    EQUS    "PUFF", 13

.file17
    EQUS    "RABBITS", 13

.file18
    EQUS    "RPENTO", 13

.file19
    EQUS    "SIRROBN", 13

.file20
    EQUS    "SPACE", 13

.file21
    EQUS    "STARGTE", 13

.file22
    EQUS    "TWINPRI", 13

.arrlo
.nameptr_lo
    EQUB <file0
    EQUB <file1
    EQUB <file2
    EQUB <file3
    EQUB <file4
    EQUB <file5
    EQUB <file6
    EQUB <file7
    EQUB <file8
    EQUB <file9
    EQUB <file10
    EQUB <file11
    EQUB <file12
    EQUB <file13
    EQUB <file14
    EQUB <file15
    EQUB <file16
    EQUB <file17
    EQUB <file18
    EQUB <file19
    EQUB <file20
    EQUB <file21
    EQUB <file22
    EQUB 0

.arrhi
.nameptr_hi
    EQUB >file0
    EQUB >file1
    EQUB >file2
    EQUB >file3
    EQUB >file4
    EQUB >file5
    EQUB >file6
    EQUB >file7
    EQUB >file8
    EQUB >file9
    EQUB >file10
    EQUB >file11
    EQUB >file12
    EQUB >file13
    EQUB >file14
    EQUB >file15
    EQUB >file16
    EQUB >file17
    EQUB >file18
    EQUB >file19
    EQUB >file20
    EQUB >file21
    EQUB >file22
    EQUB 0


;; ************************************************************
;; initialize
;; ************************************************************

.initialize
{
        LDX #0
.loop
        LDA star_cwd_n, X
        STA &0100,X
        INX
        CMP #&0D
        BNE loop
        JMP OSCLI
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
        ;; Map 0-9 to F0-F9
        CMP #'0'
        BCC exit
        CMP #'9' + 1
        BCS exit
        ADC #&50
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
        EQUS "0=clear, 1-3=random, 4=mask, 5=border, A-"
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
        EQUS 31,56,39,32,127
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
;; L oad pointers to the filenames into nameptr_lo, nameptr_hi
;; Return with Y = number of filenames
.read_current_directory
{
    LDY #(nameptr_hi - nameptr_lo - 1)
    RTS
}

.star_cwd_n
        EQUB "CWD "

;; ************************************************************
;; current drive
;; ************************************************************

.drive
        EQUB "0", 13

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

    STX osfind_block
    STY osfind_block+1

    LDX #osfind_block
    JMP OSFIND_ATOM

.close
    JMP OSSHUT_ATOM
}
