"""
ToDo/Issues:
    * changing output on first pass affects second pass
        for example, using inesprg
    * diff can give wrong addresses depending on bank
    * create large test .asm
    * text mapping
        - named textmaps, alternate formats
    * option to automatically localize labels in macros
    * namespaces
        - namespace directive
        - use namespaces when defining/specifying labels or symbols
    * segment and related directives
    * line numbers in errors
    * handle negative numbers differently?
    * implement Asar's stddefines.txt
    * handle relative unlabeled jumps
        ex: bcc $79
    * allow some awkward lack of spaces: "bne+"
        * DONE *, should add tests
    * handle expressions in macro arguments
    * make it so insert shows added bytes in list file
    * fix issue with using org in chr space as the first thing
"""

from array import array

import math, os, sys

# hacky fix for import getting confused
# with NESBuilder's include module
if 'include' in sys.modules:
    sys.path.append('/SpiderDaveAsm')

try:
    from . import include
except:
    import include
Cfg = include.Cfg
ips = include.ips
GG = include.GG
ld65cfg = include.ld65cfg
import time
from datetime import date, datetime

import re

import pathlib
import operator

from math import sqrt
import random

from textwrap import dedent
from collections import deque

import traceback

try:
    from PIL import Image, ImageOps
    PIL = True
except Exception as e:
    PIL = False
    print('***', str(e))

try: import numpy as np
except: np = False

# for detecting pyinstaller
frozen = (getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'))
initialFolder = os.getcwd()

if np:
    usenp = True
# need better code for slicing with numpy.
# just disable for now.
usenp = False

version = dict(
    stage = 'alpha',
    buildDate =  date.today().strftime('%Y.%m.%d'),
    author = 'SpiderDave',
    url = 'https://github.com/SpiderDave/SpiderDaveAsm',
)
version.update(version = 'v{} {}'.format(version.get('buildDate'), version.get('stage')))

defaultPalette = [
    [116, 116, 116], [36, 24, 140], [0, 0, 168], [68, 0, 156],[140, 0, 116],
    [168, 0, 16],[164, 0, 0],[124, 8, 0],[64, 44, 0],[0, 68, 0],[0, 80, 0],
    [0, 60, 20],[24, 60, 92],[0, 0, 0],[0, 0, 0],[0, 0, 0],[188, 188, 188],
    [0, 112, 236],[32, 56, 236],[128, 0, 240],[188, 0, 188],[228, 0, 88],
    [216, 40, 0],[200, 76, 12],[136, 112, 0],[0, 148, 0],[0, 168, 0],
    [0, 144, 56],[0, 128, 136],[0, 0, 0],[0, 0, 0],[0, 0, 0],[252, 252, 252],
    [60, 188, 252],[92, 148, 252],[204, 136, 252],[244, 120, 252],
    [252, 116, 180],[252, 116, 96],[252, 152, 56],[240, 188, 60],
    [128, 208, 16],[76, 220, 72],[88, 248, 152],[0, 232, 216],[120, 120, 120],
    [0, 0, 0],[0, 0, 0],[252, 252, 252],[168, 228, 252],[196, 212, 252],
    [212, 200, 252],[252, 196, 252],[252, 196, 216],[252, 188, 176],
    [252, 216, 168],[252, 228, 160],[224, 252, 160],[168, 240, 188],
    [176, 252, 204],[156, 252, 240],[196, 196, 196],[0, 0, 0],[0, 0, 0],
]

def replaceStringByIndex(text,startIndex=0,endIndex=0,replacement=''):
    l = list(text)
    l[startIndex:endIndex]=replacement
    return''.join(l)

def makeSurePathExists(path):
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)

def elapsed(start, end=False):
    if not end:
        end = time.time()
    hours, rem = divmod(end-start, 3600)
    minutes, seconds = divmod(rem, 60)
    return "{:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds)


def findAll(haystack, needle):
    return [i for i in range(0, len(haystack)) if haystack[i:].startswith(needle)]

def getIndent(haystack, start=0):
    return start+(len(haystack[start:]) - len(haystack[start:].lstrip()))


def bestColorMatch(rgb, colors):
    r, g, b = rgb[:3]
    color_diffs = []
    for color in colors:
        cr, cg, cb = color
        color_diff = sqrt(abs(r - cr)**2 + abs(g - cg)**2 + abs(b - cb)**2)
        color_diffs.append((color_diff, color))
    return colors.index(min(color_diffs)[1])

def imageToCHRData(f, colors=False, xOffset=0,yOffset=0, rows=False, cols=False, nTiles=False, shatter = False):
    try:
        with Image.open(f) as im:
            px = im.convert('RGB').load()
            #px = im.load()
    except:
        print("error loading image")
        return
    
    width, height = im.size
    if rows!=False:
        height = rows*8
    if cols!=False:
        width = cols*8
    
    w = math.floor(width/8)*8
    h = math.floor(height/8)*8
    if nTiles==False:
        nTiles = int(w/8 * h/8)
    
    if shatter:
        altPalettes = dict(
            gray = [0x0f, 0x2d, 0x10, 0x30],
            steve = [0x0f, 0x0b, 0x2a, 0x37],
            steveAlt = [0x0f, 0x0b, [118,192,0], 0x37],
            hud = [0x0f, 0x15, 0x26, 0x37],
            brown = [0x0f, 0x17, 0x27, 0x37],
            yychr = [0x0f, [0x8c, 0x63, 0x21], [0xad, 0xb5, 0x31], [0xc6, 0xe7, 0x9c]],
        )
        for k, pal in altPalettes.items():
            altPalettes.update({k:[assembler.palette[x] if isinstance(x, int) else x for x in pal]})
        
    out = []
    for t in range(nTiles):
        tile = [[]]*16
        for y in range(8):
            tile[y] = 0
            tile[y+8] = 0
            for x in range(8):
                try:
                    c = list(px[xOffset + x, yOffset + y])
                except:
                    c = [0,0,0]
                
                i = False
                
                if shatter:
                    for k, pal in altPalettes.items():
                        if c[:3] in pal:
                            i = pal.index(c[:3])
                            break
                
                if i == False:
                    i = bestColorMatch(c, colors)
                
                tile[y] += (2**(7-x)) * (i%2)
                tile[y+8] += (2**(7-x)) * (math.floor(i/2))
        xOffset += 8
        if xOffset >=w:
            xOffset = 0
            yOffset += 8
        for i in range(16):
            out.append(tile[i])
    ret = out
    
    return ret

def importTilemap(tilemap, filename="import.png", offsetX=0, offsetY=0, fileOffset = 0, fileData = False, palette = 'current'):
    maxX, maxY = 0, 0
    for tile in tilemap.data:
        maxX = max(maxX, offsetX + tile.x * tilemap.gridsize + 8)
        maxY = max(maxY, offsetY + tile.y * tilemap.gridsize + 8)
    
    # Load image
    try:
        with Image.open(filename) as img:
            px = img.convert('RGB').load()
    except:
        print("error loading image")
        return
    
    width, height = img.size
    
    for tile in tilemap.data:
        colors = [assembler.palette[x] for x in tile.get('palette', assembler.currentPalette)]
        
        tileOut = [[]]*16
        for y in range(8):
            tileOut[y] = 0
            tileOut[y+8] = 0
            for x in range(8):
                if 'h' in tile.flip:
                    x1 = offsetX + tile.x * tilemap.gridsize + (7-x)
                else:
                    x1 = offsetX + tile.x * tilemap.gridsize + x
                if 'v' in tile.flip:
                    y1 = offsetY + tile.y * tilemap.gridsize + (7-y)
                else:
                    y1 = offsetY + tile.y * tilemap.gridsize + y

                try:
                    c = list(px[x1, y1])
                except:
                    c = [0,0,0]
                i = bestColorMatch(c, colors)
                
                tileOut[y] += (2**(7-x)) * (i%2)
                tileOut[y+8] += (2**(7-x)) * (math.floor(i/2))
        
        for i in range(16):
            fileData[fileOffset+tile.id*16+i] = tileOut[i]

def exportTilemapToImage(tilemap, filename="export.png", offsetX=0, offsetY=0, fileOffset = 0, fileData = False, palette = 'current'):
    maxX, maxY = 0, 0
    for tile in tilemap.data:
        maxX = max(maxX, offsetX + tile.x * tilemap.gridsize + 8)
        maxY = max(maxY, offsetY + tile.y * tilemap.gridsize + 8)
    
    # Load or create image
    try:
        with Image.open(filename) as img:
            img.load()
    except:
        img=Image.new("RGB", size=(8,8))
    
    if (img.width < maxX) or (img.height < maxY):
        imgNew = Image.new("RGB", size=(max(img.width, maxX), max(img.height, maxY)))
        imgNew.paste(img)
        img = imgNew
    
    img.load()
    a = np.asarray(img).copy()
    
    for tile in tilemap.data:
        colors = tile.get('palette', assembler.currentPalette)
        
        for y in range(8):
            for x in range(8):
                c=0
                if 'h' in tile.flip:
                    x1 = offsetX + tile.x * tilemap.gridsize + x
                else:
                    x1 = offsetX + tile.x * tilemap.gridsize + (7-x)
                if 'v' in tile.flip:
                    y1 = offsetY + tile.y * tilemap.gridsize + (7-y)
                else:
                    y1 = offsetY + tile.y * tilemap.gridsize + y
                if (fileData[fileOffset+tile.id*16+y] & (1<<x)):
                    c=c+1
                if (fileData[fileOffset+tile.id*16+y+8] & (1<<x)):
                    c=c+2
                a[y1][x1] = assembler.palette[colors[c]]
    
    img = Image.fromarray(a)
    img.save(filename)
    
    
def exportCHRDataToImage(filename="export.png", fileData=False, colors=(0x0f,0x21,0x11,0x01)):
    colors=assembler.currentPalette
    
    if not fileData:
        print('no filedata')
        fileData = "\x00" * 0x1000
    
    if type(fileData) is str:
        fileData = [ord(x) for x in fileData]
    
    nTiles = int(len(fileData) / 16)
    
    # Load or create image
    try:
        with Image.open(filename) as img:
            img.load()
    except:
        img=Image.new("RGB", size=(128,128))
    
    img.load()
    
    a = np.asarray(img).copy()
    
    for tile in range(nTiles):
        for y in range(8):
            for x in range(8):
                c=0
                x1=tile%16*8+(7-x)
                y1=math.floor(tile/16)*8+y
                if (fileData[tile*16+y] & (1<<x)):
                    c=c+1
                if (fileData[tile*16+y+8] & (1<<x)):
                    c=c+2
                a[y1][x1] = assembler.palette[colors[c]]
    
    img = Image.fromarray(a)
    img.save(filename)

def makeList(item):
    if type(item)!=list:
        return flattenList([item])
    else:
        return flattenList(item)

def flattenList(k):
    result = list()
    for i in k:
        #if '__iter__' in dir(i): # Should be better, but want to test
        if isinstance(i,list):
            result.extend(flattenList(i))
        else:
            result.append(i)
    return result

def inScriptFolder(f):
    return os.path.join(os.path.dirname(os.path.realpath(__file__)),f)

class Stack(deque):
    def push(self, *args):
        for arg in args:
            self.append(arg)
    def pop(self, n=0):
        if n > 0:
            ret = []
            for i in range(n):
                ret.append(super().pop())
            return tuple(ret)
        else:
            return super().pop()
    def remove(self,value):
        try:
            super().remove(value)
            return True
        except:
            return False
    def asList(self):
        return list(self)

class Map(dict):
    """
    Example:
    m = Map({'first_name': 'Eduardo'}, last_name='Pool', age=24, sports=['Soccer'])
    """
    def __init__(self, *args, **kwargs):
        super(Map, self).__init__(*args, **kwargs)
        for arg in args:
            if isinstance(arg, dict):
                for k, v in arg.items():
                    self[k] = v

        if kwargs:
            for k, v in kwargs.items():
                self[k] = v

    def __getattr__(self, attr):
        return self.get(attr)

    def __setattr__(self, key, value):
        self.__setitem__(key, value)

    def __setitem__(self, key, value):
        super(Map, self).__setitem__(key, value)
        self.__dict__.update({key: value})

    def __delattr__(self, item):
        self.__delitem__(item)

    def __delitem__(self, key):
        super(Map, self).__delitem__(key)
        del self.__dict__[key]

class Assembler():
    cfg = False
    currentFolder = None
    currentFilename = None
    initialFolder = None
    initialFilename = None
    hideOutputLine = False
    suppressError = False
    currentTextMap = 'default'
    textMap = {}
    errorLinePos = False
    expected = False
    expectedWait = False
    warnings = 0
    palette = defaultPalette[:]
    currentPalette = [0x0f,0x01,0x11,0x30]
    stripHeader = False
    namespace = Stack([''])
    #quotes = ('"""','"',"'")
    quotes = False
    hidePrefix = '__hide__'
    caseSensitive = False
    Sprite8x16 = False
    echoLine = False
    localPrefix = []
    lastLabel = ''
    localLabels = Map()
    localLabelKeys = {}
    line = ''
    lineNumber = 0
    fileLineNumber = 0
    error = False               # used to determine if exit code 3 is needed
    errorText = ''
    memcfg = False
    insert = False
    gg = False
    outputFilename = False
    printFilename = False
    listFilename = False
    bankData = {}
    commentBlock = 0
    shatter = False
    pcStack = False
    baseStack = False
    
    nesRegisters = Map(
        PPUCTRL = 0x2000, PPUMASK = 0x2001, PPUSTATUS = 0x2002,
        OAMADDR = 0x2003, OAMDATA = 0x2004, PPUSCROLL = 0x2005,
        PPUADDR = 0x2006, PPUDATA = 0x2007, OAMDMA = 0x4014,
        SQ1VOL = 0x4000, SQ1SWEEP = 0x4001, SQ1LO = 0x4002,
        SQ1HI = 0x4003, 
        SQ2VOL = 0x4004, SQ2SWEEP = 0x4005, SQ2LO = 0x4006,
        SQ2HI = 0x4007,
        TRILINEAR = 0x4008, TRILO = 0x400A, TRIHI = 0x400B,
        NOISEVOL = 0x400C, NOISELO = 0x400E, NOISEHI = 0x400F,
        DMCFREQ = 0x4010, DMCRAW = 0x4011, DMCSTART = 0x4012,
        DMCLEN = 0x4013,
        APUSTATUS = 0x4015, APUFRAME = 0x4017,
        JOY = 0x4016, JOY1 = 0x4016, JOY2 = 0x4017,
    )
    nesRegisters = Map({x.lower():y for x,y in nesRegisters.items()})

    def get(self, prop):
        return getattr(self, prop)

    def __init__(self):
        pass
    def dummy(self):
        pass
    def printError(self, errorText = '', line = ''):
        if not errorText:
            errorText = self.errorText
        print(line)
        if self.errorLinePos:
            print(' '*self.errorLinePos+'^')
        print('*** {}'.format(errorText))
        print('    {}\n'.format(self.currentFilename))
        self.errorLinePos = False
    def lower(self, txt):
        if self.caseSensitive:
            return txt
        return txt.lower()
    def isString(self, text):
        for q in self.quotes:
            if text.startswith(q) and text.endswith(q):
                return True
    def stripQuotes(self, text):
        for q in self.quotes:
            if text.startswith(q) and text.endswith(q):
                return text[len(q):-len(q)]
        return text
    def stripComments(self, text=''):
        # inside a comment block, so just check for block close indicators
        if self.commentBlock:
            pos = -1
            for c in self.commentBlockClose:
                if c in text:
                    if pos == -1:
                        pos = text.find(c) + len(c)
                    else:
                        pos = min(pos, text.find(c) + len(c))
            if pos == -1:
                # inside a block comment so return empty string
                return ""
            else:
                self.commentBlock -= 1
                return self.stripComments(text[pos:].strip())
        
        commentSep = self.commentSep + self.commentBlockOpen
        
        # check for any quotes or comments to handle
        # if none found, we're done; return text
        if not any(q in text for q in self.quotes):
            if not any(sep in text for sep in commentSep):
                return text
        
        qIndex = -1
        q = ''
        for quote in self.quotes:
            i = text.find(quote)
            if i != -1:
                # conditions are:
                # 1. first quote found
                # 2. quote found at lesser position in string
                # 3. quote found at same position in string (handles " vs """ etc)
                if (qIndex == -1) or (i < qIndex) or ((i == qIndex) and len(quote) > len(q)):
                    qIndex = i
                    q = quote
        
        # check if comment comes before first string
        cIndex = len(text)
        cType = False
        for sep in commentSep:
            i = text.find(sep)
            if i !=-1:
                if (qIndex == -1) and (i < cIndex):
                    # no quotes found, just mark comment start
                    cType = sep
                    cIndex = i
                elif (i < qIndex) and (i < cIndex):
                    # comments found before quotes, mark start
                    cType = sep
                    cIndex = i
        
        # no need for more tokenization; trim and exit
        if cIndex < len(text):
            text = text[:cIndex]
            if cType in self.commentBlockOpen:
                self.commentBlock += 1
                print('comment block open')
            return text
        
        # find end of string
        i = text.find(q, qIndex + len(q))
        if i != -1:
            i = i + len(q)
            text = text[:i] + self.stripComments(text[i:])
            
        return text
    def tokenize(self, text='', tokens=[], splitter=','):
        tokens = tokens or [text]
        txt = tokens[-1]
        
        if not any(q in txt for q in self.quotes):
            if not any(q in txt for q in "[]"):
                return tokens[:-1] + [x.strip() for x in txt.split(splitter)]
        
        q = False
        for quote in self.quotes:
            if txt.startswith(quote):
                q = quote
                break
        
        if txt.startswith('['):
            q = ']'
        
        n1=0
        if q:
            n1 = txt.find(q,len(q))+len(q)
        n2 = txt.find(splitter,n1)
        
        if n2==-1:
            return tokens
        
        left = txt[:n2].strip()
        right = txt[n2+1:].strip()
        
        tokens = tokens[:-1] + [left, right]
        return self.tokenize(text, tokens)
    def mapText(self, text):
        #print("Mapping text:", text)
        textMap = self.textMap.get(self.currentTextMap, {})
        
