; --------------------------------------------------
; Patcher
; by SpiderDave, https://spiderdave.me/nes/index.php?c=70-Super-C-Randomizer
; hackers: bogaabogaa,
; --------------------------------------------------

arch nes.cpu        	; NES architecture
banksize $2000     		; size of each prg bank
header              	; rom has a header

org $8000           	; Needed once to set the pc

 
; -- Default Settings ------------------------------

listFilename = "list.txt"
outputFilename = "Castlevania_3_patched.nes"

; -- Local Settings --------------------------------
iffileexist "settings.local.asm"
    print loading local settings
    include "settings.local.asm"
endif
; --------------------------------------------------

;seed = $1234           	; Set seed manually for random stuff
ifndef seed					; Random seed if not set yet
    seed = {randword}
endif

seed {seed}
print "seed: {format:04x:seed}"


; ---------------------------------------------------
; feature are explained in readme.txt! --------------

enableROM_Mods = 1			; this is useful to disable if you do not want any code to be patched. Usefull to add vanilla tables and check if there are not any errors.
GFX_patching = 0

expand = 1				
	if expand				
		addSRAM =   1
		expandCHR = 0		
		expandPRG = 0		
		
		incsrc code/expand.asm
		 
		levelSelect = 1		; Mods needs SRAM! Or Expansion.
		cheats = 	  1		;
		airControl =  0		;	
	endif

fastLunch = 			0	; cheats to test the game faster. 
allCharacters = 		0									  
fastCharacterSwap =		0		

chrAnimations = 		0	; expands to have more of them avalible 
CHRparallex = 			0
subWeaponDrop =			0	; made by SpiderDave
fastDoor = 				0

; ---------------------------------------------------
; experimental features
experiment = 0				;	

; ----------------------------------------------------
; patches

incsrc code/labels.asm		; get a overview of labels and use them to code 
incsrc code/generalASM/hardwareDefines.asm 

if airControl
incsrc code/airControl.asm
endif

if enableROM_Mods
incsrc code/smallPatches.asm	; contains cheats, whilePauseRoutines, itemDrop
endif 

;textmap 0...9 d0	;TextMapMainGame
;textmap A...Z e0
;incsrc code/text.asm 			; textMap error!! 

;incsrc code/GG_sound.asm

incsrc code/levelEffect.asm		; animations, fog and many other things can be set to different levels or disabled

incsrc code/sprAssembPlusTables.asm

incsrc code/misc.asm			; Lower part is editable by revamp. About the breakable walls and special events that go into levels. 

incsrc code/entitySpawning.asm
incsrc code/entity.asm 			; editing enemy AI 

if expandPRG
incsrc code/screens.asm 
endif 

if GFX_patching 

chr 0
base $0000
incbin .gfx/CHR_banks/00_.CHR 
incbin .gfx/CHR_banks/01_.CHR 
incbin .gfx/CHR_banks/02_.CHR 
incbin .gfx/CHR_banks/03_.CHR 
incbin .gfx/CHR_banks/04_.CHR 
incbin .gfx/CHR_banks/05_.CHR 
incbin .gfx/CHR_banks/06_.CHR 
incbin .gfx/CHR_banks/07_.CHR 

chr 1
base $0000
incbin .gfx/CHR_banks/08_.CHR 
incbin .gfx/CHR_banks/09_.CHR 
incbin .gfx/CHR_banks/0a_.CHR 
incbin .gfx/CHR_banks/0b_.CHR 
incbin .gfx/CHR_banks/0c_.CHR 
incbin .gfx/CHR_banks/0d_.CHR 
incbin .gfx/CHR_banks/0e_.CHR 
incbin .gfx/CHR_banks/0f_.CHR 

chr 2
base $0000
incbin .gfx/CHR_banks/10_.CHR 
incbin .gfx/CHR_banks/11_.CHR 
incbin .gfx/CHR_banks/12_.CHR 
incbin .gfx/CHR_banks/13_.CHR 
incbin .gfx/CHR_banks/14_.CHR 
incbin .gfx/CHR_banks/15_.CHR 
incbin .gfx/CHR_banks/16_.CHR 
incbin .gfx/CHR_banks/17_.CHR 

chr 3
base $0000
incbin .gfx/CHR_banks/18_.CHR 
incbin .gfx/CHR_banks/19_.CHR 
incbin .gfx/CHR_banks/1a_.CHR 
incbin .gfx/CHR_banks/1b_.CHR 
incbin .gfx/CHR_banks/1c_.CHR 
incbin .gfx/CHR_banks/1d_.CHR 
incbin .gfx/CHR_banks/1e_.CHR 
incbin .gfx/CHR_banks/1f_.CHR 

chr 4
base $0000
incbin .gfx/CHR_banks/20_.CHR 
incbin .gfx/CHR_banks/21_.CHR 
incbin .gfx/CHR_banks/22_.CHR
incbin .gfx/CHR_banks/23_.CHR 
incbin .gfx/CHR_banks/24_.CHR 
incbin .gfx/CHR_banks/25_.CHR 
incbin .gfx/CHR_banks/26_.CHR 
incbin .gfx/CHR_banks/27_.CHR 

