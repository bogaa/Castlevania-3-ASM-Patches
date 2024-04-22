bank $00
base $8000
org $9e20
	jsr bank00_screenClear


bank $01
base $a000
org $a60d				; $260d
		ldx #$0c        ; bank to use for map nametable data

org $a194 
	jsr bank00_screenClear
org $a1b9 
;	jsr failRestorePRG
;	nop 3
;	jsr loadMapTower
	jsr bank00_screenLoad

org $a5d9 
	jsr bank00_screenClear
org $a9ea  
	jsr bank00_screenClear

;bank $03
;base $a000
;org $a85b
;	jsr bank02_screenClear
;org $a865
;	jsr bank02_screenLoad

bank $15
base $a000 
org $b1c2 
	jsr bank14_load
org $b32e 
	jsr bank14_load
org $b44c 
	jsr bank14_load
org $b459 
	jsr bank14_load
org $b6eb
	jsr bank14_load
	
bank $3f				; former 1f bank 
base $e000
org $E182
	setPPU2_Load:
org $EBD5
	backupPRGSwap:
org $E2E6	
	swapPRGbankStore:
org $E2E8
	swapPRGbank:
org $E899
	updatePointerOffset_00:


org $edb5
	screenLoadRoutine01:
org $ebff
	clearScreenRoutine:
		STA $5105    
		LDX #$00     
	loadCompressedTilemap2GFX:		
		lda #$a2	; start load routine hijack 
		JSR swapPRGbank
	
		jsr costumScreenLoad	
	
	endCostumScreenLoad:
		jsr swapPRGbank
		jmp $ed66		; ec74	

	
	bank00_screenClear:			; screenLoadFixes 
		lda #$e4
		sta $5105
		ldx #$00 
	
	bank00_screenLoad:	
		lda #$80
;	bank00_screenLoadWithBankInA:
		sta $02
		
		lda #$a2
		JSR swapPRGbank
		jsr mapLoadChecks
		
		jsr costumScreenLoadNoBank
		jmp endCostumScreenLoad
	
;	loadMapTower:
;		ldx #$26 
;		jsr bank00_screenLoad		
;		rts 
	

	bank14_load:
		txa
		and #$fe 
		tax 
		
		lda #$94
		sta $02
		
		lda #$a2
		JSR swapPRGbank
		
		jsr costumScreenLoadNoBank
		jmp endCostumScreenLoad 
	
	padbyte $ff 	; mark free space gained 
	pad $ECDB

;org $ebf7 
;		nop 03

bank $22
org $8000
base $8000
	costumScreenLoad:		
;		LDA bankReturScreenLoad,X
		lda #$82
		sta $02
	
	costumScreenLoadNoBank:	
		LDA compressScreenTilemapPointerLo,X
        STA $00                          
        LDA compressScreenTilemapPointerLo+1,X
        STA $01                           
        JSR setPPU2_Load                  
        LDA #$00                          
        STA wScrollX                      
        STA wScrollY                     
		
		LDA $2002        
        LDY #$01         
        LDA ($00),Y      
        beq clearLoop
		STA $2006        
        DEY                
        LDA ($00),Y      
        STA $2006        
	
		lda #$02
		ldx #$00
		jsr updatePointerOffset_00
		
		lda #$03		; size counter 0x400 byte		
		sta $03
	--	ldy #$00
	
	-	lda ($00),y 
		sta $2007
		iny
		bne -	
		dec $03
		bmi endCostumLoad
		inc $01
		jmp --
	
	
	endCostumLoad:
		lda $02
		rts 
	
	clearLoop:
		ldy #$00
		lda #$08
		sta $03
		
		lda #$20
		sta $2006
		lda #$00
		sta $2006

	-	sta $2007
		iny 
		bne -
		dec $03
		bpl -
		jmp endCostumLoad


	--	ldx wCurrRoomGroup
		lda roomNumberMapsSecondLoad,x 
		tax 
		rts  
	
	-	ldx wCurrRoomGroup
		lda roomNumberMaps,x 
		tax 
		rts 
	
	roomNumberMaps:
		db $0c,$26,$26,$26 ; ldx #$28 
		db $26,$26,$26,$26
		db $26,$0c,$2a,$2a
		db $2a,$2a,$2a,$2a
	roomNumberMapsSecondLoad:
		db $00,$00,$00,$00 
		db $00,$2a,$00,$26 
		db $00,$00,$00,$00 
		db $00,$00,$00,$00 
	
	mapLoadChecks:
		lda $10
		cmp #$04
		beq --
		cmp #$05
		beq ++	
		cmp #$06
		beq -
		cmp #$0a
		beq +
		cmp #$0b
		beq ++
		
		ldx #$00 	; clear 
		rts 
		
	+   ldx #$28		
		rts 
	++	ldx #$14
		rts 

	compressScreenTilemapPointerLo: 
		dw RLE_tilemap_00_clearScreen        ;0FEC77|        |0FEC9D; 00
        dw RLE_tilemap_01_titleScreen        ;0FEC79|        |02B570; 02
        dw RLE_tilemap_00_clearScreen        ;0FEC7B|        |0FEC9D; 04
        dw RLE_tilemap_00_clearScreen        ;0FEC7D|        |0FEC9D; 06
        dw RLE_tilemap_00_clearScreen        ;0FEC7F|        |0FEC9D; 08
        dw RLE_tilemap_00_clearScreen        ;0FEC81|        |0FEC9D; 0a
        dw RLE_tilemap_map00_06              ;0FEC83|        |0CABA8; 0c  
        dw RLE_tilemap_mapX1_07              ;0FEC85|        |05BA68; 0e  
        dw RLE_tilemap_mapX2_08              ;0FEC87|        |05B9FA; 10 
        dw RLE_tilemap_mapX3_09              ;0FEC89|        |05BA5C; 12
        dw RLE_tilemap_mapX4_0a              ;0FEC8B|        |05BBBC; 14
        dw RLE_tilemap_0b_prayerScreen       ;0FEC8D|        |04BAD4; 16
        dw RLE_tilemap_0c_nameScreen         ;0FEC8F|        |01B9A6; 18
        dw RLE_tilemap_0d_PWscreen           ;0FEC91|        |01B327; 1a
        dw RLE_tilemap_mapX0_0e              ;0FEC93|        |05B839; 1c
        dw RLE_tilemap_0f_castleIntro        ;0FEC95|        |0CAD7C; 1e
        dw RLE_tilemap_10_ending00           ;0FEC97|        |0ABDFA; 20
        dw RLE_tilemap_10_ending01           ;0FEC99|        |0FD772; 22
        dw RLE_tilemap_10_ending02           ;0FEC9B|        |0ABA9A; 24
		dw FIX_mapAttributes										; 26		
		dw FIX_tilemap_mapX3_09										; 28 
		dw FIX_tilemap_TopLeft										; 2a 	


