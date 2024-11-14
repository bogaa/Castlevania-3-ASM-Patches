bank $1a 			; ROM 34000
base $8000
org $823e 

oamSpecData:		
	dw trevor_025c	
	dw sympha_02cc	; sympha ??
	dw grant_0324	; grant  ?? 
	dw alucard_0378	; alucard??
	dw enemyAssemTable00_1a_0be9	; enemy 
	dw bossAssembTable00_1a_16a2
	dw bossAssembTable00_1b_0be7
	dw data_1b_0d53	; door, platforms ..
	dw data_1a_1fd6	; candles items 
	dw data_1a_0ce9	; boss01 
	dw data_1b_0ce7	; enemy01 owls,...
	
	dw trevor_025c	; intro??
	dw sympha_02cc
	dw grant_0324
	dw alucard_0378

trevor_025c:				
	dw data_1a_03be       ; 0   
	dw data_1a_0402       ; 2   
	dw data_1a_0410       ; 4   
	dw data_1a_041b       ; 6   
	dw data_1a_0410       ; 8   
	dw data_1a_0429       ; A   
	dw data_1a_0437       ; C   
	dw data_1a_0453       ; E   
	dw data_1a_051e       ; 10  
	dw data_1a_052c       ; 12  
	dw data_1a_053a       ; 14  
	dw data_1a_0445       ; 16  
	dw data_1a_0461       ; 18  
	dw data_1a_046f       ; 1A  
	dw data_1a_047d       ; 1C  
	dw data_1a_048e       ; 1E  
	dw data_1a_049f       ; 20  
	dw data_1a_04ad       ; 22  
	dw data_1a_0548       ; 24  
	dw data_1a_0550       ; 26  
	dw data_1a_0558       ; 28  
	dw data_1a_0563       ; 2A  
	dw data_1a_056b       ; 2C  
	dw data_1a_0573       ; 2E  
	dw data_1a_057b       ; 30  
	dw data_1a_0586       ; 32  
	dw data_1a_04be       ; 34  
	dw data_1a_04cf       ; 36  
	dw data_1a_04dd       ; 38  
	dw data_1a_04ee       ; 3A  
	dw data_1a_04ff       ; 3C  
	dw data_1a_050d       ; 3E  
	dw data_1a_0597       ; 40  
	dw data_1a_05a0       ; 42  
	dw data_1a_05a8       ; 44  
	dw data_1a_05b0       ; 46  
	dw data_1a_05b8       ; 48  
	dw data_1a_05c0       ; 4A  
	dw data_1a_05c8       ; 4C  
	dw data_1a_05d0       ; 4E  
	dw data_1a_05dd       ; 50  
	dw data_1a_05e5       ; 52  
	dw data_1a_05ea       ; 54  
	dw data_1a_13cb       ; 56  
	dw data_1a_13d0       ; 58  
	dw data_1a_13d5       ; 5A  
	dw data_1a_13d0       ; 5C  
	dw data_1a_05f2       ; 5E  
	dw data_1a_05fb       ; 60  
	dw data_1a_03f9       ; 62  
	dw data_1a_05d8       ; 64  
	dw data_1a_03be       ; 66  
	dw data_1a_03c7       ; 68  
	dw data_1a_03d2       ; 6A  
	dw data_1a_03e0       ; 6C  
	dw data_1a_03eb       ; 6E  

	dw data_1a_0402			; 70 trevor walking
	dw data_1a_0410
	dw data_1a_041b
	
	dw data_1a_0410
	dw data_1a_0402
	dw data_1a_041b
		

sympha_02cc:                 
	dw data_1a_03be		; 0 
	dw data_1a_0604     ; 2 
	dw data_1a_0612     ; 4 
	dw data_1a_0620     ; 6 
	dw data_1a_0612     ; 8 
	dw data_1a_062e     ; A 
	dw data_1a_063c     ; C 
	dw data_1a_0658     ; E 
	dw data_1a_0666     ; 10
	dw data_1a_0674     ; 12
	dw data_1a_0682     ; 14
	dw data_1a_064a     ; 16
	dw data_1a_0690     ; 18
	dw data_1a_069e     ; 1A
	dw data_1a_06ac     ; 1C
	dw data_1a_06ba     ; 1E
	dw data_1a_0700     ; 20
	dw data_1a_0705     ; 22
	dw data_1a_06c8     ; 24
	dw data_1a_06d6     ; 26
	dw data_1a_06e4     ; 28
	dw data_1a_06f2     ; 2A
	dw data_1a_0737     ; 2C
	dw data_1a_070d     ; 2E
	dw data_1a_071b     ; 30
	dw data_1a_0729     ; 32
	dw data_1a_0745     ; 34
	dw data_1a_0756     ; 36
	dw data_1a_0767     ; 38
	dw data_1a_0778     ; 3A
	dw data_1a_0789     ; 3C
	dw data_1a_078e     ; 3E
	dw data_1a_0799     ; 40
	dw data_1a_07aa     ; 42
	dw data_1a_07b8     ; 44
	dw data_1a_07c8     ; 46
	dw data_1a_07cd     ; 48
	dw data_1a_07d6     ; 4A
	dw data_1a_07df     ; 4C
	dw data_1a_07e8     ; 4E
	dw data_1a_07f1     ; 50
	dw data_1a_07fa     ; 52
	dw data_1a_0802     ; 54
	dw data_1a_07c0     ; 56
	
    dw $0000            ; 58
    dw $0000            ; 5A
    dw $0000            ; 5C
    dw $0000            ; 5E
    dw $0000            ; 60
    dw $0000            ; 62
    dw $0000            ; 64
    dw $0000            ; 66
    dw $0000            ; 68
    dw $0000            ; 6A
    dw $0000            ; 6C
	dw $0000            ; 6E
	
	dw data_1a_0604 	; 70
	dw data_1a_0612 
	dw data_1a_0620 	
	
	dw data_1a_0612
	dw data_1a_0604 
	dw data_1a_0620 
	

grant_0324:             
	dw data_1a_03be  	; 0    
	dw data_1a_080a     ; 2 
	dw data_1a_0818     ; 4 
	dw data_1a_0834     ; 6 
	dw data_1a_0818     ; 8 
	dw data_1a_0842     ; A 
	dw data_1a_0850     ; C 
	dw data_1a_086c     ; E 
	dw data_1a_0874     ; 10
	dw data_1a_0882     ; 12
	dw data_1a_088a     ; 14
	dw data_1a_085e     ; 16
	dw data_1a_0895     ; 18
	dw data_1a_089d     ; 1A
	dw data_1a_08ab     ; 1C
	dw data_1a_08b6     ; 1E
	dw data_1a_08be     ; 20
	dw data_1a_08c9     ; 22
	dw data_1a_08d4     ; 24
	dw data_1a_08e2     ; 26
	dw data_1a_099d     ; 28
	dw data_1a_08f3     ; 2A
	dw data_1a_0901     ; 2C
	dw data_1a_0912     ; 2E
	dw data_1a_0920     ; 30
	dw data_1a_0931     ; 32
	dw data_1a_093f     ; 34
	dw data_1a_0950     ; 36
	dw data_1a_0958     ; 38
	dw data_1a_0966     ; 3A
	dw data_1a_0971     ; 3C
	dw data_1a_097c     ; 3E
	dw data_1a_0987     ; 40
	dw data_1a_0992     ; 42
	dw data_1a_09ab     ; 44
	dw data_1a_09c0     ; 46
	dw data_1a_0826     ; 48
	dw data_1a_09ce     ; 4A
	dw data_1a_09e3     ; 4C
	dw data_1a_09f1     ; 4E
	dw data_1a_0a06     ; 50
	dw data_1a_0a14     ; 52
   
    dw $0000            ; 54
    dw $0000            ; 56
    dw $0000            ; 58
    dw $0000            ; 5A
    dw $0000            ; 5C
    dw $0000            ; 5E
    dw $0000            ; 60
    dw $0000            ; 62
    dw $0000            ; 64
    dw $0000            ; 66
    dw $0000            ; 68
    dw $0000            ; 6A
    dw $0000            ; 6C
    dw $0000            ; 6E
	
	dw data_1a_080a		; 70 
    dw data_1a_0818
	dw data_1a_0834

	dw data_1a_0818
	dw data_1a_080a
	dw data_1a_0834
	  

alucard_0378:           
	dw data_1a_03be		; 0 							
	dw data_1a_0a29     ; 2 
	dw data_1a_0a3a     ; 4 
	dw data_1a_0a4b     ; 6 
	dw data_1a_0a3a     ; 8 
	dw data_1a_0a5c     ; A 
	dw data_1a_0a6d     ; C 
	dw data_1a_0ace     ; E 
	dw data_1a_0b15     ; 10
	dw data_1a_0b23     ; 12
	dw data_1a_0b31     ; 14
	dw data_1a_0ac0     ; 16
	dw data_1a_0a7e     ; 18
	dw data_1a_0a8f     ; 1A
	dw data_1a_0aa9     ; 1C
	dw data_1a_0adc     ; 1E
	dw data_1a_0aea     ; 20
	dw data_1a_0b01     ; 22
	dw data_1a_0b3f     ; 24
	dw data_1a_0b47     ; 26
	dw data_1a_0b4f     ; 28
	dw data_1a_0b57     ; 2A
	dw data_1a_0b6b     ; 2C
	dw data_1a_0b82     ; 2E
	dw data_1a_0b90     ; 30
	dw data_1a_0b9e     ; 32
	dw data_1a_0bba     ; 34
	dw data_1a_0b9e     ; 36
	dw data_1a_0b90     ; 38
	dw data_1a_0b82     ; 3A
	dw data_1a_0b6b     ; 3C
	dw data_1a_0b57     ; 3E
	dw data_1a_0bd6     ; 40
	dw data_1a_0bdb     ; 42
	dw data_1a_0be0     ; 44
    
	dw $0000            ; 46
    dw $0000            ; 48
    dw $0000            ; 4A
    dw $0000            ; 4C
    dw $0000            ; 4E
    dw $0000            ; 50
    dw $0000            ; 52
    dw $0000            ; 54
    dw $0000            ; 56
    dw $0000            ; 58
    dw $0000            ; 5A
    dw $0000            ; 5C
    dw $0000            ; 5E
    dw $0000            ; 60
    dw $0000            ; 62
    dw $0000            ; 64
    dw $0000            ; 66
    dw $0000            ; 68
    dw $0000            ; 6A
    dw $0000            ; 6C
    dw $0000            ; 6E
 
	dw data_1a_0a29		; 70 alucard walking 
	dw data_1a_0a3a
	dw data_1a_0a4b

	dw data_1a_alucardNew1
	dw data_1a_alucardNew2          
	dw data_1a_alucardNew3          




data_1a_0410:
	db $03,$e0,$08,$00,$f8,$e1,$0a,$00,$01,$0c,$fb

data_1a_041b:
	db $04,$e0,$0e,$00,$f8,$e1,$10,$00,$01,$12,$f8,$01,$14,$00

data_1a_0429:
	db $04,$e0,$0e,$00,$f8,$e1,$10,$00,$01,$12,$f8,$01,$18,$00

data_1a_0437:
	db $04,$e0,$0e,$00,$f8,$e1,$10,$00,$01,$16,$f8,$01,$14,$00

data_1a_0445:
	db $04,$e8,$00,$00,$f8,$e9,$02,$00,$09,$16,$f8,$09,$18,$00

data_1a_0453:
	db $04,$f0,$00,$00,$f8,$f1,$02,$00,$11,$16,$f8,$11,$18,$00

data_1a_0461:
	db $04,$e0,$1a,$00,$f9,$e1,$1c,$01,$e1,$1e,$09,$01,$0c,$ff

data_1a_046f:
	db $04,$e0,$20,$00,$f8,$e1,$22,$00,$01,$12,$f8,$01,$14,$00

data_1a_047d:
	db $05,$e0,$24,$00,$f0,$e1,$26,$f8,$e1,$28,$00,$01,$04,$f8,$01,$06,$00

data_1a_048e:
	db $05,$f0,$1a,$00,$f8,$f1,$1c,$00,$f1,$1e,$08,$11,$16,$f8,$11,$18,$00

data_1a_049f:
	db $04,$f0,$20,$00,$f8,$f1,$22,$00,$11,$16,$f8,$11,$18,$00

data_1a_04ad:
	db $05,$f0,$24,$00,$f0,$f1,$26,$f8,$f1,$28,$00,$11,$16,$f8,$11,$18,$00

data_1a_04be:
	db $05,$e0,$1a,$00,$f8,$e1,$1c,$00,$e1,$1e,$08,$01,$12,$f8,$01,$18,$00

data_1a_04cf:
	db $04,$e0,$20,$00,$f8,$e1,$22,$00,$01,$12,$f8,$01,$18,$00

data_1a_04dd:
	db $05,$e0,$24,$00,$f0,$e1,$26,$f8,$e1,$28,$00,$01,$12,$f8,$01,$18,$00

data_1a_04ee:
	db $05,$e0,$1a,$00,$f8,$e1,$1c,$00,$e1,$1e,$08,$01,$16,$f8,$01,$14,$00

data_1a_04ff:
	db $04,$e0,$20,$00,$f8,$e1,$22,$00,$01,$16,$f8,$01,$14,$00

data_1a_050d:
	db $05,$e0,$24,$00,$f0,$e1,$26,$f8,$e1,$28,$00,$01,$16,$f8,$01,$14,$00

data_1a_051e:
	db $04,$e0,$2a,$00,$fa,$e1,$2c,$02,$01,$2e,$f8,$01,$18,$00

data_1a_052c:
	db $04,$e0,$2a,$00,$f7,$e1,$2c,$ff,$01,$16,$f8,$01,$18,$00

data_1a_053a:
	db $04,$00,$30,$00,$e8,$01,$32,$f0,$01,$34,$f8,$01,$36,$00

data_1a_0548:
	db $02,$e0,$38,$01,$10,$01,$3a,$10

data_1a_0550:
	db $02,$e0,$3e,$01,$08,$e5,$40,$10

data_1a_0558:
	db $03,$f0,$42,$01,$d8,$f1,$44,$e0,$f1,$44,$e8

data_1a_0563:
	db $02,$e0,$38,$01,$10,$01,$3c,$10

data_1a_056b:
	db $02,$e0,$46,$00,$10,$01,$48,$10

data_1a_0573:
	db $02,$e0,$4c,$00,$08,$e5,$4e,$10

data_1a_057b:
	db $03,$f0,$50,$00,$d8,$f1,$52,$e0,$f1,$52,$e8

data_1a_0586:
	db $05,$f0,$50,$00,$c8,$f1,$52,$d0,$f1,$52,$d8,$f1,$52,$e0,$f1,$52,$e8

data_1a_0597:
	db $02,$f0,$54,$01,$f8,$f0,$54,$41,$00

data_1a_05a0:
	db $02,$f0,$56,$01,$f8,$f1,$58,$00

data_1a_05a8:
	db $02,$f0,$58,$41,$f8,$f1,$56,$00

data_1a_05b0:
	db $02,$f0,$78,$01,$f8,$f1,$7a,$00

data_1a_05b8:
	db $02,$f0,$7a,$41,$f8,$f1,$78,$00

data_1a_05c0:
	db $02,$f0,$7a,$c1,$f8,$f1,$78,$00

data_1a_05c8:
	db $02,$f0,$78,$81,$f8,$f1,$7a,$00

data_1a_05d0:
	db $02,$f0,$7c,$81,$f8,$f1,$7e,$00

data_1a_05d8:
	db $01,$f0,$62,$01,$fc

data_1a_05dd:
	db $02,$f0,$66,$01,$f8,$f1,$68,$00

data_1a_05e5:
	db $01,$f0,$5a,$01,$fc

data_1a_05ea:
	db $02,$f0,$21,$01,$f8,$f1,$23,$00

data_1a_05f2:
	db $02,$f0,$15,$03,$f8,$f0,$15,$43,$00

data_1a_05fb:
	db $02,$f0,$17,$03,$f8,$f0,$17,$43,$00

data_1a_0604:
	db $04,$e0,$00,$00,$f8,$e1,$02,$00,$01,$04,$f8,$01,$06,$00

data_1a_0612:
	db $04,$e0,$08,$00,$f8,$e1,$0a,$00,$01,$0c,$f8,$01,$0e,$00

data_1a_0620:
	db $04,$e0,$10,$00,$f8,$e1,$12,$00,$01,$14,$f8,$01,$16,$00

data_1a_062e:
	db $04,$e0,$10,$00,$f8,$e1,$12,$00,$01,$56,$f8,$01,$48,$00

data_1a_063c:
	db $04,$e0,$10,$00,$f8,$e1,$12,$00,$01,$46,$f8,$01,$52,$00

data_1a_064a:
	db $04,$e8,$10,$00,$f8,$e9,$44,$00,$09,$46,$f8,$09,$48,$00

data_1a_0658:
	db $04,$f0,$10,$00,$f8,$f1,$44,$00,$11,$46,$f8,$11,$48,$00

data_1a_0666:
	db $04,$e0,$5c,$00,$f7,$e1,$5e,$ff,$01,$46,$f8,$01,$48,$00

data_1a_0674:
	db $04,$e0,$5c,$00,$f7,$e1,$5e,$ff,$01,$46,$f8,$01,$48,$00

data_1a_0682:
	db $04,$f0,$60,$00,$e8,$f1,$62,$f0,$f1,$64,$f8,$f1,$66,$00

data_1a_0690:
	db $04,$e0,$1e,$00,$f8,$e1,$0a,$00,$01,$0c,$f8,$01,$0e,$00

data_1a_069e:
	db $04,$e0,$20,$00,$f7,$e1,$12,$ff,$01,$22,$f8,$01,$16,$00

data_1a_06ac:
	db $04,$f0,$4a,$00,$f9,$f1,$12,$01,$11,$46,$f8,$11,$48,$00

data_1a_06ba:
	db $04,$f0,$20,$00,$f7,$f1,$12,$ff,$11,$46,$f8,$11,$48,$00

data_1a_06c8:
	db $04,$e0,$4a,$00,$f9,$e1,$12,$01,$01,$56,$f8,$01,$48,$00

data_1a_06d6:
	db $04,$e0,$20,$00,$f7,$e1,$12,$ff,$01,$56,$f8,$01,$48,$00

data_1a_06e4:
	db $04,$e0,$4a,$00,$f9,$e1,$12,$01,$01,$46,$f8,$01,$52,$00

data_1a_06f2:
	db $04,$e0,$20,$00,$f7,$e1,$12,$ff,$01,$46,$f8,$01,$52,$00

data_1a_0700:
	db $01,$d0,$18,$01,$f9

data_1a_0705:
	db $02,$e0,$1a,$01,$e7,$e5,$1c,$ef

data_1a_070d:
	db $04,$f0,$24,$00,$f8,$f1,$26,$00,$11,$46,$f8,$11,$4c,$00

data_1a_071b:
	db $04,$e0,$24,$00,$f8,$e1,$26,$00,$01,$58,$f8,$01,$4c,$00

data_1a_0729:
	db $04,$e0,$24,$00,$f8,$e1,$26,$00,$01,$46,$f8,$01,$54,$00

data_1a_0737:
	db $04,$e0,$24,$00,$f8,$e1,$26,$00,$01,$22,$f8,$01,$28,$00

data_1a_0745:
	db $05,$f0,$2a,$00,$f0,$e1,$2c,$f8,$e1,$02,$00,$01,$2e,$f8,$01,$06,$00

data_1a_0756:
	db $05,$f0,$2a,$00,$f0,$e1,$2c,$f8,$e1,$02,$00,$01,$4e,$f8,$01,$50,$00

data_1a_0767:
	db $05,$f0,$2a,$00,$f0,$e1,$2c,$f8,$e1,$12,$00,$01,$5a,$f8,$01,$50,$00

data_1a_0778:
	db $05,$f0,$2a,$00,$f0,$e1,$2c,$f8,$e1,$12,$00,$01,$4e,$f8,$01,$06,$00

data_1a_0789:
	db $01,$f0,$30,$00,$fc

data_1a_078e:
	db $03,$f0,$32,$03,$f4,$f1,$34,$fc,$f1,$36,$04

data_1a_0799:
	db $05,$f0,$32,$03,$ec,$f1,$3a,$f4,$f1,$3a,$fc,$f1,$3a,$04,$f1,$36,$0c

data_1a_07aa:
	db $04,$f0,$38,$03,$f0,$f1,$3a,$f8,$f1,$3a,$00,$f1,$36,$08

data_1a_07b8:
	db $02,$f0,$3c,$03,$f8,$f1,$3e,$00

data_1a_07c0:
	db $02,$f0,$40,$03,$f8,$f1,$42,$00

data_1a_07c8:
	db $01,$f0,$6e,$00,$fc

data_1a_07cd:
	db $02,$f0,$68,$00,$f8,$f0,$68,$c0,$00

