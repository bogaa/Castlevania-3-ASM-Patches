
; ----------------------------------------------------
if subWeaponDrop
    bank $17
	base $a000
    org $a0ad
        ; collecting item on ground
        jsr dropRoutine
        nop 3

    org $a059
        ; collecting item in air
        jsr dropRoutine
        nop 3
        nop 6


bank $1e
base $c000
org $dc19   ; start of blank space

    dropRoutine:
        popX = $1e              ; how far to pop out item horizontally
        popY = $08              ; how far to pop out item vertically
        popY = $18

;        lda $1234				; ??
        lda wOamSpecIdxDoubled, x	; $400
        cmp #$24                ; points bag
        beq destroyItem
        cmp #$0e                ; heart
        beq destroyItem2

        ldy wCurrCharacterIdx   ; weapon slot to use $3b
        lda $85, y              ; get current sub weapon
        pha
        
        jsr $a0fc               ; get the item
        
        ldy wCurrCharacterIdx   ; weapon slot to use $3b
        lda wCurrSubweapon, y   ; get current sub weapon again $85
        sta $10                 ; store in temp address
        
        pla                     ; get original weapon
        beq noItem              ; if none, skip ahead
        cmp $10                 ; compare to new weapon
        beq noItem              ; if they match, skip ahead
        
        tay
        lda dropTable, y
        
        sta wCurrPlayer, x		; $54e
        sec
        sbc #$60
        sta $5ef, x
        
        ; set a bunch of stuff for the item to look right
        ; this is mostly taken from 0b:831d
        lda wCurrPlayer, x					; $54e
        sec
        sbc #$93
        tay
        lda $8333, y
        sta wEntityOamSpecGroupDoubled, x 	; $48c
        lda $8353, y
        sta wOamSpecIdxDoubled, x	    	; $400
        
        ; y pos
        lda wEntityBaseY, x		; $41c, x
        sec
        sbc #popY
        sta wEntityBaseY, x		; $41c, x
        
        lda wEntityFacingLeft	; $4a8         
        bne popItemRight
        
    popItemLeft:
        ; x pos
        lda wEntityBaseX, x		; $438, x
        sec
        sbc #popX
        sta wEntityBaseX, x		; $438, x
        jmp donePopItem

    popItemRight:
        ; x pos
        lda wEntityBaseX, x		; $438, x
        clc
        adc #popX
        sta wEntityBaseX, x		; $438, x

    donePopItem:
        lda #$02                ; set item state to collectable
        sta wEntityPhase, x		; $5c1, x
        rts
    
    noItem:
        lda #$04
        sta wEntityPhase, x		; $5c1, x
;        inc $5c1, x             ; increment item state
        rts
        
    destroyItem2:
        lda #$05
        db $2c                  ; bit opcode trick
    destroyItem:
        lda #$04
        sta wEntityPhase, x		; $5c1, x
        jsr $fec8               ; helps remove the object (normally only on air collecting)
        jsr $a0fc               ; helps remove the object
        rts

    dropTable:					 ; table mapping held item to dropped item value       
        db $00, $93, $94, $95, $96, $98, $99, $9a
        db $95, $93, $00, $97
endif

; ----------------------------------------------------

bank $00
base $8000
	if fastCharacterSwap
		org $94ac
			lda #$1e	;sound ;47
		org $94b4
			lda #$01  	;countDown
		org $94cf	
			lda #$01	;countDown
		org $9698
			lda #$05	;countDown
		org $966a
			lda #$01	;countDown vertical sections
	endif

; ----------------------------------------------------

if allCharacters
org $95f7
	jsr rotateCharacters
	nop
	
bank $01
base $a000	
org $bec0
	rotateCharacters:
		lda $3a
		clc
		adc #$01
		cmp #$04
		bne +
		lda #$01
	+
		sta $3a
	
		LDA $3B                  
		EOR #$01                 
		rts