padbyte $ff 
pad $8170
	db "clearScreen"
pad $817e	
	RLE_tilemap_00_clearScreen:   
		dw $0000


	db "titleScreen"
pad $819e 	
	RLE_tilemap_01_titleScreen:   
		dw $2000
		incbin .gfx/screens/01_titleScreen.nam


	db "map 1 colWind"
pad $85ae 			  
	RLE_tilemap_map00_06:   
		dw $2000
		incbin .gfx/screens/06_map0.nam


	db "unused"
pad $89be 	
	RLE_tilemap_mapX1_07:
	RLE_tilemap_mapX2_08:
	RLE_tilemap_mapX0_0e: 	
		dw $0000		

	db "map 2 top "
pad $89de 
	RLE_tilemap_mapX3_09:  
		dw $2800
		incbin .gfx/screens/0e_map2_top.nam


	db "map top right"
pad $8dee			 
	RLE_tilemap_mapX4_0a:  
		dw $2400
		incbin .gfx/screens/0e_map2_bottom.nam


	db "prayer screen"
pad $91fe
	RLE_tilemap_0b_prayerScreen: 
		dw $2000
		incbin .gfx/screens/0b_prayerScreen.nam


	db "name screen"
pad $960e		
	RLE_tilemap_0c_nameScreen:  
		dw $2000
		incbin .gfx/screens/0c_nameScreen.nam


	db "password screen"
pad $9a1e		
	RLE_tilemap_0d_PWscreen:    
		dw $2000
		incbin .gfx/screens/0d_PWscreen.nam


	db "intro Castle"
pad $9e2e	        
	RLE_tilemap_0f_castleIntro:   
		dw $2000
		incbin .gfx/screens/07_intro.nam


	db "ending Castle "
pad $913e		
	RLE_tilemap_10_ending00:    
		dw $2000
		incbin .gfx/screens/10_ending.nam	


	db "ending title"
pad $954e	
	RLE_tilemap_10_ending01:      
	RLE_tilemap_10_ending02:  
		dw $2800
		incbin .gfx/screens/12_ending.nam	


	db "map 2 top r"
pad $995e
	FIX_tilemap_TopLeft:
		dw $2400
		incbin .gfx/screens/26_mapTopRight.nam 


	db "map 1 Attribute"
pad $9c6e	
	FIX_mapAttributes
		dw $2000
		incbin .gfx/screens/06_map0_atriFix.nam


	db "map 2 top "
pad $9f7e		
	FIX_tilemap_mapX3_09:  
		dw $2000
		incbin .gfx/screens/0e_map2_top.nam	

