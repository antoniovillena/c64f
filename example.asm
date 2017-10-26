*       =   $0801
        .word (+), 2005  ;pointer, line number
        .null $9e, format("%d", start);will be sys 4096
+       .word 0          ;basic line end

start:  lda     #<commpressed
        sta     apd_src
        lda     #>commpressed
        sta     apd_src+1
        lda     #<uncompressed
        sta     apd_dest
        lda     #>uncompressed
        sta     apd_dest+1
        sei
        jsr     dc64f
        cli
        rts

        .include "dc64f_fast.asm"

commpressed:
        .binary  "alice1k.c64f"
uncompressed:
