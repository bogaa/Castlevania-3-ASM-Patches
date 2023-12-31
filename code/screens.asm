bank $01
base $a000
org $a60d				; $260d
		ldx #$0c        ; bank to use for map nametable data

bank $1f
base $c000
org $ec77				; $3ec77
		dw $EC9D  
		dw $B570  
		dw $EC9D  
		dw $EC9D  
		dw $EC9D  
		dw $EC9D  
		dw $ABA8  		; map 
		dw $BA68 
		dw $B9FA  
		dw $BA5C  
		dw $BBBC  
		dw $BAD4  		; prayer screen
		dw $B9A6  
		dw $B327  
		dw $B839  
		dw $AD7C 
		dw $BDFA  
		dw $D772  
		dw $BA9A 

bank $11	
base $a000
org $BAD4 				; $13ad4
		dw $2000 		; ppu dest
		db $40			; controll byte how many tiles of the next byte
		db $00 			; tile 
		
		db $06			; controll byte how many tiles of the next byte
		db $3d 			; tile 
		
		db $81			; 80 is follows by the number of tile in the following array
		db $54			; array of 1 lol