data_1a_07d6:
	db $02,$f0,$6a,$00,$f8,$f0,$6a,$c0,$00

data_1a_07df:
	db $02,$f0,$6c,$00,$f8,$f0,$6c,$c0,$00

data_1a_07e8:
	db $02,$f0,$70,$00,$f8,$f0,$70,$40,$00

data_1a_07f1:
	db $02,$f0,$72,$00,$f8,$f0,$72,$40,$00

data_1a_07fa:
	db $02,$f0,$b1,$00,$f8,$f1,$b3,$00

data_1a_0802:
	db $02,$f0,$b5,$00,$f8,$f1,$b7,$00

data_1a_080a:
	db $04,$e0,$00,$00,$f4,$e1,$02,$fc,$01,$04,$f8,$01,$06,$00

data_1a_0818:
	db $04,$e0,$08,$00,$f5,$e1,$0a,$fd,$01,$0c,$f8,$01,$0e,$00

data_1a_0826:
	db $04,$d8,$08,$00,$f5,$d9,$0a,$fd,$f9,$0c,$f8,$f9,$0e,$00

data_1a_0834:
	db $04,$e0,$10,$00,$f4,$e1,$12,$fc,$01,$14,$f8,$01,$16,$00

data_1a_0842:
	db $04,$d8,$00,$00,$f8,$d9,$02,$00,$f9,$2a,$f8,$f9,$2c,$00

data_1a_0850:
	db $04,$d8,$00,$00,$f6,$d9,$02,$fe,$f9,$26,$f8,$f9,$28,$00

data_1a_085e:
	db $04,$e0,$00,$00,$f6,$e1,$02,$fe,$01,$6c,$f8,$01,$6e,$00

data_1a_086c:
	db $02,$f8,$40,$80,$f8,$f9,$42,$00

data_1a_0874:
	db $04,$e2,$64,$00,$f8,$e3,$02,$00,$01,$2a,$f8,$01,$2c,$00

data_1a_0882:
	db $02,$f0,$40,$80,$f8,$f1,$42,$00

data_1a_088a:
	db $03,$f0,$66,$00,$f0,$f1,$68,$f8,$f1,$6a,$00

data_1a_0895:
	db $02,$f0,$2e,$00,$f8,$f1,$30,$00

data_1a_089d:
	db $04,$f0,$32,$00,$f8,$f1,$34,$00,$11,$36,$f8,$11,$38,$00

data_1a_08ab:
	db $03,$f0,$3a,$00,$f8,$f1,$3c,$00,$f1,$3e,$08

data_1a_08b6:
	db $02,$f0,$40,$00,$f8,$f1,$42,$00

data_1a_08be:
	db $03,$f0,$44,$00,$f0,$f1,$46,$f8,$f1,$48,$00

data_1a_08c9:
	db $03,$f0,$4a,$00,$f8,$f1,$4e,$00,$11,$4c,$f8

data_1a_08d4:
	db $04,$e0,$18,$00,$f9,$e1,$1a,$01,$01,$14,$f8,$01,$16,$00

data_1a_08e2:
	db $05,$e0,$1c,$00,$ee,$e1,$1e,$f6,$e1,$20,$fe,$01,$0c,$f8,$01,$0e,$00

data_1a_08f3:
	db $04,$da,$18,$00,$fb,$db,$1a,$03,$f9,$2a,$f8,$f9,$2c,$00

data_1a_0901:
	db $05,$da,$1c,$00,$ef,$db,$1e,$f7,$db,$20,$ff,$f9,$2a,$f8,$f9,$2c,$00

data_1a_0912:
	db $04,$da,$18,$00,$f9,$db,$1a,$01,$f9,$26,$f8,$f9,$28,$00

data_1a_0920:
	db $05,$da,$1c,$00,$ee,$db,$1e,$f6,$db,$20,$fe,$f9,$26,$f8,$f9,$28,$00

data_1a_0931:
	db $04,$e8,$18,$00,$fc,$e9,$1a,$04,$09,$22,$f8,$09,$24,$00

data_1a_093f:
	db $05,$e8,$1c,$00,$ee,$e9,$1e,$f6,$e9,$20,$fe,$09,$22,$f8,$09,$24,$00

data_1a_0950:
	db $02,$f0,$2e,$80,$f8,$f1,$30,$00

data_1a_0958:
	db $04,$d0,$36,$80,$f8,$d1,$38,$00,$f1,$32,$f8,$f1,$34,$00

data_1a_0966:
	db $03,$f0,$3a,$80,$f8,$f1,$3c,$00,$f1,$3e,$08

data_1a_0971:
	db $03,$e0,$50,$00,$f8,$01,$52,$f8,$01,$54,$00

data_1a_097c:
	db $03,$e0,$52,$80,$f8,$e1,$54,$00,$01,$50,$f8

data_1a_0987:
	db $03,$e0,$56,$00,$f8,$f1,$58,$00,$f1,$5a,$08

data_1a_0992:
	db $03,$f0,$58,$80,$00,$f1,$5a,$08,$01,$56,$f8

data_1a_099d:
	db $04,$e0,$5c,$00,$f8,$e1,$5e,$00,$01,$14,$f8,$01,$16,$00

data_1a_09ab:
	db $06,$e4,$60,$01,$e4,$e0,$1c,$00,$ec,$e1,$1e,$f4,$e1,$20,$fc,$01,$14,$f8,$01,$16,$00

data_1a_09c0:
	db $04,$e8,$5c,$00,$fc,$e9,$5e,$04,$09,$22,$f8,$09,$24,$00

data_1a_09ce:
	db $06,$ee,$60,$01,$e6,$ea,$1c,$00,$ee,$eb,$1e,$f6,$eb,$20,$fe,$09,$22,$f8,$09,$24,$00

data_1a_09e3:
	db $04,$d8,$5c,$00,$fa,$d9,$5e,$02,$f9,$26,$f8,$f9,$28,$00

data_1a_09f1:
	db $06,$dc,$60,$01,$e6,$d8,$1c,$00,$ee,$d9,$1e,$f6,$d9,$20,$fe,$f9,$26,$f8,$f9,$28,$00

data_1a_0a06:
	db $04,$d8,$5c,$00,$fa,$d9,$5e,$02,$f9,$2a,$f8,$f9,$2c,$00

data_1a_0a14:
	db $06,$dc,$60,$01,$e6,$d8,$1c,$00,$ee,$d9,$1e,$f6,$d9,$20,$fe,$f9,$2a,$f8,$f9,$2c,$00

data_1a_0a5c:
	db $05,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$04,$00,$01,$06,$f9,$01,$1c,$01

data_1a_0a6d:
	db $05,$c0,$00,$00,$fc,$e1,$14,$f8,$e1,$16,$00,$01,$1e,$f9,$01,$1a,$01

data_1a_0a7e:
	db $05,$c0,$00,$00,$fb,$e1,$20,$f4,$e1,$22,$fc,$01,$24,$f8,$01,$26,$00

data_1a_0a8f:
	db $08,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$28,$00,$e1,$2a,$08,$01,$06,$f9,$01,$2c,$00,$01,$2e,$08,$eb,$30,$10

data_1a_0aa9:
	db $07,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$32,$00,$e1,$34,$08,$01,$06,$f9,$01,$2c,$00,$01,$2e,$08

data_1a_0ac0:
	db $04,$e8,$38,$00,$f8,$e9,$3a,$00,$09,$3c,$f8,$09,$3e,$00

data_1a_0ace:
	db $04,$f0,$38,$00,$f8,$f1,$3a,$00,$11,$3c,$f8,$11,$3e,$00



data_1a_0b23:
	db $04,$e0,$4c,$00,$f8,$e1,$4e,$00,$01,$36,$f8,$01,$3e,$00

data_1a_0b31:
	db $04,$00,$54,$00,$e8,$01,$56,$f0,$01,$58,$f8,$01,$5a,$00

data_1a_0b3f:
	db $02,$f0,$60,$00,$f8,$f1,$62,$00

data_1a_0b47:
	db $02,$f6,$64,$00,$f8,$f7,$66,$00

data_1a_0b4f:
	db $02,$fc,$68,$00,$f8,$fd,$6a,$00

data_1a_0b57:
	db $06,$f0,$38,$00,$f8,$f1,$48,$00,$f1,$34,$08,$11,$3c,$f8,$11,$4a,$00,$11,$36,$08

data_1a_0b6b:
	db $07,$f0,$38,$00,$f8,$f1,$48,$00,$f1,$2a,$08,$11,$3c,$f8,$11,$4a,$00,$11,$2e,$08,$f9,$30,$10

data_1a_0b82:
	db $04,$f0,$40,$00,$f8,$f1,$42,$00,$11,$44,$f8,$11,$46,$00

data_1a_0b90:
	db $04,$00,$6c,$01,$f8,$01,$6e,$00,$f1,$40,$f8,$f1,$42,$00

data_1a_0b9e:
	db $08,$e0,$72,$01,$f8,$e1,$76,$00,$01,$74,$f8,$01,$78,$00,$e1,$70,$f0,$f0,$40,$00,$f8,$f1,$42,$00,$e8,$70,$41,$08

data_1a_0bba:
	db $08,$f0,$7a,$01,$f0,$f1,$7c,$f8,$11,$7e,$f5,$00,$60,$00,$f8,$01,$62,$00,$f0,$7c,$41,$00,$f1,$7a,$08,$11,$7e,$03

data_1a_0bd6:
	db $01,$f0,$5c,$03,$fc

data_1a_0bdb:
	db $01,$f0,$5c,$01,$fc

data_1a_0be0:
	db $02,$f0,$5e,$01,$fc,$f0,$5e,$41,$00


enemyAssemTable00_1a_0be9:					  ; enemie sprites 
	dw Zombie_00_0d7e
	dw Zombie_00_0d7e
	dw Zombie_04_0d8c
	dw ZombieAppear_06_0d9a
	dw ZombieAppear_08_0da3
	dw Bird_0a_0da3
	dw Bird_0c_0db9
	dw Bird_10_0dc1
	dw Bird_0c_0db9
	dw BirdSit_12_0dcf
	dw GhostAppear_14_0e03
	dw GhostAppear_16_0e08
	dw GhostAppear_18_0e0d
	dw Ghost_1a_0e15
	dw Ghost_1c_0e1d
	dw data_1a_0e25				; bat sprite 
	dw data_1a_0e2e
	dw data_1a_0e36
	dw data_1a_0e3e
	dw data_1a_0e36
	dw data_1a_0e66
	dw data_1a_0e6e
	dw data_1a_0e96
	dw data_1a_0ea7
	dw data_1a_0eb8
	dw data_1a_0ed3
	dw data_1a_0f19
	dw data_1a_0f27
	dw data_1a_10a5
	dw data_1a_10ad
	dw data_1a_10b5
	dw data_1a_0f71
	dw data_1a_0f80
	dw data_1a_0f8f
	dw data_1a_0f9d
	dw data_1a_0fab
	dw data_1a_0fbc
	dw data_1a_0fca
	dw data_1a_0fee
	dw data_1a_0ff6
	dw data_1a_0ff6
	dw data_1a_0ee7
	dw data_1a_0f05
	dw Zombie_00_0d7e
	dw data_1a_1068
	dw data_1a_1070
	dw data_1a_1078
	dw data_1a_1080
	dw data_1a_1088
	dw data_1a_108d
	dw data_1a_1095
	dw data_1a_109d
	dw data_1a_10bd
	dw data_1a_10ce
	dw data_1a_10df
	dw data_1a_10ce
	dw data_1a_10f0
	dw data_1a_10fe
	dw data_1a_1106
	dw data_1a_1123
	dw data_1a_1140
	dw data_1a_115c
	dw data_1a_1177
	dw data_1a_0e86
	dw data_1a_0e8e
	dw Zombie_00_0d7e
	dw Zombie_00_0d7e
	dw Zombie_00_0d7e
	dw Zombie_00_0d7e
	dw Zombie_00_0d7e
	dw data_1a_119e
	dw data_1a_11b8
	dw data_1a_11b8
	dw data_1a_11d2
	dw data_1a_11e0
	dw data_1a_11ee
	dw data_1a_11ff
	dw data_1a_120d
	dw data_1a_121e
	dw data_1a_122d
	dw data_1a_1235
	dw data_1a_123d
	dw data_1a_1245
	dw data_1a_124a
	dw data_1a_1252
	dw data_1a_1269
	dw data_1a_1281
	dw data_1a_1281
	dw data_1a_118d
	dw data_1a_1195
	dw data_1a_0f35
	dw data_1a_0f46
	dw data_1a_12b2
	dw data_1a_12c4
	dw data_1a_1345
	dw data_1a_1356
	dw data_1a_1367
	dw data_1a_136c
	dw data_1a_1375
	dw data_1a_1382
	dw data_1a_1393
	dw data_1a_13c1
	dw data_1a_13c6
	dw data_1a_0e46
	dw data_1a_0e4e
	dw data_1a_0e56
	dw data_1a_0e5e
	dw data_1a_0e56
	dw data_1a_13a8
	dw data_1a_14a0
	dw data_1a_14a5
	dw data_1a_1455
	dw data_1a_1462
	dw data_1a_146e
	dw data_1a_147e
	dw data_1a_148e
	dw data_1a_1497
	dw data_1a_14aa
	dw data_1a_14b6
	dw data_1a_1295
	dw data_1a_0f5a
	dw data_1a_12d6
	dw data_1a_12eb
	dw data_1a_1309
	dw data_1a_1327
	dw data_1a_1517
	dw data_1a_1529
	dw data_1a_0d67

data_1a_0ce9:
	dw Zombie_00_0d7e
	dw data_1a_13da
	dw data_1a_13e3
	dw data_1a_13ec
	dw data_1a_13fd
	dw data_1a_1419
	dw data_1a_1430
	dw data_1a_1441
	dw data_1a_14c2
	dw data_1a_14cd
	dw data_1a_14e1
	dw data_1a_14ec
	dw Zombie_00_0d7e
	dw data_1a_1541
	dw data_1a_154f
	dw data_1a_155d
	dw data_1a_156b
	dw data_1a_1574
	dw data_1a_0fd8
	dw data_1a_0fe3
	dw data_1a_157c
	dw data_1a_158d
	dw data_1a_159e
	dw data_1a_15af
	dw data_1a_15b4
	dw data_1a_15b9
	dw data_1a_15be
	dw data_1a_15cc
	dw data_1a_15da
	dw data_1a_0ffe
	dw data_1a_1006
	dw data_1a_101e
	dw data_1a_102e
	dw data_1a_103e
	dw data_1a_1048
	dw data_1a_1058
	dw data_1a_100e
	dw data_1a_1016
	dw data_1a_1026
	dw data_1a_1036
	dw data_1a_1043
	dw data_1a_1050
	dw data_1a_1060
	dw data_1a_1612
	dw data_1a_161a
	dw data_1a_15e8
	dw data_1a_15f6
	dw data_1a_1604
	dw data_1a_14fd
	dw data_1a_1508
	dw data_1a_1622
	dw data_1a_162a
	dw data_1a_0dd7
	dw data_1a_0de5
	dw data_1a_0ded
	dw data_1a_0de5
	dw data_1a_0dfb
	dw data_1a_1632
	dw data_1a_1650
	dw data_1a_1671
	dw data_1a_1688
	dw data_1a_0e76
	dw data_1a_0e7e

data_1a_0d67:
	db $07
	db $f0,$71,$01,$e4
	db $e1,$73,$ec
	db $e1,$75,$f4
	db $e1,$77,$fc
	db $e1,$79,$04
	db $01,$7b,$fc
	db $01,$7d,$04

Zombie_00_0d7e:
	db $04				
	db $e0,$80,$02,$f4	
	db $e1,$82,$fc		
	db $01,$88,$f8		
	db $01,$8a,$00		

Zombie_04_0d8c:
	db $04				
	db $e2,$80,$02,$f5	
	db $e3,$82,$fd		
	db $01,$84,$f8		
	db $01,$86,$00		

ZombieAppear_06_0d9a:
	db $02,$00,$90,$02,$f8,$00,$90,$42,$00

ZombieAppear_08_0da3:
	db $02,$00,$8c,$02,$f8,$01,$8e,$00

Bird_0a_0da3:
	db $04,$e0,$92,$02,$fd,$e1,$94,$05,$01,$96,$f8,$01,$98,$00

Bird_0c_0db9:
	db $02,$00,$9a,$02,$f8,$01,$9c,$00

Bird_10_0dc1:
	db $04,$e2,$9e,$02,$f8,$e3,$a0,$00,$03,$a2,$f8,$03,$a4,$00

BirdSit_12_0dcf:
	db $02,$00,$a6,$02,$f8,$01,$a8,$00

data_1a_0dd7:
	db $04,$e0,$d2,$02,$fd,$e1,$d4,$05,$01,$d6,$f8,$01,$d8,$00

data_1a_0de5:
	db $02,$00,$da,$02,$f8,$01,$dc,$00

data_1a_0ded:
	db $04,$e2,$de,$02,$f8,$e3,$e0,$00,$03,$e2,$f8,$03,$e4,$00

data_1a_0dfb:
	db $02,$00,$e6,$02,$f8,$01,$e8,$00

GhostAppear_14_0e03:
	db $01,$f0,$be,$01,$fc

GhostAppear_16_0e08:
	db $01,$f0,$b4,$01,$fc

GhostAppear_18_0e0d:
	db $02,$f0,$b0,$01,$f8,$f1,$b2,$00

Ghost_1a_0e15:
	db $02,$f0,$aa,$01,$f8,$f1,$ac,$00

Ghost_1c_0e1d:
	db $02,$f0,$aa,$01,$f8,$f1,$ae,$00

data_1a_0e25:
	db $02,$f0,$cc,$03,$f8,$f0,$cc,$43,$00

data_1a_0e2e:
	db $02,$e8,$c0,$03,$f8,$e9,$c2,$00

data_1a_0e36:
	db $02,$f0,$c4,$03,$f8,$f1,$c6,$00

data_1a_0e3e:
	db $02,$f8,$c8,$03,$f8,$f9,$ca,$00

data_1a_0e46:
	db $02,$f0,$de,$03,$f8,$f1,$de,$00

data_1a_0e4e:
	db $02,$f0,$d2,$03,$f8,$f1,$d4,$00

data_1a_0e56:
	db $02,$f0,$d6,$03,$f8,$f1,$d8,$00

data_1a_0e5e:
	db $02,$f0,$da,$03,$f8,$f1,$dc,$00

data_1a_0e66:
	db $02,$f0,$ea,$01,$f8,$f1,$ec,$00

data_1a_0e6e:
	db $02,$f0,$ee,$01,$f8,$f1,$f0,$00

data_1a_0e76:
	db $02,$f0,$8a,$01,$f8,$f1,$8c,$00

data_1a_0e7e:
	db $02,$f0,$8e,$01,$f8,$f1,$ae,$00

data_1a_0e86:
	db $02,$f0,$59,$01,$f8,$f1,$5b,$00

data_1a_0e8e:
	db $02,$f0,$5d,$01,$f8,$f1,$5f,$00

data_1a_0e96:
	db $05,$f0,$d6,$01,$f0,$e1,$d8,$f8,$e1,$da,$00,$01,$dc,$f8,$01,$de,$00

data_1a_0ea7:
	db $05,$f0,$d6,$01,$ef,$e1,$d8,$f7,$e1,$da,$ff,$01,$e0,$f8,$01,$e2,$00

data_1a_0eb8:
	db $08,$f0,$d6,$01,$f0,$e1,$d8,$f8,$e1,$e8,$00,$e1,$ee,$08,$01,$e4,$f8,$01,$e6,$00,$c8,$ec,$41,$06,$c9,$ea,$0e

data_1a_0ed3:
	db $06,$e0,$f0,$01,$ed,$e1,$f2,$f4,$e1,$f4,$fd,$01,$f6,$f0,$01,$f8,$f8,$01,$e6,$00

data_1a_0ee7:
	db $09,$f0,$d4,$01,$f0,$f1,$d8,$f8,$f1,$e8,$00,$f1,$ee,$08,$11,$ce,$f2,$11,$d0,$fa,$11,$d2,$03,$d6,$ec,$41,$06,$d7,$ea,$0e

data_1a_0f05:
	db $06,$f0,$f0,$01,$f1,$f1,$f2,$f9,$f1,$f4,$01,$11,$ce,$f2,$11,$d0,$fa,$11,$d2,$02

data_1a_0f19:
	db $04,$e0,$d4,$01,$f7,$e1,$d6,$ff,$01,$d8,$f8,$01,$da,$00

data_1a_0f27:
	db $04,$e2,$d4,$01,$f7,$e3,$d6,$ff,$01,$dc,$f8,$01,$de,$00

data_1a_0f35:
	db $05,$e2,$e0,$01,$ee,$e3,$e2,$f6,$e3,$d6,$fe,$01,$e4,$f8,$01,$de,$00

