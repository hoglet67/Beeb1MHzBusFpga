BASE            = &C8

X_WIDTH         = 1600
Y_WIDTH         = 1200

X_ORIGIN        = X_WIDTH / 2
Y_ORIGIN        = Y_WIDTH / 2

OSFIND          = &FFCE
OSGBPB          = &FFD1
OSBGET          = &FFD7
OSRDCH          = &FFE0
OSASCI          = &FFE3
OSNEWL          = &FFE7
OSWRCH          = &FFEE
OSWORD          = &FFF1
OSBYTE          = &FFF4
OSCLI           = &FFF7


PATTERN_BASE    = 'A'

TYPE_RLE        = 2
TYPE_RANDOM     = 3

NAME_WIDTH      = 20

pat_width       = &70
pat_depth       = &72
count           = &74
handle          = &76
byte            = &77

temp            = &78
xx              = &7A
yy              = &7C

ptr             = &7E

multiplicand    = &80
multiplier      = &83
accumulator     = &84

last_pattern    = &87
src             = &88
dst             = &8A
tmp             = &8C
piv             = &8E

pad             = byte
num             = temp

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
