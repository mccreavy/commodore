        ; Simple Character-based (non-smooth) Scroller.
	; Nothing fancy; busy waiting.
	; http://mccreavy.com/1415/commodore-64-simple-text-scrolling
	processor 6502
        org $c000


start:
        jsr shift
        jsr place_next_char
        jsr wait_a_sec
        jmp start

shift:                          ; Scroll the line to the right by one char
        lda #$01
        sta $fb
        lda #$04
        sta $fc
        lda #$00
        sta $fd
        lda #$04
        sta $fe
        ldy #$00
shift_loop:
        lda ($fb),y
        sta ($fd),y
        iny
        cpy #$27
        bne shift_loop
        rts

place_next_char:                ; Stick some data at the end of the line
        lda #<data
        sta $fb
        lda #>data
        sta $fc
load_it:
        ldy next_char
        lda ($fb),y
        cmp #$00
        bne place_it
        lda #$00
        sta next_char
        jmp load_it
place_it:
        sta $0427
        clc
        iny
        sty next_char
        rts
next_char:
        dc.b $00
data:
        dc.b $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$00

wait_a_sec:                     ; Stupid busy wait
        ldx #$8F
busy_loop_1:
        ldy #$FF
busy_loop_2:
        dey
        bne busy_loop_2
        dex
        bne busy_loop_1
        rts