#        try:
#            ret = [textMap.get(x, ord(x)) for x in text]
#        except:
#            print('bad textmap data')
#            ret = [0 for x in text]
#            return ret
        
        ret = [textMap.get(x, ord(x)) for x in text]
        return ret
    def setTextMap(self, name):
        self.currentTextMap = name
    def getTextMap(self):
        return self.currentTextMap
    def clearTextMap(self, name=False, all=False):
        if all:
            self.currentTextMap = 'default'
            self.textMap = {}
        if not name:
            name = self.currentTextMap
        if name in self.textMap:
            self.textMap.pop(name)
    def setTextMapData(self, chars, mapTo):
        textMap = self.textMap.get(self.currentTextMap, {})
        textMap.update(dict(zip(chars,bytearray.fromhex(mapTo))))
        
        self.textMap[self.currentTextMap] = textMap
    def loadTbl(self, filename=False):
        filename = self.findFile(filename)
        if filename:
            try:
                file = open(filename, "rb")
            except:
                self.errorHint = 'could not open file.'
                return False
            
            tbl=['','']
            for line in file.read().decode('utf-8-sig').splitlines():
                l = line.split('=')
                
                if len(l[0])==1 and len(l[1])==2:
                    l = list(reversed(l))
                if len(l[0])==2 and len(l[1])==1:
                    tbl[1]+=l[0]
                    tbl[0]+=l[1]
                elif line == '':
                    pass
                else:
                    self.errorHint = 'Invalid tbl entry'
                    return False
            self.setTextMapData(tbl[0],tbl[1])
            
            return True
        else:
            self.errorHint = 'file not found'
            return False
    def loadPalette(self, filename=False):
        if filename:
            filename = self.findFile(filename)
            if filename:
                try:
                    file = open(filename, "rb")
                except:
                    self.errorHint = 'could not open file.'
                    return False
                p = list(file.read())
                if len(p) != 192:
                    self.errorHint = 'palette file size must be 192 bytes'
                    return False
                p = [p[i:i + 3] for i in range(0, len(p), 3)]
                self.palette = p
            else:
                self.errorHint = 'file not found'
                return False
        else:
            self.palette = defaultPalette[:]
        
        return self.palette
    def findFile(self, filename):
        if not filename:
            return False
        # Search for files in this order:
        #   Exact match
        #   Relative to current script folder
        #   Relative to initial script folder
        #   Relative to current working folder
        #   Relative to top level of initial script folder
        #   Relative to executable folder
        files = [
            filename,
            os.path.join(self.currentFolder,filename),
            os.path.join(self.initialFolder,filename),
            os.path.join(os.getcwd(),filename),
            os.path.join(str(pathlib.Path(*pathlib.Path(self.initialFolder).parts[:1])),filename),
            os.path.join(os.path.dirname(os.path.realpath(__file__)),filename),
        ]
        
        files = [x.replace('\\\\','\\') for x in files]
        
        for f in files:
            if os.path.isfile(f): return f
        
        return False

assembler = Assembler()

operations = {
#    '-':operator.sub,
#    '+':operator.add,
    '/':operator.truediv,
    '&':operator.and_,
    '^':operator.xor,
    '~':operator.invert,
    '|':operator.or_,
    '**':operator.pow,
    '<<':operator.lshift,
    '>>':operator.rshift,
    '%':operator.mod,
    '*':operator.mul,
}

directives = [
    'org','base','pad','fillto','align','fill','fillvalue','fillbyte','padbyte',
    'include','include?','incsrc','require','includeall','incbin','bin',
    'db','dw','byte','byt','word','hex','dc.b','dc.w',
    'dsb','dsw','ds.b','ds.w','dl','dh','res',
    'enum','ende','endenum',
    'print','warning','error','printtofile',
    'setincludefolder','setcurrentfile',
    'macro','endm','endmacro',
    'if','ifdef','ifndef','else','elseif','endif','iffileexist','iffile',
    'arch','table','loadtable','cleartable','mapdb','clampdb',
    'index','mem','bank','lastbank','banksize','chrsize','header','noheader','stripheader',
    'define', '_find','absorg',
    'seed','outputfile','listfile','textmap','text','insert','delete','truncate','printfile',
    'inesprg','ineschr','inesmir','inesmap','inesbattery','inesfourscreen',
    'inesworkram','inessaveram','ines2',
    'orgpad', 'padorg', 'quit','incchr','chr','setpalette','loadpalette',
    'rept','endr','endrept','sprite8x16','export','diff','diff2',
    'assemble', 'exportchr', 'ips','makeips', 'gg','echo','function','endf', 'endfunction',
    'return','namespace','break','expected',
    'findtext','lastpass', 'endoffunction', '_wipe',
    'loadld65cfg','loadld65cfg?','segment',
    'start','end','exportmap','importmap','_test','_shatterhand_import',
    'pushpc','pullpc','pushbase','pullbase',
]

filters = [
    'shuffle','getbyte','getbytes','getword','choose',
    'format','random','range','textmap',
    'evalvar','pop','astext','len',
    'fileexist', 'nfileexist','py',
    'concat','coalesce',
    'namespace',
]

def clamp(n, smallest, largest): return max(smallest, min(n, largest))

autoFilters = {
    'floor':math.floor,
    'ceil':math.ceil,
    'clamp':clamp,
}

filters = filters + list(autoFilters.keys())

asm=[
Map(opcode = 'adc', mode = 'Immediate', byte = 105, length = 2),
Map(opcode = 'adc', mode = 'Zero Page', byte = 101, length = 2),
Map(opcode = 'adc', mode = 'Zero Page, X', byte = 117, length = 2),
Map(opcode = 'adc', mode = 'Absolute', byte = 109, length = 3),
Map(opcode = 'adc', mode = 'Absolute, X', byte = 125, length = 3),
Map(opcode = 'adc', mode = 'Absolute, Y', byte = 121, length = 3),
Map(opcode = 'adc', mode = '(Indirect, X)', byte = 97, length = 2),
Map(opcode = 'adc', mode = '(Indirect), Y', byte = 113, length = 2),
Map(opcode = 'and', mode = 'Immediate', byte = 41, length = 2),
Map(opcode = 'and', mode = 'Zero Page', byte = 37, length = 2),
Map(opcode = 'and', mode = 'Zero Page, X', byte = 53, length = 2),
Map(opcode = 'and', mode = 'Absolute', byte = 45, length = 3),
Map(opcode = 'and', mode = 'Absolute, X', byte = 61, length = 3),
Map(opcode = 'and', mode = 'Absolute, Y', byte = 57, length = 3),
Map(opcode = 'and', mode = '(Indirect, X)', byte = 33, length = 2),
Map(opcode = 'and', mode = '(Indirect), Y', byte = 49, length = 2),
Map(opcode = 'asl', mode = 'Accumulator', byte = 10, length = 1),
Map(opcode = 'asl', mode = 'Zero Page', byte = 6, length = 2),
Map(opcode = 'asl', mode = 'Zero Page, X', byte = 22, length = 2),
Map(opcode = 'asl', mode = 'Absolute', byte = 14, length = 3),
Map(opcode = 'asl', mode = 'Absolute, X', byte = 30, length = 3),
Map(opcode = 'bcc', mode = 'Relative', byte = 144, length = 2),
Map(opcode = 'bcs', mode = 'Relative', byte = 176, length = 2),
Map(opcode = 'beq', mode = 'Relative', byte = 240, length = 2),
Map(opcode = 'bit', mode = 'Zero Page', byte = 36, length = 2),
Map(opcode = 'bit', mode = 'Absolute', byte = 44, length = 3),
Map(opcode = 'bmi', mode = 'Relative', byte = 48, length = 2),
Map(opcode = 'bne', mode = 'Relative', byte = 208, length = 2),
Map(opcode = 'bpl', mode = 'Relative', byte = 16, length = 2),
Map(opcode = 'brk', mode = 'Implied', byte = 0, length = 1),
Map(opcode = 'bvc', mode = 'Relative', byte = 80, length = 2),
Map(opcode = 'bvs', mode = 'Relative', byte = 112, length = 2),
Map(opcode = 'clc', mode = 'Implied', byte = 24, length = 1),
Map(opcode = 'cld', mode = 'Implied', byte = 216, length = 1),
Map(opcode = 'cli', mode = 'Implied', byte = 88, length = 1),
Map(opcode = 'clv', mode = 'Implied', byte = 184, length = 1),
Map(opcode = 'cmp', mode = 'Immediate', byte = 201, length = 2),
Map(opcode = 'cmp', mode = 'Zero Page', byte = 197, length = 2),
Map(opcode = 'cmp', mode = 'Zero Page, X', byte = 213, length = 2),
Map(opcode = 'cmp', mode = 'Absolute', byte = 205, length = 3),
Map(opcode = 'cmp', mode = 'Absolute, X', byte = 221, length = 3),
Map(opcode = 'cmp', mode = 'Absolute, Y', byte = 217, length = 3),
Map(opcode = 'cmp', mode = '(Indirect, X)', byte = 193, length = 2),
Map(opcode = 'cmp', mode = '(Indirect), Y', byte = 209, length = 2),
Map(opcode = 'cpx', mode = 'Immediate', byte = 224, length = 2),
Map(opcode = 'cpx', mode = 'Zero Page', byte = 228, length = 2),
Map(opcode = 'cpx', mode = 'Absolute', byte = 236, length = 3),
Map(opcode = 'cpy', mode = 'Immediate', byte = 192, length = 2),
Map(opcode = 'cpy', mode = 'Zero Page', byte = 196, length = 2),
Map(opcode = 'cpy', mode = 'Absolute', byte = 204, length = 3),
Map(opcode = 'dec', mode = 'Zero Page', byte = 198, length = 2),
Map(opcode = 'dec', mode = 'Zero Page, X', byte = 214, length = 2),
Map(opcode = 'dec', mode = 'Absolute', byte = 206, length = 3),
Map(opcode = 'dec', mode = 'Absolute, X', byte = 222, length = 3),
Map(opcode = 'dex', mode = 'Implied', byte = 202, length = 1),
Map(opcode = 'dey', mode = 'Implied', byte = 136, length = 1),
Map(opcode = 'eor', mode = 'Immediate', byte = 73, length = 2),
Map(opcode = 'eor', mode = 'Zero Page', byte = 69, length = 2),
Map(opcode = 'eor', mode = 'Zero Page, X', byte = 85, length = 2),
Map(opcode = 'eor', mode = 'Absolute', byte = 77, length = 3),
Map(opcode = 'eor', mode = 'Absolute, X', byte = 93, length = 3),
Map(opcode = 'eor', mode = 'Absolute, Y', byte = 89, length = 3),
Map(opcode = 'eor', mode = '(Indirect, X)', byte = 65, length = 2),
Map(opcode = 'eor', mode = '(Indirect), Y', byte = 81, length = 2),
Map(opcode = 'inc', mode = 'Zero Page', byte = 230, length = 2),
Map(opcode = 'inc', mode = 'Zero Page, X', byte = 246, length = 2),
Map(opcode = 'inc', mode = 'Absolute', byte = 238, length = 3),
Map(opcode = 'inc', mode = 'Absolute, X', byte = 254, length = 3),
Map(opcode = 'inx', mode = 'Implied', byte = 232, length = 1),
Map(opcode = 'iny', mode = 'Implied', byte = 200, length = 1),
Map(opcode = 'jmp', mode = 'Indirect', byte = 108, length = 3),
Map(opcode = 'jmp', mode = 'Absolute', byte = 76, length = 3),
Map(opcode = 'jsr', mode = 'Absolute', byte = 32, length = 3),
Map(opcode = 'lda', mode = 'Immediate', byte = 169, length = 2),
Map(opcode = 'lda', mode = 'Zero Page', byte = 165, length = 2),
Map(opcode = 'lda', mode = 'Zero Page, X', byte = 181, length = 2),
Map(opcode = 'lda', mode = 'Absolute', byte = 173, length = 3),
Map(opcode = 'lda', mode = 'Absolute, X', byte = 189, length = 3),
Map(opcode = 'lda', mode = 'Absolute, Y', byte = 185, length = 3),
Map(opcode = 'lda', mode = '(Indirect, X)', byte = 161, length = 2),
Map(opcode = 'lda', mode = '(Indirect), Y', byte = 177, length = 2),
Map(opcode = 'ldx', mode = 'Zero Page', byte = 166, length = 2),
Map(opcode = 'ldx', mode = 'Zero Page, Y', byte = 182, length = 2),
Map(opcode = 'ldx', mode = 'Absolute', byte = 174, length = 3),
Map(opcode = 'ldx', mode = 'Absolute, Y', byte = 190, length = 3),
Map(opcode = 'ldx', mode = 'Immediate', byte = 162, length = 2),
Map(opcode = 'ldy', mode = 'Immediate', byte = 160, length = 2),
Map(opcode = 'ldy', mode = 'Zero Page', byte = 164, length = 2),
Map(opcode = 'ldy', mode = 'Zero Page, X', byte = 180, length = 2),
Map(opcode = 'ldy', mode = 'Absolute', byte = 172, length = 3),
Map(opcode = 'ldy', mode = 'Absolute, X', byte = 188, length = 3),
Map(opcode = 'lsr', mode = 'Accumulator', byte = 74, length = 1),
Map(opcode = 'lsr', mode = 'Zero Page', byte = 70, length = 2),
Map(opcode = 'lsr', mode = 'Zero Page, X', byte = 86, length = 2),
Map(opcode = 'lsr', mode = 'Absolute', byte = 78, length = 3),
Map(opcode = 'lsr', mode = 'Absolute, X', byte = 94, length = 3),
Map(opcode = 'nop', mode = 'Implied', byte = 234, length = 1),
Map(opcode = 'ora', mode = 'Immediate', byte = 9, length = 2),
Map(opcode = 'ora', mode = 'Zero Page', byte = 5, length = 2),
Map(opcode = 'ora', mode = 'Zero Page, X', byte = 21, length = 2),
Map(opcode = 'ora', mode = 'Absolute', byte = 13, length = 3),
Map(opcode = 'ora', mode = 'Absolute, X', byte = 29, length = 3),
Map(opcode = 'ora', mode = 'Absolute, Y', byte = 25, length = 3),
Map(opcode = 'ora', mode = '(Indirect, X)', byte = 1, length = 2),
Map(opcode = 'ora', mode = '(Indirect), Y', byte = 17, length = 2),
Map(opcode = 'pha', mode = 'Implied', byte = 72, length = 1),
Map(opcode = 'php', mode = 'Implied', byte = 8, length = 1),
Map(opcode = 'pla', mode = 'Implied', byte = 104, length = 1),
Map(opcode = 'plp', mode = 'Implied', byte = 40, length = 1),
Map(opcode = 'rol', mode = 'Accumulator', byte = 42, length = 1),
Map(opcode = 'rol', mode = 'Zero Page', byte = 38, length = 2),
Map(opcode = 'rol', mode = 'Zero Page, X', byte = 54, length = 2),
Map(opcode = 'rol', mode = 'Absolute', byte = 46, length = 3),
Map(opcode = 'rol', mode = 'Absolute, X', byte = 62, length = 3),
Map(opcode = 'ror', mode = 'Accumulator', byte = 106, length = 1),
Map(opcode = 'ror', mode = 'Zero Page', byte = 102, length = 2),
Map(opcode = 'ror', mode = 'Zero Page, X', byte = 118, length = 2),
Map(opcode = 'ror', mode = 'Absolute', byte = 110, length = 3),
Map(opcode = 'ror', mode = 'Absolute, X', byte = 126, length = 3),
Map(opcode = 'rti', mode = 'Implied', byte = 64, length = 1),
Map(opcode = 'rts', mode = 'Implied', byte = 96, length = 1),
Map(opcode = 'sbc', mode = 'Immediate', byte = 233, length = 2),
Map(opcode = 'sbc', mode = 'Zero Page', byte = 229, length = 2),
Map(opcode = 'sbc', mode = 'Zero Page, X', byte = 245, length = 2),
Map(opcode = 'sbc', mode = 'Absolute', byte = 237, length = 3),
Map(opcode = 'sbc', mode = 'Absolute, X', byte = 253, length = 3),
Map(opcode = 'sbc', mode = 'Absolute, Y', byte = 249, length = 3),
Map(opcode = 'sbc', mode = '(Indirect, X)', byte = 225, length = 2),
Map(opcode = 'sbc', mode = '(Indirect), Y', byte = 241, length = 2),
Map(opcode = 'sec', mode = 'Implied', byte = 56, length = 1),
Map(opcode = 'sed', mode = 'Implied', byte = 248, length = 1),
Map(opcode = 'sei', mode = 'Implied', byte = 120, length = 1),
Map(opcode = 'sta', mode = 'Zero Page', byte = 133, length = 2),
Map(opcode = 'sta', mode = 'Zero Page, X', byte = 149, length = 2),
Map(opcode = 'sta', mode = 'Absolute', byte = 141, length = 3),
Map(opcode = 'sta', mode = 'Absolute, X', byte = 157, length = 3),
Map(opcode = 'sta', mode = 'Absolute, Y', byte = 153, length = 3),
Map(opcode = 'sta', mode = '(Indirect, X)', byte = 129, length = 2),
Map(opcode = 'sta', mode = '(Indirect), Y', byte = 145, length = 2),
Map(opcode = 'stx', mode = 'Zero Page', byte = 134, length = 2),
Map(opcode = 'stx', mode = 'Zero Page, Y', byte = 150, length = 2),
Map(opcode = 'stx', mode = 'Absolute', byte = 142, length = 3),
Map(opcode = 'sty', mode = 'Zero Page', byte = 132, length = 2),
Map(opcode = 'sty', mode = 'Zero Page, X', byte = 148, length = 2),
Map(opcode = 'sty', mode = 'Absolute', byte = 140, length = 3),
Map(opcode = 'tax', mode = 'Implied', byte = 170, length = 1),
Map(opcode = 'tay', mode = 'Implied', byte = 168, length = 1),
Map(opcode = 'tsx', mode = 'Implied', byte = 186, length = 1),
Map(opcode = 'txa', mode = 'Implied', byte = 138, length = 1),
Map(opcode = 'txs', mode = 'Implied', byte = 154, length = 1),
Map(opcode = 'tya', mode = 'Implied', byte = 152, length = 1),
]

