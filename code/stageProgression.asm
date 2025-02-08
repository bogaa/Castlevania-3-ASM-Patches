bank $00
base $8000	
org $9244
	progressionLookUp_map: 
		db $00,$00,$00,$00	; stage, block, room, new index 
		db $01,$02,$02,$01              
		db $01,$05,$00,$02
		db $02,$04,$00,$03
		db $03,$04,$01,$04
		db $04,$02,$02,$05             
		db $05,$03,$00,$06             
		db $06,$02,$00,$07
		db $07,$04,$01,$08
		db $07,$06,$00,$09
		db $08,$04,$00,$0A
		db $09,$01,$02,$0B             
		db $0A,$06,$02,$0C
		db $0B,$02,$00,$0D
		db $0C,$02,$00,$0E
		db $0D,$03,$01,$0F
		db $FF,$00,$00,$00   

org $A11D	
	progressionTableMap: 
		db $00,$00,$00     	; stage, block, room 
		
		db $01,$03,$02		; grant tower 				
		db $02,$01,$00		; woods 
		db $03,$00,$02  	; ghost ship
		db $04,$00,$00		; red tower 
		db $05,$00,$00  	; water bridge dragons 
		db $0B,$00,$00		; bridge aquarius 
		
		db $07,$00,$01 		; alucards cave
		db $07,$05,$00  	; alucards path
		db $09,$00,$00		; franks cave
		db $0A,$00,$00		; endless raising tower 
		db $0A,$00,$00
		
		db $0C,$00,$00		; death stage 
		db $0C,$00,$00  
		db $0D,$00,$00		; doblegenger 
		db $0E,$00,$02 		; final

org $A9A5
	progressionChoosePath: 
		dw goClockTower          
        dw goSymphaOrAlucard     
        dw goCryptOrWater        
 
    goClockTower: 
		db $01,$00,$00
		db $00,$00,$00              
	goWoods: 
		db $02,$00,$00                       
 
    goSymphaOrAlucard: 
		db $02,$03,$02
		db $06,$00,$01            

    goCryptOrWater: 
		db $07,$06,$00
		db $08,$00,$00   


org $92D5
    checkBossStage: 		; check stage, get index for table below     
		db $01,$00       	; grant             
		db $02,$01			; cyclops 
		db $07,$02          ; alucard 
		db $03,$03			; medusa
		db $0A,$04			; bat endles rising tower
		db $0E,$05,$FF      ; door to dracula
	
	afterBossActionTable: 	; autoWalk dir, gameState, loadState, inc room
		db $01,$04,$1E,$00	; exit door bottom-grant-tower		
		db $00,$08,$00,$00  ; exit door crossroad map cyclops          
		db $01,$08,$00,$00  ; exit door crossroad map alucard 
		db $00,$04,$1F,$01 	; exit door         
		db $00,$04,$1F,$01  ; exit door          
		db $01,$04,$1F,$01  ; exit door        
 
;bank $02					; orb transit index table (prg $4171)
;	org $8171
;		db $02,$01,$01,$00,$00,$00,$00,$01   ;018171|        |      ;
;        db $00,$00,$00,$00,$00,$00,$02,$00   ;018179|        |      ;
;        db $00,$00,$00,$00,$00,$00,$00,$00   ;018181|        |      ;
;        db $00,$00,$00,$00,$00,$00,$00,$00   ;018189|        |      ;