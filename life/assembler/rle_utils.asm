.skip_line
{
        LDA byte
        CMP #10
        BEQ skip_whitespace
        CMP #13
        BEQ skip_whitespace
        JSR rle_next_byte
        JMP skip_line
}

.skip_whitespace
{
        LDA byte
        CMP #9
        BEQ skip
        CMP #10
        BEQ skip
        CMP #13
        BEQ skip
        CMP #32
        BEQ skip
        CMP #','                ; not strictly whitespace, but not important in rle header
        BEQ skip
        RTS
.skip
        JSR rle_next_byte
        JMP skip_whitespace
}

.parse_rle_header
{
        JSR skip_whitespace
.skip_comments
        LDA byte
        CMP #'#'
        BNE process

        JSR rle_next_byte
        LDA byte
        AND #&DF
        CMP #'N'
        BEQ save_name
        CMP #'O'
        BEQ save_author

        JSR skip_line
        JMP skip_comments

.process
        JSR skip_whitespace
        LDA byte
        CMP #'x'
        BNE not_x
        JSR parse_size
        STX pat_width
        STY pat_width + 1
        JMP process

.not_x
        CMP #'y'
        BNE not_y
        JSR parse_size
        STX pat_depth
        STY pat_depth + 1
        JMP process


.not_y
        JMP skip_line

.save_name
{
        JSR rle_next_byte
        JSR skip_whitespace
        LDX #&00
.loop
        STA rle_name, X
        INX
        JSR rle_next_byte
        LDA byte
        CMP #10
        BEQ done
        CMP #13
        BEQ done
        CPX #NAME_WIDTH
        BNE loop
        JSR skip_line
.done
        LDA #13
        STA rle_name, X
        JMP parse_rle_header
}

.save_author
{
        JSR rle_next_byte
        JSR skip_whitespace
        LDX #&00
.loop
        STA rle_author, X
        INX
        JSR rle_next_byte
        LDA byte
        CMP #10
        BEQ done
        CMP #13
        BEQ done
        CPX #NAME_WIDTH
        BNE loop
        JSR skip_line
.done
        LDA #13
        STA rle_author, X
        JMP parse_rle_header
}

}

.rle_name
        SKIP NAME_WIDTH + 1

.rle_author
        SKIP AUTHOR_WIDTH + 1

.parse_size
{
        LDA #0
        STA count
        STA count + 1
        JSR rle_next_byte
        JSR skip_whitespace
        LDA byte
        CMP #'='
        BNE return
        JSR rle_next_byte
        JSR skip_whitespace
.digit_loop
        LDA byte
        CMP #'0'
        BCC return
        CMP #'9' + 1
        BCS return
        JSR rle_next_byte
        TAX
        JSR count_times_10
        TXA
        AND #&0F
        CLC
        ADC count
        STA count
        BCC digit_loop
        INC count + 1
        JMP digit_loop
.return
        LDX count
        LDY count + 1
        RTS
}

.count_times_10
{

        ASL count               ; count *= 2
        ROL count + 1

        LDA count               ; tmp = count
        STA temp
        LDA count + 1
        STA temp + 1

        ASL count               ; count *= 4
        ROL count + 1
        ASL count
        ROL count + 1

        LDA count               ; count += tmp
        CLC
        ADC temp
        STA count
        LDA count + 1
        ADC temp + 1
        STA count + 1
        RTS
}

.rle_next_byte
{
        PHA
        TYA                     ; preserve Y
        PHA
        LDY handle
        JSR OSBGET
        BCC not_eof
        LDA #&00
.not_eof
        STA byte
        PLA
        TAY
        PLA
        RTS
}
