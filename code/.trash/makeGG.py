from SpiderDaveAsm import sdasm

filename = 'music.nes'

sdasm.assemble('code/ggsound_asm6/mainSound.asm', filename+'_output.nes', binFile = filename)

