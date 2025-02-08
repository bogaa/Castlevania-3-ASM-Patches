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

vanillaFiles = 1			; this is useful to disable if you do not want any code to be patched. Usefull to add vanilla tables and check if there are not any errors.
GFX_patching = 0

expand = 1					; needs to be enabled to patch small patches as well		
	if expand				
		addSRAM =   1
		expandCHR = 0		
		expandPRG = 0		
		
		incsrc code/expand.asm
		 
		levelSelect = 1		; Mods needs SRAM! Or Expansion.
		cheats = 	  0		;
		airControl =  0		;	
	endif

fastLunch = 			0	; cheats to test the game faster. 
allCharacters = 		0									  
fastCharacterSwap =		1		

stageProgression = 		0
playerEnhance = 		0
newFogEffects = 		1
musicTestFull_BSTART = 	1 

chrAnimations = 		0	; expands to have more of them avalible 
CHRparallex = 			0
subWeaponDrop =			0	; made by SpiderDave
fastDoor = 				1

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

if expand
incsrc code/smallPatches.asm	; contains cheats, whilePauseRoutines, itemDrop
endif 

if vanillaFiles

incsrc code/stageProgression.asm 
incsrc code/text.asm 			; textMap error!! 
incsrc code/levelTables.asm		; effects, for collusion...
incsrc code/sprAssembPlusTables.asm
incsrc code/misc.asm			; Lower part is editable by revamp. About the breakable walls and special events that go into levels. 

incsrc code/entitySpawning.asm
incsrc code/entity.asm 			; editing enemy AI
; incsrc code/GG_sound.asm 
endif 

if expandPRG
incsrc code/screens.asm 
endif 

if GFX_patching 

chr 0
base $0000
incbin .gfx/CHR_banks/00_.CHR ; trevor
incbin .gfx/CHR_banks/01_.CHR ; whip 
incbin .gfx/CHR_banks/02_.CHR ; grant
incbin .gfx/CHR_banks/03_.CHR ; 
incbin .gfx/CHR_banks/04_.CHR ; sympha 
incbin .gfx/CHR_banks/05_.CHR ; 
incbin .gfx/CHR_banks/06_.CHR ; alucard 
incbin .gfx/CHR_banks/07_.CHR ;

chr 1
base $0000
incbin .gfx/CHR_banks/08_.CHR ; zombie, bird, ghost, fuzzy 
incbin .gfx/CHR_banks/09_.CHR ; bat, axe-armore 
incbin .gfx/CHR_banks/0a_.CHR ; boneTurret, hunchback, fishman
incbin .gfx/CHR_banks/0b_.CHR ; gargoyl, sword skelly, fuzzy 
incbin .gfx/CHR_banks/0c_.CHR ; spider, owl 
incbin .gfx/CHR_banks/0d_.CHR ; knight, spore thunder
incbin .gfx/CHR_banks/0e_.CHR ; eye, mummy
incbin .gfx/CHR_banks/0f_.CHR ; headless knight, medusa

chr 2
base $0000
incbin .gfx/CHR_banks/10_.CHR ; frog, mudman
incbin .gfx/CHR_banks/11_.CHR ; bat, boneDragon
incbin .gfx/CHR_banks/12_.CHR ; misc traps 
incbin .gfx/CHR_banks/13_.CHR ; skelly 
incbin .gfx/CHR_banks/14_.CHR ; gear, medusa boneDragon
incbin .gfx/CHR_banks/15_.CHR ; gear, drops, fireman, boneTurret 
incbin .gfx/CHR_banks/16_.CHR ; prayer
incbin .gfx/CHR_banks/17_.CHR ; sypha intreduction, bird 

chr 3
base $0000
incbin .gfx/CHR_banks/18_.CHR ; boss bone king
incbin .gfx/CHR_banks/19_.CHR ; boss bone king
incbin .gfx/CHR_banks/1a_.CHR ; boss grant
incbin .gfx/CHR_banks/1b_.CHR ; boss grant
incbin .gfx/CHR_banks/1c_.CHR ; boss zyclops
incbin .gfx/CHR_banks/1d_.CHR ; boss bat small, handshake 
incbin .gfx/CHR_banks/1e_.CHR ; boss alucard
incbin .gfx/CHR_banks/1f_.CHR ; boss alucard