data_1a_0f46:
	db $06,$c0,$e6,$01,$f7,$c1,$e8,$ff,$e1,$ea,$f7,$e1,$ec,$ff,$01,$ee,$f8,$01,$da,$00

data_1a_0f5a:
	db $07,$e2,$d4,$01,$f6,$e3,$d6,$fe,$01,$dc,$f8,$01,$de,$00,$fb,$f0,$e0,$fb,$f2,$e8,$fb,$f4,$f0

data_1a_0f71:
	db $04,$e0,$80,$01,$f8,$e1,$82,$00,$00,$82,$41,$f8,$01,$80,$00

data_1a_0f80:
	db $04,$e0,$fa,$01,$f8,$e1,$fc,$00,$00,$fc,$41,$f8,$01,$fa,$00

data_1a_0f8f:
	db $04,$e0,$90,$03,$f7,$e1,$92,$ff,$01,$94,$f8,$01,$96,$00

data_1a_0f9d:
	db $04,$e2,$90,$03,$f5,$e3,$92,$fd,$01,$98,$f8,$01,$9a,$00

data_1a_0fab:
	db $05,$e0,$9c,$03,$f4,$e1,$9e,$fc,$e1,$a0,$04,$01,$a2,$f8,$01,$a4,$00

data_1a_0fbc:
	db $04,$f0,$90,$03,$f7,$f1,$92,$ff,$11,$b8,$f8,$11,$ba,$00

data_1a_0fca:
	db $04,$e0,$a6,$03,$f7,$e1,$a8,$ff,$01,$94,$f8,$01,$96,$00

data_1a_0fd8:
	db $03,$f0,$b2,$02,$f4,$f1,$b4,$fc,$f1,$b6,$04

data_1a_0fe3:
	db $03,$f0,$b2,$82,$f4,$f1,$b4,$fc,$f1,$b6,$04

data_1a_0fee:
	db $02,$f0,$84,$02,$f8,$f1,$86,$00

data_1a_0ff6:
	db $02,$f0,$88,$02,$f8,$f1,$8a,$00

data_1a_0ffe:
	db $02,$f0,$e0,$01,$f8,$f1,$e2,$00

data_1a_1006:
	db $02,$f0,$e4,$01,$f8,$f1,$e6,$00

data_1a_100e:
	db $02,$f0,$90,$01,$f8,$f1,$92,$00

data_1a_1016:
	db $02,$f0,$94,$01,$f8,$f1,$96,$00

data_1a_101e:
	db $02,$f0,$e8,$01,$f8,$f1,$ea,$00

data_1a_1026:
	db $02,$f0,$98,$01,$f8,$f1,$9a,$00

data_1a_102e:
	db $02,$f0,$ec,$01,$f8,$f1,$ee,$00

data_1a_1036:
	db $02,$f0,$9c,$01,$f8,$f1,$9e,$00

data_1a_103e:
	db $01,$f0,$f0,$01,$fc

data_1a_1043:
	db $01,$f0,$a0,$01,$fc

data_1a_1048:
	db $02,$f0,$f2,$01,$f8,$f1,$f4,$00

data_1a_1050:
	db $02,$f0,$a2,$01,$f8,$f1,$a4,$00

data_1a_1058:
	db $02,$f0,$fa,$c1,$f8,$f1,$f8,$00

data_1a_1060:
	db $02,$f0,$9a,$c1,$f8,$f1,$98,$00

data_1a_1068:
	db $02,$f0,$80,$03,$f8,$f1,$82,$00

data_1a_1070:
	db $02,$f0,$80,$03,$f8,$f1,$86,$00

data_1a_1078:
	db $02,$f0,$84,$03,$f8,$f1,$86,$00

data_1a_1080:
	db $02,$f0,$88,$03,$f8,$f1,$82,$00

data_1a_1088:
	db $01,$f0,$8a,$03,$fc

data_1a_108d:
	db $02,$f0,$8c,$02,$f8,$f1,$8e,$00

data_1a_1095:
	db $02,$f0,$90,$02,$f8,$f1,$92,$00

data_1a_109d:
	db $02,$f0,$94,$02,$f8,$f1,$96,$00

data_1a_10a5:
	db $02,$f0,$8e,$c2,$f8,$f1,$8c,$00

data_1a_10ad:
	db $02,$f0,$92,$c2,$f8,$f1,$90,$00

data_1a_10b5:
	db $02,$f0,$96,$c2,$f8,$f1,$94,$00

data_1a_10bd:
	db $05,$e0,$98,$01,$f8,$e1,$9a,$00,$01,$9c,$f8,$01,$9e,$00,$c1,$be,$fb

data_1a_10ce:
	db $05,$e0,$98,$01,$f8,$e1,$9a,$00,$01,$a0,$f8,$01,$a2,$00,$c1,$be,$fb

data_1a_10df:
	db $05,$e0,$98,$01,$f8,$e1,$9a,$00,$01,$a4,$f8,$01,$a6,$00,$c1,$be,$fb

data_1a_10f0:
	db $04,$e0,$a8,$01,$f8,$e1,$aa,$00,$01,$9c,$f8,$01,$9e,$00

data_1a_10fe:
	db $02,$00,$aa,$41,$f8,$01,$a8,$00

data_1a_1106:
	db $08,$a0,$ac,$01,$f8,$a1,$ae,$00,$c0,$ae,$41,$f8,$c1,$ac,$00,$e0,$ac,$01,$f8,$e1,$ae,$00,$00,$ae,$41,$f8,$01,$ac,$00

data_1a_1123:
	db $08,$a0,$ae,$41,$f8,$a1,$ac,$00,$c0,$ac,$01,$f8,$c1,$ae,$00,$e0,$ae,$41,$f8,$e1,$ac,$00,$00,$b0,$01,$f8,$01,$b2,$00

data_1a_1140:
	db $08,$a0,$ac,$01,$f8,$a1,$ae,$00,$c0,$ae,$41,$f8,$c1,$ac,$00,$e0,$ac,$01,$f8,$e1,$ae,$00,$01,$a0,$f8,$01,$a2,$00

data_1a_115c:
	db $08,$a0,$ae,$41,$f8,$a1,$ac,$00,$c0,$ac,$01,$f8,$c1,$ae,$00,$e1,$b4,$f8,$e1,$b6,$00,$01,$a0,$f8,$01,$a2,$00

data_1a_1177:
	db $06,$c0,$ae,$41,$f8,$c1,$ac,$00,$e0,$98,$01,$f8,$e1,$9a,$00,$00,$a0,$01,$f8,$01,$a2,$00

data_1a_118d:
	db $02,$f0,$b8,$01,$f8,$f1,$ba,$00

data_1a_1195:
	db $02,$f0,$bc,$01,$f8,$f0,$ba,$81,$00

data_1a_119e:
	db $08,$e0,$c0,$02,$f0,$e1,$c2,$f8,$e1,$c4,$00,$e1,$c6,$08,$01,$c8,$f8,$01,$ca,$00,$21,$cc,$f8,$21,$ce,$00

data_1a_11b8:
	db $08,$e2,$c0,$02,$f0,$e3,$c2,$f8,$e3,$d0,$00,$f3,$d2,$08,$03,$c8,$f8,$03,$ca,$00,$23,$cc,$f8,$23,$ce,$00

data_1a_11d2:
	db $04,$e0,$c0,$01,$f7,$e1,$c2,$ff,$01,$c4,$f8,$01,$c6,$00

data_1a_11e0:
	db $04,$e0,$c0,$01,$f8,$e1,$c2,$00,$01,$c8,$f8,$01,$ca,$00

data_1a_11ee:
	db $05,$e0,$d0,$01,$f8,$e1,$d2,$00,$e1,$d4,$08,$01,$c4,$f8,$01,$ce,$00

data_1a_11ff:
	db $04,$e0,$d6,$01,$fb,$e1,$d8,$03,$01,$cc,$f8,$01,$ce,$00

data_1a_120d:
	db $05,$e2,$da,$01,$ee,$e1,$dc,$f6,$e1,$de,$fe,$01,$c6,$f8,$01,$c6,$00

data_1a_121e:
	db $04,$e0,$e2,$41,$f9,$e1,$e0,$ff,$00,$c8,$01,$f8,$01,$ca,$00

data_1a_122d:
	db $02,$00,$e0,$01,$f8,$01,$e2,$00

data_1a_1235:
	db $02,$00,$e4,$01,$f8,$01,$e6,$00

data_1a_123d:
	db $02,$f0,$f8,$01,$f8,$f1,$fa,$00

data_1a_1245:
	db $01,$f0,$fc,$01,$fc

data_1a_124a:
	db $02,$f0,$fa,$41,$f8,$f1,$f8,$00

data_1a_1252:
	db $07,$e0,$d0,$01,$f8,$e1,$d2,$00,$e1,$d4,$08,$e1,$ec,$10,$01,$c4,$f8,$01,$ce,$00,$01,$ee,$10

data_1a_1269:
	db $07,$e0,$d0,$01,$f7,$e1,$d2,$ff,$e1,$d4,$07,$e1,$ec,$0f,$01,$e8,$f7,$01,$ea,$ff,$00,$ee,$41,$0e

data_1a_1281:
	db $06,$e0,$d6,$01,$fb,$e1,$d8,$03,$e1,$f0,$0b,$e3,$f2,$13,$01,$cc,$f8,$01,$ce,$00

data_1a_1295:
	db $09,$f0,$f4,$01,$ce,$f1,$f6,$d6,$f1,$f6,$de,$f1,$f6,$e6,$e3,$da,$ee,$e1,$dc,$f6,$e1,$de,$fe,$01,$cc,$f8,$01,$ce,$00

data_1a_12b2:
	db $05,$dc,$c0,$01,$f0,$e0,$c2,$02,$f8,$e1,$c4,$00,$01,$c6,$f8,$01,$c8,$00

data_1a_12c4:
	db $05,$e0,$c0,$01,$ef,$e0,$c2,$02,$f7,$e1,$c4,$ff,$01,$ca,$f7,$01,$cc,$ff

data_1a_12d6:
	db $06,$e0,$ce,$01,$e8,$e1,$d0,$f0,$e0,$c2,$02,$f8,$e1,$c4,$00,$01,$d2,$f7,$01,$d4,$ff

data_1a_12eb:
	db $09,$e0,$d6,$01,$d6,$e1,$d6,$de,$e0,$d8,$02,$e6,$e1,$da,$ee,$e1,$dc,$f6,$01,$de,$e8,$01,$e0,$f0,$01,$e2,$f8,$01,$e4,$00

data_1a_1309:
	db $09,$e0,$e6,$01,$d6,$e1,$e8,$de,$e0,$d8,$02,$e6,$e1,$da,$ee,$e1,$dc,$f6,$01,$de,$e8,$01,$e0,$f0,$01,$e2,$f8,$01,$e4,$00

data_1a_1327:
	db $09,$f6,$e6,$01,$d6,$f7,$e8,$de,$e2,$d8,$02,$e6,$e1,$da,$ee,$e1,$dc,$f6,$01,$de,$e8,$01,$e0,$f0,$01,$e2,$f8,$01,$e4,$00

data_1a_1345:
	db $04,$e0,$80,$03,$f8,$e0,$80,$43,$00,$00,$82,$03,$f8,$00,$82,$43,$00

data_1a_1356:
	db $04,$e0,$84,$03,$f8,$e0,$84,$43,$00,$00,$86,$03,$f8,$00,$86,$43,$00

data_1a_1367:
	db $01,$f0,$8c,$03,$fc

data_1a_136c:
	db $02,$e0,$8c,$03,$fc,$00,$8c,$03,$fc

data_1a_1375:
	db $03,$d0,$8c,$03,$fc,$f0,$8c,$03,$fc,$10,$8c,$03,$fc

data_1a_1382:
	db $04,$c0,$8c,$03,$fc,$e0,$8c,$03,$fc,$00,$8c,$03,$fc,$20,$8c,$03,$fc

data_1a_1393:
	db $05,$b0,$8c,$03,$fc,$d0,$8c,$03,$fc,$f0,$8c,$03,$fc,$10,$8c,$03,$fc,$30,$8c,$03,$fc

data_1a_13a8:
	db $06,$a0,$8c,$03,$fc,$c0,$8c,$03,$fc,$e0,$8c,$03,$fc,$00,$8c,$03,$fc,$20,$8c,$03,$fc,$40,$8c,$03,$fc

data_1a_13c1:
	db $01,$f0,$88,$03,$fc

data_1a_13c6:
	db $01,$f0,$8a,$03,$fc

data_1a_13cb:
	db $01,$f0,$eb,$03,$fc

data_1a_13d0:
	db $01,$f0,$ed,$03,$fc

data_1a_13d5:
	db $01,$f0,$ef,$03,$fc

data_1a_13da:
	db $02,$e0,$8e,$02,$f8,$e0,$8e,$42,$ff

data_1a_13e3:
	db $02,$e0,$90,$02,$f8,$e0,$90,$42,$ff

data_1a_13ec:
	db $04,$e0,$92,$02,$f8,$e0,$92,$42,$ff,$00,$94,$02,$f8,$00,$94,$42,$ff

data_1a_13fd:
	db $08,$e0,$96,$02,$e8,$e1,$98,$f0,$e1,$9a,$f8,$e0,$9a,$42,$ff,$e1,$98,$07,$e1,$96,$0f,$00,$9c,$02,$f8,$01,$9c,$ff

data_1a_1419:
	db $07,$e0,$9e,$02,$f0,$e1,$a0,$f8,$e1,$a2,$00,$e1,$a4,$08,$e1,$a6,$10,$01,$a8,$f8,$01,$aa,$00

data_1a_1430:
	db $05,$e0,$ae,$02,$fb,$e1,$b0,$03,$f9,$ac,$f0,$01,$b2,$f8,$01,$b4,$00

data_1a_1441:
	db $06,$f0,$ac,$02,$f0,$f1,$b6,$f8,$f1,$b8,$00,$11,$ba,$f0,$11,$bc,$f8,$11,$be,$00

data_1a_1455:
	db $03,$e0,$de,$03,$f8,$e0,$de,$43,$00,$00,$ea,$03,$fc

data_1a_1462:
	db $03,$e0,$e0,$03,$f8,$e0,$e0,$43,$00,$01,$f0,$fc

data_1a_146e:
	db $04,$e0,$e2,$03,$f4,$e1,$e4,$fc,$e0,$e2,$43,$04,$00,$ea,$03,$fc

data_1a_147e:
	db $04,$e0,$e6,$03,$f4,$e1,$e8,$fc,$e0,$e6,$43,$04,$00,$f0,$03,$fc

data_1a_148e:
	db $02,$f0,$de,$03,$f8,$f0,$de,$43,$00

data_1a_1497:
	db $02,$f0,$e0,$03,$f8,$f0,$e0,$43,$00

data_1a_14a0:
	db $01,$f0,$ec,$03,$fc

data_1a_14a5:
	db $01,$f0,$ee,$03,$fc

data_1a_14aa:
	db $03,$f0,$e2,$03,$f4,$f1,$e4,$fc,$f0,$e2,$43,$04

data_1a_14b6:
	db $03,$f0,$e6,$03,$f4,$f1,$e8,$fc,$f0,$e6,$43,$04

data_1a_14c2:
	db $03,$f0,$84,$03,$f4,$f1,$86,$fc,$f1,$88,$04

data_1a_14cd:
	db $06,$e0,$84,$03,$f0,$e1,$86,$f8,$e1,$a8,$00,$01,$aa,$f8,$01,$ac,$00,$f9,$ae,$08

data_1a_14e1:
	db $03,$f0,$8a,$03,$f4,$f1,$8c,$fc,$f1,$88,$04

data_1a_14ec:
	db $05,$f0,$90,$03,$f0,$e9,$92,$f8,$e1,$94,$00,$e1,$96,$08,$01,$98,$00

data_1a_14fd:
	db $03,$f0,$80,$03,$f4,$f1,$82,$fc,$f1,$88,$04

data_1a_1508:
	db $04,$f0,$9a,$01,$f4,$f0,$80,$03,$f4,$f1,$82,$fc,$f1,$88,$04

data_1a_1517:
	db $05,$f0,$9c,$01,$ec,$f1,$9e,$f4,$f0,$80,$03,$f4,$f1,$82,$fc,$f1,$88,$04

data_1a_1529:
	db $07,$f0,$9c,$01,$dc,$f1,$a0,$e4,$f3,$a0,$ec,$f1,$9e,$f4,$f0,$80,$03,$f4,$f1,$82,$fc,$f1,$88,$04

data_1a_1541:
	db $04,$e0,$95,$02,$f5,$e1,$97,$fd,$01,$99,$f8,$01,$9b,$00

data_1a_154f:
	db $04,$e0,$9d,$02,$f5,$e1,$9f,$fd,$01,$b0,$f8,$01,$b2,$00

data_1a_155d:
	db $04,$e0,$b4,$02,$f5,$e1,$b6,$fd,$01,$b8,$f8,$01,$ba,$00

data_1a_156b:
	db $02,$00,$a2,$02,$f8,$00,$a2,$42,$00

data_1a_1574:
	db $02,$00,$bc,$02,$f8,$01,$be,$00

data_1a_157c:
	db $05,$e0,$d8,$02,$f8,$e1,$da,$00,$01,$dc,$f8,$01,$de,$00,$01,$e0,$08

data_1a_158d:
	db $05,$e0,$e2,$02,$f8,$e1,$e4,$00,$01,$e6,$f8,$01,$e8,$00,$01,$ea,$08

data_1a_159e:
	db $05,$e0,$ec,$02,$f9,$e1,$ee,$01,$01,$f0,$f8,$01,$f2,$00,$01,$f8,$08

data_1a_15af:
	db $01,$f0,$f4,$02,$fc

data_1a_15b4:
	db $01,$f0,$f6,$02,$fc

data_1a_15b9:
	db $01,$f0,$f8,$02,$fc

data_1a_15be:
	db $04,$e2,$b0,$01,$f8,$e3,$b2,$00,$01,$b4,$f8,$01,$b6,$00

data_1a_15cc:
	db $04,$e2,$b0,$01,$f8,$e3,$b2,$00,$01,$b8,$f8,$01,$ba,$00

data_1a_15da:
	db $04,$e0,$b0,$01,$f8,$e1,$b2,$00,$01,$bc,$f8,$01,$be,$00

data_1a_15e8:
	db $04,$e2,$c0,$01,$f8,$e3,$c2,$00,$01,$c4,$f8,$01,$c6,$00

data_1a_15f6:
	db $04,$e2,$c0,$01,$f8,$e3,$c2,$00,$01,$c8,$f8,$01,$ca,$00

data_1a_1604:
	db $04,$e0,$c0,$01,$f8,$e1,$c2,$00,$01,$cc,$f8,$01,$ce,$00

data_1a_1612:
	db $02,$f0,$f6,$01,$f8,$f1,$f8,$00

data_1a_161a:
	db $02,$f0,$fa,$01,$f8,$f1,$fc,$00

data_1a_1622:
	db $02,$f0,$b6,$01,$f8,$f1,$b8,$00

data_1a_162a:
	db $02,$f0,$ba,$01,$f8,$f1,$bc,$00

data_1a_1632:
	db $09,$d0,$c0,$01,$f0,$e1,$c2,$f8,$e1,$c4,$00,$db,$c6,$08,$d1,$c8,$10,$01,$ca,$fb,$01,$cc,$03,$1a,$84,$02,$f8,$1b,$86,$00

data_1a_1650:
	db $0a,$e6,$ce,$01,$f0,$e1,$d0,$f8,$e1,$d2,$00,$e7,$d4,$08,$05,$d6,$f0,$01,$d8,$f8,$01,$da,$00,$05,$dc,$08,$1e,$88,$02,$f8,$1f,$8a,$00

data_1a_1671:
	db $07,$d0,$c0,$01,$f0,$e1,$c2,$f8,$e1,$c4,$00,$db,$c6,$08,$d1,$c8,$10,$01,$ca,$fb,$01,$cc,$03

data_1a_1688:
	db $08,$e6,$ce,$01,$f0,$e1,$d0,$f8,$e1,$d2,$00,$e7,$d4,$08,$05,$d6,$f0,$01,$d8,$f8,$01,$da,$00,$05,$dc,$08


