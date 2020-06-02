; ==================================================
; Data
; ==================================================

ALIGN 256

.filenames
        SKIP 256

.arrlo
.nameptr_lo
        SKIP 32

.arrhi
.nameptr_hi
        SKIP 32

;; ************************************************************
;; initialize
;; ************************************************************

.initialize
{
        ;; Set the cursor keys to return &87-&8B
        LDA #&04
        LDX #&02
        LDY #&00
        JSR OSBYTE

        ;; Set function keys to return &80+n
        LDA #&E1
        LDX #&80
        LDY #&00
        JSR OSBYTE

        ;; Set shift-function keys to return &90+n
        LDA #&E2
        LDX #&90
        LDY #&00
        JSR OSBYTE

        ;; Flush any junk from the keyboard buffer
        LDA #&15
        LDX #&00
        JSR OSBYTE
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
        BIT &FF
        BMI escape
        LDA #&80
        LDX #&FF
        JSR OSBYTE
        CPX #&00
        BEQ exitc1
        JSR OSRDCH
        BCS escape
        CMP #&20
        BCC exitc0
        CMP #&7F
        BCS exitc0
        JSR OSWRCH
.exitc0
        CLC
        RTS

.exitc1
        SEC
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

;; ************************************************************
;; Clear display and turn off cursor
;; ************************************************************

.clear_display
{
        JSR print_string
        EQUB 22,0,23,1,0,0,0,0,0,0,0,0
        NOP
        RTS
}

;; ************************************************************
;; Display prompt
;; ************************************************************

.display_prompt
{
        JSR print_string
        EQUS 31,0,30,"CURSOR/TAB/COPY=pan, []=zoom, SPACE=stop/start, RETURN=step, <>=speed", 10, 13
        EQUS "0-3=drive, F0=clear, F1-3=random, F4=mask, F5=border, A-"
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
        EQUS 31,71,31,32,127
        NOP
        RTS
}

;; ************************************************************
;; Tab to column A
;; ************************************************************

.tab_to_col
{
    STA tmp
    TXA
    PHA
.loop
    LDA #&86
    JSR OSBYTE
    CPX tmp
    BCS done
    LDA #' '
    JSR OSWRCH
    JMP loop
.done
    PLA
    TAX
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
        ; Select the drive
        LDX #<star_drive_n
        LDY #>star_drive_n
        JSR OSCLI

        ; Set the directory to R
        LDX #<star_dir_r
        LDY #>star_dir_r
        JSR OSCLI

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
        LDA #&00
        STA nameptr_lo, Y   ; Add a null terminator to the array of filename pointers
        STA nameptr_hi, Y
        RTS

.osgbpb_block

.osgbpb_handle
        EQUB 0
.osgbpb_data
        EQUD 0
.osgbpb_num
        EQUD 0
.osgbpb_sequental_ptr
        EQUD 0

.star_dir_r
        EQUB "DIR R", 13

.star_drive_n
        EQUB "DRIVE "
}

.drive
        EQUB "0", 13
