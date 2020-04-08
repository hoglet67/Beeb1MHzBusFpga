wrcvec=&020E

blit_ptr=&80
blit_len=22
blit_status=&FD1C

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
    BEQ vdu_7f

    CMP #&20
    BCC oswrchexit

    CMP #&7F
    BCS oswrchexit

    STA blit_char_param
    LDX #LO(blit_char)
    LDY #HI(blit_char)
    JSR blit
    JSR cursor_right

.oswrchexit
    PLA
    TAY
    PLA
    TAX
    PLA
    JMP (oldwrcvec)

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
    STA blit_char_addr
    STA blit_char_addr+1
    STA blit_char_addr+2
    STA blit_char_addr+3
    JMP oswrchexit

.vdu_0d
    JSR cursor_sol
    JMP oswrchexit

.vdu_7f
    JSR cursor_left
    LDA #&20
    STA blit_char_param
    LDX #LO(blit_char)
    LDY #HI(blit_char)
    JMP blit

.cursor_left
{
    ;; Are we in the left most column?
    LDA blit_char_addr
    BNE left
    LDA blit_char_addr + 1
    AND #&FC
    BNE left

    JSR cursor_up
    JMP cursor_eol

.left
    ;; Move the cursor 1 character to the left
    SEC
    LDA blit_char_addr
    SBC #&08
    STA blit_char_addr
    LDA blit_char_addr + 1
    SBC #&00
    STA blit_char_addr + 1
    RTS
}

.cursor_right
{
    ;; Are we in the right most column?
    LDA blit_char_addr
    CMP #LO(640 - 8)
    BNE right
    LDA blit_char_addr + 1
    AND #&FC
    CMP #HI(640 - 8)
    BNE right

    JSR cursor_down
    JMP cursor_sol

.right
    ;; Move the cursor 1 character to the right
    CLC
    LDA blit_char_addr
    ADC #&08
    STA blit_char_addr
    LDA blit_char_addr + 1
    ADC #&00
    STA blit_char_addr + 1
    RTS
}

.cursor_up
{
    ;; Are we on the top line of the screen?
    LDA blit_char_addr + 2
    BNE up
    LDA blit_char_addr + 1
    CMP #LO(8*1024/256)
    BCC up

.scroll
    ;; Scroll the screen, leaving the cursor in the same place
    LDX #LO(blit_scroll_down)
    LDY #HI(blit_scroll_down)
    JSR blit
    LDX #LO(blit_clear_top)
    LDY #HI(blit_clear_top)
    JMP blit

.up
    SEC
    LDA blit_char_addr + 1
    SBC #HI(8*1024)
    STA blit_char_addr + 1
    LDA blit_char_addr + 2
    SBC #&00
    STA blit_char_addr + 2
    RTS
}

.cursor_down
{
    ;; Are we on the bottom line of the screen?
    LDA blit_char_addr + 2
    CMP #HI(472*1024/256)
    BCC down
    BNE scroll
    LDA blit_char_addr + 1
    CMP #LO(472*1024/256)
    BCC down

.scroll
    ;; Scroll the screen, leaving the cursor in the same place
    LDX #LO(blit_scroll_up)
    LDY #HI(blit_scroll_up)
    JSR blit
    LDX #LO(blit_clear_bottom)
    LDY #HI(blit_clear_bottom)
    JMP blit

.down
    CLC
    LDA blit_char_addr + 1
    ADC #HI(8*1024)
    STA blit_char_addr + 1
    LDA blit_char_addr + 2
    ADC #&00
    STA blit_char_addr + 2
    RTS
}


.cursor_sol
{
    LDA #&00
    STA blit_char_addr
    LDA blit_char_addr + 1
    AND #&FC
    STA blit_char_addr + 1
    RTS
}

.cursor_eol
{
    LDA #LO(640-8)
    STA blit_char_addr
    LDA blit_char_addr + 1
    AND #&FC
    ORA #HI(640-8)
    STA blit_char_addr + 1
    RTS
}

.blit
{
    STX blit_ptr
    STY blit_ptr + 1
    LDA #&C7
    STA &FCFF
    LDA #&FF
    STA &FCFE

;; Wait for Blitter to become free
.loop1
    LDA blit_status
    BNE loop1

;; Write the Blitter Block
    LDY #&00
.loop2
    LDA (blit_ptr), Y
    STA &FD00,Y
    INY
    CPY #blit_len
    BNE loop2

    RTS
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

.blit_char
    EQUD &00000000 ; bl_src_addr (unused)
    EQUW &0000     ; bl_src_xinc (unused)
    EQUW &0000     ; bl_src_yinc (unused)
.blit_char_addr
    EQUD &00000000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 8-1       ; bl_xcount
    EQUW 8-1       ; bl_ycount
.blit_char_param
    EQUB &00       ; bl_param = block
    EQUB &01       ; bl_op    = char_op

.blit_scroll_up
    EQUD &00002000 ; bl_src_addr
    EQUW &0001     ; bl_src_xinc
    EQUW &0400     ; bl_src_yinc
    EQUD &00000000 ; bl_dst_addr (top left)
    EQUW &0001     ; bl_dst_xinc
    EQUW &0400     ; bl_dst_yinc
    EQUW 640-1     ; bl_xcount
    EQUW 472-1     ; bl_ycount
    EQUB &00       ; bl_param
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
    EQUB &00       ; bl_param
    EQUB &FF       ; bl_op    = copy_op

.end

SAVE "oswrch", start, end
