.rle_next_byte_fast
{
        LDY buf_index
        BNE read

        TXA
        PHA
        LDA #&7F
        LDX #<osword7f_block
        LDY #>osword7f_block
        JSR OSWORD

        LDA sector_num
        CLC
        ADC #&01
        CMP #&0A
        BCC save_sector
        INC track_num
        LDA #&00
.save_sector
        STA sector_num
        PLA
        TAX
        LDY #&00

.read
        LDA buffer, Y
        INY
        STY buf_index
        STA byte
        PLA
        TAY
        PLA
        RTS
}

.load_catalog
{
        LDA drive
        AND #&03
        STA block
        LDA #&7F
        LDX #<block
        LDY #>block
        JMP OSWORD
.block
        EQUB &00    ; drive number
        EQUD catalog
        EQUB &03
        EQUB &53
        EQUB &00    ; track num
        EQUB &00    ; sector num
        EQUB &22    ; 2 sectors of 256 bytes
        EQUB &00    ; result
}


;; Called with tmp pointing to the filename
;;
;; This is quite rough at the moment:
;; - catalog re-loaded every time
;; - directory ignored in matching
;; - no error checking
;; - file is read until a zero is found

.rle_open_fast
{
        ;; Load the catalog
        JSR load_catalog

        ;; Find the catalog entry for the file
        LDX #&08
.loop1
        DEX
        LDY #&FF
.loop2
        INX
        INY
        CPY #&07
        BEQ found
        LDA (filename), Y
        CMP catalog, X
        BEQ loop2
        TXA
        CLC
        ADC #&08
        AND #&F8
        TAX
        CMP catalog + &105 ; Number of files on disk  (*8)
        BEQ loop1
        BCC loop1

        ;; Not found: return with carry set
        RTS

        ;; The start sector is stored at &106, X and &107, X
        ;; Convert this to sector and track requires mod/div 10 by repeated subtraction
.found
        LDA drive
        AND #&03
        STA drive_num

        LDA #0
        STA track_num
        STA buf_index

        TXA
        AND #&F8
        TAX
        LDA catalog + &106, X
        AND #&03
        STA tmp + 1
        LDA catalog + &107, X
        STA tmp
        LDA tmp + 1
.calc
        BNE not_zero
        LDA tmp
        CMP #10
        BCC done
.not_zero
        INC track_num
        SEC
        LDA tmp
        SBC #10
        STA tmp
        LDA tmp + 1
        SBC #0
        STA tmp + 1
        BPL calc    ; jump always
.done
        STA sector_num

        ; Found: return with carry clear
        CLC
        RTS
}

.osword7f_block
.drive_num
        EQUB 0      ; drive number, FIX
        EQUD buffer
        EQUB &03
        EQUB &53
.track_num
        EQUB &03    ; track
.sector_num
        EQUB &08    ; sector
        EQUB &21    ; 1 sector of 256 bytes
        EQUB &00    ; result

        ;; Align buffers on 256 byte boundary
        ALIGN &100

        ;; 2 sector catalog buffer
.catalog
        SKIP &200


        ;; 1 sector pattern buffer
.buffer
        SKIP &100
