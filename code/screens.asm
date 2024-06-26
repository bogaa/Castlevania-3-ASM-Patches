{	 	; clearCompressedScreens											
bank $05                                                       ;0FEC77|        |0FEC9D; 00	title b570 	
base $a000                                                      			
org $b570		; clean_RLE_tilemap_01_titleScreen              			
pad $b6ca,$ff                                                   			

bank $19                                                        ;0FEC83|        |0CABA8; 0c  map 32ba8 
base $a000                                                      			  
org $aba8		  			 
pad $ad7b,$ff                                                   			

bank $0b                                                        ;0FEC85|        |05BA68; 0e map 0 17a68 
base $a000                                                      			  
org $ba68		  			 
pad $bbbb,$ff																		

bank $0b                                                        ;0FEC87|        |05B9FA; 10 map 1 179fa
base $a000                                                      			  
org $b9fa		  			 
pad $ba5b,$ff																		

bank $0b                                                        ;0FEC89|        |05BA5C; 12 map 2 17a5c
base $a000                                                      			  
org $ba5c		  			 
pad $ba67,$ff																																							

bank $0b                                                        ;0FEC8B|        |05BBBC; 14 map 3 17bbc
base $a000                                                      			  
org $bbbc		  			 
pad $bbc0,$ff	

bank $09                                                        ;0FEC8D|        |04BAD4; 16  prayer 13ad4
base $a000                                                      			  
org $bad4		  			 
pad $bde9,$ff

bank $03                                                         ;0FEC8F|        |01B9A6; 18  name 79a6
base $a000                                                      			  
org $b9a6		  			 
pad $bc8c,$ff

bank $19                                                          ;0FEC91|        |0cB327; 1a 	PW 33327
base $a000                                                      			  
org $b327		  			 
pad $b674,$ff

bank $0b                                                         ;0FEC93|        |05B839; map 1c 17839
base $a000                                                      			  
org $B839		  			 
pad $b9f9,$ff

bank $19                                                         ;0FEC95|        |0CAD7C; 1e castle intro 32d7c
base $a000                                                      			  
org $AD7C		  			 
pad $afae,$ff

bank $15                                                         ;0FEC97|        |0ABDFA; 20 ending 2bdfa
base $a000                                                      			  
org $BDFA		  			 
pad $bff3,$ff

bank $1e                                                        ;0FEC99|        |0FD772; 22 ending 3d772
base $c000                                                      			  
org $D772		  			 
pad $d928,$ff

bank $15                                                       ;0FEC9B|        |0ABA9A; 24 ending 2ba9a
base $a000                                                      			  
org $BA9A		  			 
pad $babf,$ff


; layout --------------
;PRG 	NES			SNES BANK 	 SNES ROM					
;00000 	bank 0-1 	= BANK 00 	 offset $0000  		base $8000 	
;0e000 	bank 7		= BANK 00 	 offset $4000		base $C000 	
;04000 	bank 2-3	= BANK 01 	 offset $8000		base $18000	
;08000 	bank 4-5	= BANK 02 	 offset $10000		base $28000	
;0c000 	bank 6		= BANK 03 	 offset $18000		base $38000	
;10000 	bank 8-9	= BANK 04 	 offset $20000		base $48000	
;14000 	bank a-b	= BANK 05 	 offset $28000 		base $58000	
;18000 	bank c-d	= BANK 06 	 offset $30000		base $68000	
;1c000 	bank e-f	= BANK 07 	 offset $38000		base $78000	
;20000 	bank 10-11	= BANK 08 	 offset $40000		base $88000	
;24000 	bank 12-13	= BANK 09 	 offset $48000		base $98000	
;28000 	bank 14-15	= BANK 0a 	 offset $50000		base $a8000	
;2c000 	bank 16-17	= BANK 0b 	 offset $58000		base $b8000	
;30000 	bank 18-19	= BANK 0c 	 offset $60000		base $c8000	
;34000 	bank 1a-1b	= BANK 0d 	 offset $68000		base $d8000	
;38000 	bank 1c-1d	= BANK 0e 	 offset $70000		base $e8000	
;3c000 	bank 1e		= BANK 0f 	 offset $78000		base $f8000	
;3e000 	bank 1f		= BANK 0f 	 offset $7e000      base $fe000

}                                                               			

{		; hijacks and bank managing                             			
bank $3f		; former 1f lastbank                            			
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
		lda #$a2			; start load routine hijack 
		JSR swapPRGbank
	
		jsr costumScreenLoad	
	
	endCostumScreenLoad:
		jsr swapPRGbank
		jmp $ed66			; ec74	

	
	bank00_screenClear:		; screenLoadFixes 
		lda #$e4
		sta $5105
		ldx #$00 
	
	bank00_screenLoad:	
		lda #$80
		sta $02		
		lda #$a2
		JSR swapPRGbank
		jsr mapLoadChecks
		
		jsr costumScreenLoadNoBank
		jmp endCostumScreenLoad

	screenLoadIntroPlays: ; keep letter fragments
		phx
		ldx #$02
		lda #$82
		sta $02 
		jsr loadCompressedTilemap2GFX
		
		plx 
		jmp $b7c7

;	LoadTilemapWithReturnBankInA:		; theHELL FIXME!!
;		sta $02 
;		lda #$a2			; start load routine hijack 
;		JSR swapPRGbank	
;		jsr costumScreenLoadNoBank	
;		jsr swapPRGbank		
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
pad $ECDB,$ff 	; mark free space gained 


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

bank #$05			
base $a000 
org $b74d			; keep letter fragments	
	jmp screenLoadIntroplays
;org $b6ca 		; the hell?!! FIXME
;	php
;	lda #$85
;	ldx #$02
;	jsr LoadTilemapWithReturnBankInA 
;	
;	plp
;	rts 
;pad $b7e1,$ff 


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
	
}


{		; new bank with decompressed screens 
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
		db $00,$00,$26,$00 
		db $00,$2a,$00,$26 
		db $26,$00,$00,$00 
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

}