bank 5
base $a000 
org $a073 

dw miscTableStage00		; Roomidx 
dw miscTableStage01
dw miscTableStage02
dw miscTableStage03
dw miscTableStage04
dw miscTableStage05
dw miscTableStage06
dw miscTableStage07
dw miscTableStage08
dw miscTableStage09
dw miscTableStage0a
dw miscTableStage0b
dw miscTableStage0c
dw miscTableStage0d
dw miscTableStage0e

miscTableStage00:
dw miscTableSectionInxex00
dw miscTableSectionInxex01
dw miscTableSectionInxex02
dw miscTableSectionInxex03

miscTableStage01:
dw miscTableSectionInxex10
dw miscTableSectionInxex11
dw miscTableSectionInxex12
dw miscTableSectionInxex13
dw miscTableSectionInxex14
dw miscTableSectionInxex15

miscTableStage02:
dw miscTableSectionInxex20
dw miscTableSectionInxex21
dw miscTableSectionInxex22
dw miscTableSectionInxex23
dw miscTableSectionInxex24

miscTableStage03:
dw miscTableSectionInxex30
dw miscTableSectionInxex31
dw miscTableSectionInxex32
dw miscTableSectionInxex33
dw miscTableSectionInxex34

miscTableStage04:
dw miscTableSectionInxex40
dw miscTableSectionInxex41
dw miscTableSectionInxex42

miscTableStage05:
dw miscTableSectionInxex50
dw miscTableSectionInxex51
dw miscTableSectionInxex52
dw miscTableSectionInxex53

miscTableStage06:
dw miscTableSectionInxex60
dw miscTableSectionInxex61
dw miscTableSectionInxex62

miscTableStage07:
dw miscTableSectionInxex70
dw miscTableSectionInxex71
dw miscTableSectionInxex72
dw miscTableSectionInxex73
dw miscTableSectionInxex74
dw miscTableSectionInxex75
dw miscTableSectionInxex76


miscTableStage08:
dw miscTableSectionInxex80
dw miscTableSectionInxex81
dw miscTableSectionInxex82
dw miscTableSectionInxex83
dw miscTableSectionInxex84


miscTableStage09:
dw miscTableSectionInxex90
dw miscTableSectionInxex91



miscTableStage0a:
dw miscTableSectionInxexA0
dw miscTableSectionInxexA1
dw miscTableSectionInxexA2
dw miscTableSectionInxexA3
dw miscTableSectionInxexA4
dw miscTableSectionInxexA5
dw miscTableSectionInxexA6


miscTableStage0b:
dw miscTableSectionInxexB0
dw miscTableSectionInxexB1
dw miscTableSectionInxexB2

miscTableStage0c:
dw miscTableSectionInxexC0
dw miscTableSectionInxexC1
dw miscTableSectionInxexC2

miscTableStage0d:
dw miscTableSectionInxexD0
dw miscTableSectionInxexD1
dw miscTableSectionInxexD2
dw miscTableSectionInxexD3

miscTableStage0e:
dw miscTableSectionInxexE0
dw miscTableSectionInxexE1
dw miscTableSectionInxexE2



miscTableSectionInxex00:		; here you can enable/disable misc tables in levels 
db $00 
miscTableSectionInxex01:
db $00 ,$00, $01 ,$00
miscTableSectionInxex02:
db $1A,$00
miscTableSectionInxex03:
db $00  

miscTableSectionInxex10:
db $02, $00 ,$03
miscTableSectionInxex11:
db $04, $05 ,$06  
miscTableSectionInxex12:
db $07, $08 ,$09 
miscTableSectionInxex13:
db $07, $08 ,$09 
miscTableSectionInxex14:
db $04 ,$05 ,$06 
miscTableSectionInxex15:
db $02 ,$00, $03 

miscTableSectionInxex20:
db $0A 
miscTableSectionInxex21:
db $00
miscTableSectionInxex22:
db $25 ,$00 
miscTableSectionInxex23:
db $00 ,$00 
miscTableSectionInxex24:
db $1B ,$00

