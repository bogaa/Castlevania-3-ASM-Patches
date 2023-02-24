
bank $09
base $a000
org $bdf0
bank $09
base $a000
org $bdf0
    extraCharacterPaletteLoad:
        ldx $1d  
        lda #$01                        ; set job 
        sta $300,x 
        inx 

        ldy #$00
    -    lda palettePointerBGhelper,y     ; set PPU dest
        sta $300,x         
        iny
        inx 
        cpy #$02
        bne -
    
        inx             ; set for palette data 
        lda $3b         ; 00 = trevor our base is preocuring..!! 
        bne +
        lda $3a         ; helper 01 sympha 02 grant 03 alucard
        clc             ; move to fit with table 
        adc #$01
        asl 
        tay 

    +    lda palettePointerBGhelper,y
        sta $00
        iny
        lda palettePointerBGhelper,y
        sta $01

        ldy #$00
    -    lda ($00),y  
        sta $300,x 
        inx
        iny 
        cmp #$ff
        bne -
        
;    endextraCharacterPaletteLoad:    
        lda #$00
        sta $300,x 
        stx $1d 
        
        jsr $b8eb        ; hijack fix 
        rts 

    palettePointerBGhelper:
        dw $3eff,paletteDataBGtrevor,paletteDataBGgrant,paletteDataBGalucard,paletteDataBGsympha

    paletteDataBGtrevor:
        db $0f,$08,$26,$37,$ff
    paletteDataBGsympha:
        db $0f,$21,$11,$20,$ff
    paletteDataBGgrant:
        db $0f,$08,$15,$38,$ff
    paletteDataBGalucard:
        db $0f,$0f,$15,$36,$ff



bank $1f
if expandPRG
bank $3f
endif
base $E000

org $f567				; start transform 	

org $f56c 
		jsr extraCharacterPaletteLoad
		
		
		
;		lda #$01		; job 
;		sta $300,x 
;		inx 
;		lda #$00		; ppu dest
;		sta $300,x 
;		inx 
;		lda #$3f
;		sta $300,x 
;		inx 
;		lda #$0f		; palette data
;		sta $300,x
;		inx 
;		lda #$21		
;		sta $300,x 
;		inx 
;		lda #$11
;		sta $300,x 
;		inx
;		lda #$20
;		sta $300,x 
;		inx 
;		lda #$ff
;		sta $300,x 
;		inx 
;		lda #$00
;		sta $300,x
;		stx $1d 		; update table offst		


;bank 00
;base $8000
;org $9858
;		jsr extraCharacterPaletteLoad
;
;bank 01
;base $a000
;org $bee0
;	extraCharacterPaletteLoad:
;		jsr $ed12
;		 
;		ldx $1d  
;		lda #$01		; job 
;		sta $300,x 
;		inx 
;		lda #$00		; ppu dest
;		sta $300,x 
;		inx 
;		lda #$3f
;		sta $300,x 
;		inx 
;		lda #$0f		; palette data
;		sta $300,x
;		inx 
;		lda #$21		
;		sta $300,x 
;		inx 
;		lda #$11
;		sta $300,x 
;		inx
;		lda #$20
;		sta $300,x 
;		inx 
;		stx $1d 		; update table offst
;		
;		jsr $ed12		; close table hijack fix 
;		rts 