SELECTED            = &C8  ; &FCFF selector value
REGBASE             = &00  ; &FCFE page for Registers
RAMBASE             = &80  ; &FCFE base for RAM

MAGIC_LO            = &67
MAGIC_HI            = &19

VERSION_EXPECTED    = &00

DEFAULT_ZOOM        = 0
MIN_ZOOM            = 0
MAX_ZOOM            = 4

reg_control         = &FD00
reg_speed           = &FD01
reg_status          = &FD01
reg_x_size          = &FD02
reg_y_size          = &FD03
reg_scaler_x_origin = &FD04
reg_scaler_y_origin = &FD06
reg_scaler_zoom     = &FD08
reg_scaler_x_speed  = &FD09
reg_scaler_y_speed  = &FD0A
reg_magic_lo        = &FD0C
reg_magic_hi        = &FD0D
reg_version_min     = &FD0E
reg_version_maj     = &FD0F

reg_gens            = &FD10
reg_cells           = &FD14

reg_selector    = &FCFF
reg_page_hi     = &FCFE
reg_page_lo     = &FCFD
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
last_pattern    = &7F       ; last patten on disk, used by loader
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
