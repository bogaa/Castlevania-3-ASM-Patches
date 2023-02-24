bank $16
base $8000
org $8000
	db $96
	func_16_0001:
		lda wEntityState, x
		and #$fe		; 29 fe 	#$ff-ES_DESTROYED
		sta $00			; 85 00


	B22_0008:			; y = 0 if moving right, else $ff
		ldy #$00		; a0 00
	B22_000a:
		lda wEntityHorizSpeed, x	; bd f2 04
		bpl +

	B22_000f:		
		dey				; 88 
	+	sty $01			; 84 01
		jsr entityApplyHorizSpeedToX

; destroyed var is set if orig set and moving right
; or not orig set and moving left
	B22_0015:		lda wEntityState, x	; bd 70 04
		and #$01		; 29 01		#ES_DESTROYED
		adc $01			; 65 01
		and #$01		; 29 01
		ora $00			; 05 00
	B22_0020:		sta wEntityState, x	; 9d 70 04		; apply vert speed to Y
		clc
		lda wEntityFractionalY, x
		adc wEntityVertSubSpeed, x
		sta wEntityFractionalY, x
		lda wEntityBaseY, x
		adc wEntityVertSpeed, x
		sta wEntityBaseY, x
		rts

	entityApplyHorizSpeedToX:
		clc
		lda wEntityFractionalX, x
		adc wEntityHorizSubSpeed, x
		sta wEntityFractionalX, x
		lda wEntityBaseX, x
		adc wEntityHorizSpeed, x
		sta wEntityBaseX, x
		rts
	
	
	reverseEntityHorizSpeed:
		sec
		lda #$00
		sbc wEntityHorizSubSpeed, x
		sta wEntityHorizSubSpeed, x
		lda #$00
		sbc wEntityHorizSpeed, x
		sta wEntityHorizSpeed, x
		rts
	
	
	reverseEntityVertSpeed:
		sec
		lda #$00
		sbc wEntityVertSubSpeed, x
		sta wEntityVertSubSpeed, x
		lda #$00
		sbc wEntityVertSpeed, x
		sta wEntityVertSpeed, x
		rts
	
	
	addAtoEntityHorizSpeed:
		clc
		adc wEntityHorizSubSpeed, x
		sta wEntityHorizSubSpeed, x
		lda #$00
		adc wEntityHorizSpeed, x
		sta wEntityHorizSpeed, x
		rts
	
	
	addAtoEntityVertSpeed:
		clc
		adc wEntityVertSubSpeed, x
		sta wEntityVertSubSpeed, x
		lda #$00
		adc wEntityVertSpeed, x
		sta wEntityVertSpeed, x
		rts
	
	
	subAfromEntityHorizSpeed:
		eor #$ff
		sec
		adc wEntityHorizSubSpeed, x
		sta wEntityHorizSubSpeed, x
		lda #$ff
		adc wEntityHorizSpeed, x
		sta wEntityHorizSpeed, x
		rts
	
	
	subAfromEntityVertSpeed:
		eor #$ff
		sec
		adc wEntityVertSubSpeed, x
		sta wEntityVertSubSpeed, x
		lda #$ff
		adc wEntityVertSpeed, x
		sta wEntityVertSpeed, x
		rts
	
	
	getDistanceBetweenPlayerAndEntityX:
		lda wEntityBaseX, x
		sec
		sbc wEntityBaseX
		bcs 00ATdone
	
	negA_16_00bc:
		eor #$ff
		adc #$01
	00ATdone:						
		rts
	
	
	B22_00c1:		
		lda wEntityBaseY, x			; bd 1c 04
		sec							; 38 
		sbc $11						; e5 11
		bcs 00ATdone
	
	B22_00c9:		
		bcc negA_16_00bc 			; 90 f1	
		lda wEntityBaseX, x			; bd 38 04
		sec							; 38 
		sbc $10						; e5 10
		bcs 00ATdone	
		bcc negA_16_00bc 			; 90 e7	

	B22_00d5:
		lda wEntityBaseY, x			; bd 1c 04
		sec							; 38 
		sbc wEntityBaseY			; ed1c 04
		bcs + 						; b0 04
		eor #$ff					; 49 ff
		adc #$01					; 69 01
	+	rts							; 60 

		ldx #$09					; a2 09
	-	lda wEntityObjectIdxes, x	; bd 4e 05
		beq B22_00c9End 			; f0 07

		inx							; e8 
		cpx #$0d					; e0 0d
		bcc -					 	; 90 f6
	B22_00ef:
		lda #$01					; a9 01		
	B22_00c9End:
		rts							; 60 

		ldx #$07				; a2 07
	B22_00f4:
		lda wEntityObjectIdxes, x	; bd 4e 05
		beq B22_00c9End 			; f0 f8

		inx						; e8 
		cpx #$13				; e0 13
		bcc B22_00f4 			; 90 f6
		bcs B22_00ef 			; b0 ef
		

		ldx #$01				; a2 01
	B22_0102:
		lda wEntityObjectIdxes, x	; bd 4e 05
		beq +			 ; f0 05

		inx				; e8 
		cpx #$13		; e0 13
		bcc B22_0102 ; 90 f6

	+	rts				; 60  	B22_010c:
	
	
	entityPhaseFunc_00_setEntityAIIdxTo0:
		lda #$00
		sta wEntityAI_idx, x
	
	entityPhaseFunc_75_stub:
		rts
	
	
	scfIfInSunkenCityRisingWaterRooms:
		lda wCurrRoomGroup
		cmp #RG_SUNKEN_CITY
		bne +
	
		lda wCurrRoomSection
		cmp #$03
		rts
	
	+	clc
	-	rts
	
	
	entityPhaseFunc_a0:
		jsr scfIfInSunkenCityRisingWaterRooms		; 20 13 81
		bcc -
	
		lda wEntityBaseY, x	; bd 1c 04
		cmp $ca				; c5 ca
		bcc -
	
		jsr $84b2			; 20 b2 84
		sec					; 38 
		rts					; 60 
	
	
	func_16_0131:
		lda wInGameSubstate	; a5 2a FIXME!
		cmp #$1b			; c9 1b
		bne B22_014f 		; d0 18

		lda wEntityState, x	; bd 70 04
		and #ES_FROZEN		; 29 02
		bne B22_014f 		; d0 11

		jsr $b6e6			; 20 e6 b6
		clc					; 18 
		lda $c7				; a5 c7
		adc #$04			; 69 04
		sta $05d8, x		; 9d d8 05
		jsr $ff8a 			; func_1f_1f8a		; 20 8a ff
		lda #$00			; a9 00
		rts					; 60 
	B22_014f:
		lda wEntityAI_idx, x	; bd ef 05
		rts				; 60 
		
	entityPhaseFunc_6d_tryToFall:
		lda #$10
		jsr addAtoEntityVertSpeed
	
	; 04/fc, 10
	; if floor below is empty, continue falling from vert speed
		ldy #$06
		jsr getCollisionTileValUsingOffsetPresets
		beq entityPhaseFunc_75_stub
	
	; solid below entity, cancel fall
		ldx wCurrEntityIdxBeingProcessed
		jsr snapEntityXsYtoTile
	
	loopTryToFall:
		inc wEntityPhase, x
		jmp clearEntityHorizVertSpeeds
	

	entityPhaseFunc_a1:
		lda #$10		; a9 10
		jsr addAtoEntityVertSpeed		; 20 7f 80
		ldy #$0e		; a0 0e
		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
		beq B22_019a ; f0 24

		ldx wCurrEntityIdxBeingProcessed			; a6 6c
		lda wEntityBaseY, x	; bd 1c 04
		and #$f8		; 29 f8
		sta wEntityBaseY, x	; 9d 1c 04
	
	; next phase, clear speeds
		jmp loopTryToFall
	
	entityPhaseFunc_9e:
		jsr $81ef		; 20 ef 81
		lda #$10		; a9 10
		jsr addAtoEntityVertSpeed		; 20 7f 80
		lda wEntityBaseY, x	; bd 1c 04
		cmp #$f8		; c9 f8
		bcc B22_019a ; 90 08

		lda #$23		; a9 23
		jsr playSound		; 20 5f e2
		inc wEntityPhase, x	; fe c1 05
	B22_019a:	
		rts				; 60 
	

	entityPhaseFunc_01_setStateNotMoving:
		inc wEntityPhase, x
	
	setEntityStateNotMoving:
		lda wEntityState, x
		and #$ff-ES_MOVING
		sta wEntityState, x
		rts
		
	entityPhaseFunc_2a_setStateMoving:
		inc wEntityPhase, x
	
	setEntityStateMoving:
		lda wEntityState, x
		ora #ES_MOVING
		sta wEntityState, x
		rts
	
	entityPhaseFunc_2b_reverseHorizontally:
		inc wEntityPhase, x
		jmp reverseEntityHorizSpeed
		
	entityPhaseFunc_03:
		inc wEntityPhase, x	; fe c1 05
		lda wEntityState, x	; bd 70 04
		and #$f7		; 29 f7
		sta wEntityState, x	; 9d 70 04
		rts				; 60 
		
	entityPhaseFunc_0a:
		inc wEntityPhase, x	; fe c1 05
		lda wEntityState, x	; bd 70 04
		ora #$88		; 09 88
		sta wEntityState, x	; 9d 70 04
		rts				; 60 
		
	entityPhaseFunc_54_setStateIllusion:
		inc wEntityPhase, x
		lda wEntityState, x
		ora #ES_ILLUSION
		sta wEntityState, x
		rts
		
	entityPhaseFunc_53_setStateNotIllusion:
		inc wEntityPhase, x
		lda wEntityState, x
		and #$ff-ES_ILLUSION
		sta wEntityState, x
		rts	
	
	entityPhaseFunc_2d:		
		jsr setEntityStateNotMoving		; 20 9e 81
	
	incEntityPhase_setUnanimated:
		inc wEntityPhase, x
		lda wEntityState, x
		ora #ES_UNANIMATED
		sta wEntityState, x
		rts
	
	
	setEntityStateAnimated:
		lda wEntityState, x
		and #$ff-ES_UNANIMATED
		sta wEntityState, x
		rts
	
	
	entityPhaseFunc_55:
		inc wEntityPhase, x	; fe c1 05
		ldy #$01		; a0 01
		lda (wPhaseFuncDataAddr), y	; b1 02
		sta $0657, x	; 9d 57 06
		rts				; 60 
	
	
	entityPhaseFunc_04_setPhase:
		ldy #$01
		lda (wPhaseFuncDataAddr), y
		sta wEntityPhase, x
		rts
	
	
	entityPhaseFunc_62_addOffsetsToXY:
		ldy #$01
		clc
		lda (wPhaseFuncDataAddr), y
		adc wEntityBaseX, x
		sta wEntityBaseX, x
		iny
		clc
		lda (wPhaseFuncDataAddr), y
		adc wEntityBaseY, x
		sta wEntityBaseY, x
		inc wEntityPhase, x
	
	entityPhaseFunc_72_stub:
		rts
	
	
	entityPhaseFunc_05_facePlayer:
		inc wEntityPhase, x
	
	entityFacePlayer:
		lda #$00
		ldy wEntityBaseX, x
		cpy wEntityBaseX
		bcc +
	
		lda #$01
	
	+	sta wEntityFacingLeft, x
		rts
	
	
	entityPhaseFunc_91:
		inc wEntityPhase, x	; fe c1 05		B22_0240:
		jsr entityFacePlayer		; 20 30 82
		lda wEntityState, x	; bd 70 04
		and #ES_DESTROYED		; 29 01
		beq B22_0255 ; f0 08

		lda wEntityFacingLeft, x	; bd a8 04
		eor #$01		; 49 01
		sta wEntityFacingLeft, x	; 9d a8 04
	B22_0255:	
		rts				; 60 
	
	
	entityPhaseFunc_06:
		inc wEntityPhase, x	; fe c1 05
	
	func_16_0259:
		sec				; 38 
		lda wEntityObjectIdxes, x	; bd 4e 05
		sbc #$48		; e9 48
		tay				; a8 
		lda $826c, y	; b9 6c 82
		tay				; a8 
		lda #$08		; a9 08
		jsr setEntitySpecGroupA_animationDefIdxY_animateNextFrame		; 20 5c ef
		jmp updateEntityXanimationFrame		; 4c 75 ef
	

		db $00 ,$01 ,$03 ,$04 
		db $02 ,$05 ,$06 ,$10
		db $07 ,$08 ,$09 ,$11
		db $0B ,$0D ,$00 ,$06
		db $0F ,$00 ,$12 ,$05 
		db $1B ,$1C ,$00 ,$00

	entityPhaseFunc_13_animateGroupAndDefIdx:
		inc wEntityPhase, x	; fe c1 05		B22_0284
		ldy #$01		; a0 01
		lda (wPhaseFuncDataAddr), y	; b1 02
		sta $00			; 85 00
		iny				; c8 
		lda (wPhaseFuncDataAddr), y	; b1 02
		tay				; a8 
		lda $00			; a5 00
	
	entityInitAnimation_specGroupA_animationDefIdxY:
		jsr setEntitySpecGroupA_animationDefIdxY_animateNextFrame
		jsr updateEntityXanimationFrame
		jmp setEntityStateAnimated
	
	
	entityPhaseFunc_8b:
		ldy #$07		; a0 07
		lda wChrBankSpr_0800			; a5 48
		cmp #$08		; c9 08
		bne B22_02a6 ; d0 02

		ldy #$0a		; a0 0a
	B22_02a6:	
		lda #$12		; a9 12
	
	B22_02a8:		
		inc wEntityPhase, x	; fe c1 05
		jmp entityInitAnimation_specGroupA_animationDefIdxY		; 4c 93 82
	
	
	entityPhaseFunc_a5:
		ldy #$07		; a0 07
		lda #$14		; a9 14
		bne B22_02a8 ; d0 f4
	
	entityPhaseFunc_8c:
		ldy #$00		; a0 00
		lda wChrBankSpr_0800			; a5 48
		cmp #$08		; c9 08
		beq B22_02bd ; f0 01

		iny				; c8 
	B22_02bd:		
		lda $82d1, y	; b9 d1 82
		sta $00			; 85 00
		lda $82cd, y	; b9 cd 82
		ldy $00			; a4 00
		jsr $82a8		; 20 a8 82
		jmp $82f0		; 4c f0 82
	
	data82cd:
		db $08, $12, $08, $12 
		db $01, $0B, $04, $0C 
		
	entityPhaseFunc_8d:
		jsr entityFacePlayer					; 20 30 82
		jsr incEntityPhase_setUnanimated		; 20 ec 81

		ldy #$00								; a0 00
		lda wChrBankSpr_0800					; a5 48
		cmp #$08								; c9 08
		beq B22_02e4  							; f0 01

		iny										; c8 
	B22_02e4:
		lda $82cd, y							; b9 cd 82
		sta wEntityOamSpecGroupDoubled, x		; 9d 8c 04
		lda $8305, y							; b9 05 83
		sta wOamSpecIdxDoubled, x				; 9d 00 04
		lda wCurrRoomGroup						; a5 32
		cmp #$05								; c9 05
		bne B22_0304 							; d0 0e

		lda wCurrRoomSection					; a5 33
		cmp #$03		
		bne B22_0304 

		lda wEntityPaletteOverride, x			; bd 54 04
		ora #$03		
		sta wEntityPaletteOverride, x			; 9d 54 04
	B22_0304:		
		rts				; 60 
	

	B22_0305:	
		db $12, $70
	
	
	entityPhaseFunc_95:
		ldy #$02
		lda $49			; a5 49
		cmp #$0f		; c9 0f
		beq B22_02bd ; f0 ae

		iny				; c8 
		jmp B22_02bd		; 4c bd 82
		
	entityPhaseFunc_4f:
		lda #$01		; a9 01
		sta wEntityFacingLeft, x	; 9d a8 04
		lda #$00		; a9 00
		sta wEntityPaletteOverride, x	; 9d 54 04
		lda wEntityObjectIdxes, x	; bd 4e 05
		sec				; 38 
		sbc #$93		; e9 93
		tay				; a8 
		lda data_16_0333, y	; b9 33 83
		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
		lda data_16_0353, y	; b9 53 83
		sta wOamSpecIdxDoubled, x	; 9d 00 04
		jmp incEntityPhase_setUnanimated		; 4c ec 81
	
	data_16_0333:
		db $00 ,$00 ,$00 ,$00 
		db $0E ,$0E ,$0E ,$0E
		db $00 ,$00 ,$00 ,$00
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$0E ,$0E ,$0E 
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$0E ,$0E ,$0E
	
	data_16_0353:
		db $46 ,$42 ,$4E ,$50 
		db $68 ,$54 ,$56 ,$52
		db $4E ,$46 ,$54 ,$54
		db $6A ,$1C ,$1E ,$20
		db $24 ,$24 ,$24 ,$24 
		db $24 ,$24 ,$24 ,$24
		db $24 ,$22 ,$10 ,$0E
		db $58 ,$5A ,$6A ,$10
	; point of success		
	
	entityPhaseFunc_87:
		inc wEntityPhase, x
		lda #$0e		; a9 0e
		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
		sec				; 38 
		lda wEntityObjectIdxes, x	; bd 4e 05
		sbc #$a3		; e9 a3
		tay				; a8 
		lda $8389, y	; b9 89 83
		sta wOamSpecIdxDoubled, x	; 9d 00 04
		rts				; 60 

	B22_0389:		
		db $26, $28, $2a, $2c, $2e, $30, $32, $34, $70 

	
	entityPhaseFunc_88:
		ldy #$00
		lda wChrBankSpr_0800			; a5 48
		cmp #$14		; c9 14
		bne B22_039c ; d0 02

		ldy #$0e		; a0 0e
	B22_039c:		
		sty $00			; 84 00
		lda #$12		; a9 12
		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
		ldy #$01		; a0 01
		clc				; 18 
		lda (wPhaseFuncDataAddr), y	; b1 02
		adc $00			; 65 00
		jmp $83b7		; 4c b7 83
	
	
	entityPhaseFunc_0b:
		ldy #$01		; a0 01

		lda (wPhaseFuncDataAddr), y	; b1 02
		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
		iny				; c8 
		lda (wPhaseFuncDataAddr), y	; b1 02
		sta wOamSpecIdxDoubled, x	; 9d 00 04
		jmp incEntityPhase_setUnanimated		; 4c ec 81
	
	
	entityPhaseFunc_07:
		jsr setEntityStateAnimated		; 20 f8 81
		jsr func_16_0259		; 20 59 82
	
	entityPhaseFunc_1e_moveToPlayerSetHorizSpeeds:
		inc wEntityPhase, x
	
	; start moving to player
		jsr setEntityStateMoving
		jsr entityFacePlayer
		jsr clearEntityHorizVertSpeeds
	
	; override horiz speeds from params
		ldy #$01
		lda (wPhaseFuncDataAddr), y
		sta wEntityHorizSpeed, x
		iny
		lda (wPhaseFuncDataAddr), y
		sta wEntityHorizSubSpeed, x
	
	reverseEntityHorizSpeedIfFacingLeft:
		ldy wEntityFacingLeft, x
		beq +
	
		jmp reverseEntityHorizSpeed
	
	+	rts
	
	
	entityPhaseFunc_a6:
		jsr setEntityStateAnimated		; 20 f8 81
		ldy #$08		; a0 08
		lda #$14		; a9 14
		jsr setEntitySpecGroupA_animationDefIdxY_animateNextFrame		; 20 5c ef
		jsr updateEntityXanimationFrame		; 20 75 ef
		jmp $83c3		; 4c c3 83
	
	
	entityPhaseFunc_08:
		ldy #$01		; a0 01		B22_03f5
		lda (wPhaseFuncDataAddr), y	; b1 02
		jsr jumpTablePreserveY		; 20 6d e8

		dw B22_0404
		dw getStartYforSinusoidalMovement
		dw B22_0410
		dw B22_0428

	B22_0404:		
		jsr $841c
		lda data_16_040c, y			; b9
		bne setEntityAlarmOrStartYforSinusoidalMovement_nextPhase			; d0
	
	data_16_040c:
		db $f8, $b0, $a0, $c8
		
	B22_0410:
		jsr $841c		; 20 1c 84
		lda $8418, y	; b9 18 84
		bne setEntityAlarmOrStartYforSinusoidalMovement_nextPhase ; d0 2d	
		pha				; 48 
		rts				; 60 	B22_0419
	
	
	B22_041a:		;removed
		db $50, $38
	
		txa				; 8a 
		adc wEntityBaseX		; 6d 38 04
		and $1f			; 25 1f
		adc wGameStateLoopCounter			; 65 1a
		and #$03		; 29 03
		tay				; a8 
		rts				; 60 
	
	
	B22_0428:		
		jsr $841c		; 20 1c 84
		ldy wHardMode	; ac f6 07
		beq +			 ; f0 03
	
		clc				; 18 
		adc #$04		; 69 04
	+	tay				; a8 
		lda $8439, y	; b9 39 84
		bne setEntityAlarmOrStartYforSinusoidalMovement_nextPhase ; d0 0c

		ldy #$60				; a0 60
		bvs entityPhaseFunc_07 ; 70 80
	
	B22_043d:		;removed
		db $30, $48
	
		sec				; 38 
	B22_0440:	
		rti				; 40 
	
	
	entityPhaseFunc_1f_setAlarmOrStartYforSinusoidalMovement:
		ldy #$01
		lda (wPhaseFuncDataAddr), y
	
	setEntityAlarmOrStartYforSinusoidalMovement_nextPhase:
		sta wEntityAlarmOrStartYforSinusoidalMovement, x
	--	inc wEntityPhase, x
	-	rts
	
	
	entityPhaseFunc_20_incPhaseWhenAlarm0:
		dec wEntityAlarmOrStartYforSinusoidalMovement, x
		bne -
	; inc phase
		beq --
		
	getStartYforSinusoidalMovement:
		ldy wHardMode
	
		txa
		adc wRandomVal
		and #$07
		clc
		adc difficultyModeOffsetsForAbove, y
		tay
		lda startYforSinusoidalMovement, y
		bne setEntityAlarmOrStartYforSinusoidalMovement_nextPhase ; d0 e0
	
	startYforSinusoidalMovement:
		db $68, $84, $62, $73, $94, $79, $81, $a7
		db $58, $74, $42, $63, $24, $49, $31, $47		; second quest medusa
	
	difficultyModeOffsetsForAbove:
		db $00, $08
	
	
	entityPhaseFunc_9f:
		jsr B22_00d5		; 20 d5 80
		cmp #$30		; c9 30
		bcs B22_0481 ; b0 03

		inc wEntityPhase, x	; fe c1 05
	B22_0481:		
		rts				; 60 
;	
;	
;	entityPhaseFunc_0c:
;	B22_0482:		ldy #$01		; a0 01
;	B22_0484:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0486:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0489:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_048c:		cmp wEntityAlarmOrStartYforSinusoidalMovement, x	; dd 06 06
;	B22_048f:		bcs B22_0494 ; b0 03
;	
;	B22_0491:		inc wEntityPhase, x	; fe c1 05
;	B22_0494:		rts				; 60 
;	
;	
;	entityPhaseFunc_4d:
;	B22_0495:		ldy #$01		; a0 01
;	B22_0497:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0499:		sta $09			; 85 09
;	B22_049b:		iny				; c8 
;	B22_049c:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_049e:		sta $08			; 85 08
;	B22_04a0:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_04a3:		cmp $09			; c5 09
;	B22_04a5:		bcs B22_0494 ; b0 ed
;	
;	B22_04a7:		jsr $80d5		; 20 d5 80
;	B22_04aa:		cmp $08			; c5 08
;	B22_04ac:		bcs B22_0494 ; b0 e6
;	
;	B22_04ae:		bcc B22_0491 ; 90 e1
;	
;	B22_04b0:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	
;	entityPhaseFunc_27_end:
;	B22_04b2:		jsr func_16_0e36		; 20 36 8e
;		jmp entityPhaseFunc_00_setEntityAIIdxTo0
;	
;	
;	entityPhaseFunc_2e:
;	B22_04b8:		ldy #$04		; a0 04
;	B22_04ba:		lda #$00		; a9 00
;	B22_04bc:		jsr func_1f_1c1e		; 20 1e fc
;	B22_04bf:		beq B22_04c3 ; f0 02
;	
;	B22_04c1:		bne B22_04b0 ; d0 ed
;	
;	B22_04c3:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_04c5:		jmp $8e20		; 4c 20 8e
;	
;	
;	entityPhaseFunc_21:
;	B22_04c8:		jsr $8240		; 20 40 82
;	B22_04cb:		lda $061d, x	; bd 1d 06
;	B22_04ce:		cmp #$05		; c9 05
;	B22_04d0:		bcc B22_04da ; 90 08
;	
;	B22_04d2:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_04d5:		eor #$01		; 49 01
;	B22_04d7:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_04da:		jsr setEntityStateMoving		; 20 aa 81
;	B22_04dd:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_04e0:		cmp #$50		; c9 50
;	B22_04e2:		bcs B22_0505 ; b0 21
;	
;	B22_04e4:		lda wEntityFacingLeft		; ad a8 04
;	B22_04e7:		cmp wEntityFacingLeft, x	; dd a8 04
;	B22_04ea:		beq B22_0505 ; f0 19
;	
;	B22_04ec:		inc $061d, x	; fe 1d 06
;	B22_04ef:		lda #$1c		; a9 1c
;	B22_04f1:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_04f4:		lda #$fc		; a9 fc
;	B22_04f6:		ldy #$c0		; a0 c0
;	B22_04f8:		jsr setEntityVertSpeedToAY		; 20 18 85
;	B22_04fb:		lda #$01		; a9 01
;	B22_04fd:		ldy #$00		; a0 00
;	
;	setEntityHorizSpeedToAY_reversedIfFacingLeft:
;		jsr setEntityHorizSpeedToAY
;		jmp reverseEntityHorizSpeedIfFacingLeft
;	
;	
;	B22_0505:		lda #$24		; a9 24
;	B22_0507:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_050a:		lda #$ff		; a9 ff
;	B22_050c:		ldy #$00		; a0 00
;	B22_050e:		jsr setEntityVertSpeedToAY		; 20 18 85
;	B22_0511:		lda #$02		; a9 02
;	B22_0513:		ldy #$00		; a0 00
;	B22_0515:		jmp setEntityHorizSpeedToAY_reversedIfFacingLeft		; 4c ff 84
;	
;	
;	setEntityVertSpeedToAY:
;		sta wEntityVertSpeed, x
;		tya
;		sta wEntityVertSubSpeed, x
;		rts
;	
;	
;	setEntityHorizSpeedToAY:
;		sta wEntityHorizSpeed, x
;		tya
;		sta wEntityHorizSubSpeed, x
;		rts
;	
;	
;	entityPhaseFunc_0f:
;	B22_0528:		inc wEntityPhase, x	; fe c1 05
;	B22_052b:		jsr entityFacePlayer		; 20 30 82
;	B22_052e:		jsr setEntityStateMoving		; 20 aa 81
;	B22_0531:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_0534:		cmp #$40		; c9 40
;	B22_0536:		bcs B22_0505 ; b0 cd
;	
;	B22_0538:		lda wEntityFacingLeft		; ad a8 04
;	B22_053b:		cmp wEntityFacingLeft, x	; dd a8 04
;	B22_053e:		beq B22_0505 ; f0 c5
;	
;	B22_0540:		inc wEntityGenericCounter, x	; fe 33 06
;	B22_0543:		lda #$12		; a9 12
;	B22_0545:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0548:		lda #$fe		; a9 fe
;	B22_054a:		ldy #$00		; a0 00
;	B22_054c:		jsr setEntityVertSpeedToAY		; 20 18 85
;	B22_054f:		lda #$01		; a9 01
;	B22_0551:		ldy #$20		; a0 20
;	B22_0553:		jmp setEntityHorizSpeedToAY_reversedIfFacingLeft		; 4c ff 84
;	
;	
;	entityPhaseFunc_44:
;	B22_0556:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0559:		cmp #$f8		; c9 f8
;	B22_055b:		bcc B22_056c ; 90 0f
;	
;	B22_055d:		lda #$00		; a9 00
;	B22_055f:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0562:		ldy #$01		; a0 01
;	B22_0564:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0566:		sta wEntityPhase, x	; 9d c1 05
;	B22_0569:		jmp clearEntityHorizVertSpeeds		; 4c c8 fe
;	
;	
;	entityPhaseFunc_10:
;	B22_056c:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_056f:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_0572:		ldy #$04		; a0 04
;	B22_0574:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_0577:		bne B22_05b2 ; d0 39
;	
;	B22_0579:		ldy #$02		; a0 02
;	B22_057b:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_057d:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_0580:		bne B22_05ad ; d0 2b
;	
;	B22_0582:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_0585:		bmi B22_05ac ; 30 25
;	
;	B22_0587:		ldy #$03		; a0 03
;	B22_0589:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_058c:		beq B22_05ac ; f0 1e
;	
;	B22_058e:		lda wEntityObjectIdxes, x	; bd 4e 05
;	B22_0591:		cmp #$53		; c9 53
;	B22_0593:		bne B22_059a ; d0 05
;	
;	B22_0595:		lda #$0d		; a9 0d
;	B22_0597:		jsr playSound		; 20 5f e2
;	B22_059a:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_059c:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_059f:		inc wEntityPhase, x	; fe c1 05
;	B22_05a2:		lda wEntityBaseY, x	; bd 1c 04
;	B22_05a5:		and #$f0		; 29 f0
;	B22_05a7:		ora #$08		; 09 08
;	B22_05a9:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_05ac:		rts				; 60 
;	
;	
;	B22_05ad:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_05af:		jmp entityReverseFacingDirAndHorizSpeed		; 4c 5e 89
;	
;	
;	B22_05b2:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_05b4:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_05b7:		bpl B22_05ac ; 10 f3
;	
;	B22_05b9:		jmp reverseEntityVertSpeed		; 4c 5d 80
;	
;	
;	entityPhaseFunc_8a:
;	B22_05bc:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_05bf:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_05c2:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_05c5:		bmi B22_05e7 ; 30 20
;	
;	B22_05c7:		lda #$16		; a9 16
;	B22_05c9:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_05cc:		ldy #$08		; a0 08
;	B22_05ce:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_05d1:		beq B22_05e7 ; f0 14
;	
;	B22_05d3:		cmp #$01		; c9 01
;	B22_05d5:		beq B22_05e4 ; f0 0d
;	
;	B22_05d7:		lda #$02		; a9 02
;	B22_05d9:		sta $061d, x	; 9d 1d 06
;	B22_05dc:		lda #$14		; a9 14
;	B22_05de:		sta wEntityPhase, x	; 9d c1 05
;	B22_05e1:		jmp $85fe		; 4c fe 85
;	
;	
;	B22_05e4:		inc wEntityPhase, x	; fe c1 05
;	B22_05e7:		rts				; 60 
;	
;	
;	entityPhaseFunc_5c:
;	B22_05e8:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_05eb:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_05ee:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_05f1:		bmi B22_05ac ; 30 b9
;	
;	B22_05f3:		ldy #$08		; a0 08
;	B22_05f5:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_05f8:		beq B22_05ac ; f0 b2
;	
;	B22_05fa:		cmp #$01		; c9 01
;	B22_05fc:		beq B22_061a ; f0 1c
;	
;	B22_05fe:		clc				; 18 
;	B22_05ff:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0602:		and #$f0		; 29 f0
;	B22_0604:		adc #$08		; 69 08
;	B22_0606:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0609:		inc wEntityPhase, x	; fe c1 05
;	B22_060c:		inc wEntityPhase, x	; fe c1 05
;	B22_060f:		lda #$14		; a9 14
;	B22_0611:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0614:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_0617:		jmp clearEntityHorizVertSpeeds		; 4c c8 fe
;	
;	
;	B22_061a:		clc				; 18 
;	B22_061b:		lda wEntityBaseY, x	; bd 1c 04
;	B22_061e:		and #$f0		; 29 f0
;	B22_0620:		adc #$10		; 69 10
;	B22_0622:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0625:		jmp $860c		; 4c 0c 86
;	
;	
;	B22_0628:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_062a:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_062d:		bmi B22_063d ; 30 0e
;	
;	B22_062f:		cmp #$02		; c9 02
;	B22_0631:		bcc B22_063d ; 90 0a
;	
;	B22_0633:		lda #$02		; a9 02
;	B22_0635:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0638:		lda #$00		; a9 00
;	B22_063a:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_063d:		rts				; 60 
;	
;	
;	entityPhaseFunc_a8:
;	B22_063e:		ldy #$01		; a0 01
;	B22_0640:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0642:		cmp wEntityBaseY, x	; dd 1c 04
;	B22_0645:		bcs B22_063d ; b0 f6
;	
;	B22_0647:		jmp $84b2		; 4c b2 84
;	
;	
;	entityPhaseFunc_73:
;	B22_064a:		inc wEntityPhase, x	; fe c1 05
;	B22_064d:		lda #$00		; a9 00
;	B22_064f:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_0652:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0655:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0658:		jmp $86ac		; 4c ac 86
;	
;	
;	entityPhaseFunc_58:
;	B22_065b:		ldy #$03		; a0 03
;	B22_065d:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_065f:		sta $061d, x	; 9d 1d 06
;	
;	entityPhaseFunc_11:
;	B22_0662:		inc wEntityPhase, x	; fe c1 05
;	B22_0665:		ldy #$01		; a0 01
;	B22_0667:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0669:		tay				; a8 
;	B22_066a:		lda $8682, y	; b9 82 86
;	B22_066d:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0670:		lda $868a, y	; b9 8a 86
;	B22_0673:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0676:		ldy #$02		; a0 02
;	B22_0678:		clc				; 18 
;	B22_0679:		lda wEntityBaseY, x	; bd 1c 04
;	B22_067c:		adc (wPhaseFuncDataAddr), y	; 71 02
;	B22_067e:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0681:		rts				; 60 
;	
;	
;	B22_0682:		inc $fefe, x	; fe fe fe
;	B22_0685:	.db $ff
;	B22_0686:	.db $ff
;	B22_0687:	.db $ff
;	B22_0688:	.db $ff
;	B22_0689:	.db $02
;	B22_068a:		.db $00				; 00
;	B22_068b:	.db $80
;	B22_068c:		cpy #$00		; c0 00
;	B22_068e:		rti				; 40 
;	
;	
;	B22_068f:		beq B22_0631 ; f0 a0
;	
;	B22_0691:		.db $00				; 00
;	B22_0692:	.db $ff
;	B22_0693:		ora ($fd, x)	; 01 fd
;	B22_0695:	.db $04
;	B22_0696:	.db $ff
;	B22_0697:		ora ($00, x)	; 01 00
;	B22_0699:		cpy #$00		; c0 00
;	B22_069b:		cpy #$00		; c0 00
;	B22_069d:		cpy #$3f		; c0 3f
;	B22_069f:	.db $27
;	B22_06a0:	.db $3c
;	B22_06a1:		ora $273f, x	; 1d 3f 27
;	
;	
;	entityPhaseFunc_74:
;	B22_06a4:		dec $061d, x	; de 1d 06
;	B22_06a7:		bne B22_06cb ; d0 22
;	
;	B22_06a9:		inc wEntityGenericCounter, x	; fe 33 06
;	B22_06ac:		ldy wEntityGenericCounter, x	; bc 33 06
;	B22_06af:		lda $8692, y	; b9 92 86
;	B22_06b2:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_06b5:		lda $8698, y	; b9 98 86
;	B22_06b8:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_06bb:		lda $869e, y	; b9 9e 86
;	B22_06be:		sta $061d, x	; 9d 1d 06
;	B22_06c1:		rts				; 60 
;	
;	
;	entityPhaseFunc_59:
;	B22_06c2:		dec $061d, x	; de 1d 06
;	B22_06c5:		bne B22_06cb ; d0 04
;	
;	B22_06c7:		inc wEntityPhase, x	; fe c1 05
;	B22_06ca:		rts				; 60 
;	
;	entityPhaseFunc_12:
;	B22_06cb:		lda wCurrRoomMetadataByte			; a5 68
;	B22_06cd:		bpl B22_06d8 ; 10 09
;	
;	B22_06cf:		clc				; 18 
;	B22_06d0:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_06d3:		adc $6e			; 65 6e
;	B22_06d5:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	
;	B22_06d8:		lda wEntityBaseY, x	; bd 1c 04
;	B22_06db:		sec				; 38 
;	B22_06dc:		sbc wEntityAlarmOrStartYforSinusoidalMovement, x	; fd 06 06
;	B22_06df:		ldy #$00		; a0 00
;	B22_06e1:		bcs B22_06e4 ; b0 01
;	
;	B22_06e3:		dey				; 88 
;	B22_06e4:		sty $01			; 84 01
;	B22_06e6:		sta $00			; 85 00
;	B22_06e8:		lda wEntityVertSubSpeed, x	; bd 37 05
;	B22_06eb:		sec				; 38 
;	B22_06ec:		sbc $00			; e5 00
;	B22_06ee:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_06f1:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_06f4:		sbc $01			; e5 01
;	B22_06f6:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_06f9:		rts				; 60 
;	
;	
;	entityPhaseFunc_9c:
;	B22_06fa:		lda #$01		; a9 01
;	B22_06fc:		sta $061d, x	; 9d 1d 06
;	B22_06ff:		jsr $8662		; 20 62 86
;	
;	entityPhaseFunc_9d:
;	B22_0702:		lda wCurrRoomMetadataByte			; a5 68
;	B22_0704:		bpl B22_06d8 ; 10 d2
;	
;	B22_0706:		sec				; 38 
;	B22_0707:		lda wEntityBaseY, x	; bd 1c 04
;	B22_070a:		sbc wEntityAlarmOrStartYforSinusoidalMovement, x	; fd 06 06
;	B22_070d:		sta $00			; 85 00
;	B22_070f:		lda #$01		; a9 01
;	B22_0711:		sbc $061d, x	; fd 1d 06
;	B22_0714:		sta $01			; 85 01
;	B22_0716:		jmp $86e8		; 4c e8 86
;	
;	
;	entityPhaseFunc_a3:
;	B22_0719:		inc wEntityPhase, x	; fe c1 05
;	B22_071c:		lda #$00		; a9 00
;	B22_071e:		ldy wEntityBaseY, x	; bc 1c 04
;	B22_0721:		bmi B22_0725 ; 30 02
;	
;	B22_0723:		lda #$04		; a9 04
;	B22_0725:		sta $0645, x	; 9d 45 06
;	B22_0728:		jsr $873f		; 20 3f 87
;	B22_072b:		lda #$01		; a9 01
;	B22_072d:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_0730:		sta $061d, x	; 9d 1d 06
;	B22_0733:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0736:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0739:		rts				; 60 
;	
;	
;	entityPhaseFunc_a4:
;	B22_073a:		dec wEntityGenericCounter, x	; de 33 06
;	B22_073d:		bne B22_0702 ; d0 c3
;	
;	B22_073f:		lda wRandomVal			; a5 1f
;	B22_0741:		and #$03		; 29 03
;	B22_0743:		clc				; 18 
;	B22_0744:		adc $0645, x	; 7d 45 06
;	B22_0747:		tay				; a8 
;	B22_0748:		lda $875b, y	; b9 5b 87
;	B22_074b:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_074e:		lda $8763, y	; b9 63 87
;	B22_0751:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0754:		lda $876b, y	; b9 6b 87
;	B22_0757:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_075a:		rts				; 60 
;	
;	
;	B22_075b:		inc $fffc, x	; fe fc ff
;	B22_075e:		sbc $0302, x	; fd 02 03
;	B22_0761:		ora ($02, x)	; 01 02
;	B22_0763:		.db $00				; 00
;	B22_0764:	.db $80
;	B22_0765:		.db $00				; 00
;	B22_0766:	.db $80
;	B22_0767:		.db $00				; 00
;	B22_0768:	.db $80
;	B22_0769:		.db $00				; 00
;	B22_076a:	.db $80
;	B22_076b:	.db $3f
;	B22_076c:		jmp $281b		; 4c 1b 28
;	
;	
;	B22_076f:	.db $3f
;	B22_0770:		jmp $281b		; 4c 1b 28
;	
;	
;	entityPhaseFunc_6f:
;	B22_0773:		ldy #$01		; a0 01
;	B22_0775:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0777:		tay				; a8 
;	B22_0778:		lda $878f, y	; b9 8f 87
;	B22_077b:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_077e:		lda $8791, y	; b9 91 87
;	B22_0781:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0784:		ldy #$02		; a0 02
;	B22_0786:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0788:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_078b:		inc wEntityPhase, x	; fe c1 05
;	B22_078e:		rts				; 60 
;	
;	
;	B22_078f:		ora ($00, x)	; 01 00
;	B22_0791:	.db $80
;	B22_0792:		.db $00				; 00
;	
;	
;	entityPhaseFunc_70:
;	B22_0793:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0796:		beq B22_078b ; f0 f3
;	
;	B22_0798:		ldy #$01		; a0 01
;	B22_079a:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_079c:		jmp subAfromEntityVertSpeed		; 4c a1 80
;	
;	
;	entityPhaseFunc_67:
;	B22_079f:		lda wGameStateLoopCounter			; a5 1a
;	B22_07a1:		and #$01		; 29 01
;	B22_07a3:		bne B22_07ad ; d0 08
;	
;	B22_07a5:		lda wEntityState, x	; bd 70 04
;	B22_07a8:		eor #$08		; 49 08
;	B22_07aa:		sta wEntityState, x	; 9d 70 04
;	B22_07ad:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_07b0:		cmp #$40		; c9 40
;	B22_07b2:		ldy wEntityAlarmOrStartYforSinusoidalMovement, x	; bc 06 06
;	B22_07b5:		bne B22_07ba ; d0 03
;	
;	B22_07b7:		bcc B22_07bc ; 90 03
;	
;	B22_07b9:		rts				; 60 
;	
;	
;	B22_07ba:		bcc B22_07bf ; 90 03
;	
;	B22_07bc:		inc wEntityPhase, x	; fe c1 05
;	B22_07bf:		rts				; 60 
;	
;	
;	B22_07c0:		jmp entityPhaseFunc_59		; 4c c2 86
;	
;	
;	entityPhaseFunc_60:
;	B22_07c3:		jsr entityPhaseFunc_59		; 20 c2 86
;	B22_07c6:		ldy #$0a		; a0 0a
;	B22_07c8:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_07cb:		bne B22_07dc ; d0 0f
;	
;	B22_07cd:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_07cf:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_07d2:		lda #$01		; a9 01
;	B22_07d4:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_07d7:		lda #$16		; a9 16
;	B22_07d9:		sta wEntityPhase, x	; 9d c1 05
;	B22_07dc:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_07de:		rts				; 60 
;	
;	
;	entityPhaseFunc_61:
;	B22_07df:		lda #$14		; a9 14
;	B22_07e1:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_07e4:		ldy #$01		; a0 01
;	B22_07e6:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_07e8:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_07eb:		iny				; c8 
;	B22_07ec:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_07ee:		tay				; a8 
;	B22_07ef:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_07f2:		beq B22_07dc ; f0 e8
;	
;	B22_07f4:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_07f6:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_07f9:		sta wEntityPhase, x	; 9d c1 05
;	B22_07fc:		rts				; 60 
;	
;	
;	entityPhaseFunc_63:
;	B22_07fd:		inc wEntityPhase, x	; fe c1 05
;	B22_0800:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0803:		ldy #$01		; a0 01
;	B22_0805:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0807:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_080a:		iny				; c8 
;	B22_080b:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_080d:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0810:		rts				; 60 
;	
;	
;	entityPhaseFunc_98:
;	B22_0811:		inc wEntityPhase, x	; fe c1 05
;	B22_0814:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0817:		ldy #$01		; a0 01
;	B22_0819:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_081b:		bne B22_0870 ; d0 53
;	
;	B22_081d:		ldy #$00		; a0 00
;	B22_081f:		sec				; 38 
;	B22_0820:		lda $ca			; a5 ca
;	B22_0822:		sbc wEntityBaseY		; ed1c 04
;	B22_0825:		bcs B22_082b ; b0 04
;	
;	B22_0827:		eor #$ff		; 49 ff
;	B22_0829:		adc #$01		; 69 01
;	B22_082b:		cmp #$38		; c9 38
;	B22_082d:		bcc B22_083f ; 90 10
;	
;	B22_082f:		iny				; c8 
;	B22_0830:		cmp #$48		; c9 48
;	B22_0832:		bcc B22_083f ; 90 0b
;	
;	B22_0834:		iny				; c8 
;	B22_0835:		cmp #$58		; c9 58
;	B22_0837:		bcc B22_083f ; 90 06
;	
;	B22_0839:		iny				; c8 
;	B22_083a:		cmp #$68		; c9 68
;	B22_083c:		bcc B22_083f ; 90 01
;	
;	B22_083e:		iny				; c8 
;	B22_083f:		lda $8884, y	; b9 84 88
;	B22_0842:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0845:		lda $887f, y	; b9 7f 88
;	B22_0848:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_084b:		lda wEntityBaseX, x	; bd 38 04
;	B22_084e:		ldy wEntityBaseY, x	; bc 1c 04
;	B22_0851:		jsr func_1f_1c1e		; 20 1e fc
;	B22_0854:		bne B22_0876 ; d0 20
;	
;	B22_0856:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0858:		lda #$22		; a9 22
;	B22_085a:		jsr playSound		; 20 5f e2
;	B22_085d:		jsr setEntityStateMoving		; 20 aa 81
;	B22_0860:		jsr entityFacePlayer		; 20 30 82
;	B22_0863:		lda #$08		; a9 08
;	B22_0865:		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
;	B22_0868:		lda #$46		; a9 46
;	B22_086a:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_086d:		jmp $81ef		; 4c ef 81
;	
;	
;	B22_0870:		lda #$ff		; a9 ff
;	B22_0872:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0875:		rts				; 60 
;	
;	
;	B22_0876:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0878:		jsr $b584		; 20 84 b5
;	B22_087b:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_087e:		rts				; 60 
;	
;	
;	B22_087f:	.db $fc
;	B22_0880:	.db $fb
;	B22_0881:	.db $fb
;	B22_0882:	.db $fb
;	B22_0883:	.db $fa
;	B22_0884:		rti				; 40 
;	
;	
;	B22_0885:		cpy #$80		; c0 80
;	B22_0887:		rti				; 40 
;	
;	
;	B22_0888:	.db $80
;	
;	
;	entityPhaseFunc_99:
;	B22_0889:		lda #$20		; a9 20
;	B22_088b:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_088e:		ldy #$01		; a0 01
;	B22_0890:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0892:		beq B22_08a7 ; f0 13
;	
;	B22_0894:		sec				; 38 
;	B22_0895:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0898:		sbc #$10		; e9 10
;	B22_089a:		cmp $ca			; c5 ca
;	B22_089c:		bcc B22_08a6 ; 90 08
;	
;	B22_089e:		inc wEntityPhase, x	; fe c1 05
;	B22_08a1:		jsr $992b		; 20 2b 99
;	B22_08a4:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_08a6:		rts				; 60 
;	
;	
;	B22_08a7:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_08aa:		bmi B22_08a6 ; 30 fa
;	
;	B22_08ac:		ldy #$06		; a0 06
;	B22_08ae:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_08b1:		beq B22_08bc ; f0 09
;	
;	B22_08b3:		inc wEntityPhase, x	; fe c1 05
;	B22_08b6:		jsr $8b95		; 20 95 8b
;	B22_08b9:		jmp clearEntityHorizVertSpeeds		; 4c c8 fe
;	
;	
;	B22_08bc:		sec				; 38 
;	B22_08bd:		lda wEntityBaseY, x	; bd 1c 04
;	B22_08c0:		sbc #$10		; e9 10
;	B22_08c2:		cmp $ca			; c5 ca
;	B22_08c4:		bcc B22_08a6 ; 90 e0
;	
;	B22_08c6:		jsr $992b		; 20 2b 99
;	B22_08c9:		jmp $84b2		; 4c b2 84
;	
;	
;	entityPhaseFunc_64:
;	B22_08cc:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_08cf:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_08d2:		ldy #$01		; a0 01
;	B22_08d4:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_08d6:		cmp #$01		; c9 01
;	B22_08d8:		beq B22_0909 ; f0 2f
;	
;	B22_08da:		cmp #$02		; c9 02
;	B22_08dc:		beq B22_0914 ; f0 36
;	
;	B22_08de:		ldy wEntityVertSpeed, x	; bc 20 05
;	B22_08e1:		bmi B22_0913 ; 30 30
;	
;	B22_08e3:		cmp #$03		; c9 03
;	B22_08e5:		bne B22_08fd ; d0 16
;	
;	B22_08e7:		ldy #$00		; a0 00
;	B22_08e9:		lda wCurrRoomGroup		; a5 32
;	B22_08eb:		cmp #$08		; c9 08
;	B22_08ed:		bne B22_08f5 ; d0 06
;	
;	B22_08ef:		iny				; c8 
;	B22_08f0:		lda wCurrRoomSection			; a5 33
;	B22_08f2:		bne B22_08f5 ; d0 01
;	
;	B22_08f4:		iny				; c8 
;	B22_08f5:		lda wEntityBaseY, x	; bd 1c 04
;	B22_08f8:		cmp $8937, y	; d9 37 89
;	B22_08fb:		bcs B22_092b ; b0 2e
;	
;	B22_08fd:		ldy #$06		; a0 06
;	B22_08ff:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_0902:		beq B22_0913 ; f0 0f
;	
;	B22_0904:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0906:		jmp $88b3		; 4c b3 88
;	
;	B22_0909:		lda wEntityBaseY, x	; bd 1c 04
;	B22_090c:		cmp #$f8		; c9 f8
;	B22_090e:		bcc B22_0913 ; 90 03
;	
;	B22_0910:		inc wEntityPhase, x	; fe c1 05
;	B22_0913:		rts				; 60 
;	
;	
;	B22_0914:		ldy #$00		; a0 00
;	B22_0916:		lda wCurrRoomGroup		; a5 32
;	B22_0918:		cmp #RG_SUNKEN_CITY		; c9 08
;	B22_091a:		beq B22_091d ; f0 01
;	
;	B22_091c:		iny				; c8 
;	B22_091d:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0920:		cmp $8935, y	; d9 35 89
;	B22_0923:		bcc B22_0913 ; 90 ee
;	
;	B22_0925:		inc wEntityPhase, x	; fe c1 05
;	B22_0928:		jmp $992b		; 4c 2b 99
;	
;	
;	B22_092b:		ldy #$02		; a0 02
;	B22_092d:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_092f:		sta wEntityPhase, x	; 9d c1 05
;	B22_0932:		jmp $992b		; 4c 2b 99
;	
;	
;	B22_0935:		;removed
;		.db $b0 $d0
;	
;	B22_0937:		;removed
;		.db $d0 $c0
;	
;	B22_0939:		;removed
;		.db $b0
;		
;	
;	entityPhaseFunc_1c:
;		ldy #$01
;	B22_093c:		jsr $b7a6
;	B22_093f:		bne B22_0957 ; d0 16
;	
;	B22_0941:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0943:		ldy #$06		; a0 06
;	B22_0945:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_0948:		bne B22_0957 ; d0 0d
;	
;	B22_094a:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_094c:		inc wEntityPhase, x	; fe c1 05
;	B22_094f:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0952:		lda #$01		; a9 01
;	B22_0954:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0957:		ldy #$00		; a0 00
;	B22_0959:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_095c:		beq B22_0969 ; f0 0b
;	
;	entityReverseFacingDirAndHorizSpeed:
;		lda wEntityFacingLeft, x
;		eor #$01
;		sta wEntityFacingLeft, x
;		jmp reverseEntityHorizSpeed
;	
;	
;	B22_0969:		lda wEntityAI_idx, x	; bd ef 05
;	B22_096c:		cmp #$02		; c9 02
;	B22_096e:		bne B22_097d ; d0 0d
;	
;	B22_0970:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0972:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0975:		bne B22_097d ; d0 06
;	
;	B22_0977:		inc wEntityPhase, x	; fe c1 05
;	B22_097a:		inc wEntityPhase, x	; fe c1 05
;	B22_097d:		rts				; 60 
;	
;	
;	entityPhaseFunc_1d:
;	B22_097e:		ldy #$01		; a0 01
;	B22_0980:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0982:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0985:		iny				; c8 
;	B22_0986:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0988:		tay				; a8 
;	B22_0989:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_098c:		beq B22_09a5 ; f0 17
;	
;	B22_098e:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0990:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0993:		jsr setEntityStateAnimated		; 20 f8 81
;	B22_0996:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0999:		and #$f0		; 29 f0
;	B22_099b:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_099e:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_09a1:		sta wEntityPhase, x	; 9d c1 05
;	B22_09a4:		rts				; 60 
;	
;	
;	B22_09a5:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_09a7:		lda #$14		; a9 14
;	B22_09a9:		jmp addAtoEntityVertSpeed		; 4c 7f 80
;	
;	
;	entityPhaseFunc_09:
;	B22_09ac:		jsr incEntityPhase_setUnanimated		; 20 ec 81
;	B22_09af:		lda wGameStateLoopCounter			; a5 1a
;	B22_09b1:		adc wEntityBaseX, x	; 7d 38 04
;	B22_09b4:		and #$07		; 29 07
;	B22_09b6:		sta $00			; 85 00
;	B22_09b8:		lda wCurrRoomSection			; a5 33
;	B22_09ba:		beq B22_09be ; f0 02
;	
;	B22_09bc:		lda #$01		; a9 01
;	B22_09be:		clc				; 18 
;	B22_09bf:		adc wHardMode		; 6d f6 07
;	B22_09c2:		tay				; a8 
;	B22_09c3:		lda $89f5, y	; b9 f5 89
;	B22_09c6:		adc $00			; 65 00
;	B22_09c8:		tay				; a8 
;	B22_09c9:		lda $89dd, y	; b9 dd 89
;	B22_09cc:		adc wEntityBaseX		; 6d 38 04
;	B22_09cf:		sta wEntityBaseX, x	; 9d 38 04
;	B22_09d2:		lda wEntityAI_idx, x	; bd ef 05
;	B22_09d5:		cmp #$14		; c9 14
;	B22_09d7:		beq B22_09dc ; f0 03
;	
;	B22_09d9:		jmp $81d4		; 4c d4 81
;	
;	
;	B22_09dc:		rts				; 60 
;	
;	
;	B22_09dd:		pla				; 68 
;	B22_09de:		ldy #$68		; a0 68
;	B22_09e0:		dey				; 88 
;	B22_09e1:		tya				; 98 
;	B22_09e2:		sei				; 78 
;	B22_09e3:		;removed
;		.db $90 $70
;	
;	B22_09e5:		cli				; 58 
;	B22_09e6:		jmp $a048		; 4c 48 a0
;	
;	
;	B22_09e9:	.db $5c
;	B22_09ea:		rts				; 60 
;	
;	
;	B22_09eb:		cpy #$50		; c0 50
;	B22_09ed:		;removed
;		.db $30 $d8
;	
;	B22_09ef:		sec				; 38 
;	B22_09f0:		rti				; 40 
;	
;	
;	B22_09f1:		sec				; 38 
;	B22_09f2:	.db $44
;	B22_09f3:		cpy #$2c		; c0 2c
;	B22_09f5:		.db $00				; 00
;	B22_09f6:		php				; 08 
;	B22_09f7:		.db $10
;	
;	
;	entityPhaseFunc_22:
;		inc $05c1, x
;	B22_09fb:		lda wGameStateLoopCounter			; a5 1a
;	B22_09fd:		adc wEntityBaseX		; 6d 38 04
;	B22_0a00:		and #$07		; 29 07
;	B22_0a02:		sta $10			; 85 10
;	B22_0a04:		ldy #$01		; a0 01
;	B22_0a06:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0a08:		clc				; 18 
;	B22_0a09:		adc $10			; 65 10
;	B22_0a0b:		tay				; a8 
;	B22_0a0c:		lda $8a16, y	; b9 16 8a
;	B22_0a0f:		adc wEntityBaseX		; 6d 38 04
;	B22_0a12:		sta wEntityBaseX, x	; 9d 38 04
;	B22_0a15:		rts				; 60 
;	
;	
;	B22_0a16:		rti				; 40 
;	
;	
;	B22_0a17:		bne B22_0a89 ; d0 70
;	
;	B22_0a19:		bcc B22_0a7b ; 90 60
;	
;	B22_0a1b:		cpy #$50		; c0 50
;	B22_0a1d:		ldy #$40		; a0 40
;	B22_0a1f:		jsr $d0e0		; 20 e0 d0
;	B22_0a22:		;removed
;		.db $10 $f0
;	
;	B22_0a24:		;removed
;		.db $50 $70
;	
;	
;	entityPhaseFunc_a7:
;	B22_0a26:		jsr $81ef		; 20 ef 81
;	
;	entityPhaseFunc_26:
;	B22_0a29:		inc wEntityPhase, x	; fe c1 05
;	B22_0a2c:		ldy #$01		; a0 01
;	B22_0a2e:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0a30:		sta $061d, x	; 9d 1d 06
;	B22_0a33:		iny				; c8 
;	B22_0a34:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0a36:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0a39:		rts				; 60 
;	
;	
;	entityPhaseFunc_30:
;	B22_0a3a:		inc wEntityPhase, x	; fe c1 05
;	B22_0a3d:		ldy #$01		; a0 01
;	B22_0a3f:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0a41:		sta wEntityPaletteOverride, x	; 9d 54 04
;	B22_0a44:		rts				; 60 
;	
;	
;	entityPhaseFunc_23:
;	B22_0a45:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0a48:		bne B22_0a64 ; d0 1a
;	
;	B22_0a4a:		ldy #$01		; a0 01
;	B22_0a4c:		lda wEntityPaletteOverride, x	; bd 54 04
;	B22_0a4f:		eor (wPhaseFuncDataAddr), y	; 51 02
;	B22_0a51:		sta wEntityPaletteOverride, x	; 9d 54 04
;	B22_0a54:		jsr $8a33		; 20 33 8a
;	B22_0a57:		dec $061d, x	; de 1d 06
;	B22_0a5a:		bne B22_0a64 ; d0 08
;	
;	B22_0a5c:		lda #$00		; a9 00
;	B22_0a5e:		sta wEntityPaletteOverride, x	; 9d 54 04
;	B22_0a61:		inc wEntityPhase, x	; fe c1 05
;	B22_0a64:		rts				; 60 
;	
;	
;	entityPhaseFunc_25:
;	B22_0a65:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0a68:		bne B22_0a64 ; d0 fa
;	
;	B22_0a6a:		dec $061d, x	; de 1d 06
;	B22_0a6d:		beq B22_0a61 ; f0 f2
;	
;	B22_0a6f:		ldy #$01		; a0 01
;	B22_0a71:		lda wCurrRoomGroup		; a5 32
;	B22_0a73:		cmp #$09		; c9 09
;	B22_0a75:		bcc B22_0a79 ; 90 02
;	
;	B22_0a77:		ldy #$02		; a0 02
;	B22_0a79:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0a7b:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0a7e:		lda wEntityState, x	; bd 70 04
;	B22_0a81:		and #ES_INVISIBLE|ES_DESTROYED		; 29 81
;	B22_0a83:		bne B22_0a64 ; d0 df
;	
;	B22_0a85:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_0a88:		asl a			; 0a
;	B22_0a89:		tay				; a8 
;	B22_0a8a:		lda wEntityBaseX		; ad 38 04
;	B22_0a8d:		cmp wEntityBaseX, x	; dd 38 04
;	B22_0a90:		bcc B22_0a93 ; 90 01
;	
;	B22_0a92:		iny				; c8 
;	B22_0a93:		clc				; 18 
;	B22_0a94:		lda $8ac7, y	; b9 c7 8a
;	B22_0a97:		adc wEntityBaseX, x	; 7d 38 04
;	B22_0a9a:		sta $01			; 85 01
;	B22_0a9c:		clc				; 18 
;	B22_0a9d:		lda $8acb, y	; b9 cb 8a
;	B22_0aa0:		adc wEntityBaseY, x	; 7d 1c 04
;	B22_0aa3:		sta $02			; 85 02
;	B22_0aa5:		lda $8acf, y	; b9 cf 8a
;	B22_0aa8:		sta $0a			; 85 0a
;	B22_0aaa:		lda #$58		; a9 58
;	B22_0aac:		sta $07			; 85 07
;	B22_0aae:		lda #$40		; a9 40
;	B22_0ab0:		sta $00			; 85 00
;	B22_0ab2:		tya				; 98 
;	B22_0ab3:		and #$01		; 29 01
;	B22_0ab5:		eor #$01		; 49 01
;	B22_0ab7:		ldy wCurrRoomGroup			; a4 32
;	B22_0ab9:		cpy #$09		; c0 09
;	B22_0abb:		bcc B22_0ac0 ; 90 03
;	
;	B22_0abd:		clc				; 18 
;	B22_0abe:		adc #$10		; 69 10
;	B22_0ac0:		tay				; a8 
;	B22_0ac1:		jsr $8e9f		; 20 9f 8e
;	B22_0ac4:		jmp $8dca		; 4c ca 8d
;	
;	
;	B22_0ac7:		sed				; f8 
;	B22_0ac8:		php				; 08 
;	B22_0ac9:		sed				; f8 
;	B22_0aca:		php				; 08 
;	B22_0acb:		ora #$fa		; 09 fa
;	B22_0acd:	.db $fa
;	B22_0ace:		ora #$00		; 09 00
;	B22_0ad0:		ora ($00, x)	; 01 00
;	B22_0ad2:		.db $01
;	
;	
;	entityPhaseFunc_24:
;		jsr $8230
;	B22_0ad6:		jmp $844c		; 4c 4c 84
;	
;	
;	entityPhaseFunc_6e:
;	B22_0ad9:		jsr incEntityPhase_setUnanimated		; 20 ec 81
;	B22_0adc:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_0adf:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_0ae2:		rts				; 60 
;	
;	
;	entityPhaseFunc_52:
;	B22_0ae3:		inc wEntityPhase, x	; fe c1 05
;	B22_0ae6:		jmp $8a7e		; 4c 7e 8a
;	
;	
;	entityPhaseFunc_31:
;	entityPhaseFunc_32:
;	B22_0ae9:		ldy #$01		; a0 01
;	B22_0aeb:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0aed:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_0af0:		jmp $8e20		; 4c 20 8e
;	
;	
;	entityPhaseFunc_92:
;	B22_0af3:		clc				; 18 
;	B22_0af4:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0af7:		adc #$10		; 69 10
;	B22_0af9:		sta $00			; 85 00
;	B22_0afb:		lda wEntityBaseX, x	; bd 38 04
;	B22_0afe:		sta $01			; 85 01
;	B22_0b00:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_0b03:		sta $02			; 85 02
;	B22_0b05:		lda wEntityState, x	; bd 70 04
;	B22_0b08:		ora #ES_MOVING|ES_UNANIMATED		; 09 60
;	B22_0b0a:		sta $03			; 85 03
;	B22_0b0c:		stx $08			; 86 08
;	B22_0b0e:		jsr $8b5a		; 20 5a 8b
;	B22_0b11:		bne B22_0b4c ; d0 39
;	
;	B22_0b13:		stx $09			; 86 09
;	B22_0b15:		ldx $08			; a6 08
;	B22_0b17:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_0b1a:		jsr $81ef		; 20 ef 81
;	B22_0b1d:		ldx $09			; a6 09
;	B22_0b1f:		jsr clearAllEntityVars_todo		; 20 d7 fe
;	B22_0b22:		jsr $8b4f		; 20 4f 8b
;	B22_0b25:		lda $02			; a5 02
;	B22_0b27:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_0b2a:		lda $03			; a5 03
;	B22_0b2c:		sta wEntityState, x	; 9d 70 04
;	B22_0b2f:		jsr $9fc9		; 20 c9 9f
;	B22_0b32:		lda #$52		; a9 52
;	B22_0b34:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0b37:		lda #$69		; a9 69
;	B22_0b39:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0b3c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0b3e:		lda #$72		; a9 72
;	B22_0b40:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0b43:		lda #$10		; a9 10
;	B22_0b45:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0b48:		inc wEntityPhase, x	; fe c1 05
;	B22_0b4b:		rts				; 60 
;	
;	
;	B22_0b4c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0b4e:		rts				; 60 
;	
;	
;	B22_0b4f:		lda $00			; a5 00
;	B22_0b51:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0b54:		lda $01			; a5 01
;	B22_0b56:		sta wEntityBaseX, x	; 9d 38 04
;	B22_0b59:		rts				; 60 
;	
;	
;	B22_0b5a:		ldx #$01		; a2 01
;	B22_0b5c:		lda wEntityObjectIdxes, x	; bd 4e 05
;	B22_0b5f:		beq B22_0b68 ; f0 07
;	
;	B22_0b61:		inx				; e8 
;	B22_0b62:		cpx #$04		; e0 04
;	B22_0b64:		bcc B22_0b5c ; 90 f6
;	
;	B22_0b66:		lda #$01		; a9 01
;	B22_0b68:		rts				; 60 
;	
;	
;	entityPhaseFunc_93:
;	B22_0b69:		jsr $81a7		; 20 a7 81
;	B22_0b6c:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0b6f:		lda #$14		; a9 14
;	B22_0b71:		sta $061d, x	; 9d 1d 06
;	B22_0b74:		rts				; 60 
;	
;	
;	entityPhaseFunc_94:
;	B22_0b75:		lda $061d, x	; bd 1d 06
;	B22_0b78:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_0b7b:		ldy #$0e		; a0 0e
;	B22_0b7d:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_0b80:		beq B22_0b8e ; f0 0c
;	
;	B22_0b82:		jsr snapEntityXsYtoTile		; 20 91 8b
;	B22_0b85:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0b88:		sta $061d, x	; 9d 1d 06
;	B22_0b8b:		inc wEntityPhase, x	; fe c1 05
;	B22_0b8e:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0b90:		rts				; 60 
;	
org $8b91	
	snapEntityXsYtoTile:
;		lda wCurrRoomMetadataByte
;		bmi @vertRoom
;	
;	; snap entity Y to tile
;		lda wEntityBaseY, x
;		and #$f0
;		sta wEntityBaseY, x
;		rts
;	
;	@vertRoom:
;	; snap for vert room, aligning tile to top of room screen
;		clc
;		lda wEntityBaseY, x
;		adc wCurrScrollOffsetIntoRoomScreen
;		and #$f0
;		sec
;		sbc wCurrScrollOffsetIntoRoomScreen
;		clc
;		adc #$03
;		sta wEntityBaseY, x
;		rts
;	
;	
;	entityPhaseFunc_90:
;	B22_0bb0:		inc wEntityPhase, x	; fe c1 05
;	B22_0bb3:		ldy #$00		; a0 00
;	B22_0bb5:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_0bb8:		cmp #$40		; c9 40
;	B22_0bba:		bcs B22_0bbd ; b0 01
;	
;	B22_0bbc:		iny				; c8 
;	B22_0bbd:		tya				; 98 
;	B22_0bbe:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0bc1:		rts				; 60 
;	
;	
;	entityPhaseFunc_8f:
;	B22_0bc2:		inc wEntityPhase, x	; fe c1 05
;	B22_0bc5:		lda #$32		; a9 32
;	B22_0bc7:		ldy wOamSpecIdxDoubled, x	; bc 00 04
;	B22_0bca:		cpy #$30		; c0 30
;	B22_0bcc:		beq B22_0bd0 ; f0 02
;	
;	B22_0bce:		lda #$54		; a9 54
;	B22_0bd0:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0bd3:		rts				; 60 
;	
;	
;	entityPhaseFunc_3a:
;	B22_0bd4:		jsr $83ad		; 20 ad 83
;	B22_0bd7:		clc				; 18 
;	B22_0bd8:		ldy #$03		; a0 03
;	B22_0bda:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0bdc:		adc wEntityFacingLeft, x	; 7d a8 04
;	B22_0bdf:		tay				; a8 
;	B22_0be0:		lda $8bef, y	; b9 ef 8b
;	B22_0be3:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_0be6:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_0be9:		jsr func_16_0001		; 20 01 80
;	B22_0bec:		jmp clearEntityHorizVertSpeeds		; 4c c8 fe
;	
;	
;	B22_0bef:		php				; 08 
;	B22_0bf0:		sed				; f8 
;	B22_0bf1:		sed				; f8 
;	B22_0bf2:		php				; 08 
;	B22_0bf3:		;removed
;		.db $10 $f0
;	
;	B22_0bf5:		beq B22_0c07 ; f0 10
;	
;	
;	entityPhaseFunc_96:
;	B22_0bf7:		jsr $81d4		; 20 d4 81
;	B22_0bfa:		jsr $80e3		; 20 e3 80
;	B22_0bfd:		bne B22_0c1f ; d0 20
;	
;	B22_0bff:		jsr $81d4		; 20 d4 81
;	B22_0c02:		lda #$68		; a9 68
;	B22_0c04:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0c07:		lda #$00		; a9 00
;	B22_0c09:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0c0c:		sta wEntityPhase, x	; 9d c1 05
;	B22_0c0f:		txa				; 8a 
;	B22_0c10:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0c12:		sta $061d, x	; 9d 1d 06
;	B22_0c15:		lda #$08		; a9 08
;	B22_0c17:		ldy #$0c		; a0 0c
;	B22_0c19:		jsr entityInitAnimation_specGroupA_animationDefIdxY		; 20 93 82
;	B22_0c1c:		jmp $81b9		; 4c b9 81
;	
;	
;	B22_0c1f:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0c21:		rts				; 60 
;	
;	
;	entityPhaseFunc_50:
;	B22_0c22:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0c25:		jsr $81a7		; 20 a7 81
;	B22_0c28:		lda #$01		; a9 01
;	B22_0c2a:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_0c2d:		ldy #$01		; a0 01
;	B22_0c2f:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0c31:		tay				; a8 
;	B22_0c32:		lda $8c60, y	; b9 60 8c
;	B22_0c35:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0c38:		lda $8c62, y	; b9 62 8c
;	B22_0c3b:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0c3e:		lda #$50		; a9 50
;	B22_0c40:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0c43:		stx $08			; 86 08
;	B22_0c45:		lda $061d, x	; bd 1d 06
;	B22_0c48:		tax				; aa 
;	B22_0c49:		lda #$57		; a9 57
;	B22_0c4b:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0c4e:		lda #$00		; a9 00
;	B22_0c50:		sta wEntityPhase, x	; 9d c1 05
;	B22_0c53:		lda #$68		; a9 68
;	B22_0c55:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0c58:		lda $08			; a5 08
;	B22_0c5a:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0c5d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0c5f:		rts				; 60 
;	
;	
;	B22_0c60:		ora ($fe, x)	; 01 fe
;	B22_0c62:		.db $20 $d0
;	
;	
;	entityPhaseFunc_51:
;		lda $041c, x
;	B22_0c67:		cmp #$30		; c9 30
;	B22_0c69:		bcc B22_0c77 ; 90 0c
;	
;	B22_0c6b:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0c6e:		bne B22_0c5f ; d0 ef
;	
;	B22_0c70:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0c73:		inc wEntityPhase, x	; fe c1 05
;	B22_0c76:		rts				; 60 
;	
;	
;	B22_0c77:		jsr $81d4		; 20 d4 81
;	B22_0c7a:		jsr $81c5		; 20 c5 81
;	B22_0c7d:		lda #$30		; a9 30
;	B22_0c7f:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0c82:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_0c85:		sta wEntityFractionalY, x	; 9d db 04
;	B22_0c88:		lda $061d, x	; bd 1d 06
;	B22_0c8b:		tax				; aa 
;	B22_0c8c:		lda #$00		; a9 00
;	B22_0c8e:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0c91:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0c94:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0c97:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0c99:		rts				; 60 
;	
;	
;	entityPhaseFunc_9b:
;	B22_0c9a:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_0c9d:		tax				; aa 
;	B22_0c9e:		lda wEntityBaseX, x	; bd 38 04
;	B22_0ca1:		sta $08			; 85 08
;	B22_0ca3:		lda wEntityState, x	; bd 70 04
;	B22_0ca6:		ora #ES_UNANIMATED|ES_ILLUSION		; 09 30
;	B22_0ca8:		and #$bb		; 29 bb
;	B22_0caa:		sta $09			; 85 09
;	B22_0cac:		lda #$30		; a9 30
;	B22_0cae:		sta $11			; 85 11
;	B22_0cb0:		jsr $80c1		; 20 c1 80
;	B22_0cb3:		lsr a			; 4a
;	B22_0cb4:		lsr a			; 4a
;	B22_0cb5:		lsr a			; 4a
;	B22_0cb6:		lsr a			; 4a
;	B22_0cb7:		tay				; a8 
;	B22_0cb8:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0cba:		lda $8cdb, y	; b9 db 8c
;	B22_0cbd:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0cc0:		lda #$08		; a9 08
;	B22_0cc2:		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
;	B22_0cc5:		lda #$01		; a9 01
;	B22_0cc7:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_0cca:		lda $8ce5, y	; b9 e5 8c
;	B22_0ccd:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0cd0:		lda $08			; a5 08
;	B22_0cd2:		sta wEntityBaseX, x	; 9d 38 04
;	B22_0cd5:		lda $09			; a5 09
;	B22_0cd7:		sta wEntityState, x	; 9d 70 04
;	B22_0cda:		rts				; 60 
;	
;	
;	B22_0cdb:		cpy #$c2		; c0 c2
;	B22_0cdd:		cpy $c6			; c4 c6
;	B22_0cdf:		iny				; c8 
;	B22_0ce0:		cld				; d8 
;	B22_0ce1:		cld				; d8 
;	B22_0ce2:		cld				; d8 
;	B22_0ce3:		cld				; d8 
;	B22_0ce4:		cld				; d8 
;	B22_0ce5:		bmi B22_0d1f ; 30 38
;	
;	B22_0ce7:		rti				; 40 
;	
;	
;	B22_0ce8:		pha				; 48 
;	B22_0ce9:		;removed
;		.db $50 $58
;	
;	B22_0ceb:		rts				; 60 
;	
;	
;	B22_0cec:		pla				; 68 
;	B22_0ced:		bvs B22_0d67 ; 70 78
;	
;	
;	entityPhaseFunc_5d:
;	B22_0cef:		lda #$02		; a9 02
;	B22_0cf1:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0cf4:		ldy wEntityAlarmOrStartYforSinusoidalMovement, x	; bc 06 06
;	B22_0cf7:		lda $8d1c, y	; b9 1c 8d
;	B22_0cfa:		tay				; a8 
;	B22_0cfb:		lda wEntityBaseX, x	; bd 38 04
;	B22_0cfe:		jsr $fc16		; 20 16 fc
;	B22_0d01:		bne B22_0d0d ; d0 0a
;	
;	B22_0d03:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0d05:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_0d08:		bne B22_0cf4 ; d0 ea
;	
;	B22_0d0a:		jmp $84b2		; 4c b2 84
;	
;	
;	B22_0d0d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0d0f:		ldy wEntityAlarmOrStartYforSinusoidalMovement, x	; bc 06 06
;	B22_0d12:		lda $8d1f, y	; b9 1f 8d
;	B22_0d15:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0d18:		inc wEntityPhase, x	; fe c1 05
;	B22_0d1b:		rts				; 60 
;	
;	
;	B22_0d1c:		.db $00				; 00
;	B22_0d1d:		ldy $a4, x		; b4 a4
;	B22_0d1f:		.db $00				; 00
;	B22_0d20:		ldy #$90		; a0 90
;	
;	
;	entityPhaseFunc_89:
;	B22_0d22:		ldy #$01		; a0 01
;	B22_0d24:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0d26:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0d29:		clc				; 18 
;	B22_0d2a:		adc #$10		; 69 10
;	B22_0d2c:		tay				; a8 
;	B22_0d2d:		lda wEntityBaseX, x	; bd 38 04
;	B22_0d30:		jsr $fc16		; 20 16 fc
;	B22_0d33:		cmp #$01		; c9 01
;	B22_0d35:		bne B22_0d57 ; d0 20
;	
;	B22_0d37:		beq B22_0d72 ; f0 39
;	
;	
;	entityPhaseFunc_5f:
;	B22_0d39:		lda #$a8		; a9 a8
;	B22_0d3b:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0d3e:		clc				; 18 
;	B22_0d3f:		adc #$10		; 69 10
;	B22_0d41:		tay				; a8 
;	B22_0d42:		lda wEntityBaseX, x	; bd 38 04
;	B22_0d45:		jsr $fc16		; 20 16 fc
;	B22_0d48:		cmp #$01		; c9 01
;	B22_0d4a:		bne B22_0d57 ; d0 0b
;	
;	B22_0d4c:		ldy wEntityBaseY, x	; bc 1c 04
;	B22_0d4f:		lda wEntityBaseX, x	; bd 38 04
;	B22_0d52:		jsr $fc16		; 20 16 fc
;	B22_0d55:		beq B22_0d5c ; f0 05
;	
;	B22_0d57:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0d59:		jmp $84b2		; 4c b2 84
;	
;	
;	B22_0d5c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0d5e:		sec				; 38 
;	B22_0d5f:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0d62:		sbc #$08		; e9 08
;	B22_0d64:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0d67:		lda #$00		; a9 00
;	B22_0d69:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0d6c:		jsr $81ef		; 20 ef 81
;	B22_0d6f:		jsr $81d4		; 20 d4 81
;	B22_0d72:		inc wEntityPhase, x	; fe c1 05
;	B22_0d75:		rts				; 60 
;	
;	
;	entityPhaseFunc_8e:
;	B22_0d76:		txa				; 8a 
;	B22_0d77:		and #$01		; 29 01
;	B22_0d79:		tay				; a8 
;	B22_0d7a:		lda $8d84, y	; b9 84 8d
;	B22_0d7d:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_0d80:		inc wEntityPhase, x	; fe c1 05
;	B22_0d83:		rts				; 60 
;	
;	
;	B22_0d84:		rti				; 40 
;	
;	
;	B22_0d85:		;removed
;		.db $d0
;		
;		
;	entityPhaseFunc_65:
;		ldy #$01
;	B22_0d88:		lda (wPhaseFuncDataAddr), y
;	B22_0d8a:		sta $00			; 85 00
;	B22_0d8c:		iny				; c8 
;	B22_0d8d:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0d8f:		ldy $00			; a4 00
;	B22_0d91:		jsr func_1f_1c1e		; 20 1e fc
;	B22_0d94:		bne B22_0d57 ; d0 c1
;	
;	B22_0d96:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0d98:		inc wEntityPhase, x	; fe c1 05
;	B22_0d9b:		rts				; 60 
;	
;	
;	entityPhaseFunc_4e:
;	B22_0d9c:		lda #$0e		; a9 0e
;	B22_0d9e:		ldy #$01		; a0 01
;	B22_0da0:		jsr entityInitAnimation_specGroupA_animationDefIdxY		; 20 93 82
;	B22_0da3:		inc wEntityPhase, x	; fe c1 05
;	B22_0da6:		lda wCurrRoomSection			; a5 33
;	B22_0da8:		beq B22_0dbe ; f0 14
;	
;	B22_0daa:		cmp #$01		; c9 01
;	B22_0dac:		beq B22_0dba ; f0 0c
;	
;	B22_0dae:		cmp #$02		; c9 02
;	B22_0db0:		beq B22_0dba ; f0 08
;	
;	B22_0db2:		cmp #$03		; c9 03
;	B22_0db4:		beq B22_0dc4 ; f0 0e
;	
;	B22_0db6:		lda wCurrRoomIdx			; a5 34
;	B22_0db8:		bne B22_0dc4 ; d0 0a
;	
;	B22_0dba:		lda #$00		; a9 00
;	B22_0dbc:		beq B22_0dc6 ; f0 08
;	
;	B22_0dbe:		lda wCurrRoomIdx			; a5 34
;	B22_0dc0:		cmp #$02		; c9 02
;	B22_0dc2:		bne B22_0dba ; d0 f6
;	
;	B22_0dc4:		lda #$03		; a9 03
;	B22_0dc6:		sta wEntityPaletteOverride, x	; 9d 54 04
;	B22_0dc9:		rts				; 60 
;	
;	
;	B22_0dca:		jsr $80e3		; 20 e3 80
;	B22_0dcd:		bne B22_0e0c ; d0 3d
;	
;	B22_0dcf:		jsr clearAllEntityVars_todo		; 20 d7 fe
;	B22_0dd2:		lda $01			; a5 01
;	B22_0dd4:		sta wEntityBaseX, x	; 9d 38 04
;	B22_0dd7:		lda $02			; a5 02
;	B22_0dd9:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0ddc:		lda $03			; a5 03
;	B22_0dde:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_0de1:		lda $04			; a5 04
;	B22_0de3:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_0de6:		lda $05			; a5 05
;	B22_0de8:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0deb:		lda $06			; a5 06
;	B22_0ded:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0df0:		lda #ES_MOVING|ES_UNANIMATED		; a9 60
;	B22_0df2:		sta wEntityState, x	; 9d 70 04
;	B22_0df5:		lda $00			; a5 00
;	B22_0df7:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0dfa:		lda $0a			; a5 0a
;	B22_0dfc:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_0dff:		jsr $9fc9		; 20 c9 9f
;	B22_0e02:		lda $07			; a5 07
;	B22_0e04:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0e07:		stx $08			; 86 08
;	B22_0e09:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0e0b:		rts				; 60 
;	
;	
;	B22_0e0c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0e0e:		lda #$00		; a9 00
;	B22_0e10:		rts				; 60 
;	
;	
;	func_16_0e11:
;	B22_0e11:		jsr $8e6f		; 20 6f 8e
;	B22_0e14:		jsr $feb9		; 20 b9 fe
;	B22_0e17:		bne B22_0e0c ; d0 f3
;	
;	B22_0e19:		lda #$00		; a9 00
;	B22_0e1b:		sta $0a			; 85 0a
;	B22_0e1d:		jmp $8dcf		; 4c cf 8d
;	
;	
;	entityPhaseFunc_0e:
;	B22_0e20:		lda wEntityBaseX, x	; bd 38 04
;	B22_0e23:		cmp #$04		; c9 04
;	B22_0e25:		bcc B22_0e36 ; 90 0f
;	
;	B22_0e27:		cmp #$fc		; c9 fc
;	B22_0e29:		bcs B22_0e36 ; b0 0b
;	
;	B22_0e2b:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0e2e:		cmp #$18		; c9 18
;	B22_0e30:		bcc B22_0e36 ; 90 04
;	
;	B22_0e32:		cmp #$e8		; c9 e8
;	B22_0e34:		bcc B22_0e3e ; 90 08
;	
;	func_16_0e36:
;	B22_0e36:		lda #$00		; a9 00
;	B22_0e38:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0e3b:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_0e3e:		rts				; 60 
;	
;	
;	entityPhaseFunc_9a:
;	B22_0e3f:		lda wEntityState, x	; bd 70 04
;	B22_0e42:		and #ES_INVISIBLE|ES_DESTROYED		; 29 81
;	B22_0e44:		bne B22_0e51 ; d0 0b
;	
;	B22_0e46:		lda wEntityBaseX, x	; bd 38 04
;	B22_0e49:		cmp #$f8		; c9 f8
;	B22_0e4b:		bcs B22_0e51 ; b0 04
;	
;	B22_0e4d:		cmp #$08		; c9 08
;	B22_0e4f:		bcs B22_0e55 ; b0 04
;	
;	B22_0e51:		inc wEntityPhase, x	; fe c1 05
;	B22_0e54:		rts				; 60 
;	
;	
;	B22_0e55:		lda #$32		; a9 32
;	B22_0e57:		jsr playSound		; 20 5f e2
;	
;	entityPhaseFunc_0d:
;	B22_0e5a:		inc wEntityPhase, x	; fe c1 05
;	B22_0e5d:		lda wEntityState, x	; bd 70 04
;	B22_0e60:		and #ES_INVISIBLE|ES_DESTROYED		; 29 81
;	B22_0e62:		bne B22_0e3e ; d0 da
;	
;	B22_0e64:		ldy #$01		; a0 01
;	B22_0e66:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_0e68:		tay				; a8 
;	B22_0e69:		jsr $8e6f		; 20 6f 8e
;	B22_0e6c:		jmp $8dca		; 4c ca 8d
;	
;	
;	B22_0e6f:		clc				; 18 
;	B22_0e70:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0e73:		adc $8ecc, y	; 79 cc 8e
;	B22_0e76:		sta $02			; 85 02
;	B22_0e78:		lda $8ed4, y	; b9 d4 8e
;	B22_0e7b:		sta $07			; 85 07
;	B22_0e7d:		lda $8ec4, y	; b9 c4 8e
;	B22_0e80:		sta $00			; 85 00
;	B22_0e82:		lda $8ebc, y	; b9 bc 8e
;	B22_0e85:		beq B22_0e8d ; f0 06
;	
;	B22_0e87:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_0e8a:		eor $8eb4, y	; 59 b4 8e
;	B22_0e8d:		sta $0a			; 85 0a
;	B22_0e8f:		clc				; 18 
;	B22_0e90:		tya				; 98 
;	B22_0e91:		asl a			; 0a
;	B22_0e92:		adc wEntityFacingLeft, x	; 7d a8 04
;	B22_0e95:		tay				; a8 
;	B22_0e96:		clc				; 18 
;	B22_0e97:		lda $8edc, y	; b9 dc 8e
;	B22_0e9a:		adc wEntityBaseX, x	; 7d 38 04
;	B22_0e9d:		sta $01			; 85 01
;	B22_0e9f:		lda $8eec, y	; b9 ec 8e
;	B22_0ea2:		sta $03			; 85 03
;	B22_0ea4:		lda $8efe, y	; b9 fe 8e
;	B22_0ea7:		sta $04			; 85 04
;	B22_0ea9:		lda $8f10, y	; b9 10 8f
;	B22_0eac:		sta $05			; 85 05
;	B22_0eae:		lda $8f22, y	; b9 22 8f
;	B22_0eb1:		sta $06			; 85 06
;	B22_0eb3:		rts				; 60 
;	
;	
;	B22_0eb4:		.db $00				; 00
;	B22_0eb5:		.db $00				; 00
;	B22_0eb6:		.db $00				; 00
;	B22_0eb7:		ora ($00, x)	; 01 00
;	B22_0eb9:		.db $00				; 00
;	B22_0eba:		.db $00				; 00
;	B22_0ebb:		.db $00				; 00
;	B22_0ebc:		ora ($00, x)	; 01 00
;	B22_0ebe:		.db $00				; 00
;	B22_0ebf:		ora ($00, x)	; 01 00
;	B22_0ec1:		ora ($00, x)	; 01 00
;	B22_0ec3:		.db $00				; 00
;	B22_0ec4:		rti				; 40 
;	
;	
;	B22_0ec5:		eor ($42, x)	; 41 42
;	B22_0ec7:		rti				; 40 
;	
;	
;	B22_0ec8:	.db $43
;	B22_0ec9:	.db $44
;	B22_0eca:		eor $41			; 45 41
;	B22_0ecc:		inc $04f6, x	; fe f6 04
;	B22_0ecf:	.db $f7
;	B22_0ed0:	.db $f4
;	B22_0ed1:	.db $fb
;	B22_0ed2:		.db $00				; 00
;	B22_0ed3:		ora #$58		; 09 58
;	B22_0ed5:		eor $585a, y	; 59 5a 58
;	B22_0ed8:	.db $5b
;	B22_0ed9:	.db $5c
;	B22_0eda:		eor $0859, x	; 5d 59 08
;	B22_0edd:		sed				; f8 
;	B22_0ede:	.db $14
;	B22_0edf:		cpx $fc04		; ec 04 fc
;	B22_0ee2:		php				; 08 
;	B22_0ee3:		sed				; f8 
;	B22_0ee4:		.db $00				; 00
;	B22_0ee5:		.db $00				; 00
;	B22_0ee6:		php				; 08 
;	B22_0ee7:		sed				; f8 
;	B22_0ee8:		.db $00				; 00
;	B22_0ee9:		.db $00				; 00
;	B22_0eea:		php				; 08 
;	B22_0eeb:		sed				; f8 
;	B22_0eec:	.db $02
;	B22_0eed:		inc $fe01, x	; fe 01 fe
;	B22_0ef0:		.db $00				; 00
;	B22_0ef1:		.db $00				; 00
;	B22_0ef2:		ora ($fe, x)	; 01 fe
;	B22_0ef4:		.db $00				; 00
;	B22_0ef5:	.db $ff
;	B22_0ef6:		ora ($fe, x)	; 01 fe
;	B22_0ef8:		ora ($fe, x)	; 01 fe
;	B22_0efa:		ora ($fe, x)	; 01 fe
;	B22_0efc:	.db $02
;	B22_0efd:	.db $fd $00 $00
;	B22_0f00:	.db $80
;	B22_0f01:	.db $80
;	B22_0f02:		.db $00				; 00
;	B22_0f03:		.db $00				; 00
;	B22_0f04:	.db $80
;	B22_0f05:	.db $80
;	B22_0f06:		cpy #$40		; c0 40
;	B22_0f08:	.db $80
;	B22_0f09:	.db $80
;	B22_0f0a:	.db $80
;	B22_0f0b:	.db $80
;	B22_0f0c:	.db $80
;	B22_0f0d:	.db $80
;	B22_0f0e:		rti				; 40 
;	
;	
;	B22_0f0f:		cpy #$00		; c0 00
;	B22_0f11:		.db $00				; 00
;	B22_0f12:		.db $00				; 00
;	B22_0f13:		.db $00				; 00
;	B22_0f14:		ora ($01, x)	; 01 01
;	B22_0f16:		.db $00				; 00
;	B22_0f17:		.db $00				; 00
;	B22_0f18:	.db $fd $fd $00
;	B22_0f1b:		.db $00				; 00
;	B22_0f1c:		.db $00				; 00
;	B22_0f1d:		.db $00				; 00
;	B22_0f1e:		.db $00				; 00
;	B22_0f1f:		.db $00				; 00
;	B22_0f20:		.db $00				; 00
;	B22_0f21:		.db $00				; 00
;	B22_0f22:		.db $00				; 00
;	B22_0f23:		.db $00				; 00
;	B22_0f24:		.db $00				; 00
;	B22_0f25:		.db $00				; 00
;	B22_0f26:	.db $80
;	B22_0f27:	.db $80
;	B22_0f28:		.db $00				; 00
;	B22_0f29:		.db $00				; 00
;	B22_0f2a:		rti				; 40 
;	
;	
;	B22_0f2b:		rti				; 40 
;	
;	
;	B22_0f2c:		.db $00				; 00
;	B22_0f2d:		.db $00				; 00
;	B22_0f2e:		.db $00				; 00
;	B22_0f2f:		.db $00				; 00
;	B22_0f30:		.db $00				; 00
;	B22_0f31:		.db $00				; 00
;	B22_0f32:		.db $00				; 00
;	B22_0f33:		.db $00				; 00
;	
;	
;	entityPhaseFunc_02:
;	B22_0f34:		inc wEntityPhase, x	; fe c1 05
;	B22_0f37:		lda #$04		; a9 04
;	B22_0f39:		sta $08			; 85 08
;	B22_0f3b:		lda wEntityBaseX, x	; bd 38 04
;	B22_0f3e:		sta $00			; 85 00
;	B22_0f40:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0f43:		sta $01			; 85 01
;	B22_0f45:		lda wEntityState, x	; bd 70 04
;	B22_0f48:		ora #$40		; 09 40
;	B22_0f4a:		and #$fb		; 29 fb
;	B22_0f4c:		sta $09			; 85 09
;	B22_0f4e:		jsr $80e3		; 20 e3 80
;	B22_0f51:		bne B22_0f8f ; d0 3c
;	
;	B22_0f53:		jsr clearAllEntityVars_todo		; 20 d7 fe
;	B22_0f56:		lda #$46		; a9 46
;	B22_0f58:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0f5b:		lda #$5e		; a9 5e
;	B22_0f5d:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0f60:		lda $09			; a5 09
;	B22_0f62:		sta wEntityState, x	; 9d 70 04
;	B22_0f65:		lda $00			; a5 00
;	B22_0f67:		sta wEntityBaseX, x	; 9d 38 04
;	B22_0f6a:		lda $01			; a5 01
;	B22_0f6c:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_0f6f:		ldy $08			; a4 08
;	B22_0f71:		lda $8f92, y	; b9 92 8f
;	B22_0f74:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_0f77:		lda $8f97, y	; b9 97 8f
;	B22_0f7a:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_0f7d:		lda #$ff		; a9 ff
;	B22_0f7f:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_0f82:		lda $8f9c, y	; b9 9c 8f
;	B22_0f85:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_0f88:		jsr $9fc9		; 20 c9 9f
;	B22_0f8b:		dec $08			; c6 08
;	B22_0f8d:		bne B22_0f4e ; d0 bf
;	
;	B22_0f8f:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0f91:		rts				; 60 
;	
;	
;	B22_0f92:		.db $00				; 00
;	B22_0f93:	.db $ff
;	B22_0f94:	.db $ff
;	B22_0f95:		.db $00				; 00
;	B22_0f96:		.db $00				; 00
;	B22_0f97:		.db $00				; 00
;	B22_0f98:		ldy #$d8		; a0 d8
;	B22_0f9a:		plp				; 28 
;	B22_0f9b:		bvc B22_0f9d ; 50 00
;	
;	B22_0f9d:		cpy #$80		; c0 80
;	B22_0f9f:	.db $80
;	B22_0fa0:		.db $c0
;	
;	
;	entityPhaseFunc_a2:
;		lda #$38
;	B22_0fa3:		jsr playSound		; 20 5f e2
;	B22_0fa6:		lda wEntityState, x	; bd 70 04
;	B22_0fa9:		and #$f1		; 29 f1
;	B22_0fab:		ora #$60		; 09 60
;	B22_0fad:		sta $04			; 85 04
;	B22_0faf:		jsr $b52f		; 20 2f b5
;	B22_0fb2:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0fb5:		lda wEntityBaseY, x	; bd 1c 04
;	B22_0fb8:		sta $00			; 85 00
;	B22_0fba:		lda wEntityBaseX, x	; bd 38 04
;	B22_0fbd:		sta $01			; 85 01
;	B22_0fbf:		lda #$03		; a9 03
;	B22_0fc1:		sta $03			; 85 03
;	B22_0fc3:		jsr $80e3		; 20 e3 80
;	B22_0fc6:		bne B22_0fe4 ; d0 1c
;	
;	B22_0fc8:		dec $03			; c6 03
;	B22_0fca:		beq B22_0fe4 ; f0 18
;	
;	B22_0fcc:		jsr $8b4f		; 20 4f 8b
;	B22_0fcf:		lda #$6c		; a9 6c
;	B22_0fd1:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_0fd4:		lda #$6c		; a9 6c
;	B22_0fd6:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_0fd9:		lda $04			; a5 04
;	B22_0fdb:		sta wEntityState, x	; 9d 70 04
;	B22_0fde:		jsr $b52f		; 20 2f b5
;	B22_0fe1:		jmp $8fc3		; 4c c3 8f
;	
;	
;	B22_0fe4:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_0fe6:		rts				; 60 
;	
;	
;	entityPhaseFunc_6c_playSound:
;		inc wEntityPhase, x
;	
;		ldy #$01
;		lda (wPhaseFuncDataAddr), y
;		jmp playSound
;	
;	
;	entityPhaseFunc_29:
;	B22_0ff1:		jsr $90c2		; 20 c2 90
;	B22_0ff4:		jsr $93b0		; 20 b0 93
;	B22_0ff7:		ldy #$10		; a0 10
;	B22_0ff9:		jsr func_1f_1c1e		; 20 1e fc
;	B22_0ffc:		beq B22_1022 ; f0 24
;	
;	B22_0ffe:		cmp #$04		; c9 04
;	B22_1000:		beq B22_1022 ; f0 20
;	
;	B22_1002:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1004:		jsr $93b0		; 20 b0 93
;	B22_1007:		ldy #$08		; a0 08
;	B22_1009:		jsr func_1f_1c1e		; 20 1e fc
;	B22_100c:		bne B22_1022 ; d0 14
;	
;	B22_100e:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1010:		jsr $93b0		; 20 b0 93
;	B22_1013:		ldy #$f8		; a0 f8
;	B22_1015:		jsr func_1f_1c1e		; 20 1e fc
;	B22_1018:		bne B22_1022 ; d0 08
;	
;	B22_101a:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_101c:		dec $061d, x	; de 1d 06
;	B22_101f:		beq B22_103c ; f0 1b
;	
;	B22_1021:		rts				; 60 
;	
;	
;	B22_1022:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1024:		jmp reverseEntityHorizSpeed		; 4c 4b 80
;	
;	
;	entityPhaseFunc_28:
;	B22_1027:		jsr $8240		; 20 40 82
;	B22_102a:		jsr setEntityStateMoving		; 20 aa 81
;	B22_102d:		lda $0657, x	; bd 57 06
;	B22_1030:		ora #$03		; 09 03
;	B22_1032:		sta $0657, x	; 9d 57 06
;	B22_1035:		lda #$08		; a9 08
;	B22_1037:		ldy #$0d		; a0 0d
;	B22_1039:		jsr entityInitAnimation_specGroupA_animationDefIdxY		; 20 93 82
;	B22_103c:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_103f:		and #$80		; 29 80
;	B22_1041:		bne B22_1061 ; d0 1e
;	
;	B22_1043:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1046:		and #$30		; 29 30
;	B22_1048:		beq B22_1076 ; f0 2c
;	
;	B22_104a:		lsr a			; 4a
;	B22_104b:		lsr a			; 4a
;	B22_104c:		lsr a			; 4a
;	B22_104d:		lsr a			; 4a
;	B22_104e:		tay				; a8 
;	B22_104f:		dey				; 88 
;	B22_1050:		tya				; 98 
;	B22_1051:		asl a			; 0a
;	B22_1052:		asl a			; 0a
;	B22_1053:		asl a			; 0a
;	B22_1054:		asl a			; 0a
;	B22_1055:		sta $00			; 85 00
;	B22_1057:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_105a:		and #$cf		; 29 cf
;	B22_105c:		ora $00			; 05 00
;	B22_105e:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1061:		lda #$21		; a9 21
;	B22_1063:		sta $061d, x	; 9d 1d 06
;	B22_1066:		jsr $8243		; 20 43 82
;	B22_1069:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_106c:		cmp #$60		; c9 60
;	B22_106e:		bcc B22_10ac ; 90 3c
;	
;	B22_1070:		jsr $9134		; 20 34 91
;	B22_1073:		jmp $90af		; 4c af 90
;	
;	
;	B22_1076:		jsr $907c		; 20 7c 90
;	B22_1079:		jmp $9061		; 4c 61 90
;	
;	
;	B22_107c:		lda wEntityState, x	; bd 70 04
;	B22_107f:		and #$81		; 29 81
;	B22_1081:		bne B22_10a9 ; d0 26
;	
;	B22_1083:		jsr $feb9		; 20 b9 fe
;	B22_1086:		bne B22_10a9 ; d0 21
;	
;	B22_1088:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_108a:		jsr $81ef		; 20 ef 81
;	B22_108d:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_1090:		lda wGameStateLoopCounter			; a5 1a
;	B22_1092:		adc wEntityBaseX, x	; 7d 38 04
;	B22_1095:		and #$01		; 29 01
;	B22_1097:		tay				; a8 
;	B22_1098:		lda $90aa, y	; b9 aa 90
;	B22_109b:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_109e:		inc wEntityPhase, x	; fe c1 05
;	B22_10a1:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_10a4:		ora #$10		; 09 10
;	B22_10a6:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_10a9:		rts				; 60 
;	
;	
;	B22_10aa:		bmi B22_10fe ; 30 52
;	
;	B22_10ac:		jsr $9127		; 20 27 91
;	B22_10af:		lda wEntityState, x	; bd 70 04
;	B22_10b2:		and #$01		; 29 01
;	B22_10b4:		beq B22_10ba ; f0 04
;	
;	B22_10b6:		tya				; 98 
;	B22_10b7:		eor #$01		; 49 01
;	B22_10b9:		tay				; a8 
;	B22_10ba:		tya				; 98 
;	B22_10bb:		clc				; 18 
;	B22_10bc:		adc #$02		; 69 02
;	B22_10be:		tay				; a8 
;	B22_10bf:		jmp $938b		; 4c 8b 93
;	
;	
;	B22_10c2:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_10c5:		and #$80		; 29 80
;	B22_10c7:		beq B22_10f5 ; f0 2c
;	
;	B22_10c9:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_10cc:		and #$0f		; 29 0f
;	B22_10ce:		tay				; a8 
;	B22_10cf:		sty $00			; 84 00
;	B22_10d1:		lda wEntityObjectIdxes, y	; b9 4e 05
;	B22_10d4:		beq B22_10f6 ; f0 20
;	
;	B22_10d6:		ldy $00			; a4 00
;	B22_10d8:		lda wEntityBaseX, y	; b9 38 04
;	B22_10db:		sta $10			; 85 10
;	B22_10dd:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_10df:		jsr $80cb		; 20 cb 80
;	B22_10e2:		cmp #$04		; c9 04
;	B22_10e4:		bcs B22_10f5 ; b0 0f
;	
;	B22_10e6:		jsr $90f6		; 20 f6 90
;	B22_10e9:		lda #$00		; a9 00
;	B22_10eb:		ldy $00			; a4 00
;	B22_10ed:		sta wOamSpecIdxDoubled, y	; 99 00 04
;	B22_10f0:		sta wEntityObjectIdxes, y	; 99 4e 05
;	B22_10f3:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_10f5:		rts				; 60 
;	
;	
;	B22_10f6:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_10f9:		and #$7f		; 29 7f
;	B22_10fb:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_10fe:		rts				; 60 
;	
;	
;	entityPhaseFunc_2c:
;	B22_10ff:		ldy #$01		; a0 01
;	B22_1101:		lda wOamSpecIdxDoubled, x	; bd 00 04
;	B22_1104:		cmp #$32		; c9 32
;	B22_1106:		beq B22_110a ; f0 02
;	
;	B22_1108:		ldy #$07		; a0 07
;	B22_110a:		jsr func_16_0e11		; 20 11 8e
;	B22_110d:		lda $08			; a5 08
;	B22_110f:		and #$0f		; 29 0f
;	B22_1111:		ora #$80		; 09 80
;	B22_1113:		sta $09			; 85 09
;	B22_1115:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1118:		and #$70		; 29 70
;	B22_111a:		ora $09			; 05 09
;	B22_111c:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_111f:		lda #$00		; a9 00
;	B22_1121:		sta wEntityPhase, x	; 9d c1 05
;	B22_1124:		jmp setEntityStateAnimated		; 4c f8 81
;	
;	
;	B22_1127:		ldy #$01		; a0 01
;	B22_1129:		lda wEntityBaseX		; ad 38 04
;	B22_112c:		cmp wEntityBaseX, x	; dd 38 04
;	B22_112f:		bcc B22_1133 ; 90 02
;	
;	B22_1131:		ldy #$00		; a0 00
;	B22_1133:		rts				; 60 
;	
;	
;	B22_1134:		ldy #$00		; a0 00
;	B22_1136:		lda wEntityBaseX		; ad 38 04
;	B22_1139:		cmp wEntityBaseX, x	; dd 38 04
;	B22_113c:		bcc B22_1133 ; 90 f5
;	
;	B22_113e:		ldy #$01		; a0 01
;	B22_1140:		rts				; 60 
;	
;	
;	entityPhaseFunc_2f:
;	B22_1141:		lda wEntityAI_idx, x	; bd ef 05
;	B22_1144:		cmp #$14		; c9 14
;	B22_1146:		beq B22_114c ; f0 04
;	
;	B22_1148:		cmp #$13		; c9 13
;	B22_114a:		bne B22_1153 ; d0 07
;	
;	; 1st skeletons (13) or 14 - 0,10
;	B22_114c:		ldy #$0d		; a0 0d
;	B22_114e:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_1151:		beq B22_1192 ; f0 3f
;	
;	; 8,10
;	B22_1153:		ldy #$05		; a0 05
;	B22_1155:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_1158:		beq B22_117f ; f0 25
;	
;	B22_115a:		jsr snapEntityXsYtoTile		; 20 91 8b
;	B22_115d:		lda wEntityAI_idx, x	; bd ef 05
;	B22_1160:		cmp #$29		; c9 29
;	B22_1162:		bne B22_1178 ; d0 14
;	
;	B22_1164:		lda wCurrRoomGroup		; a5 32
;	B22_1166:		cmp #$09		; c9 09
;	B22_1168:		bne B22_1178 ; d0 0e
;	
;	B22_116a:		lda wCurrScrollRoomScreen			; a5 57
;	B22_116c:		bne B22_1178 ; d0 0a
;	
;	B22_116e:		clc				; 18 
;	B22_116f:		lda wCurrScrollOffsetIntoRoomScreen			; a5 56
;	B22_1171:		adc wEntityBaseX, x	; 7d 38 04
;	B22_1174:		cmp #$70		; c9 70
;	B22_1176:		bcc B22_117f ; 90 07
;	
;	; 8,8
;	B22_1178:		ldy #$00		; a0 00
;	B22_117a:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_117d:		beq B22_1184 ; f0 05
;	
;	B22_117f:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1181:		jmp entityReverseFacingDirAndHorizSpeed		; 4c 5e 89
;	
;	B22_1184:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1186:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_1189:		bne B22_1191 ; d0 06
;	
;	B22_118b:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_118e:		inc wEntityPhase, x	; fe c1 05
;	B22_1191:		rts				; 60 
;	
;	B22_1192:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1195:		lda #$01		; a9 01
;	B22_1197:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_119a:		lda wEntityAI_idx, x	; bd ef 05
;	B22_119d:		cmp #$14		; c9 14
;	B22_119f:		beq B22_11a5 ; f0 04
;	
;	B22_11a1:		inc wEntityPhase, x	; fe c1 05
;	B22_11a4:		rts				; 60 
;	
;	B22_11a5:		lda #$25		; a9 25
;	B22_11a7:		sta wEntityPhase, x	; 9d c1 05
;	B22_11aa:		rts				; 60 
;	
;	
;	entityPhaseFunc_66:
;	B22_11ab:		ldy #$05		; a0 05
;	B22_11ad:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_11b0:		beq B22_117f ; f0 cd
;	
;	B22_11b2:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_11b4:		ldy #$00		; a0 00
;	B22_11b6:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_11b9:		bne B22_117f ; d0 c4
;	
;	B22_11bb:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_11bd:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_11c0:		bne B22_11e2 ; d0 20
;	
;	B22_11c2:		lda #$40		; a9 40
;	B22_11c4:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_11c7:		jsr entityFacePlayer		; 20 30 82
;	B22_11ca:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_11cd:		bne B22_11da ; d0 0b
;	
;	B22_11cf:		lda wEntityHorizSpeed, x	; bd f2 04
;	B22_11d2:		bpl B22_11e2 ; 10 0e
;	
;	B22_11d4:		jsr reverseEntityHorizSpeed		; 20 4b 80
;	B22_11d7:		jmp $91e2		; 4c e2 91
;	
;	
;	B22_11da:		lda wEntityHorizSpeed, x	; bd f2 04
;	B22_11dd:		bmi B22_11e2 ; 30 03
;	
;	B22_11df:		jsr reverseEntityHorizSpeed		; 20 4b 80
;	B22_11e2:		lda wOamSpecIdxDoubled, x	; bd 00 04
;	B22_11e5:		cmp #$2c		; c9 2c
;	B22_11e7:		bne B22_124d ; d0 64
;	
;	B22_11e9:		lda wEntityTimeUntilNextAnimation, x	; bd 7c 05
;	B22_11ec:		cmp #$10		; c9 10
;	B22_11ee:		bne B22_124d ; d0 5d
;	
;	B22_11f0:		ldy #$0b		; a0 0b
;	B22_11f2:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_11f5:		beq B22_124d ; f0 56
;	
;	B22_11f7:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_11f9:		ldy wEntityFacingLeft, x	; bc a8 04
;	B22_11fc:		clc				; 18 
;	B22_11fd:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1200:		adc #$07		; 69 07
;	B22_1202:		sta $01			; 85 01
;	B22_1204:		lda wEntityState, x	; bd 70 04
;	B22_1207:		and #$ba		; 29 ba
;	B22_1209:		ora #$20		; 09 20
;	B22_120b:		sta $09			; 85 09
;	B22_120d:		clc				; 18 
;	B22_120e:		lda $9250, y	; b9 50 92
;	B22_1211:		adc wEntityBaseX, x	; 7d 38 04
;	B22_1214:		sta $00			; 85 00
;	B22_1216:		lda wEntityState, x	; bd 70 04
;	B22_1219:		and #$01		; 29 01
;	B22_121b:		adc $9252, y	; 79 52 92
;	B22_121e:		and #$01		; 29 01
;	B22_1220:		ora $09			; 05 09
;	B22_1222:		sta $0a			; 85 0a
;	B22_1224:		jsr $80e3		; 20 e3 80
;	B22_1227:		bne B22_124d ; d0 24
;	
;	B22_1229:		lda $00			; a5 00
;	B22_122b:		sta wEntityBaseX, x	; 9d 38 04
;	B22_122e:		lda $01			; a5 01
;	B22_1230:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1233:		lda $0a			; a5 0a
;	B22_1235:		sta wEntityState, x	; 9d 70 04
;	B22_1238:		lda #$00		; a9 00
;	B22_123a:		sta wEntityPhase, x	; 9d c1 05
;	B22_123d:		lda #$47		; a9 47
;	B22_123f:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_1242:		lda #$5f		; a9 5f
;	B22_1244:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_1247:		jsr $9fc9		; 20 c9 9f
;	B22_124a:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_124d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_124f:		rts				; 60 
;	
;	
;	B22_1250:	.db $fa
;	B22_1251:		asl $ff			; 06 ff
;	B22_1253:		.db $00				; 00
;	B22_1254:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1257:		lda #$01		; a9 01
;	B22_1259:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_125c:		inc wEntityPhase, x	; fe c1 05
;	B22_125f:		rts				; 60 
;	
;	
;	entityPhaseFunc_3b:
;	B22_1260:		jsr $93a6		; 20 a6 93
;	B22_1263:		ldy #$10		; a0 10
;	B22_1265:		jsr func_1f_1c1e		; 20 1e fc
;	B22_1268:		beq B22_1254 ; f0 ea
;	
;	B22_126a:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_126c:		jsr $93b0		; 20 b0 93
;	B22_126f:		ldy #$10		; a0 10
;	B22_1271:		jsr func_1f_1c1e		; 20 1e fc
;	B22_1274:		beq B22_12d6 ; f0 60
;	
;	B22_1276:		cmp #$04		; c9 04
;	B22_1278:		beq B22_12d6 ; f0 5c
;	
;	B22_127a:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_127c:		jsr $93b0		; 20 b0 93
;	B22_127f:		ldy #$08		; a0 08
;	B22_1281:		jsr func_1f_1c1e		; 20 1e fc
;	B22_1284:		bne B22_12d6 ; d0 50
;	
;	B22_1286:		dec $061d, x	; de 1d 06
;	B22_1289:		bne B22_12c3 ; d0 38
;	
;	B22_128b:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_128e:		inc wEntityPhase, x	; fe c1 05
;	B22_1291:		inc wEntityPhase, x	; fe c1 05
;	B22_1294:		inc wEntityPhase, x	; fe c1 05
;	B22_1297:		rts				; 60 
;	
;	
;	entityPhaseFunc_34:
;	B22_1298:		jsr $93b0		; 20 b0 93
;	B22_129b:		ldy #$10		; a0 10
;	B22_129d:		jsr func_1f_1c1e		; 20 1e fc
;	B22_12a0:		beq B22_12db ; f0 39
;	
;	B22_12a2:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_12a4:		jsr $93ba		; 20 ba 93
;	B22_12a7:		ldy #$08		; a0 08
;	B22_12a9:		jsr func_1f_1c1e		; 20 1e fc
;	B22_12ac:		beq B22_12bc ; f0 0e
;	
;	B22_12ae:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_12b0:		jsr $93ba		; 20 ba 93
;	B22_12b3:		ldy #$f8		; a0 f8
;	B22_12b5:		jsr func_1f_1c1e		; 20 1e fc
;	B22_12b8:		bne B22_12d6 ; d0 1c
;	
;	B22_12ba:		beq B22_12db ; f0 1f
;	
;	B22_12bc:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_12be:		dec $061d, x	; de 1d 06
;	B22_12c1:		beq B22_12d0 ; f0 0d
;	
;	B22_12c3:		lda #$04		; a9 04
;	B22_12c5:		ldy wEntityHorizSpeed, x	; bc f2 04
;	B22_12c8:		bpl B22_12cd ; 10 03
;	
;	B22_12ca:		jmp addAtoEntityHorizSpeed		; 4c 6f 80
;	
;	
;	B22_12cd:		jmp subAfromEntityHorizSpeed		; 4c 8f 80
;	
;	
;	B22_12d0:		lda #$04		; a9 04
;	B22_12d2:		sta wEntityPhase, x	; 9d c1 05
;	B22_12d5:		rts				; 60 
;	
;	
;	B22_12d6:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_12d8:		jmp reverseEntityHorizSpeed		; 4c 4b 80
;	
;	
;	B22_12db:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_12dd:		inc wEntityPhase, x	; fe c1 05
;	B22_12e0:		lda #$01		; a9 01
;	B22_12e2:		ldy wEntityHorizSpeed, x	; bc f2 04
;	B22_12e5:		bpl B22_12e9 ; 10 02
;	
;	B22_12e7:		lda #$ff		; a9 ff
;	B22_12e9:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_12ec:		lda #$fe		; a9 fe
;	B22_12ee:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_12f1:		lda #$00		; a9 00
;	B22_12f3:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_12f6:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_12f9:		jmp $81ef		; 4c ef 81
;	
;	
;	entityPhaseFunc_33:
;	B22_12fc:		ldy #$01		; a0 01
;	B22_12fe:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1300:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1303:		lda #$14		; a9 14
;	B22_1305:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_1308:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_130b:		bmi B22_131b ; 30 0e
;	
;	B22_130d:		cmp #$02		; c9 02
;	B22_130f:		bcc B22_131b ; 90 0a
;	
;	B22_1311:		lda #$02		; a9 02
;	B22_1313:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_1316:		lda #$00		; a9 00
;	B22_1318:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_131b:		jsr $93b0		; 20 b0 93
;	B22_131e:		ldy #$10		; a0 10
;	B22_1320:		jsr func_1f_1c1e		; 20 1e fc
;	B22_1323:		beq B22_1341 ; f0 1c
;	
;	B22_1325:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1327:		ldy #$06		; a0 06
;	B22_1329:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_132c:		beq B22_1342 ; f0 14
;	
;	B22_132e:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1330:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1333:		inc wEntityPhase, x	; fe c1 05
;	B22_1336:		jsr setEntityStateAnimated		; 20 f8 81
;	B22_1339:		lda wEntityBaseY, x	; bd 1c 04
;	B22_133c:		and #$f0		; 29 f0
;	B22_133e:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1341:		rts				; 60 
;	
;	
;	B22_1342:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1344:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1347:		lda #$01		; a9 01
;	B22_1349:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_134c:		lda #$80		; a9 80
;	B22_134e:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_1351:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_1354:		sta wEntityPhase, x	; 9d c1 05
;	B22_1357:		rts				; 60 
;	
;	
;	entityPhaseFunc_35:
;	B22_1358:		inc wEntityPhase, x	; fe c1 05
;	B22_135b:		jsr setEntityStateMoving		; 20 aa 81
;	B22_135e:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1361:		lda #$28		; a9 28
;	B22_1363:		sta $061d, x	; 9d 1d 06
;	B22_1366:		jsr entityFacePlayer		; 20 30 82
;	B22_1369:		lda wEntityState, x	; bd 70 04
;	B22_136c:		and #$01		; 29 01
;	B22_136e:		bne B22_1379 ; d0 09
;	
;	B22_1370:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_1373:		cmp #$40		; c9 40
;	B22_1375:		bcc B22_13a0 ; 90 29
;	
;	B22_1377:		bcs B22_1388 ; b0 0f
;	
;	B22_1379:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_137c:		eor #$01		; 49 01
;	B22_137e:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_1381:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_1384:		cmp #$40		; c9 40
;	B22_1386:		bcs B22_13a0 ; b0 18
;	
;	B22_1388:		jsr $9134		; 20 34 91
;	B22_138b:		lda $9398, y	; b9 98 93
;	B22_138e:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_1391:		lda $939c, y	; b9 9c 93
;	B22_1394:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1397:		rts				; 60 
;	
;	
;	B22_1398:		inc $ff01, x	; fe 01 ff
;	B22_139b:		.db $00				; 00
;	B22_139c:		;removed
;		.db $d0 $30
;	
;	B22_139e:		ldy #$60		; a0 60
;	B22_13a0:		jsr $9127		; 20 27 91
;	B22_13a3:		jmp $938b		; 4c 8b 93
;	
;	
;	B22_13a6:		lda #$fb		; a9 fb
;	B22_13a8:		ldy wEntityFacingLeft, x	; bc a8 04
;	B22_13ab:		beq B22_13b9 ; f0 0c
;	
;	B22_13ad:		lda #$05		; a9 05
;	B22_13af:		rts				; 60 
;	
;	
;	B22_13b0:		lda #$f8		; a9 f8
;	B22_13b2:		ldy wEntityHorizSpeed, x	; bc f2 04
;	B22_13b5:		bmi B22_13b9 ; 30 02
;	
;	B22_13b7:		lda #$08		; a9 08
;	B22_13b9:		rts				; 60 
;	
;	
;	B22_13ba:		lda #$e8		; a9 e8
;	B22_13bc:		ldy wEntityHorizSpeed, x	; bc f2 04
;	B22_13bf:		bmi B22_13b9 ; 30 f8
;	
;	B22_13c1:		lda #$18		; a9 18
;	B22_13c3:		rts				; 60 
;	
;	
;	entityPhaseFunc_36:
;	B22_13c4:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_13c7:		ldy #$01		; a0 01
;	B22_13c9:		cmp (wPhaseFuncDataAddr), y	; d1 02
;	B22_13cb:		bcs B22_13d1 ; b0 04
;	
;	B22_13cd:		inc wEntityPhase, x	; fe c1 05
;	B22_13d0:		rts				; 60 
;	
;	
;	B22_13d1:		ldy #$02		; a0 02
;	B22_13d3:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_13d5:		sta wEntityPhase, x	; 9d c1 05
;	B22_13d8:		rts				; 60 
;	
;	
;	entityPhaseFunc_7e:
;	B22_13d9:		inc wEntityPhase, x	; fe c1 05
;	B22_13dc:		lda #$0f		; a9 0f
;	B22_13de:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_13e1:		lda #$00		; a9 00
;	B22_13e3:		sta $061d, x	; 9d 1d 06
;	B22_13e6:		lda wEntityBaseX, x	; bd 38 04
;	B22_13e9:		adc wEntityBaseY, x	; 7d 1c 04
;	B22_13ec:		lsr a			; 4a
;	B22_13ed:		lsr a			; 4a
;	B22_13ee:		lsr a			; 4a
;	B22_13ef:		adc wRandomVal			; 65 1f
;	B22_13f1:		and #$07		; 29 07
;	B22_13f3:		tay				; a8 
;	B22_13f4:		lda $93fb, y	; b9 fb 93
;	B22_13f7:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_13fa:		rts				; 60 
;	
;	
;	B22_13fb:	.db $73
;	B22_13fc:		pha				; 48 
;	B22_13fd:		pha				; 48 
;	B22_13fe:		adc $63			; 65 63
;	B22_1400:	.db $5c
;	B22_1401:	.db $8f
;	B22_1402:	.db $54
;	
;	
;	entityPhaseFunc_7d:
;	B22_1403:		lda wEntityState, x	; bd 70 04
;	B22_1406:		and #$01		; 29 01
;	B22_1408:		bne B22_13fa ; d0 f0
;	
;	B22_140a:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_140d:		bne B22_1426 ; d0 17
;	
;	B22_140f:		lda $061d, x	; bd 1d 06
;	B22_1412:		eor #$01		; 49 01
;	B22_1414:		sta $061d, x	; 9d 1d 06
;	B22_1417:		tay				; a8 
;	B22_1418:		lda $9439, y	; b9 39 94
;	B22_141b:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_141e:		lda wEntityState, x	; bd 70 04
;	B22_1421:		eor #$08		; 49 08
;	B22_1423:		sta wEntityState, x	; 9d 70 04
;	B22_1426:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1429:		beq B22_1430 ; f0 05
;	
;	B22_142b:		dec wEntityGenericCounter, x	; de 33 06
;	B22_142e:		bne B22_1438 ; d0 08
;	
;	B22_1430:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1432:		jsr $81bc		; 20 bc 81
;	B22_1435:		inc wEntityPhase, x	; fe c1 05
;	B22_1438:		rts				; 60 
;	
;	
;	B22_1439:		plp				; 28 
;	B22_143a:	.db $07
;	
;	
;	entityPhaseFunc_7f:
;	B22_143b:		jsr $8240		; 20 40 82
;	B22_143e:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_1441:		and #$f0		; 29 f0
;	B22_1443:		lsr a			; 4a
;	B22_1444:		lsr a			; 4a
;	B22_1445:		lsr a			; 4a
;	B22_1446:		lsr a			; 4a
;	B22_1447:		tay				; a8 
;	B22_1448:		lda $9473, y	; b9 73 94
;	B22_144b:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_144e:		lda $947d, y	; b9 7d 94
;	B22_1451:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1454:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_1457:		beq B22_145c ; f0 03
;	
;	B22_1459:		jsr reverseEntityHorizSpeed		; 20 4b 80
;	B22_145c:		jsr $80d5		; 20 d5 80
;	B22_145f:		and #$f0		; 29 f0
;	B22_1461:		lsr a			; 4a
;	B22_1462:		lsr a			; 4a
;	B22_1463:		lsr a			; 4a
;	B22_1464:		lsr a			; 4a
;	B22_1465:		tay				; a8 
;	B22_1466:		lda $9487, y	; b9 87 94
;	B22_1469:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_146c:		lda $9491, y	; b9 91 94
;	B22_146f:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_1472:		rts				; 60 
;	
;	
;	B22_1473:		.db $00				; 00
;	B22_1474:		ora ($01, x)	; 01 01
;	B22_1476:	.db $02
;	B22_1477:	.db $02
;	B22_1478:	.db $02
;	B22_1479:	.db $03
;	B22_147a:	.db $03
;	B22_147b:	.db $03
;	B22_147c:	.db $04
;	B22_147d:		cpy #$80		; c0 80
;	B22_147f:		cpy #$00		; c0 00
;	B22_1481:	.db $80
;	B22_1482:		cpy #$00		; c0 00
;	B22_1484:	.db $80
;	B22_1485:		cpy #$80		; c0 80
;	B22_1487:		ora ($01, x)	; 01 01
;	B22_1489:	.db $02
;	B22_148a:	.db $02
;	B22_148b:	.db $02
;	B22_148c:	.db $03
;	B22_148d:	.db $03
;	B22_148e:	.db $03
;	B22_148f:	.db $04
;	B22_1490:	.db $04
;	B22_1491:	.db $80
;	B22_1492:		cpy #$00		; c0 00
;	B22_1494:	.db $80
;	B22_1495:		cpy #$00		; c0 00
;	B22_1497:	.db $80
;	B22_1498:		cpy #$00		; c0 00
;	B22_149a:	.db $80
;	
;	
;	entityPhaseFunc_80:
;	B22_149b:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_149e:		bpl B22_14b8 ; 10 18
;	
;	B22_14a0:		lda #$26		; a9 26
;	B22_14a2:		jsr playSound		; 20 5f e2
;	B22_14a5:		jsr setEntityStateAnimated		; 20 f8 81
;	B22_14a8:		ldy #$06		; a0 06
;	B22_14aa:		lda #$12		; a9 12
;	B22_14ac:		jsr setEntitySpecGroupA_animationDefIdxY_animateNextFrame		; 20 5c ef
;	B22_14af:		lda #$30		; a9 30
;	B22_14b1:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_14b4:		inc wEntityPhase, x	; fe c1 05
;	B22_14b7:		rts				; 60 
;	
;	
;	B22_14b8:		lda #$10		; a9 10
;	B22_14ba:		jmp subAfromEntityVertSpeed		; 4c a1 80
;	
;	
;	entityPhaseFunc_81:
;	B22_14bd:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_14c0:		beq B22_14b4 ; f0 f2
;	
;	B22_14c2:		bne B22_14b8 ; d0 f4
;	
;	
;	entityPhaseFunc_82:
;	B22_14c4:		lda #$10		; a9 10
;	B22_14c6:		jsr subAfromEntityVertSpeed		; 20 a1 80
;	B22_14c9:		lda wEntityBaseY, x	; bd 1c 04
;	B22_14cc:		cmp #$28		; c9 28
;	B22_14ce:		bcc B22_14d4 ; 90 04
;	
;	B22_14d0:		cmp #$e8		; c9 e8
;	B22_14d2:		bcc B22_14b7 ; 90 e3
;	
;	B22_14d4:		lda $0645, x	; bd 45 06
;	B22_14d7:		tax				; aa 
;	B22_14d8:		lda #$00		; a9 00
;	B22_14da:		sta wSpawner_var7c8, x	; 9d c8 07
;	B22_14dd:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_14df:		jmp $84b2		; 4c b2 84
;	
;	
;	entityPhaseFunc_83:
;	B22_14e2:		inc wEntityPhase, x	; fe c1 05
;	B22_14e5:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_14e8:		lda #$ff		; a9 ff
;	B22_14ea:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_14ed:		rts				; 60 
;	
;	
;	entityPhaseFunc_3c:
;	B22_14ee:		ldy #$01		; a0 01
;	B22_14f0:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_14f3:		cmp #$01		; c9 01
;	B22_14f5:		bcc B22_14fd ; 90 06
;	
;	B22_14f7:		lda #$00		; a9 00
;	B22_14f9:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_14fc:		iny				; c8 
;	B22_14fd:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_14ff:		sta wEntityPhase, x	; 9d c1 05
;	B22_1502:		rts				; 60 
;	
;	
;	entityPhaseFunc_3e:
;	B22_1503:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1506:		lda #$ff		; a9 ff
;	B22_1508:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_150b:		inc wEntityPhase, x	; fe c1 05
;	B22_150e:		rts				; 60 
;	
;	
;	entityPhaseFunc_3d:
;	B22_150f:		lda #$10		; a9 10
;	B22_1511:		jsr subAfromEntityVertSpeed		; 20 a1 80
;	B22_1514:		ldy #$04		; a0 04
;	B22_1516:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_1519:		beq B22_1522 ; f0 07
;	
;	B22_151b:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_151e:		inc wEntityPhase, x	; fe c1 05
;	B22_1521:		rts				; 60 
;	
;	
;	B22_1522:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1525:		cmp #$30		; c9 30
;	B22_1527:		bcs B22_150e ; b0 e5
;	
;	B22_1529:		lda #$00		; a9 00
;	B22_152b:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_152e:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1531:		ldy #$01		; a0 01
;	B22_1533:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1535:		sta wEntityPhase, x	; 9d c1 05
;	B22_1538:		rts				; 60 
;	
;	
;	entityPhaseFunc_40:
;	B22_1539:		jsr entityFacePlayer		; 20 30 82
;	B22_153c:		lda #$00		; a9 00
;	B22_153e:		ldy #$c0		; a0 c0
;	B22_1540:		jsr setEntityHorizSpeedToAY_reversedIfFacingLeft		; 20 ff 84
;	B22_1543:		lda #$01		; a9 01
;	B22_1545:		ldy #$80		; a0 80
;	B22_1547:		jsr setEntityVertSpeedToAY		; 20 18 85
;	B22_154a:		inc wEntityPhase, x	; fe c1 05
;	B22_154d:		rts				; 60 
;	
;	
;	entityPhaseFunc_41:
;	B22_154e:		ldy #$04		; a0 04
;	B22_1550:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_1553:		beq B22_155d ; f0 08
;	
;	B22_1555:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1557:		inc wEntityGenericCounter, x	; fe 33 06
;	B22_155a:		jmp $95ae		; 4c ae 95
;	
;	
;	B22_155d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_155f:		lda #$14		; a9 14
;	B22_1561:		jsr subAfromEntityVertSpeed		; 20 a1 80
;	B22_1564:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_1567:		bpl B22_154d ; 10 e4
;	
;	B22_1569:		cmp #$fd		; c9 fd
;	B22_156b:		bcs B22_154d ; b0 e0
;	
;	B22_156d:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1570:		cmp #$30		; c9 30
;	B22_1572:		bcc B22_157f ; 90 0b
;	
;	B22_1574:		lda #$fd		; a9 fd
;	B22_1576:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_1579:		lda #$00		; a9 00
;	B22_157b:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_157e:		rts				; 60 
;	
;	
;	B22_157f:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1582:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_1585:		lda #$17		; a9 17
;	B22_1587:		sta wEntityPhase, x	; 9d c1 05
;	B22_158a:		rts				; 60 
;	
;	
;	entityPhaseFunc_42:
;	B22_158b:		lda #$30		; a9 30
;	B22_158d:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1590:		lda wEntityBaseX		; ad 38 04
;	B22_1593:		sta wEntityBaseX, x	; 9d 38 04
;	
;	entityPhaseFunc_43:
;	B22_1596:		ldy #$01		; a0 01
;	B22_1598:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_159a:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_159d:		iny				; c8 
;	B22_159e:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_15a0:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_15a3:		inc wEntityPhase, x	; fe c1 05
;	B22_15a6:		rts				; 60 
;	
;	
;	entityPhaseFunc_3f:
;	B22_15a7:		ldy #$03		; a0 03
;	B22_15a9:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_15ac:		beq B22_15b5 ; f0 07
;	
;	B22_15ae:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_15b1:		inc wEntityPhase, x	; fe c1 05
;	B22_15b4:		rts				; 60 
;	
;	
;	B22_15b5:		lda #$10		; a9 10
;	B22_15b7:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_15ba:		lda wEntityVertSpeed, x	; bd 20 05
;	B22_15bd:		cmp #$02		; c9 02
;	B22_15bf:		bcc B22_15b4 ; 90 f3
;	
;	B22_15c1:		lda #$02		; a9 02
;	B22_15c3:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_15c6:		lda #$00		; a9 00
;	B22_15c8:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_15cb:		rts				; 60 
;	
;	
;	entityPhaseFunc_45:
;	B22_15cc:		ldy #$01		; a0 01
;	B22_15ce:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_15d0:		sta $061d, x	; 9d 1d 06
;	B22_15d3:		txa				; 8a 
;	B22_15d4:		adc wGameStateLoopCounter			; 65 1a
;	B22_15d6:		and #$07		; 29 07
;	B22_15d8:		tay				; a8 
;	B22_15d9:		lda $95fb, y	; b9 fb 95
;	B22_15dc:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_15df:		lda $9603, y	; b9 03 96
;	B22_15e2:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_15e5:		lda $960b, y	; b9 0b 96
;	B22_15e8:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_15eb:		lda $9613, y	; b9 13 96
;	B22_15ee:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_15f1:		lda $961b, y	; b9 1b 96
;	B22_15f4:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_15f7:		inc wEntityPhase, x	; fe c1 05
;	B22_15fa:		rts				; 60 
;	
;	
;	B22_15fb:		ora ($ff, x)	; 01 ff
;	B22_15fd:	.db $ff
;	B22_15fe:		.db $00				; 00
;	B22_15ff:	.db $ff
;	B22_1600:		.db $00				; 00
;	B22_1601:		inc $2000, x	; fe 00 20
;	B22_1604:		bpl B22_1626 ; 10 20
;	
;	B22_1606:		sed				; f8 
;	B22_1607:		bpl B22_15d9 ; 10 d0
;	
;	B22_1609:		bne B22_15cb ; d0 c0
;	
;	B22_160b:	.db $ff
;	B22_160c:		inc $fefe, x	; fe fe fe
;	B22_160f:	.db $ff
;	B22_1610:		inc $fefe, x	; fe fe fe
;	B22_1613:		.db $00				; 00
;	B22_1614:		rti				; 40 
;	
;	
;	B22_1615:		cpy #$20		; c0 20
;	B22_1617:		jsr $40c0		; 20 c0 40
;	B22_161a:		sta ($20, x)	; 81 20
;	B22_161c:		bit $3c			; 24 3c
;	B22_161e:		pha				; 48 
;	B22_161f:		bmi B22_1649 ; 30 28
;	
;	B22_1621:	.db $1c
;	B22_1622:		sec				; 38 
;	
;	
;	entityPhaseFunc_46:
;	B22_1623:		dec $061d, x	; de 1d 06
;	B22_1626:		beq B22_1631 ; f0 09
;	
;	B22_1628:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_162b:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_162e:		jmp $84b8		; 4c b8 84
;	
;	
;	B22_1631:		jmp $84b2		; 4c b2 84
;	
;	
;	entityPhaseFunc_5a:
;	B22_1634:		lda wGameStateLoopCounter			; a5 1a
;	B22_1636:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1639:		txa				; 8a 
;	B22_163a:		adc wGameStateLoopCounter			; 65 1a
;	B22_163c:		and #$07		; 29 07
;	B22_163e:		jsr addAtoEntityVertSpeed		; 20 7f 80
;	B22_1641:		jmp $84b8		; 4c b8 84
;	
;	
;	entityPhaseFunc_47:
;	entityPhaseFunc_4a:
;	entityPhaseFunc_4b:
;	entityPhaseFunc_4c:
;	B22_1644:		lda #$00		; a9 00
;	B22_1646:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1649:		jsr $81a7		; 20 a7 81
;	B22_164c:		lda #$00		; a9 00
;	B22_164e:		sta $061d, x	; 9d 1d 06
;	B22_1651:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1654:		jsr $80d5		; 20 d5 80
;	B22_1657:		cmp #$40		; c9 40
;	B22_1659:		bcs B22_1667 ; b0 0c
;	
;	B22_165b:		lda wRandomVal			; a5 1f
;	B22_165d:		and #$03		; 29 03
;	B22_165f:		tay				; a8 
;	B22_1660:		lda $9673, y	; b9 73 96
;	B22_1663:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1666:		rts				; 60 
;	
;	
;	B22_1667:		lda wRandomVal			; a5 1f
;	B22_1669:		and #$03		; 29 03
;	B22_166b:		tay				; a8 
;	B22_166c:		lda $9677, y	; b9 77 96
;	B22_166f:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1672:		rts				; 60 
;	
;	
;	B22_1673:		jsr $302c		; 20 2c 30
;	B22_1676:		sec				; 38 
;	B22_1677:		bpl B22_1691 ; 10 18
;	
;	B22_1679:	.db $1c
;	B22_167a:	.db $14
;	
;	
;	entityPhaseFunc_48:
;	B22_167b:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_167e:		beq B22_1686 ; f0 06
;	
;	B22_1680:		jsr $8243		; 20 43 82
;	B22_1683:		jmp $975c		; 4c 5c 97
;	
;	
;	B22_1686:		lda wGameStateLoopCounter			; a5 1a
;	B22_1688:		and #$03		; 29 03
;	B22_168a:		tay				; a8 
;	B22_168b:		lda $9694, y	; b9 94 96
;	B22_168e:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1691:		jmp $819b		; 4c 9b 81
;	
;	
;	B22_1694:		jsr $1c18		; 20 18 1c
;	B22_1697:		plp				; 28 
;	
;	entityPhaseFunc_49:
;	B22_1698:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_169b:		bne B22_1672 ; d0 d5
;	
;	B22_169d:		jsr setEntityStateMoving		; 20 aa 81
;	B22_16a0:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_16a3:		inc wEntityGenericCounter, x	; fe 33 06
;	B22_16a6:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_16a9:		cmp #$08		; c9 08
;	B22_16ab:		bcc B22_16c7 ; 90 1a
;	
;	B22_16ad:		jsr entityFacePlayer		; 20 30 82
;	B22_16b0:		lda #$00		; a9 00
;	B22_16b2:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_16b5:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_16b8:		asl a			; 0a
;	B22_16b9:		tay				; a8 
;	B22_16ba:		lda $9750, y	; b9 50 97
;	B22_16bd:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_16c0:		lda $9751, y	; b9 51 97
;	B22_16c3:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_16c6:		rts				; 60 
;	
;	
;	B22_16c7:		dec wEntityPhase, x	; de c1 05
;	B22_16ca:		jsr $9779		; 20 79 97
;	B22_16cd:		jsr $80d5		; 20 d5 80
;	B22_16d0:		cmp #$20		; c9 20
;	B22_16d2:		bcc B22_1709 ; 90 35
;	
;	B22_16d4:		lda wRandomVal			; a5 1f
;	B22_16d6:		and #$03		; 29 03
;	B22_16d8:		asl a			; 0a
;	B22_16d9:		tay				; a8 
;	B22_16da:		lda $9738, y	; b9 38 97
;	B22_16dd:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_16e0:		lda $9739, y	; b9 39 97
;	B22_16e3:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_16e6:		tya				; 98 
;	B22_16e7:		lsr a			; 4a
;	B22_16e8:		tay				; a8 
;	B22_16e9:		lda $9748, y	; b9 48 97
;	B22_16ec:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_16ef:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_16f2:		asl a			; 0a
;	B22_16f3:		tay				; a8 
;	B22_16f4:		lda $9754, y	; b9 54 97
;	B22_16f7:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_16fa:		lda $9755, y	; b9 55 97
;	B22_16fd:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1700:		lda $061d, x	; bd 1d 06
;	B22_1703:		beq B22_1708 ; f0 03
;	
;	B22_1705:		jmp reverseEntityVertSpeed		; 4c 5d 80
;	
;	
;	B22_1708:		rts				; 60 
;	
;	
;	B22_1709:		lda wRandomVal			; a5 1f
;	B22_170b:		and #$03		; 29 03
;	B22_170d:		asl a			; 0a
;	B22_170e:		tay				; a8 
;	B22_170f:		lda $9740, y	; b9 40 97
;	B22_1712:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_1715:		lda $9741, y	; b9 41 97
;	B22_1718:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_171b:		tya				; 98 
;	B22_171c:		lsr a			; 4a
;	B22_171d:		tay				; a8 
;	B22_171e:		lda $974c, y	; b9 4c 97
;	B22_1721:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1724:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_1727:		asl a			; 0a
;	B22_1728:		tay				; a8 
;	B22_1729:		lda $9758, y	; b9 58 97
;	B22_172c:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_172f:		lda $9759, y	; b9 59 97
;	B22_1732:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1735:		jmp $9700		; 4c 00 97
;	
;	
;	B22_1738:		ora ($80, x)	; 01 80
;	B22_173a:		ora ($c0, x)	; 01 c0
;	B22_173c:	.db $02
;	B22_173d:		.db $00				; 00
;	B22_173e:	.db $02
;	B22_173f:		rti				; 40 
;	
;	
;	B22_1740:		ora ($00, x)	; 01 00
;	B22_1742:		.db $00				; 00
;	B22_1743:		ldy #$00		; a0 00
;	B22_1745:		cpy #$01		; c0 01
;	B22_1747:		jsr $7060		; 20 60 70
;	B22_174a:		cli				; 58 
;	B22_174b:		;removed
;		.db $50 $30
;	
;	B22_174d:		pha				; 48 
;	B22_174e:		sec				; 38 
;	B22_174f:	.db $2c $02 $00
;	B22_1752:	.db $fe $00 $00
;	B22_1755:		cpy #$ff		; c0 ff
;	B22_1757:		rti				; 40 
;	
;	
;	B22_1758:		.db $00				; 00
;	B22_1759:		rti				; 40 
;	
;	
;	B22_175a:	.db $ff
;	B22_175b:		cpy #$20		; c0 20
;	B22_175d:		jmp ($a997)		; 6c 97 a9
;	
;	
;	B22_1760:		php				; 08 
;	B22_1761:		ldy wEntityFacingLeft, x	; bc a8 04
;	B22_1764:		bne B22_1769 ; d0 03
;	
;	B22_1766:		jmp addAtoEntityHorizSpeed		; 4c 6f 80
;	
;	
;	B22_1769:		jmp subAfromEntityHorizSpeed		; 4c 8f 80
;	
;	
;	B22_176c:		lda #$08		; a9 08
;	B22_176e:		ldy $061d, x	; bc 1d 06
;	B22_1771:		beq B22_1776 ; f0 03
;	
;	B22_1773:		jmp addAtoEntityVertSpeed		; 4c 7f 80
;	
;	
;	B22_1776:		jmp subAfromEntityVertSpeed		; 4c a1 80
;	
;	
;	B22_1779:		lda #$00		; a9 00
;	B22_177b:		ldy wEntityBaseY, x	; bc 1c 04
;	B22_177e:		cpy wEntityBaseY		; cc 1c 04
;	B22_1781:		bcc B22_1785 ; 90 02
;	
;	B22_1783:		lda #$01		; a9 01
;	B22_1785:		sta $061d, x	; 9d 1d 06
;	B22_1788:		rts				; 60 
;	
;	
;	entityPhaseFunc_56:
;	B22_1789:		inc wEntityPhase, x	; fe c1 05
;	B22_178c:		ldy #$01		; a0 01
;	B22_178e:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1790:		sta $10			; 85 10
;	B22_1792:		lda wEntityBaseX		; ad 38 04
;	B22_1795:		sta $04			; 85 04
;	B22_1797:		lda wEntityBaseY		; ad 1c 04
;	B22_179a:		sta $05			; 85 05
;	B22_179c:		jsr $ff30		; 20 30 ff
;	B22_179f:		lda $00			; a5 00
;	B22_17a1:		sta $00			; 85 00
;	B22_17a3:		tay				; a8 
;	B22_17a4:		lda $97e0, y	; b9 e0 97
;	B22_17a7:		ldy $10			; a4 10
;	B22_17a9:		clc				; 18 
;	B22_17aa:		adc $9800, y	; 79 00 98
;	B22_17ad:		asl a			; 0a
;	B22_17ae:		tay				; a8 
;	B22_17af:		lda $9803, y	; b9 03 98
;	B22_17b2:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_17b5:		lda $9839, y	; b9 39 98
;	B22_17b8:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_17bb:		iny				; c8 
;	B22_17bc:		lda $9803, y	; b9 03 98
;	B22_17bf:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_17c2:		lda $9839, y	; b9 39 98
;	B22_17c5:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_17c8:		lda $00			; a5 00
;	B22_17ca:		and #$10		; 29 10
;	B22_17cc:		beq B22_17d1 ; f0 03
;	
;	B22_17ce:		jsr reverseEntityHorizSpeed		; 20 4b 80
;	B22_17d1:		clc				; 18 
;	B22_17d2:		lda $00			; a5 00
;	B22_17d4:		adc #$08		; 69 08
;	B22_17d6:		and #$10		; 29 10
;	B22_17d8:		beq B22_17dd ; f0 03
;	
;	B22_17da:		jsr reverseEntityVertSpeed		; 20 5d 80
;	B22_17dd:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_17df:		rts				; 60 
;	
;	
;	B22_17e0:		.db $00				; 00
;	B22_17e1:		ora ($02, x)	; 01 02
;	B22_17e3:	.db $03
;	B22_17e4:	.db $04
;	B22_17e5:		ora $06			; 05 06
;	B22_17e7:	.db $07
;	B22_17e8:		php				; 08 
;	B22_17e9:	.db $07
;	B22_17ea:		asl $05			; 06 05
;	B22_17ec:	.db $04
;	B22_17ed:	.db $03
;	B22_17ee:	.db $02
;	B22_17ef:		ora ($00, x)	; 01 00
;	B22_17f1:		ora ($02, x)	; 01 02
;	B22_17f3:	.db $03
;	B22_17f4:	.db $04
;	B22_17f5:		ora $06			; 05 06
;	B22_17f7:	.db $07
;	B22_17f8:		php				; 08 
;	B22_17f9:	.db $07
;	B22_17fa:		asl $05			; 06 05
;	B22_17fc:	.db $04
;	B22_17fd:	.db $03
;	B22_17fe:	.db $02
;	B22_17ff:		ora ($00, x)	; 01 00
;	B22_1801:	.db $12
;	B22_1802:		bit $ff			; 24 ff
;	B22_1804:		.db $00				; 00
;	B22_1805:	.db $ff
;	B22_1806:		asl $ff			; 06 ff
;	B22_1808:	.db $14
;	B22_1809:	.db $ff
;	B22_180a:		bit $4cff		; 2c ff 4c
;	B22_180d:	.db $ff
;	B22_180e:	.db $72
;	B22_180f:	.db $ff
;	B22_1810:	.db $9e
;	B22_1811:	.db $ff
;	B22_1812:	.db $cf
;	B22_1813:		.db $00				; 00
;	B22_1814:		.db $00				; 00
;	B22_1815:		inc $fe80, x	; fe 80 fe
;	B22_1818:		dey				; 88 
;	B22_1819:		inc $fe9e, x	; fe 9e fe
;	B22_181c:		cmp ($fe, x)	; c1 fe
;	B22_181e:		sbc ($ff), y	; f1 ff
;	B22_1820:	.db $2b
;	B22_1821:	.db $ff
;	B22_1822:	.db $6b
;	B22_1823:	.db $ff
;	B22_1824:		ldx $00, y		; b6 00
;	B22_1826:		.db $00				; 00
;	B22_1827:		inc $fe00, x	; fe 00 fe
;	B22_182a:	.db $0b
;	B22_182b:		inc $fe27, x	; fe 27 fe
;	B22_182e:	.db $57
;	B22_182f:		inc $fe97, x	; fe 97 fe
;	B22_1832:		cpx $fe			; e4 fe
;	B22_1834:	.db $3c
;	B22_1835:	.db $fe $9d $00
;	B22_1838:		.db $00				; 00
;	B22_1839:		.db $00				; 00
;	B22_183a:		.db $00				; 00
;	B22_183b:		.db $00				; 00
;	B22_183c:		and ($00), y	; 31 00
;	B22_183e:	.db $62
;	B22_183f:		.db $00				; 00
;	B22_1840:		stx $b400		; 8e 00 b4
;	B22_1843:		.db $00				; 00
;	B22_1844:	.db $d4
;	B22_1845:		.db $00				; 00
;	B22_1846:		cpx $fa00		; ec 00 fa
;	B22_1849:		ora ($00, x)	; 01 00
;	B22_184b:		.db $00				; 00
;	B22_184c:		.db $00				; 00
;	B22_184d:		.db $00				; 00
;	B22_184e:		lsr a			; 4a
;	B22_184f:		.db $00				; 00
;	B22_1850:	.db $93
;	B22_1851:		.db $00				; 00
;	B22_1852:		cmp $01, x		; d5 01
;	B22_1854:	.db $0f
;	B22_1855:		ora ($3f, x)	; 01 3f
;	B22_1857:		ora ($62, x)	; 01 62
;	B22_1859:		ora ($78, x)	; 01 78
;	B22_185b:		ora ($80, x)	; 01 80
;	B22_185d:		.db $00				; 00
;	B22_185e:		.db $00				; 00
;	B22_185f:		.db $00				; 00
;	B22_1860:	.db $63
;	B22_1861:		.db $00				; 00
;	B22_1862:		cpy $01			; c4 01
;	B22_1864:	.db $1c
;	B22_1865:		ora ($69, x)	; 01 69
;	B22_1867:		ora ($a9, x)	; 01 a9
;	B22_1869:		ora ($d9, x)	; 01 d9
;	B22_186b:		ora ($f5, x)	; 01 f5
;	B22_186d:	.db $02
;	B22_186e:		.db $00				; 00
;	
;	
;	entityPhaseFunc_57:
;	B22_186f:		jsr $8240		; 20 40 82
;	B22_1872:		clc				; 18 
;	B22_1873:		lda wHardMode		; ad f6 07
;	B22_1876:		asl a			; 0a
;	B22_1877:		adc wEntityFacingLeft, x	; 7d a8 04
;	B22_187a:		tay				; a8 
;	B22_187b:		lda $989f, y	; b9 9f 98
;	B22_187e:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_1881:		lda $98a3, y	; b9 a3 98
;	B22_1884:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1887:		ldy #$00		; a0 00
;	B22_1889:		lda wEntityBaseY, x	; bd 1c 04
;	B22_188c:		cmp wEntityBaseY		; cd 1c 04
;	B22_188f:		bcc B22_1892 ; 90 01
;	
;	B22_1891:		iny				; c8 
;	B22_1892:		lda $98a7, y	; b9 a7 98
;	B22_1895:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_1898:		lda $98a9, y	; b9 a9 98
;	B22_189b:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_189e:		rts				; 60 
;	
;	
;	B22_189f:		.db $00				; 00
;	B22_18a0:	.db $ff
;	B22_18a1:		.db $00				; 00
;	B22_18a2:	.db $ff
;	B22_18a3:	.db $80
;	B22_18a4:	.db $80
;	B22_18a5:		cpy #$40		; c0 40
;	B22_18a7:		.db $00				; 00
;	B22_18a8:	.db $ff
;	B22_18a9:		rti				; 40 
;	
;	
;	B22_18aa:		.db $c0
;	
;	
;	entityPhaseFunc_5e:
;		dec wEntityAlarmOrStartYforSinusoidalMovement, x
;	B22_18ae:		beq B22_18b7 ; f0 07
;	
;	B22_18b0:		ldy #$03		; a0 03
;	B22_18b2:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_18b5:		beq B22_18bd ; f0 06
;	
;	B22_18b7:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_18ba:		inc wEntityPhase, x	; fe c1 05
;	B22_18bd:		rts				; 60 
;	
;	
;	B22_18be:		lda #$17		; a9 17
;	B22_18c0:		sta wEntityPhase, x	; 9d c1 05
;	B22_18c3:		rts				; 60 
;	
;	
;	entityPhaseFunc_5b:
;	B22_18c4:		jsr $80d5		; 20 d5 80
;	B22_18c7:		cmp #$18		; c9 18
;	B22_18c9:		bcs B22_18d2 ; b0 07
;	
;	B22_18cb:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_18ce:		cmp #$30		; c9 30
;	B22_18d0:		bcc B22_18be ; 90 ec
;	
;	B22_18d2:		lda wCurrRoomIdx			; a5 34
;	B22_18d4:		bne B22_18da ; d0 04
;	
;	B22_18d6:		ldy #$00		; a0 00
;	B22_18d8:		beq B22_18df ; f0 05
;	
;	B22_18da:		ldy #$01		; a0 01
;	B22_18dc:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_18de:		tay				; a8 
;	B22_18df:		lda $9921, y	; b9 21 99
;	B22_18e2:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_18e5:		lda $9923, y	; b9 23 99
;	B22_18e8:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_18eb:		lda $9925, y	; b9 25 99
;	B22_18ee:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_18f1:		lda $9927, y	; b9 27 99
;	B22_18f4:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_18f7:		lda $9929, y	; b9 29 99
;	B22_18fa:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_18fd:		dec $061d, x	; de 1d 06
;	B22_1900:		bne B22_1907 ; d0 05
;	
;	B22_1902:		lda #$29		; a9 29
;	B22_1904:		sta wEntityPhase, x	; 9d c1 05
;	B22_1907:		ldy #$08		; a0 08
;	B22_1909:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_190c:		cmp #$01		; c9 01
;	B22_190e:		beq B22_1913 ; f0 03
;	
;	B22_1910:		inc wEntityPhase, x	; fe c1 05
;	B22_1913:		inc wEntityPhase, x	; fe c1 05
;	B22_1916:		jsr setEntityStateMoving		; 20 aa 81
;	B22_1919:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_191c:		beq B22_18bd ; f0 9f
;	
;	B22_191e:		jmp reverseEntityHorizSpeed		; 4c 4b 80
;	
;	
;	B22_1921:	.db $fd $fc $00
;	B22_1924:		.db $00				; 00
;	B22_1925:		plp				; 28 
;	B22_1926:	.db $20 $01 $00
;	B22_1929:		jsr $20c0		; 20 c0 20
;	B22_192c:		stx $3899		; 8e 99 38
;	B22_192f:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1932:		sbc #$18		; e9 18
;	B22_1934:		sta $01			; 85 01
;	B22_1936:		jsr $80e3		; 20 e3 80
;	B22_1939:		bne B22_1968 ; d0 2d
;	
;	B22_193b:		jsr $996b		; 20 6b 99
;	B22_193e:		lda #$2a		; a9 2a
;	B22_1940:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_1943:		jmp $9936		; 4c 36 99
;	
;	
;	entityPhaseFunc_68:
;	B22_1946:		inc wEntityPhase, x	; fe c1 05
;	B22_1949:		jsr $998e		; 20 8e 99
;	B22_194c:		ldy #$01		; a0 01
;	B22_194e:		sec				; 38 
;	B22_194f:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1952:		sbc (wPhaseFuncDataAddr), y	; f1 02
;	B22_1954:		sta $01			; 85 01
;	B22_1956:		jsr $80e3		; 20 e3 80
;	B22_1959:		bne B22_1968 ; d0 0d
;	
;	B22_195b:		jsr $996b		; 20 6b 99
;	B22_195e:		ldy #$02		; a0 02
;	B22_1960:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1962:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_1965:		jmp $9956		; 4c 56 99
;	
;	
;	B22_1968:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_196a:		rts				; 60 
;	
;	
;	B22_196b:		lda $00			; a5 00
;	B22_196d:		sta wEntityBaseX, x	; 9d 38 04
;	B22_1970:		lda $01			; a5 01
;	B22_1972:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1975:		lda #$68		; a9 68
;	B22_1977:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_197a:		lda $0e			; a5 0e
;	B22_197c:		sta wEntityState, x	; 9d 70 04
;	B22_197f:		lda #$00		; a9 00
;	B22_1981:		sta wEntityPhase, x	; 9d c1 05
;	B22_1984:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_1987:		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
;	B22_198a:		sta $0657, x	; 9d 57 06
;	B22_198d:		rts				; 60 
;	
;	
;	B22_198e:		lda wEntityBaseX, x	; bd 38 04
;	B22_1991:		sta $00			; 85 00
;	B22_1993:		lda wEntityState, x	; bd 70 04
;	B22_1996:		and #$fb		; 29 fb
;	B22_1998:		ora #$60		; 09 60
;	B22_199a:		sta $0e			; 85 0e
;	B22_199c:		rts				; 60 
;	
;	
;	entityPhaseFunc_6b:
;	B22_199d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_199f:		ldy #$06		; a0 06
;	B22_19a1:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_19a4:		bne B22_19b4 ; d0 0e
;	
;	B22_19a6:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_19a8:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_19ab:		lda #$01		; a9 01
;	B22_19ad:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_19b0:		inc wEntityPhase, x	; fe c1 05
;	B22_19b3:		rts				; 60 
;	
;	
;	B22_19b4:		jsr snapEntityXsYtoTile		; 20 91 8b
;	B22_19b7:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_19b9:		ldy #$08		; a0 08
;	B22_19bb:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_19be:		beq B22_19ee ; f0 2e
;	
;	B22_19c0:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_19c2:		ldy #$0c		; a0 0c
;	B22_19c4:		jsr getCollisionTileValUsingOffsetPresets		; 20 a6 b7
;	B22_19c7:		bne B22_19ee ; d0 25
;	
;	B22_19c9:		lda wEntityAI_idx, x	; bd ef 05
;	B22_19cc:		cmp #$71		; c9 71
;	B22_19ce:		bne B22_19d5 ; d0 05
;	
;	B22_19d0:		jsr $9a0e		; 20 0e 9a
;	B22_19d3:		bne B22_1a09 ; d0 34
;	
;	B22_19d5:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_19d7:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_19da:		beq B22_19ee ; f0 12
;	
;	B22_19dc:		ldy wEntityBaseX, x	; bc 38 04
;	B22_19df:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_19e2:		bne B22_19e9 ; d0 05
;	
;	B22_19e4:		cpy #$f4		; c0 f4
;	B22_19e6:		bcs B22_19ee ; b0 06
;	
;	B22_19e8:		rts				; 60 
;	
;	
;	B22_19e9:		cpy #$0c		; c0 0c
;	B22_19eb:		bcc B22_19ee ; 90 01
;	
;	B22_19ed:		rts				; 60 
;	
;	
;	B22_19ee:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_19f0:		lda wEntityFacingLeft, x	; bd a8 04
;	B22_19f3:		eor #$01		; 49 01
;	B22_19f5:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_19f8:		jsr reverseEntityHorizSpeed		; 20 4b 80
;	B22_19fb:		lda wGameStateLoopCounter			; a5 1a
;	B22_19fd:		adc wEntityBaseX		; 6d 38 04
;	B22_1a00:		and #$03		; 29 03
;	B22_1a02:		tay				; a8 
;	B22_1a03:		lda $9a0a, y	; b9 0a 9a
;	B22_1a06:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1a09:		rts				; 60 
;	
;	
;	B22_1a0a:		lda #$d1		; a9 d1
;	B22_1a0c:	.db $97
;	B22_1a0d:	.db $c3
;	B22_1a0e:		jsr $80d5		; 20 d5 80
;	B22_1a11:		cmp #$08		; c9 08
;	B22_1a13:		bcs B22_1a36 ; b0 21
;	
;	B22_1a15:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;	B22_1a18:		cmp #$20		; c9 20
;	B22_1a1a:		bcs B22_1a36 ; b0 1a
;	
;	B22_1a1c:		lda #$00		; a9 00
;	B22_1a1e:		ldy wEntityBaseX, x	; bc 38 04
;	B22_1a21:		cpy wEntityBaseX		; cc 38 04
;	B22_1a24:		bcc B22_1a28 ; 90 02
;	
;	B22_1a26:		lda #$01		; a9 01
;	B22_1a28:		cmp wEntityFacingLeft, x	; dd a8 04
;	B22_1a2b:		bne B22_1a36 ; d0 09
;	
;	B22_1a2d:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1a30:		lda #$05		; a9 05
;	B22_1a32:		sta wEntityPhase, x	; 9d c1 05
;	B22_1a35:		rts				; 60 
;	
;	
;	B22_1a36:		lda #$00		; a9 00
;	B22_1a38:		rts				; 60 
;	
;	
;	entityPhaseFunc_79:
;	B22_1a39:		jsr $9dc5		; 20 c5 9d
;	B22_1a3c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1a3e:		rts				; 60 
;	
;	
;	entityPhaseFunc_77:
;	B22_1a3f:		lda wEntityState, x	; bd 70 04
;	B22_1a42:		and #$01		; 29 01
;	B22_1a44:		bne B22_1a6f ; d0 29
;	
;	B22_1a46:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1a49:		sta $07ed		; 8d ed 07
;	B22_1a4c:		lda #$02		; a9 02
;	B22_1a4e:		sta $061d, x	; 9d 1d 06
;	B22_1a51:		jsr $81a7		; 20 a7 81
;	B22_1a54:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1a57:		lda #$30		; a9 30
;	B22_1a59:		sta $07ee		; 8d ee 07
;	B22_1a5c:		lda #$00		; a9 00
;	B22_1a5e:		sta $07ef		; 8d ef 07
;	B22_1a61:		ldy $07ed		; ac ed 07
;	B22_1a64:		lda $9a70, y	; b9 70 9a
;	B22_1a67:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_1a6a:		lda #$09		; a9 09
;	B22_1a6c:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1a6f:		rts				; 60 
;	
;	
;	B22_1a70:		ora ($ff, x)	; 01 ff
;	B22_1a72:		sed				; f8 
;	B22_1a73:		php				; 08 
;	B22_1a74:		.db $00				; 00
;	B22_1a75:		ora ($08, x)	; 01 08
;	B22_1a77:		clc				; 18 
;	
;	
;	entityPhaseFunc_76:
;	B22_1a78:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;	B22_1a7b:		bne B22_1a6f ; d0 f2
;	
;	B22_1a7d:		lda $061d, x	; bd 1d 06
;	B22_1a80:		cmp #$08		; c9 08
;	B22_1a82:		beq B22_1b02 ; f0 7e
;	
;	B22_1a84:		ldy $07ed		; ac ed 07
;	B22_1a87:		lda $9a74, y	; b9 74 9a
;	B22_1a8a:		sta $00			; 85 00
;	B22_1a8c:		lda $9b72, y	; b9 72 9b
;	B22_1a8f:		sta $09			; 85 09
;	B22_1a91:		clc				; 18 
;	B22_1a92:		lda wEntityBaseX, x	; bd 38 04
;	B22_1a95:		adc $9a72, y	; 79 72 9a
;	B22_1a98:		ldy $061d, x	; bc 1d 06
;	B22_1a9b:		sta wEntityBaseX, y	; 99 38 04
;	B22_1a9e:		lda wEntityState, x	; bd 70 04
;	B22_1aa1:		and #$be		; 29 be
;	B22_1aa3:		sta $08			; 85 08
;	B22_1aa5:		lda wEntityState, x	; bd 70 04
;	B22_1aa8:		and #$01		; 29 01
;	B22_1aaa:		adc $09			; 65 09
;	B22_1aac:		and #$01		; 29 01
;	B22_1aae:		ora $08			; 05 08
;	B22_1ab0:		sta wEntityState, y	; 99 70 04
;	B22_1ab3:		lda $00			; a5 00
;	B22_1ab5:		sta wEntityFacingLeft, y	; 99 a8 04
;	B22_1ab8:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1abb:		sta wEntityBaseY, y	; 99 1c 04
;	B22_1abe:		lda #$12		; a9 12
;	B22_1ac0:		sta wEntityOamSpecGroupDoubled, y	; 99 8c 04
;	B22_1ac3:		lda #$2d		; a9 2d
;	B22_1ac5:		sta wEntityAI_idx, y	; 99 ef 05
;	B22_1ac8:		lda #$59		; a9 59
;	B22_1aca:		sta wEntityObjectIdxes, y	; 99 4e 05
;	B22_1acd:		lda #$00		; a9 00
;	B22_1acf:		sta wEntityPaletteOverride, y	; 99 54 04
;	B22_1ad2:		sta wEntityHorizSpeed, y	; 99 f2 04
;	B22_1ad5:		sta wEntityHorizSubSpeed, y	; 99 09 05
;	B22_1ad8:		sta wEntityVertSpeed, y	; 99 20 05
;	B22_1adb:		sta wEntityVertSubSpeed, y	; 99 37 05
;	B22_1ade:		sta wEntityPhase, y	; 99 c1 05
;	B22_1ae1:		lda #$20		; a9 20
;	B22_1ae3:		sta $067b, y	; 99 7b 06
;	B22_1ae6:		lda #$20		; a9 20
;	B22_1ae8:		sta $0657, y	; 99 57 06
;	B22_1aeb:		sty $11			; 84 11
;	B22_1aed:		lda #$42		; a9 42
;	B22_1aef:		ldy $48			; a4 48
;	B22_1af1:		cpy #$14		; c0 14
;	B22_1af3:		bne B22_1af7 ; d0 02
;	
;	B22_1af5:		lda #$50		; a9 50
;	B22_1af7:		ldy $11			; a4 11
;	B22_1af9:		sta wOamSpecIdxDoubled, y	; 99 00 04
;	B22_1afc:		inc $061d, x	; fe 1d 06
;	B22_1aff:		jmp $9a6a		; 4c 6a 9a
;	
;	
;	B22_1b02:		inc wEntityPhase, x	; fe c1 05
;	B22_1b05:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;	B22_1b08:		lda #$00		; a9 00
;	B22_1b0a:		sta $07ec		; 8d ec 07
;	B22_1b0d:		jsr setEntityStateNotMoving		; 20 9e 81
;	B22_1b10:		ldy $07ed		; ac ed 07
;	B22_1b13:		lda $9a76, y	; b9 76 9a
;	B22_1b16:		sta $07			; 85 07
;	B22_1b18:		ldx #$01		; a2 01
;	B22_1b1a:		lda $07			; a5 07
;	B22_1b1c:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1b1f:		sta $061d, x	; 9d 1d 06
;	B22_1b22:		jsr $9b3c		; 20 3c 9b
;	B22_1b25:		jsr $9b4e		; 20 4e 9b
;	B22_1b28:		inx				; e8 
;	B22_1b29:		cpx #$09		; e0 09
;	B22_1b2b:		bcc B22_1b1a ; 90 ed
;	
;	B22_1b2d:		ldx #$01		; a2 01
;	B22_1b2f:		lda #$02		; a9 02
;	B22_1b31:		sta wEntityPhase, x	; 9d c1 05
;	B22_1b34:		inx				; e8 
;	B22_1b35:		cpx #$08		; e0 08
;	B22_1b37:		bcc B22_1b2f ; 90 f6
;	
;	B22_1b39:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1b3b:		rts				; 60 
;	
;	
;	B22_1b3c:		txa				; 8a 
;	B22_1b3d:		tay				; a8 
;	B22_1b3e:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1b41:		and #$f0		; 29 f0
;	B22_1b43:		sta $01			; 85 01
;	B22_1b45:		lda $9b60, y	; b9 60 9b
;	B22_1b48:		ora $01			; 05 01
;	B22_1b4a:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1b4d:		rts				; 60 
;	
;	
;	B22_1b4e:		txa				; 8a 
;	B22_1b4f:		tay				; a8 
;	B22_1b50:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1b53:		and #$0f		; 29 0f
;	B22_1b55:		sta $01			; 85 01
;	B22_1b57:		lda $9b69, y	; b9 69 9b
;	B22_1b5a:		ora $01			; 05 01
;	B22_1b5c:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1b5f:		rts				; 60 
;	
;	
;	B22_1b60:	.db $02
;	B22_1b61:	.db $02
;	B22_1b62:	.db $02
;	B22_1b63:	.db $02
;	B22_1b64:	.db $02
;	B22_1b65:	.db $02
;	B22_1b66:	.db $02
;	B22_1b67:	.db $02
;	B22_1b68:	.db $02
;	B22_1b69:	.db $80
;	B22_1b6a:	.db $80
;	B22_1b6b:	.db $80
;	B22_1b6c:	.db $80
;	B22_1b6d:	.db $80
;	B22_1b6e:	.db $80
;	B22_1b6f:	.db $80
;	B22_1b70:	.db $80
;	B22_1b71:	.db $80
;	B22_1b72:	.db $ff
;	B22_1b73:		.db $00				; 00
;	
;	
;	entityPhaseFunc_78:
;	B22_1b74:		jsr $9b83		; 20 83 9b
;	B22_1b77:		jsr $9bf8		; 20 f8 9b
;	B22_1b7a:		jsr $9de9		; 20 e9 9d
;	B22_1b7d:		jsr $9dc5		; 20 c5 9d
;	B22_1b80:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1b82:		rts				; 60 
;	
;	
;	B22_1b83:		ldx #$01		; a2 01
;	B22_1b85:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1b88:		and #$0f		; 29 0f
;	B22_1b8a:		tay				; a8 
;	B22_1b8b:		dey				; 88 
;	B22_1b8c:		bne B22_1b97 ; d0 09
;	
;	B22_1b8e:		jsr $9b3c		; 20 3c 9b
;	B22_1b91:		jsr $9bd3		; 20 d3 9b
;	B22_1b94:		jmp $9ba3		; 4c a3 9b
;	
;	
;	B22_1b97:		sty $01			; 84 01
;	B22_1b99:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1b9c:		and #$f0		; 29 f0
;	B22_1b9e:		ora $01			; 05 01
;	B22_1ba0:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1ba3:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1ba6:		lsr a			; 4a
;	B22_1ba7:		lsr a			; 4a
;	B22_1ba8:		lsr a			; 4a
;	B22_1ba9:		lsr a			; 4a
;	B22_1baa:		tay				; a8 
;	B22_1bab:		dey				; 88 
;	B22_1bac:		bne B22_1bb7 ; d0 09
;	
;	B22_1bae:		jsr $9b4e		; 20 4e 9b
;	B22_1bb1:		jsr $9d10		; 20 10 9d
;	B22_1bb4:		jmp $9bcb		; 4c cb 9b
;	
;	
;	B22_1bb7:		sty $01			; 84 01
;	B22_1bb9:		asl $01			; 06 01
;	B22_1bbb:		asl $01			; 06 01
;	B22_1bbd:		asl $01			; 06 01
;	B22_1bbf:		asl $01			; 06 01
;	B22_1bc1:		lda wEntityGenericCounter, x	; bd 33 06
;	B22_1bc4:		and #$0f		; 29 0f
;	B22_1bc6:		ora $01			; 05 01
;	B22_1bc8:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1bcb:		inx				; e8 
;	B22_1bcc:		cpx #$09		; e0 09
;	B22_1bce:		bcc B22_1b85 ; 90 b5
;	
;	B22_1bd0:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1bd2:		rts				; 60 
;	
;	
;	B22_1bd3:		lda $061d, x	; bd 1d 06
;	B22_1bd6:		sec				; 38 
;	B22_1bd7:		sbc wEntityAlarmOrStartYforSinusoidalMovement, x	; fd 06 06
;	B22_1bda:		beq B22_1bf7 ; f0 1b
;	
;	B22_1bdc:		and #$10		; 29 10
;	B22_1bde:		bne B22_1bec ; d0 0c
;	
;	B22_1be0:		clc				; 18 
;	B22_1be1:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_1be4:		adc #$01		; 69 01
;	B22_1be6:		and #$1f		; 29 1f
;	B22_1be8:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1beb:		rts				; 60 
;	
;	
;	B22_1bec:		sec				; 38 
;	B22_1bed:		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
;	B22_1bf0:		sbc #$01		; e9 01
;	B22_1bf2:		and #$1f		; 29 1f
;	B22_1bf4:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1bf7:		rts				; 60 
;	
;	
;	B22_1bf8:		lda #$01		; a9 01
;	B22_1bfa:		sta $10			; 85 10
;	B22_1bfc:		ldx $10			; a6 10
;	B22_1bfe:		cpx #$07		; e0 07
;	B22_1c00:		beq B22_1c23 ; f0 21
;	
;	B22_1c02:		lda wEntityBaseX, x	; bd 38 04
;	B22_1c05:		sta $04			; 85 04
;	B22_1c07:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1c0a:		sta $05			; 85 05
;	B22_1c0c:		ldy wEntityAlarmOrStartYforSinusoidalMovement, x	; bc 06 06
;	B22_1c0f:		jsr $9d7f		; 20 7f 9d
;	B22_1c12:		clc				; 18 
;	B22_1c13:		lda $9c67, y	; b9 67 9c
;	B22_1c16:		adc $05			; 65 05
;	B22_1c18:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1c1b:		jsr $9c89		; 20 89 9c
;	B22_1c1e:		inc $10			; e6 10
;	B22_1c20:		jmp $9bfc		; 4c fc 9b
;	
;	
;	B22_1c23:		lda wEntityBaseX, x	; bd 38 04
;	B22_1c26:		sta $04			; 85 04
;	B22_1c28:		lda wEntityBaseY, x	; bd 1c 04
;	B22_1c2b:		sta $05			; 85 05
;	B22_1c2d:		lda wEntityState, x	; bd 70 04
;	B22_1c30:		and #$fe		; 29 fe
;	B22_1c32:		sta $00			; 85 00
;	B22_1c34:		inx				; e8 
;	B22_1c35:		clc				; 18 
;	B22_1c36:		ldy $07ed		; ac ed 07
;	B22_1c39:		lda $9c87, y	; b9 87 9c
;	B22_1c3c:		jsr $9d8b		; 20 8b 9d
;	B22_1c3f:		lda $05			; a5 05
;	B22_1c41:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1c44:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1c46:		rts				; 60 
;	
;	
;	B22_1c47:		.db $00				; 00
;	B22_1c48:	.db $02
;	B22_1c49:	.db $03
;	B22_1c4a:		ora $06			; 05 06
;	B22_1c4c:	.db $07
;	B22_1c4d:		php				; 08 
;	B22_1c4e:		ora #$09		; 09 09
;	B22_1c50:		ora #$08		; 09 08
;	B22_1c52:	.db $07
;	B22_1c53:		asl $05			; 06 05
;	B22_1c55:	.db $03
;	B22_1c56:	.db $02
;	B22_1c57:		.db $00				; 00
;	B22_1c58:		inc $fbfd, x	; fe fd fb
;	B22_1c5b:	.db $fa
;	B22_1c5c:		sbc $f7f8, y	; f9 f8 f7
;	B22_1c5f:	.db $f7
;	B22_1c60:	.db $f7
;	B22_1c61:		sed				; f8 
;	B22_1c62:		sbc $fbfa, y	; f9 fa fb
;	B22_1c65:		sbc $f7fe, x	; fd fe f7
;	B22_1c68:	.db $f7
;	B22_1c69:		sed				; f8 
;	B22_1c6a:		sbc $fbfa, y	; f9 fa fb
;	B22_1c6d:	.db $fd $fe $00
;	B22_1c70:	.db $02
;	B22_1c71:	.db $03
;	B22_1c72:		ora $06			; 05 06
;	B22_1c74:	.db $07
;	B22_1c75:		php				; 08 
;	B22_1c76:		ora #$09		; 09 09
;	B22_1c78:		ora #$08		; 09 08
;	B22_1c7a:	.db $07
;	B22_1c7b:		asl $05			; 06 05
;	B22_1c7d:	.db $03
;	B22_1c7e:	.db $02
;	B22_1c7f:		.db $00				; 00
;	B22_1c80:		inc $fbfd, x	; fe fd fb
;	B22_1c83:	.db $fa
;	B22_1c84:		sbc $f7f7, y	; f9 f7 f7
;	B22_1c87:	.db $0f
;	B22_1c88:		sbc ($bc), y	; f1 bc
;	B22_1c8a:		asl $06			; 06 06
;	B22_1c8c:		lda $9cc8, y	; b9 c8 9c
;	B22_1c8f:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_1c92:		lda $9ca8, y	; b9 a8 9c
;	B22_1c95:		sta $0b			; 85 0b
;	B22_1c97:		lda #$00		; a9 00
;	B22_1c99:		ldy $48			; a4 48
;	B22_1c9b:		cpy #$14		; c0 14
;	B22_1c9d:		bne B22_1ca1 ; d0 02
;	
;	B22_1c9f:		lda #$0e		; a9 0e
;	B22_1ca1:		clc				; 18 
;	B22_1ca2:		adc $0b			; 65 0b
;	B22_1ca4:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_1ca7:		rts				; 60 
;	
;	
;	B22_1ca8:		rol $403e, x	; 3e 3e 40
;	B22_1cab:		rti				; 40 
;	
;	
;	B22_1cac:		rti				; 40 
;	
;	
;	B22_1cad:		rti				; 40 
;	
;	
;	B22_1cae:		rti				; 40 
;	
;	
;	B22_1caf:	.db $42
;	B22_1cb0:	.db $42
;	B22_1cb1:	.db $42
;	B22_1cb2:	.db $42
;	B22_1cb3:	.db $44
;	B22_1cb4:	.db $44
;	B22_1cb5:	.db $44
;	B22_1cb6:	.db $44
;	B22_1cb7:		lsr $46			; 46 46
;	B22_1cb9:		lsr $44			; 46 44
;	B22_1cbb:	.db $44
;	B22_1cbc:	.db $44
;	B22_1cbd:	.db $44
;	B22_1cbe:	.db $44
;	B22_1cbf:	.db $42
;	B22_1cc0:	.db $42
;	B22_1cc1:	.db $42
;	B22_1cc2:	.db $42
;	B22_1cc3:		lsr $46			; 46 46
;	B22_1cc5:		lsr $46			; 46 46
;	B22_1cc7:	.db $44
;	B22_1cc8:		ora ($00, x)	; 01 00
;	B22_1cca:		.db $00				; 00
;	B22_1ccb:		.db $00				; 00
;	B22_1ccc:		.db $00				; 00
;	B22_1ccd:		.db $00				; 00
;	B22_1cce:		.db $00				; 00
;	B22_1ccf:		.db $00				; 00
;	B22_1cd0:		.db $00				; 00
;	B22_1cd1:		.db $00				; 00
;	B22_1cd2:		.db $00				; 00
;	B22_1cd3:		.db $00				; 00
;	B22_1cd4:		.db $00				; 00
;	B22_1cd5:		.db $00				; 00
;	B22_1cd6:		.db $00				; 00
;	B22_1cd7:		.db $00				; 00
;	B22_1cd8:		.db $00				; 00
;	B22_1cd9:		ora ($01, x)	; 01 01
;	B22_1cdb:		ora ($01, x)	; 01 01
;	B22_1cdd:		ora ($01, x)	; 01 01
;	B22_1cdf:		ora ($01, x)	; 01 01
;	B22_1ce1:		ora ($01, x)	; 01 01
;	B22_1ce3:		ora ($01, x)	; 01 01
;	B22_1ce5:		ora ($01, x)	; 01 01
;	B22_1ce7:		.db $01
;	
;	
;	entityPhaseFunc_7a:
;		ldx #$01
;	B22_1cea:		lda wGameStateLoopCounter
;	B22_1cec:		and #$01		; 29 01
;	B22_1cee:		tay				; a8 
;	B22_1cef:		lda $9d0c, y	; b9 0c 9d
;	B22_1cf2:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_1cf5:		lda $9d0e, y	; b9 0e 9d
;	B22_1cf8:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_1cfb:		lda #$00		; a9 00
;	B22_1cfd:		sta wEntityPhase, x	; 9d c1 05
;	B22_1d00:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_1d03:		sta wEntityOamSpecGroupDoubled, x	; 9d 8c 04
;	B22_1d06:		inx				; e8 
;	B22_1d07:		cpx #$09		; e0 09
;	B22_1d09:		bcc B22_1cef ; 90 e4
;	
;	B22_1d0b:		rts				; 60 
;	
;	
;	B22_1d0c:		ldx $4ea3		; ae a3 4e
;	B22_1d0f:	.db $43
;	B22_1d10:		cpx #$08		; e0 08
;	B22_1d12:		beq B22_1d1e ; f0 0a
;	
;	B22_1d14:		txa				; 8a 
;	B22_1d15:		tay				; a8 
;	B22_1d16:		iny				; c8 
;	B22_1d17:		lda wEntityAlarmOrStartYforSinusoidalMovement, y	; b9 06 06
;	B22_1d1a:		sta $061d, x	; 9d 1d 06
;	B22_1d1d:		rts				; 60 
;	
;	
;	B22_1d1e:		clc				; 18 
;	B22_1d1f:		ldy $07ed		; ac ed 07
;	B22_1d22:		lda $9d7d, y	; b9 7d 9d
;	B22_1d25:		adc $07ec		; 6d ec 07
;	B22_1d28:		tay				; a8 
;	B22_1d29:		lda $9d3f, y	; b9 3f 9d
;	B22_1d2c:		cmp #$ff		; c9 ff
;	B22_1d2e:		beq B22_1d37 ; f0 07
;	
;	B22_1d30:		sta $061d, x	; 9d 1d 06
;	B22_1d33:		inc $07ec		; ee ec 07
;	B22_1d36:		rts				; 60 
;	
;	
;	B22_1d37:		lda #$00		; a9 00
;	B22_1d39:		sta $07ec		; 8d ec 07
;	B22_1d3c:		jmp $9d1e		; 4c 1e 9d
;	
;	
;	B22_1d3f:		php				; 08 
;	B22_1d40:		asl $0a0e		; 0e 0e 0a
;	B22_1d43:		asl a			; 0a
;	B22_1d44:		php				; 08 
;	B22_1d45:		php				; 08 
;	B22_1d46:		php				; 08 
;	B22_1d47:		php				; 08 
;	B22_1d48:		asl $04			; 06 04
;	B22_1d4a:	.db $04
;	B22_1d4b:		php				; 08 
;	B22_1d4c:	.db $0c
;	B22_1d4d:	.db $0c
;	B22_1d4e:		asl $0a0a		; 0e 0a 0a
;	B22_1d51:		php				; 08 
;	B22_1d52:		php				; 08 
;	B22_1d53:		asl $0e0e		; 0e 0e 0e
;	B22_1d56:		asl $0a0c		; 0e 0c 0a
;	B22_1d59:		php				; 08 
;	B22_1d5a:		php				; 08 
;	B22_1d5b:		php				; 08 
;	B22_1d5c:	.db $04
;	B22_1d5d:	.db $ff
;	B22_1d5e:		clc				; 18 
;	B22_1d5f:	.db $12
;	B22_1d60:	.db $12
;	B22_1d61:		asl $16, x		; 16 16
;	B22_1d63:		clc				; 18 
;	B22_1d64:		clc				; 18 
;	B22_1d65:		clc				; 18 
;	B22_1d66:		clc				; 18 
;	B22_1d67:	.db $1a
;	B22_1d68:	.db $14
;	B22_1d69:	.db $14
;	B22_1d6a:		clc				; 18 
;	B22_1d6b:	.db $14
;	B22_1d6c:	.db $14
;	B22_1d6d:	.db $12
;	B22_1d6e:		asl $16, x		; 16 16
;	B22_1d70:		clc				; 18 
;	B22_1d71:		clc				; 18 
;	B22_1d72:	.db $12
;	B22_1d73:	.db $12
;	B22_1d74:	.db $12
;	B22_1d75:	.db $12
;	B22_1d76:	.db $14
;	B22_1d77:		asl $18, x		; 16 18
;	B22_1d79:		clc				; 18 
;	B22_1d7a:		clc				; 18 
;	B22_1d7b:	.db $14
;	B22_1d7c:	.db $ff
;	B22_1d7d:		.db $00				; 00
;	B22_1d7e:	.db $1f
;	B22_1d7f:		lda wEntityState, x	; bd 70 04
;	B22_1d82:		and #$3e		; 29 3e
;	B22_1d84:		sta $00			; 85 00
;	B22_1d86:		inx				; e8 
;	B22_1d87:		clc				; 18 
;	B22_1d88:		lda $9c47, y	; b9 47 9c
;	B22_1d8b:		bpl B22_1d96 ; 10 09
;	
;	B22_1d8d:		adc $04			; 65 04
;	B22_1d8f:		sta wEntityBaseX, x	; 9d 38 04
;	B22_1d92:		lda #$ff		; a9 ff
;	B22_1d94:		bne B22_1d9d ; d0 07
;	
;	B22_1d96:		adc $04			; 65 04
;	B22_1d98:		sta wEntityBaseX, x	; 9d 38 04
;	B22_1d9b:		lda #$00		; a9 00
;	B22_1d9d:		sta $01			; 85 01
;	B22_1d9f:		dex				; ca 
;	B22_1da0:		lda wEntityState, x	; bd 70 04
;	B22_1da3:		and #$01		; 29 01
;	B22_1da5:		adc $01			; 65 01
;	B22_1da7:		and #$01		; 29 01
;	B22_1da9:		ora $00			; 05 00
;	B22_1dab:		inx				; e8 
;	B22_1dac:		sta wEntityState, x	; 9d 70 04
;	B22_1daf:		and #$01		; 29 01
;	B22_1db1:		bne B22_1dbc ; d0 09
;	
;	B22_1db3:		lda wEntityState, x	; bd 70 04
;	B22_1db6:		and #$7f		; 29 7f
;	B22_1db8:		sta wEntityState, x	; 9d 70 04
;	B22_1dbb:		rts				; 60 
;	
;	
;	B22_1dbc:		lda wEntityState, x	; bd 70 04
;	B22_1dbf:		ora #$80		; 09 80
;	B22_1dc1:		sta wEntityState, x	; 9d 70 04
;	B22_1dc4:		rts				; 60 
;	
;	
;	B22_1dc5:		ldx #$01		; a2 01
;	B22_1dc7:		lda wEntityObjectIdxes, x	; bd 4e 05
;	B22_1dca:		beq B22_1dd2 ; f0 06
;	
;	B22_1dcc:		inx				; e8 
;	B22_1dcd:		cpx #$09		; e0 09
;	B22_1dcf:		bcc B22_1dc7 ; 90 f6
;	
;	B22_1dd1:		rts				; 60 
;	
;	
;	B22_1dd2:		ldx #$01		; a2 01
;	B22_1dd4:		jsr $84b2		; 20 b2 84
;	B22_1dd7:		sta wEntityState, x	; 9d 70 04
;	B22_1dda:		inx				; e8 
;	B22_1ddb:		cpx #$09		; e0 09
;	B22_1ddd:		bcc B22_1dd4 ; 90 f5
;	
;	B22_1ddf:		lda $064d		; ad 4d 06
;	B22_1de2:		tax				; aa 
;	B22_1de3:		lda #$02		; a9 02
;	B22_1de5:		sta wSpawner_var7c8, x	; 9d c8 07
;	B22_1de8:		rts				; 60 
;	
;	
;	B22_1de9:		lda $07ee		; ad ee 07
;	B22_1dec:		beq B22_1df2 ; f0 04
;	
;	B22_1dee:		dec $07ee		; ce ee 07
;	B22_1df1:		rts				; 60 
;	
;	
;	B22_1df2:		lda $0478		; ad 78 04
;	B22_1df5:		and #$81		; 29 81
;	B22_1df7:		bne B22_1e61 ; d0 68
;	
;	B22_1df9:		lda $07ef		; ad ef 07
;	B22_1dfc:		bne B22_1e0c ; d0 0e
;	
;	B22_1dfe:		ldy #$02		; a0 02
;	B22_1e00:		jsr $9e7b		; 20 7b 9e
;	B22_1e03:		lda #$10		; a9 10
;	B22_1e05:		sta $07ee		; 8d ee 07
;	B22_1e08:		inc $07ef		; ee ef 07
;	B22_1e0b:		rts				; 60 
;	
;	
;	B22_1e0c:		jsr $80e3		; 20 e3 80
;	B22_1e0f:		bne B22_1e61 ; d0 50
;	
;	B22_1e11:		jsr clearAllEntityVars_todo		; 20 d7 fe
;	B22_1e14:		lda #$58		; a9 58
;	B22_1e16:		sta wEntityAI_idx, x	; 9d ef 05
;	B22_1e19:		lda #$40		; a9 40
;	B22_1e1b:		sta wEntityObjectIdxes, x	; 9d 4e 05
;	B22_1e1e:		lda $04b0		; ad b0 04
;	B22_1e21:		eor #$01		; 49 01
;	B22_1e23:		sta wEntityFacingLeft, x	; 9d a8 04
;	B22_1e26:		jsr $9fc9		; 20 c9 9f
;	B22_1e29:		clc				; 18 
;	B22_1e2a:		lda $0424		; ad 24 04
;	B22_1e2d:		adc #$04		; 69 04
;	B22_1e2f:		sta wEntityBaseY, x	; 9d 1c 04
;	B22_1e32:		lda $0478		; ad 78 04
;	B22_1e35:		and #$ba		; 29 ba
;	B22_1e37:		ora #$60		; 09 60
;	B22_1e39:		sta $09			; 85 09
;	B22_1e3b:		clc				; 18 
;	B22_1e3c:		ldy $07ed		; ac ed 07
;	B22_1e3f:		lda $9e73, y	; b9 73 9e
;	B22_1e42:		adc $0440		; 6d 40 04
;	B22_1e45:		sta wEntityBaseX, x	; 9d 38 04
;	B22_1e48:		lda $0478		; ad 78 04
;	B22_1e4b:		and #$01		; 29 01
;	B22_1e4d:		adc $9e79, y	; 79 79 9e
;	B22_1e50:		and #$01		; 29 01
;	B22_1e52:		ora $09			; 05 09
;	B22_1e54:		sta wEntityState, x	; 9d 70 04
;	B22_1e57:		lda #$01		; a9 01
;	B22_1e59:		sta $10			; 85 10
;	B22_1e5b:		lda $9e75, y	; b9 75 9e
;	B22_1e5e:		jsr $97a1		; 20 a1 97
;	B22_1e61:		ldy #$00		; a0 00
;	B22_1e63:		jsr $9e7b		; 20 7b 9e
;	B22_1e66:		lda #$00		; a9 00
;	B22_1e68:		sta $07ef		; 8d ef 07
;	B22_1e6b:		lda #$80		; a9 80
;	B22_1e6d:		sta $07ee		; 8d ee 07
;	B22_1e70:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1e72:		rts				; 60 
;	
;	
;	B22_1e73:		php				; 08 
;	B22_1e74:		sed				; f8 
;	B22_1e75:		php				; 08 
;	B22_1e76:		clc				; 18 
;	B22_1e77:	.db $3c
;	B22_1e78:		lsr a			; 4a
;	B22_1e79:		.db $00				; 00
;	B22_1e7a:	.db $ff
;	B22_1e7b:		lda $49			; a5 49
;	B22_1e7d:		cmp #$11		; c9 11
;	B22_1e7f:		beq B22_1e82 ; f0 01
;	
;	B22_1e81:		iny				; c8 
;	B22_1e82:		lda $9e89, y	; b9 89 9e
;	B22_1e85:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;	B22_1e88:		rts				; 60 
;	
;	
;	B22_1e89:	.db $3a
;	B22_1e8a:		pha				; 48 
;	B22_1e8b:	.db $3c
;	B22_1e8c:		lsr a			; 4a
;	
;	
;	entityPhaseFunc_84:
;	B22_1e8d:		ldy wEntityGenericCounter, x	; bc 33 06
;	B22_1e90:		lda $9f0d, y	; b9 0d 9f
;	B22_1e93:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	B22_1e96:		lda $9f15, y	; b9 15 9f
;	B22_1e99:		sta $061d, x	; 9d 1d 06
;	B22_1e9c:		lda $9f1d, y	; b9 1d 9f
;	B22_1e9f:		sta wEntityGenericCounter, x	; 9d 33 06
;	B22_1ea2:		jsr $81a7		; 20 a7 81
;	B22_1ea5:		clc				; 18 
;	B22_1ea6:		ldy wEntityGenericCounter, x	; bc 33 06
;	B22_1ea9:		lda $9f09, y	; b9 09 9f
;	B22_1eac:		adc $061d, x	; 7d 1d 06
;	B22_1eaf:		tay				; a8 
;	B22_1eb0:		lda $9ec9, y	; b9 c9 9e
;	B22_1eb3:		sta wEntityHorizSpeed, x	; 9d f2 04
;	B22_1eb6:		lda $9ed9, y	; b9 d9 9e
;	B22_1eb9:		sta wEntityHorizSubSpeed, x	; 9d 09 05
;	B22_1ebc:		lda $9ee9, y	; b9 e9 9e
;	B22_1ebf:		sta wEntityVertSpeed, x	; 9d 20 05
;	B22_1ec2:		lda $9ef9, y	; b9 f9 9e
;	B22_1ec5:		sta wEntityVertSubSpeed, x	; 9d 37 05
;	B22_1ec8:		rts				; 60 
;	
;	
;	B22_1ec9:	.db $ff
;	B22_1eca:		.db $00				; 00
;	B22_1ecb:		.db $00				; 00
;	B22_1ecc:		.db $00				; 00
;	B22_1ecd:	.db $ff
;	B22_1ece:		.db $00				; 00
;	B22_1ecf:		.db $00				; 00
;	B22_1ed0:		.db $00				; 00
;	B22_1ed1:	.db $ff
;	B22_1ed2:		.db $00				; 00
;	B22_1ed3:		ora ($00, x)	; 01 00
;	B22_1ed5:		inc $0100, x	; fe 00 01
;	B22_1ed8:		.db $00				; 00
;	B22_1ed9:	.db $80
;	B22_1eda:		.db $00				; 00
;	B22_1edb:	.db $80
;	B22_1edc:		.db $00				; 00
;	B22_1edd:		rti				; 40 
;	
;	
;	B22_1ede:		.db $00				; 00
;	B22_1edf:		cpy #$00		; c0 00
;	B22_1ee1:		.db $00				; 00
;	B22_1ee2:		.db $00				; 00
;	B22_1ee3:		.db $00				; 00
;	B22_1ee4:		.db $00				; 00
;	B22_1ee5:		cpy #$00		; c0 00
;	B22_1ee7:		rti				; 40 
;	
;	
;	B22_1ee8:		.db $00				; 00
;	B22_1ee9:		.db $00				; 00
;	B22_1eea:		.db $00				; 00
;	B22_1eeb:		.db $00				; 00
;	B22_1eec:	.db $ff
;	B22_1eed:		.db $00				; 00
;	B22_1eee:		.db $00				; 00
;	B22_1eef:		.db $00				; 00
;	B22_1ef0:	.db $ff
;	B22_1ef1:		.db $00				; 00
;	B22_1ef2:		ora ($00, x)	; 01 00
;	B22_1ef4:	.db $ff
;	B22_1ef5:		.db $00				; 00
;	B22_1ef6:		ora ($00, x)	; 01 00
;	B22_1ef8:		inc $8000, x	; fe 00 80
;	B22_1efb:		.db $00				; 00
;	B22_1efc:	.db $80
;	B22_1efd:		.db $00				; 00
;	B22_1efe:		cpy #$00		; c0 00
;	B22_1f00:		rti				; 40 
;	
;	
;	B22_1f01:		.db $00				; 00
;	B22_1f02:		.db $00				; 00
;	B22_1f03:		.db $00				; 00
;	B22_1f04:		.db $00				; 00
;	B22_1f05:		.db $00				; 00
;	B22_1f06:		rti				; 40 
;	
;	
;	B22_1f07:		.db $00				; 00
;	B22_1f08:		cpy #$00		; c0 00
;	B22_1f0a:	.db $04
;	B22_1f0b:		php				; 08 
;	B22_1f0c:	.db $0c
;	B22_1f0d:		.db $00				; 00
;	B22_1f0e:		ora ($01, x)	; 01 01
;	B22_1f10:		.db $00				; 00
;	B22_1f11:		.db $00				; 00
;	B22_1f12:		.db $00				; 00
;	B22_1f13:		.db $00				; 00
;	B22_1f14:		.db $00				; 00
;	B22_1f15:		.db $00				; 00
;	B22_1f16:	.db $02
;	B22_1f17:	.db $02
;	B22_1f18:		.db $00				; 00
;	B22_1f19:	.db $02
;	B22_1f1a:		.db $00				; 00
;	B22_1f1b:		.db $00				; 00
;	B22_1f1c:		.db $00				; 00
;	B22_1f1d:	.db $02
;	B22_1f1e:		ora ($02, x)	; 01 02
;	B22_1f20:	.db $03
;	B22_1f21:	.db $03
;	B22_1f22:		.db $00				; 00
;	B22_1f23:		.db $00				; 00
;	B22_1f24:		.db $00				; 00
;	
;	
;	entityPhaseFunc_85:
;	B22_1f25:		jsr $9f8e		; 20 8e 9f
;	B22_1f28:		jsr $9f9b		; 20 9b 9f
;	B22_1f2b:		beq B22_1f41 ; f0 14
;	
;	B22_1f2d:		jsr $9f8e		; 20 8e 9f
;	B22_1f30:		adc #$04		; 69 04
;	B22_1f32:		jsr $9f9b		; 20 9b 9f
;	B22_1f35:		beq B22_1f7b ; f0 44
;	
;	B22_1f37:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1f39:		jsr $9f8e		; 20 8e 9f
;	B22_1f3c:		adc #$04		; 69 04
;	B22_1f3e:		jmp $9f84		; 4c 84 9f
;	
;	
;	B22_1f41:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1f43:		inc wEntityPhase, x	; fe c1 05
;	B22_1f46:		jmp $9f81		; 4c 81 9f
;	
;	
;	B22_1f49:		ora ($02, x)	; 01 02
;	B22_1f4b:	.db $03
;	B22_1f4c:		.db $00				; 00
;	B22_1f4d:	.db $03
;	B22_1f4e:		.db $00				; 00
;	B22_1f4f:		ora ($02, x)	; 01 02
;	B22_1f51:	.db $03
;	B22_1f52:		.db $00				; 00
;	B22_1f53:		ora ($02, x)	; 01 02
;	B22_1f55:		ora ($02, x)	; 01 02
;	B22_1f57:	.db $03
;	B22_1f58:		.db $00				; 00
;	
;	
;	entityPhaseFunc_86:
;	B22_1f59:		jsr $9f8e		; 20 8e 9f
;	B22_1f5c:		jsr $9f9b		; 20 9b 9f
;	B22_1f5f:		bne B22_1f75 ; d0 14
;	
;	B22_1f61:		jsr $9f8e		; 20 8e 9f
;	B22_1f64:		adc #$04		; 69 04
;	B22_1f66:		jsr $9f9b		; 20 9b 9f
;	B22_1f69:		beq B22_1f7b ; f0 10
;	
;	B22_1f6b:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1f6d:		jsr $9f8e		; 20 8e 9f
;	B22_1f70:		adc #$04		; 69 04
;	B22_1f72:		jsr $9f84		; 20 84 9f
;	B22_1f75:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;	B22_1f77:		dec wEntityPhase, x	; de c1 05
;	B22_1f7a:		rts				; 60 
;	
;	
;	B22_1f7b:		lda #$7f		; a9 7f
;	B22_1f7d:		sta $067b, x	; 9d 7b 06
;	B22_1f80:		rts				; 60 
;	
;	
;	B22_1f81:		jsr $9f8e		; 20 8e 9f
;	B22_1f84:		tay				; a8 
;	B22_1f85:		lda $9f49, y	; b9 49 9f
;	B22_1f88:		sta $061d, x	; 9d 1d 06
;	B22_1f8b:		jmp $9ea5		; 4c a5 9e
;	
;	
;	B22_1f8e:		clc				; 18 
;	B22_1f8f:		lda $061d, x	; bd 1d 06
;	B22_1f92:		ldy wEntityAlarmOrStartYforSinusoidalMovement, x	; bc 06 06
;	B22_1f95:		adc $9f99, y	; 79 99 9f
;	B22_1f98:		rts				; 60 
;	
;	
;	B22_1f99:		.db $00				; 00
;	B22_1f9a:		php				; 08 
;	B22_1f9b:		tay				; a8 
;	B22_1f9c:		lda $9fb9, y	; b9 b9 9f
;	B22_1f9f:		sta $00			; 85 00
;	B22_1fa1:		lda $9fa9, y	; b9 a9 9f
;	B22_1fa4:		ldy $00			; a4 00
;	B22_1fa6:		jmp func_1f_1c1e		; 4c 1e fc
;	
;	
;	B22_1fa9:	.db $07
;	B22_1faa:	.db $0c
;	B22_1fab:		sed				; f8 
;	B22_1fac:	.db $f4
;	B22_1fad:		sed				; f8 
;	B22_1fae:		.db $00				; 00
;	B22_1faf:	.db $07
;	B22_1fb0:		.db $00				; 00
;	B22_1fb1:	.db $07
;	B22_1fb2:	.db $f4
;	B22_1fb3:		sed				; f8 
;	B22_1fb4:	.db $0c
;	B22_1fb5:		sed				; f8 
;	B22_1fb6:		.db $00				; 00
;	B22_1fb7:	.db $07
;	B22_1fb8:		.db $00				; 00
;	B22_1fb9:	.db $0c
;	B22_1fba:		sed				; f8 
;	B22_1fbb:	.db $f4
;	B22_1fbc:	.db $07
;	B22_1fbd:		.db $00				; 00
;	B22_1fbe:	.db $07
;	B22_1fbf:		.db $00				; 00
;	B22_1fc0:		sed				; f8 
;	B22_1fc1:	.db $f4
;	B22_1fc2:		sed				; f8 
;	B22_1fc3:	.db $0c
;	B22_1fc4:	.db $07
;	B22_1fc5:		.db $00				; 00
;	B22_1fc6:	.db $07
;	B22_1fc7:		.db $00				; 00
;	B22_1fc8:		sed				; f8 
;	B22_1fc9:		lda wHardMode		; ad f6 07
;	B22_1fcc:		bne B22_1fe3 ; d0 15
;	
;	B22_1fce:		lda wCurrRoomGroup		; a5 32
;	B22_1fd0:		ldy #$00		; a0 00
;	B22_1fd2:		cmp #$03		; c9 03
;	B22_1fd4:		bcc B22_1fdc ; 90 06
;	
;	B22_1fd6:		iny				; c8 
;	B22_1fd7:		cmp #$0c		; c9 0c
;	B22_1fd9:		bcc B22_1fdc ; 90 01
;	
;	B22_1fdb:		iny				; c8 
;	B22_1fdc:		lda $9fe7, y	; b9 e7 9f
;	B22_1fdf:		sta $0657, x	; 9d 57 06
;	B22_1fe2:		rts				; 60 
;	
;	
;	B22_1fe3:		lda #$30		; a9 30
;	B22_1fe5:		bne B22_1fdf ; d0 f8
;	
;	B22_1fe7:		;removed
;		.db $10 $20
;	
;	B22_1fe9:		.db $30 
;	
;	
;	entityPhaseFunc_69:
;		inc $05c1, x
;	B22_1fed:		ldy #$01		; a0 01
;	B22_1fef:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1ff1:		sta $061d, x	; 9d 1d 06
;	B22_1ff4:		iny				; c8 
;	B22_1ff5:		lda (wPhaseFuncDataAddr), y	; b1 02
;	B22_1ff7:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;	-	rts				; 60 
;	
;	
;	entityPhaseFunc_6a:
;	B22_1ffb:		jsr $8120		; 20 20 81
;		bcs -
;	
;	cont.
	
	

bank $17
base $a000
org $a000		; entityPhaseFuncs_b17.s			;	NES 2e000

	B23_0000:		
		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
		bne + 	; d0 19

		lda $061d, x	; bd 1d 06
		eor #$01		; 49 01
		sta $061d, x	; 9d 1d 06
		tay				; a8 
		lda $a039, y	; b9 39 a0
		sta wEntityHorizSpeed, x	; 9d f2 04
		lda #$00		; a9 00
		sta wEntityHorizSubSpeed, x	; 9d 09 05
		lda #$38		; a9 38
		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
	+	lda $061d, x	; bd 1d 06
		beq +

		lda #$08		; a9 08
		jsr $806f	;addAtoEntityHorizSpeed		; 20 6f 80
		jsr $8e20		; 20 20 8e
		jmp $a054		; 4c 54 a0


	+	lda #$08		; a9 08
		jsr $808f		;subAfromEntityHorizSpeed		; 20 8f 80
		jsr $8e20		; 20 20 8e
		jmp $a054		; 4c 54 a0



;
;B23_0039:		ora ($ff, x)	; 01 ff
;
;
;entityPhaseFunc_37:
;B23_003b:		lda #$18		; a9 18
;B23_003d:		jsr $807f		; 20 7f 80
;B23_0040:		jsr $8e20		; 20 20 8e
;B23_0043:		lda wEntityVertSpeed, x	; bd 20 05
;B23_0046:		cmp #$02		; c9 02
;B23_0048:		bcc B23_0054 ; 90 0a
;
;B23_004a:		lda #$03		; a9 03
;B23_004c:		sta wEntityVertSpeed, x	; 9d 20 05
;B23_004f:		lda #$00		; a9 00
;B23_0051:		sta wEntityVertSubSpeed, x	; 9d 37 05
;B23_0054:		jsr $a0ef		; 20 ef a0
;B23_0057:		bcs B23_0068 ; b0 0f
;
;B23_0059:		inc wEntityPhase, x	; fe c1 05
;B23_005c:		inc wEntityPhase, x	; fe c1 05
;B23_005f:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;B23_0062:		jsr processItemGotten		; 20 fc a0
;B23_0065:		jmp $e76c		; 4c 6c e7
;
;B23_0068:		lda #$00		; a9 00
;B23_006a:		ldy wEntityObjectIdxes, x	; bc 4e 05
;B23_006d:		cpy #$ae		; c0 ae
;B23_006f:		bne B23_0075 ; d0 04
;
;B23_0071:		ldy #$02		; a0 02
;B23_0073:		bne B23_0077 ; d0 02
;
;B23_0075:		ldy #$08		; a0 08
;B23_0077:		jsr func_1f_1c1e		; 20 1e fc
;B23_007a:		beq B23_008a ; f0 0e
;
;B23_007c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_007e:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;B23_0081:		lda #$a0		; a9 a0
;B23_0083:		sta wEntityAlarmOrStartYforSinusoidalMovement, x	; 9d 06 06
;B23_0086:		inc wEntityPhase, x	; fe c1 05
;B23_0089:		rts				; 60 
;
;
;B23_008a:		jsr scfIfInSunkenCityRisingWaterRooms		; 20 13 81
;B23_008d:		bcc B23_0089 ; 90 fa
;
;B23_008f:		lda wEntityBaseY, x	; bd 1c 04
;B23_0092:		cmp $ca			; c5 ca
;B23_0094:		bcc B23_0089 ; 90 f3
;
;B23_0096:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_0099:		cmp #$ae		; c9 ae
;B23_009b:		beq B23_00a0 ; f0 03
;
;B23_009d:		jsr $992b		; 20 2b 99
;B23_00a0:		jmp $84b2		; 4c b2 84
;
;
;entityPhaseFunc_38:
;B23_00a3:		dec wEntityAlarmOrStartYforSinusoidalMovement, x	; de 06 06
;B23_00a6:		beq B23_00b6 ; f0 0e
;
;entityPhaseFunc_71:
;B23_00a8:		jsr $a0ef		; 20 ef a0
;B23_00ab:		bcs B23_00c2 ; b0 15
;
;B23_00ad:		inc wEntityPhase, x	; fe c1 05
;B23_00b0:		jsr processItemGotten		; 20 fc a0
;B23_00b3:		jmp $e76c		; 4c 6c e7
;
;B23_00b6:		lda #$00		; a9 00
;B23_00b8:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;B23_00bb:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_00be:		sta wEntityAI_idx, x	; 9d ef 05
;B23_00c1:		rts				; 60 
;
;B23_00c2:		lda #$00		; a9 00
;B23_00c4:		ldy #$08		; a0 08
;B23_00c6:		jsr func_1f_1c1e		; 20 1e fc
;B23_00c9:		bne B23_00d3 ; d0 08
;
;B23_00cb:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_00cd:		lda #$01		; a9 01
;B23_00cf:		sta wEntityPhase, x	; 9d c1 05
;B23_00d2:		rts				; 60 
;
;B23_00d3:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_00d5:		jmp $8120		; 4c 20 81
;
;
;entityPhaseFunc_39_setVertSpeedStartMoving:
;	jsr clearEntityHorizVertSpeeds
;	jsr setEntityStateMoving
;
;; set speed
;	ldy #$01
;	lda (wPhaseFuncDataAddr), y
;	sta wEntityVertSpeed, x
;	iny
;	lda (wPhaseFuncDataAddr), y
;	sta wEntityVertSubSpeed, x
;	inc wEntityPhase, x
;	rts
;
;
;B23_00ef:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_00f2:		cmp #$0c		; c9 0c
;B23_00f4:		bcs B23_00fb ; b0 05
;
;B23_00f6:		jsr $80d5		; 20 d5 80
;B23_00f9:		cmp #$14		; c9 14
;B23_00fb:		rts				; 60 
;
;
;processItemGotten:
;B23_00fc:		sec				; 38 
;B23_00fd:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_0100:		sbc #$93		; e9 93
;B23_0102:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw func_17_0150
;	.dw func_17_015e
;	.dw func_17_0142
;	.dw func_17_015e
;	.dw func_17_015e
;	.dw func_17_015e
;	.dw func_17_015e
;	.dw func_17_015e
;	.dw func_17_0142
;	.dw func_17_0150
;	.dw func_17_0189
;	.dw func_17_0189
;	.dw func_17_0141
;	.dw func_17_0141
;	.dw func_17_01a9
;	.dw func_17_01b5
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_01ef
;	.dw func_17_0221
;	.dw func_17_022b
;	.dw func_17_022b
;	.dw func_17_0242
;	.dw func_17_0242
;
;func_17_0141:
;B23_0141:		rts
;
;
;; eg dagger, grant's dagger
;func_17_0142:
;B23_0142:		jsr func_17_017b		; 20 7b a1
;B23_0145:		ldy wCurrPlayer		; ac 4e 05
;B23_0148:		lda $a14d, y	; b9 4d a1
;B23_014b:		bne B23_016b ; d0 1e
;
;B23_014d:	.db $03
;B23_014e:		.db $00				; 00
;B23_014f:		php				; 08 
;
;
;; eg axe, grant's axe
;func_17_0150:
;B23_0150:		jsr func_17_017b		; 20 7b a1
;B23_0153:		ldy wCurrPlayer		; ac 4e 05
;B23_0156:		lda $a15b, y	; b9 5b a1
;B23_0159:		bne B23_016b ; d0 10
;
;B23_015b:		ora ($00, x)	; 01 00
;B23_015d:		.db $09
;
;
;; eg cross, holy water, stopwatch, sypha's weapons
;func_17_015e:
;	jsr func_17_017b
;	sec
;B23_0162:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_0165:		sbc #$93		; e9 93
;B23_0167:		tay				; a8 
;B23_0168:		lda data_17_0171, y	; b9 71 a1
;
;B23_016b:		ldy wCurrCharacterIdx			; a4 3b
;.ifdef WEAPON_SWAPPING
;	jsr addNewSubweapon
;.else
;B23_016d:		sta wCurrSubweapon, y
;.endif
;B23_0170:		rts				; 60 
;
;data_17_0171:
;B23_0171:		ora ($02, x)	; 01 02
;B23_0173:	.db $03
;B23_0174:	.db $04
;B23_0175:	.db $0b
;B23_0176:		ora $06			; 05 06
;B23_0178:	.db $07
;B23_0179:		php				; 08 
;B23_017a:		.db $09
;
;
;func_17_017b:
;	lda #$00
;B23_017d:		sta $9c			; 85 9c
;B23_017f:		ldy wCurrCharacterIdx			; a4 3b
;B23_0181:		sta $87, y
;B23_0184:		lda #$1c		; a9 1c
;B23_0186:		jmp playSound		; 4c 5f e2
;
;
;func_17_0189:
;B23_0189:		lda #$1c		; a9 1c
;B23_018b:		jsr playSound		; 20 5f e2
;B23_018e:		lda #$01		; a9 01
;B23_0190:		sta $b7			; 85 b7
;B23_0192:		ldy wCurrCharacterIdx			; a4 3b
;B23_0194:		sec				; 38 
;B23_0195:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_0198:		sbc #$9c		; e9 9c
;B23_019a:	.db $99 $8e $00
;B23_019d:		lda #$00		; a9 00
;B23_019f:		sta wOamSpecIdxDoubled, x	; 9d 00 04
;B23_01a2:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_01a5:		sta wEntityAI_idx, x	; 9d ef 05
;B23_01a8:		rts				; 60 
;
;
;; eg invincibility
;func_17_01a9:
;B23_01a9:		lda #$17		; a9 17
;B23_01ab:		jsr playSound		; 20 5f e2
;B23_01ae:		lda #$b4		; a9 b4
;B23_01b0:		sta $ad			; 85 ad
;B23_01b2:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_01b4:		rts				; 60 
;
;
;; eg rosary
;func_17_01b5:
;B23_01b5:		lda #$4a		; a9 4a
;B23_01b7:		jsr playSound		; 20 5f e2
;B23_01ba:		ldx #$01		; a2 01
;B23_01bc:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_01bf:		cmp #$48		; c9 48
;B23_01c1:		bcc B23_01e3 ; 90 20
;
;B23_01c3:		cmp #$68		; c9 68
;B23_01c5:		bcs B23_01e3 ; b0 1c
;
;B23_01c7:		txa				; 8a 
;B23_01c8:		pha				; 48 
;B23_01c9:		jsr $e7cc		; 20 cc e7
;B23_01cc:		pla				; 68 
;B23_01cd:		tax				; aa 
;B23_01ce:		lda #$6f		; a9 6f
;B23_01d0:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_01d3:		lda #$18		; a9 18
;B23_01d5:		sta wEntityAI_idx, x	; 9d ef 05
;B23_01d8:		lda #$00		; a9 00
;B23_01da:		sta wEntityPhase, x	; 9d c1 05
;B23_01dd:		sta wEntityState, x	; 9d 70 04
;B23_01e0:		jsr $b52f		; 20 2f b5
;B23_01e3:		inx				; e8 
;B23_01e4:		cpx #$0d		; e0 0d
;B23_01e6:		bcc B23_01bc ; 90 d4
;
;B23_01e8:		lda #$20		; a9 20
;B23_01ea:		sta $b2			; 85 b2
;B23_01ec:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_01ee:		rts				; 60 
;
;
;; eg point bags
;func_17_01ef:
;B23_01ef:		lda #$18		; a9 18
;B23_01f1:		jsr playSound		; 20 5f e2
;B23_01f4:		sec				; 38 
;B23_01f5:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_01f8:		sbc #$a3		; e9 a3
;B23_01fa:		tay				; a8 
;B23_01fb:		lda $a20f, y	; b9 0f a2
;B23_01fe:		sta $02			; 85 02
;B23_0200:		lda $a218, y	; b9 18 a2
;B23_0203:		sta $03			; 85 03
;B23_0205:		lda #$00		; a9 00
;B23_0207:		sta $01			; 85 01
;B23_0209:		jsr $e777		; 20 77 e7
;B23_020c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_020e:		rts				; 60 
;
;
;B23_020f:		ora ($02, x)	; 01 02
;B23_0211:	.db $04
;B23_0212:	.db $07
;B23_0213:		;removed
;	.db $10 $20
;
;B23_0215:		rti				; 40 
;
;
;B23_0216:		bvs B23_0218 ; 70 00
;
;B23_0218:		.db $00				; 00
;B23_0219:		.db $00				; 00
;B23_021a:		.db $00				; 00
;B23_021b:		.db $00				; 00
;B23_021c:		.db $00				; 00
;B23_021d:		.db $00				; 00
;B23_021e:		.db $00				; 00
;B23_021f:		.db $00				; 00
;B23_0220:		.db $01
;
;
;; eg 1-up
;func_17_0221:
;	lda #$01
;	sta $d7
;B23_0225:		jsr $e748		; 20 48 e7
;B23_0228:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_022a:		rts				; 60 
;
;
;; eg hearts
;func_17_022b:
;B23_022b:		lda #$1b		; a9 1b
;B23_022d:		jsr playSound		; 20 5f e2
;B23_0230:		sec				; 38 
;B23_0231:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_0234:		sbc #$ad		; e9 ad
;B23_0236:		tay				; a8 
;B23_0237:		lda $a240, y	; b9 40 a2
;B23_023a:		jsr $e760		; 20 60 e7
;B23_023d:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_023f:		rts				; 60 
;
;
;B23_0240:		ora $01			; 05 01
;
;
;; eg multipliers
;func_17_0242:
;B23_0242:		lda #$1c		; a9 1c
;B23_0244:		jsr playSound		; 20 5f e2
;B23_0247:		ldy wCurrCharacterIdx			; a4 3b
;B23_0249:	.db $b9 $85 $00
;B23_024c:		cmp #$0b		; c9 0b
;B23_024e:		beq B23_0264 ; f0 14
;
;B23_0250:		cmp #$05		; c9 05
;B23_0252:		bcc B23_0258 ; 90 04
;
;B23_0254:		cmp #$08		; c9 08
;B23_0256:		bcc B23_0264 ; 90 0c
;
;B23_0258:		sec				; 38 
;B23_0259:		lda wEntityObjectIdxes, x	; bd 4e 05
;B23_025c:		sbc #$ae		; e9 ae
;B23_025e:		ldy wCurrCharacterIdx			; a4 3b
;B23_0260:	.db $99 $87 $00
;B23_0263:		rts				; 60 
;
;
;B23_0264:		lda #$a7		; a9 a7
;B23_0266:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_0269:		lda #$47		; a9 47
;B23_026b:		sta wEntityAI_idx, x	; 9d ef 05
;B23_026e:		lda #$04		; a9 04
;B23_0270:		sta wEntityPhase, x	; 9d c1 05
;B23_0273:		ldy #$04		; a0 04
;B23_0275:		jmp $a1fb		; 4c fb a1
;
;
;B23_0278:		lda wCurrPlayer		; ad 4e 05
;B23_027b:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a286
;	.dw $a3b4
;	.dw $a3b4
;	.dw $a2b0
;
;B23_0286:		ldy #$00		; a0 00
;B23_0288:		lda $8e			; a5 8e
;B23_028a:		beq B23_02a5 ; f0 19
;
;B23_028c:		cmp #$02		; c9 02
;B23_028e:		beq B23_02ab ; f0 1b
;
;B23_0290:		lda wNumHearts			; a5 84
;B23_0292:		cmp #$08		; c9 08
;B23_0294:		bcc B23_02ab ; 90 15
;
;B23_0296:		iny				; c8 
;B23_0297:		lda $a2ae, y	; b9 ae a2
;B23_029a:		jsr func_17_03f8		; 20 f8 a3
;B23_029d:		beq B23_02ab ; f0 0c
;
;B23_029f:		lda $00			; a5 00
;B23_02a1:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_02a4:		rts				; 60 
;
;B23_02a5:		lda wNumHearts			; a5 84
;B23_02a7:		cmp #$04		; c9 04
;B23_02a9:		bcs B23_0297 ; b0 ec
;
;B23_02ab:		jmp $a3b4		; 4c b4 a3
;
;
;B23_02ae:		sta $a09e, x	; 9d 9e a0
;B23_02b1:		.db $00				; 00
;B23_02b2:		lda $8f			; a5 8f
;B23_02b4:		beq B23_02cf ; f0 19
;
;B23_02b6:		cmp #$02		; c9 02
;B23_02b8:		beq B23_02ab ; f0 f1
;
;B23_02ba:		lda wNumHearts			; a5 84
;B23_02bc:		cmp #$08		; c9 08
;B23_02be:		bcc B23_02ab ; 90 eb
;
;B23_02c0:		iny				; c8 
;B23_02c1:		lda $a2ae, y	; b9 ae a2
;B23_02c4:		jsr func_17_03f8		; 20 f8 a3
;B23_02c7:		beq B23_02ab ; f0 e2
;
;B23_02c9:		lda $00			; a5 00
;B23_02cb:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_02ce:		rts				; 60 
;
;
;B23_02cf:		lda wNumHearts			; a5 84
;B23_02d1:		cmp #$04		; c9 04
;B23_02d3:		bcs B23_02c1 ; b0 ec
;
;B23_02d5:		jmp $a3b4		; 4c b4 a3
;
;
;B23_02d8:		ldy $d7			; a4 d7
;B23_02da:		beq B23_02fc ; f0 20
;
;B23_02dc:		jsr $a278		; 20 78 a2
;B23_02df:		jmp $a2f9		; 4c f9 a2
;
;
;B23_02e2:		lda #$33		; a9 33
;B23_02e4:		jsr playSound		; 20 5f e2
;B23_02e7:		lda $05d8, x	; bd d8 05
;B23_02ea:		cmp #$ac		; c9 ac
;B23_02ec:		beq B23_02d8 ; f0 ea
;
;B23_02ee:		cmp #$ae		; c9 ae
;B23_02f0:		beq B23_02dc ; f0 ea
;
;B23_02f2:		cmp #$98		; c9 98
;B23_02f4:		bcs B23_02fc ; b0 06
;
;B23_02f6:		jsr $a30b		; 20 0b a3
;B23_02f9:		lda wEntityObjectIdxes, x	; bd 4e 05
;
;B23_02fc:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_02ff:		sec				; 38 
;B23_0300:		sbc #$60		; e9 60
;B23_0302:		sta wEntityAI_idx, x	; 9d ef 05
;B23_0305:		jsr $b584		; 20 84 b5
;B23_0308:		jmp $ffaa		; 4c aa ff
;
;
;B23_030b:		sec				; 38 
;B23_030c:		sbc #$93		; e9 93
;B23_030e:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a31b
;	.dw $a329
;	.dw $a337
;	.dw $a345
;	.dw $a353
;B23_031b:		lda wCurrPlayer		; ad 4e 05
;B23_031e:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a358
;	.dw $a394
;	.dw $a358
;	.dw $a3b4
;B23_0329:		lda wCurrPlayer		; ad 4e 05
;B23_032c:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a380
;	.dw $a390
;	.dw $a358
;	.dw $a3b4
;B23_0337:		lda wCurrPlayer		; ad 4e 05
;B23_033a:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a371
;	.dw $a394
;	.dw $a371
;	.dw $a3b4
;B23_0345:		lda wCurrPlayer		; ad 4e 05
;B23_0348:		jsr jumpTablePreserveY		; 20 6d e8
;	.dw $a388
;	.dw $a38c
;	.dw $a371
;	.dw $a3b4
;B23_0353:		lda #$97		; a9 97
;B23_0355:		jmp $a398		; 4c 98 a3
;
;
;B23_0358:		lda wCurrPlayer		; ad 4e 05
;B23_035b:		beq B23_036c ; f0 0f
;
;B23_035d:		lda $86			; a5 86
;B23_035f:		cmp #$09		; c9 09
;B23_0361:		bne B23_0366 ; d0 03
;
;B23_0363:		jmp $b5ce		; 4c ce b5
;
;
;B23_0366:		lda #$93		; a9 93
;B23_0368:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_036b:		rts				; 60 
;
;
;B23_036c:		lda #$93		; a9 93
;B23_036e:		jmp $a398		; 4c 98 a3
;
;
;B23_0371:		lda wCurrPlayer		; ad 4e 05
;B23_0374:		beq B23_0384 ; f0 0e
;
;B23_0376:		lda $86			; a5 86
;B23_0378:		cmp #$08		; c9 08
;B23_037a:		beq B23_0363 ; f0 e7
;
;B23_037c:		lda #$95		; a9 95
;B23_037e:		bne B23_0368 ; d0 e8
;
;B23_0380:		lda #$94		; a9 94
;B23_0382:		bne B23_0398 ; d0 14
;
;B23_0384:		lda #$95		; a9 95
;B23_0386:		bne B23_0398 ; d0 10
;
;B23_0388:		lda #$96		; a9 96
;B23_038a:		bne B23_0398 ; d0 0c
;
;B23_038c:		lda #$99		; a9 99
;B23_038e:		bne B23_0398 ; d0 08
;
;B23_0390:		lda #$9a		; a9 9a
;B23_0392:		bne B23_0398 ; d0 04
;
;B23_0394:		lda #$98		; a9 98
;B23_0396:		bne B23_0398 ; d0 00
;
;B23_0398:		sta $10			; 85 10
;B23_039a:		ldy wCurrCharacterIdx			; a4 3b
;B23_039c:		sec				; 38 
;B23_039d:		sbc #$93		; e9 93
;B23_039f:		tay				; a8 
;B23_03a0:		lda $a171, y	; b9 71 a1
;B23_03a3:		ldy wCurrCharacterIdx			; a4 3b
;B23_03a5:	.db $d9 $85 $00
;B23_03a8:		beq B23_0363 ; f0 b9
;
;B23_03aa:		lda $10			; a5 10
;B23_03ac:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_03af:		rts				; 60 
;
;
;B23_03b0:		lda #$ad		; a9 ad
;B23_03b2:		bne B23_03ac ; d0 f8
;
;B23_03b4:		jsr $a3e8		; 20 e8 a3
;B23_03b7:		bne B23_03c3 ; d0 0a
;
;B23_03b9:		lda $9e			; a5 9e
;B23_03bb:		beq B23_03c3 ; f0 06
;
;B23_03bd:		lda $9c			; a5 9c
;B23_03bf:		cmp #$0a		; c9 0a
;B23_03c1:		bcs B23_03c7 ; b0 04
;
;B23_03c3:		lda #$ae		; a9 ae
;B23_03c5:		bne B23_03ac ; d0 e5
;
;B23_03c7:		lda #$00		; a9 00
;B23_03c9:		sta $9c			; 85 9c
;B23_03cb:		lda wCurrPlayer		; ad 4e 05
;B23_03ce:		and #$01		; 29 01
;B23_03d0:		bne B23_03c3 ; d0 f1
;
;B23_03d2:		ldy wCurrCharacterIdx			; a4 3b
;B23_03d4:	.db $b9 $87 $00
;B23_03d7:		cmp $a3e6, y	; d9 e6 a3
;B23_03da:		bcs B23_03c3 ; b0 e7
;
;B23_03dc:		tay				; a8 
;B23_03dd:		lda $a3e4, y	; b9 e4 a3
;B23_03e0:		sta wEntityObjectIdxes, x	; 9d 4e 05
;B23_03e3:		rts				; 60 
;
;
;B23_03e4:	.db $af
;B23_03e5:		;removed
;	.db $b0 $02
;
;B23_03e7:	.db $02
;B23_03e8:		ldy wCurrCharacterIdx			; a4 3b
;B23_03ea:	.db $b9 $85 $00
;B23_03ed:		beq B23_03f5 ; f0 06
;
;B23_03ef:		lda wEntityObjectIdxes, y	; b9 4e 05
;B23_03f2:		and #$01		; 29 01
;B23_03f4:		rts				; 60 
;
;
;B23_03f5:		lda #$01		; a9 01
;B23_03f7:		rts				; 60 
;
;
;func_17_03f8:
;B23_03f8:		sta $00			; 85 00
;B23_03fa:		ldy #$01		; a0 01
;B23_03fc:		lda wEntityObjectIdxes, y	; b9 4e 05
;B23_03ff:		cmp $00			; c5 00
;B23_0401:		beq B23_040a ; f0 07
;
;B23_0403:		iny				; c8 
;B23_0404:		cpy #$13		; c0 13
;B23_0406:		bcc B23_03fc ; 90 f4
;
;B23_0408:		lda #$01		; a9 01
;B23_040a:		rts				; 60 
;
org $a40b
	entityScripts_60:
		db $97 ,$00 ,$00 ,$00 		; sc_clearSpeeds
		db $17 ,$00 ,$00 ,$00
		db $14 ,$00 ,$00 ,$00
		db $15 ,$00 ,$00 ,$00
		db $13 ,$0A ,$0B ,$00 
		db $16 ,$00 ,$00 ,$00
		db $6C ,$2D ,$00 ,$00
		db $30 ,$02 ,$00 ,$00
		db $1A ,$04 ,$00 ,$00 
		db $1B ,$00 ,$00 ,$00
		db $17 ,$00 ,$00 ,$00
		db $1A ,$10 ,$00 ,$00
		db $1B ,$00 ,$00 ,$00 
		db $7B ,$03 ,$00 ,$00
		db $30 ,$03 ,$00 ,$00
		db $16 ,$00 ,$00 ,$00
		db $1A ,$01 ,$00 ,$00 
		db $1B ,$00 ,$00 ,$00
		db $17 ,$00 ,$00 ,$00
		db $1A ,$02 ,$00 ,$00
		db $1B ,$00 ,$00 ,$00 
		db $7C ,$F9 ,$00 ,$00
		db $18 ,$00 ,$00 ,$00


;entityPhaseFunc_97_clearSpeeds:
;	inc wEntityPhase, x
;	jmp clearEntityHorizVertSpeeds
;
;
;entityPhaseFunc_14:
;B23_046d:		inc wEntityPhase, x	; fe c1 05
;B23_0470:		jsr func_17_0524		; 20 24 a5
;B23_0473:		and #$07		; 29 07
;B23_0475:		asl a			; 0a
;B23_0476:		tay				; a8 
;B23_0477:		lda $a4bf, y	; b9 bf a4
;B23_047a:		sta $05d8, x	; 9d d8 05
;B23_047d:		lda $a4c0, y	; b9 c0 a4
;B23_0480:		sta $0645, x	; 9d 45 06
;B23_0483:		lda wCurrRoomGroup		; a5 32
;B23_0485:		cmp #$02		; c9 02
;B23_0487:		bne B23_04a8 ; d0 1f
;
;B23_0489:		lda wCurrRoomSection			; a5 33
;B23_048b:		cmp #$04		; c9 04
;B23_048d:		bne B23_04a8 ; d0 19
;
;B23_048f:		lda wEntityBaseX, x	; bd 38 04
;B23_0492:		bpl B23_049f ; 10 0b
;
;B23_0494:		jsr func_17_0524		; 20 24 a5
;B23_0497:		asl a			; 0a
;B23_0498:		asl a			; 0a
;B23_0499:		asl a			; 0a
;B23_049a:		ora #$80		; 09 80
;B23_049c:		jmp $a4a5		; 4c a5 a4
;
;
;B23_049f:		jsr func_17_0524		; 20 24 a5
;B23_04a2:		asl a			; 0a
;B23_04a3:		asl a			; 0a
;B23_04a4:		asl a			; 0a
;B23_04a5:		sta wEntityBaseX, x	; 9d 38 04
;B23_04a8:		lda wEntityBaseX, x	; bd 38 04
;B23_04ab:		and #$7f		; 29 7f
;B23_04ad:		cmp #$20		; c9 20
;B23_04af:		bcc B23_04b9 ; 90 08
;
;B23_04b1:		cmp #$50		; c9 50
;B23_04b3:		bcs B23_04b9 ; b0 04
;
;B23_04b5:		lda #$58		; a9 58
;B23_04b7:		bne B23_04bb ; d0 02
;
;B23_04b9:		lda #$40		; a9 40
;B23_04bb:		sta wEntityBaseY, x	; 9d 1c 04
;B23_04be:		rts				; 60 
;
;
;B23_04bf:	.db $80
;B23_04c0:		ora ($00, x)	; 01 00
;B23_04c2:	.db $02
;B23_04c3:		cli				; 58 
;B23_04c4:		.db $00				; 00
;B23_04c5:		rts				; 60 
;
;
;B23_04c6:		.db $00				; 00
;B23_04c7:		.db $00				; 00
;B23_04c8:		ora ($00, x)	; 01 00
;B23_04ca:	.db $04
;B23_04cb:	.db $80
;B23_04cc:		ora ($20, x)	; 01 20
;B23_04ce:		.db $01
;
;
;entityPhaseFunc_15:
;	dec $05d8, x
;B23_04d2:		bpl $0e
;B23_04d4:		ldy $05d8, x
;B23_04d7:		iny
;B23_04d8:		bne B23_04e2 ; d0 08
;
;B23_04da:		dec $0645, x	; de 45 06
;B23_04dd:		bpl B23_04e2 ; 10 03
;
;B23_04df:		inc wEntityPhase, x	; fe c1 05
;B23_04e2:		rts				; 60 
;
;
;entityPhaseFunc_16:
;B23_04e3:		lda #$50		; a9 50
;B23_04e5:		sta wEntityState, x	; 9d 70 04
;B23_04e8:		bne B23_050f ; d0 25
;
;
;entityPhaseFunc_17:
;B23_04ea:		lda #$58		; a9 58
;B23_04ec:		sta wEntityState, x	; 9d 70 04
;B23_04ef:		bne B23_050f ; d0 1e
;
;
;entityPhaseFunc_18_setPhase0:
;	lda #$00
;	sta wEntityPhase, x
;	rts
;
;
;entityPhaseFunc_1a:
;B23_04f7:		ldy #$01		; a0 01
;B23_04f9:		lda (wPhaseFuncDataAddr), y	; b1 02
;B23_04fb:		sta $05d8, x	; 9d d8 05
;B23_04fe:		inc wEntityPhase, x	; fe c1 05
;B23_0501:		rts				; 60 
;
;
;entityPhaseFunc_1b:
;B23_0502:		dec $05d8, x	; de d8 05
;B23_0505:		beq B23_050f ; f0 08
;
;B23_0507:		rts				; 60 
;
;
;entityPhaseFunc_7b_setGenericCounter:
;	ldy #$01
;	lda (wPhaseFuncDataAddr), y
;	sta wEntityGenericCounter, x
;
;B23_050f:		inc wEntityPhase, x	; fe c1 05
;B23_0512:		rts				; 60 
;
;
;entityPhaseFunc_7c:
;B23_0513:		dec wEntityGenericCounter, x	; de 33 06
;B23_0516:		beq B23_050f ; f0 f7
;
;B23_0518:		ldy #$01		; a0 01
;B23_051a:		lda (wPhaseFuncDataAddr), y	; b1 02
;B23_051c:		clc				; 18 
;B23_051d:		adc wEntityPhase, x	; 7d c1 05
;B23_0520:		sta wEntityPhase, x	; 9d c1 05
;B23_0523:		rts				; 60 
;
;
;func_17_0524:
;B23_0524:		lda wRandomVal			; a5 1f
;				bne +
;
;B23_0528:		lda #$65		; a9 65
;			+	asl a			; 0a
;B23_052b:		sta $00			; 85 00
;B23_052d:		lda wRandomVal			; a5 1f
;B23_052f:		lsr a			; 4a
;B23_0530:		clc				; 18 
;B23_0531:		adc $00			; 65 00
;B23_0533:		sta wRandomVal			; 85 1f
;B23_0535:		and #$0f		; 29 0f
;B23_0537:		rts				; 60 

org $a538 		; data/entityScript

	entityScripts_6b:
		db $20 ,$00 ,$00 ,$00 	; sc_incPhaseWhenAlarm0 
		db $A1 ,$00 ,$00 ,$00
		db $A2 ,$00 ,$00 ,$00
	entityScripts_6c:	
		db $0B ,$0E ,$46 ,$00
		db $45 ,$0F ,$00 ,$00 
		db $46 ,$00 ,$00 ,$00
	entityScripts_2c:	
		db $88 ,$3A ,$00 ,$00
		db $77 ,$00 ,$00 ,$00
		db $76 ,$00 ,$00 ,$00 
		db $78 ,$00 ,$00 ,$00
	entityScripts_2d:
		db $88 ,$42 ,$00 ,$00
		db $75 ,$00 ,$00 ,$00	; sc_stub3
		db $79 ,$00 ,$00 ,$00 
	entityScripts_2e:
		db $88 ,$42 ,$00 ,$00
		db $75 ,$00 ,$00 ,$00
		db $79 ,$00 ,$00 ,$00
	entityScripts_61:
		db $7A ,$00 ,$00 ,$00 
	entityScripts_64:
		db $8B ,$00 ,$00 ,$00
		db $84 ,$00 ,$00 ,$00
		db $85 ,$00 ,$00 ,$00
		db $86 ,$00 ,$00 ,$00 
	entityScripts_6f:
		db $A5 ,$00 ,$00 ,$00
		db $84 ,$00 ,$00 ,$00
		db $85 ,$00 ,$00 ,$00
		db $86 ,$00 ,$00 ,$00 
	entityScripts_01:
		db $07 ,$00 ,$80 ,$00
		db $1C ,$00 ,$00 ,$00
		db $1D ,$00 ,$01 ,$00
	entityScripts_24:
		db $5D ,$00 ,$00 ,$00 
		db $07 ,$00 ,$80 ,$00
		db $1C ,$00 ,$00 ,$00
		db $1D ,$01 ,$01 ,$00
	entityScripts_70:
		db $A6 ,$00 ,$A0 ,$00 
		db $1C ,$00 ,$00 ,$00
		db $1D ,$00 ,$01 ,$00
	entityScripts_02:
		db $09 ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00 	; sc_facePlayer
		db $0B ,$08 ,$06 ,$00	; 0b sc_setAlarmOrStartYforSinusoidalMovement
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $53 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$08 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $08 ,$00 ,$00 ,$00 
		db $07 ,$00 ,$80 ,$00
		db $1C ,$00 ,$00 ,$00
		db $1D ,$09 ,$01 ,$00
		db $01 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$08 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$06 ,$00 
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_07:
		db $2D ,$00 ,$00 ,$00 
		db $1E ,$01 ,$10 ,$00
		db $95 ,$00 ,$00 ,$00
		db $9C ,$07 ,$00 ,$08
		db $9D ,$00 ,$00 ,$00 
	entityScripts_6d:	
		db $2D ,$00 ,$00 ,$00
		db $1E ,$01 ,$10 ,$00
		db $13 ,$08 ,$27 ,$00
		db $A3 ,$00 ,$00 ,$00 
		db $A4 ,$00 ,$00 ,$00
	entityScripts_1e:
		db $6E ,$00 ,$00 ,$00
		db $0B ,$08 ,$3E ,$00
		db $9F ,$00 ,$00 ,$00 
		db $26 ,$08 ,$04 ,$00
		db $23 ,$03 ,$04 ,$00
		db $52 ,$00 ,$00 ,$00
		db $1F ,$24 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $52 ,$00 ,$00 ,$00
		db $08 ,$01 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$01 ,$00 ,$00
	entityScripts_12:
		db $6E ,$00 ,$00 ,$00
		db $0B ,$08 ,$3E ,$00
		db $1F ,$20 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $26 ,$08 ,$04 ,$00
		db $23 ,$03 ,$04 ,$00
		db $26 ,$04 ,$08 ,$00 
		db $25 ,$28 ,$24 ,$00
		db $04 ,$02 ,$00 ,$00
	entityScripts_2f:
		db $6E ,$00 ,$00 ,$00
		db $0B ,$08 ,$40 ,$00 
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $26 ,$08 ,$04 ,$00
		db $23 ,$03 ,$04 ,$00 
		db $26 ,$04 ,$08 ,$00
		db $25 ,$28 ,$24 ,$00
		db $04 ,$02 ,$00 ,$00
	entityScripts_69
		db $2D ,$00 ,$00 ,$00 
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$4C ,$00
		db $93 ,$00 ,$00 ,$00 
		db $94 ,$00 ,$00 ,$00
		db $21 ,$00 ,$00 ,$00
		db $0B ,$08 ,$4E ,$00
		db $10 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$4C ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $04 ,$06 ,$00 ,$00 
	entityScripts_0e:
		db $01 ,$00 ,$00 ,$00
		db $91 ,$00 ,$00 ,$00
		db $06 ,$00 ,$00 ,$00
		db $1F ,$28 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $21 ,$00 ,$00 ,$00
		db $0B ,$08 ,$4E ,$00
		db $10 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$4C ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $04 ,$05 ,$00 ,$00 
	entityScripts_05:
		db $07 ,$01 ,$40 ,$00
		db $11 ,$04 ,$00 ,$00
		db $12 ,$00 ,$00 ,$00
	entityScripts_66:
		db $2D ,$00 ,$00 ,$00 
		db $1E ,$01 ,$40 ,$00
		db $13 ,$08 ,$24 ,$00
		db $11 ,$04 ,$00 ,$00
		db $12 ,$00 ,$00 ,$00 
	entityScripts_06:
		db $0B ,$08 ,$1E ,$00
		db $4D ,$60 ,$20 ,$00
		db $07 ,$01 ,$40 ,$00
		db $6F ,$00 ,$20 ,$00 
		db $70 ,$0A ,$00 ,$00
		db $11 ,$04 ,$00 ,$00
		db $12 ,$00 ,$00 ,$00
	entityScripts_6e:
		db $2D ,$00 ,$00 ,$00 
		db $1E ,$01 ,$40 ,$00
		db $13 ,$14 ,$06 ,$00
		db $11 ,$04 ,$00 ,$00
		db $12 ,$00 ,$00 ,$00 
	entityScripts_63:
		db $2D ,$00 ,$00 ,$00
		db $54 ,$00 ,$00 ,$00
		db $0B ,$12 ,$02 ,$00
		db $7E ,$00 ,$00 ,$00 
		db $7D ,$40 ,$00 ,$00
		db $0B ,$12 ,$04 ,$00
		db $1F ,$03 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0B ,$12 ,$06 ,$00
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $53 ,$00 ,$00 ,$00 
		db $0B ,$12 ,$08 ,$00
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $83 ,$00 ,$00 ,$00 
		db $2A ,$00 ,$00 ,$00
		db $1F ,$06 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $01 ,$00 ,$00 ,$00 
		db $1F ,$04 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2A ,$00 ,$00 ,$00
		db $0B ,$12 ,$0A ,$00 
		db $7F ,$00 ,$00 ,$00
		db $80 ,$00 ,$00 ,$00
		db $81 ,$00 ,$00 ,$00
		db $01 ,$00 ,$00 ,$00 
		db $05 ,$00 ,$00 ,$00
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$0A ,$00 
		db $2A ,$00 ,$00 ,$00
		db $7F ,$00 ,$00 ,$00
		db $80 ,$00 ,$00 ,$00
		db $82 ,$00 ,$00 ,$00 
	entityScripts_65:
		db $2D ,$00 ,$00 ,$00
		db $1E ,$02 ,$10 ,$00
		db $13 ,$12 ,$08 ,$00
		db $0C ,$40 ,$00 ,$00 
		db $92 ,$00 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$76 ,$00
		db $1F ,$10 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $2A ,$00 ,$00 ,$00
		db $13 ,$12 ,$09 ,$00
		db $00 ,$00 ,$00 ,$00 
	entityScripts_11:
		db $28 ,$00 ,$00 ,$00
		db $29 ,$00 ,$00 ,$00
		db $1F ,$0A ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $8F ,$00 ,$00 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2C ,$00 ,$00 ,$00 
	entityScripts_2b:
		db $13 ,$12 ,$05 ,$00
		db $1E ,$00 ,$60 ,$00
		db $6B ,$00 ,$00 ,$00
		db $6D ,$00 ,$00 ,$00 
		db $04 ,$01 ,$00 ,$00
	entityScripts_71:
		db $13 ,$14 ,$09 ,$00
		db $1E ,$00 ,$90 ,$00
		db $6B ,$00 ,$00 ,$00 
		db $6D ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
		db $0B ,$14 ,$64 ,$00
		db $1F ,$08 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$FE ,$00
		db $1F ,$16 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0B ,$14 ,$64 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00 
	entityScripts_68:
		db $13 ,$08 ,$25 ,$00
		db $54 ,$00 ,$00 ,$00
		db $8E ,$00 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $53 ,$00 ,$00 ,$00
		db $2A ,$00 ,$00 ,$00
		db $13 ,$08 ,$23 ,$00
		db $1F ,$16 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $13 ,$08 ,$02 ,$00
		db $57 ,$00 ,$00 ,$00
		db $1F ,$20 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $04 ,$0A ,$00 ,$00
	entityScripts_08:
		db $13 ,$08 ,$23 ,$00
		db $2A ,$00 ,$00 ,$00 
		db $1F ,$16 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $13 ,$08 ,$02 ,$00
		db $57 ,$00 ,$00 ,$00 
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $04 ,$05 ,$00 ,$00
	entityScripts_13:
		db $13 ,$08 ,$26 ,$00 
		db $1E ,$00 ,$60 ,$00
		db $1F ,$C0 ,$00 ,$00
		db $2F ,$00 ,$00 ,$00
		db $6D ,$00 ,$00 ,$00 
		db $04 ,$01 ,$00 ,$00
	entityScripts_09:
		db $07 ,$00 ,$90 ,$00
		db $35 ,$00 ,$00 ,$00
		db $34 ,$00 ,$00 ,$00 
		db $33 ,$0B ,$00 ,$00
		db $97 ,$00 ,$00 ,$00
		db $13 ,$08 ,$17 ,$00
		db $1F ,$0F ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0D ,$04 ,$00 ,$00
		db $1F ,$30 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00 
		db $1D ,$04 ,$06 ,$00
	entityScripts_17:
		db $30 ,$03 ,$00 ,$00
		db $07 ,$00 ,$80 ,$00
		db $1F ,$60 ,$00 ,$00 
		db $2F ,$00 ,$00 ,$00
		db $04 ,$01 ,$00 ,$00
		db $54 ,$00 ,$00 ,$00
		db $01 ,$00 ,$00 ,$00 
		db $13 ,$08 ,$22 ,$00
		db $1F ,$38 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00 
		db $1F ,$50 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$9E ,$00
		db $1F ,$18 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$9C ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $53 ,$00 ,$00 ,$00
		db $04 ,$01 ,$00 ,$00
	entityScripts_21:
		db $30 ,$03 ,$00 ,$00
		db $07 ,$00 ,$80 ,$00 
		db $35 ,$00 ,$00 ,$00
		db $3B ,$00 ,$00 ,$00
		db $6D ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00 
		db $36 ,$48 ,$00 ,$00
		db $97 ,$00 ,$00 ,$00
		db $0B ,$08 ,$AC ,$00
		db $1F ,$08 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$EE ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$00 ,$00 ,$00
		db $54 ,$00 ,$00 ,$00
		db $97 ,$00 ,$00 ,$00
		db $13 ,$08 ,$22 ,$00 
		db $1F ,$38 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00
		db $1F ,$50 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$9E ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$9C ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $53 ,$00 ,$00 ,$00 
		db $04 ,$01 ,$00 ,$00
	entityScripts_0a:
		db $07 ,$00 ,$90 ,$00
		db $35 ,$00 ,$00 ,$00
		db $34 ,$00 ,$00 ,$00 
		db $33 ,$12 ,$00 ,$00
		db $36 ,$40 ,$00 ,$00
		db $97 ,$00 ,$00 ,$00
		db $0B ,$08 ,$AC ,$00 
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$EE ,$00
		db $1F ,$08 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
		db $1D ,$04 ,$06 ,$00
	entityScripts_0b:
		db $07 ,$01 ,$14 ,$00 
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00
		db $0B ,$08 ,$5C ,$00 
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$5E ,$00
		db $1F ,$10 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$5C ,$00
		db $1F ,$04 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0D ,$02 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
	entityScripts_0c:
		db $07 ,$00 ,$60 ,$00
		db $58 ,$04 ,$FF ,$FF 
		db $59 ,$00 ,$00 ,$00
		db $57 ,$00 ,$00 ,$00
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$00 ,$00 ,$00
	entityScripts_22:
		db $13 ,$08 ,$20 ,$00
		db $4D ,$20 ,$20 ,$00
	entityScripts_23:
		db $13 ,$08 ,$21 ,$00 
		db $1F ,$2E ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $02 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00 
	entityScripts_20:
		db $13 ,$08 ,$1E ,$00
		db $1F ,$2E ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $02 ,$00 ,$00 ,$00 
		db $27 ,$00 ,$00 ,$00
	entityScripts_0d:
		db $07 ,$01 ,$10 ,$00
		db $73 ,$00 ,$00 ,$00
		db $74 ,$00 ,$00 ,$00 
	entityScripts_03:
	entityScripts_04:
		db $8D ,$00 ,$00 ,$00
		db $4D ,$78 ,$80 ,$00
		db $8C ,$00 ,$00 ,$00
		db $47 ,$00 ,$00 ,$00 
		db $48 ,$00 ,$00 ,$00
		db $49 ,$00 ,$00 ,$00
	entityScripts_0f:
		db $0B ,$08 ,$62 ,$00
		db $1F ,$20 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0F ,$00 ,$00 ,$00
		db $0B ,$08 ,$64 ,$00
		db $44 ,$17 ,$00 ,$00 
		db $0B ,$08 ,$62 ,$00
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $3C ,$01 ,$0A ,$00 
		db $0B ,$08 ,$66 ,$00
		db $3E ,$00 ,$00 ,$00
		db $3D ,$17 ,$00 ,$00
		db $0B ,$08 ,$38 ,$00 
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$3A ,$00
		db $40 ,$00 ,$00 ,$00 
		db $41 ,$00 ,$00 ,$00
		db $3C ,$0D ,$14 ,$00
		db $43 ,$01 ,$80 ,$00
		db $3F ,$00 ,$00 ,$00 
		db $04 ,$00 ,$00 ,$00
		db $1F ,$40 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $42 ,$01 ,$80 ,$00 
		db $0B ,$08 ,$3C ,$00
		db $3F ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
	entityScripts_10:
		db $07 ,$00 ,$80 ,$00 
		db $35 ,$00 ,$00 ,$00
		db $3B ,$00 ,$00 ,$00
		db $6D ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$B4 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $3A ,$08 ,$B6 ,$00 
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $3A ,$08 ,$F0 ,$00
		db $1F ,$10 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $3A ,$08 ,$B4 ,$02
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$00 ,$00 ,$00
	entityScripts_1c:
		db $07 ,$00 ,$60 ,$00
		db $35 ,$00 ,$00 ,$00
		db $3B ,$00 ,$00 ,$00 
		db $6D ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
		db $3A ,$08 ,$F2 ,$00
		db $1F ,$04 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $3A ,$08 ,$F8 ,$00
		db $1F ,$04 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$F4 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $3A ,$08 ,$F2 ,$02 
		db $1F ,$04 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00
	entityScripts_6a:
		db $98 ,$00 ,$00 ,$00 
		db $68 ,$18 ,$2A ,$00
		db $99 ,$00 ,$00 ,$00
		db $0B ,$08 ,$48 ,$00
		db $1F ,$06 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $07 ,$00 ,$70 ,$00
		db $1F ,$90 ,$00 ,$00
		db $2F ,$00 ,$00 ,$00 
		db $05 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00
		db $0B ,$08 ,$4A ,$00
		db $1F ,$18 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0D ,$03 ,$00 ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $98 ,$01 ,$00 ,$00
		db $2A ,$00 ,$00 ,$00
		db $99 ,$01 ,$00 ,$00
		db $6C ,$23 ,$00 ,$00 
		db $27 ,$00 ,$00 ,$00
	entityScripts_14:
		db $09 ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $0B ,$08 ,$46 ,$00 
		db $2A ,$00 ,$00 ,$00
		db $6C ,$22 ,$00 ,$00
		db $63 ,$F9 ,$2C ,$00
		db $64 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$48 ,$00
		db $1F ,$06 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $07 ,$00 ,$70 ,$00 
		db $1F ,$90 ,$00 ,$00
		db $2F ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00 
		db $0B ,$08 ,$4A ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0D ,$03 ,$00 ,$00 
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $07 ,$00 ,$70 ,$00
		db $1F ,$90 ,$00 ,$00 
		db $2F ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00
		db $0B ,$08 ,$4A ,$00 
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0D ,$03 ,$00 ,$00
		db $1F ,$18 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $63 ,$FF ,$20 ,$00
		db $2A ,$00 ,$00 ,$00
		db $64 ,$01 ,$00 ,$00 
		db $6C ,$23 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
		db $9E ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00 
	entityScripts_27:
		db $65 ,$00 ,$00 ,$00
		db $13 ,$12 ,$02 ,$00
		db $1E ,$01 ,$20 ,$00
		db $58 ,$05 ,$00 ,$60 
		db $60 ,$00 ,$00 ,$00
		db $01 ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $62 ,$00 ,$F8 ,$00 
		db $2D ,$00 ,$00 ,$00
		db $0B ,$08 ,$42 ,$00
		db $6C ,$22 ,$00 ,$00
		db $68 ,$18 ,$62 ,$00 
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$4A ,$00
		db $1F ,$10 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0D ,$03 ,$00 ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $62 ,$00 ,$08 ,$00
		db $04 ,$01 ,$00 ,$00
		db $61 ,$01 ,$0A ,$00
	entityScripts_29:
		db $65 ,$00 ,$00 ,$00 
		db $13 ,$12 ,$02 ,$00
		db $1E ,$01 ,$80 ,$00
		db $90 ,$06 ,$00 ,$60
		db $67 ,$00 ,$00 ,$00 
		db $03 ,$00 ,$00 ,$00
		db $01 ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $0B ,$08 ,$46 ,$00 
		db $2A ,$00 ,$00 ,$00
		db $6C ,$22 ,$00 ,$00
		db $63 ,$FA ,$24 ,$00
		db $68 ,$18 ,$2A ,$00 
		db $64 ,$03 ,$2A ,$00
		db $0B ,$08 ,$48 ,$00
		db $1F ,$06 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $07 ,$00 ,$70 ,$00
		db $1F ,$90 ,$00 ,$00
		db $2F ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00 
		db $2D ,$00 ,$00 ,$00
		db $0B ,$08 ,$4A ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0D ,$03 ,$00 ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $07 ,$00 ,$70 ,$00 
		db $1F ,$90 ,$00 ,$00
		db $2F ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00 
		db $0B ,$08 ,$4A ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0D ,$03 ,$00 ,$00 
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $63 ,$FF ,$20 ,$00
		db $2A ,$00 ,$00 ,$00 
		db $64 ,$02 ,$B0 ,$00
		db $6C ,$23 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_28:	
		db $13 ,$12 ,$03 ,$00 
		db $1E ,$00 ,$80 ,$00
		db $1F ,$40 ,$00 ,$00
		db $66 ,$00 ,$00 ,$00
	entityScripts_25:
		db $5F ,$00 ,$00 ,$00 
		db $6C ,$0F ,$00 ,$00
		db $0B ,$12 ,$20 ,$00
		db $1F ,$12 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $53 ,$00 ,$00 ,$00
		db $0B ,$12 ,$22 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $08 ,$01 ,$00 ,$00
		db $13 ,$12 ,$00 ,$00
		db $1E ,$00 ,$60 ,$00
		db $5E ,$00 ,$00 ,$00 
		db $0B ,$12 ,$22 ,$00
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$20 ,$00 
		db $1F ,$08 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_26:
		db $A7 ,$05 ,$00 ,$00 
		db $89 ,$A8 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $6C ,$22 ,$00 ,$00
		db $5B ,$01 ,$00 ,$00 
		db $68 ,$00 ,$67 ,$00
		db $2A ,$00 ,$00 ,$00
		db $0B ,$12 ,$12 ,$00
		db $5C ,$00 ,$00 ,$00 
		db $68 ,$00 ,$67 ,$00
		db $1F ,$06 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$10 ,$00 
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $5B ,$00 ,$00 ,$00 
		db $68 ,$00 ,$67 ,$00
		db $2A ,$00 ,$00 ,$00
		db $0B ,$12 ,$12 ,$00
		db $5C ,$00 ,$00 ,$00 
		db $68 ,$00 ,$67 ,$00
		db $04 ,$0A ,$00 ,$00
		db $0B ,$12 ,$60 ,$00
		db $1F ,$02 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$62 ,$00
		db $1F ,$02 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $0B ,$08 ,$FA ,$00
		db $1F ,$02 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$FC ,$00 
		db $1F ,$02 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$08 ,$FA ,$00
		db $1F ,$02 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$62 ,$00
		db $1F ,$02 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$0A ,$00 ,$00
		db $68 ,$00 ,$67 ,$00
		db $8A ,$00 ,$00 ,$00
		db $A8 ,$C0 ,$00 ,$00 
	entityScripts_1d:
		db $96 ,$00 ,$00 ,$00
		db $50 ,$00 ,$00 ,$00
		db $53 ,$00 ,$00 ,$00
		db $51 ,$00 ,$00 ,$00 
		db $01 ,$00 ,$00 ,$00
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $9A ,$06 ,$00 ,$00 
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $50 ,$01 ,$00 ,$00
		db $51 ,$00 ,$00 ,$00 
		db $22 ,$08 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $08 ,$00 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $04 ,$00 ,$00 ,$00
	entityScripts_16:
		db $13 ,$08 ,$14 ,$00
		db $54 ,$00 ,$00 ,$00
		db $1F ,$3A ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $53 ,$00 ,$00 ,$00
		db $1F ,$20 ,$00 ,$00
		db $07 ,$00 ,$70 ,$00 
		db $2F ,$00 ,$00 ,$00
		db $05 ,$00 ,$00 ,$00
		db $2D ,$00 ,$00 ,$00
		db $97 ,$00 ,$00 ,$00 
		db $0D ,$05 ,$00 ,$00
		db $1F ,$18 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $08 ,$03 ,$00 ,$00 
		db $04 ,$06 ,$00 ,$00
	entityScripts_30:
		db $13 ,$0E ,$00 ,$00
		db $55 ,$01 ,$00 ,$00
		db $A0 ,$00 ,$00 ,$00 
	entityScripts_31:
		db $13 ,$0E ,$02 ,$00
		db $55 ,$01 ,$00 ,$00
		db $00 ,$80 ,$00 ,$00
	entityScripts_32:
		db $4E ,$00 ,$00 ,$00 
		db $55 ,$01 ,$00 ,$00
		db $00 ,$80 ,$00 ,$00
	entityScripts_58:
		db $0B ,$0E ,$14 ,$00
		db $0E ,$00 ,$00 ,$00 
	entityScripts_59:
		db $13 ,$0E ,$03 ,$00
		db $1F ,$38 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $2B ,$00 ,$00 ,$00 
		db $00 ,$80 ,$00 ,$00
	entityScripts_5a:
		db $0B ,$08 ,$60 ,$00
		db $2E ,$00 ,$00 ,$00
	entityScripts_5b:
		db $13 ,$08 ,$16 ,$00 
		db $32 ,$1A ,$00 ,$00
	entityScripts_5c:
		db $13 ,$08 ,$18 ,$00
		db $11 ,$03 ,$00 ,$00
		db $12 ,$00 ,$00 ,$00 
	entityScripts_5d:
		db $13 ,$08 ,$1D ,$00
		db $56 ,$01 ,$00 ,$00
		db $0E ,$00 ,$00 ,$00
	entityScripts_18:
	entityScripts_72:
		db $13 ,$0E ,$04 ,$00 
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
		db $04 ,$00 ,$00 ,$00 
	entityScripts_19:
		db $13 ,$08 ,$19 ,$00
		db $1F ,$10 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00 
	entityScripts_1a:
		db $13 ,$08 ,$1A ,$00
		db $6C ,$27 ,$00 ,$00
		db $1F ,$20 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00 
		db $27 ,$00 ,$00 ,$00
	entityScripts_1b:
		db $30 ,$00 ,$00 ,$00
		db $0B ,$0E ,$46 ,$00
		db $45 ,$30 ,$00 ,$00 
		db $46 ,$00 ,$00 ,$00
	entityScripts_2a:
		db $0B ,$0E ,$1A ,$00
		db $45 ,$20 ,$00 ,$00
		db $46 ,$00 ,$00 ,$00 
	entityScripts_67:
		db $30 ,$02 ,$00 ,$00
	entityScripts_62:
		db $0B ,$0E ,$1A ,$00
		db $45 ,$10 ,$00 ,$00
		db $46 ,$00 ,$00 ,$00 
	entityScripts_5e:
		db $13 ,$08 ,$1F ,$00
		db $1F ,$28 ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $5A ,$08 ,$00 ,$00 
	entityScripts_5f:
		db $13 ,$12 ,$04 ,$00
		db $1F ,$FF ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $0B ,$12 ,$32 ,$00 
		db $1F ,$0A ,$00 ,$00
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_4e:
		db $4F ,$00 ,$00 ,$00 	
		db $39 ,$00 ,$40 ,$00
		db $69 ,$00 ,$01 ,$00
		db $6A ,$00 ,$00 ,$00
		db $38 ,$00 ,$00 ,$00 
		db $27 ,$00 ,$00 ,$00
	entityScripts_33:
	entityScripts_34:
	entityScripts_35:
	entityScripts_36:
	entityScripts_37:
	entityScripts_38:
	entityScripts_39:
	entityScripts_3a:
	entityScripts_3b:
	entityScripts_3c:
	entityScripts_3d:
	entityScripts_3e:
	entityScripts_3f:
	entityScripts_40:
	entityScripts_41:
	entityScripts_42:
	entityScripts_4c:
	entityScripts_4d:
	entityScripts_4f:
	entityScripts_50:
		db $4F ,$00 ,$00 ,$00
		db $39 ,$01 ,$00 ,$00
		db $37 ,$00 ,$00 ,$00 
		db $38 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_43:
	entityScripts_44:
	entityScripts_45:
	entityScripts_46:
	entityScripts_47:
	entityScripts_48:
	entityScripts_49:
	entityScripts_4a:
	entityScripts_4b:
		db $4F ,$00 ,$00 ,$00
		db $39 ,$01 ,$00 ,$00 
		db $37 ,$00 ,$00 ,$00
		db $38 ,$00 ,$00 ,$00
		db $87 ,$00 ,$00 ,$00
		db $1F ,$38 ,$00 ,$00 
		db $20 ,$00 ,$00 ,$00
		db $27 ,$00 ,$00 ,$00
	entityScripts_51:
	entityScripts_52:
	entityScripts_53:
		db $00 ,$00 ,$00 ,$00
	entityScripts_57:

		db $9B ,$00 ,$00 ,$00 
		db $01 ,$00 ,$01 ,$00
		db $00 ,$00 ,$00 ,$00
		db $01 ,$0C ,$71 ,$7C
		db $01 ,$00 ,$01 ,$00 
		db $01 ,$00 ,$01 ,$0C
		db $10 ,$10 ,$01 ,$FC
		db $01 ,$1C ,$01 ,$0C
		db $01 ,$0C ,$01 ,$0C 
		db $01 ,$0C ,$01 ,$00
		

; --------------------------------------

	B23_1100:		
		jmp $b9d0		; 4c d0 b9
	B23_1103:		
		jmp $b888		; 4c 88 b8
	B23_1106:		
		lda wEntityAlarmOrStartYforSinusoidalMovement, x	; bd 06 06
		bne +			; d0 03
	
		jmp $b17c		; 4c 7c b1
	+ 	rts				; 60 


;B23_110f:		lda $81			; a5 81
;B23_1111:		cmp #$01		; c9 01
;B23_1113:		beq B23_1132 ; f0 1d
;
;B23_1115:		jsr $b84c		; 20 4c b8
;B23_1118:		bcs B23_1132 ; b0 18
;
;B23_111a:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_111d:		cmp #$7d		; c9 7d
;B23_111f:		beq B23_114f ; f0 2e
;
;B23_1121:		cmp #$82		; c9 82
;B23_1123:		beq B23_1135 ; f0 10
;
;B23_1125:		sec				; 38 
;B23_1126:		sbc #$79		; e9 79
;B23_1128:		asl a			; 0a
;B23_1129:		tay				; a8 
;B23_112a:		lda $b0dd, y	; b9 dd b0
;B23_112d:		sta $81			; 85 81
;B23_112f:		jmp $b250		; 4c 50 b2
;
;
;B23_1132:		jmp $b25f		; 4c 5f b2
;
;
;B23_1135:		lda wEntityAlarmOrStartYforSinusoidalMovement.w, x	; bd 06 06
;B23_1138:		bne B23_1143 ; d0 09
;
;B23_113a:		lda $0657, x	; bd 57 06
;B23_113d:		beq B23_114c ; f0 0d
;
;B23_113f:		lda #$1c		; a9 1c
;B23_1141:		bne B23_114a ; d0 07
;
;B23_1143:		lda $0657, x	; bd 57 06
;B23_1146:		beq B23_114c ; f0 04
;
;B23_1148:		lda #$0c		; a9 0c
;B23_114a:		sta $81			; 85 81
;B23_114c:		jmp $b250		; 4c 50 b2
;
;
;B23_114f:		lda $0657, x	; bd 57 06
;B23_1152:		beq B23_114c ; f0 f8
;
;B23_1154:		bne B23_1148 ; d0 f2
;
;B23_1156:		lda $0657, x	; bd 57 06
;B23_1159:		jmp $b1bf		; 4c bf b1
;
;
;func_17_115c:
;B23_115c:		cmp #$83		; c9 83
;B23_115e:		bne B23_1163 ; d0 03
;
;B23_1160:		jmp $b22e		; 4c 2e b2
;
;B23_1163:		cmp #$85		; c9 85
;B23_1165:		beq B23_11cf ; f0 68
;
;B23_1167:		cmp #$7a		; c9 7a
;B23_1169:		bne B23_116e ; d0 03
;
;B23_116b:		jmp $b100		; 4c 00 b1
;
;B23_116e:		cmp #$7f		; c9 7f
;B23_1170:		bne B23_1175 ; d0 03
;
;B23_1172:		jmp $b106		; 4c 06 b1
;
;B23_1175:		cmp #$80		; c9 80
;B23_1177:		bne B23_117c ; d0 03
;
;B23_1179:		jmp $b103		; 4c 03 b1
;
;B23_117c:		jsr $b64c		; 20 4c b6
;B23_117f:		bcc B23_1184 ; 90 03
;
;B23_1181:		jmp $b10f		; 4c 0f b1
;
;B23_1184:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_1187:		cmp #$7e		; c9 7e
;B23_1189:		beq B23_119f ; f0 14
;
;B23_118b:		cmp #$84		; c9 84
;B23_118d:		beq B23_119f ; f0 10
;
;B23_118f:		cmp #$86		; c9 86
;B23_1191:		beq B23_119f ; f0 0c
;
;B23_1193:		cmp #$87		; c9 87
;B23_1195:		beq B23_119f ; f0 08
;
;B23_1197:		cmp #$8a		; c9 8a
;B23_1199:		beq B23_119f ; f0 04
;
;B23_119b:		cmp #$88		; c9 88
;B23_119d:		bne B23_11ab ; d0 0c
;
;B23_119f:		ldy $af			; a4 af
;B23_11a1:		beq B23_11ab ; f0 08
;
;B23_11a3:		cpx $b8			; e4 b8
;B23_11a5:		beq B23_1132 ; f0 8b
;
;B23_11a7:		lda #$00		; a9 00
;B23_11a9:		sta $af			; 85 af
;B23_11ab:		cmp #$7d		; c9 7d
;B23_11ad:		beq B23_1156 ; f0 a7
;
;B23_11af:		cmp #$82		; c9 82
;B23_11b1:		beq B23_1156 ; f0 a3
;
;B23_11b3:		cmp #$83		; c9 83
;B23_11b5:		beq B23_11c9 ; f0 12
;
;B23_11b7:		sec				; 38 
;B23_11b8:		sbc #$79		; e9 79
;B23_11ba:		asl a			; 0a
;B23_11bb:		tay				; a8 
;B23_11bc:		lda data_17_10dc.w, y	; b9 dc b0
;B23_11bf:		sta $81			; 85 81
;B23_11c1:		lda #$10		; a9 10
;B23_11c3:		sta $0669, x	; 9d 69 06
;B23_11c6:		jmp $b250		; 4c 50 b2
;
;
;B23_11c9:		lda $0657, x	; bd 57 06
;B23_11cc:		jmp $b1bf		; 4c bf b1
;
;
;B23_11cf:		lda #$00		; a9 00
;B23_11d1:		sta $93			; 85 93
;B23_11d3:		jmp $b8ee		; 4c ee b8
;
;
;B23_11d6:		jsr $b663		; 20 63 b6
;B23_11d9:		bcs B23_11e9 ; b0 0e
;
;B23_11db:		jsr $b809		; 20 09 b8
;B23_11de:		bcc B23_11e3 ; 90 03
;
;B23_11e0:		jmp $b25f		; 4c 5f b2
;
;
;B23_11e3:		lda #$01		; a9 01
;B23_11e5:		sta $81			; 85 81
;B23_11e7:		bne B23_1250 ; d0 67
;
;B23_11e9:		lda $81			; a5 81
;B23_11eb:		cmp #$01		; c9 01
;B23_11ed:		beq B23_125f ; f0 70
;
;B23_11ef:		jsr $b377		; 20 77 b3
;B23_11f2:		bcs B23_125f ; b0 6b
;
;B23_11f4:		lda #$02		; a9 02
;B23_11f6:		sta $81			; 85 81
;B23_11f8:		bne B23_1250 ; d0 56
;
;B23_11fa:		rts				; 60 
;
;
;func_17_11fb:
;B23_11fb:		lda wEntityState.w, x	; bd 70 04
;B23_11fe:		and #$11		; 29 11
;B23_1200:		bne B23_11fa ; d0 f8
;
;B23_1202:		lda wOamSpecIdxDoubled.w, x	; bd 00 04
;B23_1205:		beq B23_11fa ; f0 f3
;
;B23_1207:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_120a:		cmp #$1c		; c9 1c
;B23_120c:		beq B23_11fa ; f0 ec
;
;B23_120e:		cmp #$93		; c9 93
;B23_1210:		bcs B23_11fa ; b0 e8
;
;B23_1212:		cmp #$90		; c9 90
;B23_1214:		bcs B23_125f ; b0 49
;
;B23_1216:		cmp #$68		; c9 68
;B23_1218:		bcc B23_121e ; 90 04
;
;B23_121a:		cmp #$71		; c9 71
;B23_121c:		bcc B23_11fa ; 90 dc
;
;B23_121e:		lda $81			; a5 81
;B23_1220:		and #$f0		; 29 f0
;B23_1222:		bne B23_125f ; d0 3b
;
;B23_1224:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_1227:		cmp #$79		; c9 79
;B23_1229:		bcc B23_122e ; 90 03
;
;B23_122b:		jmp func_17_115c		; 4c 5c b1
;
;B23_122e:		lda wEntityState.w, x	; bd 70 04
;B23_1231:		and #$02		; 29 02
;B23_1233:		bne B23_11d6 ; d0 a1
;
;B23_1235:		lda $80			; a5 80
;B23_1237:		bne B23_125f ; d0 26
;
;B23_1239:		jsr $b377		; 20 77 b3
;B23_123c:		bcs B23_125f ; b0 21
;
;B23_123e:		lda $0657, x	; bd 57 06
;B23_1241:		sta $81			; 85 81
;B23_1243:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_1246:		cmp #$49		; c9 49
;B23_1248:		bne B23_1250 ; d0 06
;
;B23_124a:		jsr clearEntityHorizVertSpeeds		; 20 c8 fe
;B23_124d:		jsr $b581		; 20 81 b5
;B23_1250:		stx $91			; 86 91
;B23_1252:		ldy #$00		; a0 00
;B23_1254:		lda wEntityBaseX.w, x	; bd 38 04
;B23_1257:		cmp wEntityBaseX.w		; cd 38 04
;B23_125a:		bcs B23_125d ; b0 01
;
;B23_125c:		iny				; c8 
;B23_125d:		sty $90			; 84 90
;B23_125f:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_1262:		cmp #$16		; c9 16
;B23_1264:		beq B23_11fa ; f0 94
;
;B23_1266:		cmp #$47		; c9 47
;B23_1268:		beq B23_11fa ; f0 90
;
;B23_126a:		cmp #$71		; c9 71
;B23_126c:		bcc B23_1272 ; 90 04
;
;B23_126e:		cmp #$90		; c9 90
;B23_1270:		bcc B23_11fa ; 90 88
;
;B23_1272:		lda $068d, x	; bd 8d 06
;B23_1275:		and #$01		; 29 01
;B23_1277:		bne B23_12a0 ; d0 27
;
;B23_1279:		lda $0630		; ad 30 06
;B23_127c:		beq B23_12a0 ; f0 22
;
;B23_127e:		lda $0413		; ad 13 04
;B23_1281:		beq B23_12a0 ; f0 1d
;
;B23_1283:		jsr $b42a		; 20 2a b4
;B23_1286:		bcs B23_12a0 ; b0 18
;
;B23_1288:		lda $068d, x	; bd 8d 06
;B23_128b:		ora #$01		; 09 01
;B23_128d:		sta $068d, x	; 9d 8d 06
;B23_1290:		lda $0630		; ad 30 06
;B23_1293:		jsr $b30b		; 20 0b b3
;B23_1296:		lda #$00		; a9 00
;B23_1298:		sta $9e			; 85 9e
;B23_129a:		jsr $b601		; 20 01 b6
;B23_129d:		jsr $b4c4		; 20 c4 b4
;B23_12a0:		lda #$14		; a9 14
;B23_12a2:		sta $9e			; 85 9e
;B23_12a4:		ldy $9e			; a4 9e
;B23_12a6:		lda wEntityObjectIdxes.w, y	; b9 4e 05
;B23_12a9:		beq B23_12f5 ; f0 4a
;
;B23_12ab:		jsr $b301		; 20 01 b3
;B23_12ae:		and $b2fe, y	; 39 fe b2
;B23_12b1:		bne B23_12f5 ; d0 42
;
;B23_12b3:		jsr $b485		; 20 85 b4
;B23_12b6:		bcs B23_12f5 ; b0 3d
;
;B23_12b8:		jsr $b759		; 20 59 b7
;B23_12bb:		jsr $b301		; 20 01 b3
;B23_12be:		ora $b2fe, y	; 19 fe b2
;B23_12c1:		sta $068d, x	; 9d 8d 06
;B23_12c4:		ldy $9e			; a4 9e
;B23_12c6:		lda wEntityAlarmOrStartYforSinusoidalMovement.w, y	; b9 06 06
;B23_12c9:		and #$f0		; 29 f0
;B23_12cb:		jsr $b30b		; 20 0b b3
;B23_12ce:		and #$f0		; 29 f0
;B23_12d0:		sta $13			; 85 13
;B23_12d2:		lda wEntityAlarmOrStartYforSinusoidalMovement.w, y	; b9 06 06
;B23_12d5:		and #$0f		; 29 0f
;B23_12d7:		ora $13			; 05 13
;B23_12d9:		sta $0669, x	; 9d 69 06
;B23_12dc:		jsr $b33a		; 20 3a b3
;B23_12df:		jsr $b31a		; 20 1a b3
;B23_12e2:		lda wEntityObjectIdxes.w, y	; b9 4e 05
;B23_12e5:		cmp #$06		; c9 06
;B23_12e7:		bne B23_12ef ; d0 06
;
;B23_12e9:		jsr $b6e6		; 20 e6 b6
;B23_12ec:		jmp $b2f5		; 4c f5 b2
;
;B23_12ef:		jsr $b5dd		; 20 dd b5
;B23_12f2:		jsr $b4c4		; 20 c4 b4
;B23_12f5:		inc $9e			; e6 9e
;B23_12f7:		lda $9e			; a5 9e
;B23_12f9:		cmp #$17		; c9 17
;B23_12fb:		bcc B23_12a4 ; 90 a7
;
;B23_12fd:		rts				; 60 
;
;
;;
;B23_12fe:	.db $02
;B23_12ff:	.db $04
;B23_1300:		php				; 08 
;B23_1301:		sec				; 38 
;B23_1302:		lda $9e			; a5 9e
;B23_1304:		sbc #$14		; e9 14
;B23_1306:		tay				; a8 
;B23_1307:		lda $068d, x	; bd 8d 06
;B23_130a:		rts				; 60 
;
;
;B23_130b:		clc				; 18 
;B23_130c:		adc $0669, x	; 7d 69 06
;B23_130f:		bcc B23_1316 ; 90 05
;
;B23_1311:		lda $0669, x	; bd 69 06
;B23_1314:		ora #$f0		; 09 f0
;B23_1316:		sta $0669, x	; 9d 69 06
;B23_1319:		rts				; 60 
;
;
;B23_131a:		and #$0f		; 29 0f
;B23_131c:		cmp #$03		; c9 03
;B23_131e:		bne B23_1339 ; d0 19
;
;B23_1320:		lda wEntityObjectIdxes.w, y	; b9 4e 05
;B23_1323:		cmp #$02		; c9 02
;B23_1325:		bne B23_1339 ; d0 12
;
;B23_1327:		lda $0669, y	; b9 69 06
;B23_132a:		ora #$03		; 09 03
;B23_132c:		sta $0669, y	; 99 69 06
;B23_132f:		lda $0669, x	; bd 69 06
;B23_1332:		and #$f0		; 29 f0
;B23_1334:		ora #$03		; 09 03
;B23_1336:		sta $0669, x	; 9d 69 06
;B23_1339:		rts				; 60 
;
;
;B23_133a:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_133d:		cmp #$67		; c9 67
;B23_133f:		beq B23_1358 ; f0 17
;
;B23_1341:		cmp #$1b		; c9 1b
;B23_1343:		bcc B23_1351 ; 90 0c
;
;B23_1345:		cmp #$1f		; c9 1f
;B23_1347:		bcs B23_1351 ; b0 08
;
;B23_1349:		cmp #$1c		; c9 1c
;B23_134b:		beq B23_1351 ; f0 04
;
;B23_134d:		lda #$00		; a9 00
;B23_134f:		beq B23_1354 ; f0 03
;
;B23_1351:		lda $0657, x	; bd 57 06
;B23_1354:		sta $061d, y	; 99 1d 06
;B23_1357:		rts				; 60 
;
;
;B23_1358:		lda wEntityFacingLeft.w, x	; bd a8 04
;B23_135b:		bne B23_1367 ; d0 0a
;
;B23_135d:		lda wEntityBaseX.w, x	; bd 38 04
;B23_1360:		cmp wEntityBaseX.w, y	; d9 38 04
;B23_1363:		bcc B23_1351 ; 90 ec
;
;B23_1365:		bcs B23_136f ; b0 08
;
;B23_1367:		lda wEntityBaseX.w, x	; bd 38 04
;B23_136a:		cmp wEntityBaseX.w, y	; d9 38 04
;B23_136d:		bcs B23_1351 ; b0 e2
;
;B23_136f:		lda $0657, x	; bd 57 06
;B23_1372:		and #$f0		; 29 f0
;B23_1374:		jmp $b354		; 4c 54 b3
;
;
;B23_1377:		ldy $82			; a4 82
;B23_1379:		lda $bb43, y	; b9 43 bb
;B23_137c:		sta $00			; 85 00
;B23_137e:		lda $bb4c, y	; b9 4c bb
;B23_1381:		sta $01			; 85 01
;B23_1383:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1386:		lda wEntityOamSpecGroupDoubled.w, x	; bd 8c 04
;B23_1389:		cmp #$08		; c9 08
;B23_138b:		bne B23_1394 ; d0 07
;
;B23_138d:		lda wOamSpecIdxDoubled.w, x	; bd 00 04
;B23_1390:		cmp #$ee		; c9 ee
;B23_1392:		;removed
;	.db $b0 $40
;
;B23_1394:		lda $ba			; a5 ba
;B23_1396:		beq B23_13a0 ; f0 08
;
;B23_1398:		jsr $e611		; 20 11 e6
;B23_139b:		bcc B23_13a0 ; 90 03
;
;B23_139d:		jmp $b763		; 4c 63 b7
;
;
;B23_13a0:		clc				; 18 
;B23_13a1:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_13a4:		lda $bbc8, y	; b9 c8 bb
;B23_13a7:		adc $00			; 65 00
;B23_13a9:		sta $02			; 85 02
;B23_13ab:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_13ae:		cmp $02			; c5 02
;B23_13b0:		bcs B23_13d1 ; b0 1f
;
;B23_13b2:		clc				; 18 
;B23_13b3:		lda $bc60, y	; b9 60 bc
;B23_13b6:		adc $01			; 65 01
;B23_13b8:		sta $03			; 85 03
;B23_13ba:		ldy #$00		; a0 00
;B23_13bc:		lda $82			; a5 82
;B23_13be:		cmp #$04		; c9 04
;B23_13c0:		bcc B23_13c3 ; 90 01
;
;B23_13c2:		iny				; c8 
;B23_13c3:		clc				; 18 
;B23_13c4:		lda $b3d2, y	; b9 d2 b3
;B23_13c7:		adc wEntityBaseY.w		; 6d 1c 04
;B23_13ca:		sta $11			; 85 11
;B23_13cc:		jsr $80c1		; 20 c1 80
;B23_13cf:		cmp $03			; c5 03
;B23_13d1:		rts				; 60 
;
;

;B23_13d2:		.db $00				; 00
;B23_13d3:		ora $38			; 05 38
;B23_13d5:		sbc #$ee		; e9 ee
;B23_13d7:		pha				; 48 
;B23_13d8:		clc				; 18 
;B23_13d9:		adc wEntityFacingLeft.w, x	; 7d a8 04
;B23_13dc:		sta $07			; 85 07
;B23_13de:		pla				; 68 
;B23_13df:		lsr a			; 4a
;B23_13e0:		sta $06			; 85 06
;B23_13e2:		tay				; a8 
;B23_13e3:		clc				; 18 
;B23_13e4:		lda $bb72, y	; b9 72 bb
;B23_13e7:		adc $00			; 65 00
;B23_13e9:		sta $02			; 85 02
;B23_13eb:		ldy $07			; a4 07
;B23_13ed:		lda $bb84, y	; b9 84 bb
;B23_13f0:		clc				; 18 
;B23_13f1:		adc wEntityBaseX.w, x	; 7d 38 04
;B23_13f4:		sta $10			; 85 10
;B23_13f6:		jsr $b745		; 20 45 b7
;B23_13f9:		cmp $02			; c5 02
;B23_13fb:		bcs B23_13d1 ; b0 d4
;
;B23_13fd:		ldy $06			; a4 06
;B23_13ff:		clc				; 18 
;B23_1400:		lda $bb7b, y	; b9 7b bb
;B23_1403:		adc $01			; 65 01
;B23_1405:		sta $03			; 85 03
;B23_1407:		ldy $07			; a4 07
;B23_1409:		lda $bb96, y	; b9 96 bb
;B23_140c:		clc				; 18 
;B23_140d:		adc wEntityBaseY.w, x	; 7d 1c 04
;B23_1410:		sta $10			; 85 10
;B23_1412:		ldy #$00		; a0 00
;B23_1414:		lda $82			; a5 82
;B23_1416:		cmp #$04		; c9 04
;B23_1418:		bcc B23_141b ; 90 01
;
;B23_141a:		iny				; c8 
;B23_141b:		clc				; 18 
;B23_141c:		lda $b3d2, y	; b9 d2 b3
;B23_141f:		adc wEntityBaseY.w		; 6d 1c 04
;B23_1422:		sta $11			; 85 11
;B23_1424:		jsr $b739		; 20 39 b7
;B23_1427:		cmp $03			; c5 03
;B23_1429:		rts				; 60 
;
;
;B23_142a:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_142d:		cmp #$80		; c9 80
;B23_142f:		bcs B23_1484 ; b0 53
;
;B23_1431:		ldy $0561		; ac 61 05
;B23_1434:		lda $bb55, y	; b9 55 bb
;B23_1437:		sta $00			; 85 00
;B23_1439:		lda $bb5a, y	; b9 5a bb
;B23_143c:		sta $01			; 85 01
;B23_143e:		clc				; 18 
;B23_143f:		tya				; 98 
;B23_1440:		asl a			; 0a
;B23_1441:		adc wEntityFacingLeft.w		; 6d a8 04
;B23_1444:		tay				; a8 
;B23_1445:		clc				; 18 
;B23_1446:		lda $bb5f, y	; b9 5f bb
;B23_1449:		adc wEntityBaseX.w		; 6d 38 04
;B23_144c:		sta $10			; 85 10
;B23_144e:		clc				; 18 
;B23_144f:		ldy $82			; a4 82
;B23_1451:		lda $042f		; ad 2f 04
;B23_1454:		adc $bb69, y	; 79 69 bb
;B23_1457:		sta $11			; 85 11
;B23_1459:		lda $ba			; a5 ba
;B23_145b:		beq B23_1465 ; f0 08
;
;B23_145d:		jsr $e611		; 20 11 e6
;B23_1460:		bcc B23_1465 ; 90 03
;
;B23_1462:		jmp $b78d		; 4c 8d b7
;
;
;B23_1465:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1468:		clc				; 18 
;B23_1469:		lda $bbc8, y	; b9 c8 bb
;B23_146c:		adc $00			; 65 00
;B23_146e:		sta $02			; 85 02
;B23_1470:		jsr $80cb		; 20 cb 80
;B23_1473:		cmp $02			; c5 02
;B23_1475:		bcs B23_1484 ; b0 0d
;
;B23_1477:		clc				; 18 
;B23_1478:		lda $bc60, y	; b9 60 bc
;B23_147b:		adc $01			; 65 01
;B23_147d:		sta $03			; 85 03
;B23_147f:		jsr $80c1		; 20 c1 80
;B23_1482:		cmp $03			; c5 03
;B23_1484:		rts				; 60 
;
;
;B23_1485:		ldy $9e			; a4 9e
;B23_1487:		lda wEntityObjectIdxes.w, y	; b9 4e 05
;B23_148a:		cmp #$05		; c9 05
;B23_148c:		beq B23_14aa ; f0 1c
;
;B23_148e:		tay				; a8 
;B23_148f:		lda $bba8, y	; b9 a8 bb
;B23_1492:		sta $00			; 85 00
;B23_1494:		lda $bbb3, y	; b9 b3 bb
;B23_1497:		sta $01			; 85 01
;B23_1499:		ldx $9e			; a6 9e
;B23_149b:		lda wEntityBaseX.w, x	; bd 38 04
;B23_149e:		sta $10			; 85 10
;B23_14a0:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_14a3:		sta $11			; 85 11
;B23_14a5:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_14a7:		jmp $b459		; 4c 59 b4
;
;
;B23_14aa:		ldy wEntityOamSpecIdxBaseOffset.w, x	; bc 93 05
;B23_14ad:		lda $bbbe, y	; b9 be bb
;B23_14b0:		sta $00			; 85 00
;B23_14b2:		lda #$08		; a9 08
;B23_14b4:		sta $01			; 85 01
;B23_14b6:		jmp $b497		; 4c 97 b4
;
;
;B23_14b9:		cmp #$90		; c9 90
;B23_14bb:		bcc B23_151d ; 90 60
;
;B23_14bd:		cmp #$93		; c9 93
;B23_14bf:		bcs B23_151d ; b0 5c
;
;B23_14c1:		jmp $a2e2		; 4c e2 a2
;
;
;B23_14c4:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_14c7:		cmp #$40		; c9 40
;B23_14c9:		bcc B23_151d ; 90 52
;
;B23_14cb:		cmp #$68		; c9 68
;B23_14cd:		bcs B23_14b9 ; b0 ea
;
;B23_14cf:		lda wEntityState.w, x	; bd 70 04
;B23_14d2:		and #$02		; 29 02
;B23_14d4:		bne B23_1529 ; d0 53
;
;B23_14d6:		lda wEntityAI_idx.w, x	; bd ef 05
;B23_14d9:		cmp #$2d		; c9 2d
;B23_14db:		beq B23_151e ; f0 41
;
;B23_14dd:		cmp #$2e		; c9 2e
;B23_14df:		beq B23_151e ; f0 3d
;
;B23_14e1:		lda $0669, x	; bd 69 06
;B23_14e4:		sta $00			; 85 00
;B23_14e6:		and #$f0		; 29 f0
;B23_14e8:		beq B23_151d ; f0 33
;
;B23_14ea:		lsr a			; 4a
;B23_14eb:		lsr a			; 4a
;B23_14ec:		lsr a			; 4a
;B23_14ed:		lsr a			; 4a
;B23_14ee:		sta $01			; 85 01
;B23_14f0:		lda $0669, x	; bd 69 06
;B23_14f3:		and #$0f		; 29 0f
;B23_14f5:		sta $0669, x	; 9d 69 06
;B23_14f8:		sec				; 38 
;B23_14f9:		lda $067b, x	; bd 7b 06
;B23_14fc:		sbc $01			; e5 01
;B23_14fe:		sta $067b, x	; 9d 7b 06
;B23_1501:		beq B23_153e ; f0 3b
;
;B23_1503:		bmi B23_153e ; 30 39
;
;B23_1505:		lda #$29		; a9 29
;B23_1507:		jsr playSound		; 20 5f e2
;B23_150a:		ldy #$00		; a0 00
;B23_150c:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_150f:		cmp #$64		; c9 64
;B23_1511:		bne B23_1514 ; d0 01
;
;B23_1513:		iny				; c8 
;B23_1514:		lda wPlayerStateDoubled.w, x	; bd 65 05
;B23_1517:		ora $b527, y	; 19 27 b5
;B23_151a:		sta wPlayerStateDoubled.w, x	; 9d 65 05
;B23_151d:		rts				; 60 
;
;
;B23_151e:		lda #$28		; a9 28
;B23_1520:		jsr playSound		; 20 5f e2
;B23_1523:		ldy #$00		; a0 00
;B23_1525:		beq B23_1514 ; f0 ed
;
;B23_1527:		bpl B23_153d ; 10 14
;
;B23_1529:		jsr $e7cc		; 20 cc e7
;B23_152c:		jmp $ff7a		; 4c 7a ff
;
;
;B23_152f:		lda #$00		; a9 00
;B23_1531:		sta wEntityPhase.w, x	; 9d c1 05
;B23_1534:		sta wOamSpecIdxDoubled.w, x	; 9d 00 04
;B23_1537:		sta wEntityOamSpecGroupDoubled.w, x	; 9d 8c 04
;B23_153a:		sta $0657, x	; 9d 57 06
;B23_153d:		rts				; 60 
;
;
;B23_153e:		lda #$27		; a9 27
;B23_1540:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1543:		cpy #$4d		; c0 4d
;B23_1545:		beq B23_1555 ; f0 0e
;
;B23_1547:		cpy #$4e		; c0 4e
;B23_1549:		beq B23_1555 ; f0 0a
;
;B23_154b:		cpy #$5b		; c0 5b
;B23_154d:		beq B23_1555 ; f0 06
;
;B23_154f:		cpy #$57		; c0 57
;B23_1551:		beq B23_1555 ; f0 02
;
;B23_1553:		lda #$33		; a9 33
;B23_1555:		jsr playSound		; 20 5f e2
;B23_1558:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_155b:		cmp #$5b		; c9 5b
;B23_155d:		beq B23_1596 ; f0 37
;
;B23_155f:		cmp #$57		; c9 57
;B23_1561:		beq B23_15b7 ; f0 54
;
;B23_1563:		cmp #$59		; c9 59
;B23_1565:		beq B23_1581 ; f0 1a
;
;B23_1567:		cmp #$5d		; c9 5d
;B23_1569:		beq B23_15bc ; f0 51
;
;B23_156b:		cmp #$48		; c9 48
;B23_156d:		bcc B23_1581 ; 90 12
;
;B23_156f:		jsr $e7cc		; 20 cc e7
;B23_1572:		lda $9e			; a5 9e
;B23_1574:		beq B23_157b ; f0 05
;
;B23_1576:		jsr $e7dc		; 20 dc e7
;B23_1579:		bcs B23_1593 ; b0 18
;
;B23_157b:		lda wGameStateLoopCounter			; a5 1a
;B23_157d:		and #$07		; 29 07
;B23_157f:		beq B23_159c ; f0 1b
;
;B23_1581:		jsr $e7c1		; 20 c1 e7
;B23_1584:		lda #$00		; a9 00
;B23_1586:		sta $0657, x	; 9d 57 06
;B23_1589:		sta wEntityState.w, x	; 9d 70 04
;B23_158c:		sta wEntityPhase.w, x	; 9d c1 05
;B23_158f:		sta wOamSpecIdxDoubled.w, x	; 9d 00 04
;B23_1592:		rts				; 60 
;
;
;B23_1593:		jmp processItemGotten		; 4c fc a0
;
;
;B23_1596:		lda #$05		; a9 05
;B23_1598:		sta wEntityPhase.w, x	; 9d c1 05
;B23_159b:		rts				; 60 
;
;
;B23_159c:		inc $ce			; e6 ce
;B23_159e:		lda $ce			; a5 ce
;B23_15a0:		cmp #$05		; c9 05
;B23_15a2:		bcs B23_15a7 ; b0 03
;
;B23_15a4:		jmp $b5ce		; 4c ce b5
;
;
;B23_15a7:		lda #$00		; a9 00
;B23_15a9:		sta $ce			; 85 ce
;B23_15ab:		jsr $e7ab		; 20 ab e7
;B23_15ae:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_15b1:		jsr $a30b		; 20 0b a3
;B23_15b4:		jmp $b5d1		; 4c d1 b5
;
;
;B23_15b7:		lda #$0f		; a9 0f
;B23_15b9:		jmp $b598		; 4c 98 b5
;
;
;B23_15bc:		lda $061d, x	; bd 1d 06
;B23_15bf:		tax				; aa 
;B23_15c0:		jsr $b584		; 20 84 b5
;B23_15c3:		sta wEntityObjectIdxes.w, x	; 9d 4e 05
;B23_15c6:		sta wEntityAI_idx.w, x	; 9d ef 05
;B23_15c9:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_15cb:		jmp $b56f		; 4c 6f b5
;
;
;B23_15ce:		jsr $a278		; 20 78 a2
;B23_15d1:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_15d4:		sec				; 38 
;B23_15d5:		sbc #$60		; e9 60
;B23_15d7:		sta wEntityAI_idx.w, x	; 9d ef 05
;B23_15da:		jmp $b584		; 4c 84 b5
;
;
;B23_15dd:		jsr $b637		; 20 37 b6
;B23_15e0:		bne B23_1634 ; d0 52
;
;B23_15e2:		lda #$04		; a9 04
;B23_15e4:		sta $00			; 85 00
;B23_15e6:		ldy $9e			; a4 9e
;B23_15e8:		lda wEntityHorizSpeed.w, y	; b9 f2 04
;B23_15eb:		bpl B23_15f1 ; 10 04
;
;B23_15ed:		lda #$fc		; a9 fc
;B23_15ef:		sta $00			; 85 00
;B23_15f1:		clc				; 18 
;B23_15f2:		lda $00			; a5 00
;B23_15f4:		adc wEntityBaseX.w, y	; 79 38 04
;B23_15f7:		sta $00			; 85 00
;B23_15f9:		lda wEntityBaseY.w, y	; b9 1c 04
;B23_15fc:		sta $01			; 85 01
;B23_15fe:		jmp $b613		; 4c 13 b6
;
;
;B23_1601:		jsr $b637		; 20 37 b6
;B23_1604:		bne B23_1634 ; d0 2e
;
;B23_1606:		clc				; 18 
;B23_1607:		lda $042f		; ad 2f 04
;B23_160a:		adc #$01		; 69 01
;B23_160c:		sta $01			; 85 01
;B23_160e:		lda wEntityBaseX.w, x	; bd 38 04
;B23_1611:		sta $00			; 85 00
;B23_1613:		ldx #$17		; a2 17
;B23_1615:		lda #$20		; a9 20
;B23_1617:		sta wEntityState.w, x	; 9d 70 04
;B23_161a:		lda #$12		; a9 12
;B23_161c:		sta wOamSpecIdxDoubled.w, x	; 9d 00 04
;B23_161f:		lda #$0e		; a9 0e
;B23_1621:		sta wEntityOamSpecGroupDoubled.w, x	; 9d 8c 04
;B23_1624:		lda $00			; a5 00
;B23_1626:		sta wEntityBaseX.w, x	; 9d 38 04
;B23_1629:		lda $01			; a5 01
;B23_162b:		sta wEntityBaseY.w, x	; 9d 1c 04
;B23_162e:		lda #$08		; a9 08
;B23_1630:		sta $8c			; 85 8c
;B23_1632:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_1634:		rts				; 60 
;
;
;B23_1635:		sec				; 38 
;B23_1636:		rts				; 60 
;
;
;B23_1637:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_163a:		cmp #$1b		; c9 1b
;B23_163c:		beq B23_1649 ; f0 0b
;
;B23_163e:		cmp #$1c		; c9 1c
;B23_1640:		beq B23_1649 ; f0 07
;
;B23_1642:		ldy #$17		; a0 17
;B23_1644:		lda wOamSpecIdxDoubled.w, y	; b9 00 04
;B23_1647:		beq B23_164b ; f0 02
;
;B23_1649:		lda #$01		; a9 01
;B23_164b:		rts				; 60 
;
;
;B23_164c:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_164f:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_1652:		sta $0e			; 85 0e
;B23_1654:		lda $bbc8, y	; b9 c8 bb
;B23_1657:		ldy $82			; a4 82
;B23_1659:		clc				; 18 
;B23_165a:		adc $bb43, y	; 79 43 bb
;B23_165d:		cmp $0e			; c5 0e
;B23_165f:		bcc B23_1635 ; 90 d4
;
;B23_1661:		bcs B23_166e ; b0 0b
;
;B23_1663:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1666:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_1669:		cmp $bbc8, y	; d9 c8 bb
;B23_166c:		bcs B23_168a ; b0 1c
;
;B23_166e:		ldy $82			; a4 82
;B23_1670:		lda $b68b, y	; b9 8b b6
;B23_1673:		clc				; 18 
;B23_1674:		adc wEntityBaseY.w		; 6d 1c 04
;B23_1677:		sta $10			; 85 10
;B23_1679:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_167c:		sec				; 38 
;B23_167d:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_1680:		sbc $bc60, y	; f9 60 bc
;B23_1683:		sta $11			; 85 11
;B23_1685:		jsr $b739		; 20 39 b7
;B23_1688:		cmp #$0c		; c9 0c
;B23_168a:		rts				; 60 
;
;
;B23_168b:		;removed
;	.db $10 $10
;
;B23_168d:	.db $0c
;B23_168e:		;removed
;	.db $10 $10
;
;B23_1690:		bpl B23_169e ; 10 0c
;
;B23_1692:		bpl B23_1698 ; 10 04
;
;B23_1694:		sec				; 38 
;B23_1695:		lda wOamSpecIdxDoubled.w, x	; bd 00 04
;B23_1698:		sbc #$08		; e9 08
;B23_169a:		lsr a			; 4a
;B23_169b:		tay				; a8 
;B23_169c:		sta $16			; 85 16
;B23_169e:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_16a1:		cmp $b6c8, y	; d9 c8 b6
;B23_16a4:		bcs B23_16c7 ; b0 21
;
;B23_16a6:		sta $17			; 85 17
;B23_16a8:		clc				; 18 
;B23_16a9:		ldy $82			; a4 82
;B23_16ab:		lda $b6da, y	; b9 da b6
;B23_16ae:		adc wEntityBaseY.w		; 6d 1c 04
;B23_16b1:		sta $10			; 85 10
;B23_16b3:		sec				; 38 
;B23_16b4:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_16b7:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_16ba:		sbc $bc60, y	; f9 60 bc
;B23_16bd:		sta $11			; 85 11
;B23_16bf:		jsr $b739		; 20 39 b7
;B23_16c2:		ldy $16			; a4 16
;B23_16c4:		cmp $b6d1, y	; d9 d1 b6
;B23_16c7:		rts				; 60 
;
;
;B23_16c8:		asl a			; 0a
;B23_16c9:		asl a			; 0a
;B23_16ca:		asl a			; 0a
;B23_16cb:		asl a			; 0a
;B23_16cc:		asl a			; 0a
;B23_16cd:		asl a			; 0a
;B23_16ce:		asl a			; 0a
;B23_16cf:		asl a			; 0a
;B23_16d0:		asl a			; 0a
;B23_16d1:	.db $04
;B23_16d2:	.db $04
;B23_16d3:	.db $04
;B23_16d4:	.db $04
;B23_16d5:	.db $04
;B23_16d6:	.db $04
;B23_16d7:	.db $04
;B23_16d8:	.db $04
;B23_16d9:	.db $04
;B23_16da:		;removed
;	.db $10 $10
;
;B23_16dc:		php				; 08 
;B23_16dd:		;removed
;	.db $10 $08
;
;B23_16df:		php				; 08 
;B23_16e0:		php				; 08 
;B23_16e1:		php				; 08 
;B23_16e2:		php				; 08 
;B23_16e3:		php				; 08 
;B23_16e4:		php				; 08 
;B23_16e5:		php				; 08 
;B23_16e6:		lda wEntityObjectIdxes.w, x	; bd 4e 05
;B23_16e9:		cmp #$40		; c9 40
;B23_16eb:		bcc B23_1710 ; 90 23
;
;B23_16ed:		cmp #$68		; c9 68
;B23_16ef:		bcs B23_1710 ; b0 1f
;
;B23_16f1:		cmp #$59		; c9 59
;B23_16f3:		beq B23_1711 ; f0 1c
;
;B23_16f5:		cmp #$5d		; c9 5d
;B23_16f7:		beq B23_1725 ; f0 2c
;
;B23_16f9:		lda wEntityState.w, x	; bd 70 04
;B23_16fc:		and #$02		; 29 02
;B23_16fe:		bne B23_1710 ; d0 10
;
;B23_1700:		lda wEntityState.w, x	; bd 70 04
;B23_1703:		ora #$02		; 09 02
;B23_1705:		sta wEntityState.w, x	; 9d 70 04
;B23_1708:		lda wPlayerStateDoubled.w, x	; bd 65 05
;B23_170b:		and #$3f		; 29 3f
;B23_170d:		sta wPlayerStateDoubled.w, x	; 9d 65 05
;B23_1710:		rts				; 60 
;
;
;B23_1711:		ldx #$01		; a2 01
;B23_1713:		lda wEntityState.w, x	; bd 70 04
;B23_1716:		and #$02		; 29 02
;B23_1718:		bne B23_171d ; d0 03
;
;B23_171a:		jsr $b700		; 20 00 b7
;B23_171d:		inx				; e8 
;B23_171e:		cpx #$09		; e0 09
;B23_1720:		bcc B23_1713 ; 90 f1
;
;B23_1722:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_1724:		rts				; 60 
;
;
;B23_1725:		lda wEntityState.w, x	; bd 70 04
;B23_1728:		and #$02		; 29 02
;B23_172a:		bne B23_1710 ; d0 e4
;
;B23_172c:		jsr $b700		; 20 00 b7
;B23_172f:		lda $061d, x	; bd 1d 06
;B23_1732:		tax				; aa 
;B23_1733:		jsr $b700		; 20 00 b7
;B23_1736:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_1738:		rts				; 60 
;
;
;B23_1739:		sec				; 38 
;B23_173a:		lda $11			; a5 11
;B23_173c:		sbc $10			; e5 10
;B23_173e:		bcs B23_1744 ; b0 04
;
;B23_1740:		eor #$ff		; 49 ff
;B23_1742:		adc #$01		; 69 01
;B23_1744:		rts				; 60 
;
;
;B23_1745:		sec				; 38 
;B23_1746:		lda $10			; a5 10
;B23_1748:		sbc wEntityBaseX.w		; ed38 04
;B23_174b:		bcs B23_1744 ; b0 f7
;
;B23_174d:		bcc B23_1740 ; 90 f1
;
;B23_174f:		sec				; 38 
;B23_1750:		lda $10			; a5 10
;B23_1752:		sbc wEntityBaseY.w		; ed1c 04
;B23_1755:		bcs B23_1744 ; b0 ed
;
;B23_1757:		bcc B23_1740 ; 90 e7
;
;B23_1759:		lda wCurrPlayer.w		; ad 4e 05
;B23_175c:		and #$01		; 29 01
;B23_175e:		bne B23_1762 ; d0 02
;
;B23_1760:		inc $9c			; e6 9c
;B23_1762:		rts				; 60 
;
;
;B23_1763:		sec				; 38 
;B23_1764:		lda wEntityBaseX.w, x	; bd 38 04
;B23_1767:		sbc $0c			; e5 0c
;B23_1769:		jsr $80b6		; 20 b6 80
;B23_176c:		cmp $02			; c5 02
;B23_176e:		bcs B23_17a5 ; b0 35
;
;B23_1770:		ldy #$00		; a0 00
;B23_1772:		lda $82			; a5 82
;B23_1774:		cmp #$04		; c9 04
;B23_1776:		bcc B23_1779 ; 90 01
;
;B23_1778:		iny				; c8 
;B23_1779:		lda $b3d2, y	; b9 d2 b3
;B23_177c:		adc wEntityBaseY.w		; 6d 1c 04
;B23_177f:		sta $11			; 85 11
;B23_1781:		sec				; 38 
;B23_1782:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_1785:		sbc $0d			; e5 0d
;B23_1787:		jsr $80c4		; 20 c4 80
;B23_178a:		cmp $03			; c5 03
;B23_178c:		rts				; 60 
;
;
;B23_178d:		sec				; 38 
;B23_178e:		lda wEntityBaseX.w, x	; bd 38 04
;B23_1791:		sbc $0c			; e5 0c
;B23_1793:		jsr $80ce		; 20 ce 80
;B23_1796:		cmp $02			; c5 02
;B23_1798:		bcs B23_17a5 ; b0 0b
;
;B23_179a:		sec				; 38 
;B23_179b:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_179e:		sbc $0d			; e5 0d
;B23_17a0:		jsr $80c4		; 20 c4 80
;B23_17a3:		cmp $03			; c5 03
;B23_17a5:		rts				; 60 
;
org $b7a6 
	getCollisionTileValUsingOffsetPresets:
;B23_17a6:		tya				; 98 
;B23_17a7:		asl a			; 0a
;B23_17a8:		ldy wEntityFacingLeft.w, x	; bc a8 04
;	beq +
;
;B23_17ad:		clc				; 18 
;B23_17ae:		adc #$01		; 69 01
;+	tay				; a8 
;B23_17b1:		lda data_17_17bd.w, y	; b9 bd b7
;B23_17b4:		pha				; 48 
;B23_17b5:		lda data_17_17e3.w, y	; b9 e3 b7
;B23_17b8:		tay				; a8 
;B23_17b9:		pla				; 68 
;B23_17ba:		jmp func_1f_1c1e		; 4c 1e fc
;
;; into A, facing right - facing left
;data_17_17bd:
;	.db $08 $f8
;	.db $f8 $08
;	.db $08 $f8
;	.db $08 $f8
;	.db $04 $fc
;	.db $08 $f8 ; 05
;	.db $04 $fc
;	.db $10 $f0
;	.db $08 $f8
;	.db $0c $f4
;	.db $fc $04
;	.db $ec $14
;	.db $08 $f7
;	.db $00 $00 ; 0d
;	.db $00 $00
;	.db $10 $f0
;	.db $18 $e8
;	.db $04 $fc
;	.db $08 $f8
;
;; into Y
;data_17_17e3:
;	.db $08 $08
;	.db $10 $10
;	.db $fc $fc
;	.db $08 $08
;	.db $f8 $f8
;	.db $10 $10 ; 05
;	.db $10 $10
;	.db $00 $00
;	.db $10 $10
;	.db $f8 $f8
;	.db $10 $10
;	.db $10 $10
;	.db $f4 $f4
;	.db $10 $10 ; 0d
;	.db $08 $08
;	.db $fc $fc
;	.db $00 $00
;	.db $08 $08
;	.db $00 $00
;
;
;B23_1809:		ldy #$00		; a0 00
;B23_180b:		lda $b81c, y	; b9 1c b8
;B23_180e:		bmi B23_1818 ; 30 08
;
;B23_1810:		cmp wPlayerStateDoubled.w		; cd 65 05
;B23_1813:		beq B23_181a ; f0 05
;
;B23_1815:		iny				; c8 
;B23_1816:		bne B23_180b ; d0 f3
;
;B23_1818:		clc				; 18 
;B23_1819:		rts				; 60 
;
;
;B23_181a:		sec				; 38 
;B23_181b:		rts				; 60 
;
;
;B23_181c:		asl $1210		; 0e 10 12
;B23_181f:	.db $14
;B23_1820:		asl $ff24, x	; 1e 24 ff
;B23_1823:		sta $00			; 85 00
;B23_1825:		stx $04			; 86 04
;B23_1827:		sty $05			; 84 05
;B23_1829:		lda #$00		; a9 00
;B23_182b:		sta $01			; 85 01
;B23_182d:		sta $02			; 85 02
;B23_182f:		ldy #$08		; a0 08
;B23_1831:		lsr $00			; 46 00
;B23_1833:		bcc B23_1842 ; 90 0d
;
;B23_1835:		clc				; 18 
;B23_1836:		lda $04			; a5 04
;B23_1838:		adc $01			; 65 01
;B23_183a:		sta $01			; 85 01
;B23_183c:		lda $05			; a5 05
;B23_183e:		adc $02			; 65 02
;B23_1840:		sta $02			; 85 02
;B23_1842:		ror $02			; 66 02
;B23_1844:		ror $01			; 66 01
;B23_1846:		ror $00			; 66 00
;B23_1848:		dey				; 88 
;B23_1849:		bne B23_1833 ; d0 e8
;
;B23_184b:		rts				; 60 
;
;
;B23_184c:		ldy $82			; a4 82
;B23_184e:		lda $bb43, y	; b9 43 bb
;B23_1851:		sta $00			; 85 00
;B23_1853:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1856:		clc				; 18 
;B23_1857:		lda $bbc8, y	; b9 c8 bb
;B23_185a:		adc $00			; 65 00
;B23_185c:		sta $02			; 85 02
;B23_185e:		jsr getDistanceBetweenPlayerAndEntityX		; 20 b3 80
;B23_1861:		cmp $02			; c5 02
;B23_1863:		bcs B23_1887 ; b0 22
;
;B23_1865:		ldy $82			; a4 82
;B23_1867:		lda wEntityBaseY.w		; ad 1c 04
;B23_186a:		sec				; 38 
;B23_186b:		sbc $b9bb, y	; f9 bb b9
;B23_186e:		sta $03			; 85 03
;B23_1870:		ldy wEntityObjectIdxes.w, x	; bc 4e 05
;B23_1873:		clc				; 18 
;B23_1874:		lda $bc60, y	; b9 60 bc
;B23_1877:		adc #$03		; 69 03
;B23_1879:		sta $02			; 85 02
;B23_187b:		sec				; 38 
;B23_187c:		lda $03			; a5 03
;B23_187e:		sbc wEntityBaseY.w, x	; fd 1c 04
;B23_1881:		bcs B23_1885 ; b0 02
;
;B23_1883:		eor #$ff		; 49 ff
;B23_1885:		cmp $02			; c5 02
;B23_1887:		rts				; 60 
;
;
;B23_1888:		ldy $82			; a4 82
;B23_188a:		lda $b9b2, y	; b9 b2 b9
;B23_188d:		clc				; 18 
;B23_188e:		adc wEntityBaseY.w		; 6d 1c 04
;B23_1891:		sta $00			; 85 00
;B23_1893:		ldy #$00		; a0 00
;B23_1895:		lda wEntityBaseX.w		; ad 38 04
;B23_1898:		sec				; 38 
;B23_1899:		sbc wEntityBaseX.w, x	; fd 38 04
;B23_189c:		bcs B23_18a4 ; b0 06
;
;B23_189e:		iny				; c8 
;B23_189f:		eor #$ff		; 49 ff
;B23_18a1:		clc				; 18 
;B23_18a2:		adc #$01		; 69 01
;B23_18a4:		cmp #$08		; c9 08
;B23_18a6:		bcs B23_18dd ; b0 35
;
;B23_18a8:		sty $01			; 84 01
;B23_18aa:		ldy #$00		; a0 00
;B23_18ac:		lda $00			; a5 00
;B23_18ae:		sec				; 38 
;B23_18af:		sbc wEntityBaseY.w, x	; fd 1c 04
;B23_18b2:		bcs B23_18ba ; b0 06
;
;B23_18b4:		iny				; c8 
;B23_18b5:		eor #$ff		; 49 ff
;B23_18b7:		clc				; 18 
;B23_18b8:		adc #$01		; 69 01
;B23_18ba:		cmp #$08		; c9 08
;B23_18bc:		bcs B23_18dd ; b0 1f
;
;B23_18be:		sty $02			; 84 02
;B23_18c0:		stx $94			; 86 94
;B23_18c2:		lda wPlayerStateDoubled.w, x	; bd 65 05
;B23_18c5:		bmi B23_18de ; 30 17
;
;B23_18c7:		cmp #$20		; c9 20
;B23_18c9:		bcs B23_18d1 ; b0 06
;
;B23_18cb:		lda $01			; a5 01
;B23_18cd:		beq B23_18d9 ; f0 0a
;
;B23_18cf:		bne B23_18d5 ; d0 04
;
;B23_18d1:		lda $02			; a5 02
;B23_18d3:		beq B23_18d9 ; f0 04
;
;B23_18d5:		lda #$01		; a9 01
;B23_18d7:		bne B23_18db ; d0 02
;
;B23_18d9:		lda #$02		; a9 02
;B23_18db:		sta $93			; 85 93
;B23_18dd:		rts				; 60 
;
;
;B23_18de:		cmp #$e0		; c9 e0
;B23_18e0:		bcc B23_18e8 ; 90 06
;
;B23_18e2:		lda $01			; a5 01
;B23_18e4:		bne B23_18d9 ; d0 f3
;
;B23_18e6:		beq B23_18d5 ; f0 ed
;
;B23_18e8:		lda $02			; a5 02
;B23_18ea:		beq B23_18d9 ; f0 ed
;
;B23_18ec:		bne B23_18d5 ; d0 e7
;
;B23_18ee:		lda $af			; a5 af
;B23_18f0:		beq B23_18f6 ; f0 04
;
;B23_18f2:		cpx $d2			; e4 d2
;B23_18f4:		beq B23_18dd ; f0 e7
;
;B23_18f6:		lda $81			; a5 81
;B23_18f8:		cmp #$06		; c9 06
;B23_18fa:		beq B23_18dd ; f0 e1
;
;B23_18fc:		ldy $82			; a4 82
;B23_18fe:		lda $b9b2, y	; b9 b2 b9
;B23_1901:		clc				; 18 
;B23_1902:		adc wEntityBaseY.w		; 6d 1c 04
;B23_1905:		sta $00			; 85 00
;B23_1907:		lda wEntityAlarmOrStartYforSinusoidalMovement.w, x	; bd 06 06
;B23_190a:		beq B23_195a ; f0 4e
;
;B23_190c:		ldy #$00		; a0 00
;B23_190e:		lda wEntityBaseX.w		; ad 38 04
;B23_1911:		sec				; 38 
;B23_1912:		sbc wEntityBaseX.w, x	; fd 38 04
;B23_1915:		bcs B23_191e ; b0 07
;
;B23_1917:		ldy #$80		; a0 80
;B23_1919:		eor #$ff		; 49 ff
;B23_191b:		clc				; 18 
;B23_191c:		adc #$01		; 69 01
;B23_191e:		sec				; 38 
;B23_191f:		sbc #$05		; e9 05
;B23_1921:		bcs B23_1925 ; b0 02
;
;B23_1923:		lda #$00		; a9 00
;B23_1925:		cmp #$40		; c9 40
;B23_1927:		bcs B23_18dd ; b0 b4
;
;B23_1929:		sta $90			; 85 90
;B23_192b:		tya				; 98 
;B23_192c:		ora $90			; 05 90
;B23_192e:		sta $90			; 85 90
;B23_1930:		and #$7f		; 29 7f
;B23_1932:		tay				; a8 
;B23_1933:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_1936:		sec				; 38 
;B23_1937:		sbc $ba7e, y	; f9 7e ba
;B23_193a:		sec				; 38 
;B23_193b:		sbc $00			; e5 00
;B23_193d:		bcs B23_1945 ; b0 06
;
;B23_193f:		cmp #$fb		; c9 fb
;B23_1941:		bcc B23_19ab ; 90 68
;
;B23_1943:		bcs B23_194d ; b0 08
;
;B23_1945:		cpy #$3a		; c0 3a
;B23_1947:		bcs B23_1954 ; b0 0b
;
;B23_1949:		cmp #$04		; c9 04
;B23_194b:		bcs B23_19ab ; b0 5e
;
;B23_194d:		sta $91			; 85 91
;B23_194f:		lda #$01		; a9 01
;B23_1951:		jmp $b99f		; 4c 9f b9
;
;
;B23_1954:		cmp #$10		; c9 10
;B23_1956:		bcs B23_19ab ; b0 53
;
;B23_1958:		bcc B23_194d ; 90 f3
;
;B23_195a:		ldy #$00		; a0 00
;B23_195c:		lda wEntityBaseX.w		; ad 38 04
;B23_195f:		sec				; 38 
;B23_1960:		sbc wEntityBaseX.w, x	; fd 38 04
;B23_1963:		bcs B23_196c ; b0 07
;
;B23_1965:		ldy #$80		; a0 80
;B23_1967:		eor #$ff		; 49 ff
;B23_1969:		clc				; 18 
;B23_196a:		adc #$01		; 69 01
;B23_196c:		sec				; 38 
;B23_196d:		sbc #$05		; e9 05
;B23_196f:		bcs B23_1973 ; b0 02
;
;B23_1971:		lda #$00		; a9 00
;B23_1973:		cmp #$20		; c9 20
;B23_1975:		bcs B23_19ab ; b0 34
;
;B23_1977:		sta $90			; 85 90
;B23_1979:		tya				; 98 
;B23_197a:		ora $90			; 05 90
;B23_197c:		sta $90			; 85 90
;B23_197e:		and #$7f		; 29 7f
;B23_1980:		tay				; a8 
;B23_1981:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_1984:		sec				; 38 
;B23_1985:		sbc $babf, y	; f9 bf ba
;B23_1988:		sec				; 38 
;B23_1989:		sbc $00			; e5 00
;B23_198b:		bcs B23_1993 ; b0 06
;
;B23_198d:		cmp #$fb		; c9 fb
;B23_198f:		bcc B23_19ab ; 90 1a
;
;B23_1991:		bcs B23_199b ; b0 08
;
;B23_1993:		cpy #$1f		; c0 1f
;B23_1995:		bcs B23_19ac ; b0 15
;
;B23_1997:		cmp #$04		; c9 04
;B23_1999:		bcs B23_19ab ; b0 10
;
;B23_199b:		sta $91			; 85 91
;B23_199d:		lda #$00		; a9 00
;B23_199f:		sta $95			; 85 95
;B23_19a1:		stx $d4			; 86 d4
;B23_19a3:		lda #$06		; a9 06
;B23_19a5:		sta $81			; 85 81
;B23_19a7:		lda #$00		; a9 00
;B23_19a9:		sta $af			; 85 af
;B23_19ab:		rts				; 60 
;
;
;B23_19ac:		cmp #$10		; c9 10
;B23_19ae:		bcs B23_19ab ; b0 fb
;
;B23_19b0:		bcc B23_199b ; 90 e9
;
;B23_19b2:		bpl B23_19c4 ; 10 10
;
;B23_19b4:	.db $0c
;B23_19b5:		bpl B23_19c7 ; 10 10
;
;B23_19b7:		bpl B23_19c5 ; 10 0c
;
;B23_19b9:		bpl B23_19c3 ; 10 08
;
;B23_19bb:		php				; 08 
;B23_19bc:		php				; 08 
;B23_19bd:	.db $04
;B23_19be:		php				; 08 
;B23_19bf:	.db $02
;B23_19c0:	.db $02
;B23_19c1:		.db $00				; 00
;B23_19c2:	.db $02
;B23_19c3:	.db $04
;B23_19c4:		iny				; c8 
;B23_19c5:		sty $0f			; 84 0f
;B23_19c7:		lda wPlayerStateDoubled.w, x	; bd 65 05
;B23_19ca:		sec				; 38 
;B23_19cb:		sbc #$40		; e9 40
;B23_19cd:		jmp $b9e7		; 4c e7 b9
;
;
;B23_19d0:		lda wEntityAlarmOrStartYforSinusoidalMovement.w, x	; bd 06 06
;B23_19d3:		beq B23_19d6 ; f0 01
;
;B23_19d5:		rts				; 60 
;
;
;B23_19d6:		ldy #$00		; a0 00
;B23_19d8:		lda wPlayerStateDoubled.w, x	; bd 65 05
;B23_19db:		cmp #$40		; c9 40
;B23_19dd:		bcs B23_19c4 ; b0 e5
;
;B23_19df:		sty $0f			; 84 0f
;B23_19e1:		lda #$40		; a9 40
;B23_19e3:		sec				; 38 
;B23_19e4:		sbc wPlayerStateDoubled.w, x	; fd 65 05
;B23_19e7:		sta $07			; 85 07
;B23_19e9:		tay				; a8 
;B23_19ea:		lda wEntityBaseX.w, x	; bd 38 04
;B23_19ed:		sec				; 38 
;B23_19ee:		sbc $bae0, y	; f9 e0 ba
;B23_19f1:		sta $09			; 85 09
;B23_19f3:		ldx #$00		; a2 00
;B23_19f5:		lda $09			; a5 09
;B23_19f7:		sec				; 38 
;B23_19f8:		sbc wEntityBaseX.w		; ed38 04
;B23_19fb:		bcs B23_1a03 ; b0 06
;
;B23_19fd:		inx				; e8 
;B23_19fe:		eor #$ff		; 49 ff
;B23_1a00:		clc				; 18 
;B23_1a01:		adc #$01		; 69 01
;B23_1a03:		cmp $bb22, y	; d9 22 bb
;B23_1a06:		bcs B23_19d5 ; b0 cd
;
;B23_1a08:		sta $0a			; 85 0a
;B23_1a0a:		stx $0b			; 86 0b
;B23_1a0c:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_1a0e:		lda wEntityBaseY.w, x	; bd 1c 04
;B23_1a11:		ldx $0f			; a6 0f
;B23_1a13:		beq B23_1a1b ; f0 06
;
;B23_1a15:		sec				; 38 
;B23_1a16:		sbc $bb01, y	; f9 01 bb
;B23_1a19:		bne B23_1a1f ; d0 04
;
;B23_1a1b:		clc				; 18 
;B23_1a1c:		adc $bb01, y	; 79 01 bb
;B23_1a1f:		sec				; 38 
;B23_1a20:		sbc #$10		; e9 10
;B23_1a22:		sta $0c			; 85 0c
;B23_1a24:		ldy $07			; a4 07
;B23_1a26:		lda $fdc2, y	; b9 c2 fd
;B23_1a29:		tax				; aa 
;B23_1a2a:		ldy #$00		; a0 00
;B23_1a2c:		lda $0a			; a5 0a
;B23_1a2e:		jsr $b823		; 20 23 b8
;B23_1a31:		ldx wCurrEntityIdxBeingProcessed			; a6 6c
;B23_1a33:		lda $0f			; a5 0f
;B23_1a35:		beq B23_1a3d ; f0 06
;
;B23_1a37:		lda $0b			; a5 0b
;B23_1a39:		beq B23_1a41 ; f0 06
;
;B23_1a3b:		bne B23_1a48 ; d0 0b
;
;B23_1a3d:		lda $0b			; a5 0b
;B23_1a3f:		beq B23_1a48 ; f0 07
;
;B23_1a41:		lda $0c			; a5 0c
;B23_1a43:		sec				; 38 
;B23_1a44:		sbc $01			; e5 01
;B23_1a46:		bne B23_1a4d ; d0 05
;
;B23_1a48:		lda $0c			; a5 0c
;B23_1a4a:		clc				; 18 
;B23_1a4b:		adc $01			; 65 01
;B23_1a4d:		sta $0c			; 85 0c
;B23_1a4f:		sec				; 38 
;B23_1a50:		sbc wEntityBaseY.w		; ed1c 04
;B23_1a53:		bcs B23_1a5b ; b0 06
;
;B23_1a55:		cmp #$f8		; c9 f8
;B23_1a57:		bcc B23_1a7d ; 90 24
;
;B23_1a59:		bcs B23_1a5f ; b0 04
;
;B23_1a5b:		cmp #$08		; c9 08
;B23_1a5d:		bcs B23_1a7d ; b0 1e
;
;B23_1a5f:		sta $91			; 85 91
;B23_1a61:		lda $07			; a5 07
;B23_1a63:		ldy wPlayerStateDoubled.w, x	; bc 65 05
;B23_1a66:		cpy #$40		; c0 40
;B23_1a68:		bcc B23_1a6c ; 90 02
;
;B23_1a6a:		ora #$80		; 09 80
;B23_1a6c:		sta $90			; 85 90
;B23_1a6e:		lda #$01		; a9 01
;B23_1a70:		ldy $0b			; a4 0b
;B23_1a72:		bne B23_1a76 ; d0 02
;
;B23_1a74:		lda #$08		; a9 08
;B23_1a76:		sta $0645, x	; 9d 45 06
;B23_1a79:		lda #$05		; a9 05
;B23_1a7b:		sta $81			; 85 81
;B23_1a7d:		rts				; 60 

org $ba7e
	B23_1a7e:
		db $40 ,$40 ,$40 ,$40 
		db $40 ,$40 ,$40 ,$40
		db $3F ,$3F ,$3F ,$3F
		db $3F ,$3F ,$3E ,$3E
		db $3E ,$3E ,$3D ,$3D 
		db $3D ,$3C ,$3C ,$3C
		db $3B ,$3B ,$3A ,$3A
		db $3A ,$39 ,$39 ,$38
		db $37 ,$37 ,$36 ,$36 
		db $35 ,$34 ,$33 ,$33
		db $32 ,$31 ,$30 ,$2F
		db $2E ,$2E ,$2C ,$2B
		db $2A ,$29 ,$28 ,$27 
		db $25 ,$24 ,$22 ,$21
		db $1F ,$1D ,$1B ,$19
		db $16 ,$13 ,$10 ,$0B
		db $00 ,$20 ,$20 ,$20 
		db $20 ,$20 ,$20 ,$1F
		db $1F ,$1F ,$1F ,$1E
		db $1E ,$1E ,$1D ,$1D
		db $1C ,$1C ,$1B ,$1A 
		db $1A ,$19 ,$18 ,$17
		db $16 ,$15 ,$14 ,$13
		db $11 ,$0F ,$0E ,$0B
		db $08 ,$00 ,$08 ,$08 
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$07 ,$07 ,$07 
		db $07 ,$07 ,$07 ,$07
		db $07 ,$07 ,$07 ,$07
		db $06 ,$06 ,$06 ,$06
		db $06 ,$06 ,$06 ,$00 
		db $00 ,$00 ,$01 ,$01
		db $01 ,$01 ,$01 ,$02
		db $02 ,$02 ,$02 ,$02
		db $03 ,$03 ,$03 ,$03 
		db $03 ,$03 ,$04 ,$04
		db $04 ,$04 ,$04 ,$04
		db $05 ,$05 ,$05 ,$05
		db $05 ,$05 ,$06 ,$06 
		db $3C ,$3C ,$3C ,$3C
		db $3C ,$3C ,$3B ,$3B
		db $3B ,$3B ,$3A ,$3A
		db $39 ,$39 ,$38 ,$38 
		db $37 ,$37 ,$36 ,$36
		db $35 ,$34 ,$33 ,$33
		db $32 ,$31 ,$30 ,$2F
		db $2E ,$2D ,$2C ,$2B 
		db $2A ,$06 ,$06 ,$06
		db $06 ,$06 ,$06 ,$06
		db $06 ,$06 ,$0C ,$0C
		db $0A ,$0C ,$08 ,$08 
		db $06 ,$08 ,$05 ,$14
		db $14 ,$1E ,$0E ,$0E
		db $03 ,$03 ,$03 ,$08
		db $03 ,$14 ,$EC ,$14 
		db $EC ,$1C ,$E4 ,$10
		db $F0 ,$0C ,$F4 ,$FE
		db $FC ,$FC ,$00 ,$FE
		db $FC ,$FC ,$00 ,$00 
		db $1A ,$0C ,$0C ,$10
		db $10 ,$12 ,$12 ,$16
		db $12 ,$03 ,$05 ,$03
		db $03 ,$03 ,$03 ,$03 
		db $03 ,$03 ,$18 ,$E8
		db $10 ,$F0 ,$0C ,$F4
		db $10 ,$F0 ,$14 ,$EC
		db $14 ,$EC ,$08 ,$F8 
		db $0C ,$F4 ,$0C ,$F4
		db $00 ,$00 ,$00 ,$00
		db $FC ,$FC ,$FC ,$FC
		db $FC ,$FC ,$FC ,$FC 
		db $00 ,$00 ,$00 ,$00
		db $FC ,$FC ,$00 ,$06
		db $07 ,$06 ,$0C ,$1C
		db $06 ,$06 ,$06 ,$06 
		db $03 ,$00 ,$06 ,$07
		db $03 ,$0C ,$04 ,$06
		db $06 ,$03 ,$06 ,$04
		db $00 ,$04 ,$0F ,$0F 
		db $16 ,$16 ,$12 ,$12
		db $0A ,$0A ,$08 ,$08
		db $0A ,$08 ,$08 ,$10
		db $08 ,$0D ,$0C ,$18 
		db $10 ,$06 ,$0C ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08 
		db $08 ,$10 ,$08 ,$08
		db $08 ,$0C ,$08 ,$08
		db $10 ,$06 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08 
		db $10 ,$08 ,$03 ,$05
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08 
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$03 ,$04
		db $02 ,$06 ,$04 ,$04
		db $03 ,$08 ,$08 ,$08 
		db $08 ,$05 ,$08 ,$08
		db $08 ,$08 ,$06 ,$08
		db $0C ,$06 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08 
		db $08 ,$08 ,$08 ,$08
		db $06 ,$08 ,$08 ,$08
		db $08 ,$08 ,$06 ,$08
		db $08 ,$0C ,$08 ,$08 
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$30
		db $10 ,$20 ,$80 ,$10
		db $20 ,$08 ,$08 ,$08 
		db $08 ,$08 ,$08 ,$11
		db $0C ,$10 ,$08 ,$08
		db $0C ,$08 ,$0E ,$08
		db $10 ,$10 ,$10 ,$08 
		db $10 ,$08 ,$08 ,$08
		db $08 ,$08 ,$04 ,$06
		db $04 ,$02 ,$02 ,$02
		db $02 ,$02 ,$0E ,$10 
		db $10 ,$10 ,$10 ,$10
		db $08 ,$20 ,$0C ,$18
		db $10 ,$0C ,$14 ,$08
		db $14 ,$0E ,$0E ,$08 
		db $0E ,$0E ,$04 ,$0E
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$09 ,$0E ,$0A
		db $14 ,$0E ,$06 ,$04 
		db $02 ,$06 ,$08 ,$0E
		db $02 ,$04 ,$0E ,$0E
		db $08 ,$08 ,$03 ,$05
		db $0E ,$0E ,$08 ,$08 
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$08 ,$08
		db $08 ,$08 ,$04 ,$08 
		db $04 ,$06 ,$02 ,$06
		db $06 ,$0E ,$0E ,$0E
		db $06 ,$05 ,$08 ,$0E
		db $0E ,$0E ,$0E ,$0E 
		db $08 ,$04 ,$0E ,$0E
		db $0E ,$0E ,$0E ,$06
		db $0E ,$0E ,$0E ,$0E
		db $06 ,$0E ,$0E ,$0E 
		db $0E ,$0E ,$06 ,$0E
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$0E ,$0E ,$0E
		db $0E ,$0E ,$0E ,$20 
		db $28 ,$10 ,$10 ,$10
		db $28 ,$0E ,$0E ,$05
		db $05 ,$0E ,$0E ,$04
		db $08 ,$08 ,$0E ,$0E 
		db $04 ,$04 ,$08 ,$0E
		db $08 ,$08 ,$08 ,$0E
		db $08 ,$0E ,$0E ,$0E
		db $0E ,$0E ,$07 ,$0C 
		db $07 ,$04 ,$04 ,$04
		db $04 ,$04

	-	rts
execEntityXNextPhaseFunc:
		lda $ab					; a5 ab
		beq +
		jsr	func_1f_07b6		; 20 b6 e7 	; ab non-0
		bcs -

	+	lda wEntityAI_idx, x	; bd ef 05
		beq -
		cmp #$27				; c9 27
		bne +

		jsr func_16_0131		; 20 31 81	; ai idx == 27
		beq -

+
; get script addr for entity
	asl a			; 0a
	tay
	lda entityScriptsAddresses, y
	sta wCurrEntityScriptAddr
	lda entityScriptsAddresses+1, y
	sta wCurrEntityScriptAddr+1

; get 4 bytes (opcode + params) for current phase
	lda wEntityPhase, x
	asl a
	asl a
	clc
	adc wCurrEntityScriptAddr
	sta wPhaseFuncDataAddr
	lda wPhaseFuncDataAddr+1
	adc #$00
	sta wPhaseFuncDataAddr+1

; get script func for opcode
	ldy #$00
	lda (wPhaseFuncDataAddr), y
	asl a
	bcs +

	tay
	lda entityPhaseFuncsAddresses, y
	sta wCurrEntityPhaseFuncAddr
	lda entityPhaseFuncsAddresses+1, y
	sta wCurrEntityPhaseFuncAddr+1
	jmp (wCurrEntityPhaseFuncAddr)

+	tay
	lda entityPhaseFuncsAddresses2, y
	sta wCurrEntityPhaseFuncAddr
	lda entityPhaseFuncsAddresses2+1, y
	sta wCurrEntityPhaseFuncAddr+1
	jmp (wCurrEntityPhaseFuncAddr)


entityPhaseFuncsAddresses:
	.dw entityPhaseFunc_00_setEntityAIIdxTo0
	.dw entityPhaseFunc_01_setStateNotMoving
;	.dw entityPhaseFunc_02
;	.dw entityPhaseFunc_03
;	.dw entityPhaseFunc_04_setPhase
;	.dw entityPhaseFunc_05_facePlayer
;	.dw entityPhaseFunc_06
;	.dw entityPhaseFunc_07
;	.dw entityPhaseFunc_08
;	.dw entityPhaseFunc_09
;	.dw entityPhaseFunc_0a
;	.dw entityPhaseFunc_0b
;	.dw entityPhaseFunc_0c
;	.dw entityPhaseFunc_0d
;	.dw entityPhaseFunc_0e
;	.dw entityPhaseFunc_0f
;	.dw entityPhaseFunc_10
;	.dw entityPhaseFunc_11
;	.dw entityPhaseFunc_12
;	.dw entityPhaseFunc_13_animateGroupAndDefIdx
;	.dw entityPhaseFunc_14
;	.dw entityPhaseFunc_15
;	.dw entityPhaseFunc_16
;	.dw entityPhaseFunc_17
;	.dw entityPhaseFunc_18_setPhase0
;	.dw entityPhaseFunc_19_stub
;	.dw entityPhaseFunc_1a
;	.dw entityPhaseFunc_1b
;	.dw entityPhaseFunc_1c
;	.dw entityPhaseFunc_1d
;	.dw entityPhaseFunc_1e_moveToPlayerSetHorizSpeeds
;	.dw entityPhaseFunc_1f_setAlarmOrStartYforSinusoidalMovement
;	.dw entityPhaseFunc_20_incPhaseWhenAlarm0
;	.dw entityPhaseFunc_21
;	.dw entityPhaseFunc_22
;	.dw entityPhaseFunc_23
;	.dw entityPhaseFunc_24
;	.dw entityPhaseFunc_25
;	.dw entityPhaseFunc_26
;	.dw entityPhaseFunc_27_end
;	.dw entityPhaseFunc_28
;	.dw entityPhaseFunc_29
;	.dw entityPhaseFunc_2a_setStateMoving
;	.dw entityPhaseFunc_2b_reverseHorizontally
;	.dw entityPhaseFunc_2c
;	.dw entityPhaseFunc_2d
;	.dw entityPhaseFunc_2e
;	.dw entityPhaseFunc_2f
;	.dw entityPhaseFunc_30
;	.dw entityPhaseFunc_31
;	.dw entityPhaseFunc_32
;	.dw entityPhaseFunc_33
;	.dw entityPhaseFunc_34
;	.dw entityPhaseFunc_35
;	.dw entityPhaseFunc_36
;	.dw entityPhaseFunc_37
;	.dw entityPhaseFunc_38
;	.dw entityPhaseFunc_39_setVertSpeedStartMoving
;	.dw entityPhaseFunc_3a
;	.dw entityPhaseFunc_3b
;	.dw entityPhaseFunc_3c
;	.dw entityPhaseFunc_3d
;	.dw entityPhaseFunc_3e
;	.dw entityPhaseFunc_3f
;	.dw entityPhaseFunc_40
;	.dw entityPhaseFunc_41
;	.dw entityPhaseFunc_42
;	.dw entityPhaseFunc_43
;	.dw entityPhaseFunc_44
;	.dw entityPhaseFunc_45
;	.dw entityPhaseFunc_46
;	.dw entityPhaseFunc_47
;	.dw entityPhaseFunc_48
;	.dw entityPhaseFunc_49
;	.dw entityPhaseFunc_4a
;	.dw entityPhaseFunc_4b
;	.dw entityPhaseFunc_4c
;	.dw entityPhaseFunc_4d
;	.dw entityPhaseFunc_4e
;	.dw entityPhaseFunc_4f
;	.dw entityPhaseFunc_50
;	.dw entityPhaseFunc_51
;	.dw entityPhaseFunc_52
;	.dw entityPhaseFunc_53_setStateNotIllusion
;	.dw entityPhaseFunc_54_setStateIllusion
;	.dw entityPhaseFunc_55
;	.dw entityPhaseFunc_56
;	.dw entityPhaseFunc_57
;	.dw entityPhaseFunc_58
;	.dw entityPhaseFunc_59
;	.dw entityPhaseFunc_5a
;	.dw entityPhaseFunc_5b
;	.dw entityPhaseFunc_5c
;	.dw entityPhaseFunc_5d
;	.dw entityPhaseFunc_5e
;	.dw entityPhaseFunc_5f
;	.dw entityPhaseFunc_60
;	.dw entityPhaseFunc_61
;	.dw entityPhaseFunc_62_addOffsetsToXY
;	.dw entityPhaseFunc_63
;	.dw entityPhaseFunc_64
;	.dw entityPhaseFunc_65
;	.dw entityPhaseFunc_66
;	.dw entityPhaseFunc_67
;	.dw entityPhaseFunc_68
;	.dw entityPhaseFunc_69
;	.dw entityPhaseFunc_6a
;	.dw entityPhaseFunc_6b
;	.dw entityPhaseFunc_6c_playSound
;	.dw entityPhaseFunc_6d_tryToFall
;	.dw entityPhaseFunc_6e
;	.dw entityPhaseFunc_6f
;	.dw entityPhaseFunc_70
;	.dw entityPhaseFunc_71
;	.dw entityPhaseFunc_72_stub
;	.dw entityPhaseFunc_73
;	.dw entityPhaseFunc_74
;	.dw entityPhaseFunc_75_stub
;	.dw entityPhaseFunc_76
;	.dw entityPhaseFunc_77
;	.dw entityPhaseFunc_78
;	.dw entityPhaseFunc_79
;	.dw entityPhaseFunc_7a
;	.dw entityPhaseFunc_7b_setGenericCounter
;	.dw entityPhaseFunc_7c
;	.dw entityPhaseFunc_7d
;	.dw entityPhaseFunc_7e
;	.dw entityPhaseFunc_7f

org $be4f
	entityPhaseFuncsAddresses2:
;	.dw entityPhaseFunc_80
;	.dw entityPhaseFunc_81
;	.dw entityPhaseFunc_82
;	.dw entityPhaseFunc_83
;	.dw entityPhaseFunc_84
;	.dw entityPhaseFunc_85
;	.dw entityPhaseFunc_86
;	.dw entityPhaseFunc_87
;	.dw entityPhaseFunc_88
;	.dw entityPhaseFunc_89
;	.dw entityPhaseFunc_8a
;	.dw entityPhaseFunc_8b
;	.dw entityPhaseFunc_8c
;	.dw entityPhaseFunc_8d
;	.dw entityPhaseFunc_8e
;	.dw entityPhaseFunc_8f
;	.dw entityPhaseFunc_90
;	.dw entityPhaseFunc_91
;	.dw entityPhaseFunc_92
;	.dw entityPhaseFunc_93
;	.dw entityPhaseFunc_94
;	.dw entityPhaseFunc_95
;	.dw entityPhaseFunc_96
;	.dw entityPhaseFunc_97_clearSpeeds
;	.dw entityPhaseFunc_98
;	.dw entityPhaseFunc_99
;	.dw entityPhaseFunc_9a
;	.dw entityPhaseFunc_9b
;	.dw entityPhaseFunc_9c
;	.dw entityPhaseFunc_9d
;	.dw entityPhaseFunc_9e
;	.dw entityPhaseFunc_9f
;	.dw entityPhaseFunc_a0
;	.dw entityPhaseFunc_a1
;	.dw entityPhaseFunc_a2
;	.dw entityPhaseFunc_a3
;	.dw entityPhaseFunc_a4
;	.dw entityPhaseFunc_a5
;	.dw entityPhaseFunc_a6
;	.dw entityPhaseFunc_a7
;	.dw entityPhaseFunc_a8
;
org $bea1
	entityScriptsAddresses:
	.dw entityScripts_stub				; #00  Unused address used by diverted spawners
	.dw entityScripts_01                ;  #01  Zombie (slow rate) normal zombie
	.dw entityScripts_02                ;  #02  Zombie (from ground)
	.dw entityScripts_03                ;  #03  Medusa Head (one)
	.dw entityScripts_04                ;  #04  Winged Demon (one)
	.dw entityScripts_05                ;  #05  Skull Knight (Boss)
	.dw entityScripts_06                ;  #06  Cyclops (Boss)
	.dw entityScripts_07                ;  #07  Grant (Boss)
	.dw entityScripts_08                ;  #08  Lightning (bolts) first visual effect
	.dw entityScripts_09                ;  #09  Lightning (Sypha) cinematic visual effect
	.dw entityScripts_0a                ;  #0A  Lightning (clouds) boss fight visual effect
	.dw entityScripts_0b                ;  #0B  Hunchback
	.dw entityScripts_0c                ;  #0C  Bats (flying)[1]
	.dw entityScripts_0d                ;  #0D  Bats (asleep)
	.dw entityScripts_0e                ;  #0E  Bone Pillar (3-shot)[1]
	.dw entityScripts_0f                ;  #0F  Axe Knight
	.dw entityScripts_10                ;  #10  Crow (flying low)
	.dw entityScripts_11                ;  #11  Skeleton (sword)[1]
	.dw entityScripts_12                ;  #12  Fishmen (jumping) bridge variety
	.dw entityScripts_13                ;  #13  Skeleton (whip,red)
	.dw entityScripts_14                ;  #14  Floating Eye
	.dw entityScripts_stub              ;  #15  Slime Ball
	.dw entityScripts_16                ;  #16  Skeleton (bones)
	.dw entityScripts_17                ;  #17  Skeleton (whip,blue)
	.dw entityScripts_18                ;  #18  Ghost (no flicker)
	.dw entityScripts_19                ;  #19  Skeleton (red)
	.dw entityScripts_1a                ;  #1A  Mummies[1]
	.dw entityScripts_1b                ;  #1B  Giant Bat (Boss)
	.dw entityScripts_1c                ;  #1C  Alucard (Boss)
	.dw entityScripts_1d                ;  #1D  Bone Dragon King (Boss)
	.dw entityScripts_1e                ;  #1E  Medusa (Boss)
	.dw entityScripts_stub              ;  #1F  Water Dragons (Boss)
	.dw entityScripts_20                ;  #20  Mummies + Cyclops (Boss)
	.dw entityScripts_21                ;  #21  Frankenstein's Monster (Boss)
	.dw entityScripts_22                ;  #22  UNUSED BOSS (no object, spawner position #2A)
	.dw entityScripts_23                ;  #23  Grim Reaper (Boss)
	.dw entityScripts_24                ;  #24  Doppelganger (Boss)
	.dw entityScripts_25                ;  #25  Mummy + Cyclops + Leviathan (Boss)
	.dw entityScripts_26                ;  #26  Dracula (Boss)
	.dw entityScripts_27                ;  #27  Crow (flying high)
	.dw entityScripts_28                ;  #28  Headless Pirate a.k.a. Dhuron
	.dw entityScripts_29                ;  #29  Spider
	.dw entityScripts_2a                ;  #2A  Bone Pillar (2-shot)
	.dw entityScripts_2b                ;  #2B  Bats (flying)[2] *unused in CV3j*
	.dw entityScripts_2c                ;  #2C  Fuzz Buster[1] *unused in CV3j*
	.dw entityScripts_2d                ;  #2D  Spore (floating)
	.dw entityScripts_2e                ;  #2E  Spore
	.dw entityScripts_2f                ;  #2F  Trap Door *unused*
	.dw entityScripts_30                ;  #30  Trap Door (spikes) *unused*
	.dw entityScripts_31                ;  #31  Gear Tooth *unused*
	.dw entityScripts_32                ;  #32  Skeleton (blue)
	.dw entityScripts_33                ;  #33  Pendulum *unused*
	.dw entityScripts_34                ;  #34  Falling Spikes[1] *unused*
	.dw entityScripts_35                ;  #35  Falling Spikes[2] *unused*
	.dw entityScripts_36                ;  #36  Water Current (4 blocks)
	.dw entityScripts_37                ;  #37  Falling Blocks *unused*
	.dw entityScripts_38                ;  #38  Acid Drops *unused*
	.dw entityScripts_39                ;  #39  Water Current (2 blocks)[1]
	.dw entityScripts_3a                ;  #3A  Zombie (fast rate)[1]
	.dw entityScripts_3b                ;  #3B  Mudmen
	.dw entityScripts_3c                ;  #3C  Frog
	.dw entityScripts_3d                ;  #3D  Fishmen (swimming) aqueduct variety
	.dw entityScripts_3e                ;  #3E  Fishmen (swim+jump) deep water variety
	.dw entityScripts_3f                ;  #3F  Fire Man
	.dw entityScripts_40                ;  #40  Knight
	.dw entityScripts_41                ;  #41  Bone Pillar (3-shot)[2]
	.dw entityScripts_42                ;  #42  Auto-Walk (forest)
	.dw entityScripts_43                ;  #43  Bone Dragon
	.dw entityScripts_44                ;  #44  Owl
	.dw entityScripts_45                ;  #45  Fuzz Buster[2]
	.dw entityScripts_46                ;  #46  Harpy
	.dw entityScripts_47                ;  #47  Bats Flying[3]
	.dw entityScripts_48                ;  #48  Medusa Heads (two)[1]
	.dw entityScripts_49                ;  #49  Skeleton (sword)[2]
	.dw entityScripts_4a                ;  #4A  Medusa Heads (two)[2]
	.dw entityScripts_4b                ;  #4B  Ghost (w/flicker)
	.dw entityScripts_4c                ;  #4C  Auto-Walk (caves)
	.dw entityScripts_4d                ;  #4D  Water Current (6 blocks)
	.dw entityScripts_4e                ;  #4E  Water Current (2 blocks)[2]
	.dw entityScripts_4f                ;  #4F  Zombie (fast rate)[2]
	.dw entityScripts_50                ;  #50  Mummies[2]
	.dw entityScripts_51                ;  #51  Flood Controller
	.dw entityScripts_52                ;  #52  Winged Demon (two) *CV3u only*
	.dw entityScripts_53				
	.dw entityScripts_stub				;	$83 Axe
	.dw entityScripts_stub              ;    $84 Cross
	.dw entityScripts_stub              ;    $85 Dagger
	.dw entityScripts_57                ;    $86 Holy Water
	.dw entityScripts_58                ;    $87 Stopwatch
	.dw entityScripts_59                ;    $88 Sypha's fire
	.dw entityScripts_5a                ;    $89 Sypha's ice
	.dw entityScripts_5b                ;    $8A Sypha's water
	.dw entityScripts_5c                ;    $8B Grant's Dagger
	.dw entityScripts_5d                ;    $8C Grant's Axe
	.dw entityScripts_5e                ;    $8D Upgrade 1 (upgrades whip to 1)
	.dw entityScripts_5f                ;    $8E Upgrade 2 (upgrades whip to 2)
	.dw entityScripts_60                ;    $8F Nothing? (looks like whip upgrade but no effect)
	.dw entityScripts_61                ;    $90 Mystery Meat
	.dw entityScripts_62                ;    $91 Invincibility Potion (duration = $B4)
	.dw entityScripts_63                ;    $92 Rosary
	.dw entityScripts_64                ;    $93 100 Point Bag
	.dw entityScripts_65                ;    $94 200 Point Bag
	.dw entityScripts_66                ;    $95 400 Point Bag
	.dw entityScripts_67                ;    $96 700 Point Bag
	.dw entityScripts_68                ;    $97 1 k Point Bag
	.dw entityScripts_69                ;    $98 2 k Point Bag
	.dw entityScripts_6a                ;    $99 4 k Point Bag
	.dw entityScripts_6b                ;    $9A 7 k Point Bag
	.dw entityScripts_6c                ;    $9B 10G Point Bag
	.dw entityScripts_6d                ;    $9C 1UP
	.dw entityScripts_6e                ;    $9D Big Heart
	.dw entityScripts_6f                ;    $9E Small Heart
	.dw entityScripts_70                ;    $9F 2x Multiplier
	.dw entityScripts_71                ;    $A0 3x Multiplier
	.dw entityScripts_72                ;    $A1 Fake Candle (can be useful glitch)


; Scripts_00, Scripts_15, Scripts_1f
; Scripts_54, Scripts_55, Scripts_56
	entityScripts_stub:
		.db $19, $00, $00, $00			; sc_stub


	entityPhaseFunc_19_stub:
		rts

; unused?
		.dw entityPhaseFunc_19_stub
		.dw entityPhaseFunc_19_stub


bank $1f
if expandPRG
bank $3f
endif
base $e000

org $e25f
	playSound:		

org $e86d
	jumpTablePreserveY: 

org $e7b6	
	func_1f_07b6:

org $ef5c 
	setEntitySpecGroupA_animationDefIdxY_animateNextFrame: 

org $ef75 
	updateEntityXanimationFrame:
	
org $fec8
	clearEntityHorizVertSpeeds:


;.macro sc_setEntityAIIdxTo0		; toDo find known function to lable them properly 
;    .if nargs == 1
;        .db $00 \1 $00 $00
;    .else
;        .db $00 $00 $00 $00
;    .endif
;.endm
;
;.macro sc_setStateNotMoving
;    .db $01 $00 $00 $00
;.endm
;
;.macro sc_setPhase
;    .db $04 \1 $00 $00
;.endm
;
;.macro sc_facePlayer
;    .db $05 $00 $00 $00
;.endm
;
;.macro sc_animateGroupAndDefIdx
;    .db $13 \1 \2 $00
;.endm
;
;.macro sc_setPhase0
;    .db $18 $00 $00 $00
;.endm
;
;.macro sc_stub
;    .db $19 $00 $00 $00
;.endm
;
;.macro sc_moveToPlayerSetHorizSpeeds
;    .db $1e \1>>8 \1&$ff $00
;.endm
;
;.macro sc_setAlarmOrStartYforSinusoidalMovement
;    .db $1f \1 $00 $00
;.endm
;
;.macro sc_incPhaseWhenAlarm0
;    .db $20 $00 $00 $00
;.endm
;
;.macro sc_end
;    .db $27 $00 $00 $00
;.endm
;
;.macro sc_setStateMoving
;    .db $2a $00 $00 $00
;.endm
;
;.macro sc_reverseHorizontally
;    .db $2b $00 $00 $00
;.endm
;
;.macro sc_setVertSpeedStartMoving
;    .db $39 \1>>8 \1&$ff $00
;.endm
;
;.macro sc_setStateNotIllusion
;    .db $53 $00 $00 $00
;.endm
;
;.macro sc_setStateIllusion
;    .db $54 $00 $00 $00
;.endm
;
;.macro sc_addOffsetsToXY
;    .db $62 \1 \2 $00
;.endm
;
;.macro sc_playSound
;    .db $6c \1 $00 $00
;.endm
;
;.macro sc_tryToFall
;    .db $6d $00 $00 $00
;.endm
;
;.macro sc_stub2
;    .db $72 $00 $00 $00
;.endm
;
;.macro sc_stub3
;    .db $75 $00 $00 $00
;.endm
;
;.macro sc_setGenericCounter
;    .db $7b \1 $00 $00
;.endm
;
;.macro sc_clearSpeeds
;    .db $97 $00 $00 $00
;.endm	