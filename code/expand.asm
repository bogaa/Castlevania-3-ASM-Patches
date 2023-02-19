if expandPRG
;prgbanks 64			; there is probably a better way to write header changes but could not find out.. 	
bank $00
base $8000
org $8000-16 + 4
		db $20

bank $1d
base $8000
org $bfff
	insert banksize * (prgbanks-oldPrgBanks)
endif

;-------------------------------------------------------------------------------

if expandCHR
;chrbanks 32		  	; there is probably a better way to write header changes but could not find out.. 	
bank $00
base $8000
org $8000-16 + 5
		db $20

bank $30				; 48 banks in total this is a hacky way as I could not figure chrbank directives.. 
if expandPRG
bank $6f
endif
base $8000
org $8000
insert banksize * (prgbanks-oldPrgBanks)
endif

;-------------------------------------------------------------------------------

if addSRAM
print "sRAM"		; we always use SRAM
	sramCode = $6000	; define unused code blocks
	sramCode2 = $6100

bank -1
org $8000-16 + 6
		db $52

;----------- initiate and prepare SRAM codeblock --------------------------------------------------------------------
bank $1f
if expandPRG
bank $3f
endif
base $e000
org $e03a



		JSR $E0DF 		; initMMC5Regs
		JSR $E2DA  		; setBank_c000_toRom1eh   
		JSR initSRAM    

org $e0df
	initMMC5Regs:
		lda #$00		; disabled
		sta $5010 		;PCM_MODE.w
		; use as extra nametable (unused)
		sta $5104		;EXTENDED_RAM_MODE.w
		; start with vertical mirroring
		lda #$44		;#NT_VERTICAL_MIRROR
		sta $25		;wNametableMapping
		sta $5105		;NAMETABLE_MAPPING.w
	
		lda #$00
		; disable vertical split mode
		sta $5200		;VERTICAL_SPLIT_MODE.w
		; default tile/colour (unused)
		sta $5106 		;FILL_MODE_TILE.w
		sta $5107		;FILL_MODE_COLOUR.w
		; 8000 - 16kb, c000/e000 - 8kb
		ldy #$02		;#PRG_MODE_16_8_8
		sty $5100		;PRG_MODE.w
		; 1kb CHR pages
		iny
		sty $5101		;CHR_MODE.w
		rts

bank $1e
base $c000
org $dd00
	initSRAM:			
		lda #$02			;enable write to RAM
		sta $5102
		
		lda #$01			;enable write to RAM
		sta $5103
		
		lda #$00
		tay
	loopClearSRAM			;clear the beginning of SRAM so it is clean to be used again	
		sta $7000,y
		dey
		bne loopClearSRAM	
		;	sta $5113			; Switch SRAM Page you could put extra code to different SRAM pages.. 

	CopyToSRAM:
		LDY #$00       		;Copy code block to SRAM. Run on startup          
	CopyToSRAMLoop:
		LDA CodeBlock,y              
		STA $6000,y              
		dey                      
		BNE CopyToSRAMLoop      
	CopyToSRAMLoop2:
		LDA CodeBlock2,y              
		STA $6100,y              
		dey                      
		BNE CopyToSRAMLoop2 	
	
	
	endInitRAM:	
		JSR $E227     		 ;hijack fix  ->  initSound
		rts

org $de00	
	CodeBlock:	
		;base $6000	
		db "goes_into_sram._a_good_place_to_transit_to_different_banks"

org $df00	
	CodeBlock2:	
		;base $6100		
		db "goes_into_sram._a_good_place_to_transit_to_different_banks"
endif
