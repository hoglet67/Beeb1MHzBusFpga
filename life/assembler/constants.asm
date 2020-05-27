BASE                = &C8

DEFAULT_ZOOM        = 0
MIN_ZOOM            = 0
MAX_ZOOM            = 4

reg_control         = &FCA0
reg_speed           = &FCA1
reg_status          = &FCA1
reg_x_size          = &FCA2
reg_y_size          = &FCA3
reg_scaler_x_origin = &FCA4
reg_scaler_y_origin = &FCA6
reg_scaler_zoom     = &FCA8
reg_scaler_x_speed  = &FCA9
reg_scaler_y_speed  = &FCAA

reg_page_lo     = &FCFE
reg_page_hi     = &FCFF
reg_jim         = &FD00

ctrl_running    = &80
ctrl_mask       = &40
ctrl_clear      = &20
ctrl_border     = &10

st_running      = &80
st_vsync        = &40

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
multiplicand    = &80       ; used by maths code, 3 bytes
multiplier      = &83       ; used by maths code, 1 bytes
accumulator     = &84       ; used by maths code, 3 bytes
piv             = &87       ; workspace, used by quick sort
pad             = byte      ; workspace, used by quick sort
num             = tmp       ; workspace, used by quick sort
fast_flag       = &88       ; workspace, used by rle_reader, rle_utils
buf_index       = &89       ; workspace, used by rle_reader, rle_utils
filename        = &8A       ; file name pointer, used by rle_reader, rle_utils and indexer
x_limit         = &8C       ; size of X dimension of frame buffer
y_limit         = &8E       ; size of Y dimension of frame buffer

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
