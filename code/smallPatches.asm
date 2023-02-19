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

        lda $1234
        lda $400, x
        cmp #$24                ; points bag
        beq destroyItem
        cmp #$0e                ; heart
        beq destroyItem2

        ldy $3b                 ; weapon slot to use
        lda $85, y              ; get current sub weapon
        pha
        
        jsr $a0fc               ; get the item
        
        ldy $3b                 ; weapon slot to use
        lda $85, y              ; get current sub weapon again
        sta $10                 ; store in temp address
        
        pla                     ; get original weapon
        beq noItem              ; if none, skip ahead
        cmp $10                 ; compare to new weapon
        beq noItem              ; if they match, skip ahead
        
        tay
        lda dropTable, y
        
        sta $54e, x
        sec
        sbc #$60
        sta $5ef, x
        
        ; set a bunch of stuff for the item to look right
        ; this is mostly taken from 0b:831d
        lda $54e, x
        sec
        sbc #$93
        tay
        lda $8333, y
        sta $48c, x
        lda $8353, y
        sta $400, x
        
        ; y pos
        lda $41c, x
        sec
        sbc #popY
        sta $41c, x
        
        lda $4a8                ; facing direction
        bne popItemRight
        
    popItemLeft:
        ; x pos
        lda $438, x
        sec
        sbc #popX
        sta $438, x
        jmp donePopItem

    popItemRight:
        ; x pos
        lda $438, x
        clc
        adc #popX
        sta $438, x

    donePopItem:
        lda #$02                ; set item state to collectable
        sta $5c1, x
        rts
    
    noItem:
        lda #$04
        sta $5c1, x
;        inc $5c1, x             ; increment item state
        rts
        
    destroyItem2:
        lda #$05
        db $2c                  ; bit opcode trick
    destroyItem:
        lda #$04
        sta $5c1, x
        jsr $fec8               ; helps remove the object (normally only on air collecting)
        jsr $a0fc               ; helps remove the object
        rts

    dropTable:
        ; table mapping held item to dropped item value
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

bank $00
org $8af1
		lda #$01			; empty on debugg screen

bank $03
base $a000	
org $b05d
		lda #$01			; default start
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
	
; ----------------------------------------------------
if fastLunch
	org $e386
		dw $e50a				; pointer replacement Prayer screen to game start 
	org $e41b	 
		LDA #$01     			; title screen count down till it starts            
endif	


org $e2e6    
	prgBankSwitchWithBackup:
		STA $21		
	prgBankSwitch:	
		STA $5115 
		RTS


; ----------------------------------------------------
if whilePauseRoutines
	org $f384
		jsr beforePause

	org $f6b4
		jsr whilePause  	; whilePauseHijack           
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


if whilePauseRoutines		
	beforePause:			; you can write any routine that should always run in game mode
	if cheats	
		jsr getItemWhiteAB
	endif	
		
		jsr $f683			; jijack Fix pause check..
		rts 

	whilePause:				; you can write any routine after here that should run while pause
endif

	if levelSelect	
		jsr levelSelectDebuggScreen
	   endLevelSelect:
	endif

	if cheats		
		jsr backupRestorePlayerState	; check if you like to copy stats to practice faster		
	endif	

if whilePauseRoutines
	endWhilePause:
		LDA $F8      					; hijack fix  check to unpause        
		AND #$10 
		rts		
endif


if cheats
	getItemWhiteAB:
		lda $fa					; skip not holding select
		and #$20
		beq endGetItem
		
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
		lda #$40
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
	endGetItem:
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
		rts 
	endif	