;    switchCharacter:
;        lda $3a
;        cmp #$ff
;        bne +
;        lda #$01
;    +
;        sta $39
;        
;        inc $3a
;        lda $3a
;        cmp #$04
;        bne +
;        lda #$00
;        sta $3a
;    +
;        lda $3b
;        ora #$01
;        sta $3b
;
;        lda #$99
;        sta $84
;        
;        lda #$15
;        jsr $e25f
;        rts




bank $00
org $8af1
		lda #$01			; empty on debugg screen

bank $03
base $a000	
org $b05d
		lda #$01			; default start replace FF for no character
endif


; ----------------------------------------------------
bank $1f
if expandPRG
bank $3f
endif
base $E000
org $E252 
		LDA #$98          	; music engine bank
		JSR prgBankSwitchWithBackup  
		JSR $89DE   	   	; music Routine. Not SFX..             	

org $e2e6    
	prgBankSwitchWithBackup: 
		STA $21		
	prgBankSwitch:			; games prgSwapRoutine 
		STA $5115 
		RTS

; ----------------------------------------------------
if fastLunch
	org $e386
		dw $e50a				; pointer replacement Prayer screen to game start 
	org $e41b	 
		LDA #$01     			; title screen count down till it starts            
endif	
; ----------------------------------------------------
if fastDoor
    doorSpeed = $02
    org $fb6c
        adc #doorSpeed

    org $f9cb
        sbc #doorSpeed

    org $fa00
        ; wait time for door to open
        lda #$10

    org $faa2
        ; wait time for door to close
        lda #$28
endif




	org $f384
	if addSRAM
		jsr beforePause
	endif 
		
	org $f6b4
	if addSRAM
		jsr whilePause  	      
		nop
		BEQ +                
		LDA #$00                 
		STA $2B  		
	+	
		RTS  
	endif
	
; ----------------------------------------------------	
bank $1e
base $c000	
org $de00	
base $6000					; This section goes to SRAM when start or reset

	
	beforePause:			; you can write any routine that should always run in game mode					
		if expandPRG
		lda #$a0
		jsr prgBankSwitch
		endif
		
		if experiment
		jsr checkRamPage
		endif 

		if CHRparallex
		jsr newParalexScroll
		endif

		if expandPRG
		lda $21 
		jsr prgBankSwitch
		endif
				
		jsr $f683			; jijack Fix pause check..
		rts 
	
	whilePause:				; you can write any routine after here that should run while pause
		if expandPRG
		lda #$a0
		jsr prgBankSwitch
		endif
		
		if levelSelect	
		jsr levelSelectDebuggScreen
		endif


		if cheats		
		jsr backupRestorePlayerState	; check if you like to copy stats to practice faster		
		jsr getItemWhiteAB
		endif			
		
		if expandPRG
		lda #$21
		jsr prgBankSwitch
		endif

		LDA $F8      					; hijack fix  check to unpause        
		AND #$10 
		rts		

