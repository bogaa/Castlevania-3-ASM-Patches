if expandPRG
prgbanks = 32	
inesprg prgbanks   ; write header PRG 

bank $1d
base $8000
org $bfff
	insert banksize * (prgbanks-oldPrgBanks)
endif

;-------------------------------------------------------------------------------

if expandCHR
chrbanks = 32
ineschr chrbanks

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
inesbattery 		; write 2 header 
print "sRAM"		; we always use SRAM

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


bank $1e					; to do rewrite the loader make offload code to new bank like in CV1 practice hack.. 
base $c000
org $dd00
	initSRAM:			
		lda #$02			;enable write to RAM
		sta $5102
		
		lda #$01			;enable write to RAM
		sta $5103
	
	CopyToSRAM:			;	sta $5113 Switch SRAM Page
		LDY #$00       	; 	Copy code block to SRAM. Run on startup          
	CopyToSRAMLoop:
		LDA CodeBlock,y              
		STA SRAM_Code,y              
		LDA CodeBlock2,y              
		STA SRAM_Code+256,y     		
		lda #$00
		sta $6000,y		; initalize sRAM 
		sta $6100,y
		sta $6200,y
		sta $6300,y
		sta $6400,y
		sta $6500,y
		sta $6600,y
		sta $6700,y
		sta $6800,y
		sta $6900,y
		sta $6a00,y
		sta $6b00,y
		sta $6c00,y
		sta $6d00,y
		sta $6e00,y
		sta $6f00,y
		iny                       
		BNE CopyToSRAMLoop      
		
	endInitRAM:	
		JSR $E227     		 ;hijack fix  ->  initSound
		rts

;
;	initExtRamAndMMC5Regs:		; venheim full initalize.. I might do different stup.. 
;		lda #2
;		sta $5102
;		lda #1
;		sta $5103
;	
;	; clear extended ram
;		ldx #$80
;		ldy #$00
;		lda #$60
;		sta $01
;		lda #$00
;		sta $00
;	-	sta ($00), y
;		iny
;		bne -
;		inc $01
;		cpx $01
;		bne -
;	
;		jmp initMMC5Regs


org $de00	; SRAM_Code
	CodeBlock:	
		db "goes_into_sram._a_good_place_to_transit_to_different_banks"

org $df00	
	CodeBlock2:		
		db "goes_into_sram._a_good_place_to_transit_to_different_banks"
endif
