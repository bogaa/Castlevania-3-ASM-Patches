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
outputFilename = "Castlevania_3{format:04x:seed}.nes"

; -- Local Settings --------------------------------
iffileexist "settings.local.asm"
    print loading local settings
    include "settings.local.asm"
endif
; --------------------------------------------------

seed = $1234           	; Set seed manually for random stuff
ifndef seed				; Random seed if not set yet
    seed = {randword}
endif

seed {seed}
print "seed: {format:04x:seed}"


; ---------------------------------------------------
; feature are explained in readme.txt! --------------

enableROM_Mods = 1			; this is useful to disable if you do not want any code to be patched. Usefull to add vanilla tables and check if there are not any errors.

expand = 1					
	if expand				
		addSRAM = 1
		expandCHR = 1		
		expandPRG = 1		
		incsrc code/expand.asm
		 
		levelSelect = 1		; Mods needs SRAM! Or Expansion.
		cheats = 1			;
		airControl = 1		;	
	endif

fastLunch = 0				; cheats to test the game faster. 
allCharacters = 0			;								  
fastCharacterSwap = 0		;

chrAnimations = 0			; expands to have more of them avalible 

subWeaponDrop = 0			; made by SpiderDave


; ---------------------------------------------------
; experimental features
extraBGpalette4Character = 0	; non functional or buggy
mapExpand = 0					;
experiment = 0					;	


; ----------------------------------------------------
; patches

incsrc code/RAM_LabelsAndDefines.asm		; get a overview of labels and use them to code 


if airControl
incsrc code/airControl.asm
endif

if enableROM_Mods
incsrc code/smallPatches.asm	; contains cheats, whilePauseRoutines, itemDrop
endif 


incsrc code/levelEffect.asm		; animations, fog and many other things can be set to different levels or disabled

incsrc code/spriteAssembly.asm

incsrc code/misc.asm			; this is a revamp lable. About the breakable walls and special events that go into levels. 

;textmap 0...9 d0	;TextMapMainGame
;textmap A...Z e0


if extraBGpalette4Character
incsrc  code/extraPalette.asm
endif 


listFile {listFilename}
outputFile {outputFilename}
