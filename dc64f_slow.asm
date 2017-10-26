        apd_bitbuffer = $f5
        apd_src       = $f6
        apd_length    = $f8
        apd_offset    = $fa
        apd_source    = $fc
        apd_dest      = $fe

incsrc  .macro
        inc     apd_src
        bne     incsr1
        inc     apd_src+1
incsr1: .endm

dc64f:  lda     #$80
        sta     apd_bitbuffer
        ldy     #0
copyby: lda     (apd_src), Y
        #incsrc
        sta     (apd_dest), y
        inc     apd_dest
        bne     mainlo
        inc     apd_dest+1
mainlo: jsr     getbit
        bcc     copyby
        sty     apd_length+1
        sty     apd_offset+1
        lda     #1
        jmp     here
lenval: jsr     getbit
        rol
        rol     apd_length+1
here:   jsr     getbit
        bcc     lenval
        adc     #0
        sta     apd_length
        beq     getbi1
        lda     (apd_src), y
        #incsrc
        asl
        bcc     offend
        pha
        lda     #%00010000
nextbi: jsr     getbit
        rol
        bcc     nextbi
        adc     #0
        lsr
        sta     apd_offset+1
        pla
offend: ror
        sec
        sbc     apd_dest
        eor     #%11111111
        sta     apd_source
        lda     apd_offset+1
        sbc     apd_dest+1
        eor     #%11111111
        sta     apd_source+1
        ldx     apd_length
        beq     loop2
loop1:  lda     (apd_source), y
        sta     (apd_dest), y
        iny
        dex
        bne     loop1
        inc     apd_source+1
        inc     apd_dest+1
loop2:  dec     apd_length+1
        bpl     loop1
        tya
        ldy     #0
        adc     apd_dest
        sta     apd_dest
        bcs     mainlo
        dec     apd_dest+1
        jmp     mainlo

getbit: asl     apd_bitbuffer
        bne     getbi1
        tax
        lda     (apd_src), Y
        #incsrc
        rol
        sta     apd_bitbuffer
        txa
getbi1: rts
