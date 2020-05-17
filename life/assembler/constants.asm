BASE            = &C8

reg_control     = &FCA0
reg_x_size      = &FCA1
reg_y_size      = &FCA2
reg_page_lo     = &FCFE
reg_page_hi     = &FCFF
reg_jim         = &FD00

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

NAME_WIDTH      = 30

AUTHOR_WIDTH    = 20

pat_width       = &70       ; pattern width, used by rle_reader, rle_utils and indexer
pat_depth       = &72       ; pattern depth, used by rle_reader, rle_utils and indexer
handle          = &74       ; file handle,   used by rle_reader, rle_utils and indexer
byte            = &75       ; workspace, used by rle_reader, rle_utils
xx              = &76       ; workspace, used by rle_reader, rle_utils
yy              = &78       ; workspace, used by rle_reader, rle_utils
count           = &7A       ; workspace, used by rle_reader, rle_utils
tmp             = &7C       ; short term temporary storage
last_pattern    = &7E       ; last patten on disk, used by loader
drive           = &7F       ; current drive, used by loader and indexer
multiplicand    = &80       ; used by maths code, 3 bytes
multiplier      = &83       ; used by maths code, 1 bytes
accumulator     = &84       ; used by maths code, 3 bytes
piv             = &87       ; workspace, used by quick sort
pad             = byte      ; workspace, used by quick sort
num             = tmp       ; workspace, used by quick sort

                            ; &88-&8F currently free

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
