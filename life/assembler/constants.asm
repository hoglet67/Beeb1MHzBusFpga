BASE            = &C8

X_WIDTH         = 1600
Y_WIDTH         = 1200

X_ORIGIN        = X_WIDTH / 2
Y_ORIGIN        = Y_WIDTH / 2

OSFIND          = &FFCE
OSBGET          = &FFD7
OSRDCH          = &FFE0
OSASCI          = &FFE3
OSWRCH          = &FFEE
OSWORD          = &FFF1
OSBYTE          = &FFF4


pat_width       = &70
pat_depth       = &72
count           = &74
handle          = &76
byte            = &77

temp            = &78
xx              = &7A
yy              = &7C

multiplicand    = &80
multiplier      = &83
accumulator     = &84


MACRO M_INCREMENT zp
        INC zp
        BNE nocarry
        INC zp + 1
.nocarry
ENDMACRO

MACRO M_DECREMENT zp
        LDA zp
        BNE nocarry
        DEC zp + 1
.nocarry
        DEC zp
ENDMACRO