architectures = ['nes.cpu','6502']

# Converting to dictionary removes duplicates
opcodes = list(dict.fromkeys([x.opcode for x in asm]))

opcodes2 = [
    'lda','ldx','ldy',
    'sta','stx','sty',
    'and','asl','bit','eor','lsr','ora','rol','ror',
    'adc','dec','dex','dey','inc','inx','iny','sbc',
    'cmp','cpx','cpy',
    'jmp',
]
opcodes2 = [x+'.b' for x in opcodes2]+[x+'.w' for x in opcodes2]


implied = [x.opcode for x in asm if x.mode=='Implied']
accumulator = [x.opcode for x in asm if x.mode=="Accumulator"]
ifDirectives = ['if','endif','else','elseif','ifdef','ifndef','iffileexist','iffile']

mergeList = lambda a,b: [(a[i], b[i]) for i in range(min(len(a),len(b)))]
makeHex = lambda x: '$'+x.to_bytes(((x.bit_length()|1  + 7) // 8),"big").hex()

superglobals = [
    'return'
]

specialSymbols = [
    'sdasm','bank','banksize','chrsize','randbyte','randword','fileoffset','filesize',
    'prgbanks','chrbanks','lastbank','lastchr','mapper','binfile','namespace',
    'vectornmi','vectorreset','vectorirq','warnings',
]

timeSymbols = ['year','month','day','hour','minute','second']

specialSymbols+= timeSymbols
specialSymbols+= [x.lower() for x in assembler.nesRegisters.keys()]

def assemble(filename, outputFilename = 'output.bin', listFilename = False, configFile=False, fileData=False, binFile=False, symbolsFile=False, quiet=False, defineSymbol=''):
    assembler.error = False
    #quiet=True
    
    if not configFile:
        if frozen:
            configFile = 'sdasm.ini'
        else:
            configFile = inScriptFolder('config.ini')
    
    cfg = False
    # create our config parser
    cfg = Cfg(configFile)

    # read config file if it exists
    cfg.load()
    
    # number of bytes to show when generating list
    cfg.setDefault('main', 'list_nBytes', 8)
    cfg.setDefault('main', 'metaCommandPrefix', ';!,//!,;//!')
    cfg.setDefault('main', 'comment', ';,//')
    cfg.setDefault('main', 'commentBlockOpen', '/*')
    cfg.setDefault('main', 'commentBlockClose', '*/')
    cfg.setDefault('main', 'nestedComments', True)
    cfg.setDefault('main', 'fillValue', '$00')
    cfg.setDefault('main', 'localPrefix', '@')
    cfg.setDefault('main', 'debug', False)
    cfg.setDefault('main', 'varOpen', '{')
    cfg.setDefault('main', 'varClose', '}')
    cfg.setDefault('main', 'labelSuffix', ':')
    cfg.setDefault('main', 'namespaceSymbol', '.')
    cfg.setDefault('main', 'orgPad', 0)
    cfg.setDefault('main', 'padOrg', 0)
    cfg.setDefault('main', 'mapdb', False)
    cfg.setDefault('main', 'lineSep', '')
    cfg.setDefault('main', 'clampdb', False)
    cfg.setDefault('main', 'caseSensitive', False)
    cfg.setDefault('main', 'lineContinue', '\\')
    cfg.setDefault('main', 'lineContinueComma', True)
    cfg.setDefault('main', 'quotes', '\',","""')
    cfg.setDefault('main', 'suppressErrorPrefix', '-E-,-e-')
    cfg.setDefault('main', 'floorDiv', True)
    cfg.setDefault('main', 'xkasplusbranch', False)
    cfg.setDefault('main', 'showFileOffsetInListFile', True)
    cfg.setDefault('main', 'showBankInListFile', False)
    cfg.setDefault('main', 'fullTraceback', False)
    cfg.setDefault('main', 'loadld65cfg', True)
    cfg.setDefault('main', 'rememberBankAddress', False)
    cfg.setDefault('main', 'oldPrint', False)
    
    assembler.quotes = tuple(makeList(cfg.getValue('main', 'quotes')))

    # save configuration so our defaults can be changed
    cfg.save()
    
    assembler.cfg = cfg

    startTime = time.time()
    
    try:
        ret = _assemble(filename, outputFilename, listFilename, cfg=cfg, fileData=fileData, binFile=binFile, symbolsFile=symbolsFile, quiet=quiet, defineSymbol=defineSymbol)
        
        if type(ret) is tuple:
            success, errorText = ret
            
            errorText = dedent("""
            {dashes}
            {}
            {dashes}
            """).format(errorText, dashes='-'*50)
            
            
            if not success:
                return False, errorText
    except Exception as e:
        tb = traceback.extract_tb(e.__traceback__)[-1]
        
        assembler.error = True
        assembler.errorText = dedent("""
        {dashes}
        
        Error: {}
            
            {}:{}
                {}
            
            {}:{} in {}
                {}
        
        {dashes}
        """).format(
            e,
            assembler.currentFilename, assembler.fileLineNumber,
            assembler.line,
            tb.filename, tb.lineno, tb.name,
            tb.line,
            dashes = '-'*50,
        )
        
        if assembler.cfg.isTrue(assembler.cfg.getValue('main', 'fullTraceback')):
            raise e
    
    
    endTime = time.time()-startTime
    if endTime >= 3:
        elapsed = time.strftime(' %H hours, %M minutes, %S seconds.',time.gmtime(endTime))
        elapsed = elapsed.replace(' 00 ',' 0 ')
        elapsed = elapsed.replace(' 0 hours,','')
        elapsed = elapsed.replace(' 0 minutes,','')
        elapsed = elapsed.strip()
        print(time.strftime('Finished in {}'.format(elapsed)))
    
    return not assembler.error, assembler.errorText

def _assemble(filename, outputFilename, listFilename, cfg, fileData, binFile, symbolsFile, quiet, defineSymbol):
    
    if not defineSymbol:
        defineSymbol = ''
    defineSymbol = defineSymbol.replace(',',' ').split()
    
    def createHeader():
        header = (list(out[:16]) + [0] * 16)[:16]
        header[0:4] = list(bytearray("NES", 'utf8')) + [0x1a]
        if header[4] == 0:
            # Don't let it have zero prg
            header[4] = 1
        out[0:16] = header
    
    def bytesForNumber(n):
        if type(n) is float:
            l = len(hex(math.floor(n)))-1 >>1
        elif type(n) is int:
            l = len(hex(n))-1 >>1
        elif type(n) is str:
            l = len(n)
        elif type(n) is list:
            l = len(n)
        
        return l
    def getAsFilename(filename):
        print(filename)
        filename = getValueAsString(filename.strip(), fallback=True)
        print(filename)
        if assembler.errorHint:
            errorText = assembler.errorHint
            assembler.errorLinePos = len(originalLine.rstrip())-1
        
        filename = assembler.findFile(filename)
        if not filename:
            errorText = 'file not found'
        return filename
    def getValueAsString(s, fallback=False):
        ret = False
        try:
            ret = getString(getValue(s))
        except:
            pass
            
        if ret:
            return ret
        else:
            if fallback:
                assembler.errorHint = False
                return  getString(s)
            return False
    def getString(s, strip=True):
        if type(s) is int:
            return False
        
        if type(s) is list:
            s = bytes(s).decode()
        
        if strip:
            s=s.strip()
        
        for q in assembler.quotes:
            if s.strip().startswith(q) and s.strip().endswith(q):
                s=s.strip()
                s=s[len(q):-len(q)]
                return s
            elif s.strip().startswith(q):
                s=s.strip()
                s=s[len(q):]
                for q2 in assembler.quotes:
                    if s.strip().endswith(q2):
                        s=s[:-len(q2)]
                        assembler.errorHint = "quote missmatch"
                        return s
                
                assembler.errorHint = f"missing closing quote ({q})"
                return s
        return s
    def getSymbolInfo(symbol, ns = False):
        symbol = symbol.strip()
        symbol = assembler.lower(symbol)
        
        if ns == False:
            ns = assembler.namespace[-1]
        ret = Map()
        ret.namespace = ns
        
        if ns != '':
            ns = ns + namespaceSymbol
        
#        if ns and symbol.startswith(ns):
#            symbol = symbol.split(ns)[1]
#        if namespaceSymbol in symbol:
#            symbol = symbol.split(namespaceSymbol,1)[1]
        
        #ret.update(key = assembler.lower(ns + symbol))
        ret.update(key = nsSymbol(symbol))
        ret.update(baseKey = assembler.lower(symbol))
        
        if symbol in assembler.localLabelKeys:
            label = assembler.localLabels.get(assembler.lastLabel, Map()).get(ret.key, False)
            if label:
                ret.update(value = label.get('value'))
                return ret
        
        if symbol in symbols:
            ret.update(value = symbols.get(ret.get('key')))
            return ret
        else:
            return
    def nsSymbol(s):
        if s.startswith(namespaceSymbol):
            n = 0
            while s.startswith(namespaceSymbol):
                s = s[1:]
                n -= 1
            try:
                ns = assembler.namespace[n]
            except:
                ns = assembler.namespace[-1]
        else:
            if namespaceSymbol in s:
                return assembler.lower(s)
            
            ns = assembler.namespace[-1]
        
        if ns == '':
            return assembler.lower(s)
        
        return assembler.lower(ns + namespaceSymbol + s)
    def getSpecial(s):
        if s == 'sdasm':
            v = 1
        elif s == 'bank':
            if bank == None:
                return ''
            else:
                return makeHex(bank)
        elif s == 'banksize':
            if bank == None:
                return ''
            else:
                return str(bankSize)
        elif s == 'chrsize':
            return str(chrSize)
        elif s == 'prgbanks':
            if passNum != lastPass:
                return str(0)
            return str(out[4])
        elif s == 'lastbank':
            return str(out[4]-1)
        elif s == 'chrbanks':
            return str(out[5])
        elif s == 'lastchr':
            return str(out[5]-1)
        elif s == 'mapper':
            return str((out[7] & 0xf0) + (out[6]>>4))
        elif s == 'warnings':
            return str(assembler.warnings)
        elif s == 'filesize':
            return str(len(out))
        elif s == 'fileoffset':
            if bank != None:
                #return str(addr + bank * bankSize + headerSize)
                return str(addr + headerSize)
            else:
                #return str(addr + headerSize)
                return str(addr)
        elif s == 'randbyte':
            return makeHex(random.randrange(0x100))
        elif s == 'namespace':
            return assembler.namespace[-1]
        elif s == 'randword':
            return '${:04x}'.format(random.randrange(0x10000))
        elif s == 'reptindex':
            return str(symbols.get('reptindex', 0))
        elif s == 'binFile':
            return binFile or 0
        elif s == 'vectorreset':
            fileOffset = 0xfffa - 0x8000 - (currentAddress-startAddress) + bank * bankSize + headerSize
            return '${:02x}{:02x}'.format(out[fileOffset+1], out[fileOffset])
        elif s == 'vectornmi':
            fileOffset = 0xfffc - 0x8000 - (currentAddress-startAddress) + bank * bankSize + headerSize
            return '${:02x}{:02x}'.format(out[fileOffset+1], out[fileOffset])
        elif s == 'vectorirq':
            fileOffset = 0xfffe - 0x8000 - (currentAddress-startAddress) + bank * bankSize + headerSize
            return '${:02x}{:02x}'.format(out[fileOffset+1], out[fileOffset])
        elif s in timeSymbols:
            return str(list(datetime.now().timetuple())[timeSymbols.index(s)])
            #v = list(datetime.now().timetuple())[timeSymbols.index(s)]
        elif s in assembler.nesRegisters:
            v = assembler.nesRegisters[s]
            return '${:04x}'.format(v)
        else:
            v = 0
            l = 1
        if type(v) in (int,float):
            return makeHex(v)
        else:
            return v
    def findFile(filename):
        return assembler.findFile(filename)
    
    def isImmediate(v):
        if v.startswith("#"):
            return True
        else:
            return False

    def isNumber(v):
        return all([x in "0123456789" for x in str(v)])
    
    def splitNumber(v):
        i = ([x in '0123456789' for x in v]+[False]).index(False)
        if i == len(v):
            return [v]
        else:
            return [v[:i], v[i:]]

    def getValueAndLength(v, mode=False, param=False, hint=False):
        assembler.errorHint = False
        if type(v) is int:
            l = 1 if v < 256 else 2
            return v,l
        
        if type(v) is float:
            l = 1 if v < 256 else 2
            return v,l
        
        if mode == 'namespace':
            v = v.strip()
            if v.startswith('.') and v == v[0]*len(v):
                n = -len(v)
                try:
                    return assembler.namespace[n], n
                except:
                    return 0,1
            return 0,1
        
        if mode == 'getbyte':
            a = getValue(v)
            fileOffset = int(getSpecial('fileoffset')) + (a-currentAddress)
            try:
                v = int(out[fileOffset])
            except:
                v = 0
            return v, 1
        
        if mode == 'getword':
            a = getValue(v)
            fileOffset = int(getSpecial('fileoffset')) + (a-currentAddress)
            
            try:
                v = int(out[fileOffset]) + int(out[fileOffset+1]) * 0x100
            except:
                v = 0
            return v, 2
        
        if mode == 'len':
            v, l = getValueAndLength(v)
            return l, 1
        if mode == 'coalesce':
            vToken = assembler.tokenize(v)
            for item in vToken:
                v,l = getValueAndLength(item)
                if v:
                    return v, l
            return 0, 0
        if mode == 'choose':
            v = v.split(',')
            random.shuffle(v)
            v=v[0]
            l=1
            
            #v,l = getValueAndLength(v)
            
            return v,l
        if mode == 'pop':
            s = getSymbolInfo(v)
            if s:
                v,l = getValueAndLength(s.value, mode=mode)
                return v,l
            else:
                assembler.errorHint = "unknown symbol"
                v = 0
                l = -1
                return v,l
        
        if mode == 'range':
            v=v.split(',')
            v = [getValue(x) for x in v]
            if len(v) == 1:
                v[0]+=1
            elif len(v) == 2:
                v[1]+=1
            elif len(v) == 3:
                v[1]+=v[2]
            
            v = list(range(*v))
            l = len(v)
            return v,l
        if mode == 'concat':
            v=v.split(',',1)
            left, right = getValue(v[0]), getValue(v[1])
            
            left = makeList(left)
            right = makeList(right)
            
            if type(left) != type(right):
                txt = "Can't concat types {} and {}".format(type(left).__name__, type(right).__name__)
                assembler.errorHint = txt
                print(txt)
                return -1,0
            
            v = left + right
            v,l = getValueAndLength(v)
            return v,l
            
        if mode == 'evalvar':
            print(v)
            v,l = getValueAndLength(v)
            return v,l
        if mode in autoFilters.keys():
            v = autoFilters[mode](*[getValue(x) for x in v.split(',')])
            v,l = getValueAndLength(v)
            return v,l
        if mode == 'random':
            v=v.split(',',1)
            r1 = getValue(v[0])
            if len(v) == 2:
                r2 = getValue(v[1])
            else:
                # Add 1 so for example:
                #   random:0 is randrange(1) or randrange(0, 1)
                #   random:1 is randrange(2) or randrange(0, 2)
                r2 = None
                r1 = r1 + 1
            
            try:
                v = random.randrange(r1,r2)
            except:
                # symbol evaluation fails on earlier passes sometimes
                v = 0
                if passNum == lastPass:
                    assembler.errorHint = "invalid random range"
                    return 0,0
            l = 1
            return v,l
        
        if mode == 'fileexist':
            v = getValueAsString(v) or getString(v)
            if assembler.findFile(getString(v)):
                return 1,1
            else:
                return 0,1
        
        if mode == 'nfileexist':
            v = getValueAsString(v) or getString(v)
            if assembler.findFile(getString(v)):
                return 0,1
            else:
                return 1,1
        
        if type(v) is list:
            if mode == 'shuffle':
                random.shuffle(v)
            return v,len(v)
        
        if type(v) is bool:
            return v, 0
        
        if type(v) is str and '??' in v:
            v = v.split('??',1)
            
            v2, l = getValueAndLength(v[0])
            # make sure length isn't 0 or -1
            if l > 0:
                return v2, l
            else:
                v2, l = getValueAndLength(v[1])
                return v2, l
        
        if v.startswith("[") and v.endswith("]"):
            v = v[1:-1]
        
        v = v.strip()
        l = False
        
        # list indexing like a[1]
        if '[' in v and v.endswith(']') and v.find(']') == v.rfind(']'):
            index = v.split('[',1)[1].split(']')[0]
            s = getSymbolInfo(v.split('[')[0])
            
            if s and s.baseKey in superglobals:
                s = getSymbolInfo(s.baseKey, ns='')
                v = symbols[s.baseKey]
                if type(v) == list:
                    v = v[:]
                v,l = getValueAndLength(v[getValue(index)], mode=mode)
                return v,l
            
            if s:
                if type(s.value) == list:
                    s.value = s.value[:]
                v,l = getValueAndLength(s.value[getValue(index)], mode=mode)
                return v,l
        
        vToken = assembler.tokenize(v)
        
        if v.startswith("(") and v.endswith(")"):
            v = v[1:-1]
        
        if vToken[-1] in ('x','y','X','Y'):
            vToken = vToken[:-1]
            v = ', '.join(vToken)
        
        if v.startswith("(") and v.endswith(")"):
            v = v[1:-1]
        if '(' in v and ')' in v:
            if v.startswith(assembler.quotes) and v.endswith(assembler.quotes):
                pass
            else:
                result = re.findall('\(([^\(].*?)\)', v)
                if result:
                    for item in result:
                        item = '('+item+')'
                        v = v.replace(item, str(getValue(item)))
        if v=='':
            return 0,0
        
        # this will handle comma separated lists
        vToken = assembler.tokenize(v)
        if len(vToken) > 1:
            v = [getValue(x) for x in vToken]
            l = len(v)
            if mode == 'shuffle':
                random.shuffle(v)
            elif mode == 'choose':
                random.shuffle(v)
                v=v[0]
                l=1
            return v,l
        
        if ' > ' in v:
            l,r = v.split(' > ')
            if (getValue(l) > getValue(r)):
                return 1, 1
            else:
                return 0, 1
        if ' < ' in v:
            l,r = v.split(' < ')
            if (getValue(l) < getValue(r)):
                return 1, 1
            else:
                return 0, 1
        if ' >= ' in v:
            l,r = v.split(' >= ')
            if (getValue(l) >= getValue(r)):
                return 1, 1
            else:
                return 0, 1
        if ' <= ' in v:
            l,r = v.split(' <= ')
            if (getValue(l) <= getValue(r)):
                return 1, 1
            else:
                return 0, 1
        
        if v.startswith(assembler.quotes) and v.endswith(assembler.quotes):
            if mode == 'textmap':
                v = assembler.mapText(assembler.stripQuotes(v))
            else:
                v = list(bytes(assembler.stripQuotes(v), 'utf-8'))
            l=len(v)
            return v, l
        
        if '=' in v:
            v = v.replace('==', '=')
            if '!=' in v:
                l,r = v.split('!=')
                inv = True
            else:
                l,r = v.split('=')
                inv = False
            if ((getValue(l) == getValue(r)) and inv == False) or ((getValue(l) != getValue(r)) and inv == True):
                return 1, 1
            else:
                return 0, 1
        
#        if v.startswith(assembler.quotes) and v.endswith(assembler.quotes):
#            if mode == 'textmap':
#                v = assembler.mapText(assembler.stripQuotes(v))
#            else:
#                v = list(bytes(assembler.stripQuotes(v), 'utf-8'))
#            l=len(v)
#            return v, l
        
        if v.startswith('-'):
            label = v.split(' ',1)[0]
            if passNum == lastPass:
                
                if len(v)>1 and v[1] in '1234567890':
                    v,l = getValueAndLength('0'+v)
                    return v,l
                
                possible = [x for l, x in labels.anon[passNum-1].items() if x.label == assembler.lower(v) and l<=lineNumber]
                if possible:
                    l = possible[-1]
                    return l.address, 2
            else:
                return 0,2
            
        if v.startswith('+'):
            label = v.split(' ',1)[0]
            if passNum == lastPass:

                if len(v)>1 and v[1] in '1234567890':
                    v,l = getValueAndLength('0'+v)
                    return v,l

                possible = [x for l, x in labels.anon[passNum-2].items() if x.label == assembler.lower(v) and l>lineNumber]
                if possible:
                    l = possible[0]
                    return l.address, 2
            else:
                return 0,2
        
        if v.startswith(tuple(assembler.localPrefix)):
            s = getSymbolInfo(v)
            if s:
                v,l = getValueAndLength(s.value, mode=mode)
                return v,l
        
        # ToDo: tokenize, allow (), implement proper order of operations.
        if '+' in v:
            v = v.split('+',1)
            left, right = getValue(v[0]), getValue(v[1])
            if type(left)==type(right):
                v = left + right
            elif type(left)==list:
                v = [x+right for x in left]
                return v,len(v)
            else:
                return 0, 1
            l = 1 if v < 256 else 2
            return v,l
        if '-' in v:
            v = v.split('-', 1)
            left, right = getValue(v[0]), getValue(v[1])
            if type(left)==type(right):
                v = left - right
            elif type(left)==list:
                v = [x-right for x in left]
                return v,len(v)
            else:
                return 0, 1
            l = 1 if v < 256 else 2
            return v,l
        
        if v.startswith('#'):
            v = getValue(v[1:])
            l = 1
            #assembler.immediate = True
            return v,l
        
        if v.startswith("<"):
            v = getValue(v[1:]) % 0x100
            l = 1
            return v,l
        if v.startswith(">"):
            v = getValue(v[1:]) >> 8
            l = 1
            return v,l
        
        if v == '$' or v.lower() == 'pc':
            v = currentAddress
            l=2
        elif v.lower() == 'randbyte':
            v = random.randrange(0,256)
            l=1
        elif v.startswith('%'):
            # do this to avoid clogging things up with operations below
            v = '_0b_'+v[1:]
            v = getValue(v)
            l = 1
            return v,l
        elif any(x in v for x in operations):
            for op in operations:
                if op in v:
                    v = v.split(op)
                    
                    v0 = getValue(v[0], mode)
                    v1 = getValue(v[1])
                    
                    if type(v0) is list:
                        v = [operations[op](x, v1) for x in v0]
                        l = len(v)
                    else:
                        v = operations[op](v0, v1)
                        l = 1 if v < 256 else 2
                    #v = operations[op](getValue(v[0]), getValue(v[1]))
                    #l = 1 if v < 256 else 2
                    return v,l
        elif v.startswith('0x'):
            v = int(v[2:],16)
            l = bytesForNumber(v)
        elif v.startswith('$'):
            v = int(v[1:],16)
            l = bytesForNumber(v)
        elif v.startswith('_0b_'):
            l = 1
            v = int(v[4:],2)
        elif v.startswith('%'):
            l = 1
            v = int(v[1:],2)
        elif isNumber(v):
            l = 1 if int(v,10) < 256 else 2
            v = int(v,10)
        elif nsSymbol(v) in symbols:
            v2 = v
            if namespaceSymbol in v2:
                v2 = v.split(namespaceSymbol,1)[1]
            if v2.startswith(tuple(assembler.localPrefix)):
                label = assembler.localLabels.get(assembler.lastLabel, Map()).get(nsSymbol(v), False)
                if label and passNum == lastPass:
                    v = label.value
                    l = 2
                    return v, l
            v, l = getValueAndLength(symbols[nsSymbol(v)], mode=mode)
        elif v.startswith(namespaceSymbol) and v.split(namespaceSymbol,1)[1] in symbols:
            v, l = getValueAndLength(symbols[v.split(namespaceSymbol,1)[1]], mode=mode)
        elif assembler.lower(v) in symbols:
            v, l = getValueAndLength(symbols[assembler.lower(v)], mode=mode)
        elif v.lower() in specialSymbols:
            v, l = getValueAndLength(getSpecial(v.lower()), mode=mode)
        else:
            if hint == 'string':
                return str(v), len(v)
            
            if passNum == lastPass:
                #errorText= 'invalid value: {}'.format(v)
                #print('*** '+errorText)
                pass
            assembler.errorHint = "invalid value*"
            v = 0
            l = -1
        
        if mode == 'astext':
            v = bytearray(makeList(v)).decode('utf8')
            l = len(v)
            return v, l

        if mode == 'textmap':
            if type(v) is int:
                print('bad textmap type')
                return v,l
            v = assembler.mapText(bytearray(makeList(v)).decode('utf8'))
            l = len(v)
        
        if mode == 'getbytes':
            fileOffset = int(getSpecial('fileoffset')) + (v-currentAddress)
            
            try:
                v = out[fileOffset:fileOffset + param]
                return v, param
            except:
                return 0, 0
        return v, l

    def getValue(v, mode=False, param=False, hint=False):
        return getValueAndLength(v, mode=mode, param=param, hint=hint)[0]
    def getLength(v, mode=False, param=False, hint=False):
        return getValueAndLength(v, mode=mode, param=param, hint=hint)[1]

    def getOpWithMode(opcode,mode):
        ops = [x for x in asm if x.opcode==opcode]
        if mode in [x.mode for x in ops]:
            return [x for x in ops if x.mode==mode][0]
        else:
            return False

    try:
        file = open(filename, "r")
    except:
        print("Error: could not open file.")
        return False
    
    print(dedent("""
    ------------------------------------------------------------
    WARNING: This project is currently in {} stage.
    Some features may be incomplete, have bugs, or change.
    ------------------------------------------------------------
    """.format(version.get('stage'))))
    print('assembling {}'.format(filename))
    
    assembler.initialFolder = os.path.split(filename)[0]
    assembler.currentFolder = assembler.initialFolder
    assembler.initialFilename = filename
    
    printFilename = False

    # Doing it this way removes the line endings
    lines = file.read().splitlines()
    
    lineContinue = makeList(cfg.getValue('main', 'lineContinue'))
    lineContinueComma = cfg.isTrue(cfg.getValue('main', 'lineContinueComma'))
    if cfg.isTrue(cfg.getValue('main', 'floorDiv')):
        operations.update({'/':operator.floordiv})
    
    for c in lineContinue:
        joinLines = [i for i,x in enumerate(lines) if x.strip().endswith(c)]
        for i in joinLines:
            lines[i+1] = lines[i].rsplit(c,1)[0] + lines[i+1]
            lines[i]= '_delete_this_'
    if lineContinueComma:
        joinLines = [i for i,x in enumerate(lines) if x.strip().endswith(',')]
        for i in joinLines:
            lines[i+1] = lines[i].rstrip() + ' ' + lines[i+1]
            lines[i]= '_delete_this_'
        lines = [x for i,x in enumerate(lines) if x!='_delete_this_']
    
    originalLines = lines
    
    symbols = Map()
    
    symbols.sdasm = 1
    equ = Map()
    
    lastPass = 3
    
    aLabels = []
    lLabels = []
    macros = Map()
    functions = Map()
    tilemaps = Map()
    assembler.commentBlock = 0
    
    labels = Map()
    labels.anon = Map()
    labels.anon = [Map() for x in range(lastPass)]
    
    if binFile:
        filename = assembler.findFile(binFile)
        if filename:
            try:
                with open(filename,'rb') as file:
                    fileData = file.read()
            except:
                print("Could not load file: {}".format(filename))
                return
        else:
            print("Could not find file: {}".format(binFile))
            return
    
    if (fileData is not None) and (fileData is not False):
        originalFileData = fileData[:]
    
    rndState = random.getstate()
    
    for passNum in range(1,lastPass+1):
        if passNum>lastPass:
            break
        
        passTime = time.time()
        
        commentSep = makeList(cfg.getValue('main', 'comment'))
        commentBlockOpen = makeList(cfg.getValue('main', 'commentBlockOpen'))
        commentBlockClose = makeList(cfg.getValue('main', 'commentBlockClose'))
        assembler.commentSep = makeList(cfg.getValue('main', 'comment'))
        assembler.commentBlockOpen = makeList(cfg.getValue('main', 'commentBlockOpen'))
        assembler.commentBlockClose = makeList(cfg.getValue('main', 'commentBlockClose'))
        fillValue = getValue(cfg.getValue('main', 'fillValue'))
        localPrefix = makeList(cfg.getValue('main', 'localPrefix'))
        assembler.localPrefix = makeList(cfg.getValue('main', 'localPrefix'))
        debug = cfg.isTrue(cfg.getValue('main', 'debug'))
        varOpen = makeList(cfg.getValue('main', 'varOpen'))
        varClose = makeList(cfg.getValue('main', 'varClose'))
        varOpenClose = mergeList(varOpen,varClose)
        labelSuffix = makeList(cfg.getValue('main', 'labelSuffix'))
        namespaceSymbol = cfg.getValue('main', 'namespaceSymbol')
        orgPad = int(cfg.getValue('main', 'orgPad'))
        padOrg = int(cfg.getValue('main', 'padOrg'))
        mapdb = cfg.isTrue(cfg.getValue('main', 'mapdb'))
        clampdb = cfg.isTrue(cfg.getValue('main', 'clampdb'))
        lineSep = makeList(cfg.getValue('main', 'linesep'))
        suppressErrorPrefix = makeList(cfg.getValue('main', 'suppressErrorPrefix'))
        caseSensitive = cfg.isTrue(cfg.getValue('main', 'caseSensitive'))
        xkasplusbranch = cfg.isTrue(cfg.getValue('main', 'xkasplusbranch'))
        metaCommandPrefix = makeList(cfg.getValue('main', 'metaCommandPrefix'))
        showFileOffsetInListFile = cfg.isTrue(cfg.getValue('main', 'showFileOffsetInListFile'))
        showBankInListFile = cfg.isTrue(cfg.getValue('main', 'showBankInListFile'))
        fullTraceback = cfg.isTrue(cfg.getValue('main', 'fullTraceback'))
        loadld65cfg = cfg.isTrue(cfg.getValue('main', 'loadld65cfg'))
        rememberBankAddress = cfg.isTrue(cfg.getValue('main', 'rememberBankAddress'))
        oldPrint = cfg.isTrue(cfg.getValue('main', 'oldPrint'))
        
        assembler.namespace = Stack([''])
        assembler.pcStack = Stack()
        assembler.baseStack = Stack()
        
        
        for s in defineSymbol:
            symbols[assembler.lower(s)] = 1
        
        # This is important for consistancy in each pass
        random.setstate(rndState)
        
        assembler.caseSensitive = caseSensitive
        
        lineSep = [x for x in lineSep if x != '']
        suppressErrorPrefix = [x for x in suppressErrorPrefix if x != '']
        
        assembler.currentFilename = assembler.initialFilename
        lines = originalLines
        
        if loadld65cfg:
            lines = [assembler.hidePrefix + 'loadld65cfg?'] + lines
        
        addr = 0
        oldAddr = 0
        
        noOutput = False
        noOutputSingle = False
        
        macro = False
        function = False
        tilemap = False
        currentAddress = 0
        mode = ""
        showAddress = False
        out = []
        assembler.bankData = {}
        
        if (fileData is not None) and (fileData is not False):
            out = list(fileData)
        
#        try:
#            if type(fileData) != bool and fileData != None:
#                out = list(fileData)
#        except:
            # I'm sick of your nonsense, numpy.
#            pass
        
        if usenp:
            #out = np.array([],dtype="B")
            out = np.array(out, dtype="B")
        
        outputText = ''
        outputText2 = ''

        startAddress = False
        assembler.currentFolder = assembler.initialFolder
        ifLevel = 0
        ifData = Map()
        
        depth = 0
        
        arch = 'nes.cpu'
        headerSize = 0
        bankSize = 0x10000
        chrSize = 0x2000
        bank = None
        symbols['reptindex'] = 0
        assembler.warnings = 0
        assembler.lastLabel = ''
        
        assembler.clearTextMap(all=True)
        
        fileList = []
        print('pass {}...'.format(passNum))
        
        totalTime = time.time()
        
        for lineNumber in range(10000000):
            i = lineNumber # compatability; should get rid of i
            if lineNumber>len(lines)-1:
                break
            line = lines[lineNumber]
            
            hide = False
            
            #currentAddress = addr
            originalLine = line
            assembler.line = line
            assembler.lineNumber = lineNumber
            assembler.fileLineNumber +=1
            errorText = False
            assembler.errorLinePos = False
            
            if assembler.expectedWait:
                assembler.expectedWait = False
            else:
                assembler.expected = False
            
            lineTime = time.time()
            
#            if assembler.echoLine and passNum == lastPass:
#                print('>>>',originalLine)
            
            # change tabs to spaces
            line = line.replace("\t"," ")
            
            
            line = line.replace('+:','+ ').replace('-:','- ')
            
            if assembler.echoLine and passNum == lastPass:
                if line.strip().lower() != 'echo off':
                    print(originalLine)
            
            # remove meta command prefix
            for sep in metaCommandPrefix:
                for item in metaCommandPrefix:
                    if line.startswith(item):
                        line = line.split(item,1)[1].lstrip()
            
            # remove comments
            line = assembler.stripComments(line.strip())
            
            # used to help hide internal directive lines
            if line.startswith(assembler.hidePrefix):
                line = line.split(assembler.hidePrefix,1)[1]
                assembler.hideOutputLine = True
            
            if lineSep:
                line = [line]
                for s in lineSep:
                    line = flattenList([l.split(s) for l in line])
                
                if len(line) > 1:
                    lines[i+1:i+1] = line
                    line = ''
                    assembler.hideOutputLine = True
                else:
                    line = line[0]
            
            
            if suppressErrorPrefix:
                for s in suppressErrorPrefix:
                    if line.startswith(s):
                        line = line.split(s,1)[1]
                        assembler.suppressError = True
            
            # "EQU" replacement
            for item in equ:
                line = line.replace(item, equ[item])
            
            # {var} replacement
            for o,c in varOpenClose:
                if o in line and c in line:
                    while o+":" in line:
                        start = line.find('{:')
                        end = line.find('}', start)
                        
                        line = line.replace(line[start:end+1], str(getValue(line[start+2:end])))
                    
                    for item in specialSymbols:
                        if o+item+c in line:
                            s = getSpecial(item)
                            line = line.replace(o+item+c, s)
                    
                    for item in filters:
                        while o+item+":" in line:
                            start = line.find('{'+item+':')
                            end = line.find('}', start)
                            
                            if item == 'format':
                                fmtStart = line.find(':',start)+1
                                fmtEnd = line.find(':',fmtStart)
                                fmtString = '{:' + line[fmtStart:fmtEnd] + '}'
                                #v = getValue(line[fmtEnd+1:end])
                                v, l = getValueAndLength(line[fmtEnd+1:end])
                                
                                if type(v) is list:
                                    v = ', '.join([fmtString.format(x) for x in v])
                                else:
                                    v = fmtString.format(v)
                            elif item == 'getbytes':
                                v = assembler.tokenize(line[start+2+len(item):end])
                                v, l = getValueAndLength(v[0], mode=item, param = getValue(v[1]))
                            else:
                                v, l = getValueAndLength(line[start+2+len(item):end], mode=item)
                                assembler.errorLinePos = start+2+len(item)
                            
                            if l == 0:
                                errorText = assembler.errorHint or 'invalid filter value'
                                
                                v = "0"
                            elif type(v) is int:
                                v = str(v)
                            elif type(v) is list:
                                v = ','.join([str(x) for x in v])
                            line = line.replace(line[start:end+1], str(v))
                    
                    while o in line:
                        start = line.find(o)
                        end = line.find(c, start)
                        
                        line = line.replace(line[start:end+1], str(getValue(line[start+1:end])))
            
            if ifLevel:
                if ifLevel>1 and ifData[ifLevel-1].bool == False:
                    ifData[ifLevel].bool = False
                    ifData[ifLevel].done = True

                if ifData[ifLevel].bool == False:
                    
                    key = line.split(" ",1)[0].strip().lower()
                    if key.startswith('.'):
                        key = key[1:]
                    
                    if key not in ifDirectives:
                        ifData.line = line
                        line = ''
            
            if macro:
                if line.split(" ",1)[0].strip().lower() not in ['endm','endmacro','.endm','.endmacro']:
                    macros[macro].lines.append(originalLine)
                    line = ''
            if function:
                if line.split(" ",1)[0].strip().lower() not in ['endf','endfunction','.endf','.endfunction']:
                    functions[function].lines.append(originalLine)
                    line = ''
            if tilemap:
                endTilemap = False
                try:
                    if ' '.join(line.lower().split(None, 2)[0:2]) == 'end tilemap':
                        endTilemap = True
                except:
                    pass
                
                if not endTilemap:
                    tilemaps[tilemap].lines.append(originalLine.strip())
                    line = ''
            
            b=[]
            k0 = line.split(" ",1)[0].strip()
            
            # This is for handling keywords separated
            # by something other than a space
            # Example:
            #     bne+
            #
            if k0.startswith(tuple(opcodes+opcodes2)):
                chars = '-+<>#$%()'
                
                for index, c in enumerate(k0):
                    if c in chars:
                        k0 = line[:index]
                        line = line[:index]+' '+line[index:]
                        break
            
            k = k0.lower()
            kf = ''
            label = False
            labelWithSuffix = False
            
            if '(' in line and assembler.lower(line.split('(')[0]) in functions:
                kf = line.split('(')[0].lower()
                kfdata = line.split('(',1)[1].rsplit(')',1)[0].strip()
                
                kfdata = [x.strip() for x in assembler.tokenize(kfdata)]
                k = ''
            
            if k.startswith(('-','+')):
                label = k
                for l in labelSuffix:
                    k = (k+l).split(l,1)[0]
                    label = k
                    labelWithSuffix = k+l
#                    print('label =',label)
#                    input('...')
                    break
            
            if k.startswith(('-','+')) and label:
                    l = Map(
                        label=assembler.lower(k),
                        lineNumber = lineNumber,
                        originalLine = originalLine,
                        address = currentAddress,
                    )
                    
                    labels.anon[passNum-1][lineNumber] = l
                    
            if k!='' and (k=="-"*len(k) or k=="+"*len(k)):
                #if not [k,currentAddress] in aLabels:
                if k.startswith('-') or (not [k,currentAddress] in aLabels):
                    aLabels.append([k, currentAddress])
                    
                    # update so rest of line can be processed
                    line = (line.split(" ",1)+[''])[1].strip()
                    k0 = line.split(" ",1)[0].strip()
                    k = k0.lower()
            
            # This is really complicated but we have to check to see
            # if this is a label without a suffix somehow.
            if k!='' and not (k.startswith('.') and k[1:] in directives) and not k.endswith(tuple(labelSuffix)) and ' equ ' not in line.lower() and '=' not in line and k not in list(directives)+list(macros)+list(opcodes)+opcodes2+list(functions):
                if k.startswith('-') or k.startswith('+'):
                    k0=k
                    
                    aLabels.append([assembler.lower(k0), currentAddress])
                    line = (line+' ').split(' ',1)[1].strip()
                    k0 = line.split(" ",1)[0].strip()
                    k = k0.lower()
                else:
                    if debug: print('label without suffix: {}'.format(k))
                    k += labelSuffix[0]
                    k0 += labelSuffix[0]
            if k.endswith(tuple(labelSuffix)):
                if k.startswith('-') or k.startswith('+'):
                    # this code should never execute
                    print('huh?')
                    aLabels.append([k0[:-1], currentAddress])
                else:
                    n = nsSymbol(assembler.lower(k0[:-1]))
                    symbols[nsSymbol(n)] = str(currentAddress)
                    
                    if not k.startswith(tuple(localPrefix)):
                        assembler.lastLabel = n
                    else:
                        # make sure parent label map exists
                        assembler.localLabels[assembler.lastLabel] = assembler.localLabels.get(assembler.lastLabel, Map())
                        
                        assembler.localLabels[assembler.lastLabel][n] = Map(
                            name = n,
                            parentLabel = assembler.lastLabel,
                            value = currentAddress,
                        )
                        
                        assembler.localLabelKeys.update({n:True})
                        
                    # update so rest of line can be processed
                    line = (line.split(" ",1)+[''])[1].strip()
                    k = line.split(" ",1)[0].strip().lower()
            
            # prefix is optional for valid directives
            if k.startswith(".") and k[1:] in directives:
                k=k[1:]
            
            # optionally allow "then" at the end of some if directives
            if k in ifDirectives and k not in ('else', 'endif'):
                data = line.split(" ",1)[1]
                if data.lower().rfind('then') != -1:
                    line = line[:line.lower().rfind('then')]
            
            if k == 'ifdef':
                ifLevel+=1
                ifData[ifLevel] = Map()
                
                data = line.split(" ",1)[1].strip().replace('==','=')

                #if assembler.lower(data) in symbols:
                if getSymbolInfo(data):
                    ifData[ifLevel].bool = True
                    ifData[ifLevel].done = True
                else:
                    ifData[ifLevel].bool = False
            elif k == 'ifndef':
                ifLevel+=1
                ifData[ifLevel] = Map()
                
                data = line.split(" ",1)[1].strip().replace('==','=')
                
                if getSymbolInfo(data):
                #if assembler.lower(data) in symbols:
                    ifData[ifLevel].bool = False
                else:
                    ifData[ifLevel].bool = True
                    ifData[ifLevel].done = True
            elif k == 'elseif':
                if ifData[ifLevel].done:
                    ifData[ifLevel].bool=False
                else:
                    k = 'if'
                    ifLevel-=1
            elif k == 'iffileexist' or k == 'iffile':
                ifLevel+=1
                ifData[ifLevel] = Map()
                
                data = line.split(" ",1)[1].strip()
                data = getString(data)
                if assembler.findFile(data):
                    ifData[ifLevel].bool = True
                    ifData[ifLevel].done = True
                else:
                    ifData[ifLevel].bool = False
            if k == 'if':
                ifLevel+=1
                ifData[ifLevel] = Map()
                
                inv = False
                data = line.split(" ",1)[1].strip().replace('==','=')
                
                if data.split(" ")[0].strip().lower() == 'not':
                    data = data.split(' ',1)[1]
                    inv = True

                if inv:
                    if getValue(data):
                        ifData[ifLevel].bool = False
                    else:
                        ifData[ifLevel].bool = True
                        ifData[ifLevel].done = True
                else:
                    if getValue(data):
                        ifData[ifLevel].bool = True
                        ifData[ifLevel].done = True
                    else:
                        ifData[ifLevel].bool = False
            if k == 'else':
                ifData[ifLevel].bool = not ifData[ifLevel].done
            elif k == 'endif':
                ifLevel-=1
            elif k == 'arch':
                arch = line.split(" ")[1].strip()
                if arch.lower() not in architectures:
                    errorText = 'invalid architecture'
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
            elif k == 'noheader':
                headerSize = 0
                assembler.stripHeader = False
            elif k == 'header':
                headerSize = 16
                assembler.stripHeader = False
                
                # Make sure there's a bare bones header if
                # it doesn't exist.
                header = (list(out[:16]) + [0] * 16)[:16]
                header[0:4] = list(bytearray("NES", 'utf8')) + [0x1a]
                if header[4] == 0:
                    # Don't let it have zero prg
                    header[4] = 1
                out[0:16] = header
                
                # also set position back to start of header
                bank = None
                currentAddress = 0
                addr = 0
            elif k == 'stripheader':
                headerSize = 16
                assembler.stripHeader = True
            elif k == 'banksize':
                bankSize = getValue(line.split(" ")[1].strip())
                #print('banksize: ',bankSize)
            elif k == 'chrsize':
                chrSize = getValue(line.split(" ")[1].strip())
            elif k == 'lastbank':
                bank = out[4]-1

                # bank resets
                currentAddress = 0x8000
                addr = bank * bankSize
            elif k == 'absorg':
                v = getValue(line.split()[1].strip())
                bank = None
                currentAddress = 0
                addr = v
            elif k == 'bank':
                if rememberBankAddress and (bank != None):
                    assembler.bankData[bank] = assembler.bankData.get(bank, {})
                    assembler.bankData[bank].update(currentAddress = currentAddress, addr = addr)
                
                v = line.split(" ")[1].strip()
                bank = getValue(v)
                
                # bank resets
                currentAddress = 0x8000
                addr = bank * bankSize
                
                if rememberBankAddress and (bank != None):
                    assembler.bankData[bank] = assembler.bankData.get(bank, {})
                    currentAddress = assembler.bankData[bank].get('currentAddress', currentAddress)
                    addr = assembler.bankData[bank].get('addr', addr)
            
            elif k == 'segment':
                if assembler.memcfg:
                    segId = line.split(" ")[1].strip()
                    segId = getValueAsString(segId, fallback=True)
                    
                    mem = assembler.memcfg['memory']
                    seg = assembler.memcfg['segments']
                    
                    load = seg[segId].get('load')
                    
                    a = 0
                    for k,v in mem.items():
                        if k == load:
                            break
                        a = a + v.get('size')
                    
                    addr = a
                    
                    currentAddress = seg[segId].get('start', mem.get(load).get('start'))
                    startAddress = mem.get(load).get('start')
                    
                    # segment has a defined start, like $fffa for vectors
                    if seg[segId].get('start', False):
                        startAddress = seg[segId].get('start') - mem.get(load).get('start')
                        addr += seg[segId].get('start', 0) - mem.get(load).get('start')
                    
                    if debug:
                        print('segment:')
                        print('load =', load)
                        print('addr =', hex(addr))
                        print('startAddress =', hex(currentAddress))
                        print('currentAddress =', hex(currentAddress))
                        print()
                else:
                    print('ld65cfg not loaded, ignoring segment.')
            elif k == 'chr':
                v = getValue(line.split(" ")[1].strip())
                
                bank = int((getValue('prgbanks') * 0x4000) / bankSize)
                bank = None
                # bank resets
                currentAddress = 0
                addr = getValue('prgbanks') * 0x4000 + chrSize*v + headerSize
            elif k == 'setpalette':
                v = getValue(line.split(" ",1)[1].strip())
                assembler.currentPalette = v
            elif k == 'quit':
                v = (line.split(" ",1)[1:]+[''])[0]
                print('*** quit ***\n{}\n'.format(v))
                return
            elif k == 'inesprg':
                out[4] = getValue(line.split(" ")[1].strip())
                if debug:
                    print('setting prg to ',out[4])
            elif k == 'ineschr':
                out[5] = getValue(line.split(" ")[1].strip())
            elif k == 'inesmir':
                v = line.split(" ")[1].strip()
                
                if v.lower() in('v', 'vertical', 'vert'):
                    v = 1
                elif v.lower() in('h', 'horizontal', 'vert'):
                    v = 0
                else:
                    v = getValue(v)
                
                out[6] = (out[6] & 0xfe) | v
            elif k == 'inesbattery':
                if k.strip() == line.strip().lower():
                    v = 1
                else:
                    v = getValue(line.split(" ")[1].strip())
                out[6] = (out[6] & 0xfd) | v<<1
            elif k == 'ines2':
                v = getValue(line.split(" ")[1].strip())
                out[7] = (out[7] & 0xf3) | v<<3
            elif k == 'inesworkram':
                v = getValue(line.split(" ")[1].strip())
                out[10] = (out[10] & 0xf0) | v
            elif k == 'inessaveram':
                v = getValue(line.split(" ")[1].strip())
                out[10] = (out[10] & 0x0f) | v<<4
            elif k == 'inesfourscreen':
                v = getValue(line.split(" ")[1].strip())
                out[6] = (out[6] & 0xf7) | v<<3
            elif k == 'inesmap':
                v = getValue(line.split(" ")[1].strip())
                out[6] = (out[6] & 0x0f) | (v & 0x0f)<<4
                out[7] = (out[7] & 0x0f) | (v & 0xf0)
            elif k == 'index':
                errorText = '{} directive not implemented.'.format(k)
            elif k == 'mem':
                errorText = '{} directive not implemented.'.format(k)
            elif k == 'orgpad':
                orgPad = getValue(line.split(" ")[1].strip())
            elif k == 'padorg':
                padOrg = getValue(line.split(" ")[1].strip())
            elif k == 'lastpass':
                print('Skipping to final pass')
                lastPass = passNum
            elif k == 'findtext':
                txt = line.split(" ", 1)[1]
                txt = getString(getValue(txt), strip = False) or getString(txt)
                findValue = assembler.mapText(txt)
                fileOffset = int(getSpecial('fileoffset'))
                
                index = fileOffset - 1
                while True:
                    try:
                        index = out.index(findValue[0], index+1)
                        if out[index:index+len(findValue)] == findValue:
                            break
                    except:
                        index = False
                        break
                
                symbols['resultbank'] = False
                symbols['resultaddress'] = False
                if passNum == lastPass:
                    print(f'\nSearching for text: "{txt}"')
                    if index:
                        a = (index-headerSize)
                        resultBank = math.floor(a/bankSize)
                        a = a % bankSize + 0x8000
                        print('Found at: {:02x}:{:05x}'.format(resultBank, a))
                        symbols['resultbank'] = resultBank
                        symbols['resultaddress'] = a
                    else:
                        print('Not found')
                    print()
            
            elif k == 'insert' and (passNum == lastPass):
                v = getValue(line.split(" ", 1)[1].strip())
                fv = fillValue
                if type(v) == list:
                    fv = v[1]
                    v = v[0]
                
                fileOffset = int(getSpecial('fileoffset'))
                out[fileOffset:fileOffset] = [fv] * v
                
                # This is used for display in list file
                assembler.insert = (v, fv)
                
                if debug:
                    print('insert', hex(v), 'bytes at ', hex(fileOffset))
            elif k == 'truncate':
                #fileOffset = addr + bank * bankSize + headerSize
                fileOffset = int(getSpecial('fileoffset'))
                del out[fileOffset:]
            elif k == '_wipe':
                out = []
            elif k == 'delete':
                v = getValue(line.split(" ", 1)[1].strip())
                fileOffset = addr + bank * bankSize + headerSize
                del out[fileOffset:fileOffset+v]
                if debug:
                    print('delete', v, 'bytes.')
            elif k == 'seed':
                if not line.split(" ")[1].strip().startswith('='):
                    v = getValue(line.split(" ")[1].strip())
                    random.seed(v)
            elif k == 'cleartable':
                assembler.clearTextMap()
            elif k == 'textmap':
                data = line.split(' ',1)[1]
                
                if data.lower() == 'clear':
                    assembler.clearTextMap()
                else:
                    data = data.split()
                    if data[0].lower() == 'space':
                        data[0] = ' '
                    elif data[0].lower() == 'equals':
                        data[0] = '='
                    elif '...' in data[0]:
                        c1,c2 = data[0].split('...')
                        data[0] = ''.join([chr(c) for c in range(ord(c1), ord(c2)+1)])
                        
                        n1 = int(data[1],16)
                        data[1] = ''.join(['{:02x}'.format(x) for x in range(n1,n1+len(data[0]))])
                    
                    if data[0].lower() == 'set':
                        assembler.setTextMap(data[1])
                    else:
                        assembler.setTextMapData(data[0], data[1])
            elif k == 'outputfile':
                data = (line.split(" ",1)+[''])[1].strip()
                filename = getValueAsString(data) or getString(data)
                
                if filename.lower() in ('false','0','none', ''):
                    outputFilename = False
                else:
                    outputFilename = filename
            elif k == 'listfile':
                data = (line.split(" ",1)+[''])[1].strip()
                filename = getValueAsString(data) or getString(data)

                if filename.lower() in ('false','0','none', ''):
                    listFilename = False
                else:
                    listFilename = filename
            elif k == 'printfile':
                data = (line.split(" ",1)+[''])[1].strip()
                filename = getValueAsString(data) or getString(data)

                if filename.lower() in ('false','0','none', ''):
                    printFilename = False
                else:
                    printFilename = filename
            # hidden internally used directive used with include paths
            if k == "setincludefolder":
                assembler.currentFolder = (line.split(" ",1)+[''])[1].strip()
                hide = True
            if k == "setcurrentfile":
                data = (line.split(" ",1)+[''])[1].strip()
                filename = getValueAsString(data) or getString(data)
                assembler.currentFilename = filename
            elif k == 'loadld65cfg' or k == 'loadld65cfg?':
                data = (line.split(" ",1)+[''])[1].strip()
                filename = getAsFilename(data) or 'ld65.cfg'
                
                if filename:
                    d = ld65cfg.read()
                    if d:
                        assembler.memcfg = d
                    else:
                        errorText = 'could not read file {}'.format(filename)
                else:
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    errorText = 'file not found'
                
                if k.endswith('?'):
                    errorText = False
            elif k=='loadtable' or k == 'table':
                l = line.split(" ",1)[1].strip()
                l = l.split(',',1)
                if len(l)==2:
                    pass
                filename = getValueAsString(l[0]) or getString(l[0])
                if not assembler.loadTbl(filename):
                    errorText = assembler.errorHint or 'file not found'
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
            elif k == 'loadpalette':
                if len(line.split(" ",1))==1:
                    # load default palette
                    assembler.loadPalette()
                else:
                    filename = line.split(" ",1)[1].strip()
                    filename = getValueAsString(filename) or getString(filename)
                    filename = assembler.findFile(filename)
                    if filename:
                        if not assembler.loadPalette(filename):
                            errorText = assembler.errorHint or 'file not found'
                            assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    else:
                        errorText = 'file not found'
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
            elif k == 'incchr' and passNum == lastPass:
                shatter = getValue('_shatterhand_import')
                
                if PIL:
                    imageX, imageY, nTiles, rows, cols = [False]*5
                    filename = line.split(" ",1)[1].strip()
                    if ',' in filename:
                        arg = filename.split(',')[1:]
                        arg = [getValue(x) for x in arg]
                        if len(arg) == 4:
                            imageX,imageY,cols,rows = arg
                        if len(arg) == 3:
                            imageX,imageY, nTiles = arg
                        if len(arg)==2:
                            cols,rows = arg
                        filename = filename.split(',')[0]
                        
                    filename = getString(filename)
                    filename = assembler.findFile(filename)
                    if filename:
                        #print(filename, shatter)
                        
                        colors = [assembler.palette[x] for x in assembler.currentPalette]
                        chrData = imageToCHRData(filename, colors=colors, xOffset=imageX,yOffset=imageY,rows=rows, cols=cols, nTiles=nTiles, shatter=shatter)
                        
                        if assembler.Sprite8x16:
                            for y in range(0,rows, 2):
                                for x in range(0, cols):
                                    for h in range(2):
                                        tileNum = ((y+h)*cols+x)
                                        b=b+chrData[tileNum*16:tileNum*16+16]
                        else:
                            b = b + chrData
                    else:
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
                        errorText = 'file not found'
                else:
                    errorText = 'PIL not available.'
            elif k in ('importmap', 'exportmap'):
                if passNum == lastPass:
                    l = line.split(" ",1)[1].strip()
                    args = l.split(',')
                    
                    x,y = 0,0
                    if len(args) == 2:
                        tilemapName = assembler.lower(getString(args[0].strip()))
                        filename = getValueAsString(args[1].strip(), fallback=True)
                        
                        assembler.errorLinePos = len(l[0])+ 1 + len(','.join(args[:1])) + 2
                    elif len(args) == 4:
                        x = getValue(args[0])
                        y = getValue(args[1])
                        tilemapName = assembler.lower(getString(args[2].strip()))
                        filename = getValueAsString(args[3].strip(), fallback=True)
                        
                        assembler.errorLinePos = len(l[0])+ 1 + len(','.join(args[:3])) + 2
                    
                    if tilemaps.get(tilemapName, False):
                        if tilemaps[tilemapName].chr != None:
                            bank = int((getValue('prgbanks') * 0x4000) / bankSize)
                            bank = None
                            currentAddress = 0
                            addr = getValue('prgbanks') * 0x4000 + chrSize*tilemaps[tilemapName].chr + headerSize
                        if tilemaps[tilemapName].org != None:
                            addr = addr + (tilemaps[tilemapName].org-currentAddress)
                            currentAddress += (tilemaps[tilemapName].org-currentAddress)
                        
                        fileOffset = int(getSpecial('fileoffset'))
                        
                        if k == 'importmap':
                            importTilemap(tilemaps[tilemapName], filename, x, y, fileOffset, out)
                        elif k == 'exportmap':
                            exportTilemapToImage(tilemaps[tilemapName], filename, x, y, fileOffset, out)
                    else:
                        errorText = 'not a valid tilemap'
            elif k == 'exportchr':
                if passNum == lastPass:
                    l = line.split(" ",1)[1].strip()
                    l = l.split(',')
                    exportSymbol = l[0].strip()
                    filename = getString(l[1].strip())
                    
                    try:
                        makeSurePathExists(os.path.dirname(filename))
                        
                        v = getValue(exportSymbol)
                        exportCHRDataToImage(filename, v)
                        print('{} written.'.format(filename))
                    except:
                        print('exportchr error')
                        raise
            elif k == 'export':
                if passNum == lastPass:
                    l = line.split(" ",1)[1].strip()
                    l = l.split(',')
                    exportSymbol = l[0].strip()
                    print(getValue(exportSymbol))
                    filename = getString(l[1].strip())
                    try:
                        makeSurePathExists(os.path.dirname(filename))
                        with open(filename, 'wb') as file:
                            file.write(bytes(getValue(exportSymbol)))
                            print('{} written.'.format(filename))
                    except:
                        print('export error')
            elif k == 'diff' or k == 'diff2':
                if passNum == lastPass:
                    arg = line.split(' ',1)[1].strip()
                    arg = assembler.tokenize(arg)
                    
                    filename = arg[0]
                    filename = getValueAsString(filename) or getString(filename)
                    filename = assembler.findFile(filename)
                    if filename:
                        with open(filename, 'rb') as file:
                            diffData = file.read()
                        diffOut='; {}\n'.format(filename)
                        n=0
                        for i,b1 in enumerate(out):
                            b2 = diffData[i]
                            if b1!=b2:
                                if k == 'diff':
                                    if n==0:
                                        diffOut += 'org ${:04x} ; ${:04x}\n    db ${:02x}'.format(i-0x10+0x8000, i, b1)
                                    else:
                                        if n % 4 == 0:
                                            diffOut += '\n    db ${:02x}'.format(b1)
                                        else:
                                            diffOut += ', ${:02x}'.format(b1)
                                elif k == 'diff2':
                                    if n==0:
                                        diffOut += 'org ${:04x} ; ${:04x}\n    db ${:02x}'.format(i-0x10+0x8000, i, b2)
                                    else:
                                        if n % 4 == 0:
                                            diffOut += '\n    db ${:02x}'.format(b2)
                                        else:
                                            diffOut += ', ${:02x}'.format(b2)
                                n += 1
                            else:
                                if n>0:
                                    diffOut += '\n'
                                n = 0
                        if len(arg)>1:
                            filename = arg[1]
                            filename = getValueAsString(filename) or getString(filename)
                            try:
                                makeSurePathExists(os.path.dirname(filename))
                                with open(filename, 'w') as file:
                                    file.write(diffOut)
                                    print('{} written.'.format(filename))
                            except:
                                errorText = 'export error'
                        else:
                            print(diffOut)
                        
                    else:
                        errorText = 'file not found'
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
            elif k == 'incbin' or k == 'bin':
                l = line.split(" ",1)[1].strip()
                
                offset = 0
                nBytes = -1
                importSymbol = False
                if ',' in l:
                    l = l.split(',')
                    filename = l[0].strip()
                    offset = getValue(l[1])
                    if len(l)>2:
                        nBytes = getValue(l[2])
                        if nBytes<=0:
                            assembler.errorLinePos = getIndent(line, findAll(line,',')[1]+1)
                            errorText = 'length out of range'
                    if len(l)>3:
                        importSymbol = l[3].strip()
                else:
                    filename = l
                
                filename = getValueAsString(filename, fallback=True)
                filename = assembler.findFile(filename)
                
                if errorText:
                    pass
                elif filename:
                    b=False
                    try:
                        with open(filename, 'rb') as file:
                            file.seek(offset)
                            b = list(file.read(nBytes))
                    except:
                        print("Could not open file.")
                    
                    if b:
                        fileList.append(filename.replace('\\','/'))
                        lines = lines[:i]+['']+['setincludefolder '+assembler.currentFolder]+lines[i+1:]
                        
                        if importSymbol:
                            symbols[assembler.lower(importSymbol)] = b[:]
                            b = []
                    else:
                        assembler.errorLinePos = getIndent(line, findAll(line,',')[0]+1)
                        errorText = 'file offset out of range'
                else:
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    errorText = 'file not found'
            elif k == 'expected':
                data = (line.split(" ", 1)+[''])[1].strip()
                assembler.expected = getString(data).strip().upper()
                assembler.expectedWait = True # wait for next line
            elif k == 'namespace':
                data = (line.split(" ", 1)+[''])[1].strip()
                if data == '_pop_':
                    assembler.namespace.pop()
                else:
                    assembler.namespace[-1] = data
            elif k == 'function':
                v = line.split(" ", 1)[1].strip()
                data = ''
                if '(' in v:
                    data = v.split('(',1)[1].rsplit(')',1)[0]
                    v = v.split('(',1)[0].strip()
                param = [x.strip() for x in data.split(',')]
                function = v.lower()
                functions[function]=Map()
                functions[function].params = param
                functions[function].lines = []
                noOutput = True
            elif k == 'endf' or k == 'endfunction':
                function = False
                noOutput = False
            elif k == 'endoffunction':
                # Hidden directive used as a marker for return
                # The argument is the ifLevel
                ifLevel = getValue(line.split(" ", 1)[1].strip())
            elif k == 'return':
                v = (line.split(" ", 1)+[''])[1].strip()
                symbols['return'] = getValue(v)
            elif k == 'rept':
                reptCount = getValue(line.split(" ",1)[1].strip())
                startIndex = i
                #depth = 1
                depth += 1
                for j in range(i+1, len(lines)):
                    l = lines[j]
                    k = l.strip().split(" ",1)[0].strip().lower()
                    if k == 'rept':
                        depth += 1
                    if k in ('endr','endrept'):
                        depth -= 1
                    if depth == 0:
                        endIndex = j
                        break
                newLines = []
                for c in range(reptCount):
                    newLines.append( '{}reptindex = {}'.format(assembler.hidePrefix, c))
                    for j in range(startIndex+1, endIndex):
                        newLines.append(lines[j])
                lines = lines[:startIndex+1] + newLines+ lines[endIndex+1:]
            elif k == 'assemble':
                arg = line.split(' ',1)[1].strip()
                arg = assembler.tokenize(arg)
                filename = line.split(" ",1)[1].strip()
                filename = getString(filename)
                filename = assembler.findFile(filename)
                if filename:
                    assemble(filename, outputFilename = 'output.bin', listFilename = False, configFile=False, fileData=False, binFile=False)
                else:
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    errorText = 'file not found'
            elif k == 'gg':
                arg = line.split(' ',1)[1].strip()
                ggCode = getValueAsString(arg.strip(), fallback=True)
                gg = GG.getGG(ggCode)
                
                ggAddresses = []
                ggOldValues = []
                
                offset = gg.get('address') + headerSize
                while True:
                    if offset>len(out):
                        #print('offset =', hex(offset), 'len =', hex(len(out)))
                        break
                    if gg.get('compare') is None:
                        ggOldValues.append(out[offset])
                        out[offset] = gg.get('value')
                        ggAddresses.append(offset)
                        #print('{:04x}:{:02x} (0x{:04x})'.format(gg.get('address'), gg.get('value'), offset))
                    elif gg.get('compare') == out[offset]:
                        ggOldValues.append(out[offset])
                        out[offset] = gg.get('value')
                        ggAddresses.append(offset)
                        #print('{:04x}:{:02x}:{:02x} (0x{:04x})'.format(gg.get('address'), gg.get('value'), gg.get('compare'), offset))
                    offset += 0x2000
                
                assembler.gg = dict(addresses = ggAddresses[:], value = gg.get('value'), oldValues = ggOldValues[:], address = gg.get('address'), compare=gg.get('compare', None), ggCode = ggCode.upper())
                
            elif k == 'ips' and passNum == lastPass:
                filename = line.split(" ",1)[1].strip()
                filename = getValueAsString(filename, fallback=True)
                
                if assembler.errorHint:
                    errorText = assembler.errorHint
                    assembler.errorLinePos = len(originalLine.rstrip())-1

                filename = assembler.findFile(filename)
                if filename:
                    ipsData = np.fromfile(filename, dtype='B')
                    out = ips.applyIps(ipsData, out) or out
                else:
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    errorText = 'file not found'
            elif k == 'makeips' and passNum == lastPass:
                filename = line.split(" ",1)[1].strip()
                filename = getValueAsString(filename, fallback=True)
                
                ipsData = False
                try:
                    originalFileData
                    ipsData = ips.createIps(originalFileData, out)
                except NameError:
                    errorText = 'could not create ips (no original file data)'
                except:
                    errorText = 'could not create ips'
                
                if ipsData:
                    try:
                        with open(filename, 'wb') as file:
                            file.write(bytes(ipsData))
                        print("{} written.".format(filename))
                    except:
                        print("Could not open file.")

            elif k == 'include' or k == 'include?' or k=='incsrc' or k == 'require':
                filename = line.split(" ",1)[1].strip()
                filename = getValueAsString(filename, fallback=True)
                
                if assembler.errorHint:
                    errorText = assembler.errorHint
                    assembler.errorLinePos = len(originalLine.rstrip())-1
                
                if passNum == lastPass and not quiet and filename is str:
                    print(filename.replace("\\","/"))
                
                filename = assembler.findFile(filename)
                if filename:

                    newLines = False
                    try:
                        with open(filename, 'r') as file:
                            newLines = file.read().splitlines()
                    except:
                        print("Could not open file.")
                    
                    if newLines:
                        fileList.append(filename)
                        folder = os.path.split(filename)[0]
                        
                        newLines = ['setincludefolder '+folder]+newLines+['setincludefolder '+assembler.currentFolder]
                        newLines.append(assembler.hidePrefix + 'setCurrentFile "{}"'.format(assembler.currentFilename))
                        assembler.currentFolder = folder
                        assembler.currentFilename = filename
                        
                        lines = lines[:i]+['']+newLines+lines[i+1:]
                        assembler.fileLineNumber = 0
                else:
                    if k == 'include?':
                        pass
                    else:
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
                        errorText = 'file not found'
                        if k == 'require':
                            assembler.printError(errorText, line)
                            break
            elif k == 'includeall':
                folder = line.split(" ",1)[1].strip()
                files = [x for x in os.listdir(folder) if os.path.splitext(x.lower())[1] in ['.asm']]
                files = [x for x in files if not x.startswith('_')]
                lines = lines[:i]+['']+['include {}/{}'.format(folder, x) for x in files]+lines[i+1:]
            elif k == '_shatterhand_import' and passNum == lastPass:
                v = line.split(" ",1)[1].strip()
                if (v.lower() in ['on','true']) or (getValue(v) == 1):
                    assembler.shatter = True
                else:
                    assembler.shatter = False
            elif k == 'echo' and passNum == lastPass:
                v = line.split(" ",1)[1].strip()
                if (v.lower() in ['on','true']) or (getValue(v) == 1):
                    assembler.echoLine = True
                else:
                    assembler.echoLine = False
            elif k == '_test' and passNum == lastPass:
                pass
            elif k == 'print' and passNum == lastPass:
                if oldPrint:
                    v = (line+' ').split(" ",1)[1].strip()
                    print(getString(v))
                else:
                    v = (line+' ').split(" ",1)[1].strip()
                    values = assembler.tokenize(v)
                    for i, value in enumerate(values):
                        if value == "":
                            pass
                        elif assembler.isString(value):
                            values[i] = assembler.stripQuotes(value)
                        else:
                            gv = getValue(value)
                            if type(gv) is list:
                                values[i] = getValue(value, mode='astext')
                            else:
                                values[i] = str(gv)
                    print(' '.join(values))
            elif k == 'printtofile' and passNum == lastPass:
                v = (line+' ').split(" ",1)[1].strip()
                print('> ',getString(v))
                outputText2 += getString(v) + "\n"
            elif k == 'warning' and passNum == lastPass:
                v = line.split(" ",1)[1].strip()
                print('Warning: ' + v)
            elif k == 'error' and passNum == lastPass:
                v = line.split(" ",1)[1].strip()
                raise ValueError(v)
            
            elif k == '_find' and passNum == lastPass:
                data = line.split(' ',1)[1]
                findData = list(bytes.fromhex(''.join(['0'*(len(x)%2) + x for x in data.split()])))
                #b = b + list(bytes.fromhex(''.join(['0'*(len(x)%2) + x for x in data.split()])))
                
                out2 = list(out)
                lenFindData = len(findData)
                lenData = len(out2)
                
                #t = time.time()
                result = [i for i in range(lenData-lenFindData+1) if out2[i:i+lenFindData]==findData]
                #print(time.time()-t)
                
                res = []
                
                if result:
                    for a in result[:20]:
                        
                        a = (a-headerSize)
                        resultBank = math.floor(a/bankSize)
                        a=a-resultBank * bankSize + 0x8000
                        
                        a=a+currentAddress-startAddress
                        
                        print('{:02x}:{:04x}'.format(resultBank,a))
                else:
                    print('0 results.')
            elif k == 'start': # start tilemap
                tilemapName = None
                try:
                    if ' '.join(line.lower().split(None, 2)[0:2]) == 'start tilemap':
                        tilemapName = assembler.lower(line.split(None, 2)[2])
                except:
                    pass
                
                if tilemapName:
                    tilemap = tilemapName
                    tilemaps[tilemap]=Map()
                    tilemaps[tilemap].lines = []
                    tilemaps[tilemap].data = []
            elif k == 'end': # end tilemap
                if ' '.join(line.lower().split(None, 2)[0:2]) == 'end tilemap':
                    tilemaps[tilemap].gridsize = 8
                    for l in tilemaps[tilemap].lines:
                        if l.startswith(('gridsize', 'address', 'palette')):
                            k,v = l.split('=', 1)
                            k = k.lower().strip()
                            v = v.strip()
                            
                            if k in ('gridsize', 'address'):
                                v = int(v, 16)
                            elif k == 'palette':
                                v = pal = [int(v[i:i+2],16) for i in range(0, len(v), 2)]
                            
                            tilemaps[tilemap][k] = v
                        elif l.startswith(('chr', 'org')):
                            k,v = l.split(None, 1)
                            k = k.lower().strip()
                            v = v.strip()
                            
                            tilemaps[tilemap][k] = getValue(v)
                        elif l.strip():
                            try:
                                v = l.split()
                                m = Map()
                                m.id = int(v[0], 16)
                                m.x = int(v[1], 16)
                                m.y = int(v[2], 16)
                                m.flip = v[3:4] and v[3:4][0].lower().strip() or ''
                                m.palette = tilemaps[tilemap].get('palette', False)
                                tilemaps[tilemap].data.append(m)
                            except:
                                # lazy way to handle things like comments for now
                                pass
                    tilemaps[tilemap].lines = None
                    tilemap = False
            elif k == 'macro':
                v = line.split(" ")[1].strip()
                macro = v.lower()
                macros[macro]=Map()
                data = line.split(" ", 2)
                macros[macro].params = (data+[''])[2].replace(',',' ').split()
                macros[macro].lines = []
                noOutput = True
            elif k == 'endm' or k == 'endmacro':
                macro = False
                noOutput = False
            
            if k in macros:
                params = (line.split(" ",1)+[''])[1].replace(',',' ').split()
                
                for item in macros[k].params:
                    if getSymbolInfo(item):
                        symbols.pop(assembler.lower(item))
                
                for item in mergeList(macros[k].params, params):
                    
                    v = item[1]
                    
                    immediate = False
                    sInfo = getSymbolInfo(nsSymbol(v))
                    if sInfo and str(sInfo.get('value','')).startswith('#'):
                        immediate = True
                    
                    if v.startswith('#') or immediate:
                        v = '#'+str(getValue(v))
                    else:
                        v = getValue(v)
                    
                    symbols[k + namespaceSymbol + assembler.lower(item[0])] = v
                    
                assembler.namespace.push(k)
                lines = lines[:i]+['']+macros[k].lines+[assembler.hidePrefix+'namespace _pop_']+lines[i+1:]
            if kf: # keyword function
                if len(kfdata) < len(functions[kf].params):
                    kfdata = kfdata + ['0'] * (len(functions[kf].params) - len(kfdata))
                
                for item in mergeList(functions[kf].params, kfdata):
                    symbols[kf + namespaceSymbol + assembler.lower(item[0])] = getValue(item[1])
                
                assembler.namespace.push(kf)
                symbols['return']=None
                
                lines = lines[:i]+['']+functions[kf].lines+[assembler.hidePrefix+'namespace _pop_']+lines[i+1:]+ ['{}endoffunction {}'.format(assembler.hidePrefix, ifLevel)]
            
            if k == 'pushpc':
                assembler.pcStack.push(currentAddress)
            elif k == 'pushbase':
                assembler.baseStack.push(currentAddress)
            elif k == 'pullpc':
                if assembler.pcStack:
                    k = 'org'
                    v = '${:04x}'.format(assembler.pcStack.pop())
                    line = '{} {}'.format(k,v)
                else:
                    errorText = 'stack is empty'
            elif k == 'pullbase':
                if assembler.baseStack:
                    k = 'base'
                    v = '${:04x}'.format(assembler.baseStack.pop())
                    line = '{} {}'.format(k,v)
                else:
                    errorText = 'stack is empty'
            if k == 'enum':
                v = getValue(line.split(' ',1)[1])
                currentAddress = getValue(v)
                noOutput = True
                
                oldAddr = addr
            elif k == 'ende' or k == 'endenum':
                addr = oldAddr
                currentAddress = addr
                noOutput = False
            elif k == 'base' or (k == 'org' and startAddress==False):
                v = getValue(line.split(' ',1)[1])
                if startAddress == False:
                    startAddress = v
                currentAddress = v
                
            elif k == 'org':
                v = getValue(line.split(' ',1)[1])
                
                if (orgPad == 1) and (startAddress!=False):
                    k = 'org pad'
                else:
                    addr = addr + (v-currentAddress)
                    currentAddress += (v-currentAddress)
                    
                    if startAddress==False:
                        startAddress = addr
                        k = 'pad'
                        line = 'pad ${:04x}'.format(addr)

            if k == 'pad' or k == 'fillto' or k == 'org pad':
                data = line.split(' ',1)[1]
                
                fv = fillValue
                if ',' in data:
                    fv = getValue(data.split(',')[1])
                a = getValue(data.split(',')[0])
                if a-currentAddress != 0:
                    if currentAddress <= a:
                        if ',' not in data and padOrg == 1 and k!='org pad':
                            # pad with original data (asm6n behaviour)
                            fileOffset = int(getSpecial('fileoffset'))
                            b.extend(out[fileOffset:fileOffset+(a-currentAddress)])
                        else:
                            b.extend([fv] * (a-currentAddress))
                        
                    else:
                        if bank:
                            b.extend(([fv] * (a-(addr+bank*bankSize))))
                        else:
                            pass
            elif k == 'fill':
                data = line.split(' ',1)[1]
                
                fv = fillValue
                if ',' in data:
                    fv = getValue(data.split(',')[1])
                n = getValue(data.split(',')[0])
                
                b = b + ([fv] * n)
            elif k == 'align':
                data = line.split(' ',1)[1]
                
                fv = fillValue
                if ',' in data:
                    fv = getValue(data.split(',')[1])
                a = getValue(data.split(',')[0])
                
                b = b + ([fv] * ((a-currentAddress%a)%a))
            elif k in ('fillvalue','fillbyte','padbyte'):
                fillValue = getValue(line.split(' ',1)[1])
            elif k == 'hex':
                data = line.split(' ',1)[1]
                b = b + list(bytes.fromhex(''.join(['0'*(len(x)%2) + x for x in data.split()])))
            elif k == 'dsb' or k == 'ds.b' or k == 'res':
                data = line.split(' ',1)[1]
                n = getValue(data.split(",")[0])
                v = getValue((data.split(",")+['0'])[1])
                b = b + [v] * n
                if k == 'res':
                    noOutputSingle = True
                
            elif k == 'dsw' or k == 'ds.w':
                data = line.split(' ',1)[1]
                n = getValue(data.split(",")[0])
                v = getValue((data.split(",")+['0'])[1])
                b = b + [v % 0x100, v>>8] * n
                
            elif k == "dl":
                values = line.split(' ',1)[1].split(",")
                values = [x.strip() for x in values]
                
                for v in [getValue(x) % 0x100 for x in values]:
                    b = b + makeList(v)
            
            elif k == "dh":
                values = line.split(' ',1)[1].split(",")
                values = [x.strip() for x in values]
                
                for v in [getValue(x) >>8 for x in values]:
                    b = b + makeList(v)
            elif k == 'lineContinueComma':
                v = line.split(' ',1)
                if len(v) == 1:
                    lineContinueComma = True
                else:
                    v = v[1].strip()
                    if (v.lower() in ['on','true']) or (getValue(v) == 1):
                        lineContinueComma = True
                    else:
                        lineContinueComma = False
            elif k == 'mapdb':
                v = line.split(' ',1)
                if len(v) == 1:
                    mapdb = True
                else:
                    v = v[1].strip()
                    if (v.lower() in ['on','true']) or (getValue(v) == 1):
                        mapdb = True
                    else:
                        mapdb = False
            elif k == 'clampdb':
                v = line.split(' ',1)
                if len(v) == 1:
                    clampdb = True
                else:
                    v = v[1].strip()
                    if (v.lower() in ['on','true']) or (getValue(v) == 1):
                        clampdb = True
                    else:
                        clampdb = False
            elif k == 'sprite8x16':
                v = line.split(' ',1)
                if len(v) == 1:
                    assembler.Sprite8x16 = True
                else:
                    v = v[1].strip()
                    if (v.lower() in ['on','true']) or (getValue(v) == 1):
                        assembler.Sprite8x16 = True
                    else:
                        assembler.Sprite8x16 = False
            elif k == 'text' or (k in ('db','dl') and mapdb == True):
                values = line.split(' ',1)[1].strip()
                
                values = assembler.tokenize(values)
                
                for i, v in enumerate(values):
                    if v.startswith(assembler.quotes):
                        values[i] = getValue(v, mode='textmap')
                    else:
                        if k == 'text':
                            values[i] = getValue(v, mode='textmap')
                        else:
                            values[i] = getValue(v)
                
                values = flattenList(values)
                
                if any(x not in range(256) for x in values):
                    if k != 'dl' and clampdb == False:
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
                        errorText = "invalid value"
                    #values = [max(0, x) % 256 for x in values]
                    values = [x % 256 for x in values]
                
                b = b + makeList(values)
            elif k == 'db' or k=='byte' or k == 'byt' or k == 'dc.b' or k == 'dl':
                values = line.split(' ',1)[1]
                
                values = assembler.tokenize(values)
                if '' in values and False: # disable detection of empty values for now
                    l = line.split(' ',1)[1]
                    assembler.errorLinePos = len(','.join(l.split(',')[:values.index('')])) + len(line.split(' ',1)[0]) + 2
                    errorText = "missing value"
                values = [getValue(x) for x in values]
                values = flattenList(values)
                
                if any(x not in range(256) for x in values):
                    if k != 'dl' and clampdb == False:
                        assembler.errorLinePos = len(line.split(' ',1)[0])+1
                        errorText = "invalid value"
                    values = [x % 256 for x in values]
                
                l = len(values)
                
                if l==-1:
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                    errorText = assembler.errorHint or 'value out of range'
                else:
                    values = makeList(values)
                    
                    for value in values:
                        if value>255:
                            assembler.errorLinePos = len(line.split(' ',1)[0])+1
                            errorText = "value out of range"
                            break
                        if value < 0:
                            value += 0x100
                        b = b + [value]
                
            elif k in ('dw', 'word', 'dbyt', 'dc.w'):
                values = line.split(' ',1)[1]
                values, l = getValueAndLength(values)
                
                if l==-1:
                    errorText = assembler.errorHint or 'value out of range'
                    assembler.errorLinePos = len(line.split(' ',1)[0])+1
                else:
                    values = makeList(values)
                    
                    for value in values:
                        if value>65535:
                            errorText = "value out of range"
                            b = b + [0, 0]
                            break
                        if value < 0:
                            value += 0x10000
                        b = b + [value % 0x100, value>>8]
            
            elif (k in opcodes) or (k in opcodes2):
                setLength = False
                if k.endswith('.b'):
                    setLength = 1
                    k = k.rsplit('.b',1)[0]
                elif k.endswith('.w'):
                    setLength = 2
                    k = k.rsplit('.w',1)[0]
                
                # Special handling for pseudo opcode (nop nBytes)
                # Example:
                # nop 6 ; 6 nop instructions
                if k == 'nop':
                    v = (line.split(" ",1)+[''])[1].strip()
                    if v:
                        op = getOpWithMode(k, "Implied") # op will be set to False below
                        b=b+([op.byte] * getValue(v))
                    
                v = "0"
                oldv = v
                
                if k in implied and k.strip() == line.strip().lower():
                    op = getOpWithMode(k, "Implied")
                elif k in accumulator and k.strip() == line.strip().lower():
                    op = getOpWithMode(k, "Accumulator")
                elif line.strip().lower() in [x+' a' for x in accumulator]:
                    op = getOpWithMode(k, "Accumulator")
                else:
                    op = False
                    ops = [x for x in asm if x.opcode==k]
                    
                    v = (line.split(" ",1)+[''])[1].strip()
                    oldv = v
                    v=v.replace(', ',',').replace(' ,',',')
                    immediate = False
                    
                    if v.startswith("#"):
                        vv = getValue(v)
                        if type(vv) is list and len(vv) == 1:
                            # cmp #'N'
                            pass
                        elif type(vv) is list:
                            # attempt to use non-immediate
                            v = v[1:]
                            immediate = False
                        elif v.lower().endswith((',x)',',y)',',x',',y')) or (getValue(v) > 255):
                            v = v[1:]
                            immediate = False

                    sInfo = getSymbolInfo(nsSymbol(v))
                    if sInfo and str(sInfo.get('value','')).startswith('#'):
                        immediate = True
                    
                    # Helps ignore the # when you do this dumb stuff:
                    # lda #$1234
                    # lda #$1234, x
                    # asm6 does this.  should make it a setting
                    if v.startswith("#"):
                        if v.lower().endswith((',x)',',y)',',x',',y')) or (getLength(v) > 1):
                            v = v[1:]
                            immediate = False
                    
                    if k == "jmp" and v.startswith("("):
                        op = getOpWithMode(k, 'Indirect')
                    elif v.lower().endswith('),y'):
                        op = getOpWithMode(k, '(Indirect), Y')
                        
                        length = setLength or getLength(v)
                        if length == 2 and getOpWithMode(k, 'Absolute, Y'):
                            op = getOpWithMode(k, 'Absolute, Y')
                        
                    elif v.lower().endswith(',x)'):
                        op = getOpWithMode(k, '(Indirect, X)')

                        length = setLength or getLength(v)
                    elif v.lower().endswith(',x'):
                        # split using whichever case
                        v = v.split(','+v[-1],1)[0]
                        
                        length = setLength or getLength(v)
                        if length == 1 and getOpWithMode(k, 'Zero Page, X'):
                            op = getOpWithMode(k, 'Zero Page, X')
                        elif getOpWithMode(k, 'Absolute, X'):
                            op = getOpWithMode(k, 'Absolute, X')
                    elif v.lower().endswith(',y'):
                        v = v.split(','+v[-1],1)[0]
                        length = setLength or getLength(v)
                        if length == 1 and getOpWithMode(k, 'Zero Page, Y'):
                            op = getOpWithMode(k, 'Zero Page, Y')
                        elif getOpWithMode(k, 'Absolute, Y'):
                            op = getOpWithMode(k, 'Absolute, Y')
                    elif v.startswith("#"):
                        v = v[1:]
                        op = getOpWithMode(k, 'Immediate')
                        immediate = True
                    elif immediate:
                        op = getOpWithMode(k, 'Immediate')
                    else:
                        length = setLength or getLength(v)
                        if length == 1 and getOpWithMode(k, 'Zero Page'):
                            op = getOpWithMode(k, "Zero Page")
                        elif getOpWithMode(k, "Absolute"):
                            op = getOpWithMode(k, "Absolute")
                        elif getOpWithMode(k, "Relative"):
                            op = getOpWithMode(k, "Relative")
                if op:
                    if op.mode == 'Relative' and passNum == lastPass:
                        v2 = getValue(v)
                        if xkasplusbranch and ('${:02x}'.format(v2) == v.lower()) and (v2 < 0x80):
                            # xkasplus branching quirks
                            #
                            # use the value directly with the opcode if:
                            #    it is in hex, not an expression, less than 0x80,
                            #    and 3 characters long (i.e. not $0010)
                            v = getValue(v)
                        elif v2 == currentAddress+op.length:
                            v = 0
                        elif v2 > currentAddress+op.length:
                            v = v2 - (currentAddress+op.length)
                            v='${:02x}'.format(v)
                        else:
                            v = (currentAddress+op.length) - v2
                            v='${:02x}'.format(0x100 - v)
                    v,l = getValueAndLength(v)
                    l = bytesForNumber(v)
                    
                    if type(v) is str:
                        v = int.from_bytes(v.encode('utf8'),'little')
                    elif type(v) is list:
                        v = int.from_bytes(v,'little')
                    
                    # if lda.b is used with a larger number, 
                    # silently clamp to a byte.
                    if setLength == 1 and l>1:
                        v = v % 0x100
                        l = 1
                    
                    if op.length>0 and v<0:
                        b = [op.byte] + [0] * (op.length-1)
                        errorText= 'value out of range: {}'.format(hex(v))
                    elif oldv == '#' or ((op.length>1) and l==0):
                        b = [op.byte] + [0] * (op.length-1)
                        assembler.errorLinePos = len(line)
                        errorText= 'missing value'
                    elif (op.length>1) and l>op.length:
                        b = [op.byte] + [0] * (op.length-1)
                        assembler.errorLinePos = line.find(oldv)
                        if oldv.startswith('#'):
                            assembler.errorLinePos += 1
                        errorText= 'value out of range: {}'.format(hex(v))
                    else:
                        b = [op.byte]
                        if op.length == 2:
                            b.append(v % 0x100)
                        elif op.length == 3:
                            b.append(v % 0x100)
                            b.append(math.floor(v/0x100))
            
            if k == 'define':
                k = line.split(" ")[1].strip()
                v = line.split(" ",2)[-1].strip()
                if k.startswith(assembler.quotes) and k.endswith(assembler.quotes):
                    k = assembler.stripQuotes(k)
                    assembler.setTextMapData(k, '{:02x}'.format(getValue(v)))
                else:
                    if k == '$':
                        addr = getValue(v)
                        if startAddress == False:
                            startAddress = addr
                        currentAddress = addr
                    else:
                        symbols[assembler.lower(k)] = v
                k=''
            if ' equ ' in line.lower():
                k = line[:line.lower().find(' equ ')]
                v = line[line.lower().find(' equ ')+len(' equ '):]
                equ[k] = v
            
            # Append to array
            if (line.split(',=')+[''])[1] and k!='':
                keyword = line.split(",=",1)[0].strip()
                value = line.split(",=",1)[1].strip()
                symbols[assembler.lower(k)] = getValue('{}, {}'.format(keyword,value), mode='concat')
                k=''
                
            if (line.split('=')+[''])[1] and k!='':
                keyword = line.split("=",1)[0].strip()
                value = line.split("=",1)[1].strip()
                if '(' in value and assembler.lower(value.split('(',1)[0]) in functions:
                    
                    t = assembler.tokenize(keyword)
                    
                    # hide what we can from output
                    prefix = assembler.hidePrefix
                    
                    newLines = []
                    newLines.append(prefix + value.lstrip())
                    
                    if len(t) == 1:
                        newLines.append(f'{prefix}{t[0]} = {{return}}')
                    else:
                        for index, item in enumerate(t):
                            newLines.append(f'{prefix}{item} = {{return[{index}]}}')
                    
                    lines = lines[:i]+['']+newLines+lines[i+1:]
                    k = ''
                    v = False
            
            if (line.split('=')+[''])[1] and k!='':
                k = line.split("=",1)[0].strip()
                v = line.split("=",1)[1].strip()
                
                keywords = [x.strip() for x in k.split(',')]
                if len(keywords)>1:
                    v = getValue(v)
                    if type(v) == list:
                        for i, k in enumerate(keywords):
                            ns = assembler.namespace[-1]
                            if namespaceSymbol in k:
                                ns, k = k.split(namespaceSymbol,1)
                            if ns!='':
                                ns = ns + namespaceSymbol
                            symbols[ns + assembler.lower(k)] = getValue(v[i])
                    
                else:
                    if k == '$':
                        addr = getValue(v)
                        if startAddress == False:
                            startAddress = addr
                        currentAddress = addr
                    else:
                        ns = assembler.namespace[-1]
                        if namespaceSymbol in k:
                            ns, k = k.split(namespaceSymbol,1)
                        if ns!='':
                            ns = ns + namespaceSymbol
                        
                        if '[' in k:
                            index = k.split('[',1)[1].split(']')[0]
                            k = k.split('[')[0]
                            symbols[ns + assembler.lower(k)][getValue(index)] = getValue(v)
                        else:
                            symbols[ns + assembler.lower(k)] = getValue(v)
                    k=''
            
            if len(b)>0:
                invalidBytes = [(i,x) for (i,x) in enumerate(b) if x not in range(256)]
                if len(invalidBytes)!=0:
                    # If we're here it means error handling didn't catch it.
                    errorText= 'invalid bytes: '+str(b)
            
                showAddress = True
                if noOutput==False and noOutputSingle==False and passNum == lastPass:
                    
                    if bank == None:
                        fileOffset = addr
                        if fileOffset == len(out):
                            # We're in the right spot, just append
                            if usenp:
                                out = np.append(out, np.array(b, dtype='B'))
                            else:
                                #out = out + b
                                out.extend(b)
                        elif fileOffset>len(out):
                            fv = fillValue
                            if usenp:
                                out = np.append(out, np.array(([fv] * (fileOffset-len(out))), dtype='B'))
                                out = np.append(out, np.array(b, dtype='B'))
                            else:
                                out = out + ([fv] * (fileOffset-len(out))) + b
                        elif fileOffset<len(out):
                            out[fileOffset:fileOffset+len(b)] = b
                    else:
                        fileOffset = getValue('fileoffset')
                        
                        if fileOffset == len(out):
                            # We're in the right spot, just append
                            
                            if usenp:
                                out = np.append(out, np.array(b, dtype='B'))
                            else:
                                out.extend(b)
                        elif fileOffset>len(out):
                            fv = fillValue
                            if usenp:
                                out = np.append(out, np.array(([fv] * (fileOffset-len(out))), dtype='B'))
                                out = np.append(out, np.array(b, dtype='B'))
                            else:
                                out = out + ([fv] * (fileOffset-len(out))) + b
                        elif fileOffset<len(out):
                            out[fileOffset:fileOffset+len(b)] = b
                if noOutput==False and noOutputSingle==False:
                    addr = addr + len(b)
                currentAddress = currentAddress + len(b)
            
            if assembler.hideOutputLine:
                assembler.hideOutputLine = False
            elif passNum == lastPass and not hide:
                nBytes = cfg.getValue('main', 'list_nBytes')
                
                fileOffset = getValue('fileoffset')
                
                if noOutput==False and noOutputSingle==False:
                    fileOffset -= len(b)
                
                if showFileOffsetInListFile:
                    outputText+="{:05X} ".format(fileOffset)

                if showBankInListFile:
                    if bank == None:
                        outputText+="   "
                    else:
                        outputText+="{:02X}:".format(bank)

                if startAddress or ((noOutput == True) or (noOutputSingle==True)):
                    outputText+="{:05X} ".format(currentAddress-len(b))
                else:
                    outputText+=' '*6
                
                if nBytes == 0:
                    outputText+="{}\n".format(originalLine)
                else:
                    listBytes = False
                    if noOutput or noOutputSingle:
                        listBytes = ' '*(3*nBytes+1)
                    else:
                        listBytes = ' '.join(['{:02X}'.format(x) for x in b[:nBytes]]).ljust(3*nBytes-1) + ('..' if len(b)>nBytes else '  ')
                        
                        # Special coding so insert directive looks ok
                        if k == 'insert':
                            v, fv = assembler.insert
                            insertBytes = [fv] * min(v, nBytes)
                            listBytes = ' '.join(['{:02X}'.format(x) for x in insertBytes]).ljust(3*nBytes-1) + ('..' if v>nBytes else '  ')
                    
                    if (not assembler.expectedWait) and assembler.expected and (listBytes.strip() != assembler.expected):
                        errorText = 'Data and expected not matching\n'.format(listBytes.strip())
                        errorText += '  Data:     {}\n'.format(listBytes.strip())
                        errorText += '  Expected: {}\n'.format(assembler.expected)
                    outputText+="{} {}\n".format(listBytes, originalLine)


                    if k == 'gg':
                        v = assembler.gg.get('value')
                        for a, ov in zip(assembler.gg.get('addresses'), assembler.gg.get('oldValues')):
                            outputText+='{:05X} '.format(a)

                            if startAddress or ((noOutput == True) or (noOutputSingle==True)):
                                outputText+="{:05X} ".format(currentAddress-len(b))
                            else:
                                outputText+=' '*6
                            outputText+='{:02X} {} '.format(v, ' '*(3*(nBytes-1)+1))
                            outputText+='gg info: {} ({:04X}:{:02X}'.format(assembler.gg.get('ggCode'), assembler.gg.get('address'), assembler.gg.get('value'))
                            if assembler.gg.get('compare'):
                                outputText+=':{:02x}'.format(assembler.gg.get('compare'))
                            outputText+=') ${:02x} --> ${:02}'.format(ov, v)
                            outputText+='\n'
                if assembler.suppressError:
                    assembler.suppressError = False
                    errorText = False
                if errorText:
                    assembler.warnings += 1
                    
                    if assembler.errorLinePos:
                        outputText +=' '*38 + ' '*assembler.errorLinePos+'^\n'
                    outputText+='*** {}\n'.format(errorText)
                    outputText+='    {}\n'.format(assembler.currentFilename)
                    
                    print(originalLine)
                    if assembler.errorLinePos:
                        print(' '*assembler.errorLinePos+'^')
                    print('*** {}'.format(errorText))
                    print('    {}\n'.format(assembler.currentFilename))
                    errorText = False
                    assembler.errorLinePos = False
            if k==".org": showAddress = True
            noOutputSingle = False
            if passNum == lastPass and (time.time() - lineTime>2):
                print(originalLine)
                print('Line time: ' + elapsed(lineTime))
    
    # output:
    if set(out).issubset(set(range(256))):
        # contains only valid bytes
        pass
    else:
        print('Invalid bytes found.  Processing...')
        # This list comprehension is very slow.
        invalidBytes = [(i,x) for (i,x) in enumerate(out) if x not in range(256)]
        if len(invalidBytes)!=0:
            outputText+='*** Invalid bytes:'
            print('Invalid bytes:')
            for a,b in invalidBytes:
                outputText += '{:05x}: {:02x}'.format(a,b)
                print('{:05x}: {:02x}'.format(a,b))
                out[a] = 0
    print('done.')
    
    assembler.currentFilename = None
    assembler.line = ''
    assembler.lineNumber = 0
    assembler.fileLineNumber = 0
    
    if assembler.warnings > 0:
        print('Warnings: {}'.format(assembler.warnings))
    
    assembler.outputFilename = outputFilename
    assembler.listFilename = listFilename
    assembler.printFilename = printFilename
    
    if outputFilename:
        with open(outputFilename, "wb") as file:
            if assembler.stripHeader:
                out = out[16:]
            
            file.write(bytes(out))
            print('{} written.'.format(outputFilename))
    else:
        print("No output file")
    
    outputTopper = ''
    outputTopper+= 'Assembled with sdasm\n\n'


    if out[0:4] == list(bytearray("NES", 'utf8')) + [0x1a]:
        outputTopper+= 'PRG Banks:{}\nCHR Banks:{}\nMapper: {}\n'.format(
            getSpecial('prgbanks'),
            getSpecial('chrbanks'),
            getSpecial('mapper'),
        )
    else:
        outputTopper+= "No header\n"

    topperBase = [
        '_____ __ _____ _________________________ ________________________________________',
        'file |ba|prg  | bytes                   | asm code',
        'offst|nk|addr |                         |',
        '-----|--|-----|-------------------------|----------------------------------------',
    ]
    
    if not showBankInListFile:
        topperBase = [replaceStringByIndex(l, 6,9) for l in topperBase]
    if not showFileOffsetInListFile:
        topperBase = [replaceStringByIndex(l, 0,6) for l in topperBase]
    
    outputTopper+= '\n'.join(topperBase) + '\n'
    
    outputText = outputTopper + outputText
    
    if listFilename:
        with open(listFilename, 'w') as file:
            print(outputText, file=file)
            print('{} written.'.format(listFilename))
    else:
        print('No list file')
    
    if printFilename:
        with open(printFilename, 'w') as file:
            print(outputText2, file=file)
            print('{} written.'.format(printFilename))
    else:
        pass
        #print('No print file')
    
    if debug and not symbolsFile:
        symbolsFile = 'debug_symbols.txt'
    
    if symbolsFile:
        with open(symbolsFile, "w") as file:
            for k,v in symbols.items():
                print('{} = {}'.format(k,v), file=file)
        print('{} written.'.format(symbolsFile))
    if debug:
        f = 'debug_files.txt'
        with open(f, "w") as file:
            file.write('\n'.join(fileList))
        print('{} written.'.format(f))
    print()
    
if __name__ == '__main__' or sys.argv[0] == 'NESBuilder:asm':
    import argparse

    parser = argparse.ArgumentParser(description='ASM 6502 Assembler made in Python')
    
    parser.add_argument('-l', type=str, metavar="<file>",
                        help='Create a list file')
    parser.add_argument('-bin', type=str, metavar="<file>",
                        help='Include binary file')
    parser.add_argument('-cfg', type=str, metavar="<file>",
                        help='Specify config file')
    parser.add_argument('-fulltb', action='store_true',
                        help='Show full traceback')
    parser.add_argument('-d', type=str, metavar="<symbol>",
                        help='Define symbol')
    parser.add_argument('-q', action='store_true',
                        help='Quiet mode')
    parser.add_argument('-symbols', type=str, metavar="<file>",
                        help='Specify export symbols file')
    parser.add_argument('sourcefile', type=str,
                        help='The file to assemble')
    parser.add_argument('outputfile', type=str, nargs='?',
                        help='The output file')
    
    print('sdasm {} by {}\n{}\n'.format(version.get('version'), version.get('author'), version.get('url')))
    
    args = parser.parse_args()

    filename = args.sourcefile
    outputFilename = args.outputfile
    listFilename = args.l
    configFile = args.cfg
    binFile = args.bin
    symbolsFile = args.symbols
    defineSymbol = args.d
    quiet = args.q
    
    success, errorText = assemble(filename, outputFilename = outputFilename, listFilename = listFilename, configFile = configFile, binFile = binFile, symbolsFile = symbolsFile, quiet=quiet, defineSymbol=defineSymbol)
    
    if not success:
        print(errorText)
        sys.exit(3)