if expandPRG
bank $20
base $8000
org $8000
endif

	if cheats
		getItemWhiteAB:
			;lda $fa					; skip not holding select
			;and #$20
			;beq endGetItem
			phx 
			lda $f8
			and #$40
			beq ++
			lda $87
			clc 
			adc #$01
			cmp #$03
			bne +
			lda #$00				; reset upgrade
		
		+	sta $87					; we just upgrade helper and Trevor..
			sta $88
			jsr updateSpritesMulti
			
			lda #$40				; also give hearts
			sta $84
			
		++	lda $f8
			and #$80
			beq endGetItem
			lda $85
			clc
			adc #$01
			cmp #$0c
			bne +
			lda #$00
			
		+	sta $85
			sta $86
			jsr updateSpritesSubw

		endGetItem:
			plx 
			rts 
	
		backupRestorePlayerState:
			lda $26
			cmp #$02
			beq copyPlayerStats
			cmp #$01
			beq savePlayerStates
			rts
		copyPlayerStats:	
			ldy #$0b
		-
			lda $84,y
			sta $6200,y
			dey 
			bne -
			lda $3b					; player ID used for upgrades resived
			sta $6200
			rts
		savePlayerStates:
			ldy #$0b
		-
			lda $6200,y
			sta $84,y
			dey 
			bne -
			lda $6200
			sta $3b
			rts	
		endif	
	
	if levelSelect
		levelSelectDebuggScreen:
			lda $fa
			and #$10
			beq endLevelSelect	; check hold start 
			lda $f8	
			and #$20			; check select
			beq	endLevelSelect
			lda #$07
			sta $18
			lda #$00
			sta $19	
		endLevelSelect:
			rts 
	endif	
	
	if CHRparallex
		newParalexScroll:
			lda $7d					; read ram effect table
			cmp #$1f				
			bne +
			
			lda $56					; read loScrollOffset
			lsr						; make it a max 16 bamls 
			lsr
			lsr
			lsr 
			tax
			lda animParlX,x 		; read current offset and store to bank update table 
			sta $4b 
			
		+	rts 
	
		animParlX:
			db $54,$55,$56,$54
			db $55,$56,$54,$55
			db $56,$54,$55,$56
			db $54,$55,$56,$54       
	
	endif 

		updateSpritesMulti:
			tax
			lda MultiplayerSpriteID,x 
			sta $419
			lda #$0e
			sta $4a5
			rts 
		updateSpritesSubw:
			tax
			lda SubWeaponSpriteID,x 
			sta $418
			lda SubWeaponSpriteBankID,x 
			sta $4a4
			
			lda #$24		; fix XY pos 
			sta $434
			lda #$90
			sta $450
			
			rts 
		MultiplayerSpriteID:
			db $00,$58,$5a 
		SubWeaponSpriteID:
			db $00,$46,$42,$4E,$50,$52,$54,$4E,$4E,$46,$50,$68 
		SubWeaponSpriteBankID:
			db $00,$00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$0E	

if experiment			
		checkRamPage:
			lda $f8
			and #$40
			beq +
			
;			lda #$23
;			jsr playSound
			
		+	lda wInGameSubstate  ; 2a 
			
			lda OAMDMA
			lda NAMETABLE_MAPPING
			
			
			lda w190 								
			
			lda w0d1
			lda wCurrInstrumentDataAddr ;e0
			lda wFreqAdjustFromEnvelope ; e2
			lda wSoundBankTempVar1 	;e4
			
			lda w3cc
			lda wEntityOamSpecIdxBaseOffset	; 593
			lda w7f7    							; dsb $800-$7f7
			
			
		spriteViewer:	
			lda $f8
			and #$40
			beq +
	
			inc $7000
			inc $7000
			
			lda $7000
			sta $418
	
			lda #$54							; fix XY pos 
			sta $434
			lda #$90
			sta $450			
			
		+	lda wJoy1NewButtonsPressed2			; $f8
			and #$80
			beq ++
			inc $7001							; go next pointer
			inc $7001
			
			lda $7001		
			cmp #$1e
			bne +
			lda #$00 
			sta $7001
		+	sta $4a4
			
		++	lda wJoy1NewButtonsPressed2			; reset pointer 
			and #$20
			beq +
			lda #$0000
			sta $7000			; table 
			sta $7002			; CHR 
					
		+	lda wJoy1NewButtonsPressed2			; change CHR 
			and #$08
			beq +
			lda $7002

			sta CHR_BANK_0800
			clc
			adc #$01
			sta CHR_BANK_0c00
;			clc
;			adc #$02
;			sta CHR_BANK_0800_1800
;			clc
;			adc #$02
;		
;			sta CHR_BANK_0c00_1c00
;			clc
;			adc #$02			
			
			sta $7002
			cmp #$37
			bne +
			lda #$08
			sta $7002
		+	lda wJoy1NewButtonsPressed2		; change CHR 
			and #$04
			beq +
			lda $7002
			sec
			sbc #$02
			sta $7002
			sta CHR_BANK_0800
			clc
			adc #$01
			sta CHR_BANK_0c00
		+	rts 
endif 			