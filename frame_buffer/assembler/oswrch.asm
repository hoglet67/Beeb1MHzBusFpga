wrcvec         = &020E

tmp            = &80
blit_ptr       = &80
cursor_x       = &82
cursor_y       = &83


blit_len       = 22

bl_src_addr    = &FD00
bl_src_xinc    = &FD04
bl_src_yinc    = &FD06
bl_dst_addr    = &FD08
bl_dst_xinc    = &FD0C
bl_dst_yinc    = &FD0E
bl_xcount      = &FD10
bl_ycount      = &FD12
bl_param       = &FD14
bl_op          = &FD15
bl_status      = &FD1C


org &2800

.start

.init
    LDA wrcvec
    CMP #LO(oswrch)
    BNE revector
    LDA wrcvec+1
    CMP #HI(oswrch)
    BNE revector
    RTS

.revector
    LDA wrcvec
    STA oldwrcvec
    LDA #LO(oswrch)
    STA wrcvec
    LDA wrcvec + 1
    STA oldwrcvec + 1
    LDA #HI(oswrch)
    STA wrcvec + 1
    RTS

.oswrch
    PHA
    TXA
    PHA
    TYA
    PHA
    TSX
    LDA &103,X

    CMP #&20
    BCC vdu_control

    CMP #&7F
    BCS vdu_control

    JSR vdu_char
    JSR cursor_right

.oswrchexit
    PLA
    TAY
    PLA
    TAX
    PLA
    JMP (oldwrcvec)

.vdu_control
    CMP #&08
    BEQ vdu_08
    CMP #&09
    BEQ vdu_09
    CMP #&0A
    BEQ vdu_0a
    CMP #&0B
    BEQ vdu_0b
    CMP #&0C
    BEQ vdu_0c
    CMP #&0D
    BEQ vdu_0d
    CMP #&1E
    BEQ vdu_1e
    CMP #&7F
    BNE oswrchexit

.vdu_7f
    JSR cursor_left
    LDA #&20
    JSR vdu_char
    JMP oswrchexit

.vdu_08
    JSR cursor_left
    JMP oswrchexit

.vdu_09
    JSR cursor_right
    JMP oswrchexit

.vdu_0a
    JSR cursor_down
    JMP oswrchexit

.vdu_0b
    JSR cursor_up
    JMP oswrchexit

.vdu_0c
    LDX #LO(blit_clear)
    LDY #HI(blit_clear)
    JSR blit

.vdu_1e
    LDA #0
    STA cursor_x
    STA cursor_y
    JMP oswrchexit

.vdu_0d
    JSR cursor_sol
    JMP oswrchexit

    ;; Unrolled/Optimised version of blit for chars
    ;; 125 cycles rather than 432 cycles

.vdu_char
{
    LDX #&C7                    ; 2
    STX &FCFF                   ; 6
    LDX #&FF                    ; 2
    STX &FCFE                   ; 6
;; Wait for Blitter to become free
.loop
    LDX bl_status               ; 6
    BNE loop                    ; 2
    STA bl_param                ; 6 = 30

;; bl_dst_addr = 8192 * cursor_y + 8 * cursor_x
    LDA cursor_x                ; 3
    ASL A                       ; 2
    ASL A                       ; 2
    ASL A                       ; 2
    STA bl_dst_addr             ; 6
    LDA cursor_x                ; 3
    AND #&60                    ; 2
    STA tmp                     ; 3
    LDA cursor_y                ; 3
    AND #&07                    ; 2
    ASL A                       ; 2
    ORA tmp                     ; 3
    ROL A                       ; 2
    ROL A                       ; 2
    ROL A                       ; 2
    ROL A                       ; 2
    STA bl_dst_addr + 1         ; 6
    LDA cursor_y                ; 3
    LSR A                       ; 2
    LSR A                       ; 2
    LSR A                       ; 2
    STA bl_dst_addr + 2         ; 6 = 62

    LDA #4                      ; 2
    LDX #0                      ; 2
    LDY #1                      ; 2
    STY bl_dst_xinc      ; &01  ; 6
    STX bl_dst_xinc + 1  ; &00  ; 6
    STX bl_dst_yinc      ; &00  ; 6
    STA bl_dst_yinc + 1  ; &04  ; 6
    LDA #7                      ; 2
    STA bl_xcount        ; &07  ; 6
    STX bl_xcount + 1    ; &00  ; 6
    STA bl_ycount        ; &07  ; 6
    STX bl_ycount + 1    ; &00  ; 6
    STY bl_op            ; &01  ; 6
    RTS                         ; 6 = 68
                                ; ---
                                ; 160
                                ; ---
}