chr 4
base $0000
incbin .gfx/CHR_banks/20_.CHR ; boss water dragons
incbin .gfx/CHR_banks/21_.CHR ; boss bone dragon 
incbin .gfx/CHR_banks/22_.CHR ; boss monster frank
incbin .gfx/CHR_banks/23_.CHR ; boss monster frank
incbin .gfx/CHR_banks/24_.CHR ; boss medusa 
incbin .gfx/CHR_banks/25_.CHR ; boss medusa 
incbin .gfx/CHR_banks/26_.CHR ; boss flying goatman
incbin .gfx/CHR_banks/27_.CHR ; boss flying goatman

chr 5
base $0000
incbin .gfx/CHR_banks/28_.CHR ; boss bat big 
incbin .gfx/CHR_banks/29_.CHR ; boss mummy, flame
incbin .gfx/CHR_banks/2a_.CHR ; cut scene trevor grant
incbin .gfx/CHR_banks/2b_.CHR ; cut scene sympha alucard
incbin .gfx/CHR_banks/2c_.CHR ; boss death
incbin .gfx/CHR_banks/2d_.CHR ; boss death
incbin .gfx/CHR_banks/2e_.CHR ; boss death skull
incbin .gfx/CHR_banks/2f_.CHR ; harpies, alucard resurect 

chr 6
base $0000
incbin .gfx/CHR_banks/30_.CHR ; boss Dracula
incbin .gfx/CHR_banks/31_.CHR ; boss Dracula
incbin .gfx/CHR_banks/32_.CHR ; boss Dracula 3rd
incbin .gfx/CHR_banks/33_.CHR ; boss Dracula 3rd
incbin .gfx/CHR_banks/34_.CHR ; boss Dracula 2rd
incbin .gfx/CHR_banks/35_.CHR ; boss Dracula 2rd
incbin .gfx/CHR_banks/36_.CHR ; second Quest Monster
incbin .gfx/CHR_banks/37_.CHR ; ABC candles 

chr 7
base $0000
incbin .gfx/CHR_banks/38_.CHR ; ending trevor
incbin .gfx/CHR_banks/39_.CHR ; ending sympha 
incbin .gfx/CHR_banks/3a_.CHR ; ending lake 
incbin .gfx/CHR_banks/3b_.CHR ; ending grant 
incbin .gfx/CHR_banks/3c_.CHR ; intro trevor  
incbin .gfx/CHR_banks/3d_.CHR ; intro castle  
incbin .gfx/CHR_banks/3e_.CHR ; intro castle  
incbin .gfx/CHR_banks/3f_.CHR ; intro trevor close-up 

chr 8
base $0000
incbin .gfx/CHR_banks/40_.CHR ; door, spikes, clock heart 
incbin .gfx/CHR_banks/41_.CHR ; 0123, ABC 
incbin .gfx/CHR_banks/42_.CHR ; HUD 
incbin .gfx/CHR_banks/43_.CHR ; candles, pork, heart.. 
incbin .gfx/CHR_banks/44_.CHR ;	44 cross 
incbin .gfx/CHR_banks/45_.CHR ; 45
incbin .gfx/CHR_banks/46_.CHR ; 46 churge window
incbin .gfx/CHR_banks/47_.CHR ; 47
                                
chr 9                           
base $0000                      
incbin .gfx/CHR_banks/48_.CHR ; 48 houses
incbin .gfx/CHR_banks/49_.CHR ; 49 clock tower
incbin .gfx/CHR_banks/4a_.CHR ; 4A clock tower big gear
incbin .gfx/CHR_banks/4b_.CHR ; 4B woods 
incbin .gfx/CHR_banks/4c_.CHR ; 4C sympha 
incbin .gfx/CHR_banks/4d_.CHR ; 4D crusher
incbin .gfx/CHR_banks/4e_.CHR ; 4E ship and coffine
incbin .gfx/CHR_banks/4f_.CHR ; 4F swamp
                                