chr 5
base $0000
incbin .gfx/CHR_banks/28_.CHR 
incbin .gfx/CHR_banks/29_.CHR 
incbin .gfx/CHR_banks/2a_.CHR 
incbin .gfx/CHR_banks/2b_.CHR 
incbin .gfx/CHR_banks/2c_.CHR 
incbin .gfx/CHR_banks/2d_.CHR 
incbin .gfx/CHR_banks/2e_.CHR 
incbin .gfx/CHR_banks/2f_.CHR 

chr 6
base $0000
incbin .gfx/CHR_banks/30_.CHR 
incbin .gfx/CHR_banks/31_.CHR 
incbin .gfx/CHR_banks/32_.CHR 
incbin .gfx/CHR_banks/33_.CHR 
incbin .gfx/CHR_banks/34_.CHR 
incbin .gfx/CHR_banks/35_.CHR 
incbin .gfx/CHR_banks/36_.CHR 
incbin .gfx/CHR_banks/37_.CHR 

chr 7
base $0000
incbin .gfx/CHR_banks/38_.CHR 
incbin .gfx/CHR_banks/39_.CHR 
incbin .gfx/CHR_banks/3a_.CHR 
incbin .gfx/CHR_banks/3b_.CHR 
incbin .gfx/CHR_banks/3c_.CHR 
incbin .gfx/CHR_banks/3d_.CHR 
incbin .gfx/CHR_banks/3e_.CHR 
incbin .gfx/CHR_banks/3f_.CHR 

chr 8
base $0000
incbin .gfx/CHR_banks/40_.CHR 
incbin .gfx/CHR_banks/41_.CHR 
incbin .gfx/CHR_banks/42_.CHR 
incbin .gfx/CHR_banks/43_.CHR 
incbin .gfx/CHR_banks/44_.CHR 
incbin .gfx/CHR_banks/45_.CHR 
incbin .gfx/CHR_banks/46_.CHR 
incbin .gfx/CHR_banks/47_.CHR 

chr 9
base $0000
incbin .gfx/CHR_banks/48_.CHR 
incbin .gfx/CHR_banks/49_.CHR 
incbin .gfx/CHR_banks/4a_.CHR 
incbin .gfx/CHR_banks/4b_.CHR 
incbin .gfx/CHR_banks/4c_.CHR 
incbin .gfx/CHR_banks/4d_.CHR 
incbin .gfx/CHR_banks/4e_.CHR 
incbin .gfx/CHR_banks/4f_.CHR 

chr 10
base $0000
incbin .gfx/CHR_banks/50_.CHR 
incbin .gfx/CHR_banks/51_.CHR 
incbin .gfx/CHR_banks/52_.CHR 
incbin .gfx/CHR_banks/53_.CHR 
incbin .gfx/CHR_banks/54_.CHR 
incbin .gfx/CHR_banks/55_.CHR 
incbin .gfx/CHR_banks/56_.CHR 
incbin .gfx/CHR_banks/57_.CHR 

chr 11
base $0000
incbin .gfx/CHR_banks/58_.CHR 
incbin .gfx/CHR_banks/59_.CHR 
incbin .gfx/CHR_banks/5a_.CHR 
incbin .gfx/CHR_banks/5b_.CHR 
incbin .gfx/CHR_banks/5c_.CHR 
incbin .gfx/CHR_banks/5d_.CHR 
incbin .gfx/CHR_banks/5e_.CHR 
incbin .gfx/CHR_banks/5f_.CHR 

chr 12
base $0000
incbin .gfx/CHR_banks/60_.CHR 
incbin .gfx/CHR_banks/61_.CHR 
incbin .gfx/CHR_banks/62_.CHR 
incbin .gfx/CHR_banks/63_.CHR 
incbin .gfx/CHR_banks/64_.CHR 
incbin .gfx/CHR_banks/65_.CHR 
incbin .gfx/CHR_banks/66_.CHR 
incbin .gfx/CHR_banks/67_.CHR 

chr 13
base $0000
incbin .gfx/CHR_banks/68_.CHR 
incbin .gfx/CHR_banks/69_.CHR 
incbin .gfx/CHR_banks/6a_.CHR 
incbin .gfx/CHR_banks/6b_.CHR 
incbin .gfx/CHR_banks/6c_.CHR 
incbin .gfx/CHR_banks/6d_.CHR 
incbin .gfx/CHR_banks/6e_.CHR 
incbin .gfx/CHR_banks/6f_.CHR 

chr 14
base $0000
incbin .gfx/CHR_banks/70_.CHR 
incbin .gfx/CHR_banks/71_.CHR 
incbin .gfx/CHR_banks/72_.CHR 
incbin .gfx/CHR_banks/73_.CHR 
incbin .gfx/CHR_banks/74_.CHR 
incbin .gfx/CHR_banks/75_.CHR 
incbin .gfx/CHR_banks/76_.CHR 
incbin .gfx/CHR_banks/77_.CHR 

chr 15
base $0000
incbin .gfx/CHR_banks/78_.CHR 
incbin .gfx/CHR_banks/79_.CHR 
incbin .gfx/CHR_banks/7a_.CHR 
incbin .gfx/CHR_banks/7b_.CHR 
incbin .gfx/CHR_banks/7c_.CHR 
incbin .gfx/CHR_banks/7d_.CHR 
incbin .gfx/CHR_banks/7e_.CHR 
incbin .gfx/CHR_banks/7f_.CHR 

endif 

listFile {listFilename}
outputFile {outputFilename}
