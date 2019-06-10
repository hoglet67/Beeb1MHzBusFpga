   org &FD00

oswrch = &ffee
osbyte = &fff4

.exit
   RTS

.input
   EQUS "OLD", 13, "RUN", 13, 0

   ;; This is called before the VDU is initialized

.reset1
   ;; Clear the interrupt reset interrupt
   STA &FD00

   ;; Use the BREAK intercept vecter to run some code later
   ;; TODO: Should we save/chain the old vector?
   LDA #&4C
   STA &0287
   LDA #<reset2
   STA &0288
   LDA #>reset2
   STA &0289
   RTS

   ;; This is run after the VDU is initialized
.reset2
   ;; C = 0 is the first call to the break intercent vector, before OSHWM is set up
   BCC exit

   ;; Clear the break intercept bector
   LDA #&00
   STA &0287

   ;; Test the break type
   LDA &028D
   BEQ exit

   ;; Insert OLD/RUN into keyboard buffer
   LDX #&00
.kbd_loop
   LDA input, X
   BEQ kbd_done
   TAY
   TXA
   PHA
   LDA #&8A
   LDX #&00
   JSR osbyte
   PLA
   TAX
   INX
   BNE kbd_loop
.kbd_done

;; TODO - Add Mandelbrot Logo

   LDX #(copy_loop_end - copy_loop - 1)
.copy_copy
   LDA copy_loop, X
   STA &900, X
   DEX
   BPL copy_copy

   LDA #&83
   JSR osbyte
   TYA         ;; destination page is OSHWM
   LDX #&0F    ;; number of pages (The "rom" is 4KB at the moment)
   LDY #&01    ;; source page in Jim

   JMP &900    ;; do the copying from RAM
               ;; otherwise we will be paged out

.copy_loop
   STY &FCFF
   LDY #&00
   STY &80
   STA &81
.loop
   LDA &FD00,Y
   STA (&80),Y
   INY
   BNE loop
   INC &81
   INC &FCFF
   DEX
   BNE loop
   LDA #&00
   STA &FCFF
   RTS
.copy_loop_end

   ;; Install the Jim reset intercept vector
   org &FDFE

   EQUW reset1

   SAVE "loader.bin",&FD00,&FE00
