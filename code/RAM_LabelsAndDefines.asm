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
		wVramQueueNextIdxToFill: 			.dsb 1	; $1d db
		wRandomVal: 						.dsb 1	; $1f db
		wCurrFrameStartingOamOffset: 		.dsb 1	; $20 db
		wPrgBank_8000: 						.dsb 1 	; $21 db
		wPrgBankBkup_8000: 					.dsb 1	; $22 db
		wPrgBankBkup2_8000: 				.dsb 1	; $23 db
		wIsExecutingSoundFunc: 				.dsb 1	; $24 db
		wNametableMapping: 					.dsb 1	; $25db
		wJoy1NewButtonsPressed: 			.dsb 1	; $26 db
		wJoy2NewButtonsPressed: 			.dsb 1 	; $27 db
		wJoy1ButtonsPressed: 				.dsb 1	; $28 db
		wJoy2ButtonsPressed: 				.dsb 1	; $29 db
		wInGameSubstate: 					.dsb 1	; $2a db	; todo: could be multi-purpose, could be wrong
		wIsPaused: 							.dsb 1	; $2b db
		wCinematicsController: 				.dsb 1	; $2c db
		w02d:    							.dsb 4	; dsb $30-$2d
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