bossAssembTable00_1a_16a2:
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_17a9
	dw data_1a_17ca
	dw data_1a_17a9
	dw data_1a_17ee
	dw data_1a_1815
	dw data_1a_1836
	dw data_1a_1860
	dw data_1a_1881
	dw data_1a_1889
	dw data_1a_188e
	dw data_1a_1896
	dw data_1a_18b7
	dw data_1a_18d8
	dw data_1a_18b7
	dw data_1a_18fc
	dw data_1a_1920
	dw data_1a_1944
	dw data_1a_1961
	dw data_1a_196f
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_1978
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_1782
	dw data_1a_19f3
	dw data_1a_1a07
	dw data_1a_1a1b
	dw data_1a_1a2f
	dw data_1a_1a43
	dw data_1a_1a57
	dw data_1a_1a6e
	dw data_1a_1a82
	dw data_1a_1a96
	dw data_1a_1aa7
	dw data_1a_1aaf
	dw data_1a_1ab7
	dw data_1a_1abf
	dw data_1a_1ac7
	dw data_1a_1af0
	dw data_1a_1b17
	dw data_1a_1b31
	dw data_1a_1b48
	dw data_1a_1b5f
	dw data_1a_1b6a
	dw data_1a_1b78
	dw data_1a_1b80
	dw data_1a_1b88
	dw data_1a_1b96
	dw data_1a_1bbd
	dw data_1a_1bd7
	dw data_1a_1bdc
	dw data_1a_1bf6
	dw data_1a_1c17
	dw data_1a_1c45
	dw data_1a_1c66
	dw data_1a_1c87
	dw data_1a_1cb1
	dw data_1a_1cbd
	dw data_1a_1cc6
	dw data_1a_1cce
	dw data_1a_1cd6
	dw data_1a_1cde
	dw data_1a_1cfb
	dw data_1a_1d15
	dw data_1a_1d26
	dw data_1a_1d37
	dw data_1a_1d45
	dw data_1a_1d53
	dw data_1a_1d61
	dw data_1a_1acf
	dw data_1a_1add
	dw data_1a_1ae8
	dw data_1a_1d6f
	dw data_1a_1d7d
	dw data_1a_1d88
	dw data_1a_1d93
	dw data_1a_1da1
	dw data_1a_1daf
	dw data_1a_1db7
	dw data_1a_1dbf
	dw data_1a_1dc4
	dw data_1a_1dcc
	dw data_1a_1dd4
	dw data_1a_1dd9
	dw data_1a_1dde
	dw data_1a_1de3
	dw data_1a_1de8
	dw data_1a_1ded
	dw data_1a_1df2
	dw data_1a_1dfb
	dw data_1a_1e1a
	dw data_1a_1e31
	dw data_1a_1e40
	dw data_1a_1e4f
	dw data_1a_1e75
	dw data_1a_1e95
	dw data_1a_1e75
	dw data_1a_1ebb
	dw data_1a_1ee1
	dw data_1a_1f0a
	dw data_1a_1f30
	dw data_1a_1f56
	dw data_1a_1f82
	dw data_1a_1f9f
	dw data_1a_1fb3
	dw data_1b_09b9
	dw data_1b_099b

data_1a_1782:
	db $0c,$f0,$c0,$03,$00,$f1,$c2,$08,$d2,$80,$02,$ee,$d3,$82,$f6,$d3,$84,$fe,$d1,$86,$e8,$f1,$88,$e8,$f1,$8a,$f0,$f1,$8c,$f8,$11,$8e,$f8,$11,$90,$00,$11,$92,$08

data_1a_17a9:
	db $0a,$f2,$c0,$03,$ff,$f3,$c2,$07,$d0,$80,$02,$f0,$d1,$82,$f8,$d1,$84,$00,$e1,$94,$e8,$f1,$96,$f0,$f1,$98,$f8,$11,$9a,$fa,$11,$9c,$02

data_1a_17ca:
	db $0b,$f2,$c0,$03,$fd,$f3,$c2,$05,$d2,$80,$02,$f0,$d3,$82,$f8,$d3,$84,$00,$f1,$9e,$e8,$f1,$a0,$f0,$f1,$a2,$f8,$11,$a4,$f8,$11,$a6,$00,$11,$a8,$08

data_1a_17ee:
	db $0c,$f0,$c0,$03,$01,$f1,$c2,$09,$d2,$80,$02,$f3,$d3,$82,$fb,$d3,$84,$03,$d1,$86,$ea,$f1,$88,$ea,$f1,$8a,$f2,$f1,$8c,$fa,$11,$8e,$f8,$11,$90,$00,$11,$92,$08

data_1a_1815:
	db $0a,$f0,$c0,$03,$01,$f1,$c2,$09,$d2,$aa,$02,$f8,$d3,$ac,$00,$d3,$ae,$08,$d3,$b0,$10,$f1,$8c,$fb,$11,$8e,$f8,$11,$90,$00,$11,$92,$08

data_1a_1836:
	db $0d,$f2,$c0,$03,$00,$f3,$c2,$08,$d2,$80,$02,$f0,$d3,$82,$f8,$d3,$84,$00,$f7,$9e,$d8,$f7,$a0,$e0,$f5,$b2,$e8,$f1,$b4,$f0,$f1,$a2,$f8,$11,$a4,$f8,$11,$a6,$00,$11,$a8,$08

data_1a_1860:
	db $0a,$f2,$c0,$03,$ff,$f3,$c2,$07,$d0,$80,$02,$f0,$d1,$82,$f8,$d1,$84,$00,$e1,$94,$e8,$f1,$96,$f0,$f1,$98,$f8,$11,$f2,$f8,$11,$f4,$00

data_1a_1881:
	db $02,$f8,$ec,$02,$f8,$f9,$ee,$00

data_1a_1889:
	db $01,$f8,$f0,$02,$fc

data_1a_188e:
	db $02,$f8,$ee,$42,$f8,$f9,$ec,$00

data_1a_1896:
	db $0a,$c2,$80,$01,$f2,$c3,$82,$fa,$c3,$84,$02,$e1,$86,$f6,$e1,$88,$fe,$e1,$8a,$06,$01,$8c,$fc,$01,$8e,$04,$ba,$b4,$02,$ff,$bb,$b6,$07

data_1a_18b7:
	db $0a,$c0,$80,$01,$f3,$c1,$82,$fb,$c1,$84,$03,$e1,$90,$f7,$e1,$92,$ff,$e1,$94,$07,$01,$96,$fb,$01,$98,$03,$ba,$b4,$02,$00,$bb,$b6,$08

data_1a_18d8:
	db $0b,$c0,$80,$01,$f4,$c1,$82,$fc,$c1,$84,$04,$e1,$9a,$f8,$e1,$9c,$00,$e1,$9e,$08,$01,$a0,$f8,$01,$a2,$00,$01,$a4,$08,$b8,$b4,$02,$00,$b9,$b6,$08

data_1a_18fc:
	db $0b,$c0,$a6,$01,$f9,$c1,$a8,$01,$c1,$aa,$09,$e1,$ac,$f8,$e1,$ae,$00,$e1,$b0,$08,$01,$a0,$f8,$01,$a2,$00,$01,$a4,$08,$b0,$b8,$02,$08,$b1,$ba,$10

data_1a_1920:
	db $0b,$c0,$80,$01,$f2,$c1,$82,$fa,$c1,$84,$02,$e1,$b2,$f6,$e1,$88,$fe,$e1,$8a,$06,$01,$8c,$fc,$01,$8e,$04,$00,$b8,$02,$e4,$01,$ba,$ec,$01,$be,$f4

data_1a_1944:
	db $09,$a0,$c4,$02,$fb,$c1,$c6,$f3,$c1,$c8,$fb,$c1,$ca,$03,$e1,$cc,$f8,$e1,$ce,$00,$01,$d0,$f3,$01,$d2,$fb,$01,$d4,$03

data_1a_1961:
	db $04,$f0,$51,$01,$f0,$f1,$61,$f8,$f1,$53,$00,$f1,$63,$08

data_1a_196f:
	db $02,$00,$f4,$01,$fc,$18,$f4,$41,$f8

data_1a_1978:
	db $1b,$80,$f0,$01,$fc,$91,$c4,$cc,$91,$c8,$d4,$90,$c4,$c1,$dc,$a0,$c6,$41,$e4,$a1,$c8,$ec,$a0,$c4,$01,$f4,$a0,$f2,$41,$fc,$b0,$e0,$01,$d4,$b1,$d6,$dc,$b1,$c4,$04,$c1,$d8,$cc,$c1,$f2,$fc,$d0,$d8,$41,$d4,$e0,$f2,$01,$f6,$e1,$f0,$fc,$e1,$c8,$04,$e1,$ce,$0c,$01,$f2,$f2,$00,$f2,$c1,$fc,$00,$c2,$01,$14,$21,$e0,$e4,$21,$f2,$ec,$20,$f0,$c1,$fc,$40,$ca,$41,$e4,$40,$f2,$01,$fc,$60,$f2,$41,$fc

data_1a_19d8:
	db $08,$c2,$80,$01,$f2,$c3,$82,$fa,$c3,$84,$02,$e1,$86,$f6,$e1,$88,$fe,$e1,$8a,$06,$ba,$b4,$02,$ff,$bb,$b6,$07

data_1a_19f3:
	db $06,$e0,$80,$02,$f8,$e1,$82,$00,$e1,$84,$08,$01,$86,$f8,$01,$88,$00,$01,$8a,$08

data_1a_1a07:
	db $06,$f0,$8c,$02,$e8,$e1,$8e,$f0,$e1,$90,$f8,$e1,$92,$00,$01,$94,$00,$01,$96,$08

data_1a_1a1b:
	db $06,$e0,$98,$02,$f0,$e1,$9a,$f8,$e1,$9c,$00,$01,$9e,$f0,$01,$a0,$f8,$01,$a2,$00

data_1a_1a2f:
	db $06,$d6,$a4,$02,$f0,$e1,$a6,$f8,$e1,$a8,$00,$11,$aa,$f0,$01,$ac,$f8,$01,$ae,$00

data_1a_1a43:
	db $06,$f0,$b0,$02,$f0,$e1,$b2,$f8,$e1,$b4,$00,$01,$b6,$f8,$01,$b8,$00,$f1,$ba,$08

data_1a_1a57:
	db $07,$e0,$bc,$02,$f0,$e1,$be,$f8,$01,$c0,$f0,$01,$c2,$f8,$f1,$c4,$00,$e9,$c6,$08,$e1,$c8,$10

data_1a_1a6e:
	db $06,$e0,$9e,$82,$f0,$e1,$a0,$f8,$e1,$a2,$00,$01,$98,$f0,$01,$9a,$f8,$01,$9c,$00

data_1a_1a82:
	db $06,$d0,$aa,$82,$f0,$e1,$ac,$f8,$e1,$ae,$00,$0b,$a4,$f0,$01,$a6,$f8,$01,$a8,$00

data_1a_1a96:
	db $05,$f0,$ce,$02,$e8,$f1,$d0,$f0,$f1,$d2,$f8,$f1,$d4,$00,$f1,$d6,$08

data_1a_1aa7:
	db $02,$f0,$d8,$81,$f8,$f1,$da,$00

data_1a_1aaf:
	db $02,$f0,$dc,$02,$f8,$f1,$de,$00

data_1a_1ab7:
	db $02,$f0,$de,$42,$f8,$f1,$dc,$00

data_1a_1abf:
	db $02,$f0,$de,$c2,$f8,$f1,$dc,$00

data_1a_1ac7:
	db $02,$f0,$dc,$82,$f8,$f1,$de,$00

data_1a_1acf:
	db $04,$f0,$f2,$00,$f0,$f1,$f4,$f8,$f1,$f6,$00,$f1,$f8,$08

data_1a_1add:
	db $03,$f0,$e0,$00,$f4,$f1,$e2,$fc,$f1,$e4,$04

data_1a_1ae8:
	db $02,$f0,$ca,$02,$f8,$f1,$cc,$00

data_1a_1af0:
	db $0c,$e0,$82,$02,$f8,$e1,$84,$00,$e1,$86,$08,$e1,$88,$10,$e1,$8a,$18,$01,$8c,$f8,$01,$8e,$00,$01,$90,$08,$01,$92,$10,$01,$e0,$f0,$e0,$8a,$42,$e8,$e1,$88,$f0

data_1a_1b17:
	db $08,$d0,$94,$02,$f8,$d1,$96,$00,$f1,$98,$f7,$f1,$9a,$ff,$f1,$9c,$07,$11,$9e,$f6,$11,$a0,$fe,$11,$a2,$06

data_1a_1b31:
	db $07,$e0,$a4,$02,$f0,$e1,$a6,$f8,$e1,$a8,$00,$e1,$aa,$08,$e1,$ac,$10,$01,$ae,$f8,$01,$b0,$00

data_1a_1b48:
	db $07,$e0,$b2,$02,$f9,$e1,$b4,$ff,$01,$b6,$f8,$01,$b8,$00,$01,$ba,$08,$21,$bc,$fa,$21,$be,$02

data_1a_1b5f:
	db $03,$f0,$c0,$02,$f8,$f1,$c2,$00,$f1,$c4,$08

data_1a_1b6a:
	db $03,$f0,$c6,$02,$fb,$f1,$c8,$03,$01,$ca,$fb,$01,$cc,$03

data_1a_1b78:
	db $02,$f0,$ce,$02,$f8,$f1,$d0,$00

data_1a_1b80:
	db $02,$f8,$d2,$02,$f8,$f9,$d4,$00

data_1a_1b88:
	db $04,$e0,$d6,$02,$f8,$e1,$d8,$00,$01,$da,$f8,$01,$dc,$00

data_1a_1b96:
	db $0c,$e0,$8c,$82,$f8,$e1,$8e,$00,$e1,$90,$08,$e1,$92,$10,$e1,$e0,$f0,$01,$82,$f8,$01,$84,$00,$01,$86,$08,$01,$88,$10,$01,$8a,$18,$00,$8a,$c2,$e8,$01,$88,$f0

data_1a_1bbd:
	db $08,$d0,$9e,$82,$f6,$d1,$a0,$fe,$d1,$a2,$06,$f1,$98,$f7,$f1,$9a,$ff,$f1,$9c,$07,$11,$94,$f8,$11,$96,$00

data_1a_1bd7:
	db $01,$00,$80,$03,$00

data_1a_1bdc:
	db $08,$e0,$82,$01,$f4,$e1,$84,$fc,$e1,$86,$04,$e1,$88,$0c,$01,$8a,$f4,$01,$8c,$fc,$01,$8e,$04,$01,$90,$0c

data_1a_1bf6:
	db $0a,$d4,$92,$01,$f4,$d1,$94,$fc,$d1,$96,$04,$d5,$98,$0c,$e0,$be,$03,$f8,$e1,$c0,$00,$e1,$c2,$08,$01,$c4,$f8,$01,$c6,$00,$01,$c8,$08

data_1a_1c17:
	db $0e,$b0,$b6,$03,$ff,$a0,$9a,$01,$f4,$a1,$9c,$fc,$a1,$9e,$04,$a1,$a0,$0c,$c0,$b8,$03,$f8,$c1,$ba,$00,$c1,$bc,$08,$e1,$be,$f8,$e1,$c0,$00,$e1,$c2,$08,$01,$c4,$f8,$01,$c6,$00,$01,$c8,$08

data_1a_1c45:
	db $0a,$b0,$b6,$01,$ff,$c0,$b8,$03,$f8,$c1,$ba,$00,$c1,$bc,$08,$e1,$be,$f8,$e1,$c0,$00,$e1,$c2,$08,$01,$c4,$f8,$01,$c6,$00,$01,$c8,$08

data_1a_1c66:
	db $0a,$b0,$b6,$01,$ff,$c0,$ca,$03,$f8,$c1,$ba,$00,$c1,$bc,$08,$e1,$cc,$f8,$e1,$ce,$00,$e1,$c2,$08,$01,$d0,$f8,$01,$d2,$00,$01,$c8,$08

data_1a_1c87:
	db $0d,$b0,$b6,$01,$ff,$c0,$d4,$03,$f8,$c1,$d6,$00,$c1,$d8,$08,$c1,$da,$10,$e1,$cc,$f8,$e1,$ea,$00,$e1,$ea,$08,$e1,$dc,$10,$01,$d0,$f8,$01,$ea,$00,$01,$ea,$08,$01,$de,$10

data_1a_1cb1:
	db $03,$f0,$a2,$03,$f4,$f1,$a4,$fc,$f0,$a2,$43,$04

data_1a_1cbd:
	db $02,$f0,$a6,$03,$f8,$f0,$a6,$43,$00

data_1a_1cc6:
	db $02,$f0,$a8,$03,$f8,$f1,$aa,$00

data_1a_1cce:
	db $02,$f0,$ac,$03,$f8,$f1,$ae,$00

data_1a_1cd6:
	db $02,$f0,$ac,$83,$f8,$f1,$ae,$00

data_1a_1cde:
	db $09,$c6,$b8,$03,$f8,$c7,$ba,$00,$c7,$bc,$08,$e1,$b8,$f8,$e1,$c0,$00,$e1,$c2,$08,$01,$c4,$f8,$01,$c6,$00,$01,$c8,$08

data_1a_1cfb:
	db $08,$00,$e2,$03,$f0,$01,$ea,$f8,$01,$e4,$00,$01,$e6,$08,$01,$e8,$10,$e7,$b8,$f8,$e7,$ba,$00,$e7,$bc,$08

data_1a_1d15:
	db $05,$00,$ec,$03,$f0,$01,$ee,$f8,$01,$f0,$00,$01,$f2,$08,$01,$f4,$10

data_1a_1d26:
	db $05,$00,$ec,$01,$f0,$01,$ee,$f8,$01,$f0,$00,$01,$f2,$08,$01,$f4,$10

data_1a_1d37:
	db $04,$00,$f6,$02,$f4,$01,$f8,$fc,$01,$fa,$04,$01,$fc,$0c

data_1a_1d45:
	db $04,$00,$f6,$01,$f4,$01,$f8,$fc,$01,$fa,$04,$01,$fc,$0c

data_1a_1d53:
	db $04,$e0,$57,$01,$f8,$e1,$59,$00,$01,$69,$f8,$01,$6b,$00

data_1a_1d61:
	db $04,$e0,$57,$03,$f8,$e1,$59,$00,$01,$69,$f8,$01,$6b,$00

data_1a_1d6f:
	db $04,$e0,$d4,$02,$f7,$e1,$d6,$ff,$01,$d8,$f9,$01,$da,$01

data_1a_1d7d:
	db $03,$ea,$c0,$02,$f4,$ef,$c2,$fc,$f1,$c4,$04

data_1a_1d88:
	db $03,$f2,$c6,$02,$f4,$f1,$c8,$fc,$ef,$ca,$04

data_1a_1d93:
	db $04,$e0,$ce,$02,$fc,$e1,$d0,$04,$f1,$cc,$f4,$01,$d2,$fc

data_1a_1da1:
	db $04,$e0,$da,$c2,$f7,$e1,$d8,$ff,$01,$d6,$f9,$01,$d4,$01

data_1a_1daf:
	db $02,$f0,$e2,$02,$f8,$f1,$e4,$00

data_1a_1db7:
	db $02,$f0,$de,$02,$f8,$f1,$e0,$00

data_1a_1dbf:
	db $01,$f0,$dc,$02,$fc

data_1a_1dc4:
	db $02,$f0,$e0,$42,$f8,$f1,$de,$00

data_1a_1dcc:
	db $02,$f0,$e4,$42,$f8,$f1,$e2,$00

data_1a_1dd4:
	db $01,$f0,$ea,$02,$fc

data_1a_1dd9:
	db $01,$f0,$e8,$02,$fc

data_1a_1dde:
	db $01,$f0,$e6,$02,$fc

data_1a_1de3:
	db $01,$f0,$e8,$82,$fc

data_1a_1de8:
	db $01,$f0,$ea,$82,$fc

data_1a_1ded:
	db $01,$00,$b6,$01,$fc

data_1a_1df2:
	db $02,$00,$b8,$01,$f8,$00,$b8,$41,$00

data_1a_1dfb:
	db $08,$c0,$ba,$01,$f8,$c0,$ee,$41,$00,$e0,$bc,$01,$f8,$e0,$bc,$41,$00,$00,$be,$01,$f0,$01,$ec,$f8,$00,$ec,$41,$00,$01,$be,$08

data_1a_1e1a:
	db $06,$e0,$ee,$01,$f8,$e0,$ba,$41,$00,$00,$f0,$01,$f0,$01,$f2,$f8,$00,$f2,$41,$00,$01,$f0,$08

data_1a_1e31:
	db $04,$00,$f4,$01,$f0,$01,$f6,$f8,$00,$f6,$41,$00,$01,$f4,$08

data_1a_1e40:
	db $04,$00,$f8,$01,$f0,$01,$f8,$f8,$00,$f8,$41,$00,$01,$f8,$08

data_1a_1e4f:
	db $0c,$c2,$80,$02,$ef,$c1,$82,$f7,$c1,$84,$00,$e1,$86,$f2,$e1,$88,$fa,$e1,$8a,$02,$01,$8c,$f0,$01,$8e,$f8,$01,$90,$00,$21,$92,$f3,$21,$94,$fb,$21,$96,$03

