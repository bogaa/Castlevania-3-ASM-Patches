	CURR_LOWER_BANK = $8000
										;	org $e382 initTableGameState
	GS_INTRO = $00						;	dw gameState0_intro													
	GS_STUB = $01                       ;	dw B31_03b3@done
	GS_PRE_NAME_PW_INPUT = $02          ;	dw gameState2_preNamePwInput
	GS_PRE_IN_GAME = $03                ;	dw gameState3_preInGame
	GS_IN_GAME = $04                    ;	dw gameState4_inGame
	GS_DIED = $05                       ;	dw gameState5_died
	GS_GAME_OVER = $06                  ;	dw gameState6_gameOver
	GS_DEBUG_MODE = $07                 ;	dw gameState7_debugMode
	GS_BETWEEN_LEVELS = $08             ;	dw gameState8_betweenLevels
	GS_INTRO_CUTSCENE = $09             ;	dw gameState9_introCutscene
	GS_NAME_PW_INPUT = $0a              ;	dw gameStateA_namePwInput
	GS_SHOW_PASSWORD = $0b              ;	dw gameStateB_showPassword
	GS_ENDING_CUTSCENE = $0c            ;	dw gameStateC_endingCutscene
	GS_CREDITS = $0d                    ;	dw gameStateD_credits
	GS_AFTER_PW_ENTER = $0e             ;	dw gameStateE_afterPwEnter
	GS_SOUND_MODE = $0f                 ;	dw gameStateF_soundMode
	
	NUM_ENTITIES = $1c					; 	enemies or events table size 
	NUM_SPAWNERS = 6
	
	SL_TITLE_SCREEN_OPENING_TEXT = $00	; 	static layouts
	SL_INTERNAL_PALETTE_DUMMY_WRITE = $04
	SL_TITLE_SCREEN_INTERNAL_PALETTES = $05
	SL_BASE_ROOM_INTERNAL_PALETTES = $09
	SL_TREVOR_INTERNAL_PALETTES = $0a
	SL_SYPHA_INTERNAL_PALETTES = $0b
	SL_GRANT_INTERNAL_PALETTES = $0c
	SL_ALUCARD_INTERNAL_PALETTES = $0d
	SL_TITLE_SCREEN_PASSWORD_TEXT = $26
		
	RG_SUNKEN_CITY = $08	; room groups
	RG_MAIN_HALL = $0c
	RG_CASTLE_KEEP = $0e
	
	ES_INVISIBLE = $80		; entity state
	ES_MOVING = $40
	ES_UNANIMATED = $20
	ES_ILLUSION = $10
	ES_FROZEN = $02
	ES_DESTROYED = $01 		; wrong?
		
	COLL_EMPTY = 0			; collision
	COLL_MUD = 1
	COLL_CEILING_SPIKE = 5
	COLL_SOLID = 6
	COLL_FLOOR_SPIKE = 7
		
	LL_TITLE_SCREEN = $02 	; large layouts

	CB_TREVOR_1 = $00
	CB_TREVOR_2 = $01
	CB_GRANT_1 = $02
	CB_GRANT_2 = $03
	CB_SYPHA_1 = $04
	CB_SYPHA_2 = $05
	CB_ALUCARD_1 = $06
	CB_ALUCARD_2 = $07
	CB_ZOMBIE_CROW_GHOST_SPRITE = $08
	CB_BAT_SWORDKNIGHT_AXEKNIGHT = $09
	CB_SPINNING_PLATFORM_PENDULUM = $12
	CB_GRANT_BOSS_FIGHT_1 = $1a
	CB_GRANT_BOSS_FIGHT_2 = $1b
	CB_GATE_TORCHES_WHIPUPGRADE_HEARTS_BRICKWALLS = $40
	CB_ASCII_ROUND_RECTANGLE = $41
	CB_STATUS_BAR_CHAR_FACES = $42
	CB_SCORE_ITEMS_PROJECTILES_CANDLES = $43
	CB_45 = $45 ; used for 1st room tiles
	CB_47 = $47 ; used for 1st room tiles
	CB_TITLE_SCREEN_1 = $70
	CB_TITLE_SCREEN_2 = $71
	CB_TITLE_SCREEN_3 = $72
	CB_EMPTY = $7f


	enum $00
		wReturnAddr: ; dw 0
		wPointerBase: ; dw 0
		wReturnAddr: ; dw 0
		wPointerBase: ; dw 0
		wTempJoy1ButtonsPressedPass1: ; db 0
		wCurrEntityPhaseFuncAddr: ; dw 0
		wIdxIntoRoomTransitionBytes: ; db 0
		wCurrDrawnEntityPaletteOverride: ; db 0
		wCurrRoomBGInternalPalettesSpecOffset: ; db 0
		wCurrStaticLayoutAddr: ; dw 0
		wCoreLoadingFuncIdx: ; db 0
		wCurrLargeLayoutAddr: ; dw 0
		wTempSpawnerXCoord: ; db 0
		w000: ; db 0
	endenum

	enum $01
		wTempJoy2ButtonsPressedPass1: ; db 0
		wCurrDrawnEntityBaseY: ; db 0
 		wTempSpawnerYCoord: ; db 0
		wLivesLeftLowNybble: ; db 0
	endenum

	enum $02
		wJumpAddr: ; dw 0
		w002: ; db
		wTempJoy1ButtonsPressedPass2: ; db
		wPhaseFuncDataAddr: ; dw
		wCurrEntityScriptAddr: ; dw
		wCurrDrawnEntityBaseX: ; db      
		wCurrStaticLayoutTileMask: ; db
		wCurrLargeLayoutCountByte: ; db
		wLivesLeftHighNybble: ; db
		wCurrMetatileTilesAddr: ; dw
		wTempSpawnerAI_Idx: ; db
	endenum 

	enum $0003
		wTempY: ; db
		wTempJoy2ButtonsPressedPass2: ; db
		wCurrDrawnEntityNumSprites: ; db
		wTempSpawnerObjectIdx: ; db
	endenum 
	
	enum $0004
		wJoy1IsButtonPressed: ; $db
		wCurrSectionEntityDataAddr: ; dw
		wCurrOamOffsetToFill: ; db
	endenum 
	
	enum $0005
		wJoy2IsButtonPressed: ; db
		wCurrDrawnEntityIdx: ; db
	endenum 	

	enum $0006
		wCurrRoomGroupEntityDataAddr: ; dw
		wCurrDrawnEntityIdx_stateC: ; db
	endenum 

	enum $0007
		wNumOamSpotsLeftThisFrame: ; db
		wCurrRoomUses2ndBGInternalPalettesSpecsGroup: ; db
	endenum 

	enum $0008
		wCurrRoomGroupMetatilesAddress: ; dw
		wCurrRoomGroupChrBanks: ; dw
		wCurrRoomGroupMetadataAddr: ; dw
		wSoundModeTextAddr: ; dw
		wCurrEntitySpecGroupAnimationDataAddr: ; dw
		wCurrEntityOamSpecGroupAddr: ; dw
		wRoomGroupInternalPalettesAddr: ; dw
		wCurrRoomGroupStairsDataAddr: ; dw
		wMenuCursorXorYoffsetsAddr: ; dw
		wCurrNumToVramQueue: ; db
		wCurrRoomGroupRespawnTimeLeftAddr: ; dw
		wCurrRoomGroupPlayerPosAndScreenAddr: ; dw
	endenum

	enum $000a
		wCurrRoomSectionPlayerPosAndScreenAddr: ; dw 
		wCurrRoomSectionStairsDataAddr: ; dw
		wCurrRoomSectionMetatilesAddress: ; dw    
		wRoomTransitionDataAddr_dx: ; dw
		wCurrRoomSectionMetadataAddr: ; dw  
        wCurrRoomSectionChrBanks1: ; dw   
        wCurrRoomSectionChrBanks2: ; dw
		wCurrEntityOamSpecIdxAddr: ; dw    
		wRoomSectionInternalBGPalettesAddr: ; dw    
		wRoomSectionInternalSprPalettesAddr: ; dw
	endenum

	enum $000c
		wDoubleCurrGroup: ; db
		wNumColoursLeftForCurrPalette: ; db
	endenum

	enum $000d
		wDoubleCurrSection: ; db
		wNumInternalPalettesLeft: ; db
	endenum
	
	enum $000e
		wDoubleCurrRoomIdx: ; db	
	    wRoomSectionSprPalettesAddrOffset: ;  db
	endenum
	
	enum $000f
        wRoomSectionChrBanksDataOffset: ; db
		wCurrEntitySpecGroupDoubled: ; db
	endenum
	
	enum $0010
		wCurrDrawnEntityCachedAttr: ; db
		wCollisionPointXinScreen: ; db
	endenum

	enum $0011
		wCollisionPointYinScreen: ; db  
		wCollisionPointYinScreenDiv16: ; db
	endenum

	enum $0012
		wCollisionPointXvalDiv32: ; db   
	endenum

	enum $0013
        wCollisionPointAbsoluteXInRoom: ; db  
        wCollisionPointIsInVertRoomStatusBarRegion: ; db		
	endenum

	enum $0014
		wCollisionPointAbsoluteXRoom: 		.dsb 1	; $14 db
		w015:								.dsb 1  ; $15 db 
		wCoreLoadingFuncAddr: 				.dsb 2	; $16 dw 
		wGameState: 						.dsb 1	; $18 db
		wGameSubstate:						.dsb 1	; $19 db
		wGameStateLoopCounter: 				.dsb 1	; $1a db
		wIsExecutingNMIVector: 				.dsb 1	; $1b db
		wCounterUntilCanShowSprBg: 			.dsb 1	; $1c db
		wVramQueueNextIdxToFill: 			.dsb 2	; $1d db
		wRandomVal: 						.dsb 1	; $1f db
		wCurrFrameStartingOamOffset: 		.dsb 1	; $20 db
		wPrgBank_8000: 						.db 1 	; $21 db
		wPrgBankBkup_8000: 					.db 1	; $22 db
		wPrgBankBkup2_8000: 				.db 1	; $23 db
		wIsExecutingSoundFunc: 				.dsb 1	; $24 db
		wNametableMapping: 					.dsb 1	; $25 db
		wJoy1NewButtonsPressed: 			.dsb 1	; $26 db
		wJoy2NewButtonsPressed: 			.dsb 1 	; $27 db
		wJoy1ButtonsPressed: 				.dsb 1	; $28 db
		wJoy2ButtonsPressed: 				.dsb 1	; $29 db
		wInGameSubstate: 					.dsb 1	; $2a db	; todo: could be multi-purpose, could be wrong
		wIsPaused: 							.dsb 1	; $2b db
		wCinematicsController: 				.dsb 1	; $2c db
		w02d:    							.dsb 3	; dsb $30-$2d
		wGenericStateTimer:					.dsb 2	; $30 dw
		wCurrRoomGroup: 					.dsb 1	; $32 db	lvlblock = $32 
		wCurrRoomSection: 					.dsb 1	; $33 db	lvl = $33			
		wCurrRoomIdx: 						.dsb 1	; $34 db	stage = $34			
		wCurrLivesLeft: 					.dsb 1	; $35 db ; bcd				
		wCurrScore: 						.dsb 3	; $36 dsb 3
		wUsableChars: 						.dsb 2	; $39 dsb 2
		wCurrCharacterIdx: 					.dsb 1	; $3b db
		wPlayerHealth:						.dsb 1	; $3c db	; health goes up to 40h, single life bars are 4 health each
		wBossHealth: 						.dsb 1	; $3d db
		w03e: 								.dsb 1	; $3e db
		wBaseIRQFuncIdx: 					.dsb 1	; $3f db
		wBaseIRQStatus: 					.dsb 1	; $40 db
		wBaseIRQCmpVal: 					.dsb 1	; $41 db
		w042: 								.dsb 1	; $42 db
		wBaseIRQScanlineCmpVal: 			.dsb 1	; $43 db
		wIRQFuncAddr: 						.dsb 2	; $44 dw					
		wChrBankSpr_0000: 					.dsb 1	; $46 db	; wChrBanks:   	
		wChrBankSpr_0400: 					.dsb 1 	; $47 db
		wChrBankSpr_0800: 					.dsb 1 	; $48 db
		wChrBankSpr_0c00: 					.dsb 1 	; $49 db
		wChrBankBG_0000: 					.dsb 1	; $4a db
		wChrBankBG_0400: 					.dsb 1	; $4b db
		wChrBankBG_0800: 					.dsb 1	; $4c db
		wChrBankBG_0c00: 					.dsb 1	; $4d db
		wChrBankSpr_1400: 					.dsb 1 	; $4e db
		w04f:								.dsb 1	; $4f db
		wRoomMetaTilesAddr: 				.dsb 2	; $50 dw
		w052:								.dsb 4	; $52    dsb 4
		wCurrScrollOffsetIntoRoomScreen: 	.dsb 1	; $56 db
		wCurrScrollRoomScreen: 				.dsb 1	; $57 db
		w058:								.dsb 5	; $58 dsb $d-8
		wCurrRoomGroupMetaTileTiles: 		.dsb 2	; $5d dw
		wCurrRoomGroupMetaTilePalettes: 	.dsb 2	; $5f dw
		wVramQueueDest: 					.dsb 2	; $61 dw
		wCurrMetatile:						.dsb 1	; $63 db
		w064: 								.dsb 4 	; dsb 4
		wCurrRoomMetadataByte: 				.dsb 1	; $68 db	; if bit 7 set, it's a vertical-scrolling room
		wCurrRoomStairsDataAddr: 			.dsb 2	; $69 dw

		wMenuOptionIdxSelected: 			.dsb 1 	; $6b db
		wSoundModeCtrlState: 						; $6b db

		wCurrEntityIdxBeingProcessed: 		.dsb 1 	; $6c db	; 1 to 12 (todo: enemies?)
		wIRQFuncIdx: 						.dsb 1	; $6d db
		w06e:								.dsb 1	; $6e db
		wGameplayScrollXWithinRoom: 		.dsb 1	; $6f db
		wGameplayScrollXRoom: 				.dsb 1	; $70 db
		wCurrRoomNumScreens: 				.dsb 1	; $71 db
		wFrameStartChrBankOverrideIdx:		.dsb 1	; $72 db
		wPrevRoomMetadataByte: 				.dsb 1	; $73 db
		w074:   							.dsb 2	; $74 dsb 2
		wCurrRoomXQuarter: 					.dsb 1	; $76 db
		w077:								.dsb 7	; $77 dsb $e-7
		wCurrTimeLeft: 						.dsb 2	; $7e dw ; bcd
		w080:								.dsb 4	; $80 dsb 4
		wNumHearts:							.dsb 1	; $84 db ; bcd
		wCurrSubweapon: 					.dsb 1	; $85 db ; 03 - dagger
		w086:								.dsb 18 ; $86 dsb $98-$86
		wCurrRoomEntityDataAddr: 			.dsb 2	; $98 dw
		w09a:								.dsb 11	; ds $a5-$9a
		wCollisionValIsForRightHalfOf32x16block: .dsb 1 	; $a5 db
		w0a6:								.dsb 11 		; dsb $b1-$a6 ; b0 - related to stopwatch?
		wStaticLayoutBank: 					.dsb 1			; $b1 db
		w0b2: 								.dsb 30 		; dsb $d0-$b2
		wHighestTileToCheckForCollisionsInVertRoom: .dsb 1 	; $d0 db		
		w0d1:								.dsb 15 		; ds $e0-$d1
		wCurrInstrumentDataAddr: 			.dsb 2	; $e0 dw
		wSoundBankJumpAddr:					 		; $e2 dw 
		wSoundBankTempInstMetadataOffset: 			; $e2 db
		wSoundTempDataBytesOffset:					; $e2 db
		wCurrFrequencyAdjust: 						; $e2 db
		wNextInstrumentDataAddr_lo: 				; $e2 db
		wGenericTempVar:							; $e2 db
		wEnvelopeAddr: 								; $e2 dw
		wFreqAdjustFromEnvelope: 			.dsb 2	; $e2 db
		wSoundBankTempVar1: 				.dsb 1	; $e4 db	
		wSoundBankTempVar2: 				.dsb 1	; $e5 db		
		wTempCurrInstrumentDataAddr: 		.dsb 2	; $e6 dw ; used just to check 1st byte when loading sound		
		wSoundMetadataAddr: 				.dsb 2	; $e8 dw		
		wSoundNumInstrumentsMinus1: 		.dsb 1	; $ea db		
		wSoundDataBank: 					.dsb 1	; $eb db		
		wSoundFrequency: 					.dsb 2	; $ec dw		
		wCurrInstrumentIdx: 				.dsb 1	; $ee db
		wSoundToPlay: 						.dsb 1	; $ef db
		wDMCToPlay: 								; $ef db			
		w0f0:								.dsb 8 	; $f0 dsb 8		
		wJoy1NewButtonsPressed2: 			.dsb 1	; $f8 db		
		wJoy2NewButtonsPressed2:			.dsb 1	; $f9 db	
		wJoy1ButtonsPressed2: 				.dsb 1	; $fa db		
		wJoy2ButtonsPressed2: 				.dsb 1	; $fb db		
		wScrollY:							.dsb 1	; $fc db		
		wScrollX: 							.dsb 1	; $fd db		
		wPPUMask: 							.dsb 1	; $fe db		
		wPPUCtrl: 							.dsb 1	; $ff db
		wInstrumentsFramesUntilNextByteProcessed: .dsb 7 ; $100 dsb 7
		wInstrumentsSoundIdxes: 			.dsb 7	 ; $107 dsb 7
		wInstrumentsSpeedCtrler_todo: 		.dsb 7	; $10e dsb7	; multiplied by time for a note to give actual frames ; until next sound byte processed, ie higher = slower
		wSoundControlByte: 					.dsb 7	; $115 dsb 7	; 115 - set to 1 if not 2nd square channels
													; and 1st instrument metadata byte >= $10
													; when bit 0 set, data bytes are processed in soundEngine
													; otherwise it is processed in soundCommon
													; bit 0 - are codes processed in soundEngine?
													; bit 3 - is looping
		wSoundCtrsForLastLoop: 				.dsb 7	; $11c dsb 7
		wInstrumentData_lo: 				.dsb 7	; $123 dsb 7
		wInstrumentData_hi: 				.dsb 7	; $12a dsb 7
		wLoopToAddr_lo: 					.dsb 7	; $131 dsb 7
		wLoopToAddr_hi: 					.dsb 7	; $138 dsb 7
		w13f:								.dsb 14	; $13f dsb $4d-$3f 
		wInstrumentLastFreq_hi: 			.dsb 7	; $14d dsb 7	 ; todo: unknown size
		w154:								.dsb 19	; $154 dsb $67-$54
		wPauseSoundPlayed: 					.dsb 1	; $167 db
		w168: 								.dsb 1	; $168 db
		w169:								.dsb 5 	; $169 dsb 5
		w16e:    							.dsb 5	; $16e dsb 5 ; control bits? ; when bit 4 set, envelope restarted
		wInstrumentFrequencyAdjust: 		.dsb 5	; $173 dsb 5   
		wInstrumentLastFreq_lo: 			.dsb 5	; $178 dsb 5    
		wOctaveIncreasedBy5minusThis: 		.dsb 6	; $17d dsb 6    
		wInstrumentFrequency_lo: 			.dsb 3	; $183 dsb 3    
		wInstrumentFrequency_hi: 			.dsb 3	; $186 dsb 3    
		wInstrumentEnvelope1Idx: 			.dsb 3	; $189 dsb 3   
		wCurrInstrumentHwRegOffset: 		.dsb 1	; $18c db
		wSoundCounterForGlobalDelayFrames: 	.dsb 1	; $18d db
		wSoundGlobalDelayFrames:			.dsb 1 	; $18e db	; all instruments skipped once everytime this many frames passed
		wSoundShouldSkipDecDelayBytes: 		.dsb 1  ; $18f db	; todo: specifically for noise?? wSoundShouldSkipDecreasingDelayBytes:
		w190:								.dsb 2 	; $190 dsb 2
		wCurrentlyPlayingDMCSoundIdx: 		.dsb 1	; $192 db
		w193:								.dsb 2	; $193 dsb 2
		InstrumentDataBanks: 				.dsb 1	; $195 db ; todo: unknown size
		w196:		    					.dsb 6	; $196dsb $200-$196
		wStackEnd:							.dsb 100; $200 db
		wOam: 								.dsb 256; $300 ; wOamCont: dsb $100-Oam.size
		wVramQueue: 						.dsb 204; $300 dsb $cc ; todo: unknown size
		w3cc:								.dsb 3	; $3cc dsb 3
		w3cf:								.dsb 3 	; $3cf dsb 3	; todo: unknown size ; low nybble from da 3rd param ; num times to multiply $100,x to itself, 
		w3d2:								.dsb 12 ; $3d2 dsb $e-2
		wCurrEnvelopeByteTimeUntilNext: 	.dsb 3	; $3de  dsb 3
		wInstrumentEnvelopeMultiplier: 		.dsb 3	; $3e1 dsb 3
		w3e4:								.dsb 28	; $3e4 dsb $400-$3e4
		
		wOamSpecIdxDoubled: 				.dsb NUM_ENTITIES 	; $400	
		wEntityBaseY:						.dsb NUM_ENTITIES	; $41c 
		wEntityBaseX: 						.dsb NUM_ENTITIES 	; $438
		wEntityPaletteOverride:				.dsb NUM_ENTITIES 	; $454
		wEntityState: 						.dsb NUM_ENTITIES	; $470	; bit 7 - invisible
		wEntityOamSpecGroupDoubled: 		.dsb NUM_ENTITIES	; $48c    
		wEntityFacingLeft:					.dsb NUM_ENTITIES	; $4a8	; 1 is facing left

		wEntityFractionalX:					.dsb 23 ; $4c4 dsb $17
		wEntityFractionalY:					.dsb 23	; $4db dsb $17   
		wEntityHorizSpeed: 					.dsb 23	; $4f2 dsb $17    
		wEntityHorizSubSpeed: 				.dsb 23	; $509 dsb $17   
		wEntityVertSpeed: 					.dsb 23	; $520 dsb $17   
		wEntityVertSubSpeed: 				.dsb 23	; $537 dsb $17   
		wCurrPlayer: 								; $54e db ; trevor, sypha, grant, alucard 
		wEntityObjectIdxes: 				.dsb 23		; $54e dsb $17	; todo: better name?   
		wPlayerStateDoubled: 				.dsb 1	; $565 db
		w566:								.dsb 22	; $566 sb $7c-$66
		wEntityTimeUntilNextAnimation: 		.dsb 1	; $57c db	; todo: unknown size
		w57d:								.dsb 22 ; $57d dsb $93-$7d
		wEntityOamSpecIdxBaseOffset: 		.dsb 1	; $593 db ; todo: unknown size
		w594:								.dsb 22	; $594 dsb $aa-$94
		wEntityAnimationDefIdxInSpecGroup: 	.dsb 23 ; $5aa dsb $17
		wEntityPhase: 						.dsb 23	; $5c1 dsb $17 ; which step in their AI to perform ; todo: trevor fall switch    
		w5d8:    							.dsb 23	; $5d8 dsb $17		
		wEntityAI_idx: 						.dsb 23 ; $5ef dsb $17		
		wEntityAlarmOrStartYforSinusoidalMovement: 	.dsb 23 ; $606    dsb $17
		wPixelsToWalkToStairs: 				.dsb 1	; $61d db		
		w61e:    							.dsb 21 ; $61e dsb $33-$1e		
		wEntityGenericCounter: 				.dsb 23 ; $633 dsb $17		
		w64a:    							.dsb 86 ; $64a dsb $a0-$4a		
		wInstrumentEnvelopeLoopToIdx: 		.dsb 3	; $6a0 dsb 3		
		wInstrumentsCurrEnvelopeInUse: 		.dsb 3	; $6a3 dsb 3
		wInstrumentsEnvelopeIdx: 			.dsb 3	; $6a6 dsb 3
		wInstrumentsCurrEnvelopeLoops: 		.dsb 3	; $6a9 dsb 3
		w6ac:   							.dsb 28	; $6ac dsb $c8-$ac
		wTimeSpecialDMCSoundPlayed: 		.dsb 1	; $6c8 db ; eg ominous laugh, boss scream, flying heads scream
		w6c9:    							.dsb 23	; $6c9 dsb $e0-$c9
		wCurrCollisionValues: 				.dsb 144	; $6e0    dsb $90
		wCurrChrBanksTileCollisionTypeOffsets: dsb 16 	; $770 dsb $10
		wSoundModeSongSelected: 			.dsb 1		; $780 db
		w781:    							.dsb 65 	; dsb $c2-$81
		wSpawnerID: 						.dsb NUM_SPAWNERS 	; $7c2    
		wSpawner_var7c8: 					.dsb NUM_SPAWNERS	; $7c8    
		wSpawner_var7ce:					.dsb NUM_SPAWNERS	; $7ce
		wSpawnerYCoord: 					.dsb NUM_SPAWNERS	; $7d4
		wSpawnerXCoord: 					.dsb NUM_SPAWNERS	; $7da
		wSpawnerOffScreenStatus: 			.dsb NUM_SPAWNERS	; $7e0
		wSpawner_var7e6: 					.dsb NUM_SPAWNERS	; $7e6
		w7ec:   							.dsb 10 ; dsb $f6-$ec
		wHardMode: 							.dsb 1	; $7f6 db
		w7f7:   							.dsb 9	; dsb $800-$7f7
	endenum


