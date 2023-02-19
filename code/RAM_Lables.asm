lvlblock = $32
lvl = $33
stage = $34 





;$e382 initTableGameState
;	dw gameState0_intro
;	dw B31_03b3@done
;	dw gameState2_preNamePwInput
;	dw gameState3_preInGame
;	dw gameState4_inGame
;	dw gameState5_died
;	dw gameState6_gameOver
;	dw gameState7_debugMode
;	dw gameState8_betweenLevels
;	dw gameState9_introCutscene
;	dw gameStateA_namePwInput
;	dw gameStateB_showPassword
;	dw gameStateC_endingCutscene
;	dw gameStateD_credits
;	dw gameStateE_afterPwEnter
;	dw gameStateF_soundMode

;bank $1e				; free Space
;base $c000
;org $dc20
	
;bank $09
;base $a000
;org  $bdf0				; free Space