miscTableSectionInxex30:
db $00, $00 ,$0B
miscTableSectionInxex31:
db $1C ,$00 
miscTableSectionInxex32:
db $24, $00 
miscTableSectionInxex33:
db $1D ,$0C 
miscTableSectionInxex34:
db $28 ,$00 ,$00

miscTableSectionInxex40:
db $0D ,$00 ,$1E 
miscTableSectionInxex41:
db $00 ,$00 ,$0E
miscTableSectionInxex42:
db $00, $00, $1F

miscTableSectionInxex50:
db $00 
miscTableSectionInxex51:
db $00 
miscTableSectionInxex52:
db $00, $20 
miscTableSectionInxex53:
db $00, $0F

miscTableSectionInxex60:
db $21, $00
miscTableSectionInxex61:
db $22
miscTableSectionInxex62:
db $00 ,$00, $00


miscTableSectionInxex70:
db $10, $11
miscTableSectionInxex71:
db $00 ,$00, $00
miscTableSectionInxex72:
db $12
miscTableSectionInxex73:
db $23, $00
miscTableSectionInxex74:
db $13, $00
miscTableSectionInxex75:
db $26, $00
miscTableSectionInxex76:
db $14


miscTableSectionInxex80:
db $15, $16
miscTableSectionInxex81:
db $17
miscTableSectionInxex82:
db $18, $19
miscTableSectionInxex83:
db $42
miscTableSectionInxex84:
db $00


miscTableSectionInxex90:
db $39,$00
miscTableSectionInxex91:
db $00,$3A,$00



miscTableSectionInxexA0:
db $00,$34
miscTableSectionInxexA1:
db $00
miscTableSectionInxexA2:
db $35
miscTableSectionInxexA3:
db $41,$3D
miscTableSectionInxexA4:
db $3B,$00,$31
miscTableSectionInxexA5:
db $32,$36
miscTableSectionInxexA6:
db $00,$00,$3E 

miscTableSectionInxexB0:
db $29, $00
miscTableSectionInxexB1:
db $2A, $33
miscTableSectionInxexB2:
db $2B, $00 ,$00 

miscTableSectionInxexC0:
db $00, $2C
miscTableSectionInxexC1:
db $3F, $00
miscTableSectionInxexC2:
db $27
miscTableSectionInxexD0:
db $00, $2D, $00
miscTableSectionInxexD1:
db $3C, $00, $00
miscTableSectionInxexD2:
db $00, $2E, $2F
miscTableSectionInxexD3:
db $00, $30


miscTableSectionInxexE0:
db $00, $38, $00
miscTableSectionInxexE1:
db $40, $37
miscTableSectionInxexE2:
db $00, $00 

miscDataPointer:
dw miscData00				; $A21F
dw miscData01               ; $A230
dw miscData02               ; $A269
dw miscData03               ; $A28A
dw miscData04               ; $A29B
dw miscData05               ; $A2AC
dw miscData06               ; $A2B5
dw miscData07               ; $A2BE
dw miscData08               ; $A2CF
dw miscData09               ; $A2F0
dw miscData0a               ; $A2F9
dw miscData0b               ; $A32C
dw miscData0c               ; $A347
dw miscData0d               ; $A372
dw miscData0e               ; $A38C
dw miscData0f               ; $A3C7
dw miscData10               ; $A3FA
dw miscData11               ; $A403
dw miscData12               ; $A41C
dw miscData13               ; $A42E
dw miscData14               ; $A470
dw miscData15               ; $A491
dw miscData16               ; $A492
dw miscData17               ; $A49B
dw miscData18               ; $A49C
dw miscData19               ; $A4A5
dw miscData00		; 1a    ; $A21F
dw miscData1b               ; $A323
dw miscData1c               ; $A335
dw miscData1d               ; $A33E
dw miscData1e               ; $A383
dw miscData1f               ; $A3B5
dw miscData20               ; $A3BE
dw miscData21               ; $A3D0
dw miscData22               ; $A3D9
dw miscData23               ; $A425
dw miscData24               ; $A361
dw miscData25               ; $A31A
dw miscData26               ; $A467
dw miscData27               ; $A5AC
dw miscData28               ; $A358
dw miscData29               ; $A577
dw miscData2a               ; $A588
dw miscData2b               ; $A591
dw miscData2c               ; $A59A
dw miscData2d               ; $A5BD
dw miscData2e               ; $A5CF
dw miscData2f               ; $A5C6
dw miscData30               ; $A5D8
dw miscData31               ; $A54D
dw miscData32               ; $A53B
dw miscData33               ; $A621
dw miscData34               ; $A52A
dw miscData35               ; $A521
dw miscData36               ; $A4B8
dw miscData37               ; $A64B
dw miscData38               ; $A664
dw miscData39               ; $A67D
dw miscData3a               ; $A69E
dw miscData3b               ; $A4AF
dw miscData3c               ; $A6BF
dw miscData3d               ; $A544
dw miscData3e               ; $A56E
dw miscData3f               ; $A5A3
dw miscData40               ; $A642
dw miscData41               ; $A6E0
dw miscData42               ; $A4A6


