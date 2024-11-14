bank $00
base $8000	

org $9730
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
	
	
org $843D
    collusioBitLo: 
		dw no_col    					; 44 cross 
        dw collusion_45     			; 45
        dw no_col     					; 46 churge window
        dw collusion_47     			; 47
        dw no_col     					; 48 houses
        dw collusion_49   				; 49 clock tower
        dw collusion_4a					; 4A clock tower big gear
        dw no_col  						; 4B woods 
        dw no_col  						; 4C sympha 
        dw collusion_4d   				; 4D crusher
        dw no_col  						; 4E ship and coffine
        dw no_col  						; 4F swamp
        dw collusion_49   				; 50 ship window pillars 
        dw no_col  						; 51 coffine open
        dw no_col  						; 52 statue 
        dw collusion_53   				; 53 outer wall 
        dw collusion_54   				; 54 water gear animation 00
        dw collusion_54   				; 55 water gear animation 00
        dw collusion_54   				; 56 water gear animation 00
        dw collusion_57   				; 57 sewers
        dw no_col  						; 58 swamp mountains
        dw collusion_59   				; 59 swamp robes
        dw collusion_5a   				; 5A swamp floor with sprite mud man 
        dw no_col  						; 5B cave
        dw no_col  						; 5C alucard 
        dw collusion_5D   				; 5D crypt
        dw no_col  						; 5E aquaduct
        dw no_col  						; 5F aquabridge
        dw collusion_60   				; 60 aqua pillar 
        dw no_col  						; 61 crypt frank 
        dw collusion_62   				; 62 crypt slulls
        dw no_col  						; 63 crypt tower 
        dw collusion_64   				; 64 red tower spikes 
        dw collusion_65   				; 65 sunset bridge 
        dw collusion_66   				; 66 castle exterior
        dw no_col  						; 67 cave spider web
        dw collusion_68   				; 68 lake mountains 
        dw collusion_68   				; 69 torture wall 
        dw no_col  						; 6A big moon 
        dw collusion_6b   				; 6B finall 
        dw no_col  						; 6C armore
        dw collusion_6d   				; 6D castlevania
        dw collusion_6e   				; 6E konami 
 
    cullusion_CHR_33_36_37: ; bossDracBottomFeet, secondQuest sprite, ABC puls candles
		dw collusion_33      
        dw collusion_33      
        dw collusion_33      
							; 2 = convior right 
							; 3 = convior left 
							; 4 = crumble Block
							; 5 = spike 
							; 6 = ground 
							; 8 = ground 
	
	no_col:					; 0 1 7...crash! 
		db $08,$80  		; type, startPos (when uneven number a other table follows)	                      
 
    collusion_33: 
		db $06,$BC
		db $02,$C0                
 
    collusion_6e: 
		db $06,$7B
		db $02,$80                
 
    collusion_45: 
		db $06,$7E
		db $02,$80                
 
    collusion_47: 
		db $06,$B7
		db $02,$C0                
 
    collusion_4a: 
		db $06,$B9
		db $02,$C0                
 
    collusion_4d: 
		db $06,$B8
		db $02,$C0                
 
    collusion_49: 
		db $04,$B8
		db $02,$B9
		db $02,$C0                            
 
    collusion_53: 
		db $06,$7A
		db $02,$80                
 
    collusion_54: 
		db $06,$7C
		db $02,$80                
 
    collusion_57: 
		db $02,$B6
		db $01,$B7
		db $03,$B8            
        db $02,$C0                    
 
    collusion_59: 
		db $06,$78
		db $02,$80                
 
    collusion_5a: 
		db $01,$B8
		db $05,$BA
		db $02,$C0             

    collusion_5D: 
		db $04,$B2
		db $02,$B4
		db $02,$c0            

    collusion_60: 
		db $04,$BA
		db $02,$BB
		db $02,$C0            
 
    collusion_62: 
		db $06,$A0
		db $02,$C0                
 
    collusion_64: 
		db $06,$B8
		db $02,$C0                
 
    collusion_65: 
		db $06,$7C
		db $02,$80                
 
    collusion_66: 
		db $04,$B8
		db $02,$B9
		db $02,$C0                                    
 
    collusion_68: 
		db $04,$B2
		db $02,$B3
		db $02,$C0             

    collusion_6b: 
		db $04,$B7
		db $02,$B8
		db $02,$C0                                        
 
    collusion_6d: 
		db $06,$B8
		db $02,$C0                

bank $1e
base $c000
org $D3D9
    secondCHR_C00_3rdSlot: 
		CMP.B #$DC                          
        BEQ A_spikeTileTop                     
        CMP.B #$DD                          
        BEQ A_spikeTileTop                     
        CMP.B #$DE                          
        BEQ A_spikeTileFloor                     
        CMP.B #$DF                          
        BEQ A_spikeTileFloor                     
        CMP.B #$E4                          
        BEQ A_flooTile                     
        CMP.B #$E5                          
        BEQ A_flooTile                     
        RTS                                 
 
    A_spikeTileFloor: 
		LDY.B #$07                          
        RTS                                 
 
    A_spikeTileTop: 
		LDY.B #$05                          
        RTS                                 
 
    A_flooTile: 
		LDY.B #$00                          
        RTS                                 