; http://www.romhacking.net/hacks/3596/


bank $1c
base $8000

org $834d						; rom addr 0x38348
		nop
		nop
		jsr func2 				; _bf66			

org $8421
	endAirControl:                 

org $834f
		jsr func2        	 	; $834f: 20 45 dc  


org $937b 
	processTrevorState:
		ldy $0565 				; wPlayerStateDoubled.w
		jsr $e886 				; jumpTableNoPreserveY

;-------------------------------------------------------------------------------

		dw playerState00_init						; 9381
		dw playerState02_standIdle					; 9383
		dw playerState04_walking_exceptGrant		; 9385
		dw playerState06_jumpStart_exceptGrant		; 9387

		dw jumpStateAirMovement						; vanilla dw playerState08_jumping_exceptGrant		; 9389 
		
		dw playerState0a_ducking_exceptGrant
		dw playerState0c_falling_exceptGrant
		dw playerState0e_walkToStair
		dw playerState10_startClimb
		dw playerState12_stairIdle
		dw playerState14_stairClimb
		dw playerState16
		dw playerState18_standingAttack_trevor_sypha
		dw playerState18_jumpAttack_trevor_sypha
		dw playerState1c_duckAttack_trevor_sypha
		dw playerState1e_stairAttack_exceptAlucard
		dw playerState20_standingItem
		dw playerState22_jumpingItem_exceptGrant
		dw playerState24_stairItem
		dw playerState26
		dw playerState28_2a
		dw playerState28_2a
		dw playerState2c
		dw playerState2e

org $8AC5
	playerState00_init:
org $9538
	playerState02_standIdle:
org $9660
	playerState04_walking_exceptGrant:
org $961D
	playerState06_jumpStart_exceptGrant:
org $9770
	playerState0c_falling_exceptGrant:
	playerState08_jumping_exceptGrant:
org $9919
	playerState0a_ducking_exceptGrant:

org $9953
	playerState0e_walkToStair:
org $9967
	playerState10_startClimb:
org $998E
    playerState12_stairIdle: 
org $9A93
    playerState14_stairClimb:
org $9942
    playerState16:
org $9418
    playerState18_standingAttack_trevor_sypha:
org $943A
    playerState18_jumpAttack_trevor_sypha:
org $9465
    playerState1c_duckAttack_trevor_sypha:
org $949E
    playerState1e_stairAttack_exceptAlucard:
org $94B8
    playerState20_standingItem:
org $94D4
    playerState22_jumpingItem_exceptGrant:
org $94FF
    playerState24_stairItem:
org $831C
    playerState26:
org $93B1
    playerState28_2a:
org $93B1
    playerState28_2a:
org $8B57
    playerState2c:
org $8ADE
    playerState2e:							; death

;-------------------------------------------------------------------------------

org $9389
		dw jumpStateAirMovement
	
org $943b
		dw playerState18_jumpAttack_11_body		; !!


org $94d4									
		jsr playerState18_jumpAttack_11_body	; jsr _bfc6 !!
org $9748									
		lda #$08								; $lda #$0c  make state to jump insted of falling 
org $974f									
		lda #$1c								; lda #$0c
org $9754									
		lda #$00								; lda #$01

org $9759										; $9760 J
		lda #$16								; falling off edge
		sta $400								; wOamSpecIdxDoubled.w
	_9765:
		lda #$00
		sta $509								; wEntityHorizSubSpeed.w
		rts
		db $ea, $ea, $ea, $ea, $ea				; NOP to be save?



org $9919										; $9920 J
		jsr _bfe9								; jsr $8421   			;playerState0a_exceptGrant_body?? better solutuion

org	$998e 										; $99a4 J
		jsr _bfcc									; lda $28 and #$40 		;jsr playerState12_14_body nop?? better solutuion 
		nop
org $9a93										; $9aab J				
		jsr _bfcc									; jsr $9a2d				;jsr playerState12_14_body nop?? better solutuion 
org $9c0a	;grant??							; $9c21 J	
		dw jumpStateAirMovement

;-------------------------------------------------------------------------------

bank $1d
base $a000
org $a5bc								
		dw jumpStateAirMovement
org $a6a2
;	__a6a2:        



;---------------- free space ---------------------------------------------------------------
bank $1e 
base $c000
;org $dc18			; orginal.. crash at boss..

org $df00
base $6100		 	; will go into SRAM    
	jumpStateAirMovement:
		lda #$97
		pha
		lda #$6f						; lda #$76  J   ;58
		pha
	_bf44:
		jsr _9765
		lda $28
		and #$03
		beq _bfc0
		lsr
		bcc _bf5c
		ldy #$00
		ldx #$01
		
		stx $4f2
		bpl _bf99
		lsr
		bcc _bfaa
	_bf5c:
		ldy #$01
		ldx #$ff
		stx $4f2
		jmp _bf99

	func2:						; _bf66:
		lda $565				; check for death state 
		cmp #$26
		beq _bf88 
		lda $4a
		beq _bf93
		lda $520
		bmi _bf88
		lda #$08
		sta $565
		lda $49
		beq _bf8b
		lda $48
		cmp #$02
		bne _bf8b
		lda #$38
		sta $5d8
		lda #$16
		sta $400
	_bf88:
		jmp _bf93
	_bf8b:
		lda #$1c
		sta $5d8

	_bf93:
		lda #$08
		ldy $4f2
		rts


	_bf99:
		lda $565
		cmp #$08
		bne _bfaa
		lda $400
		cmp #$10
		beq _bfaa
		sty $4a8
	_bfaa:
		lda $28
		and #$80
		bne _bfaa_end
		lda $520
		bpl _bfaa_end
		lda #$1c
		sta $5d8
		lda #$00
		sta $520
	_bfaa_end:
		rts
	_bfc0:
		sta $4f2
		jmp _bfaa

	playerState18_jumpAttack_11_body:		
		jsr _bf44
		jmp $979c					; whip in air
	_bfcc:
		lda $26
		and #$80
		beq _bfcc_stair
		lda #$06
		sta $565
		pla 
		pla 
		rts 
	_bfcc_stair:
		lda $565
		cmp #$14
		beq  _bfcc_stair2
		lda $28
		and #$40
		rts
	_bfcc_stair2:
		jmp $9a2d					; stair
	_bfe9:
		lda $28
		lsr
		bcc duckState
		ldx #$00
		stx $4a8
	duckState:
		lsr
		bcc duckState2
		ldx #$01
		stx $4a8
	duckState2:
		jmp endAirControl					; duckState


