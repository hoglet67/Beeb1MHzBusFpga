SELECTED            = &C8  ; &FCFF selector value
REGBASE             = &00  ; &FCFE page for Registers
RAMBASE             = &80  ; &FCFE base for RAM

MAGIC_LO            = &67
MAGIC_HI            = &19

VERSION_EXPECTED    = &00

DEFAULT_ZOOM        = 0
MIN_ZOOM            = 0
MAX_ZOOM            = 4

reg_control         = base_jim + &00
reg_speed           = base_jim + &01
reg_status          = base_jim + &01
reg_x_size          = base_jim + &02
reg_y_size          = base_jim + &03
reg_scaler_x_origin = base_jim + &04
reg_scaler_y_origin = base_jim + &06
reg_scaler_zoom     = base_jim + &08
reg_scaler_x_speed  = base_jim + &09
reg_scaler_y_speed  = base_jim + &0A
reg_speed_max       = base_jim + &0B
reg_magic_lo        = base_jim + &0C
reg_magic_hi        = base_jim + &0D
reg_version_min     = base_jim + &0E
reg_version_maj     = base_jim + &0F

reg_gens            = base_jim + &10
reg_cells           = base_jim + &14

reg_selector        = base_fred + &FF
reg_page_hi         = base_fred + &FE
reg_page_lo         = base_fred + &FD
reg_jim             = base_jim


ctrl_running        = &80
ctrl_mask           = &40
ctrl_clear          = &20
ctrl_border         = &10

st_running          = &80
st_vsync            = &40

PATTERN_BASE        = 'A'

TYPE_RLE            = 2
TYPE_RANDOM         = 3

NAME_WIDTH          = 30

AUTHOR_WIDTH        = 20

pat_width           = base_zp + &00       ; pattern width, used by rle_reader, rle_utils and indexer
pat_depth           = base_zp + &02       ; pattern depth, used by rle_reader, rle_utils and indexer
handle              = base_zp + &04       ; file handle,   used by rle_reader, rle_utils and indexer
byte                = base_zp + &05       ; workspace, used by rle_reader, rle_utils
xx                  = base_zp + &06       ; workspace, used by rle_reader, rle_utils
yy                  = base_zp + &08       ; workspace, used by rle_reader, rle_utils
count               = base_zp + &0A       ; workspace, used by rle_reader, rle_utils
tmp                 = base_zp + &0C       ; short term temporary storage
last_pattern        = base_zp + &0F       ; last patten on disk, used by loader
multiplicand        = base_zp + &10       ; used by maths code, 3 bytes
multiplier          = base_zp + &13       ; used by maths code, 1 bytes
accumulator         = base_zp + &14       ; used by maths code, 3 bytes
piv                 = base_zp + &17       ; workspace, used by quick sort
fast_flag           = base_zp + &18       ; workspace, used by rle_reader, rle_utils
buf_index           = base_zp + &19       ; workspace, used by rle_reader, rle_utils
filename            = base_zp + &1A       ; file name pointer, used by rle_reader, rle_utils and indexer
x_limit             = base_zp + &1C       ; size of X dimension of frame buffer
y_limit             = base_zp + &1E       ; size of Y dimension of frame buffer

pad                 = byte                ; workspace, used by quick sort
num                 = tmp                 ; workspace, used by quick sort

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
