bank $00
base $8000	
org $9702
levelEffectsNextRowCheck:		;prg $1703
	ldy #$00		

nextRowCheck:
	lda roomEffects, y
	cmp #$ff					; check end of table
	beq noMatchFound

	cmp wCurrRoomGroup		
	bne toNextRowCheck			; check in what level we are to write a level effect index to RAM $7d. From there they will be executed in that section. 

	lda roomEffects+1, y	
	cmp wCurrRoomSection		; lvl 
	bne toNextRowCheck

	lda roomEffects+2, y	
	cmp wCurrRoomIdx			; stage		
	bne toNextRowCheck

	lda roomEffects+3, y	
	sta $7d			
	sec				
	rts				

toNextRowCheck:
	iny				 
	iny				
	iny				
	iny					
	bne nextRowCheck 	; @nextRowCheck

noMatchFound:
	lda #$00		
	sta $7d				; active effects in RAM	
	clc				
	rts				

; ----------------------------------------------------------------------
;    screen,block,stage,effectID	;effectID description !!TODO Better discribtions
roomEffects:				
	.db $02, $02, $01, $10			;$10 Fog 02 02 01			
	.db $02, $03, $01, $11			;$11 For 02 03 01
	.db $0e, $00, $02, $12			;$12 High Fog Stage 0e 00 02
	.db $0e, $02, $00, $13			;$13 Low Fog Stage 0e 02 00
	.db $02, $00, $01, $20			;$40 Animation Only,
	.db $0c, $01, $01, $23			;$23 0c 01 01 ??
	.db $05, $01, $00, $30			;$28 Blinking sprites 
	.db $0d, $03, $00, $31			;$30 Animation and Sound 05 01 00
	.db $01, $00, $00, $40			;$31 Water animation 0d 03 00 
	.db $01, $01, $00, $40			;$32 WaterEffect(flicker) -36
	.db $01, $01, $01, $40			;$33 06 00 00 Mud
	.db $01, $01, $02, $40			;$34 06 01 00
	.db $01, $02, $00, $40			;$35 06 01 01
	.db $01, $02, $01, $40			;$37 06 01 02
	.db $01, $03, $00, $40			;$36 04 02 00 BossRoom
	.db $01, $03, $01, $40			;$40 Clocktower Stage 2
	.db $01, $04, $00, $40			;$41 Animation and Sound 0d 01 00
	.db $01, $04, $01, $40			;$50 08 00 00 Water
	.db $01, $04, $02, $40			;$51 Forest Stage 02 01 00 and 05 03 00 Water and 08 01 00 .. 09
	.db $01, $05, $00, $40			;$71 Rising Water 08 03 00
	.db $0e, $00, $01, $40			;$80 Falling Bridge 05 03 01
	.db $0d, $01, $00, $41			;$81 Falling Bridge 0c
	.db $0d, $01, $01, $41	
	.db $0d, $01, $02, $41	
	.db $06, $00, $01, $32	
	.db $06, $00, $00, $33	
	.db $06, $01, $00, $34	
	.db $06, $02, $01, $35	
	.db $06, $02, $00, $36	
	.db $06, $02, $02, $37	
	.db $08, $00, $00, $50	
	.db $08, $01, $00, $51	
	.db $08, $02, $00, $51	
	.db $05, $03, $00, $51	
	.db $09, $00, $00, $51	
	.db $0a, $01, $00, $51	
	.db $0a, $02, $00, $51	
	.db $0a, $03, $00, $51	
	.db $02, $01, $00, $51	
	.db $08, $00, $01, $60	
	.db $08, $03, $00, $71	
	.db $08, $04, $00, $71	
	.db $05, $03, $01, $80	
	.db $0c, $02, $00, $81	
    .db $ff 	;end of table				