chr 10                          
base $0000                      
incbin .gfx/CHR_banks/50_.CHR ; 50 ship window pillars 
incbin .gfx/CHR_banks/51_.CHR ; 51 coffine open
incbin .gfx/CHR_banks/52_.CHR ; 52 statue 
incbin .gfx/CHR_banks/53_.CHR ; 53 outer wall 
incbin .gfx/CHR_banks/54_.CHR ; 54 water gear animation 00
incbin .gfx/CHR_banks/55_.CHR ; 55 water gear animation 00
incbin .gfx/CHR_banks/56_.CHR ; 56 water gear animation 00
incbin .gfx/CHR_banks/57_.CHR ; 57 sewers
                                
chr 11                          
base $0000                      
incbin .gfx/CHR_banks/58_.CHR ; 58 swamp mountains
incbin .gfx/CHR_banks/59_.CHR ; 59 swamp robes
incbin .gfx/CHR_banks/5a_.CHR ; 5A swamp floor with sprite mud man 
incbin .gfx/CHR_banks/5b_.CHR ; 5B cave
incbin .gfx/CHR_banks/5c_.CHR ; 5C alucard 
incbin .gfx/CHR_banks/5d_.CHR ; 5D crypt
incbin .gfx/CHR_banks/5e_.CHR ; 5E aquaduct
incbin .gfx/CHR_banks/5f_.CHR ; 5F aquabridge
                                
chr 12                          
base $0000                      
incbin .gfx/CHR_banks/60_.CHR ; 60 aqua pillar 
incbin .gfx/CHR_banks/61_.CHR ; 61 crypt frank 
incbin .gfx/CHR_banks/62_.CHR ; 62 crypt slulls
incbin .gfx/CHR_banks/63_.CHR ; 63 crypt tower 
incbin .gfx/CHR_banks/64_.CHR ; 64 red tower spikes 
incbin .gfx/CHR_banks/65_.CHR ; 65 sunset bridge 
incbin .gfx/CHR_banks/66_.CHR ; 66 castle exterior
incbin .gfx/CHR_banks/67_.CHR ; 67 cave spider web

chr 13
base $0000
incbin .gfx/CHR_banks/68_.CHR ; 68 lake mountains 
incbin .gfx/CHR_banks/69_.CHR ; 69 torture wall 
incbin .gfx/CHR_banks/6a_.CHR ; 6A big moon 
incbin .gfx/CHR_banks/6b_.CHR ; 6B finall 
incbin .gfx/CHR_banks/6c_.CHR ; 6C armore
incbin .gfx/CHR_banks/6d_.CHR ; 6D castlevania
incbin .gfx/CHR_banks/6e_.CHR ; 6E konami 
incbin .gfx/CHR_banks/6f_.CHR ; 6F ABC abc 

chr 14
base $0000
incbin .gfx/CHR_banks/70_.CHR ; title screen 
incbin .gfx/CHR_banks/71_.CHR 
incbin .gfx/CHR_banks/72_.CHR 
incbin .gfx/CHR_banks/73_.CHR ; name screen 
incbin .gfx/CHR_banks/74_.CHR ; map exterior
incbin .gfx/CHR_banks/75_.CHR ; map exterior
incbin .gfx/CHR_banks/76_.CHR ; map exterior
incbin .gfx/CHR_banks/77_.CHR ; map exterior

chr 15
base $0000
incbin .gfx/CHR_banks/78_.CHR ; map interior
incbin .gfx/CHR_banks/79_.CHR ; map interior
incbin .gfx/CHR_banks/7a_.CHR ; map interior
incbin .gfx/CHR_banks/7b_.CHR ; map interior
incbin .gfx/CHR_banks/7c_.CHR ; bolts and thunder
incbin .gfx/CHR_banks/7d_.CHR ; cross road aqua 
incbin .gfx/CHR_banks/7e_.CHR ; cross road clock 
incbin .gfx/CHR_banks/7f_.CHR ; ghost ship map sprites 

endif 

listFile {listFilename}
outputFile {outputFilename}