data_1a_1e75:
	db $0a,$c0,$80,$02,$f0,$c1,$98,$f8,$c1,$9a,$00,$e1,$9c,$f0,$e1,$9e,$f8,$e1,$a0,$00,$01,$a2,$f6,$01,$a4,$fe,$21,$a6,$f8,$21,$a8,$00

data_1a_1e95:
	db $0c,$c2,$80,$02,$f1,$c1,$aa,$f9,$c1,$ac,$01,$e1,$ae,$f3,$e1,$b0,$fb,$e1,$b2,$03,$01,$b4,$f2,$01,$b6,$fa,$01,$b8,$02,$21,$ba,$f3,$21,$bc,$fb,$21,$be,$03

data_1a_1ebb:
	db $0c,$c2,$80,$02,$f4,$c1,$82,$fc,$c1,$84,$04,$e1,$86,$f5,$e1,$88,$fd,$e1,$8a,$05,$01,$c0,$f1,$01,$c2,$f9,$01,$90,$01,$21,$c4,$f0,$21,$c6,$fb,$21,$96,$03

data_1a_1ee1:
	db $0d,$c2,$80,$02,$f6,$c1,$82,$fe,$c1,$84,$06,$e1,$c8,$f0,$e1,$ca,$f8,$e1,$cc,$00,$e1,$ce,$08,$01,$d0,$eb,$01,$d2,$f3,$01,$d4,$fb,$01,$d6,$03,$21,$d8,$fb,$21,$da,$03

data_1a_1f0a:
	db $0c,$c2,$80,$02,$ec,$c1,$82,$f4,$c1,$84,$fc,$e1,$86,$f0,$e1,$88,$f8,$e1,$8a,$00,$01,$8c,$ef,$01,$8e,$f7,$01,$90,$ff,$21,$92,$f3,$21,$94,$fb,$21,$96,$03

data_1a_1f30:
	db $0c,$c0,$dc,$02,$f4,$c1,$de,$fc,$c1,$e0,$04,$e1,$e2,$f4,$e1,$9e,$fc,$e1,$a0,$04,$01,$e4,$f1,$01,$8e,$f7,$01,$90,$01,$21,$92,$f3,$21,$94,$fb,$21,$96,$03

data_1a_1f56:
	db $0e,$c2,$80,$02,$ec,$c1,$82,$f4,$c1,$84,$fc,$e1,$e6,$e0,$e1,$e8,$e8,$e1,$ea,$f0,$e1,$88,$f8,$e1,$8a,$00,$01,$e4,$ef,$01,$8e,$f7,$01,$90,$ff,$21,$92,$f3,$21,$94,$fb,$21,$96,$03

data_1a_1f82:
	db $09,$c2,$80,$02,$ec,$c1,$82,$f4,$c1,$84,$fc,$e1,$86,$f0,$e1,$88,$f8,$e1,$8a,$00,$01,$ec,$f3,$01,$ee,$fb,$01,$f0,$03

data_1a_1f9f:
	db $06,$c2,$80,$02,$ec,$c1,$82,$f4,$c1,$84,$fc,$e1,$86,$f0,$e1,$88,$f8,$e1,$8a,$00

data_1a_1fb3:
	db $0b,$c0,$f2,$02,$f9,$c1,$f4,$01,$e1,$ae,$f5,$e1,$b0,$fd,$e1,$b2,$05,$01,$b4,$f2,$01,$b6,$fa,$01,$b8,$02,$21,$ba,$f3,$21,$bc,$fb,$21,$be,$03


data_1a_1fd6:
	dw data_1b_00d6
	dw data_1b_00de
	dw data_1a_1f56
	dw data_1b_00d6
	dw data_1a_17ee
	dw data_1a_1815
	dw data_1a_1836
	dw data_1a_1896
	dw data_1a_19d8
	dw data_1b_0104
	dw data_1b_0112
	dw data_1b_0120
	dw data_1b_012e
	dw data_1b_013f
	dw data_1b_0147
	dw data_1b_09c3
	dw data_1b_09a5
	dw data_1b_09af
	dw data_1b_014f
	dw data_1b_015d
	dw data_1b_0171

; ----------------------------------------------------------------------------------------
;bank $1b 			; ROM 36000
;base $a000
;org $a000				; $a048		; $a0d6
	dw data_1b_018b
	dw data_1b_01ab
	dw data_1b_01c8
	dw data_1b_01e5
	dw data_1b_0202
	dw data_1b_0225
	dw data_1b_0248
	dw data_1b_026b
	dw data_1b_0291
	dw data_1b_02b7
	dw data_1b_02dd
	dw data_1b_02fb
	dw data_1b_0306
	dw data_1b_0311
	dw data_1b_0320
	dw data_1b_0335
	dw data_1b_0350
	dw data_1b_035b
	dw data_1b_0363
	dw data_1b_0368
	dw data_1b_036d
	dw data_1b_0376
	dw data_1b_0388
	dw data_1b_03a3
	dw data_1b_03be
	dw data_1b_03d5
	dw data_1b_03ec
	dw data_1b_040d
	dw data_1b_0431
	dw data_1b_044e
	dw data_1b_046b
	dw data_1b_0488
	dw data_1b_04c9
	dw data_1b_04fe
	dw data_1b_04c9
	dw data_1b_0530
	dw data_1b_059a
	dw data_1b_05a2
	dw data_1b_05ae
	dw data_1b_05c6
	dw data_1b_05cb
	dw data_1b_05df
	dw data_1b_05f0
	dw data_1b_0601
	dw data_1b_0618
	dw data_1b_062c
	dw data_1b_063a
	dw data_1b_0649
	dw data_1b_0651
	dw data_1b_065a
	dw data_1b_066c
	dw data_1b_0687
	dw data_1b_06a8
	dw data_1b_06c9
	dw data_1b_06f6
	dw data_1b_06fe
	dw data_1b_0706
	dw data_1b_0712
	dw data_1b_072b
	dw data_1b_074f
	dw data_1b_0779
	dw data_1b_077e
	dw data_1b_0786
	dw data_1b_0791
	dw data_1b_0571
	dw data_1b_05ba
	dw data_1b_079f
	dw data_1b_07d2
	dw data_1b_0805
	dw data_1b_083e
	dw data_1b_0871
	dw data_1b_08a6
	dw data_1b_08ae
	dw data_1b_08b6
	dw data_1b_08be
	dw data_1b_08c6
	dw data_1b_08d1
	dw data_1b_08dc
	dw data_1b_08e7
	dw data_1b_08f2
	dw data_1b_08fd
	dw data_1b_0908
	dw data_1b_0916
	dw data_1b_0924
	dw data_1b_0932
	dw data_1b_0941
	dw data_1b_0950
	dw data_1b_0955
	dw data_1b_095d
	dw data_1b_0965
	dw data_1b_0970
	dw data_1b_097c
	dw data_1b_0981
	dw data_1b_0989
	dw data_1b_0992
	dw data_1b_09a0
	dw data_1b_09aa
	dw data_1b_09b4
	dw data_1b_09be
	dw data_1b_09c8
	dw data_1b_09cd
	dw data_1b_09d2
	dw data_1b_09d7
	dw data_1b_09dc
	dw data_1b_09e1
	dw data_1b_09e6
	dw data_1b_09eb

data_1b_00d6:
	db $02,$f0,$fa,$01,$f8,$f1,$fc,$00

data_1b_00de:
	db $0c,$c2,$80,$02,$f3,$c1,$82,$fb,$c1,$84,$03,$e1,$f6,$f5,$e1,$f8,$fd,$e1,$8a,$05,$01,$e4,$f1,$01,$8e,$f9,$01,$90,$01,$21,$92,$f3,$21,$94,$fb,$21,$96,$03

data_1b_0104:
	db $04,$c0,$80,$03,$f8,$c1,$82,$00,$e1,$84,$f8,$e1,$86,$00

data_1b_0112:
	db $04,$d8,$88,$03,$f0,$e1,$8a,$f0,$e1,$8c,$f8,$e1,$8e,$00

data_1b_0120:
	db $04,$e8,$90,$03,$e8,$e1,$92,$f0,$e1,$94,$f8,$e1,$96,$00

data_1b_012e:
	db $05,$e0,$98,$03,$e8,$d1,$9a,$f0,$f1,$9c,$f0,$e1,$9e,$f8,$e1,$a0,$00

data_1b_013f:
	db $02,$f0,$a2,$03,$f8,$f1,$a4,$00

data_1b_0147:
	db $02,$f0,$a6,$03,$f8,$f1,$ae,$00

data_1b_014f:
	db $04,$f0,$a2,$03,$f8,$f1,$a4,$00,$11,$a2,$f8,$11,$a4,$00

data_1b_015d:
	db $06,$f0,$a2,$03,$f8,$f1,$a4,$00,$11,$a2,$f8,$11,$a4,$00,$31,$a2,$f8,$31,$a4,$00

data_1b_0171:
	db $08,$f0,$a2,$03,$f8,$f1,$a4,$00,$11,$a2,$f8,$11,$a4,$00,$31,$a2,$f8,$31,$a4,$00,$51,$a2,$f8,$51,$a4,$00

data_1b_018b:
	db $0a,$f0,$a2,$03,$f8,$f1,$a4,$00,$11,$a2,$f8,$11,$a4,$00,$31,$a2,$f8,$31,$a4,$00,$51,$a2,$f8,$51,$a4,$00,$71,$a2,$f8,$71,$a4,$00

data_1b_01ab:
	db $09,$d2,$9a,$03,$f2,$d3,$9c,$fa,$eb,$98,$ea,$f3,$9e,$f2,$f3,$a0,$fa,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_01c8:
	db $09,$d0,$9a,$03,$f1,$d1,$9c,$f9,$e9,$98,$e9,$f1,$9e,$f1,$f1,$a0,$f9,$11,$80,$f0,$11,$8a,$f8,$11,$8c,$00,$11,$8e,$08

data_1b_01e5:
	db $09,$d0,$9a,$03,$f0,$d1,$9c,$f8,$e9,$98,$e8,$f1,$9e,$f0,$f1,$a0,$f8,$11,$90,$f0,$11,$92,$f8,$11,$94,$00,$11,$96,$08

data_1b_0202:
	db $0b,$d2,$9a,$03,$f4,$d3,$9c,$fc,$d1,$a2,$e7,$f1,$a4,$e7,$f1,$a6,$ed,$f1,$a8,$f5,$f1,$aa,$fd,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_0225:
	db $0b,$d0,$9a,$03,$f5,$d1,$9c,$fd,$d1,$a2,$e7,$f1,$a4,$e7,$f1,$a6,$ef,$f1,$ac,$f7,$f1,$ae,$ff,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_0248:
	db $0b,$d0,$9a,$03,$f5,$d1,$b0,$fd,$d1,$a2,$e9,$f1,$b2,$e7,$f1,$b4,$ef,$f1,$b6,$f7,$f1,$b8,$ff,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_026b:
	db $0c,$d0,$ba,$03,$e4,$d1,$bc,$ec,$d1,$be,$f4,$d1,$c0,$fc,$f1,$c2,$e4,$f1,$c4,$ec,$f1,$c6,$f4,$f1,$c8,$fc,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_0291:
	db $0c,$d0,$ba,$03,$e4,$d1,$bc,$ec,$d1,$be,$f4,$d1,$c0,$fc,$f1,$c2,$e4,$f1,$c4,$ec,$f1,$ca,$f4,$f1,$cc,$fc,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_02b7:
	db $0c,$d2,$ba,$03,$e8,$d3,$ce,$ef,$d3,$be,$f7,$d3,$c0,$ff,$f3,$c2,$e8,$f3,$d0,$f0,$f3,$d2,$f8,$f3,$d4,$00,$11,$80,$f0,$11,$82,$f8,$11,$84,$00,$11,$86,$08

data_1b_02dd:
	db $09,$d0,$9a,$01,$f0,$d1,$9c,$f8,$e8,$98,$03,$e8,$f1,$9e,$f0,$f1,$a0,$f8,$11,$90,$f0,$11,$92,$f8,$11,$94,$00,$11,$96,$08

data_1b_02fb:
	db $03,$f0,$e6,$03,$f4,$f1,$e8,$fc,$f1,$ea,$04

data_1b_0306:
	db $03,$f0,$ec,$03,$f4,$f1,$ee,$fc,$f1,$f0,$04

data_1b_0311:
	db $04,$f0,$ea,$43,$f0,$f0,$f2,$03,$f8,$f1,$f4,$00,$f1,$f0,$08

data_1b_0320:
	db $06,$d0,$f4,$43,$f8,$d1,$f2,$00,$f1,$f0,$f0,$f0,$f6,$03,$f8,$f1,$f8,$00,$f1,$ea,$08

data_1b_0335:
	db $08,$b0,$f2,$03,$f8,$b1,$f4,$00,$f1,$f0,$08,$d0,$f8,$43,$f8,$d1,$f6,$00,$f1,$ea,$f0,$f1,$f8,$f8,$f1,$f6,$00

data_1b_0350:
	db $03,$f0,$d6,$01,$f8,$f1,$d8,$00,$f1,$da,$08

data_1b_035b:
	db $02,$f0,$dc,$01,$f8,$f1,$de,$00

data_1b_0363:
	db $01,$f0,$e0,$03,$fc

data_1b_0368:
	db $01,$f0,$e2,$03,$fc

data_1b_036d:
	db $02,$e0,$e4,$03,$fc,$00,$e4,$83,$fc

data_1b_0376:
	db $05,$10,$e4,$03,$0c,$11,$e6,$14,$10,$c4,$02,$f0,$11,$c6,$f8,$11,$c8,$00

data_1b_0388:
	db $08,$10,$e8,$03,$08,$11,$ea,$10,$f0,$cc,$02,$00,$f1,$ce,$08,$11,$d0,$f0,$11,$d2,$f8,$11,$d4,$00,$11,$d6,$08

data_1b_03a3:
	db $08,$10,$e8,$03,$00,$11,$ea,$08,$f0,$d8,$02,$f0,$f1,$da,$f8,$f1,$dc,$00,$11,$de,$f0,$11,$e0,$f8,$11,$e2,$00

data_1b_03be:
	db $07,$e0,$f0,$02,$00,$dd,$80,$f1,$e1,$e6,$f9,$e1,$e8,$01,$01,$ea,$f0,$01,$ec,$f8,$01,$8a,$00

data_1b_03d5:
	db $07,$e0,$fa,$02,$ee,$e1,$fc,$f6,$e1,$84,$fe,$f1,$ee,$e6,$01,$ea,$f0,$01,$ec,$f8,$01,$8a,$00

data_1b_03ec:
	db $0a,$f8,$c2,$43,$e9,$f9,$c0,$f1,$d2,$80,$02,$f1,$d3,$82,$f9,$d3,$84,$01,$f1,$bc,$f9,$f1,$be,$01,$11,$a4,$f8,$11,$a6,$00,$11,$a8,$08

data_1b_040d:
	db $0b,$00,$c0,$03,$00,$01,$c2,$08,$e2,$80,$02,$f0,$e3,$82,$f8,$e3,$84,$00,$01,$9e,$e8,$01,$a0,$f0,$01,$a2,$f8,$21,$b6,$f3,$21,$b8,$fb,$21,$ba,$03

data_1b_0431:
	db $09,$e0,$ca,$02,$f4,$e1,$cc,$fc,$e1,$ca,$04,$01,$ce,$f4,$01,$d4,$fc,$01,$ce,$04,$21,$d0,$f4,$21,$d2,$fc,$21,$d0,$04

data_1b_044e:
	db $09,$e0,$ca,$02,$f4,$e1,$cc,$fc,$e1,$ca,$04,$01,$ce,$f4,$01,$d6,$fc,$01,$ce,$04,$21,$d0,$f4,$21,$d2,$fc,$21,$d0,$04

data_1b_046b:
	db $09,$e0,$ca,$02,$f4,$e1,$cc,$fc,$e1,$ca,$04,$01,$ce,$f4,$01,$d8,$fc,$01,$ce,$04,$21,$d0,$f4,$21,$d2,$fc,$21,$d0,$04

data_1b_0488:
	db $15,$c0,$80,$02,$e8,$c1,$82,$f0,$c1,$84,$f8,$c1,$86,$00,$c1,$88,$08,$c1,$8a,$10,$e1,$8c,$e8,$e1,$8e,$f0,$e1,$90,$f8,$e1,$92,$00,$e1,$94,$08,$e1,$96,$10,$01,$98,$e8,$01,$9a,$f0,$01,$9c,$f8,$01,$9e,$00,$01,$a0,$08,$01,$a2,$10,$21,$a4,$ee,$21,$a6,$f6,$21,$a8,$fe

data_1b_04c9:
	db $11,$c0,$aa,$02,$f0,$c1,$84,$f8,$c1,$ac,$00,$c1,$ae,$08,$e1,$8c,$e8,$e1,$8e,$f0,$e1,$90,$f8,$e1,$92,$00,$e1,$b0,$08,$01,$98,$e8,$01,$9a,$f0,$01,$9c,$f8,$01,$9e,$00,$01,$b2,$08,$21,$a4,$ee,$21,$a6,$f6,$21,$a8,$fe

data_1b_04fe:
	db $10,$c0,$b4,$02,$f0,$c1,$b6,$f8,$c1,$b8,$00,$e1,$8c,$e8,$e1,$8e,$f0,$e1,$90,$f8,$e1,$92,$00,$e1,$ba,$08,$01,$98,$e8,$01,$9a,$f0,$01,$9c,$f8,$01,$9e,$00,$01,$a0,$08,$21,$a4,$ee,$21,$a6,$f6,$21,$a8,$fe

data_1b_0530:
	db $15,$d0,$80,$02,$e8,$d1,$82,$f0,$d1,$84,$f8,$d1,$86,$00,$d1,$88,$08,$d1,$8a,$10,$f1,$8c,$e8,$f1,$8e,$f0,$f1,$90,$f8,$f1,$92,$00,$f1,$94,$08,$f1,$96,$10,$11,$bc,$e8,$11,$be,$f0,$11,$c0,$f8,$11,$c2,$00,$11,$a0,$08,$11,$a2,$10,$31,$c4,$f0,$31,$c6,$f8,$31,$c8,$00

data_1b_0571:
	db $0d,$c0,$b4,$02,$f0,$c1,$b6,$f8,$c1,$b8,$00,$e1,$8c,$e8,$e1,$8e,$f0,$e1,$90,$f8,$e1,$92,$00,$e1,$b4,$08,$01,$98,$e8,$01,$9a,$f0,$01,$9c,$f8,$01,$9e,$00,$01,$a0,$08

data_1b_059a:
	db $02,$d0,$f0,$01,$fc,$f1,$f2,$fc

data_1b_05a2:
	db $03,$d0,$f4,$01,$fc,$f1,$f6,$f8,$f0,$f6,$41,$00

data_1b_05ae:
	db $03,$d0,$f8,$01,$fc,$f1,$fa,$f8,$f0,$fa,$41,$00

data_1b_05ba:
	db $03,$f0,$f8,$81,$fc,$d1,$fa,$f8,$d0,$fa,$c1,$00

data_1b_05c6:
	db $01,$f0,$fc,$01,$fc

data_1b_05cb:
	db $06,$d0,$c0,$02,$fe,$f1,$c2,$f0,$f1,$c4,$f8,$f1,$c6,$00,$11,$c8,$fb,$11,$ca,$03

data_1b_05df:
	db $05,$d0,$c0,$02,$ff,$f1,$cc,$f8,$f1,$ce,$00,$11,$d0,$f8,$11,$d2,$00

data_1b_05f0:
	db $05,$d2,$c0,$02,$ff,$f1,$d4,$f8,$f1,$d6,$00,$11,$d8,$fc,$11,$da,$04

data_1b_0601:
	db $07,$d0,$de,$02,$f8,$d1,$dc,$00,$e1,$dc,$f0,$f1,$dc,$f8,$f1,$de,$00,$11,$c8,$fb,$11,$ca,$03

data_1b_0618:
	db $06,$f0,$dc,$82,$f8,$f1,$dc,$00,$f1,$de,$08,$01,$de,$f0,$11,$c8,$fb,$11,$ca,$03

data_1b_062c:
	db $04,$10,$de,$02,$f0,$11,$d4,$f8,$11,$d6,$00,$11,$dc,$08

data_1b_063a:
	db $04,$10,$e0,$02,$f0,$11,$e2,$f8,$10,$e2,$41,$00,$11,$e0,$08

data_1b_0649:
	db $02,$f0,$ea,$02,$f8,$f1,$ec,$00

data_1b_0651:
	db $02,$f0,$ee,$02,$f8,$f0,$ec,$82,$00

data_1b_065a:
	db $05,$d0,$b6,$01,$e8,$e0,$ae,$02,$e4,$e1,$b0,$ec,$f1,$b2,$f4,$11,$b4,$f4

