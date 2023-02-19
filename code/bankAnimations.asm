
bank $02
base $8000
org $9fbd
	dw CHRanim0,CHRanim0,CHRanim2,CHRanim3,CHRanim4,CHRanim5,CHRanim6 	; this animations can be set in the effect table. 
																		; Value $3x are with sound and $4x is without.
																		; X does index this pointer table. So $32 will use CHRanim2..
	
bank $03
org $bd68
	CHRanim0:
		db $0A,$54,$55,$56,$FF  	; first byte is the speed (how many frames to wait till going to the next bank. FF resets program)
	CHRanim1:
        db $0A,$80,$81,$82,$83,$FF
    CHRanim2:
        db $0A,$84,$85,$86,$87,$FF
    CHRanim3:
        db $0A,$88,$89,$8a,$8b,$FF
    CHRanim4:
        db $0A,$8c,$8d,$8e,$8f,$FF
    CHRanim5:
        db $0A,$90,$91,$92,$93,$FF
    CHRanim6:
        db $0A,$94,$95,$96,$97,$FF 