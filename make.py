from SpiderDaveAsm import sdasm

filename = 'Castlevania_3.nes'

sdasm.assemble('main.asm', filename+'_output.nes', binFile = filename)

