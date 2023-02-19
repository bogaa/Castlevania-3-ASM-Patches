# Castlevania-3-ASM-Patches

Put following ROM in this directory and rename it to "Castlevania_3.nes"

		Castlevania_3.nes
		Load a ROM
		Database match: Castlevania III - Dracula's Curse (USA)
		Database: No-Intro: Nintendo Entertainment System (v. 20210216-231042)
		File SHA-1: F91281D5D9CC26BCF6FB4DE2F5BE086BC633D49B
		File CRC32: 7CC9C669
		ROM SHA-1: 23C4DAFCC17FA75E8D682931702277659CD59735
		ROM CRC32: ED2465BE

Credits:
	- SpiderDave for SpiderDaveASM: https://github.com/SpiderDave/SpiderDaveAsm
	- SpiderDave for ItemDrop Patch: https://spiderdave.me (among many other things)
	- Konami for Castlevania 3, North America in 1990



Cheat Notes:


About Cheats and Levelselect:
	- To use levelSelect press select while pause. In debugg the screen select stage/helper use A,B and select to choose. Then pause again to lunch new stage.
	- MultiShot Press B while holding select (this works only well with fast swap. Else you have to wait till swap is done)
	- Subweapon press A while holding select (this works only well with fast swap. Else you have to wait till swap is done)
	
About Expansion:
	- This is purpesfully made so you can disable all expansion and work with the base ROM. Most patches will make use of the expansion and will not work otherwise.
	- Setting the expansion in the main.asm will overwrite. Both CHR and PRG are overwriten blank!