data_1b_066c:
	db $08,$d2,$c6,$01,$fd,$e0,$b8,$02,$f0,$e1,$ba,$f8,$e1,$bc,$00,$01,$be,$f4,$01,$c0,$fc,$11,$c2,$f4,$11,$c4,$fc

data_1b_0687:
	db $0a,$ce,$ac,$01,$fc,$d0,$80,$02,$f4,$d1,$82,$fc,$d1,$84,$04,$f1,$86,$f4,$f1,$88,$fc,$f1,$8a,$04,$11,$8c,$f4,$11,$8e,$fc,$11,$90,$04

data_1b_06a8:
	db $0a,$ce,$ac,$01,$fc,$d0,$80,$02,$f4,$d1,$92,$fc,$d1,$84,$04,$f1,$86,$f4,$f1,$94,$fc,$f1,$8a,$04,$11,$8c,$f4,$11,$96,$fc,$11,$98,$04

data_1b_06c9:
	db $0e,$ce,$ac,$01,$fc,$d0,$80,$02,$f4,$d1,$92,$fc,$d1,$9c,$04,$f1,$86,$f4,$f1,$a0,$fc,$f1,$a2,$04,$11,$8c,$f4,$11,$a6,$fc,$11,$a8,$04,$b1,$9a,$04,$d1,$9e,$04,$f1,$a4,$04,$11,$aa,$04

data_1b_06f6:
	db $02,$f0,$c8,$03,$f8,$f1,$ca,$00

data_1b_06fe:
	db $02,$f0,$e0,$03,$f8,$f1,$e2,$00

data_1b_0706:
	db $03,$d0,$e4,$03,$fc,$f1,$e6,$f8,$f0,$e6,$c3,$00

data_1b_0712:
	db $07,$90,$e4,$43,$fc,$b0,$e6,$03,$f8,$d1,$e8,$f8,$11,$ea,$f8,$b0,$e6,$c3,$00,$d1,$e8,$00,$11,$ea,$00

data_1b_072b:
	db $0b,$b0,$e4,$03,$fc,$d1,$e6,$f8,$f1,$e8,$f8,$11,$ea,$f8,$31,$ea,$f8,$51,$ea,$f8,$d0,$e6,$c3,$00,$f1,$e8,$00,$11,$ea,$00,$31,$ea,$00,$51,$ea,$00

data_1b_074f:
	db $0d,$90,$e4,$03,$fc,$b1,$e6,$f8,$d1,$e8,$f8,$f1,$e8,$f8,$11,$ea,$f8,$31,$ea,$f8,$51,$ea,$f8,$b0,$e6,$c3,$00,$d1,$e8,$00,$f1,$e8,$00,$11,$ea,$00,$31,$ea,$00,$51,$ea,$00

data_1b_0779:
	db $01,$f0,$cc,$03,$fc

data_1b_077e:
	db $02,$d0,$ce,$03,$fc,$f1,$d0,$fc

data_1b_0786:
	db $03,$b0,$ce,$03,$fc,$d1,$d0,$fc,$f1,$d2,$fc

data_1b_0791:
	db $04,$90,$ce,$03,$fc,$b1,$d0,$fc,$d1,$d2,$fc,$f1,$d4,$fc

data_1b_079f:
	db $10,$c0,$80,$02,$f8,$c1,$82,$00,$c1,$84,$08,$e1,$8a,$f0,$e1,$8c,$f8,$e1,$8e,$00,$e1,$90,$08,$01,$92,$f0,$01,$94,$f8,$01,$96,$00,$01,$98,$08,$21,$9a,$f5,$21,$9c,$fd,$21,$9e,$fb,$c2,$86,$01,$10,$cd,$88,$18

data_1b_07d2:
	db $10,$c0,$80,$02,$f8,$c1,$82,$00,$c1,$84,$08,$e1,$a0,$f0,$e1,$a2,$f8,$e1,$a4,$00,$e1,$a6,$08,$01,$a8,$f0,$01,$aa,$f8,$01,$ac,$00,$01,$ae,$08,$21,$b0,$f0,$21,$b2,$f8,$21,$b4,$00,$c2,$86,$01,$10,$cd,$88,$18

data_1b_0805:
	db $12,$c0,$80,$02,$f8,$c1,$82,$00,$c1,$84,$08,$fd,$b6,$e8,$e1,$ba,$f0,$e1,$bc,$f8,$e1,$be,$00,$e1,$c0,$08,$1d,$b8,$e8,$01,$c2,$f0,$01,$c4,$f8,$01,$c6,$00,$01,$c8,$08,$21,$ca,$f0,$21,$cc,$f8,$21,$ce,$00,$c2,$86,$01,$10,$cd,$88,$18

data_1b_083e:
	db $10,$c0,$80,$02,$f8,$c1,$82,$00,$c1,$d0,$08,$e1,$d2,$f0,$e1,$d4,$f8,$e1,$d6,$00,$e1,$90,$08,$01,$d8,$f0,$01,$da,$f8,$01,$96,$00,$01,$98,$08,$21,$e0,$f5,$21,$9c,$fd,$21,$9e,$05,$20,$dc,$01,$e5,$21,$de,$ed

data_1b_0871:
	db $11,$c0,$80,$02,$f8,$c1,$82,$00,$c1,$d0,$08,$e1,$e2,$d8,$e1,$e4,$e0,$e9,$e6,$e8,$e1,$e8,$f0,$e1,$ea,$f8,$e1,$d6,$00,$e1,$a6,$08,$01,$ec,$f0,$01,$ee,$f8,$01,$ac,$00,$01,$ae,$08,$21,$b0,$f0,$21,$b2,$f8,$21,$b4,$00

data_1b_08a6:
	db $02,$f0,$f6,$c3,$f8,$f1,$f4,$00

data_1b_08ae:
	db $02,$f0,$f0,$03,$f8,$f1,$f2,$00

data_1b_08b6:
	db $02,$f0,$f4,$03,$f8,$f1,$f6,$00

data_1b_08be:
	db $02,$f0,$f2,$c3,$f8,$f1,$f0,$00

data_1b_08c6:
	db $03,$e0,$80,$02,$f8,$01,$82,$f8,$01,$84,$00

data_1b_08d1:
	db $03,$e0,$a0,$02,$f8,$01,$a2,$f8,$01,$a4,$00

data_1b_08dc:
	db $03,$e0,$c0,$01,$f8,$01,$c2,$f8,$01,$c4,$00

data_1b_08e7:
	db $03,$e0,$86,$02,$f8,$01,$88,$f8,$01,$8a,$00

data_1b_08f2:
	db $03,$e0,$a6,$02,$f8,$01,$a8,$f8,$01,$aa,$00

data_1b_08fd:
	db $03,$e0,$c6,$01,$f8,$01,$c8,$f8,$01,$ca,$00

data_1b_0908:
	db $04,$e0,$8c,$02,$f8,$e1,$90,$00,$01,$8e,$f8,$01,$92,$00

data_1b_0916:
	db $04,$e0,$de,$02,$f8,$e1,$b0,$00,$01,$ae,$f8,$01,$b2,$00

data_1b_0924:
	db $04,$e0,$cc,$01,$f8,$e1,$ce,$00,$01,$8e,$f8,$01,$92,$00

data_1b_0932:
	db $04,$f0,$94,$03,$f0,$f1,$96,$f8,$f0,$96,$43,$00,$f1,$94,$08

data_1b_0941:
	db $04,$f0,$98,$03,$f0,$f1,$9a,$f8,$f0,$9a,$43,$00,$f1,$98,$08

data_1b_0950:
	db $01,$f0,$9c,$03,$fc

data_1b_0955:
	db $02,$d0,$b4,$03,$fc,$f1,$b6,$fc

data_1b_095d:
	db $02,$f0,$b8,$03,$f8,$f1,$ba,$00

data_1b_0965:
	db $02,$f0,$bc,$03,$f4,$f1,$be,$fc,$f1,$d0,$04

data_1b_0970:
	db $02,$f0,$d2,$03,$f4,$f1,$d4,$fc,$f0,$d2,$43,$04

data_1b_097c:
	db $01,$f0,$ec,$01,$00

data_1b_0981:
	db $02,$f0,$ee,$01,$f8,$f1,$f0,$00

data_1b_0989:
	db $02,$f0,$d6,$01,$f8,$f0,$d6,$41,$00

data_1b_0992:
	db $02,$f0,$d8,$01,$f8,$f0,$d8,$41,$00

data_1b_099b:
	db $01,$f0,$f4,$81,$f8

data_1b_09a0:
	db $01,$f0,$f4,$01,$fc

data_1b_09a5:
	db $01,$f0,$f6,$81,$fc

data_1b_09aa:
	db $01,$f0,$f6,$01,$fc

data_1b_09af:
	db $01,$f0,$f8,$81,$f8

data_1b_09b4:
	db $01,$f0,$f8,$01,$f8

data_1b_09b9:
	db $01,$f0,$fa,$81,$f8

data_1b_09be:
	db $01,$f0,$fa,$01,$f8

data_1b_09c3:
	db $01,$f0,$fc,$01,$f8

data_1b_09c8:
	db $01,$f0,$ac,$01,$fc

data_1b_09cd:
	db $01,$f0,$ac,$01,$fc

data_1b_09d2:
	db $01,$f0,$84,$01,$fc

data_1b_09d7:
	db $01,$f0,$8a,$01,$fc

data_1b_09dc:
	db $01,$f0,$90,$01,$fc

data_1b_09e1:
	db $01,$f0,$80,$01,$fc

data_1b_09e6:
	db $01,$f0,$86,$01,$fc

data_1b_09eb:
	db $01,$f0,$8c,$01,$fc

data_1b_09f0:
	db $06,$da,$c8,$43,$01,$f9,$d4,$f1,$fc,$ec,$83,$01,$e8,$d6,$03,$f9,$09,$c8,$f9,$13,$c8,$09

data_1b_0a06:
	db $03,$e0,$e8,$03,$00,$01,$e4,$f8,$01,$e6,$00

data_1b_0a11:
	db $03,$f4,$d4,$03,$00,$fb,$d8,$f8,$fa,$c2,$c3,$00

data_1b_0a1d:
	db $09,$d8,$c6,$c3,$f1,$df,$c6,$f9,$e0,$ce,$43,$01,$df,$c6,$09,$01,$c2,$f9,$ee,$da,$03,$e9,$ff,$c6,$f1,$ff,$c8,$01,$01,$dc,$09

data_1b_0a3c:
	db $03,$ee,$c8,$03,$f6,$ff,$c2,$06,$e2,$c2,$c3,$fe

data_1b_0a48:
	db $0c,$d0,$84,$03,$f8,$d1,$86,$00,$e1,$82,$f0,$f1,$8e,$f8,$f1,$90,$00,$e1,$88,$08,$ef,$8a,$10,$fb,$80,$e8,$01,$8c,$f0,$11,$94,$f8,$11,$96,$00,$01,$92,$08

data_1b_0a6e:
	db $0c,$d0,$a0,$03,$f8,$d1,$a2,$00,$e1,$9a,$f0,$f1,$bc,$f8,$f1,$be,$00,$e1,$a4,$08,$ef,$8a,$10,$fb,$98,$e8,$01,$a6,$f0,$11,$a8,$f8,$11,$96,$00,$01,$92,$08

data_1b_0a94:
	db $02,$de,$e8,$43,$fe,$fe,$ea,$03,$fd

data_1b_0a9d:
	db $04,$e8,$e2,$03,$ef,$f1,$ca,$f7,$f1,$e0,$ff,$09,$ca,$07

data_1b_0aab:
	db $06,$ce,$c6,$c3,$f8,$e0,$c6,$43,$00,$e6,$da,$03,$f0,$f7,$c8,$f8,$03,$c6,$00,$03,$c4,$08

data_1b_0ac1:
	db $06,$00,$c8,$43,$e9,$01,$c2,$f1,$01,$ec,$f9,$f5,$c8,$01,$f3,$c2,$09,$ef,$ec,$11

data_1b_0ad5:
	db $03,$fc,$c2,$43,$f6,$f2,$c4,$03,$fe,$e5,$de,$06

data_1b_0ae1:
	db $09,$d4,$ec,$c3,$e4,$f6,$c4,$43,$fc,$f3,$c8,$04,$e7,$d2,$0c,$cb,$ec,$04,$f2,$c8,$03,$ec,$f7,$c4,$f4,$d7,$d4,$14,$c7,$cc,$0c

data_1b_0b00:
	db $04,$e0,$40,$00,$f8,$e1,$42,$00,$01,$44,$f8,$01,$46,$00

data_1b_0b0e:
	db $04,$e0,$48,$00,$f8,$e1,$4a,$00,$01,$4c,$f8,$01,$4e,$00

data_1b_0b1c:
	db $04,$e0,$50,$00,$f8,$e1,$52,$00,$01,$54,$f8,$01,$56,$00

data_1b_0b2a:
	db $04,$e0,$40,$00,$f4,$e1,$42,$fc,$01,$44,$f8,$01,$46,$00

data_1b_0b38:
	db $04,$e0,$48,$00,$f5,$e1,$4a,$fd,$01,$4c,$f8,$01,$4e,$00

data_1b_0b46:
	db $04,$e0,$50,$00,$f4,$e1,$52,$fc,$01,$54,$f8,$01,$56,$00

data_1b_0b54:
	db $05,$c0,$40,$00,$fc,$e1,$42,$f8,$e1,$44,$00,$01,$46,$f9,$01,$48,$01

data_1b_0b65:
	db $05,$c0,$4a,$00,$fc,$e1,$4c,$f8,$e1,$4e,$00,$01,$50,$f8,$01,$52,$00

data_1b_0b76:
	db $05,$c0,$40,$00,$fc,$e1,$54,$f8,$e1,$56,$00,$01,$58,$f9,$01,$5a,$01

data_1b_0b87:
	db $02,$00,$9c,$02,$00,$01,$9e,$08

data_1b_0b8f:
	db $02,$00,$b8,$02,$00,$01,$ba,$08

data_1b_0b97:
	db $01,$00,$c0,$02,$00

data_1b_0b9c:
	db $02,$00,$b0,$03,$f8,$00,$b0,$43,$00

data_1b_0ba5:
	db $02,$00,$b2,$03,$f8,$00,$b2,$43,$00

data_1b_0bae:
	db $02,$00,$b4,$03,$f8,$00,$b4,$43,$00

data_1b_0bb7:
	db $02,$02,$b6,$03,$f8,$02,$b6,$43,$00

data_1b_0bc0:
	db $02,$f0,$6a,$03,$f8,$f1,$6c,$00

data_1b_0bc8:
	db $01,$f0,$6e,$00,$f8

data_1b_0bcd:
	db $02,$f0,$15,$23,$f8,$f0,$15,$63,$00

data_1b_0bd6:
	db $02,$f0,$17,$23,$f8,$f0,$17,$63,$00

data_1b_0bdf:
	db $02,$f0,$da,$41,$f8,$f1,$d8,$00


bossAssembTable00_1b_0be7:
	dw data_1b_0e99
	dw data_1b_0ea7
	dw data_1b_0ebb
	dw data_1b_0ea7
	dw data_1b_1075
	dw data_1b_107d
	dw data_1b_1085
	dw data_1b_108d
	dw data_1b_1095
	dw data_1b_109d
	dw data_1b_10a5
	dw data_1b_10ad
	dw data_1b_10b5
	dw data_1b_10bd
	dw data_1b_10cb
	dw data_1b_10dc
	dw data_1b_10e4
	dw data_1b_10bd
	dw data_1b_10f5
	dw data_1b_1103
	dw data_1b_1117
	dw data_1b_1125
	dw data_1b_1139
	dw data_1b_1125
	dw data_1b_1117
	dw data_1b_1103
	dw data_1b_10f5
	dw data_1b_1147
	dw data_1b_114c
	dw data_1b_1151
	dw data_1b_1156
	dw data_1b_115b
	dw data_1b_1160
	dw data_1b_1165
	dw data_1b_116a
	dw data_1b_116f
	dw data_1b_1174
	dw data_1b_1179
	dw data_1b_117e
	dw data_1b_1186
	dw data_1b_118e
	dw data_1b_1196
	dw data_1b_11b2
	dw data_1b_11e6
	dw data_1b_11ef
	dw data_1b_11f7
	dw data_1b_11ff
	dw data_1b_1204
	dw data_1b_1209
	dw data_1b_1211
	dw data_1b_121a
	dw data_1b_1222
	dw data_1b_122a
	dw data_1b_1233
	dw data_1b_123c
	dw data_1b_1245
	dw data_1b_124d
	dw data_1b_125b
	dw data_1b_1266
	dw data_1b_1274
	dw data_1b_1282
	dw data_1b_1290
	dw data_1b_129e
	dw data_1b_12ac
	dw data_1b_12ba
	dw data_1b_12c8
	dw data_1b_12e9
	dw data_1b_130a
	dw data_1b_1318
	dw data_1b_1329
	dw data_1b_133a
	dw data_1b_134b
	dw data_1b_136f
	dw data_1b_1393
	dw data_1b_13a4
	dw data_1b_13b2
	dw data_1b_13c0
	dw data_1b_13ce
	dw data_1b_13ef
	dw data_1b_1410
	dw data_1b_09f0
	dw data_1b_0a06
	dw data_1b_0a11
	dw data_1b_0a1d
	dw data_1b_0a3c
	dw data_1b_0a48
	dw data_1b_0a6e
	dw data_1b_0a94
	dw data_1b_0a9d
	dw data_1b_0aab
	dw data_1b_0ac1
	dw data_1b_0ad5
	dw data_1b_0ae1
	dw data_1b_0b00
	dw data_1b_0b0e
	dw data_1b_0b1c
	dw data_1b_0b0e
	dw data_1b_0b2a
	dw data_1b_0b38
	dw data_1b_0b46
	dw data_1b_0b38
	dw data_1b_0b54
	dw data_1b_0b65
	dw data_1b_0b76
	dw data_1b_0b65
	dw data_1b_0b87
	dw data_1b_0b87
	dw data_1b_0b87
	dw data_1b_0b8f
	dw data_1b_141e
	dw data_1b_1444
	dw data_1b_1452
	dw data_1b_1460
	dw data_1b_146e
	dw data_1b_1488
	dw data_1b_149f
	dw data_1b_14ad
	dw data_1b_0b97
	dw data_1b_0b9c
	dw data_1b_0ba5
	dw data_1b_0bae
	dw data_1b_0bb7
	dw data_1b_0bc0
	dw data_1b_0bc8
	dw data_1b_0bcd
	dw data_1b_0bd6
	dw data_1b_0bdf
	dw data_1b_11cc

data_1b_0ce7:
	dw data_1b_14b5
	dw data_1b_14b5
	dw data_1b_14c4
	dw data_1b_14d3
	dw data_1b_14e1
	dw data_1b_14fe
	dw data_1b_150c
	dw data_1b_151d
	dw data_1b_152b
	dw data_1b_1534
	dw data_1b_154f
	dw data_1b_1581
	dw data_1b_15c2
	dw data_1b_15f4
	dw data_1b_1605
	dw data_1b_1616
	dw data_1b_162a
	dw data_1b_163e
	dw data_1b_164c
	dw data_1b_165d
	dw data_1b_166e
	dw data_1b_1682
	dw data_1b_1699
	dw data_1b_16b0
	dw data_1b_16c1
	dw data_1b_16d3
	dw data_1b_16eb
	dw data_1b_1700
	dw data_1b_16eb
	dw data_1b_16d3
	dw data_1b_16eb
	dw data_1b_1715
	dw data_1b_1736
	dw data_1b_175d
	dw data_1b_0dc5
	dw data_1b_0dca
	dw data_1b_0dd2
	dw data_1b_0ddd
	dw data_1b_0deb
	dw data_1b_0dfc
	dw data_1b_0e0d
	dw data_1b_0e15
	dw data_1b_0e1d
	dw data_1b_0e25
	dw data_1b_0e1d
	dw data_1b_0e3a
	dw data_1b_0e42
	dw data_1b_0e4a
	dw data_1b_0e58
	dw data_1b_0e66
	dw data_1b_0e77
	dw data_1b_0e88
	dw data_1b_0e2d
	dw data_1b_0e32


