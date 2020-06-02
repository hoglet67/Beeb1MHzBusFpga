org &2900-22

guard &3C00

FASTLOAD=0

.header

        EQUS "LIFE"
        EQUW 0,0,0,0,0,0
        EQUW start
        EQUW start
        EQUW end - start

.start

include "atom_constants.asm"

include "loader.asm"

include "atom_support.asm"

.end

SAVE "", header, end
