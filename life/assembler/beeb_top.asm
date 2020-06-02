org &1900

guard &3000

FASTLOAD=-1

include "beeb_constants.asm"

.start

include "loader.asm"

include "beeb_support.asm"

IF FASTLOAD
include "rle_fast.asm"
ENDIF

.end

SAVE "", start, end