data_1b_0d53:
	dw data_1b_0e99
	dw data_1b_0ef8
	dw data_1b_0efd
	dw data_1b_0e99
	dw data_1b_0e99
	dw data_1b_0f1d
	dw data_1b_0f2e
	dw data_1b_0f51
	dw data_1b_0f56
	dw data_1b_0f5f
	dw data_1b_0f64
	dw data_1b_0f69
	dw data_1b_0f7f
	dw data_1b_0fa0
	dw data_1b_0fa5
	dw data_1b_0fad
	dw data_1b_0fb5
	dw data_1b_0fbd
	dw data_1b_0fc5
	dw data_1b_0fcd
	dw data_1b_0fd5
	dw data_1b_0fdd
	dw data_1b_0fe5
	dw data_1b_0fed
	dw data_1b_0ff5
	dw data_1b_0ffd
	dw data_1b_1005
	dw data_1b_0ed8
	dw data_1b_0ee0
	dw data_1b_0ee8
	dw data_1b_0ef0
	dw data_1a_13cb
	dw data_1a_13d0
	dw data_1a_13d5
	dw data_1a_13d0
	dw data_1b_1058
	dw data_1b_0f84
	dw data_1b_0f95
	dw data_1b_0f3f
	dw data_1b_0f48
	dw data_1b_0f77
	dw data_1b_105d
	dw data_1b_1065
	dw data_1b_106d
	dw data_1b_1018
	dw data_1b_1020
	dw data_1b_1038
	dw data_1b_1041
	dw data_1b_0f02
	dw data_1b_0f0b
	dw data_1b_0f14
	dw data_1b_0f0b
	dw data_1b_1028
	dw data_1b_1030
	dw data_1b_0e99
	dw data_1b_104a
	dw data_1b_100d

data_1b_0dc5:
	db $01,$f0,$b0,$02,$f0

data_1b_0dca:
	db $02,$f0,$b0,$82,$e8,$f1,$fc,$f0

data_1b_0dd2:
	db $03,$f0,$b0,$02,$e0,$f1,$fa,$e8,$f1,$fc,$f0

data_1b_0ddd:
	db $04,$f0,$b0,$82,$d8,$f1,$b4,$e0,$f1,$fa,$e8,$f1,$fc,$f0

data_1b_0deb:
	db $05,$f0,$b0,$02,$d0,$f1,$b2,$d8,$f1,$b4,$e0,$f1,$fa,$e8,$f1,$fc,$f0

data_1b_0dfc:
	db $05,$f0,$b0,$82,$d0,$f1,$b2,$d8,$f1,$b4,$e0,$f1,$fa,$e8,$f1,$fc,$f0

data_1b_0e0d:
	db $02,$f0,$b0,$02,$f0,$f1,$fc,$f8

data_1b_0e15:
	db $02,$e8,$41,$03,$f8,$e9,$43,$00

data_1b_0e1d:
	db $02,$f0,$45,$03,$f8,$f1,$47,$00

data_1b_0e25:
	db $02,$f8,$49,$03,$f8,$f9,$4b,$00

data_1b_0e2d:
	db $01,$f0,$da,$03,$fc

data_1b_0e32:
	db $02,$f0,$dc,$03,$f8,$f1,$de,$00

data_1b_0e3a:
	db $02,$f0,$77,$01,$f8,$f1,$79,$00

data_1b_0e42:
	db $02,$f0,$7b,$01,$f8,$f1,$7d,$00

data_1b_0e4a:
	db $04,$e0,$41,$02,$f4,$e1,$43,$fc,$01,$45,$f8,$01,$47,$00

data_1b_0e58:
	db $04,$e2,$55,$02,$f5,$e3,$57,$fd,$01,$49,$f8,$01,$4b,$00

data_1b_0e66:
	db $05,$ee,$71,$01,$f4,$e3,$61,$fc,$e3,$63,$04,$01,$65,$fc,$01,$67,$04

data_1b_0e77:
	db $05,$f0,$71,$01,$f4,$e3,$61,$fc,$e3,$63,$04,$01,$69,$fc,$01,$6b,$04

data_1b_0e88:
	db $05,$ec,$71,$01,$f4,$e1,$61,$fc,$e1,$63,$04,$01,$6d,$fc,$01,$6f,$04

data_1b_0e99:
	db $04,$f0,$4d,$00,$f0,$f1,$5d,$f8,$f1,$6d,$00,$f1,$7d,$08

data_1b_0ea7:
	db $06,$c0,$05,$03,$f0,$c1,$0f,$f8,$e1,$07,$f0,$e1,$09,$f8,$01,$07,$f0,$01,$09,$f8

data_1b_0ebb:
	db $09,$c0,$0b,$03,$e8,$c1,$0d,$f0,$c1,$0d,$f8,$e1,$09,$e8,$e1,$09,$f0,$e1,$09,$f8,$01,$09,$e8,$01,$09,$f0,$01,$09,$f8

data_1b_0ed8:
	db $02,$f0,$ea,$01,$f8,$f1,$ec,$00

data_1b_0ee0:
	db $02,$f0,$ec,$41,$f8,$f1,$ea,$00

data_1b_0ee8:
	db $02,$f0,$ec,$c1,$f8,$f1,$ea,$00

data_1b_0ef0:
	db $02,$f0,$ea,$81,$f8,$f1,$ec,$00

data_1b_0ef8:
	db $01,$f0,$f1,$03,$fc

data_1b_0efd:
	db $01,$f0,$f3,$03,$fc

data_1b_0f02:
	db $02,$f0,$2b,$01,$f8,$f0,$2b,$41,$00

data_1b_0f0b:
	db $02,$f0,$1d,$01,$f8,$f0,$1d,$41,$00

data_1b_0f14:
	db $02,$f0,$1f,$01,$f8,$f0,$1f,$41,$00

data_1b_0f1d:
	db $04,$e0,$15,$03,$f8,$e0,$15,$43,$00,$00,$19,$01,$f8,$00,$19,$41,$00

data_1b_0f2e:
	db $04,$e0,$17,$03,$f8,$e0,$17,$43,$00,$00,$19,$01,$f8,$00,$19,$41,$00

data_1b_0f3f:
	db $02,$00,$15,$03,$f8,$00,$15,$43,$00

data_1b_0f48:
	db $02,$00,$17,$03,$f8,$00,$17,$43,$00

data_1b_0f51:
	db $01,$f0,$25,$03,$fc

data_1b_0f56:
	db $02,$f0,$03,$03,$f8,$f0,$03,$43,$00

data_1b_0f5f:
	db $01,$f0,$e1,$03,$fc

data_1b_0f64:
	db $01,$f8,$e3,$03,$fc

data_1b_0f69:
	db $04,$f0,$e5,$00,$f0,$f1,$e5,$f8,$f1,$e5,$00,$f1,$e5,$08

data_1b_0f77:
	db $02,$f2,$bf,$40,$f8,$f3,$bd,$00

data_1b_0f7f:
	db $01,$f0,$e7,$01,$fc

data_1b_0f84:
	db $05,$e4,$e7,$01,$f8,$e5,$e7,$00,$f5,$e7,$f8,$f5,$e7,$fd,$f5,$e7,$00

data_1b_0f95:
	db $03,$f8,$e7,$01,$f8,$f9,$e7,$fd,$f9,$e7,$00

data_1b_0fa0:
	db $01,$f0,$e9,$01,$fc

data_1b_0fa5:
	db $02,$f0,$d1,$03,$f8,$f1,$d3,$00

data_1b_0fad:
	db $02,$f0,$d5,$00,$f8,$f1,$d7,$00

data_1b_0fb5:
	db $02,$f0,$d9,$01,$f8,$f1,$db,$00

data_1b_0fbd:
	db $02,$f0,$f9,$03,$f8,$f1,$fb,$00

data_1b_0fc5:
	db $02,$f0,$cd,$01,$f8,$f1,$cf,$00

data_1b_0fcd:
	db $02,$f0,$c1,$01,$f8,$f1,$c9,$00

data_1b_0fd5:
	db $02,$f0,$c3,$01,$f8,$f1,$c9,$00

data_1b_0fdd:
	db $02,$f0,$c5,$01,$f8,$f1,$c9,$00

data_1b_0fe5:
	db $02,$f0,$c7,$01,$f8,$f1,$c9,$00

data_1b_0fed:
	db $02,$f0,$c1,$01,$f8,$f1,$cb,$00

data_1b_0ff5:
	db $02,$f0,$c3,$01,$f8,$f1,$cb,$00

data_1b_0ffd:
	db $02,$f0,$c5,$01,$f8,$f1,$cb,$00

data_1b_1005:
	db $02,$f0,$c7,$01,$f8,$f1,$cb,$00

data_1b_100d:
	db $03,$f0,$c1,$01,$f4,$f1,$cb,$fc,$f1,$c9,$04

data_1b_1018:
	db $02,$f0,$70,$03,$f8,$f1,$72,$00

data_1b_1020:
	db $02,$f0,$74,$01,$f8,$f1,$76,$00

data_1b_1028:
	db $02,$f0,$11,$01,$f8,$f1,$13,$00

data_1b_1030:
	db $02,$f0,$21,$01,$f8,$f1,$23,$00

data_1b_1038:
	db $02,$f0,$f5,$03,$f8,$f0,$f5,$43,$00

data_1b_1041:
	db $02,$f0,$f7,$03,$f8,$f0,$f7,$43,$00

data_1b_104a:
	db $04,$f0,$bd,$00,$f0,$f1,$bf,$f8,$f1,$bd,$00,$f1,$bf,$08

data_1b_1058:
	db $01,$00,$e7,$00,$fc

data_1b_105d:
	db $02,$f0,$7c,$01,$f8,$f1,$7e,$00

data_1b_1065:
	db $02,$f0,$7c,$03,$f8,$f1,$7e,$00

data_1b_106d:
	db $02,$f0,$7c,$00,$f8,$f1,$7e,$00

data_1b_1075:
	db $02,$f0,$98,$01,$f8,$f1,$9a,$00

data_1b_107d:
	db $02,$f0,$98,$01,$f8,$f3,$9a,$00

data_1b_1085:
	db $02,$f0,$9c,$01,$f8,$f1,$9e,$00

data_1b_108d:
	db $02,$f0,$a0,$01,$f8,$f1,$a2,$00

data_1b_1095:
	db $02,$f0,$a4,$01,$f8,$f1,$a6,$00

data_1b_109d:
	db $02,$f2,$9a,$41,$f8,$f1,$98,$00

data_1b_10a5:
	db $02,$f0,$9e,$41,$f8,$f1,$9c,$00

data_1b_10ad:
	db $02,$f0,$a2,$41,$f8,$f1,$a0,$00

data_1b_10b5:
	db $02,$f0,$a6,$41,$f8,$f1,$a4,$00

data_1b_10bd:
	db $04,$f8,$e5,$02,$f0,$f9,$e5,$f8,$f9,$e5,$00,$f9,$e5,$08

data_1b_10cb:
	db $05,$e6,$80,$02,$ee,$e7,$82,$f6,$e7,$84,$fe,$07,$86,$fe,$01,$88,$06

data_1b_10dc:
	db $02,$e0,$8a,$02,$f8,$01,$8a,$f8

data_1b_10e4:
	db $05,$fa,$80,$82,$ee,$fb,$82,$f6,$fb,$84,$fe,$db,$86,$fe,$e1,$88,$06

data_1b_10f5:
	db $04,$f0,$8c,$01,$f0,$f1,$8c,$f8,$f1,$8c,$00,$f1,$8c,$08

data_1b_1103:
	db $06,$e4,$8e,$01,$f0,$e1,$90,$f8,$e1,$84,$00,$01,$92,$f8,$01,$94,$00,$fb,$88,$08

data_1b_1117:
	db $04,$e0,$96,$01,$f8,$e1,$8a,$00,$01,$96,$f8,$01,$8a,$00

data_1b_1125:
	db $06,$fc,$8e,$81,$f0,$e1,$92,$f8,$e1,$94,$00,$01,$90,$f8,$01,$84,$00,$e7,$88,$08

data_1b_1139:
	db $04,$f0,$8c,$81,$f0,$f1,$8c,$f8,$f1,$8c,$00,$f1,$8c,$08

data_1b_1147:
	db $01,$f2,$80,$02,$fc

data_1b_114c:
	db $01,$f2,$82,$02,$fd

data_1b_1151:
	db $01,$f2,$84,$02,$fe

data_1b_1156:
	db $01,$f4,$86,$02,$fe

data_1b_115b:
	db $01,$f6,$88,$02,$fe

data_1b_1160:
	db $01,$ec,$86,$82,$fe

data_1b_1165:
	db $01,$f0,$84,$82,$fe

data_1b_116a:
	db $01,$f0,$82,$82,$fd

data_1b_116f:
	db $01,$f0,$80,$82,$fc

data_1b_1174:
	db $01,$f0,$a8,$02,$fc

data_1b_1179:
	db $01,$f0,$aa,$02,$fc

data_1b_117e:
	db $02,$f0,$ac,$02,$f8,$f1,$ae,$00

data_1b_1186:
	db $02,$f0,$b0,$02,$f8,$f1,$b2,$00

data_1b_118e:
	db $02,$f0,$b4,$02,$f8,$f1,$b6,$00

data_1b_1196:
	db $08,$e0,$bc,$02,$f0,$e1,$be,$f8,$e1,$b8,$00,$e1,$ba,$08,$00,$ba,$c2,$f0,$01,$b8,$f8,$00,$b8,$82,$00,$01,$ba,$08

data_1b_11b2:
	db $08,$e0,$df,$01,$f0,$e1,$df,$f8,$e1,$df,$00,$e1,$df,$08,$01,$27,$f0,$01,$27,$f8,$01,$27,$00,$01,$27,$08

data_1b_11cc:
	db $08,$e0,$df,$01,$f0,$e1,$df,$f8,$e1,$df,$00,$e1,$df,$08,$01,$27,$f0,$01,$27,$f8,$01,$27,$00,$01,$27,$08

data_1b_11e6:
	db $02,$f0,$ca,$01,$f8,$f0,$ca,$41,$00

data_1b_11ef:
	db $02,$f0,$cc,$01,$f8,$f1,$ce,$00

data_1b_11f7:
	db $02,$f0,$ce,$41,$f8,$f1,$cc,$00

data_1b_11ff:
	db $01,$00,$d0,$01,$fc

data_1b_1204:
	db $01,$f0,$d2,$01,$fc

data_1b_1209:
	db $02,$fc,$d4,$01,$f8,$fd,$d6,$00

data_1b_1211:
	db $02,$fc,$ca,$81,$f8,$fc,$ca,$c1,$00

data_1b_121a:
	db $02,$f0,$a3,$02,$f8,$f1,$a5,$00

data_1b_1222:
	db $02,$f0,$a7,$02,$f8,$f1,$a9,$00

data_1b_122a:
	db $02,$f0,$ab,$02,$f8,$f0,$ab,$42,$00

data_1b_1233:
	db $02,$f0,$ad,$02,$f8,$f0,$ad,$42,$00

data_1b_123c:
	db $02,$f0,$af,$02,$f8,$f0,$af,$42,$00

data_1b_1245:
	db $02,$f0,$bd,$00,$f9,$f1,$bf,$01

data_1b_124d:
	db $04,$e0,$40,$00,$f8,$e1,$42,$00,$01,$44,$f8,$01,$46,$00

data_1b_125b:
	db $03,$e0,$48,$00,$f8,$e1,$4a,$00,$01,$4c,$fc

data_1b_1266:
	db $04,$e0,$4e,$00,$f8,$e1,$50,$00,$01,$52,$f8,$01,$54,$00

data_1b_1274:
	db $04,$e0,$78,$00,$f9,$e1,$50,$01,$01,$52,$f8,$01,$54,$00

data_1b_1282:
	db $04,$e0,$7a,$00,$f9,$e1,$50,$01,$01,$52,$f8,$01,$54,$00

data_1b_1290:
	db $04,$e0,$7c,$00,$f9,$e1,$50,$01,$01,$52,$f8,$01,$54,$00

data_1b_129e:
	db $04,$ea,$56,$00,$f4,$eb,$58,$fc,$0b,$5a,$f8,$0b,$5c,$00

data_1b_12ac:
	db $04,$ea,$5e,$00,$f5,$eb,$60,$fd,$0b,$62,$f8,$0b,$64,$00

data_1b_12ba:
	db $04,$ea,$66,$00,$f4,$eb,$68,$fc,$0b,$6a,$f8,$0b,$6c,$00

data_1b_12c8:
	db $0a,$e8,$58,$41,$ee,$e9,$74,$f6,$09,$5c,$ea,$09,$5a,$f2,$e9,$72,$fe,$e0,$e2,$00,$00,$e1,$e4,$08,$e1,$e6,$10,$01,$44,$08,$01,$46,$10

data_1b_12e9:
	db $0a,$e8,$58,$41,$ee,$e9,$74,$f6,$09,$5c,$ea,$09,$5a,$f2,$eb,$9e,$fe,$e0,$e8,$00,$00,$e1,$ea,$08,$e1,$e6,$10,$01,$44,$08,$01,$46,$10

data_1b_130a:
	db $04,$ea,$76,$00,$f5,$eb,$58,$fd,$0b,$5a,$f8,$0b,$5c,$00

data_1b_1318:
	db $05,$d2,$7e,$00,$fb,$f1,$80,$f7,$f1,$82,$ff,$11,$84,$f8,$11,$86,$00

data_1b_1329:
	db $05,$d0,$7e,$00,$fc,$f1,$88,$f8,$f1,$8a,$00,$11,$8c,$f8,$11,$8e,$00

data_1b_133a:
	db $05,$d2,$7e,$00,$fc,$f1,$90,$f7,$f1,$92,$ff,$11,$94,$f8,$11,$96,$00

data_1b_134b:
	db $0b,$d2,$7e,$43,$f5,$f1,$82,$ef,$f1,$f6,$f7,$11,$86,$ed,$11,$84,$f5,$f1,$f4,$ff,$f0,$e2,$00,$00,$f1,$e4,$08,$f1,$e6,$10,$11,$44,$08,$11,$46,$10

data_1b_136f:
	db $0b,$d2,$7e,$43,$f5,$f1,$82,$ef,$f1,$f8,$ff,$11,$86,$ed,$11,$84,$f5,$f1,$fa,$f7,$f0,$e8,$00,$00,$f1,$ea,$08,$f1,$e6,$10,$11,$44,$08,$11,$46,$10

data_1b_1393:
	db $05,$d2,$7e,$00,$fd,$f1,$98,$f8,$f1,$92,$00,$11,$94,$f9,$11,$96,$01

data_1b_13a4:
	db $04,$e0,$a0,$00,$f8,$e1,$a2,$00,$01,$a4,$f8,$01,$a6,$00

data_1b_13b2:
	db $04,$e0,$a8,$00,$f8,$e1,$aa,$00,$01,$ac,$f8,$01,$ae,$00

data_1b_13c0:
	db $04,$e0,$b0,$00,$f8,$e1,$b2,$00,$01,$b4,$f8,$01,$b6,$00

data_1b_13ce:
	db $0a,$e0,$b2,$42,$ee,$e1,$ee,$f6,$01,$b6,$ee,$01,$b4,$f6,$e1,$ec,$fe,$e0,$e2,$00,$00,$e1,$e4,$08,$e1,$e6,$10,$01,$44,$08,$01,$46,$10

data_1b_13ef:
	db $0a,$e0,$b2,$42,$ee,$e1,$f2,$f6,$01,$b6,$ee,$01,$b4,$f6,$f1,$f0,$fe,$e0,$e8,$00,$00,$e1,$ea,$08,$e1,$e6,$10,$01,$44,$08,$01,$46,$10

data_1b_1410:
	db $04,$e0,$b8,$00,$f8,$e3,$b2,$00,$01,$b4,$f8,$01,$b6,$00

data_1b_141e:
	db $0c,$a0,$f2,$01,$f8,$a1,$ca,$00,$c1,$e0,$f0,$c1,$f0,$f8,$e1,$f2,$f8,$e1,$f0,$00,$01,$f2,$f0,$01,$f2,$00,$21,$d6,$e8,$21,$ca,$00,$21,$dc,$08,$41,$d6,$e0

data_1b_1444:
	db $04,$e0,$80,$00,$f8,$e1,$82,$00,$01,$84,$f8,$01,$86,$00

data_1b_1452:
	db $04,$e0,$88,$00,$f8,$e1,$8a,$00,$01,$8c,$f8,$01,$8e,$00

data_1b_1460:
	db $04,$e0,$90,$00,$f8,$e1,$92,$00,$01,$94,$fc,$01,$96,$04

data_1b_146e:
	db $08,$e0,$98,$00,$00,$e1,$9a,$08,$e1,$9c,$10,$e1,$9e,$18,$01,$a0,$00,$01,$a2,$08,$01,$a4,$10,$01,$a6,$18

data_1b_1488:
	db $07,$e0,$98,$00,$00,$e1,$a8,$08,$e1,$aa,$10,$01,$a0,$00,$01,$a2,$08,$01,$ac,$10,$01,$ae,$18

data_1b_149f:
	db $04,$e0,$b0,$00,$00,$e1,$b2,$08,$01,$b4,$00,$01,$b6,$08

data_1b_14ad:
	db $02,$e0,$2d,$03,$00,$e1,$2f,$08

data_1b_14b5:
	db $04,$e0,$8e,$01,$f7,$01,$90,$f1,$e0,$8e,$41,$01,$01,$90,$07

data_1b_14c4:
	db $04,$e0,$90,$41,$f7,$01,$8e,$f1,$e0,$90,$01,$01,$01,$8e,$07