.cursor_left
{
    ;; Are we in the left most column?
    LDA cursor_x
    BNE left

    JSR cursor_up
    JMP cursor_eol

.left
    ;; Move the cursor 1 character to the left
    DEC cursor_x
    RTS
}

.cursor_right
{
    ;; Are we in the right most column?
    LDA cursor_x
    CMP #79
    BNE right

    JSR cursor_down
    JMP cursor_sol

.right
    ;; Move the cursor 1 character to the right
    INC cursor_x
    RTS
}

.cursor_up
{
    ;; Are we on the top line of the screen?
    LDA cursor_y
    BNE up

.scroll
    ;; Scroll the screen, leaving the cursor in the same place
    LDX #LO(blit_scroll_down)
    LDY #HI(blit_scroll_down)
    JSR blit
    LDX #LO(blit_clear_top)
    LDY #HI(blit_clear_top)
    JMP blit

.up
    DEC cursor_y
    RTS
}

.cursor_down
{
    ;; Are we on the bottom line of the screen?
    LDA cursor_y
    CMP #59
    BNE down

.scroll
    ;; Scroll the screen, leaving the cursor in the same place
    LDX #LO(blit_scroll_up)
    LDY #HI(blit_scroll_up)
    JSR blit
    LDX #LO(blit_clear_bottom)
    LDY #HI(blit_clear_bottom)
    JMP blit

.down
    INC cursor_y
    RTS
}


.cursor_sol
{
    LDA #0
    STA cursor_x
    RTS
}

.cursor_eol
{
    LDA #79
    STA cursor_x
    RTS
}

.blit
{
    STX blit_ptr        ; 3
    STY blit_ptr + 1    ; 3
    LDA #&C7            ; 2
    STA &FCFF           ; 6
    LDA #&FF            ; 2
    STA &FCFE           ; 6

;; Wait for Blitter to become free
.loop1
    LDA bl_status       ; 6
    BNE loop1           ; 2

;; Write the Blitter Block
    LDY #&00            ; 2
.loop2
    LDA (blit_ptr), Y   ; 5
    STA &FD00,Y         ; 6
    INY                 ; 2
    CPY #blit_len       ; 2
    BNE loop2           ; 3 x 22

    RTS                 ; 6
                        ; ---
                        ; 432
                        ; ---
}

.oldwrcvec
    EQUW &0000

.blit_clear
    EQUD &00000000 ; bl_src_addr (unused)
    EQUW &0000     ; bl_src_xinc (unused)
    EQUW &0000     ; bl_src_yinc (unused)
    EQUD &00000000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 480-1     ; bl_ycount
    EQUB &00       ; bl_param = block
    EQUB &00       ; bl_op    = fill_op

.blit_clear_top
    EQUD &00000000 ; bl_src_addr (unused)
    EQUW &0000     ; bl_src_xinc (unused)
    EQUW &0000     ; bl_src_yinc (unused)
    EQUD &00000000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 8-1       ; bl_ycount
    EQUB &00       ; bl_param = block
    EQUB &00       ; bl_op    = fill_op

.blit_clear_bottom
    EQUD &00000000 ; bl_src_addr (unused)
    EQUW &0000     ; bl_src_xinc (unused)
    EQUW &0000     ; bl_src_yinc (unused)
    EQUD &00076000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 8-1       ; bl_ycount
    EQUB &00       ; bl_param = block
    EQUB &00       ; bl_op    = fill_op

.blit_scroll_up
    EQUD &00002000 ; bl_src_addr
    EQUW &0001     ; bl_src_xinc
    EQUW &0400     ; bl_src_yinc
    EQUD &00000000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 472-1     ; bl_ycount
    EQUB &FF       ; bl_param = mask
    EQUB &FF       ; bl_op    = copy_op

.blit_scroll_down
    EQUD &00075E7F ; bl_src_addr
    EQUW &FFFF     ; bl_src_xinc
    EQUW &FC00     ; bl_src_yinc
    EQUD &00077E7F ; bl_dst_addr (bottom right)
    EQUW &FFFF     ; bl_dst_xinc
    EQUW &FC00     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 472-1     ; bl_ycount
    EQUB &FF       ; bl_param = mask
    EQUB &FF       ; bl_op    = copy_op

.end

SAVE "oswrch", start, end
