;*****************************
;* KIM-1 Banner              *
;* by Jim Zuber              *
;*    20224 Cohasset #16     *
;*    Conga Park, Ca 91306   *
;*                           *
;* Instructions:             *
;* Start the Program at      *
;* location $2000.           *
;*                           *
;* Type in the Text you want *
;* bannered in UPPER CASE.   *
;* supported letters are:    *
;*                           *
;* A-Z                       *
;* 0-9                       *
;* .:,;-+*()$                *
;* (return is treated as     *
;* space.)                   *
;*                           *
;* End your Entry with an @  *
;* hit enter and watch the   *
;* show                      *
;*****************************
    
CRLF     =       $1e2f
GETCH    =       $1e5a
OUTCH    =       $1ea0

         .org    $2000
STAR:    jmp     OVER

INV:     jmp     INPT

OUTV:    jmp     OUTC

TBLL:    .byte   $00
TBLH:    .byte   $22
PRCH:    .byte   $40
BUFL:    .byte   $50
BUFH:    .byte   $21

OVER:    cld
         ldy     #$00
         jsr     INTB
         lda     #$3e
         jsr     OUTV
         jsr     OUTV
         lda     #$0d
         jsr     OUTV
CHAR:    jsr     INV
         sta     ($02),y
         cmp     #$40
         beq     CHEK
         jsr     INCB
         jmp     CHAR

CHEK:    jsr     INTB
LOP3:    ldy     #$00
         lda     ($02),y
         cmp     #$40
         beq     OK
         sta     $04
         jsr     FDCH
         cmp     #$ff
         bne     LOP4
         lda     $04
         jsr     OUTV
         jmp     STAR

LOP4:    jsr     INCB
         jmp     LOP3

OK:      lda     #$4f
         jsr     OUTV
         lda     #$4b
         jsr     OUTV
         lda     #$0d
         jsr     OUTV
         jsr     INV
         jsr     INTB
LOP6:    ldy     #$00
         lda     ($02),y
         cmp     #$40
         bne     LOP7
         jmp     STAR

LOP7:    sta     $04
         jsr     FDCH
         jsr     PNTC
         lda     #$0d
         jsr     OUTV
         jsr     OUTV
         jsr     OUTV
         jsr     INCB
         jmp     LOP6

PNTC:    ldy     #$00
         lda     ($00),y
         cmp     #$ee
         bne     LP10
         lda     #$0d
         jsr     OUTV
         jmp     STOP

LP10:    sta     $04
         and     #$80
         bne     MARK
         ldy     $04
LP11:    lda     #$20
         jsr     OUTV
         dey
         beq     STOP
         jmp     LP11

MARK:    lda     $04
         and     #$7f
         tay
LP12:    lda     PRCH
         jsr     OUTV
         dey
         beq     STOP
         jmp     LP12

STOP:    dex
         beq     LP13
         jsr     INCP
         jmp     PNTC

LP13:    rts

FDCH:    jsr     INTP
LOP1:    ldy     #$00
         lda     ($00),y
         cmp     #$ff
         beq     OUT
         cmp     $04
         beq     OUT1
         iny
         lda     ($00),y
         clc
         adc     $00
         sta     $00
         lda     #$00
         adc     $01
         sta     $01
         jsr     INCP
         jsr     INCP
         jmp     LOP1

OUT:     rts

OUT1:    jsr     INCP
         lda     ($00),y
         tax
         jsr     INCP
         rts

INTB:    lda     BUFL
         sta     $02
         lda     BUFH
         sta     $03
         rts

INTP:    lda     TBLL
         sta     $00
         lda     TBLH
         sta     $01
         rts

INCB:    clc
         lda     $02
         adc     #$01
         sta     $02
         lda     $03
         adc     #$00
         sta     $03
         rts

INCP:    clc
         lda     $00
         adc     #$01
         sta     $00
         lda     $01
         adc     #$00
         sta     $01
         rts

INPT:    sty     $06
         jsr     GETCH
         ldy     $06
         rts

OUTC:    pha
         stx     $05
         sty     $06
         cmp     #$0d
         bne     CONT
         jsr     CRLF
         jmp     RESTOR

CONT:    jsr     OUTCH
RESTOR:  ldx     $05
         ldy     $06
         pla
         rts