data_1b_14d3:
	db $04,$e0,$80,$01,$f8,$e1,$82,$00,$01,$84,$f8,$01,$86,$00

data_1b_14e1:
	db $08,$de,$8e,$c3,$f1,$de,$8e,$83,$07,$e0,$82,$03,$f8,$e1,$82,$00,$ff,$90,$f1,$01,$84,$f8,$01,$86,$00,$fe,$90,$43,$07

data_1b_14fe:
	db $04,$e0,$80,$02,$f8,$e1,$82,$00,$01,$84,$f8,$01,$86,$00

data_1b_150c:
	db $05,$e0,$80,$02,$f8,$e1,$82,$00,$01,$88,$f4,$01,$8a,$fc,$01,$8c,$04

data_1b_151d:
	db $04,$e0,$f8,$02,$f8,$e1,$fa,$00,$01,$fc,$f8,$01,$ee,$00

data_1b_152b:
	db $02,$f0,$5c,$00,$f8,$f0,$5c,$40,$00

data_1b_1534:
	db $08,$d0,$5e,$00,$f0,$d1,$5e,$f8,$d1,$5e,$00,$d1,$5e,$08,$f1,$5e,$f0,$f1,$5c,$f8,$f1,$5e,$08,$f0,$5c,$40,$00

data_1b_154f:
	db $10,$a0,$ba,$41,$f8,$c1,$bc,$f8,$c1,$9e,$00,$e1,$a0,$00,$e1,$a2,$08,$e1,$a4,$10,$e1,$a6,$18,$01,$a8,$00,$01,$aa,$18,$21,$b6,$f8,$21,$ac,$00,$21,$ae,$10,$21,$b0,$18,$41,$b8,$f8,$41,$b2,$10,$41,$b4,$18

data_1b_1581:
	db $15,$a0,$80,$21,$f8,$a1,$82,$00,$c1,$84,$f0,$c1,$86,$f8,$c1,$88,$00,$c1,$8a,$08,$c1,$8c,$10,$e1,$8e,$e8,$e1,$90,$f0,$e1,$94,$f8,$e1,$9e,$00,$e1,$9e,$08,$e1,$9e,$10,$e1,$96,$18,$01,$98,$e8,$01,$9a,$f0,$01,$9e,$f8,$01,$9e,$00,$01,$9e,$08,$01,$9e,$10,$01,$9c,$18

data_1b_15c2:
	db $10,$e0,$d4,$03,$e0,$e1,$d0,$f0,$e1,$d2,$f8,$e1,$d4,$00,$e1,$d6,$08,$e1,$d6,$10,$e1,$d8,$18,$01,$d0,$e8,$01,$da,$00,$01,$dc,$08,$01,$dc,$10,$01,$de,$18,$21,$da,$f8,$21,$dc,$00,$21,$dc,$08,$21,$de,$10

data_1b_15f4:
	db $05,$c0,$00,$00,$fd,$e1,$02,$f8,$e1,$04,$00,$01,$06,$f8,$01,$08,$00

data_1b_1605:
	db $05,$c0,$00,$00,$fd,$e1,$0a,$f8,$e1,$0c,$00,$01,$0e,$f8,$01,$10,$00

data_1b_1616:
	db $06,$c0,$00,$00,$fd,$e1,$12,$f8,$e1,$14,$00,$01,$18,$f8,$01,$1a,$00,$f9,$16,$f0

data_1b_162a:
	db $06,$c0,$00,$00,$fd,$e1,$1c,$f8,$e1,$1e,$00,$01,$22,$f8,$01,$24,$00,$ff,$20,$f0

data_1b_163e:
	db $04,$e0,$74,$02,$fa,$e1,$76,$02,$01,$7a,$00,$01,$78,$f8

data_1b_164c:
	db $05,$e0,$7c,$02,$f6,$e1,$7e,$fe,$e1,$c0,$06,$01,$7a,$00,$01,$78,$f8

data_1b_165d:
	db $05,$e0,$c2,$02,$f6,$e1,$c4,$fe,$e1,$c6,$06,$01,$7a,$00,$01,$78,$f8

data_1b_166e:
	db $06,$c0,$54,$02,$f8,$c1,$56,$00,$e1,$58,$f8,$e1,$5a,$00,$01,$5c,$f8,$01,$5e,$00

data_1b_1682:
	db $07,$c0,$54,$02,$f8,$c1,$56,$00,$e1,$60,$f8,$e1,$62,$00,$01,$66,$f8,$01,$68,$00,$f1,$64,$f0

data_1b_1699:
	db $07,$c0,$54,$02,$f8,$c1,$56,$00,$e1,$6a,$f8,$e1,$6c,$00,$01,$70,$f8,$01,$72,$00,$f3,$6e,$f0

data_1b_16b0:
	db $05,$c0,$26,$02,$fc,$e1,$28,$f8,$e1,$2a,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_16c1:
	db $05,$c0,$30,$00,$fc,$e0,$32,$02,$f8,$e1,$34,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_16d3:
	db $07,$c0,$30,$00,$fc,$e1,$3e,$f3,$e1,$40,$fb,$e0,$36,$02,$f8,$e1,$38,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_16eb:
	db $06,$c0,$30,$00,$fc,$e1,$42,$f4,$e1,$44,$fc,$e0,$3a,$02,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_1700:
	db $06,$c0,$30,$00,$fc,$e1,$46,$f4,$e1,$48,$fc,$e0,$3c,$02,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_1715:
	db $0a,$c0,$4a,$00,$ef,$e1,$02,$e9,$e1,$4e,$f0,$e1,$50,$f8,$01,$06,$e8,$01,$08,$f0,$c1,$4c,$f8,$e0,$52,$02,$00,$01,$2c,$f8,$01,$2e,$00

data_1b_1736:
	db $0c,$c0,$e0,$00,$f1,$c1,$e2,$f9,$e1,$f0,$e9,$e1,$f2,$f1,$e1,$ec,$f9,$e1,$ee,$01,$01,$06,$eb,$01,$08,$f3,$e0,$e4,$02,$f9,$e1,$e6,$01,$01,$e8,$f8,$01,$ea,$00

data_1b_175d:
	db $02,$f0,$64,$41,$f8,$f1,$62,$00

if PC >= $b750
print "spriteData!!" 
endif 

pad $b765, $ff 		; fill to non sprite data.. 
	



org $be63				; free space 

data_1a_0402:				; !! if Ypos is uneven M+F+P is skippet. $80 is followed by a pointer where to continue the table 
	db $04				    ; number of 8x16 segments		
	db $e0,$00,$00,$f8		; Ypos,ID,Mirr+Flip+Palette,Xpos  
	db $e1,$02,$00         	; Ypos,ID,Xpos 						
	db $01,$04,$f8         	; Ypos,ID,Xpos 
	db $01,$06,$00         	; Ypos,ID,Xpos 

	
data_1a_0a29:				; alucard sprite assembly data 
	db $05
	db $c0,$00,$00,$fc
	db $e1,$02,$f8
	db $e1,$04,$00
	db $01,$06,$f9
	db $01,$08,$01

data_1a_0a3a:
	db $05
	db $c0,$0a,$00,$fc
	db $e1,$0c,$f8
	db $e1,$0e,$00
	db $01,$10,$f8
	db $01,$12,$00	

data_1a_0a4b:			
	db $05
	db $c0,$00,$00,$fc
	db $e1,$14,$f8
	db $e1,$16,$00
	db $01,$18,$f9
	db $01,$1a,$01

data_1a_alucardNew1:		; alucard sprite assembly data NEW
	db $05
	db $c0,$00,$01,$fc
	db $e0,$02,$02,$f8
	db $e0,$04,$03,$00
	db $00,$06,$00,$f9
	db $00,$08,$01,$01
data_1a_alucardNew2:
	db $05
	db $c0,$0a,$02,$fc
	db $e0,$0c,$02,$f8
	db $e0,$0e,$02,$00
	db $00,$10,$02,$f8
	db $00,$12,$02,$00	
data_1a_alucardNew3:
	db $05
	db $c0,$00,$03,$fc
	db $e0,$14,$03,$f8
	db $e0,$16,$03,$00
	db $00,$18,$03,$f9
	db $00,$1a,$03,$01



data_1a_0a5c:
	db $05,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$04,$00,$01,$06,$f9,$01,$1c,$01

data_1a_0a6d:
	db $05,$c0,$00,$00,$fc,$e1,$14,$f8,$e1,$16,$00,$01,$1e,$f9,$01,$1a,$01

data_1a_0a7e:
	db $05,$c0,$00,$00,$fb,$e1,$20,$f4,$e1,$22,$fc,$01,$24,$f8,$01,$26,$00

data_1a_0a8f:
	db $08,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$28,$00,$e1,$2a,$08,$01,$06,$f9,$01,$2c,$00,$01,$2e,$08,$eb,$30,$10

data_1a_0aa9:
	db $07,$c0,$00,$00,$fc,$e1,$02,$f8,$e1,$32,$00,$e1,$34,$08,$01,$06,$f9,$01,$2c,$00,$01,$2e,$08




data_1a_0adc:
	db $04,$f0,$40,$00,$f8,$f1,$42,$00,$11,$44,$f8,$11,$46,$00

data_1a_0aea:
	db $07,$f0,$38,$00,$f8,$f1,$48,$00,$f1,$2a,$08,$11,$3c,$f8,$11,$4a,$00,$11,$2e,$08,$f9,$30,$10

data_1a_0b01:
	db $06,$f0,$38,$00,$f8,$f1,$48,$00,$f1,$34,$08,$11,$3c,$f8,$11,$4a,$00,$11,$36,$08

data_1a_0b15:
	db $04,$e0,$4c,$00,$fb,$e1,$4e,$03,$01,$50,$f8,$01,$52,$00



	
data_1a_03be:
	db $02
	db $00,$e0,$02,$f8
	db $00,$e0,$42,$00

data_1a_03c7:
	db $03,$00,$e2,$02,$f4,$01,$e4,$fc,$01,$e6,$04

data_1a_03d2:
	db $04,$00,$e8,$02,$f0,$01,$ea,$f8,$01,$ec,$00,$01,$ee,$08

data_1a_03e0:
	db $03,$00,$f0,$02,$f4,$01,$f2,$fc,$01,$f4,$04

data_1a_03eb:
	db $04,$e0,$f6,$02,$f5,$e1,$f8,$fd,$01,$fa,$f8,$01,$fc,$00

data_1a_03f9:
	db $02,$f0,$5f,$01,$f8,$f0,$5f,$41,$00




	
; ----------------------------- entityAnimation Data
; --------------------------------------------------
bank $1f
if expandPRG
bank $3f
endif
base $E000
org $EFB4

;entitySpecGroupAnimationData:
	dw data_1f_0fd2
	dw data_1f_0fd2
	dw data_1f_0fd2
	dw data_1f_0fd2
	dw data_1f_10b9
	dw data_1f_1158
	dw data_1f_1002
	dw data_1f_133e	; $f33e
	dw data_1f_1257
	dw data_1f_1131
	dw data_1f_1362	; $f362
	dw data_1f_0fd2
	dw data_1f_0fd2
	dw data_1f_0fd2
	dw data_1f_0fd2

data_1f_0fd2:			; format start, speed, leanth		; playerAll
	db $70, $08, $0c		; trevorWalk_1f_0fd2			; alucard 
	db $18, $08, $04
	db $1e, $08, $04
	db $24, $08, $06
	db $24, $04, $06
	db $2a, $06, $0c
	db $34, $06, $0c
	db $40, boomerangRotateSpeed, $06
	db $46, $06, $08
	db $46, $06, $08
	db $4e, $06, $04
	db $40, $04, $04
	db $56, $04, $0c
	db $36, $08, $04
	db $66, $08, $06
	db $6c, $08, $04 

data_1f_1002:			
	db $02, $0a, $04	
	db $04, $0a, $04	
	db $08, $08, $02	
	db $0a, $08, $02	
	db $0c, $08, $02
	db $0e, $08, $02
	db $10, $08, $02
	db $12, $08, $02
	db $14, $08, $02
	db $16, $08, $02
	db $18, $08, $02
	db $1a, $08, $02
	db $1c, $08, $02
	db $1e, $08, $02
	db $20, $08, $02
	db $22, $08, $02
	db $24, $08, $02
	db $26, $08, $02
	db $28, $08, $02
	db $2a, $08, $02
	db $2c, $08, $02
	db $2e, $08, $02
	db $30, $08, $02
	db $32, $08, $02
	db $24, $08, $02
	db $36, $08, $02
	db $38, $08, $02
	db $3a, $08, $02
	db $3c, $08, $02
	db $3e, $08, $02
	db $40, $08, $02
	db $42, $08, $02
	db $44, $08, $02
	db $46, $08, $02
	db $50, $08, $02
	db $4e, $08, $02
	db $4c, $08, $02
	db $4a, $08, $02
	db $48, $08, $02
	db $52, $08, $02
	db $54, $08, $02
	db $56, $08, $02
	db $58, $08, $02
	db $5a, $08, $02
	db $5c, $08, $02
	db $5e, $08, $02
	db $60, $08, $02
	db $62, $08, $02
	db $64, $08, $02
	db $66, $08, $02
	db $68, $08, $02
	db $6a, $08, $02
	db $6c, $08, $02
	db $6e, $08, $02
	db $ba, $08, $08
	db $c2, $08, $08
	db $ca, $08, $08
	db $e0, $09, $08
	db $ec, $07, $04
	db $f0, $09, $04
	db $fe, $08, $02


data_1f_10b9:			; boss??
	db $02, $10, $04
	db $0a, $08, $08
	db $1a, $0a, $04
	db $20, $0a, $08
	db $28, $0a, $04
	db $92, $10, $04
	db $a8, $0a, $04
	db $de, $18, $04
	db $8c, $0c, $04
	db $4c, $0a, $04
	db $62, $0a, $04
	db $34, $10, $04
	db $bc, $0c, $04
	db $2c, $0e, $04
	db $30, $0e, $04
	db $42, $10, $04
	db $58, $0a, $04
	db $62, $0a, $04
	db $68, $0c, $08
	db $88, $0c, $04
	db $74, $0c, $0a
	db $ac, $0a, $06
	db $a2, $0c, $06
	db $96, $08, $06
	db $b0, $0c, $04
	db $70, $0a, $04
	db $9c, $0c, $06
	db $b8, $0a, $04
	db $bc, $0c, $04
	db $ca, $18, $04
	db $de, $0c, $08
	db $da, $0c, $04
	db $e6, $18, $04
	db $e6, $0c, $08
	db $9c, $18, $06
	db $14, $08, $06
	db $d0, $0a, $08
	db $14, $08, $04
	db $92, $14, $04
	db $7e, $0a, $04 

data_1f_1131:				; items??
	db $1A, $08, $06 
	db $20, $14, $04 
	db $24, $0C, $04 
	db $28, $10, $06 
	db $2E, $06, $04 
	db $34, $0A, $06 
	db $0C, $08, $04 
	db $56, $04, $04 
	db $72, $0C, $04 
	db $76, $0C, $04 
	db $64, $04, $04 
	db $68, $08, $08 
	db $7A, $0A, $04 

data_1f_1158:
	db $02, $08, $06 		; enemy ??
	db $0A, $04, $02 		
	db $0C, $18, $02 		
	db $0E, $18, $02       ; zombie walk??
	db $10, $08, $02       ; zomgie Appear??
	db $12, $08, $06 		; bird??					
	db $18, $10, $08 		; birdsit??
	db $18, $08, $08 		; ghost??
	db $20, $10, $02 
	db $22, $10, $02 
	db $26, $08, $02 
	db $28, $08, $02 
	db $2E, $08, $02 
	db $02, $08, $02 
	db $04, $08, $02 
	db $06, $08, $02 
	db $04, $08, $02 
	db $38, $08, $02 
	db $3A, $08, $04 
	db $3E, $08, $04 
	db $42, $08, $04 
	db $46, $08, $04 
	db $4E, $08, $08 
	db $4C, $08, $02 
	db $4A, $08, $02 
	db $3A, $08, $02 
	db $3C, $08, $02 
	db $56, $08, $04 
	db $5A, $08, $04 
	db $5E, $08, $04 
	db $62, $08, $04 
	db $66, $08, $02 
	db $66, $08, $06 
	db $74, $08, $02 
	db $76, $08, $02 
	db $78, $08, $02 
	db $7A, $08, $04 
	db $7E, $08, $04 
	db $80, $08, $04 
	db $82, $08, $04 
	db $72, $08, $02 
	db $70, $08, $02 
	db $6E, $08, $02 
	db $6C, $08, $02 
	db $6C, $08, $02 
	db $6E, $08, $02 
	db $70, $08, $02 
	db $72, $08, $02 
	db $84, $08, $02 
	db $86, $08, $02 
	db $88, $08, $02 
	db $8A, $08, $0A 
	db $9A, $08, $02 
	db $9C, $08, $02 
	db $9E, $08, $02 
	db $A0, $08, $02 
	db $A2, $08, $02 
	db $A4, $08, $02 
	db $A6, $08, $02 
	db $A8, $08, $02 
	db $AA, $08, $02 
	db $AC, $08, $02 
	db $AE, $08, $02 
	db $B0, $08, $02 
	db $B2, $08, $02 
	db $B4, $08, $02 
	db $B6, $08, $02 
	db $B8, $08, $02 
	db $BA, $08, $02 
	db $BC, $08, $02 
	db $BE, $08, $02 
	db $C0, $08, $02 
	db $C2, $08, $02 
	db $C4, $08, $02 
	db $C6, $08, $02 
	db $C8, $08, $02 
	db $CA, $08, $02 
	db $CC, $08, $02 
	db $CE, $08, $02 
	db $D0, $08, $02 
	db $D2, $08, $02 
	db $D4, $08, $02 
	db $D6, $08, $02 
	db $D8, $08, $02 
	db $DA, $08, $02 

data_1f_1257:
	db $02, $08, $02 
	db $04, $08, $02 
	db $06, $08, $02 
	db $08, $08, $02 
	db $0A, $08, $02 
	db $0C, $08, $02 
	db $0E, $18, $02 
	db $10, $18, $02 
	db $12, $08, $02 
	db $14, $08, $02 
	db $16, $08, $02 
	db $18, $08, $02 
	db $1A, $08, $02 
	db $1C, $08, $02 
	db $1E, $08, $06 
	db $24, $08, $02 
	db $26, $08, $02 
	db $28, $08, $02 
	db $2A, $08, $02 
	db $2C, $08, $06 
	db $32, $08, $02 
	db $34, $08, $02 
	db $36, $08, $02 
	db $38, $08, $02 
	db $3A, $08, $02 
	db $3C, $08, $02 
	db $3E, $08, $02 
	db $40, $08, $04 
	db $42, $08, $02 
	db $44, $08, $02 
	db $46, $08, $02 
	db $48, $08, $02 
	db $2C, $08, $02 
	db $4A, $08, $02 
	db $4C, $08, $02 
	db $4E, $08, $02 
	db $50, $08, $02 
	db $52, $08, $02 
	db $54, $08, $02 
	db $56, $08, $02 
	db $58, $08, $02 
	db $5A, $08, $02 
	db $5C, $08, $02 
	db $62, $08, $02 
	db $64, $08, $02 
	db $66, $08, $02 
	db $70, $08, $02 
	db $68, $08, $02 
	db $68, $08, $08 
	db $68, $08, $02 
	db $70, $08, $02 
	db $6C, $08, $02 
	db $6A, $08, $02 
	db $68, $08, $02 
	db $6C, $08, $02 
	db $70, $08, $02 
	db $68, $08, $02 
	db $72, $08, $06 
	db $78, $08, $02 
	db $7A, $08, $02 
	db $7C, $08, $02 
	db $7E, $08, $02 
	db $7C, $08, $02 
	db $80, $08, $02 
	db $82, $08, $02 
	db $84, $08, $02 
	db $86, $08, $02 
	db $88, $08, $04 
	db $8C, $08, $02 
	db $6C, $08, $02 
	db $AA, $08, $02 
	db $AC, $08, $02 
	db $AE, $08, $06 
	db $B2, $14, $06 
	db $B8, $03, $08 
	db $5E, $08, $02 
	db $60, $08, $02 

data_1f_133e:
	db $02, $08, $04 
	db $60, $08, $08 
	db $0A, $08, $04 
	db $36, $04, $08 
	db $3E, $06, $08 
	db $46, $04, $0A 
	db $48, $08, $02 
	db $4A, $08, $02 
	db $4C, $08, $04 
	db $50, $08, $02 
	db $18, $08, $02 
	db $5C, $04, $04 
data_1f_1362: 	
	db $1C, $0A, $06 
	db $22, $0A, $06 
	db $28, $10, $06 
	db $2E, $08, $08
	db $36, $0A, $08 