; format: 
; screen, 	Xpos,	??, 	ID, 	Ypos??, 	quantity,	??,		??
; aa		bb		cc		dd		ee			ff			gg 		hh

; ID defines 
; 02 = turningPlatform, 06 = Slikes 

miscData00:		
db $00, $18, $00, $10, $B0, $00, $01, $00
db $00, $88, $00, $10, $A8, $01, $00, $01, $FF
miscData01:
db $00, $B0, $10, $02, $64, $01, $00, $00
db $01, $50, $10, $02, $B4, $01, $01, $00
db $01, $90, $10, $02, $64, $01, $02, $00
db $01, $D0, $10, $02, $64, $01, $03, $00
db $02, $10, $10, $02, $64, $01, $04, $00
db $02, $10, $10, $02, $B4, $01, $05, $00
db $02, $30, $10, $02, $64, $01, $06, $00, $FF
miscData02:
db $00, $AD, $00, $11, $18, $03, $01, $00
db $00, $BD, $40, $0A, $60, $00, $01, $00
db $02, $7D, $40, $0A, $40, $00, $00, $00
db $02, $AD, $00, $11, $E8, $01, $01, $01, $FF
miscData03:
db $00, $60, $40, $05, $30, $00, $00, $00
db $01, $50, $40, $05, $30, $01, $FF, $00, $FF
miscData04:
db $00, $18, $00, $10, $B0, $01, $01, $00
db $01, $20, $40, $04, $DE, $01, $02, $00, $FF
miscData05:
db $00, $9D, $40, $0A, $80, $00, $03, $00, $FF
miscData06:
db $00, $E8, $00, $10, $50, $04, $01, $01, $FF
miscData07:
db $00, $60, $40, $04, $E0, $01, $05, $00
db $00, $E8, $00, $10, $90, $03, $01, $00, $FF
miscData08:
db $00, $7D, $40, $0A, $C0, $00, $08, $00
db $02, $05, $00, $11, $28, $02, $00, $01
db $02, $5D, $40, $0A, $20, $00, $07, $00
db $02, $7D, $40, $0A, $60, $00, $06, $00, $FF
miscData09:
db $01, $E8, $00, $10, $70, $00, $01, $02, $FF
miscData0a: 		
db $01, $30, $10, $07, $00, $01, $04, $00
db $01, $70, $10, $07, $00, $01, $05, $00
db $01, $B0, $10, $07, $00, $01, $06, $00
db $02, $E8, $00, $10, $B0, $03, $01, $00, $FF 
miscData25: 	
db $03, $78, $00, $10, $68, $00, $00, $00, $FF 
miscData1b:
db $01, $28, $00, $10, $A8, $00, $00, $00, $FF
miscData0b:
db $00, $D0, $30, $01, $50, $00, $00, $00, $FF
miscData1c:
db $04, $E8, $00, $10, $90, $00, $01, $00, $FF
miscData1d:
db $02, $E8, $00, $10, $50, $00, $01, $00, $FF
miscData0c:
db $01, $70, $30, $01, $60, $01, $00, $00
db $01, $D0, $30, $01, $80, $02, $00, $00, $FF
miscData28:
db $00, $38, $00, $10, $98, $03, $00, $00, $FF
miscData24:
db $01, $C0, $C0, $0D, $80, $00, $00, $00
db $03, $70, $80, $0D, $80, $00, $00, $02, $FF
miscData0d:
db $00, $70, $10, $03, $A8, $01, $07, $00
db $01, $30, $10, $03, $88, $01, $08, $00, $FF
miscData1e:
db $00, $E8, $00, $10, $58, $00, $00, $00, $FF
miscData0e:
db $00, $18, $00, $10, $B0, $04, $01, $00
db $00, $50, $10, $03, $88, $01, $09, $00
db $00, $B0, $10, $03, $88, $01, $0A, $00
db $00, $D0, $10, $03, $C8, $01, $0B, $00
db $01, $10, $10, $03, $88, $01, $0C, $00, $FF
miscData1f:
db $02, $48, $00, $10, $88, $00, $00, $00, $FF
miscData20:
db $03, $E8, $00, $10, $48, $00, $00, $00, $FF
miscData0f:
db $00, $C8, $10, $00, $86, $00, $00, $00, $FF
miscData21:
db $00, $38, $00, $10, $A0, $00, $01, $00, $FF
miscData22:
db $01, $34, $30, $0C, $98, $30, $83, $00
db $01, $D0, $00, $0B, $88, $02, $02, $00
db $03, $B8, $00, $10, $A8, $00, $00, $00
db $04, $38, $00, $10, $88, $02, $00, $01, $FF
miscData10:
db $01, $40, $08, $09, $00, $00, $00, $00, $FF
miscData11:
db $01, $80, $08, $09, $00, $02, $00, $00
db $01, $E8, $00, $10, $B0, $02, $01, $00
db $01, $E8, $00, $10, $C8, $00, $00, $01, $FF
miscData12:
db $00, $80, $08, $09, $00, $01, $00, $00, $FF
miscData23:
db $00, $E0, $00, $0B, $AC, $04, $02, $00, $FF
miscData13:
db $00, $90, $10, $06, $00, $01, $00, $00
db $00, $D0, $10, $06, $00, $01, $03, $00
db $01, $10, $10, $06, $00, $01, $02, $00
db $01, $70, $10, $07, $00, $01, $01, $00
db $01, $90, $10, $07, $00, $01, $07, $00
db $02, $B8, $00, $10, $58, $00, $00, $00
db $03, $D0, $20, $0B, $90, $20, $02, $00, $FF
miscData26:
db $03, $A8, $00, $10, $90, $01, $01, $00, $FF
miscData14:
db $00, $D8, $00, $10, $88, $03, $00, $00
db $01, $80, $08, $08, $30, $03, $00, $00
db $02, $18, $00, $10, $88, $01, $00, $01
db $03, $C0, $08, $08, $30, $04, $00, $00, $FF
miscData15:
db $FF
miscData16:
db $04, $A8, $00, $10, $88, $01, $00, $00, $FF
miscData17:
db $FF
miscData18:
db $03, $08, $00, $10, $88, $00, $00, $00, $FF
miscData19:
db $FF
miscData42:			
db $04, $E8, $00, $10, $50, $04, $01, $00, $FF
miscData3b:			
db $01, $40, $08, $08, $80, $07, $00, $00, $FF
miscData36:			
db $00, $B0, $10, $03, $88, $01, $0D, $00
db $00, $D0, $10, $02, $84, $01, $0E, $00
db $00, $F0, $10, $02, $84, $01, $0F, $00
db $01, $10, $10, $03, $88, $01, $10, $00
db $01, $30, $10, $02, $84, $01, $11, $00
db $01, $50, $10, $03, $88, $01, $12, $00
db $01, $70, $10, $02, $84, $01, $13, $00
db $01, $B0, $10, $02, $84, $01, $14, $00
db $01, $D0, $10, $03, $88, $01, $15, $00
db $02, $10, $10, $02, $A4, $01, $16, $00
db $02, $50, $10, $03, $A8, $01, $17, $00
db $02, $70, $10, $02, $A4, $01, $18, $00
db $02, $90, $10, $03, $A8, $01, $19, $00, $FF
miscData35:	
db $00, $80, $08, $09, $00, $06, $00, $00, $FF
miscData34:		
db $00, $18, $00, $10, $B0, $01, $01, $00
db $00, $80, $08, $09, $00, $05, $00, $00, $FF
miscData32:
db $01, $80, $C0, $0D, $80, $00, $00, $04, $FF
miscData3d:		
db $00, $18, $00, $10, $B0, $00, $01, $00, $FF
miscData31:		
db $00, $18, $00, $10, $B0, $04, $01, $00
db $00, $40, $00, $0B, $A8, $08, $02, $00
db $00, $A0, $60, $0C, $78, $18, $02, $00
db $01, $E0, $20, $0B, $A0, $10, $02, $00, $FF
miscData3e:	
db $00, $28, $00, $10, $68, $00, $00, $00, $FF
miscData29:
db $02, $00, $F0, $0D, $00, $00, $00, $06
db $03, $E8, $00, $10, $A0, $03, $01, $00, $FF
miscData2a:
db $00, $98, $00, $10, $60, $00, $01, $00, $FF
miscData2b:
db $01, $18, $00, $10, $A8, $01, $00, $00, $FF
miscData2c:
db $01, $E8, $00, $10, $78, $01, $00, $00, $FF
miscData3f:
db $01, $E8, $00, $10, $C0, $00, $01, $00, $FF
miscData27:
db $00, $18, $00, $10, $C0, $03, $01, $00
db $01, $C8, $10, $00, $96, $00, $00, $00, $FF
miscData2d:
db $04, $58, $00, $10, $B8, $01, $00, $00, $FF
miscData2f:
db $00, $E8, $00, $10, $B0, $00, $01, $01, $FF
miscData2e:
db $02, $2D, $00, $11, $E8, $04, $04, $00, $FF
miscData30:
db $01, $28, $00, $10, $B0, $03, $01, $00
db $01, $B0, $10, $02, $A4, $01, $1C, $00
db $01, $D0, $10, $03, $A8, $01, $1D, $00
db $01, $F0, $10, $02, $A4, $01, $1E, $00
db $02, $10, $10, $03, $A8, $01, $1F, $00
db $02, $30, $10, $03, $A8, $01, $20, $00
db $02, $50, $10, $03, $A8, $01, $21, $00
db $02, $70, $10, $03, $A8, $01, $22, $00
db $02, $90, $10, $02, $A4, $01, $23, $00, $FF
miscData33:		
db $00, $28, $20, $01, $60, $03, $00, $00
db $01, $28, $20, $01, $60, $04, $00, $00
db $01, $98, $20, $01, $70, $05, $00, $00
db $02, $98, $20, $01, $70, $06, $00, $00, $FF
miscData40:			
db $01, $E8, $00, $10, $B0, $00, $01, $00, $FF
miscData37:		
db $00, $90, $40, $05, $30, $02, $FF, $00
db $01, $80, $40, $05, $30, $03, $FF, $00
db $02, $70, $40, $05, $30, $04, $00, $00, $FF
miscData38:			
db $00, $5D, $40, $0A, $80, $00, $09, $00
db $00, $7D, $40, $0A, $40, $00, $0A, $00
db $02, $9D, $40, $0A, $80, $00, $0B, $00, $FF
miscData39:		
db $00, $D4, $48, $0C, $C8, $28, $02, $00
db $01, $30, $F0, $0C, $78, $40, $02, $00
db $01, $74, $F0, $0C, $C0, $28, $82, $00
db $02, $88, $00, $10, $98, $01, $00, $00, $FF
miscData3a:	
db $00, $7F, $60, $0C, $A8, $11, $82, $00
db $01, $78, $60, $0C, $A8, $30, $02, $00
db $02, $18, $60, $0C, $A8, $20, $02, $00
db $03, $48, $00, $10, $38, $00, $00, $00, $FF
miscData3c:		
db $00, $90, $10, $07, $00, $01, $08, $00
db $00, $D0, $10, $06, $00, $01, $09, $00
db $00, $F0, $10, $07, $00, $01, $0A, $00
db $01, $70, $10, $07, $00, $01, $0B, $00
db $FF
miscData41:
db $00, $80, $08, $08, $30, $08, $00, $00, $FF

org $bed0			; freeSpace