;bank $1e				; free Space
;base $c000
;org $dc20
	
;bank $09
;base $a000
;org  $bdf0				; free Space



;Address    Size    Description			to do check for better lables.. 
;--------   ----    -----------
;$0017              Repeat Counter
;$0018              System State
;                            00 = Title; 02 = New Game; 03 = In-game Transition; 04 = In-Game;
;                            05 = Game Over Transition; 06 = Game Over; 07 = Stage Select Debug;
;                            08 = Map Screen; 09 = Prayer Scene; 0a = Name Entry; 0b = Password Entry;
;                            0c = Epilogue; 0d = Credit Roll; 0e = Respawn; 0f = Sound Test Debug
;$0019              System Substate
;$001A              System Step Counter
;$001B              Radio Mode (halts most code except music)
;$001C              Blackout Delay
;$001D              X Register Backup
;$001E              Pausing Disabled (always 00?)
;$001F              Randomizer
;$0020              OAM Batch
;$0021              Current PROM Bank 
;$0022              Previous PROM Bank
;$0023              PROM Bank Backup (used by some functions)
;$0024              Bank Changed (for debugging probably)
;$0025              Nametable Mapping
;$0026       #02    Controller Buttons Pressed
;                            01 = right; 02 = left; 04 = down; 08 = up;
;                            10 = start; 20 = select; 40 = B; 80 = A
;$0028       #02    Controller Buttons Held
;$002A              Game State (set $006B to 00 before changing)
;                            00 = initialize room; 01 = initialize nametables; 02 = load horizontal room;
;                            03 = horizontal gameplay; 04 = load vertical room; 05 = vertical gameplay;
;                            06 = stair transition start; 07 = stair transition fade; 08 = door transition;
;                            09 = initialize fog; 0a = fog parallax; 0b = horizontal partner swap;
;                            0c = vertical partner swap; 0d/0e = <CUT CONTENT>; 0f = detect automatic stairs;
;                            10 = automatic stair transition; 11 = tally score; 12 = <UNUSED>;
;                            13 = flee Aquarius; 14 = initialize flooding; 15 = load flood room;
;                            16 = flood room gameplay; 17 = map transition; 18 = autowalk to door;
;                            19 = powering up; 1a = freeze water; 1b = thaw ice; 1c = Bone King escape;
;                            1d = Aquarius ruptured; 1e = initialize map transition; 1f = map transition exit
;$002B              User Paused (toggled by Start button)
;$002C              Boss Defeated
;$002D              Entry End (valid in Name screen, garbage in Pass screen)
;$002E              Checkpoint
;$002F              Grant Defeated
;$0030       #02    System Effect Timer
;$0032              Stage
;$0033              Block
;$0034              Room
;$0035              Lives   
;$0036       #03    Score  
;$0039              Main Character (change this to not always be Trevor)
;$003A              Partner   
;                            00 = Trevor; 01 = Syfa; 02 = Grant; 03 = Alucard; ff = None
;$003B              Partner Active 
;$003C              Player's Health
;                            40 = full
;$003D              Boss Health 
;$003E              Score Target (for extra life)
;$003F              Default Drawing State (write to $006D)
;$0040              Scanline IRQ
;$0041              Scanline Target
;$0042              Default Vertical Scanline Target (write to $0089)
;$0043              Scanline Next Target
;$0044       #02    Draw State Address
;$0046       #08    CHR Banks
;$004E              Hard Mode CHR Bank (overwrites $0049)
;$0050       #02    Tile Assembly Starting Address
;$0052       #02    Tile Assembly Left Address
;$0054       #02    Tile Assembly Right Address
;$0056       #02    View Position (little endian) 
;$0058              View Subpixel Position
;$0059              Left Spawn Area
;$005A              Right Spawn Area
;$005B              Tile Assembly Count Left
;$005C              Tile Assembly Count Right
;$005D       #02    Tile Assembly Pointer
;$005F       #02    Pallet Map Pointer
;$0061       #02    Nametable Write Address
;$0063              Tile Assembly ID
;$0064              Transition Timer
;$0065              Scroll Direction
;                            00 = left; 01 = right; 02 = unchanged
;$0066              View Refreshed Position
;$0067              Update View
;$0068              Room Orientation
;                            00 = horizontal; 80 or 81 = vertical; 82 = scroll up;
;                            83 = scroll down; 84 = collapse up; 85 = collapse down
;$0069       #02    Stair Map Address
;$006B              Menu selections
;                   Door State
;                            00 = unopened; 01 = load next room; 02 = scroll in next room;
;                            03 = unlatch door; 04 = open door; 05 = walk in; 06 = close door;
;                            07 = latch door; 08 = scroll out old room; 09 = end transition
;$006C              Current Instance (saves X register)
;$006D              Drawing State
;$006E              View Speed
;$006F       #02    PPU Scroll 
;$0071              Room Size
;$0072              CHR Write Mode
;                            00 or 03 = all CHR banks; 01 = status bar banks;  02 = clear NPC banks
;$0073              Previous Room Orientation
;$0074              Music Loaded
;$0075              Transition Nametable (nametable to use after door closes)
;$0076              Horizontal Spawner Block
;$0077              First Spawner Block
;$0078              Boss Scroll Lock
;$0079              Vertical Spawner Block
;$007A              Vertical Spawner Previous (?)
;$007B              Spawner Count
;$007C              Vertical Partner Y-Coordinate (used for partner swap in vertical rooms)
;$007D              Room Type
;                            10 = Stormclouds; 20 = Autowalk; 30 = River; 40 = Clockwork;
;                            50 and 60 = Watery Grave; 70 = Flood Zone; 80 = Collapsing Bridge
;                            Note: lower 4 bits alter behavior
;$007E       #02    Time
;$0080              Wounded Timer (invincibility frames)
;$0081              Damage Received/Effect on Player
;$0082              PC Height
;                            00 = Trevor standing; 01 = Syfa standing; 02 = Grant standing; 03 = Alucard standing;
;                            04 = Trevor duck; 05 = Syfa duck; 06 = Grant duck; 07 = Alucard duck; 08 = Bat
;$0084              Hearts
;$0085              Trevor Subweapon
;                            00 = none; 01 = axe; 02 = boomerang; 03 = knife/book; 04 = holy water; 05 = fireball; 
;                            06 = freeze; 07 = orb; 08 = axe; 09 = boomerang; 0a = knife/book ;0b = clock
;$0086              Partner Subweapon
;$0087              Trevor Subweapon Multiplier   
;                            00 = none; 01 = [II]; 02 = [III]
;$0088              Partner Subweapon Multiplier
;$0089              Vertical Scanline Target (HUD bottom in vertical rooms)
;$008B              Conveyance
;                            01 = Elevator/Frozen enemy; 02 = Scroll-locked right; 05 = Teeter-totter;
;                            06 = Cogwheel; 07 = Mud; 08 = Waterfall; 09 = Waterfall w/current;
;                            0a = Conveyor left; 0b = Conveyor right; 0d = Petrified; 0e = Auto-walk
;$008C              Whip Spark Timer
;$008D              Room Initialized
;$008E              Trevor Weapon Level   
;                            00 = short; 01 = medium; 02 = long
;$008F              Partner Weapon Level
;                            00 = one orb; 01 = two orbs; 03 = three orbs
;$0090              Knockback Direction
;                            00 = left; 01 = right
;$0091              Conveyor (see $008B)
;$0093              Cog Proximity
;                            00 = none; 01 = right OR below; 02 = right AND below
;$0094              Cog ID
;$0095              Cogwheel Size
;                            00 = small; 01 = large
;$0096              Terrain Present
;$0098       #02    Spawner Data Address
;$009a       #02    Terrain Data Address
;$009C              Subweapon Kill Count (affects multiplier drops)
;$009D              Variable Jump (for Grant)
;$009E              Subweapon Iterator
;$009F              Upgrade Previous Game State
;$00A0              Recent Player Direction (copy of $009E)
;$00A1              Previous Player Direction (copy of $0062)
;$00A3              Game Step Counter (only increments while game not paused)
;$00A4              Map Transition Checkpoint
;$00A5              Check Right Tile
;$00A6              Default Drawing State Backup (used during partner swap)
;$00A7       #02    IRQ Latch Backup (used during partner swap)
;$00A9              IRQ Control Backup (used during partner swap)
;$00AA              Partner Swap Previous Game State
;$00AB              Stopwatch Active
;$00AC              Stopwatch Timer
;$00AD              Invincibility Potion Timer
;$00AE              Alucard Bat Timer (drains 1 heart when decreased to 0)
;$00AF              Landing Delay (prevents walking between elevators)
;$00B0              Load Doppelganger Sprites (forces CHR updates)
;$00B1              Current Instance (backup for X register)
;$00B2              Rosary Flash Timer
;$00B3              Bridge Out
;$00B6              Tile Assembly Count Vertical (only for vertical rooms)
;$00B7              Power Up (used for weapon upgrade)
;$00B8              Current Platform (ID of elevator or frozen enemy)
;$00B9              Crash Timer (stuns Player after falling too far)
;$00BA              Boss Special Hitbox (bitmasked)
;$00BB              Boss Melee Hitbox
;                            01-03 = Doppelganger whip; 04 = Doppelganger staff;
;                            05 = Death's Skull; 06 = Moat Dragon head; 
;$00BC              Boss Hitbox Phase (redundant with Doppelganger)
;$00BD              Bone Dragon King HP
;$00BE              Bone Dragon King Misc. Ticker
;$00BF              Faint Pause (pauses game when killed or time runs out)
;$00C0              Flood Halted
;$00C1              Boss Object
;$00C2              Boss Second Phase
;$00C3              Boss Spawner
;$00C4       #02    Character Disabled (cleared in every transition)
;$00C6              Autowalk Data Pointer (ref. $00:9140 for autowalk behavior)
;                            00 = Clocktower/Default; 04 = Forest; 08 = Alucard Caves;
;                            0C = Ghost Ship; 10 = Mountain Pass; 14 = Castle Keep
;$00C7              Thaw Timer (for frozen water)
;$00C8              Horizontal Scroll Lock (used by crumbling bridge)
;$00CA              Flood Height
;$00CE              Weapon Kill Count (affects item drops)
;$00CF              Previous Conveyance (backup of $0088)
;$00D0              Vertical Ceiling (lowest y-coordinate in vertical room)
;$00D2              Cogwheel ID Copy
;$00D3              Grant Corner Y-Coordinate
;$00D4              Cogwheel ID
;$00E0       #02    Audio Current Note Address
;$00E2       #02    Audio Redirect Address
;                   Audio Data Temporary Variable
;$00E4       #02    Audio Data 16-bit Variable
;$00E6       #02    Audio Track Base Address
;$00E8       #02    Audio Track Address
;$00EA              Audio Channels to Load
;$00EB              Audio Routine PROM Bank
;$00EC       #02    Audio Current Period (i.e., pitch)
;$00EE              Audio Current Channel
;$00EF              Audio Track ID
;$00F0       #04    Candle Status (32-bit mask)
;$00F4       #04    Breakable Wall Status
;                            00 = unused/unbroken; ff = broken
;$00F8       #02    Previous Controller Buttons Pressed
;$00FA       #02    Previous Controller Buttons Held
;$00FC       #02    PPU Scroll
;$00FE              PPU Mask (for hue shifts and greyscale)
;$00FF              PPU Control 
;       Audio channels: (grouped by 3, 5, or 7)
;           00 = BGM Square 1; 021 = BGM Square 2; 02 = BGM Triangle;
;           03 = SFX Square 1; 04 = SFX Square 2;
;           05 = Drums (DCM & Noise); 06 = Noise
;$0100       #07    Audio Channel Note Duration
;$0107       #07    Audio Channel Song ID
;$010E       #07    Audio Channel Next Note Duration
;$0115       #07    Audio Channel Behavior
;                             bit 0 = SFX (ignore ritenuto); bits 1-2 = init/decay/sustain/release; 
;                             bit 3 = Al segno loop; bit 5 = coda loop; bit 6 = ignore envelope;
;$011C       #07    Audio Channel Loop Count
;$0123       #07    Audio Channel Note Address Low Byte
;$012A       #07    Audio Channel Note Address High Byte
;$0131       #07    Audio Channel Al Segno Address Low Byte
;$0138       #07    Audio Channel Al Segno Address High Byte
;$013F       #07    Audio Channel Coda Address Low Byte
;$0146       #07    Audio Channel Coda Address High Byte
;$014D       #07    Audio Channel Previous Period High Byte
;$0152              Audio Global Dampening (lowers volume for all channels)
;$0154       #07    Audio Channel Volume
;$0159              Audio Global Fade Timer (decreases $017C after 2b steps)
;$015B       #07    Audio Channel Next Control Value / Channel Dampening Placeholder
;$0160              Audio Global Fade Delay
;$0162       #07    Audio Channel Default Duty Cycle
;$0167              Audio Global Mute for Pause
;$0169       #05    Audio Channel Dampening (lowers volume for specific channel)
;$016E       #05    Audio Channel Attributes
;                             bit 4 = use waveform; bit 5 = alternate duty; bit 7 = disabled needs more info
;$0173       #05    Audio Channel Pitch Bend Amount
;$0178       #05    Audio Channel Period Low Byte Backup (useless?)
;$017D       #03    Audio Channel Octave (raises octave by 5-n)
;$0180       #03    Audio Channel Note Offset
;                             (adds signed value to note ID to look up period)
;$0183       #03    Audio Channel Period Low 
;$0186       #03    Audio Channel Period High 
;$0189       #03    Audio Channel Volume Envelope
;                             (if bit 7 set, fade out instead based on bits 0-3)
;$018C              Audio SFX Register Offset
;$018D              Audio Global Ritenuto Delay (counts up to $018E)
;$018E              Audio Global Ritenuto Cutoff (frames until $018F set)
;$018F              Audio Global Ritenuto (prolongs BGM note duration when set)
;$0190       #02    Audio SFX Square Sweep
;$0192              Audio Current DPCM
;$0193              Audio Triangle Staccato Timer
;$0194              Audio Triangle Linear Counter (only used with $193)
;$0195       #07    Audio Channel PROM Bank
;$019C              Audio SFX Square 1 Sweep (write to $4001)
;$0200      #100    OAM Data
;$0300       #a0    Tile Data
;$03C0       #03    Audio Channel Volume Envelope Duration
;$03C3       #03    Audio Channel Volume Envelope Position
;$03C6       #03    Audio Channel Volume Envelope Loop Count
;$03C9       #03    Audio Channel Volume Envelope Loop Point
;$03CC       #03    Audio Channel Fadeout Point (fades out when equal to $100,X)
;$03CF       #03    Audio Channel Volume Envelope 
;                             (bits 0-3 = value; $03CC = duration*value >> 4)
;$03D2       #03    Audio Channel Next Fade Duration
;$03D5       #03    Audio Channel Fade Duration
;$03D8       #03    Audio Channel Alternate Duty Cycle
;$03DB       #03    Audio Channel Next Pitchbend Duration
;$03DE       #03    Audio Channel Pitchbend Duration
;$03E1       #03    Audio Channel Sweep Rate
;$0400       #1c    Sprite Frame Index
;$041C       #1c    Y-Coordinate
;$0438       #1c    X-Coordinate 
;$0454       #1c    Sprite Attributes (palette & background priority)
;$0470       #1c    Attributes
;                            01 = destroyed; 02 = frozen; 04 = unknown; 08 = flicker;
;                            10 = illusory; 20 = inanimate; 40 = moving; 80 = invisible
;$048C       #1c    Animation Batch (even numbers)
;                            00-06 = Player; 08-12 = NPCs; 14 = Epilogue; 16-1C = Doppelganger
;$04A8       #1C    Sprite Mirrored
;$04C4       #17    X-Coordinate Subpixel
;$04DB       #17    Y-Coordinate Subpixel
;$04F2       #17    Horizontal Speed
;  $0505            Partner Swap Ghosting Amount
;$0509       #17    Horizontal Speed Subpixel
;  $051C            Partner Swap Ghosting Amount Fractional
;$0520       #17    Vertical Speed
;$0537       #17    Vertical Speed Subpixel
;$054E       #17    Object Index
;$0565              Player State
;$0566       #11    Stun Timer
;$0578              Weapon State
;$0579       #03    Subweapon State
;$057C       #17    Animation Timer
;$0593       #17    Sprite Frame (used to calculate $0400,X)
;$05AA       #17    Sprite Index
;$05C1              Moving Down
;$05C2       #12    NPC State
;$05D4              Player Stunned State
;                   Partner Swap X-coordinate
;$05D5       #03    Subweapon Throw Delay
;$05D8              Player Jump State
;                             00-1D = Trevor/Syfa/Alucard; 1E-39 = Grant
;$05D9       #0c    Boss Use
;$05E5       #06    Candle Drop
;                             83 = Axe; 84 = Cross; 85 = Dagger; 86 = Holy Water; 87 = Stopwatch;
;                             88 = Syfa Fire; 89 = Syfa Ice; 8a = Syfa Water; 8b = Grant Dagger;
;                             8c Grant Axe; 8d-8f = Upgrades (8f removed); 90 = Wall Meat; 
;                             91 = Invincibility Potion; 92 = Rosary; 93-9b = Coins; 9c = 1UP; 
;                             9d = Big Heart; 9e = Small Heart; 9f-a0 = Multipliers
;$05EB              Stair Stun Timer
;                   Partner Swap Ghosting Speed Fractional
;$05EF              Stair Direction
;                   Grant Jump State Fraction (functions like speed variables)
;$05F0       #12    AI Class (determines behavior)
;$0602              Stair Stun (decreases $05EB)
;                   Freezing Rivers
;                   Turning Into Bat
;                   Partner Swap Ghosting Speed 
;$0606              Grant Gravity Subpixel (increases $05EF for Grant)
;$0607       #12    State Timer (time between state changes for most NPCs)
;                   Sinusoid Center Axis
;$0619              Partner Swap Y-Coordinate
;$061A       #03    Subweapon Damage and Multikill Count
;$061D              Stair Timer (time to climb one step)
;                   Grant Gravity (increases $05D8 for Grant)
;$061E       #12    Miscellaneous Ticker (usually timer or counter for NPCs)
;$0630              Weapon Damage
;$0631       #03    Subweapon Deflection (copy of $0658,X on Cross hit)
;$0634       #17    Miscellaneous Use (used by a couple NPCs)
;$0646       #12    Spawner Index
;$0658       #0d    NPC Damage
;$0664       #06    Candle Active
;$066A       #12    Applied Effect (copy of $061A,X on subweapon hit)
;$067B       #12    NPC Hitpoints
;$068E       #12    Weapons Impact
;                             01 = weapon; 02 = subweapon 1; 04 = subweapon 2; 08 = subweapon 3
;$06A0       #03    Audio Channel Pitch Envelope Loop Start
;$06A3       #03    Audio Channel Pitch Envelope ID
;$06A6       #03    Audio Channel Pitch Envelope Position
;$06A9       #03    Audio Channel Pitch Envelope Loop Count
;$06AC       #03    Audio Channel Sustain State (80 = disabled)
;$06AF       #03    Audio Channel Sustain Position (from 0 to 3)
;$06B2       #03    Audio Channel Sustain Dampen
;$06B5       #04    Audio BGM Square 1 Sustain Period Low Bytes
;$06B9       #04    Audio BGM Square 2 Sustain Period Low Bytes
;$06BD       #04    Audio BGM Square 1 Sustain Period High Bytes
;$06C1       #04    Audio BGM Square 2 Sustain Period High Bytes
;$06C8              Boss Scream Time (stops DPCM at f0)
;$06C9              Music Paused
;$06E0       #90    Collision Map
;                             00 = empty; 01 = mud; 02 = convey right; 03 = convey left;
;                             04 = fragile; 05 = ceiling spike; 06 = solid; 07 = floor spike;
;                             08 = ice; 0c-0f = cracking
;$0770       #08    CHR5 Solid Definitions
;                             Byte 0 = empty; Byte 1 = mud; Byte 2 = convey right; Byte 3 = convey left;
;                             Byte 4 = fragile; Byte 5 = ceiling spike; Byte 6 = solid; Byte 7 = floor spike
;$0778       #08    CHR6 Solid Definitions 
;$0780              Background Animation Frame
;                   Entry Selector Column
;                   Map Clipping
;                             00 = To Grant; 01 = To Syfa; 02 = From Alucard
;$0781              Background Animation Timer
;                   Entry Selector Row
;                   Map Fade-out Value
;$0782       #40    Fog Parallax Positions
;                             32 rows of parallax with 2 bytes per row:
;                             Byte 0 = subpixel offset; Byte 1 = pixel offset
;                   Previous Selector Column
;                   Map Timer
;                   Epilogue Partner
;                   Sypha's Frozen Tile Column
;$0783              Previous Selector Row
;                   Map Horizontal Speed Subpixel
;                   Epilogue State
;                   Sypha's Frozen Tile Row
;$0784              Name Cursor Position
;                   Map Horizontal Speed
;                   Castle Shake Direction
;                   Leftmost Frozen Tile Column
;$0785              Map Vertical Speed Subpixel
;                   Epilogue Text Page
;                   Leftmost Frozen Tile Row
;$0786              Password Icon
;                   Map Vertical Speed
;                   Rightmost Frozen Tile Column
;$0787              Previous Password Icon
;                   Map Scroll Timer
;                   Rightmost Frozen Tile Row
;$0788       #02    Password Decryption Dump
;                   Map X-coordinate Subpixel
;                   Epilogue Scroll Timer
;                   Water Freeze Counter
;$0789              Map Y-coordinate Subpixel
;                   Frozen Water Room Type
;$078A              Epilogue Timer
;                   Map Path PPU Scroll
;$078B              Map Path PPU Control
;                   Password Errors (used for debugging)
;$078C       #02    Map Path PPU Address
;                   Update Selector
;$0790       #10    Entered Password
;                             00 = empty; 01 = whip; 02 = cross; 03 = heart
;            #10    Boss Stun Timer
;                   Map Screen Platform
;                             00 = full; 01 = short west; 02 = bottom east;
;                             03 = top west; 04 = middle west; 05 = bottom west
;$07A0       #0a    Generated Password
;$07B1       #02    Stacked Breakable Wall
;$07B3       #02    Lower Block Broken
;$07B5       #02    Upper Block Broken
;$07B7       #02    Wall ID (points to $00F4,X)
;$07C2       #06    Spawner Type
;$07C8       #06    Spawner State
;$07CE       #06    Spawner Timer
;$07D4       #06    Spawner Y-Coordinate
;$07DA       #06    Spawner x-Coordinate
;$07E0       #06    Spawner Offscreen
;$07E6       #06    Spawner NPC Object
;$07EC       #06    Bone Dragon King Frames (two ribs per byte)
;                   Cyclops Lightning State
;                   Bone Dragon Cycle
;                   Giant Bat Leader
;                   Dracula Phase
;                             00 = Dracula; 01 = demon; 02 = Pazuzu
;$07ED              Stage Clear State
;                   Bone Dragon Mirrored
;                   Collapsing Bridge Length
;                   Giant Bat State
;$07EE              Bone Dragon Fireball Timer
;                   Death Scythe Count
;$07EF              Bone Dragon Attacking
;$07F3              Boss Battle State
;                             00 = boss fight; 01 = boss defeat; 02 = crystal drop;
;                             03 = battle over; 80 = boss waiting
;                   Victory Delay (timer after battle over)
;$07F6              Hard Mode
;$07F8       #08    Player Name