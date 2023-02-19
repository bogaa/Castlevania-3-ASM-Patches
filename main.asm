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

expand = 1
	if expand
		addSRAM = 1
		expandCHR = 1		
		expandPRG = 1		
		incsrc code/expand.asm
		endif 

whilePauseRoutines = 1		; needs SRAM!
	if whilePauseRoutines
		levelSelect = 1
		cheats = 1
	endif 

fastLunch = 1				; will get you in the game. Great for testing!
allCharacters = 1
fastCharacterSwap = 1

chrAnimations = 1			; expands to have more of them avalible 
airControl = 1				; needs SRAM!
subWeaponDrop = 1			; made by SpiderDave


; ---------------------------------------------------
; experimental features
extraBGpalette4Character = 0

mapExpand = 0
experiment = 0				


; ----------------------------------------------------
; patches

incsrc code/RAM_Lables.asm		; get a overview of labels and use them to code 


if airControl
incsrc code/airControl.asm
endif

incsrc code/smallPatches.asm	; contains cheats, whilePauseRoutines, itemDrop
incsrc code/levelEffect.asm		; animations, fog and many other things can be set to different levels or disabled

incsrc code/spriteAssembly.asm


;textmap 0...9 d0	;TextMapMainGame
;textmap A...Z e0


if experiment

endif

if extraBGpalette4Character
incsrc  code/extraPalette.asm
endif 


listFile {listFilename}
outputFile {outputFilename}
