demoGame = 1


if demoGame

{		; header
prgbanks = 1				
inesprg prgbanks

chrbanks = 1
ineschr chrbanks

inesmap 0
;inesbattery
}

{		; ppu.inc 
MIN_BRIGHTNESS_LEVEL = 0
MAX_BRIGHTNESS_LEVEL = 4
FADING_SPEED = 5

;bit positions for PPU control register $2000
PPU0_EXECUTE_NMI = 7
PPU0_MASTER_SLAVE = 6
PPU0_SPRITE_SIZE = 5
PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS = 4
PPU0_SPRITE_PATTERN_TABLE_ADDRESS = 3
PPU0_ADDRESS_INCREMENT = 2
PPU0_NAMETABLE_ADDRESS1 = 1
PPU0_NAMETABLE_ADDRESS0 = 0

;bit positions for PPU control register $2001
PPU1_FULL_BACKGROUND_COLOR_2 = 7
PPU1_FULL_BACKGROUND_COLOR_1 = 6
PPU1_FULL_BACKGROUND_COLOR_0 = 5
PPU1_COLOR_INTENSITY_2 = 7
PPU1_COLOR_INTENSITY_1 = 6
PPU1_COLOR_INTENSITY_0 = 5
PPU1_SPRITE_VISIBILITY = 4
PPU1_BACKGROUND_VISIBILITY = 3
PPU1_SPRITE_CLIPPING = 2
PPU1_BACKGROUND_CLIPPING = 1
PPU1_DISPLAY_TYPE = 0

macro set_ppu_2006 nametable, row, column

    lda #nametable
    ;or in the upper two bits of row
    ora #(row >> 3)
    sta $2006
    lda #column
    ;or in the lower three bits of row
    ora #<(row << 5)
    sta $2006

endm

;also sets ppu 2006 but uses absolute rather than immediate addressing
macro set_ppu_2006_abs nametable, row, column

    ;get the upper two bits of row
    lda row
    lsr
    lsr
    lsr
    ;or in the nametable bits
    ora nametable
    sta ppu_2006
    ;get the lower three bits of row
    lda row
    asl
    asl
    asl
    asl
    asl
    ;or in the column
    ora column
    sta ppu_2006+1

endm

macro set_ppu_2000_bit bit_position

    ;load the current state of the ppu register
    lda ppu_2000
    ora #( 1 << bit_position )
    sta ppu_2000

endm

macro clear_ppu_2000_bit bit_position

    ;load the current state of the ppu register
    lda ppu_2000
    and #( ~( 1 << bit_position ) )
    sta ppu_2000

endm

macro set_ppu_2001_bit bit_position

    ;load the current state of the ppu register
    lda ppu_2001
    ora #(1 << bit_position)
    sta ppu_2001

endm

macro clear_ppu_2001_bit bit_position

    ;load the current state of the ppu register
    lda ppu_2001
    and #( ~( 1 << bit_position ) )
    sta ppu_2001

endm

macro upload_ppu_2000

    lda ppu_2000
    sta $2000

endm

macro upload_ppu_2001

    lda ppu_2001
    sta $2001

endm

macro upload_ppu_2005

    lda ppu_2005
    sta $2005
    lda ppu_2005+1
    sta $2005

endm

macro upload_ppu_2006

    lda ppu_2006
    sta $2006
    lda ppu_2006+1
    sta $2006

endm

macro wait_vblank

-
    bit $2002
    bpl -

endm

macro wait_vblank_done

;wait til vblank says it is done
-
    lda vblank_done_flag
    beq -

endm

;clear the vblank done flag (usually used right before a wait,
;so that we can be certain we're outside of vblank and not about
;to be interrupted)
macro clear_vblank_done

    lda #0
    sta vblank_done_flag

endm

;set the vblank done flag.
;use this flag to determine when it is safe to
;operate on the PPU when graphics are off, or swap out the
;indirect vblank_routine itself.
macro set_vblank_done

    lda #1
    sta vblank_done_flag

endm
}

{		; controller.inc 
buttons_a      = 0
buttons_b      = 1
buttons_select = 2
buttons_start  = 3
buttons_up     = 4
buttons_down   = 5
buttons_left   = 6
buttons_right  = 7
}

{		; sprite.inc 
sprite_struct_ycoord = 0
sprite_struct_tile = 1
sprite_struct_attribute = 2
sprite_struct_xcoord = 3
}

endif



{		; ggsound.inc 

;Comment out these equates for features you do not wish to use.
FEATURE_DPCM = 1
FEATURE_ARPEGGIOS = 1

ifdef FEATURE_DPCM
DPCM_STATE_NOP = 0
DPCM_STATE_UPLOAD = 1
DPCM_STATE_UPLOAD_THEN_WAIT = 2
DPCM_STATE_WAIT = 3
endif

;Max number of music streams, sfx streams, and max total streams
;based on whether dpcm is enabled. soundeffect_one and soundeffect_two
;are always to be used when specifying sound effect priority.
ifdef FEATURE_DPCM
MAX_MUSIC_STREAMS = 5
soundeffect_one = 5
soundeffect_two = 6
else
MAX_MUSIC_STREAMS = 4
soundeffect_one = 4
soundeffect_two = 5
endif
MAX_SFX_STREAMS = 2
MAX_STREAMS = (MAX_MUSIC_STREAMS + MAX_SFX_STREAMS)

;****************************************************************
;The following are all opcodes. All opcodes in range 0-86 are
;interpreted as a note playback call. Everything 87 or above
;are interpreted as stream control opcodes.
;****************************************************************

C0  = 0
CS0 = 1
D0  = 2
DS0 = 3
E0  = 4
F0  = 5
FS0 = 6
G0  = 7
GS0 = 8
A0  = 9
AS0 = 10
B0  = 11
C1  = 12
CS1 = 13
D1  = 14
DS1 = 15
E1  = 16
F1  = 17
FS1 = 18
G1  = 19
GS1 = 20
A1  = 21
AS1 = 22
B1  = 23
C2  = 24
CS2 = 25
D2  = 26
DS2 = 27
E2  = 28
F2  = 29
FS2 = 30
G2  = 31
GS2 = 32
A2  = 33
AS2 = 34
B2  = 35
C3  = 36
CS3 = 37
D3  = 38
DS3 = 39
E3  = 40
F3  = 41
FS3 = 42
G3  = 43
GS3 = 44
A3  = 45
AS3 = 46
B3  = 47
C4  = 48
CS4 = 49
D4  = 50
DS4 = 51
E4  = 52
F4  = 53
FS4 = 54
G4  = 55
GS4 = 56
A4  = 57
AS4 = 58
B4  = 59
C5  = 60
CS5 = 61
D5  = 62
DS5 = 63
E5  = 64
F5  = 65
FS5 = 66
G5  = 67
GS5 = 68
A5  = 69
AS5 = 70
B5  = 71
C6  = 72
CS6 = 73
D6  = 74
DS6 = 75
E6  = 76
F6  = 77
FS6 = 78
G6  = 79
GS6 = 80
A6  = 81
AS6 = 82
B6  = 83
C7  = 84
CS7 = 85
D7  = 86
DS7 = 87
E7  = 88
F7  = 89
FS7 = 90
G7  = 91
GS7 = 92
A7  = 93
AS7 = 94
B7  = 95

HIGHEST_NOTE = B7

OPCODES_BASE = 96

;stream control opcodes

;set length opcodes for standard note lengths
SL1 = 0  + OPCODES_BASE
SL2 = 1  + OPCODES_BASE
SL3 = 2  + OPCODES_BASE
SL4 = 3  + OPCODES_BASE
SL5 = 4  + OPCODES_BASE
SL6 = 5  + OPCODES_BASE
SL7 = 6  + OPCODES_BASE
SL8 = 7  + OPCODES_BASE
SL9 = 8  + OPCODES_BASE
SLA = 9  + OPCODES_BASE
SLB = 10 + OPCODES_BASE
SLC = 11 + OPCODES_BASE
SLD = 12 + OPCODES_BASE
SLE = 13 + OPCODES_BASE
SLF = 14 + OPCODES_BASE
SL0 = 15 + OPCODES_BASE

;set length lo byte
SLL = 16+OPCODES_BASE

;set length hi byte
SLH = 17+OPCODES_BASE

;set instrument
STI = 18+OPCODES_BASE

;goto
GOT = 19+OPCODES_BASE

;call
CAL = 20+OPCODES_BASE

;return
RET = 21+OPCODES_BASE

;terminate
TRM = 22+OPCODES_BASE

ifdef FEATURE_ARPEGGIOS
;set arpeggio envelope
SAR = 25+OPCODES_BASE
endif

;opcodes read from volume and pitch envelopes. These values are also
;reserved by Famitracker, so they are safe to use.
ENV_STOP = %10000000 ;-128
ENV_LOOP = %01111111 ; 127

;a different set of opcodes for stop and loop for duty cycle envelopes.
;This is necessary since ENV_STOP can be intepreted as duty cycle = 2,
;preventing users from using that setting.
DUTY_ENV_STOP = %00111111
DUTY_ENV_LOOP = %00101010

;these opcodes exist at the start of any arpeggio envelope to indicate
;how the arpeggio is to be executed.
ARP_TYPE_ABSOLUTE = 0
ARP_TYPE_FIXED    = 1
ARP_TYPE_RELATIVE = 2

;values for stream flags
STREAM_ACTIVE_SET         = %00000001
STREAM_ACTIVE_TEST        = %00000001
STREAM_ACTIVE_CLEAR       = %11111110

STREAM_SILENCE_SET        = %00000010
STREAM_SILENCE_TEST       = %00000010
STREAM_SILENCE_CLEAR      = %11111101

STREAM_PAUSE_SET          = %00000100
STREAM_PAUSE_TEST         = %00000100
STREAM_PAUSE_CLEAR        = %11111011

STREAM_PITCH_LOADED_SET   = %00001000
STREAM_PITCH_LOADED_TEST  = %00001000
STREAM_PITCH_LOADED_CLEAR = %11110111

;default tempo.
DEFAULT_TEMPO = 256 * 15

;Region constants.
SOUND_REGION_NTSC = 0
SOUND_REGION_PAL  = 1
SOUND_REGION_DENDY = 2

track_header_ntsc_tempo_lo            = 0
track_header_ntsc_tempo_hi            = 1
track_header_pal_tempo_lo             = 2
track_header_pal_tempo_hi             = 3
track_header_square1_stream_address   = 4
track_header_square2_stream_address   = 6
track_header_triangle_stream_address  = 8
track_header_noise_stream_address     = 10
ifdef FEATURE_DPCM
track_header_dpcm_stream_address      = 12
endif

instrument_header_volume_offset = 0
instrument_header_pitch_offset = 1
instrument_header_duty_offset = 2
instrument_header_arpeggio_offset = 3
instrument_header_arpeggio_type = 4

macro advance_stream_read_address

    inc stream_read_address_lo,x
    bne +
    inc stream_read_address_hi,x
+

endm

;this macro updates the sound engine. It is intended to
;be used at the end of an nmi routine, after ppu synchronization.
macro soundengine_update

    lda sound_disable_update
    bne +

    jsr sound_update
    jsr sound_upload

+

endm

}


base $0000
enum $0000
{		; demo_zp.inc 

b0: .dsb 1
b1: .dsb 1
b2: .dsb 1
b3: .dsb 1
b4: .dsb 1
b5: .dsb 1
b6: .dsb 1
b7: .dsb 1
b8: .dsb 1
b9: .dsb 1
b10: .dsb 1
b11: .dsb 1

w0:  .dsb 2
w1:  .dsb 2
w2:  .dsb 2
w3:  .dsb 2
w4:  .dsb 2
w5:  .dsb 2
w6:  .dsb 2
w7:  .dsb 2
w8:  .dsb 2
w9:  .dsb 2
w10: .dsb 2
w11: .dsb 2
w12: .dsb 2
w13: .dsb 2
w14: .dsb 2
w15: .dsb 2
w16: .dsb 2
w17: .dsb 2
w18: .dsb 2
w19: .dsb 2
w20: .dsb 2
ppu_2000: .dsb 1
ppu_2001: .dsb 1
ppu_2005: .dsb 1
ppu_2006: .dsb 1
palette_address: .dsb 2
controller_buffer: .dsb 8
vblank_routine: .dsb 2
vblank_done_flag: .dsb 1
current_song: .dsb 1
pause_flag: .dsb 1
next_sprite_address: .dsb 1
nmis: .dsb 1
}

{		; ggsound_zp.inc 

sound_region: .dsb 1
sound_disable_update: .dsb 1
sound_local_byte_0: .dsb 1
sound_local_byte_1: .dsb 1
sound_local_byte_2: .dsb 1

sound_local_word_0: .dsb 2
sound_local_word_1: .dsb 2
sound_local_word_2: .dsb 2

sound_param_byte_0: .dsb 1
sound_param_byte_1: .dsb 1
sound_param_byte_2: .dsb 1

sound_param_word_0: .dsb 2
sound_param_word_1: .dsb 2
sound_param_word_2: .dsb 2
sound_param_word_3: .dsb 2

base_address_instruments: .dsb 2
base_address_note_table_lo: .dsb 2
base_address_note_table_hi: .dsb 2
ifdef FEATURE_DPCM
base_address_dpcm_sample_table: .dsb 2
base_address_dpcm_note_to_sample_index: .dsb 2
base_address_dpcm_note_to_sample_length: .dsb 2
base_address_dpcm_note_to_loop_pitch_index: .dsb 2
endif

apu_data_ready: .dsb 1
apu_square_1_old: .dsb 1
apu_square_2_old: .dsb 1
ifdef FEATURE_DPCM
apu_dpcm_state: .dsb 1
endif

song_list_address: .dsb 2
sfx_list_address: .dsb 2
song_address: .dsb 2
apu_register_sets: .dsb 20

}
ende 


base $0200
enum $0200
{		; demo_ram.inc 
sprite:	.dsb 256
	
}

{		; ggsound_ram.inc 

stream_flags:                  .dsb MAX_STREAMS
stream_note:                   .dsb MAX_STREAMS
stream_note_length_lo:         .dsb MAX_STREAMS
stream_note_length_hi:         .dsb MAX_STREAMS
stream_note_length_counter_lo: .dsb MAX_STREAMS
stream_note_length_counter_hi: .dsb MAX_STREAMS
stream_instrument_index:       .dsb MAX_STREAMS
stream_volume_offset:          .dsb MAX_STREAMS
stream_arpeggio_offset:        .dsb MAX_STREAMS
stream_pitch_offset:           .dsb MAX_STREAMS
stream_duty_offset:            .dsb MAX_STREAMS

stream_channel:                .dsb MAX_STREAMS
stream_channel_register_1:     .dsb MAX_STREAMS
stream_channel_register_2:     .dsb MAX_STREAMS
stream_channel_register_3:     .dsb MAX_STREAMS
stream_channel_register_4:     .dsb MAX_STREAMS

stream_read_address_lo:        .dsb MAX_STREAMS
stream_read_address_hi:        .dsb MAX_STREAMS
stream_return_address_lo:      .dsb MAX_STREAMS
stream_return_address_hi:      .dsb MAX_STREAMS

stream_tempo_counter_lo:       .dsb MAX_STREAMS
stream_tempo_counter_hi:       .dsb MAX_STREAMS
stream_tempo_lo:               .dsb MAX_STREAMS
stream_tempo_hi:               .dsb MAX_STREAMS

}
ende 



base $C000

if demoGame  

{		; get_tv_system.asm 

; NES TV system detection code
; Copyright 2011 Damian Yerrick
;
; Copying and distribution of this file, with or without
; modification, are permitted in any medium without royalty provided
; the copyright notice and this notice are preserved in any source
; code copies.  This file is offered as-is, without any warranty.
;

align 32

;;
; Detects which of NTSC, PAL, or Dendy is in use by counting cycles
; between NMIs.
;
; NTSC NES produces 262 scanlines, with 341/3 CPU cycles per line.
; PAL NES produces 312 scanlines, with 341/3.2 CPU cycles per line.
; Its vblank is longer than NTSC, and its CPU is slower.
; Dendy is a Russian famiclone distributed by Steepler that uses the
; PAL signal with a CPU as fast as the NTSC CPU.  Its vblank is as
; long as PAL's, but its NMI occurs toward the end of vblank (line
; 291 instead of 241) so that cycle offsets from NMI remain the same
; as NTSC, keeping Balloon Fight and any game using a CPU cycle-
; counting mapper (e.g. FDS, Konami VRC) working.
;
; nmis is a variable that the NMI handler modifies every frame.
; Make sure your NMI handler finishes within 1500 or so cycles (not
; taking the whole NMI or waiting for sprite 0) while calling this,
; or the result in A will be wrong.
;
; @return A: TV system (0: NTSC, 1: PAL, 2: Dendy; 3: unknown
;         Y: high byte of iterations used (1 iteration = 11 cycles)
;         X: low byte of iterations used
get_tv_system:
  ldx #0
  ldy #0
  lda nmis
@nmiwait1:
  cmp nmis
  beq @nmiwait1
  lda nmis

@nmiwait2:
  ; Each iteration takes 11 cycles.
  ; NTSC NES: 29780 cycles or 2707 = $A93 iterations
  ; PAL NES:  33247 cycles or 3022 = $BCE iterations
  ; Dendy:    35464 cycles or 3224 = $C98 iterations
  ; so we can divide by $100 (rounding down), subtract ten,
  ; and end up with 0=ntsc, 1=pal, 2=dendy, 3=unknown
  inx
  bne @skip_iny
  iny
@skip_iny:
  cmp nmis
  beq @nmiwait2
  tya
  sec
  sbc #10
  cmp #3
  bcc @notAbove3
  lda #3
@notAbove3:
  rts

}

{		; sprite.asm 

;this routine uses the same data structure as metasprites, but it
;is intended for a full screen overlay for cut-scenes.
;expects w0 to be address to the sprite overlay to draw
sprite_draw_overlay:
count = b0

  ldy #0
  lda (w0),y
  sta count

  clc
  lda w0
  adc #1
  sta w0
  lda w0+1
  adc #0
  sta w0+1

  ldx next_sprite_address

-
  ldy #sprite_struct_ycoord
  sec
  lda (w0),y
  sbc #1
  sta sprite,x
  inx

  ldy #sprite_struct_tile
  lda (w0),y
  sta sprite,x
  inx

  ldy #sprite_struct_attribute
  lda (w0),y
  sta sprite,x
  inx

  ldy #sprite_struct_xcoord
  lda (w0),y
  sta sprite,x
  inx

  stx next_sprite_address

  clc
  lda w0
  adc #5
  sta w0
  lda w0+1
  adc #0
  sta w0+1

  dec count
  bne -

  rts

}

{		; ppu.asm 

;expects palette_address to have address of palette
ppu_load_palette:
    ldy #0
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
-
    lda (palette_address),y
    sta $2007
    inx
    iny
    cpx #$20
    bne -
    rts

ppu_load_palette_bg:
    ldy #0
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
-
    lda (w0),y
    sta $2007
    inx
    iny
    cpx #$10
    bne -
    rts

ppu_load_black_palette:
    ldy #0
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
    lda #$0e
-
    sta $2007
    inx
    iny
    cpx #$20
    bne -
    rts

;loads a nametable and attribute table located at address in w0
;assumes VRAM points to the nametable that is to be loaded
ppu_load_nametable:
    ldy #$00
    ldx #$04
-
    lda (w0),y
    sta $2007
    iny
    bne -
    inc w0+1
    dex
    bne -

    rts

}

{		; controller.asm 

;Deserializes the controller into a buffer.
;output: controller_buffer
controller_read:

    jsr read_joy

    ;a
    ror
    rol controller_buffer

    ;b
    ror
    rol controller_buffer+1

    ;select
    ror
    rol controller_buffer+2

    ;start
    ror
    rol controller_buffer+3

    ;up
    ror
    rol controller_buffer+4

    ;down
    ror
    rol controller_buffer+5

    ;left
    ror
    rol controller_buffer+6

    ;right
    ror
    rol controller_buffer+7

    rts

;****************************************************************
;The following DMC safe controller reading code was adapted from
;read_joy3, created by blargg of NESDEV.
;****************************************************************
align 32
; Reads controller into A.
; Reliable even if DMC is playing.
; Preserved: X, Y
; Time: ~660 clocks
read_joy:
temp = b0
temp2 = b1
temp3 = b2
    jsr read_joy_fast
    sta <(temp3)
    jsr read_joy_fast
    pha
    jsr read_joy_fast
    sta <(temp2)
    jsr read_joy_fast

    ; All combinations of one controller
    ; change and one DMC DMA corruption
    ; leave at least two matching readings,
    ; and never just the first and last
    ; matching. No more than one DMC DMA
    ; corruption can occur.

    ; X--X can't occur
    pla
    cmp <(temp3)
    beq +         ; XX--
    cmp <(temp)
    beq +         ; -X-X

    lda <(temp2)  ; X-X-
            ; -XX-
            ; --XX
+   cmp #0
    rts

; Reads controller into A and temp.
; Unreliable if DMC is playing.
; Preserved: X, Y
; Time: 153 clocks

read_joy_fast:
    ; Strobe controller
    lda #1          ; 2
    sta $4016       ; 4
    lda #0          ; 2
    sta $4016       ; 4

    ; Read 8 bits
    lda #$80        ; 2
    sta <(temp)     ; 3
-   lda $4016       ; *4

    ; Merge bits 0 and 1 into carry. Normal
    ; controllers use bit 0, and Famicom
    ; external controllers use bit 1.
    and #$03        ; *2
    cmp #$01        ; *2

    ror <(temp)   ; *5
    bcc -         ; *3
                  ; -1
    lda <(temp)   ; 3
    rts           ; 6

}

{		; demo data code 

palette:
    db $0e,$08,$18,$20,$0e,$0e,$12,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
    db $0e,$0e,$09,$1a,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

tv_system_to_sound_region:
    db SOUND_REGION_NTSC, SOUND_REGION_PAL, SOUND_REGION_DENDY, SOUND_REGION_NTSC

reset:
    ;Set interrupt disable flag.
    sei

    ;Clear binary encoded decimal flag.
    cld

    ;Disable APU frame IRQ.
    lda #$40
    sta $4017

    ;Initialize stack.
    ldx #$FF
    txs

    ;Turn off all graphics, and clear PPU registers.
    lda #$00
    sta ppu_2000
    sta ppu_2001
    upload_ppu_2000
    upload_ppu_2001

    ;Disable DMC IRQs.
    lda #$00
    sta $4010

    ;Clear the vblank flag, so we know that we are waiting for the
    ;start of a vertical blank and not powering on with the
    ;vblank flag spuriously set.
    bit $2002

    ;Wait for PPU to be ready.
    wait_vblank
    wait_vblank

    ;Install nmi routine for just counting nmis (detecting system)
    lda #<(vblank_get_tv_system)
    sta vblank_routine
    lda #>(vblank_get_tv_system)
    sta vblank_routine+1

    ;Initialize ppu registers with settings we're never going to change.
    set_ppu_2000_bit PPU0_EXECUTE_NMI
    set_ppu_2001_bit PPU1_SPRITE_CLIPPING
    set_ppu_2001_bit PPU1_BACKGROUND_CLIPPING
    clear_ppu_2000_bit PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS
    set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS
    upload_ppu_2000
    upload_ppu_2001

    ;Load palette.
    lda #<(palette)
    sta palette_address
    lda #>(palette)
    sta palette_address+1
    jsr ppu_load_palette

    ;Load nametable.
    lda #$20
    sta ppu_2006
    lda #$00
    sta ppu_2006+1
    upload_ppu_2006
    lda #<(name_table)
    sta w0
    lda #>(name_table)
    sta w0+1
    jsr ppu_load_nametable

    lda #0
    sta next_sprite_address

    ;Draw sprite overlay.
    lda #<(sprite_overlay)
    sta w0
    lda #>(sprite_overlay)
    sta w0+1
    jsr sprite_draw_overlay

    ;Get the sprites on the screen.
    lda #>(sprite)
    sta $4014

    lda #$20
    sta ppu_2006+1
    lda #0
    sta ppu_2006
    sta ppu_2005
    lda #-8
    sta ppu_2005+1
    upload_ppu_2006
    upload_ppu_2005

    ;Turn on graphics and sprites.
    set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
    set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
    upload_ppu_2001

    lda #0
    sta current_song
    sta pause_flag

    wait_vblank

    ;initialize modules
    lda #0
    sta nmis
    jsr get_tv_system
    tax
    lda tv_system_to_sound_region,x
    sta sound_param_byte_0
    lda #<(song_list)
    sta sound_param_word_0
    lda #>(song_list)
    sta sound_param_word_0+1
    lda #<(sfx_list)
    sta sound_param_word_1
    lda #>(sfx_list)
    sta sound_param_word_1+1
    lda #<(instrument_list)
    sta sound_param_word_2
    lda #>(instrument_list)
    sta sound_param_word_2+1
    lda #<dpcm_list
    sta sound_param_word_3
    lda #>dpcm_list
    sta sound_param_word_3+1
    jsr sound_initialize
    ;load a song
    lda current_song
    sta sound_param_byte_0
    jsr play_song

    lda #<(vblank_demo)
    sta vblank_routine
    lda #>(vblank_demo)
    sta vblank_routine+1

main_loop:
    clear_vblank_done
    wait_vblank_done

    jsr controller_read

    lda controller_buffer+buttons_a
    and #%00000011
    cmp #%00000001
    bne skipa

    lda #sfx_index_sfx_collide
    sta sound_param_byte_0
    lda #soundeffect_one
    sta sound_param_byte_1
    jsr play_sfx

skipa:

    lda controller_buffer+buttons_b
    and #%00000011
    cmp #%00000001
    bne skipb

    lda #sfx_index_sfx_dpcm
    sta sound_param_byte_0
    lda #soundeffect_two
    sta sound_param_byte_1
    jsr play_sfx

skipb:

    lda controller_buffer+buttons_up
    and #%00000011
    cmp #%00000001
    bne skipup

    inc current_song
    lda current_song
    cmp #7
    bne +
    lda #6
    sta current_song
+

    lda current_song
    sta sound_param_byte_0
    jsr play_song

skipup:

    lda controller_buffer+buttons_down
    and #%00000011
    cmp #%00000001
    bne skipdown

    dec current_song
    lda current_song
    cmp #$ff
    bne +
    lda #0
    sta current_song
+

    lda current_song
    sta sound_param_byte_0
    jsr play_song
skipdown:

    lda controller_buffer+buttons_start
    and #%00000011
    cmp #%00000001
    bne skipstart

    lda pause_flag
    eor #1
    sta pause_flag
    lda pause_flag
    bne paused
unpaused:

    jsr resume_song

    jmp done
paused:

    jsr pause_song

done:

skipstart:

    jmp main_loop

vblank_get_tv_system:
    inc nmis
    rts

vblank_demo:
    ;Just use up vblank cycles to push monochrome bit
    ;CPU usage display of sound engine onto the screen.
    ldy #130
    lda sound_region
    cmp #SOUND_REGION_PAL
    bne +
    ldy #255
+
--  ldx #7
-   dex
    bne -
    dey
    bne --

    ;turn on monochrome color while the sound engine runs
    set_ppu_2001_bit PPU1_DISPLAY_TYPE
    upload_ppu_2001

    ;update the sound engine. This should always be done at the
    ;end of vblank, this way it is always running at the same speed
    ;even if your game s<s down.
    soundengine_update

    ;turn off monochrome color now that the sound engine is
    ;done. You should see a nice gray bar that shows how much
    ;cpu time the sound engine is using.
    clear_ppu_2001_bit PPU1_DISPLAY_TYPE
    upload_ppu_2001

    rts

vblank:

    pha
    txa
    pha
    tya
    pha
    php

    jsr vblank_indirect

    lda #1
    sta vblank_done_flag

    plp
    pla
    tay
    pla
    tax
    pla

irq:
    rti

vblank_indirect:
    jmp (vblank_routine)

}

{		; name_table.inc 
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$01,$02,$03,$04,$01,$02,$03,$04,$05,$06,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00
    db $00,$00,$00,$00,$09,$0a,$0b,$0c,$0d,$0a,$0b,$0c,$0d,$0e,$0b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0f,$10,$00,$00,$00,$00
    db $00,$00,$00,$00,$11,$12,$13,$14,$15,$12,$13,$14,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$00,$00,$00,$00
    db $00,$00,$00,$00,$26,$27,$28,$29,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$29,$35,$36,$2c,$37,$00,$00,$00,$00
    db $00,$00,$00,$00,$38,$39,$39,$3a,$38,$39,$39,$3a,$3b,$39,$3c,$3d,$3e,$3f,$40,$3e,$41,$42,$43,$44,$45,$39,$46,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$47,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$48,$49,$4a,$00,$4b,$4c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$4d,$4e,$4f,$00,$00,$00
    db $00,$00,$50,$51,$52,$53,$54,$55,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$56,$57,$58,$59,$5a,$00,$00,$00,$5b,$5c,$5d,$00,$00,$00
    db $00,$00,$00,$00,$5e,$5f,$60,$61,$62,$63,$00,$00,$00,$00,$00,$00,$00,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$00,$00,$00
    db $00,$00,$00,$00,$70,$71,$72,$73,$74,$75,$00,$00,$00,$00,$00,$00,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$00,$00,$7e,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$7f,$80,$81,$82,$83,$84,$00,$00,$00,$00,$00,$00,$85,$86,$87,$88,$89,$8a,$8b,$00,$00,$8c,$8d,$00,$00,$00,$00,$00
    db $00,$00,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$00,$00,$00,$00,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$00,$9f,$8d,$00,$00,$00,$00,$00,$00
    db $00,$00,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$00,$00,$00,$00,$a9,$aa,$00,$ab,$ac,$ad,$00,$00,$ae,$af,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$b0,$0b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b1,$00,$b2,$b3,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$b4,$b5,$b6,$b4,$00,$b7,$b8,$b9,$ba,$00,$00,$00,$bb,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$c6,$c7,$c8,$00,$00,$c9,$ca,$cb,$cc,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$cd,$ce,$cf,$d0,$00,$00,$d1,$d2,$d3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$d4,$d5,$d6,$d7,$d8,$00,$d9,$da,$db,$dc,$dd,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$de,$df,$e0,$e1,$e2,$00,$e3,$e4,$e5,$e6,$e7,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$54,$54,$55,$50,$50,$50,$00
    db $00,$05,$05,$05,$05,$05,$05,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00

}

{		; sprite_overlay.inc
  db $22
  db $70,$01,$00,$c0,$38
  db $70,$02,$00,$c8,$30
  db $78,$03,$00,$b8,$40
  db $78,$04,$00,$c0,$38
  db $78,$05,$00,$c8,$30
  db $78,$06,$00,$d0,$28
  db $80,$07,$00,$b0,$48
  db $80,$08,$00,$b8,$40
  db $80,$09,$00,$c0,$38
  db $80,$0a,$00,$c8,$30
  db $88,$0b,$00,$78,$80
  db $88,$0c,$00,$80,$78
  db $88,$0d,$00,$88,$70
  db $88,$0e,$00,$b0,$48
  db $88,$0f,$00,$b8,$40
  db $88,$10,$00,$c0,$38
  db $90,$11,$00,$78,$80
  db $90,$12,$00,$80,$78
  db $90,$13,$00,$88,$70
  db $90,$14,$00,$90,$68
  db $90,$15,$00,$a8,$50
  db $90,$16,$00,$b0,$48
  db $90,$17,$00,$b8,$40
  db $90,$18,$00,$c0,$38
  db $98,$19,$00,$80,$78
  db $98,$1a,$00,$88,$70
  db $98,$1b,$00,$90,$68
  db $98,$1c,$00,$98,$60
  db $98,$1d,$00,$a0,$58
  db $98,$1e,$00,$a8,$50
  db $98,$1f,$00,$b0,$48
  db $98,$20,$00,$b8,$40
  db $a0,$21,$00,$90,$68
  db $a0,$22,$00,$a0,$58
}

endif 



{		; ggsound.asm 

;Expects sound_param_byte_0 to contain desired region (SOUND_REGION_NTSC, SOUND_REGION_PAL, SOUND_REGION_DENDY)
;Expects sound_param_word_0 to contain song list address.
;Expects sound_param_word_1 to contain sfx list address.
;Expects sound_param_word_2 to contain instrument list address.
;If FEATURE_DPCM is defined, then
;Expects sound_param_word_3 to contain dpcm sample address.
sound_initialize:

    lda #1
    sta sound_disable_update

    lda sound_param_byte_0
    sta sound_region

    ;Get songs address.
    lda sound_param_word_0
    sta song_list_address
    lda sound_param_word_0+1
    sta song_list_address+1

    ;Get sfx address.
    lda sound_param_word_1
    sta sfx_list_address
    lda sound_param_word_1+1
    sta sfx_list_address+1

    ;Get instruments address.
    lda sound_param_word_2
    sta base_address_instruments
    lda sound_param_word_2+1
    sta base_address_instruments+1

    ifdef FEATURE_DPCM
    ;Get dpcm samples list.
    ldy #0
    lda (sound_param_word_3),y
    sta base_address_dpcm_sample_table
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_sample_table+1
    ;Get dpcm note to sample index table.
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_sample_index
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_sample_index+1
    ;Get dpcm note to sample length table.
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_sample_length
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_sample_length+1
    ;Get dpcm note to loop and pitch index table.
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_loop_pitch_index
    iny
    lda (sound_param_word_3),y
    sta base_address_dpcm_note_to_loop_pitch_index+1
    endif

    ;Load PAL note table for PAL, NTSC for any other region.
    lda sound_region
    cmp #SOUND_REGION_PAL
    beq @pal
@nstc:
    lda #<ntsc_note_table_lo
    sta base_address_note_table_lo
    lda #>ntsc_note_table_lo
    sta base_address_note_table_lo+1
    lda #<ntsc_note_table_hi
    sta base_address_note_table_hi
    lda #>ntsc_note_table_hi
    sta base_address_note_table_hi+1
    jmp @done
@pal:
    lda #<pal_note_table_lo
    sta base_address_note_table_lo
    lda #>pal_note_table_lo
    sta base_address_note_table_lo+1
    lda #<pal_note_table_hi
    sta base_address_note_table_hi
    lda #>pal_note_table_hi
    sta base_address_note_table_hi+1
@done:

    ;Enable square 1, square 2, triangle and noise.
    lda #%00001111
    sta $4015

    ;Ensure no apu data is uploaded yet.
    lda #0
    sta apu_data_ready
    ifdef FEATURE_DPCM
    lda #DPCM_STATE_NOP
    sta apu_dpcm_state
    endif

    jsr sound_initialize_apu_buffer

    ;Make sure all streams are killed.
    jsr sound_stop

    dec sound_disable_update

    rts


;Kill all active streams and halt sound.
sound_stop:

    ;Save x.
    txa
    pha

    inc sound_disable_update

    ;Kill all streams.
    ldx #(MAX_STREAMS-1)
@loop:

    lda #0
    sta stream_flags,x

    dex
    bpl @loop

    jsr sound_initialize_apu_buffer

    dec sound_disable_update

    ;Restore x.
    pla
    tax

    rts

;Updates all playing streams, if actve. Streams 0 through MAX_MUSIC_STREAMS-1
;are assumed to be music streams. The last two streams, are assumed to be sound
;effect streams. When these are playing, their channel control registers are
;copied overtop what the corresponding music streams had written, so the sound
;effect streams essentially take over while they are playing. When the sound
;effect streams are finished, they signify their corresponding music stream
;(via the TRM callback) to silence themselves until the next note to avoid
;ugly volume envelope transitions. DPCM is handled within this framework by
;a state machine that handles sound effect priority.
sound_update:

    ;Save regs.
    txa
    pha

    ;Signal apu data not ready.
    lda #0
    sta apu_data_ready

    ;First copy all music streams.
    ldx #0
@song_stream_register_copy_loop:

    ;Load whether this stream is active.
    lda stream_flags,x
    and #STREAM_ACTIVE_TEST
    beq @song_stream_not_active

    ;Update the stream.
    jsr stream_update

    ;Load channel number.
    lda stream_channel,x
    ;Multiply by four to get location within apu_register_sets.
    asl
    asl
    tay
    ;Copy the registers over.
    lda stream_channel_register_1,x
    sta apu_register_sets,y
    lda stream_channel_register_2,x
    sta apu_register_sets+1,y
    lda stream_channel_register_3,x
    sta apu_register_sets+2,y
    lda stream_channel_register_4,x
    sta apu_register_sets+3,y
@song_stream_not_active:

    inx
    cpx #MAX_MUSIC_STREAMS
    bne @song_stream_register_copy_loop
@do_not_update_music:

    ldx #soundeffect_one
@sfx_stream_register_copy_loop:

    ;Load whether this stream is active.
    lda stream_flags,x
    and #STREAM_ACTIVE_TEST
    beq @sfx_stream_not_active

    ;Update the stream.
    jsr stream_update

    ;Load channel number
    lda stream_channel,x
    ;Multiply by four to get location within apu_register_sets.
    asl
    asl
    tay
    ;Copy the registers over.
    lda stream_channel_register_1,x
    sta apu_register_sets,y
    lda stream_channel_register_2,x
    sta apu_register_sets+1,y
    lda stream_channel_register_3,x
    sta apu_register_sets+2,y
    lda stream_channel_register_4,x
    sta apu_register_sets+3,y
@sfx_stream_not_active:

    inx
    cpx #MAX_STREAMS
    bne @sfx_stream_register_copy_loop

    ;Signial apu data ready.
    lda #1
    sta apu_data_ready

    ;Restore regs.
    pla
    tax

    rts

;Note table borrowed from periods.s provided by FamiTracker's NSF driver.
ntsc_note_table_lo:
    db <$0D5B, <$0C9C, <$0BE6, <$0B3B, <$0A9A, <$0A01, <$0972, <$08EA, <$086A, <$07F1, <$077F, <$0713
    db <$06AD, <$064D, <$05F3, <$059D, <$054C, <$0500, <$04B8, <$0474, <$0434, <$03F8, <$03BF, <$0389
    db <$0356, <$0326, <$02F9, <$02CE, <$02A6, <$0280, <$025C, <$023A, <$021A, <$01FB, <$01DF, <$01C4
    db <$01AB, <$0193, <$017C, <$0167, <$0152, <$013F, <$012D, <$011C, <$010C, <$00FD, <$00EF, <$00E1
    db <$00D5, <$00C9, <$00BD, <$00B3, <$00A9, <$009F, <$0096, <$008E, <$0086, <$007E, <$0077, <$0070
    db <$006A, <$0064, <$005E, <$0059, <$0054, <$004F, <$004B, <$0046, <$0042, <$003F, <$003B, <$0038
    db <$0034, <$0031, <$002F, <$002C, <$0029, <$0027, <$0025, <$0023, <$0021, <$001F, <$001D, <$001B
    db <$001A, <$0018, <$0017, <$0015, <$0014, <$0013, <$0012, <$0011, <$0010, <$000F, <$000E, <$000D

ntsc_note_table_hi:
    db >$0D5B, >$0C9C, >$0BE6, >$0B3B, >$0A9A, >$0A01, >$0972, >$08EA, >$086A, >$07F1, >$077F, >$0713
    db >$06AD, >$064D, >$05F3, >$059D, >$054C, >$0500, >$04B8, >$0474, >$0434, >$03F8, >$03BF, >$0389
    db >$0356, >$0326, >$02F9, >$02CE, >$02A6, >$0280, >$025C, >$023A, >$021A, >$01FB, >$01DF, >$01C4
    db >$01AB, >$0193, >$017C, >$0167, >$0152, >$013F, >$012D, >$011C, >$010C, >$00FD, >$00EF, >$00E1
    db >$00D5, >$00C9, >$00BD, >$00B3, >$00A9, >$009F, >$0096, >$008E, >$0086, >$007E, >$0077, >$0070
    db >$006A, >$0064, >$005E, >$0059, >$0054, >$004F, >$004B, >$0046, >$0042, >$003F, >$003B, >$0038
    db >$0034, >$0031, >$002F, >$002C, >$0029, >$0027, >$0025, >$0023, >$0021, >$001F, >$001D, >$001B
    db >$001A, >$0018, >$0017, >$0015, >$0014, >$0013, >$0012, >$0011, >$0010, >$000F, >$000E, >$000D

pal_note_table_lo:
    db <$0C68, <$0BB6, <$0B0E, <$0A6F, <$09D9, <$094B, <$08C6, <$0848, <$07D1, <$0760, <$06F6, <$0692
    db <$0634, <$05DB, <$0586, <$0537, <$04EC, <$04A5, <$0462, <$0423, <$03E8, <$03B0, <$037B, <$0349
    db <$0319, <$02ED, <$02C3, <$029B, <$0275, <$0252, <$0231, <$0211, <$01F3, <$01D7, <$01BD, <$01A4
    db <$018C, <$0176, <$0161, <$014D, <$013A, <$0129, <$0118, <$0108, <$00F9, <$00EB, <$00DE, <$00D1
    db <$00C6, <$00BA, <$00B0, <$00A6, <$009D, <$0094, <$008B, <$0084, <$007C, <$0075, <$006E, <$0068
    db <$0062, <$005D, <$0057, <$0052, <$004E, <$0049, <$0045, <$0041, <$003E, <$003A, <$0037, <$0034
    db <$0031, <$002E, <$002B, <$0029, <$0026, <$0024, <$0022, <$0020, <$001E, <$001D, <$001B, <$0019
    db <$0018, <$0016, <$0015, <$0014, <$0013, <$0012, <$0011, <$0010, <$000F, <$000E, <$000D, <$000C

pal_note_table_hi:
    db >$0C68, >$0BB6, >$0B0E, >$0A6F, >$09D9, >$094B, >$08C6, >$0848, >$07D1, >$0760, >$06F6, >$0692
    db >$0634, >$05DB, >$0586, >$0537, >$04EC, >$04A5, >$0462, >$0423, >$03E8, >$03B0, >$037B, >$0349
    db >$0319, >$02ED, >$02C3, >$029B, >$0275, >$0252, >$0231, >$0211, >$01F3, >$01D7, >$01BD, >$01A4
    db >$018C, >$0176, >$0161, >$014D, >$013A, >$0129, >$0118, >$0108, >$00F9, >$00EB, >$00DE, >$00D1
    db >$00C6, >$00BA, >$00B0, >$00A6, >$009D, >$0094, >$008B, >$0084, >$007C, >$0075, >$006E, >$0068
    db >$0062, >$005D, >$0057, >$0052, >$004E, >$0049, >$0045, >$0041, >$003E, >$003A, >$0037, >$0034
    db >$0031, >$002E, >$002B, >$0029, >$0026, >$0024, >$0022, >$0020, >$001E, >$001D, >$001B, >$0019
    db >$0018, >$0016, >$0015, >$0014, >$0013, >$0012, >$0011, >$0010, >$000F, >$000E, >$000D, >$000C

;Maps NTSC to NTSC tempo, maps PAL and Dendy to
;faster PAL tempo in song and sfx headers.
sound_region_to_tempo_offset:
    db 0, 2, 2

channel_callback_table_lo:
    db <square_1_play_note
    db <square_2_play_note
    db <triangle_play_note
    db <noise_play_note
    ifdef FEATURE_DPCM
    db <dpcm_play_note
    endif

channel_callback_table_hi:
    db >square_1_play_note
    db >square_2_play_note
    db >triangle_play_note
    db >noise_play_note
    ifdef FEATURE_DPCM
    db >dpcm_play_note
    endif

stream_callback_table_lo:
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_s
    db <stream_set_length_lo
    db <stream_set_length_hi
    db <stream_set_instrument
    db <stream_goto
    db <stream_call
    db <stream_return
    db <stream_terminate

stream_callback_table_hi:
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_s
    db >stream_set_length_lo
    db >stream_set_length_hi
    db >stream_set_instrument
    db >stream_goto
    db >stream_call
    db >stream_return
    db >stream_terminate

ifdef FEATURE_ARPEGGIOS

arpeggio_callback_table_lo:
    db <(arpeggio_absolute-1)
    db <(arpeggio_fixed-1)
    db <(arpeggio_relative-1)

arpeggio_callback_table_hi:
    db >(arpeggio_absolute-1)
    db >(arpeggio_fixed-1)
    db >(arpeggio_relative-1)

endif

;****************************************************************
;These callbacks are all note playback and only execute once per
;frame.
;****************************************************************

square_1_play_note:

    ;Load instrument index.
    ldy stream_instrument_index,x
    ;Load instrument address.
    lda (base_address_instruments),y
    sta sound_local_word_0
    iny
    lda (base_address_instruments),y
    sta sound_local_word_0+1

    ;Set negate flag for sweep unit.
    lda #$08
    sta stream_channel_register_2,x

    ifdef FEATURE_ARPEGGIOS

    ;Get arpeggio type.
    ldy #instrument_header_arpeggio_type
    lda (sound_local_word_0),y
    tay

    ;Get the address.
    lda #>(@return_from_arpeggio_callback-1)
    pha
    lda #<(@return_from_arpeggio_callback-1)
    pha
    lda arpeggio_callback_table_hi,y
    pha
    lda arpeggio_callback_table_lo,y
    pha
    rts
@return_from_arpeggio_callback:

    else

    ldy stream_note,x

    endif

    ;Skip loading note pitch if already loaded, to allow envelopes
    ;to modify the pitch.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_TEST
    bne @pitch_already_loaded
    lda stream_flags,x
    ora #STREAM_PITCH_LOADED_SET
    sta stream_flags,x
    ;Load low byte of note.
    lda (base_address_note_table_lo),y
    ;Store in low 8 bits of pitch.
    sta stream_channel_register_3,x
    ;Load high byte of note.
    lda (base_address_note_table_hi),y
    sta stream_channel_register_4,x
@pitch_already_loaded:

    lda stream_flags,x
    and #STREAM_SILENCE_TEST
    bne @silence_until_note
@note_not_silenced:

    ;Load volume offset.
    ldy stream_volume_offset,x

    ;Load volume value for this frame, branch if opcode.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @volume_stop
    cmp #ENV_LOOP
    bne @skip_volume_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_volume_offset,x
    tay

@skip_volume_loop:

    ;Initialize channel control register with envelope decay and
    ;length counter disabled but preserving current duty cycle.
    lda stream_channel_register_1,x
    and #%11000000
    ora #%00110000

    ;Load current volume value.
    ora (sound_local_word_0),y
    sta stream_channel_register_1,x

    inc stream_volume_offset,x

@volume_stop:

    jmp @done
@silence_until_note:
    lda stream_channel_register_1,x
    and #%11000000
    ora #%00110000
    sta stream_channel_register_1,x

@done:

    ;Load pitch offset.
    ldy stream_pitch_offset,x

    ;Load pitch value.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @pitch_stop
    cmp #ENV_LOOP
    bne @skip_pitch_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_pitch_offset,x
    tay

@skip_pitch_loop:

    ;Test sign.
    lda (sound_local_word_0),y
    bmi @pitch_delta_negative
@pitch_delta_positive:

    clc
    lda stream_channel_register_3,x
    adc (sound_local_word_0),y
    sta stream_channel_register_3,x
    lda stream_channel_register_4,x
    adc #0
    sta stream_channel_register_4,x

    jmp @pitch_delta_test_done

@pitch_delta_negative:

    clc
    lda stream_channel_register_3,x
    adc (sound_local_word_0),y
    sta stream_channel_register_3,x
    lda stream_channel_register_4,x
    adc #$ff
    sta stream_channel_register_4,x

@pitch_delta_test_done:

    ;Move pitch offset along.
    inc stream_pitch_offset,x

@pitch_stop:

@duty_code:

    ldy stream_duty_offset,x

    ;Load duty value for this frame, but hard code flags and duty for now.
    lda (sound_local_word_0),y
    cmp #DUTY_ENV_STOP
    beq @duty_stop
    cmp #DUTY_ENV_LOOP
    bne @skip_duty_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_duty_offset,x
    tay

@skip_duty_loop:

    ;Or the duty value into the register.
    lda stream_channel_register_1,x
    and #%00111111
    ora (sound_local_word_0),y
    sta stream_channel_register_1,x

    ;Move duty offset along.
    inc stream_duty_offset,x

@duty_stop:

    rts


square_2_play_note = square_1_play_note

triangle_play_note:

    ;Load instrument index.
    ldy stream_instrument_index,x
    ;Load instrument address.
    lda (base_address_instruments),y
    sta sound_local_word_0
    iny
    lda (base_address_instruments),y
    sta sound_local_word_0+1

    ifdef FEATURE_ARPEGGIOS
    ;Get arpeggio type.
    ldy #instrument_header_arpeggio_type
    lda (sound_local_word_0),y
    tay

    ;Get the address.
    lda #>(@return_from_arpeggio_callback-1)
    pha
    lda #<(@return_from_arpeggio_callback-1)
    pha
    lda arpeggio_callback_table_hi,y
    pha
    lda arpeggio_callback_table_lo,y
    pha
    rts
@return_from_arpeggio_callback:

    else

    ldy stream_note,x

    endif

    ;Skip loading note pitch if already loaded, to allow envelopes
    ;to modify the pitch.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_TEST
    bne @pitch_already_loaded
    lda stream_flags,x
    ora #STREAM_PITCH_LOADED_SET
    sta stream_flags,x
    ;Load low byte of note.
    lda (base_address_note_table_lo),y
    ;Store in low 8 bits of pitch.
    sta stream_channel_register_3,x
    ;Load high byte of note.
    lda (base_address_note_table_hi),y
    sta stream_channel_register_4,x
@pitch_already_loaded:

    ;Load volume offset.
    ldy stream_volume_offset,x

    ;Load volume value for this frame, but hard code flags and duty for now.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @volume_stop
    cmp #ENV_LOOP
    bne @skip_volume_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_volume_offset,x
    tay

@skip_volume_loop:

    lda #%10000000
    ora (sound_local_word_0),y
    sta stream_channel_register_1,x

    inc stream_volume_offset,x

@volume_stop:

    ;Load pitch offset.
    ldy stream_pitch_offset,x

    ;Load pitch value.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @pitch_stop
    cmp #ENV_LOOP
    bne @skip_pitch_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_pitch_offset,x
    tay

@skip_pitch_loop:

    ;Test sign.
    lda (sound_local_word_0),y
    bmi @pitch_delta_negative
@pitch_delta_positive:

    clc
    lda stream_channel_register_3,x
    adc (sound_local_word_0),y
    sta stream_channel_register_3,x
    lda stream_channel_register_4,x
    adc #0
    sta stream_channel_register_4,x

    jmp @pitch_delta_test_done

@pitch_delta_negative:

    clc
    lda stream_channel_register_3,x
    adc (sound_local_word_0),y
    sta stream_channel_register_3,x
    lda stream_channel_register_4,x
    adc #$ff
    sta stream_channel_register_4,x

@pitch_delta_test_done:

    ;Move pitch offset along.
    inc stream_pitch_offset,x

@pitch_stop:

    rts


noise_play_note:

    ;Load instrument index.
    ldy stream_instrument_index,x
    ;Load instrument address.
    lda (base_address_instruments),y
    sta sound_local_word_0
    iny
    lda (base_address_instruments),y
    sta sound_local_word_0+1

    ifdef FEATURE_ARPEGGIOS
    ;Get arpeggio type.
    ldy #instrument_header_arpeggio_type
    lda (sound_local_word_0),y
    tay

    ;Get the address.
    lda #>(@return_from_arpeggio_callback-1)
    pha
    lda #<(@return_from_arpeggio_callback-1)
    pha
    lda arpeggio_callback_table_hi,y
    pha
    lda arpeggio_callback_table_lo,y
    pha
    rts
@return_from_arpeggio_callback:

    else

    ldy stream_note,x

    endif

    tya
    and #%01111111
    sta sound_local_byte_0

    ;Skip loading note pitch if already loaded, to allow envelopes
    ;to modify the pitch.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_TEST
    bne @pitch_already_loaded
    lda stream_flags,x
    ora #STREAM_PITCH_LOADED_SET
    sta stream_flags,x
    lda stream_channel_register_3,x
    and #%10000000
    ora sound_local_byte_0
    sta stream_channel_register_3,x
@pitch_already_loaded:

    ;Load volume offset.
    ldy stream_volume_offset,x

    ;Load volume value for this frame, hard code disable flags.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @volume_stop
    cmp #ENV_LOOP
    bne @skip_volume_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_volume_offset,x
    tay

@skip_volume_loop:

    lda #%00110000
    ora (sound_local_word_0),y
    sta stream_channel_register_1,x

    ;Move volume offset along.
    inc stream_volume_offset,x
@volume_stop:

    ;Load pitch offset.
    ldy stream_pitch_offset,x

    ;Load pitch value.
    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @pitch_stop
    cmp #ENV_LOOP
    bne @skip_pitch_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_pitch_offset,x
    tay

@skip_pitch_loop:

    ;Save off current duty bit.
    lda stream_channel_register_3,x
    and #%10000000
    sta sound_local_byte_0

    ;Advance pitch regardless of duty bit.
    clc
    lda stream_channel_register_3,x
    adc (sound_local_word_0),y
    and #%00001111
    ;Get duty bit back in.
    ora sound_local_byte_0
    sta stream_channel_register_3,x

    ;Move pitch offset along.
    inc stream_pitch_offset,x

@pitch_stop:

@duty_code:
    ;Load duty offset.
    ldy stream_duty_offset,x

    ;Load duty value for this frame, but hard code flags and duty for now.
    lda (sound_local_word_0),y
    cmp #DUTY_ENV_STOP
    beq @duty_stop
    cmp #DUTY_ENV_LOOP
    bne @skip_duty_loop

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_duty_offset,x
    tay

@skip_duty_loop:

    ;We only care about bit 6 for noise, and we want it in bit 7 position.
    lda (sound_local_word_0),y
    asl
    sta sound_local_byte_0

    lda stream_channel_register_3,x
    and #%01111111
    ora sound_local_byte_0
    sta stream_channel_register_3,x

    ;Move duty offset along.
    inc stream_duty_offset,x

@duty_stop:

    rts


ifdef FEATURE_DPCM
dpcm_play_note:

    ;Determine if silence until note is set.
    lda stream_flags,x
    and #STREAM_SILENCE_TEST
    bne @note_already_played

    ;Load note index.
    ldy stream_note,x

    ;Get sample index.
    lda (base_address_dpcm_note_to_sample_index),y
    bmi @no_sample

    ;This sample index looks up into base_address_dpcm_sample_table.
    tay
    lda (base_address_dpcm_sample_table),y
    sta stream_channel_register_3,x

    ;Get loop and pitch from dpcm_note_to_loop_pitch_index table.
    ldy stream_note,x
    lda (base_address_dpcm_note_to_loop_pitch_index),y
    sta stream_channel_register_1,x

    ;Get sample length.
    lda (base_address_dpcm_note_to_sample_length),y
    sta stream_channel_register_4,x

    ;Upload the dpcm data if sfx commands are not overriding.
    lda apu_dpcm_state
    cmp #DPCM_STATE_WAIT
    beq @skip
    cmp #DPCM_STATE_UPLOAD_THEN_WAIT
    beq @skip
    lda #DPCM_STATE_UPLOAD
    sta apu_dpcm_state
@skip:

    lda stream_flags,x
    ora #STREAM_SILENCE_SET
    sta stream_flags,x
@no_sample:
@note_already_played:

    rts

endif

ifdef FEATURE_ARPEGGIOS

arpeggio_absolute:

    ldy stream_arpeggio_offset,x

    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @arpeggio_stop
    cmp #ENV_LOOP
    beq @arpeggio_loop
@arpeggio_play:

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and add it to current note.
    clc
    lda (sound_local_word_0),y
    adc stream_note,x
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x

    jmp @done
@arpeggio_stop:

    ;Just load the current note.
    ldy stream_note,x

    jmp @done
@arpeggio_loop:

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_arpeggio_offset,x
    tay

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and add it to current note.
    clc
    lda (sound_local_word_0),y
    adc stream_note,x
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x
@done:

    rts


arpeggio_fixed:

    ldy stream_arpeggio_offset,x

    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @arpeggio_stop
    cmp #ENV_LOOP
    beq @arpeggio_loop
@arpeggio_play:

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and use it as the current note.
    lda (sound_local_word_0),y
    ;sta stream_note,x
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x

    jmp @done
@arpeggio_stop:

    ;When a fixed arpeggio is done, we're changing notes to the
    ;currently playing note. (This is FamiTracker's behavior)
    ;However, we only do this if we're stopping at any point other
    ;than one, which indicates an arpeggio did in fact execute.
    lda stream_arpeggio_offset,x
    cmp #1
    beq @skip_clear_pitch_loaded
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x
@skip_clear_pitch_loaded:

    ;Just load the current note.
    ldy stream_note,x

    jmp @done
@arpeggio_loop:

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_arpeggio_offset,x
    tay

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and use it as the current note.
    lda (sound_local_word_0),y
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x
@done:

    rts


arpeggio_relative:

    ldy stream_arpeggio_offset,x

    lda (sound_local_word_0),y
    cmp #ENV_STOP
    beq @arpeggio_stop
    cmp #ENV_LOOP
    beq @arpeggio_loop
@arpeggio_play:

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and add it to current note.
    clc
    lda (sound_local_word_0),y
    adc stream_note,x
    cmp #HIGHEST_NOTE
    bmi @skip
    lda #HIGHEST_NOTE
@skip:
    sta stream_note,x
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x

    jmp @done
@arpeggio_stop:

    ;Just load the current note.
    ldy stream_note,x

    jmp @done
@arpeggio_loop:

    ;We hit a loop opcode, advance envelope index and load loop point.
    iny
    lda (sound_local_word_0),y
    sta stream_arpeggio_offset,x
    tay

    ;We're changing notes.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Load the current arpeggio value and add it to current note.
    clc
    lda (sound_local_word_0),y
    adc stream_note,x
    tay
    ;Advance arpeggio offset.
    inc stream_arpeggio_offset,x
@done:

    rts


endif

;****************************************************************
;These callbacks are all stream control and execute in sequence
;until exhausted.
;****************************************************************

stream_set_instrument:

    advance_stream_read_address
    ;Load byte at read address.
    lda stream_read_address_lo,x
    sta sound_local_word_0
    lda stream_read_address_hi,x
    sta sound_local_word_0+1
    ldy #0
    lda (sound_local_word_0),y
    asl
    sta stream_instrument_index,x
    tay

    lda (base_address_instruments),y
    sta sound_local_word_0
    iny
    lda (base_address_instruments),y
    sta sound_local_word_0+1

    ldy #0
    lda (sound_local_word_0),y
    sta stream_volume_offset,x
    iny
    lda (sound_local_word_0),y
    sta stream_pitch_offset,x
    iny
    lda (sound_local_word_0),y
    sta stream_duty_offset,x
    ifdef FEATURE_ARPEGGIOS
    iny
    lda (sound_local_word_0),y
    sta stream_arpeggio_offset,x
    endif

    rts

;Set a standard note length. This callback works for a set
;of opcodes which can set the note length for values 1 through 16.
;This helps reduce ROM space required by songs.
stream_set_length_s:

    ;determine note length from opcode
    sec
    lda stream_note,x
    sbc #OPCODES_BASE
    clc
    adc #1
    sta stream_note_length_lo,x
    sta stream_note_length_counter_lo,x
    lda #0
    sta stream_note_length_hi,x
    sta stream_note_length_counter_hi,x

    rts


stream_set_length_lo:

    advance_stream_read_address
    ;Load byte at read address.
    lda stream_read_address_lo,x
    sta sound_local_word_0
    lda stream_read_address_hi,x
    sta sound_local_word_0+1
    ldy #0
    lda (sound_local_word_0),y
    sta stream_note_length_lo,x
    sta stream_note_length_counter_lo,x
    lda #0
    sta stream_note_length_hi,x
    sta stream_note_length_counter_hi,x

    rts

stream_set_length_hi:

    advance_stream_read_address
    ;Load byte at read address.
    lda stream_read_address_lo,x
    sta sound_local_word_0
    lda stream_read_address_hi,x
    sta sound_local_word_0+1
    ldy #0
    lda (sound_local_word_0),y
    sta stream_note_length_hi,x
    sta stream_note_length_counter_hi,x

    rts

;This opcode loops to the beginning of the stream. It expects the two
;following bytes to contain the address to loop to.
stream_goto:

    advance_stream_read_address
    ;Load byte at read address.
    lda stream_read_address_lo,x
    sta sound_local_word_0
    lda stream_read_address_hi,x
    sta sound_local_word_0+1
    ldy #0
    lda (sound_local_word_0),y
    sta stream_read_address_lo,x
    ldy #1
    lda (sound_local_word_0),y
    sta stream_read_address_hi,x

    sec
    lda stream_read_address_lo,x
    sbc #1
    sta stream_read_address_lo,x
    lda stream_read_address_hi,x
    sbc #0
    sta stream_read_address_hi,x

    rts


;This opcode stores the current stream read address in
;return_stream_read_address (lo and hi) and then reads the
;following two bytes and stores them in the current stream read address.
;It is assumed that a RET opcode will be encountered in the stream which
;is being called, which will restore the return stream read address.
;This is how the engine can allow repeated chunks of a song.
stream_call:

    advance_stream_read_address
    lda stream_read_address_lo,x
    sta sound_local_word_0
    lda stream_read_address_hi,x
    sta sound_local_word_0+1

    ;Retrieve lo byte of destination address from first CAL parameter.
    ldy #0
    lda (sound_local_word_0),y
    sta sound_local_word_1
    iny
    ;Retrieve hi byte of destination address from second CAL parameter.
    lda (sound_local_word_0),y
    sta sound_local_word_1+1

    advance_stream_read_address

    ;Now store current stream read address in stream's return address.
    lda stream_read_address_lo,x
    sta stream_return_address_lo,x
    lda stream_read_address_hi,x
    sta stream_return_address_hi,x

    ;Finally, transfer address we are calling to current read address.
    sec
    lda sound_local_word_1
    sbc #<1
    sta stream_read_address_lo,x
    lda sound_local_word_1+1
    sbc #>1
    sta stream_read_address_hi,x

    rts


;This opcode restores the stream_return_address to the stream_read_address
;and continues where it left off.
stream_return:

    lda stream_return_address_lo,x
    sta stream_read_address_lo,x
    lda stream_return_address_hi,x
    sta stream_read_address_hi,x

    rts


;This opcode returns from the parent caller by popping two bytes off
;the stack and then doing rts.
stream_terminate:

    ;Set the current stream to inactive.
    lda #0
    sta stream_flags,x

    cpx #soundeffect_one
    bmi @not_sound_effect

    ;Load channel this sfx writes to.
    ldy stream_channel,x
    ;Use this as index into streams to tell corresponding music channel
    ;to silence until the next note.
    lda stream_flags,y
    ora #STREAM_SILENCE_SET
    sta stream_flags,y

@not_sound_effect:

    ;Pop current address off the stack.
    pla
    pla

    ;Return from parent caller.
    rts

;Expects sound_param_byte_0 to contain index of a song in song_list.
;Assumed to be four addresses to initialize streams on, for square1, square2, triangle and noise.
;Any addresses found to be zero will not initialize that channel.
play_song:

    ;Save index regs.
    tya
    pha
    txa
    pha

    inc sound_disable_update

    ;Select header tempo offset based on region.
    ldx sound_region
    lda sound_region_to_tempo_offset,x
    sta sound_local_byte_0

    ;Get song address from song list.
    lda sound_param_byte_0
    asl
    tay
    lda (song_list_address),y
    sta song_address
    iny
    lda (song_list_address),y
    sta song_address+1

    ;Load square 1 stream.
    ldx #0
    jsr stream_stop

    ldy #track_header_square1_stream_address
    lda (song_address),y
    sta sound_param_word_0
    iny
    lda (song_address),y
    beq @no_square_1
    sta sound_param_word_0+1

    lda #0
    sta sound_param_byte_0

    lda #0
    sta sound_param_byte_1

    jsr stream_initialize

    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_0
    tay
    lda (song_address),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (song_address),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x
@no_square_1:

    ;Load square 2 stream.
    ldx #1
    jsr stream_stop

    ldy #track_header_square2_stream_address
    lda (song_address),y
    sta sound_param_word_0
    iny
    lda (song_address),y
    beq @no_square_2
    sta sound_param_word_0+1

    lda #1
    sta sound_param_byte_0

    lda #1
    sta sound_param_byte_1

    jsr stream_initialize

    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_0
    tay
    lda (song_address),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (song_address),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x
@no_square_2:

    ;Load triangle stream.
    ldx #2
    jsr stream_stop

    ldy #track_header_triangle_stream_address
    lda (song_address),y
    sta sound_param_word_0
    iny
    lda (song_address),y
    beq @no_triangle
    sta sound_param_word_0+1

    lda #2
    sta sound_param_byte_0

    lda #2
    sta sound_param_byte_1

    jsr stream_initialize

    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_0
    tay
    lda (song_address),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (song_address),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x
@no_triangle:

    ;Load noise stream.
    ldx #3
    jsr stream_stop

    ldy #track_header_noise_stream_address
    lda (song_address),y
    sta sound_param_word_0
    iny
    lda (song_address),y
    beq @no_noise
    sta sound_param_word_0+1

    lda #3
    sta sound_param_byte_0

    lda #3
    sta sound_param_byte_1

    jsr stream_initialize

    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_0
    tay
    lda (song_address),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (song_address),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x
@no_noise:

    ifdef FEATURE_DPCM
    ;Load dpcm stream.
    ldx #4
    jsr stream_stop

    ldy #track_header_dpcm_stream_address
    lda (song_address),y
    sta sound_param_word_0
    iny
    lda (song_address),y
    beq @no_dpcm
    sta sound_param_word_0+1

    lda #4
    sta sound_param_byte_0

    lda #4
    sta sound_param_byte_1

    jsr stream_initialize

    lda #DPCM_STATE_NOP
    sta apu_dpcm_state

    ;Reset load counter to safeguard against accumulating too far
    ;in one direction. (can cause distortion). Suggestion by thefox
    ;on nesdev. I've never actually heard this distortion occur.
    lda #0
    sta $4011

    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_0
    tay
    lda (song_address),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (song_address),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x
@no_dpcm:
    endif

    dec sound_disable_update

    ;Restore index regs.
    pla
    tax
    pla
    tay

    rts


;Expects sound_param_byte_0 to contain the index of the sound effect to play.
;Expects sound_param_byte_1 to contain the sound effect priority. This can
;be one of two values: soundeffect_one, and soundeffect_two from ggsound.inc.
;Assumes the parameters are correct; no range checking is performed.
play_sfx:

    ;Save index regs.
    tya
    pha
    txa
    pha

    inc sound_disable_update

    ;Select header tempo offset based on region.
    ldx sound_region
    lda sound_region_to_tempo_offset,x
    sta sound_local_byte_1

    ;Get sfx address from sfx list.
    lda sound_param_byte_0
    asl
    tay
    lda (sfx_list_address),y
    sta sound_local_word_0
    iny
    lda (sfx_list_address),y
    sta sound_local_word_0+1

    lda sound_param_byte_1
    sta sound_local_byte_0

    ;Load square 1 stream.
    ldy #track_header_square1_stream_address
    lda (sound_local_word_0),y
    sta sound_param_word_0
    iny
    lda (sound_local_word_0),y
    beq @no_square_1
    sta sound_param_word_0+1

    lda #0
    sta sound_param_byte_0

    lda sound_local_byte_0
    sta sound_param_byte_1

    jsr stream_initialize

    ldx sound_local_byte_0
    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_1
    tay
    lda (sound_local_word_0),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    iny
    lda (sound_local_word_0),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    inc sound_local_byte_0
@no_square_1:

    lda sound_local_byte_0
    cmp #(soundeffect_two + 1)
    bne @skip0
    jmp @no_more_sfx_streams_available
@skip0:

    ;Load square 2 stream.
    ldy #track_header_square2_stream_address
    lda (sound_local_word_0),y
    sta sound_param_word_0
    iny
    lda (sound_local_word_0),y
    beq @no_square_2
    sta sound_param_word_0+1

    lda #1
    sta sound_param_byte_0

    lda sound_local_byte_0
    sta sound_param_byte_1

    jsr stream_initialize

    ldx sound_local_byte_0
    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_1
    tay
    lda (sound_local_word_0),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    iny
    lda (sound_local_word_0),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    inc sound_local_byte_0
@no_square_2:

    lda sound_local_byte_0
    cmp #(soundeffect_two + 1)
    bne @skip1
    jmp @no_more_sfx_streams_available
@skip1:

    ;Load triangle stream.
    ldy #track_header_triangle_stream_address
    lda (sound_local_word_0),y
    sta sound_param_word_0
    iny
    lda (sound_local_word_0),y
    beq @no_triangle
    sta sound_param_word_0+1

    lda #2
    sta sound_param_byte_0

    lda sound_local_byte_0
    sta sound_param_byte_1

    jsr stream_initialize

    ldx sound_local_byte_0
    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_1
    tay
    lda (sound_local_word_0),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    iny
    lda (sound_local_word_0),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    inc sound_local_byte_0
@no_triangle:

    lda sound_local_byte_0
    cmp #(soundeffect_two + 1)
    beq @no_more_sfx_streams_available

    ;Load noise stream.
    ldy #track_header_noise_stream_address
    lda (sound_local_word_0),y
    sta sound_param_word_0
    iny
    lda (sound_local_word_0),y
    beq @no_noise
    sta sound_param_word_0+1

    lda #3
    sta sound_param_byte_0

    lda sound_local_byte_0
    sta sound_param_byte_1

    jsr stream_initialize

    ldx sound_local_byte_0
    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_1
    tay
    lda (sound_local_word_0),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    iny
    lda (sound_local_word_0),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    inc sound_local_byte_0
@no_noise:

    ifdef FEATURE_DPCM
    ;Load dpcm stream.
    ldy #track_header_dpcm_stream_address
    lda (sound_local_word_0),y
    sta sound_param_word_0
    iny
    lda (sound_local_word_0),y
    beq @no_dpcm
    sta sound_param_word_0+1

    lda #4
    sta sound_param_byte_0

    lda sound_local_byte_0
    sta sound_param_byte_1

    jsr stream_initialize

    ldx sound_local_byte_0
    clc
    lda #track_header_ntsc_tempo_lo
    adc sound_local_byte_1
    tay
    lda (sound_local_word_0),y
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x

    iny
    lda (sound_local_word_0),y
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    lda #DPCM_STATE_UPLOAD_THEN_WAIT
    sta apu_dpcm_state
@no_dpcm:
   endif

@no_more_sfx_streams_available:

    dec sound_disable_update

    ;Restore index regs.
    pla
    tax
    pla
    tay

    rts


;Pauses all music streams by clearing volume bits from all channel registers
;and setting the pause flag so these streams are not updated.
pause_song:

    ldx #(MAX_MUSIC_STREAMS-1)
@next_stream:

    lda stream_flags,x
    ora #STREAM_PAUSE_SET
    sta stream_flags,x

    lda stream_channel_register_1,x
    and #%11110000
    sta stream_channel_register_1,x

    dex
    bpl @next_stream

    rts


;Resumes all music streams.
resume_song:

    ldx #(MAX_MUSIC_STREAMS-1)
@next_stream:

    lda stream_flags,x
    and #STREAM_PAUSE_CLEAR
    sta stream_flags,x

    dex
    bpl @next_stream

    rts


;Expects sound_param_byte_0 to contain the channel on which to play the stream.
;Expects sound_param_byte_1 to contain the offset of the stream instance to initialize.
;Expects sound_param_word_0 to contain the starting read address of the stream to
;initialize.
stream_initialize:
channel = sound_param_byte_0
stream = sound_param_byte_1
starting_read_address = sound_param_word_0

    ;Save x.
    txa
    pha

    ldx stream

    inc sound_disable_update

    lda starting_read_address
    ora starting_read_address+1
    beq @null_starting_read_address

    ;Set stream to be inactive while initializing.
    lda #0
    sta stream_flags,x

    ;Set a default note length (20 frames).
    lda #20
    sta stream_note_length_lo,x
    ;Set initial note length counter.
    sta stream_note_length_counter_lo,x
    lda #0
    sta stream_note_length_hi,x
    sta stream_note_length_counter_hi,x

    ;Set initial instrument index.
    lda #0
    sta stream_instrument_index,x
    sta stream_volume_offset,x
    sta stream_pitch_offset,x
    sta stream_duty_offset,x
    ifdef FEATURE_ARPEGGIOS
    sta stream_arpeggio_offset,x
    endif

    ;Set channel.
    lda channel
    sta stream_channel,x

    ;Set initial read address.
    lda starting_read_address
    sta stream_read_address_lo,x
    lda starting_read_address+1
    sta stream_read_address_hi,x

    ;Set default tempo.
    lda #<DEFAULT_TEMPO
    sta stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    lda #>DEFAULT_TEMPO
    sta stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    ;Set stream to be active.
    lda stream_flags,x
    ora #STREAM_ACTIVE_SET
    sta stream_flags,x
@null_starting_read_address:

    dec sound_disable_update

    ;Restore x.
    pla
    tax

    rts

;Stops a stream from playing.
;Assumes x contains the index of the stream to kill.
stream_stop:

    inc sound_disable_update

    lda #0
    sta stream_flags,x

    dec sound_disable_update

    rts


;Updates a single stream.
;Expects x to be pointing to a stream instance as an offset from streams.
stream_update:
callback_address = sound_local_word_0
read_address = sound_local_word_1

    lda stream_flags,x
    and #STREAM_PAUSE_TEST
    beq @skip0
    rts
@skip0:

    ;Load current read address of stream.
    lda stream_read_address_lo,x
    sta read_address
    lda stream_read_address_hi,x
    sta read_address+1

    ;Load next byte from stream data.
    lda stream_flags,x
    and #STREAM_PITCH_LOADED_TEST
    bne @skip1
    ldy #0
    lda (read_address),y
    sta stream_note,x
@skip1:

    ;Is this byte a note or a stream opcode?
    cmp #OPCODES_BASE
    bcc @process_note
@process_opcode:

    ;Look up the opcode in the stream callbacks table.
    sec
    sbc #OPCODES_BASE
    tay
    ;Get the address.
    lda stream_callback_table_lo,y
    sta callback_address
    lda stream_callback_table_hi,y
    sta callback_address+1
    ;Call the callback!
    jsr indirect_jsr_callback_address

    ;Advance the stream's read address.
    advance_stream_read_address

    ;Immediately process the next opcode or note. The idea here is that
    ;all stream control opcodes will execute during the current frame as "setup"
    ;for the next note. All notes will execute once per frame and will always
    ;return from this routine. This leaves the problem, how would the stream
    ;control opcode "terminate" work? It works by pulling the current return
    ;address off the stack and then performing an rts, effectively returning
    ;from its caller, this routine.
    jmp stream_update

@process_note:

    ;Determine which channel callback to use.
    lda stream_channel,x
    tay
    lda channel_callback_table_lo,y
    sta callback_address
    lda channel_callback_table_hi,y
    sta callback_address+1

    ;Call the channel callback!
    jsr indirect_jsr_callback_address

    sec
    lda stream_tempo_counter_lo,x
    sbc #<256
    sta stream_tempo_counter_lo,x
    lda stream_tempo_counter_hi,x
    sbc #>256
    sta stream_tempo_counter_hi,x
    bcs @do_not_advance_note_length_counter

    ;Reset tempo counter when we cross 0 by adding original tempo back on.
    ;This way we have a wrap-around value that does not get lost when we count
    ;down to the next note.
    clc
    lda stream_tempo_counter_lo,x
    adc stream_tempo_lo,x
    sta stream_tempo_counter_lo,x
    lda stream_tempo_counter_hi,x
    adc stream_tempo_hi,x
    sta stream_tempo_counter_hi,x

    ;Decrement the note length counter.. On zero, advance the stream's read address.
    sec
    lda stream_note_length_counter_lo,x
    sbc #<1
    sta stream_note_length_counter_lo,x
    lda stream_note_length_counter_hi,x
    sbc #>1
    sta stream_note_length_counter_hi,x

    lda stream_note_length_counter_lo,x
    ora stream_note_length_counter_hi,x

    bne @note_length_counter_not_zero

    ;Reset the note length counter.
    lda stream_note_length_lo,x
    sta stream_note_length_counter_lo,x
    lda stream_note_length_hi,x
    sta stream_note_length_counter_hi,x

    ldy stream_instrument_index,x
    lda (base_address_instruments),y
    sta sound_local_word_0
    iny
    lda (base_address_instruments),y
    sta sound_local_word_0+1
    ldy #0
    lda (sound_local_word_0),y
    sta stream_volume_offset,x
    iny
    lda (sound_local_word_0),y
    sta stream_pitch_offset,x
    iny
    lda (sound_local_word_0),y
    sta stream_duty_offset,x
    ifdef FEATURE_ARPEGGIOS
    iny
    lda (sound_local_word_0),y
    sta stream_arpeggio_offset,x
    endif

    ;Reset silence until note and pitch loaded flags.
    lda stream_flags,x
    and #STREAM_SILENCE_CLEAR
    and #STREAM_PITCH_LOADED_CLEAR
    sta stream_flags,x

    ;Advance the stream's read address.
    advance_stream_read_address
@do_not_advance_note_length_counter:
@note_length_counter_not_zero:

    rts

indirect_jsr_callback_address:
    jmp (callback_address)
    rts


sound_initialize_apu_buffer:

    ;****************************************************************
    ;Initialize Square 1
    ;****************************************************************

    ;Set Saw Envelope Disable and Length Counter Disable to 1 for square 1.
    lda #%00110000
    sta apu_register_sets

    ;Set Negate flag on the sweep unit.
    lda #$08
    sta apu_register_sets+1

    ;Set period to C9, which is a C#...just in case nobody writes to it.
    lda #$C9
    sta apu_register_sets+2

    ;Make sure the old value starts out different from the first default value.
    sta apu_square_1_old

    lda #$00
    sta apu_register_sets+3

    ;****************************************************************
    ;Initialize Square 2
    ;****************************************************************

    ;Set Saw Envelope Disable and Length Counter Disable to 1 for square 2.
    lda #%00110000
    sta apu_register_sets+4

    ;Set Negate flag on the sweep unit.
    lda #$08
    sta apu_register_sets+5

    ;Set period to C9, which is a C#...just in case nobody writes to it.
    lda #$C9
    sta apu_register_sets+6

    ;Make sure the old value starts out different from the first default value.
    sta apu_square_2_old

    lda #$00
    sta apu_register_sets+7

    ;****************************************************************
    ;Initialize Triangle
    ;****************************************************************
    lda #%10000000
    sta apu_register_sets+8

    lda #$C9
    sta apu_register_sets+10

    lda #$00
    sta apu_register_sets+11

    ;****************************************************************
    ;Initialize Noise
    ;****************************************************************
    lda #%00110000
    sta apu_register_sets+12

    lda #%00000000
    sta apu_register_sets+13

    lda #%00000000
    sta apu_register_sets+14

    lda #%00000000
    sta apu_register_sets+15

    ifdef FEATURE_DPCM
    ;****************************************************************
    ;Initialize DPCM
    ;****************************************************************
    lda #0
    sta apu_register_sets+16

    lda #0
    sta apu_register_sets+17

    lda #0
    sta apu_register_sets+18

    lda #0
    sta apu_register_sets+19
    endif

    rts

sound_upload:

    lda apu_data_ready
    beq @apu_data_not_ready

    jsr sound_upload_apu_register_sets

@apu_data_not_ready:

    rts

sound_upload_apu_register_sets:
@square1:
    lda apu_register_sets+0
    sta $4000
    lda apu_register_sets+1
    sta $4001
    lda apu_register_sets+2
    sta $4002
    lda apu_register_sets+3
    ;Compare to last write.
    cmp apu_square_1_old
    ;Don't write this frame if they were equal.
    beq @square2
    sta $4003
    ;Save the value we just wrote to $4003.
    sta apu_square_1_old
@square2:
    lda apu_register_sets+4
    sta $4004
    lda apu_register_sets+5
    sta $4005
    lda apu_register_sets+6
    sta $4006
    lda apu_register_sets+7
    cmp apu_square_2_old
    beq @triangle
    sta $4007
    ;Save the value we just wrote to $4007.
    sta apu_square_2_old
@triangle:
    lda apu_register_sets+8
    sta $4008
    lda apu_register_sets+10
    sta $400A
    lda apu_register_sets+11
    sta $400B
@noise:
    lda apu_register_sets+12
    sta $400C
    lda apu_register_sets+14
    ;Our notes go from 0 to 15 (low to high)
    ;but noise channel's low to high is 15 to 0.
    eor #$0f
    sta $400E
    lda apu_register_sets+15
    sta $400F

    ;Clear out all volume values from this frame in case a sound effect is killed suddenly.
    lda #%00110000
    sta apu_register_sets
    sta apu_register_sets+4
    sta apu_register_sets+12
    lda #%10000000
    sta apu_register_sets+8

    ifdef FEATURE_DPCM
    ;Now execute DPCM command/state machine. This state machine has logic for allowing
    ;a DPCM sound effect to override the currenty playing music DPCM sample until finished.
@dpcm:
    ldx apu_dpcm_state
    lda @dpcm_state_callback_hi,x
    pha
    lda @dpcm_state_callback_lo,x
    pha
    rts
@dpcm_upload:
    jsr @dpcm_upload_registers
    lda #DPCM_STATE_NOP
    sta apu_dpcm_state
    rts
@dpcm_upload_then_wait:
    jsr @dpcm_upload_registers
    lda #DPCM_STATE_WAIT
    sta apu_dpcm_state
    rts
@dpcm_wait:
    lda $4015
    and #%00010000
    bne @skip
    lda #DPCM_STATE_NOP
    sta apu_dpcm_state
@skip:
    rts
@dpcm_nop:
    rts

@dpcm_state_callback_lo:
    db <(@dpcm_nop-1)
    db <(@dpcm_upload-1)
    db <(@dpcm_upload_then_wait-1)
    db <(@dpcm_wait-1)

@dpcm_state_callback_hi:
    db >(@dpcm_nop-1)
    db >(@dpcm_upload-1)
    db >(@dpcm_upload_then_wait-1)
    db >(@dpcm_wait-1)

@dpcm_upload_registers:
    lda apu_register_sets+16
    sta $4010
    lda apu_register_sets+18
    sta $4012
    lda apu_register_sets+19
    sta $4013
    ;Restart DPCM channel in case a new note was played before sample finished.
    lda #%00001111
    sta $4015
    lda #%00011111
    sta $4015
    rts
    else
    rts
    endif

}

{		; tracker_data.inc 

song_index_robot_adv = 0
song_index_k466 = 1
song_index_k11 = 2
song_index_soler42 = 3
song_index_antagonist = 4
song_index_arps = 5
song_index_noise_arps = 6

sfx_index_sfx_shot = 0
sfx_index_sfx_laser = 1
sfx_index_sfx_dpcm = 2
sfx_index_sfx_zap = 3
sfx_index_sfx_collide = 4

song_list:
  dw _robot_adv
  dw _k466
  dw _k11
  dw _soler42
  dw _antagonist
  dw _arps
  dw _noise_arps

sfx_list:
  dw _sfx_shot
  dw _sfx_laser
  dw _sfx_dpcm
  dw _sfx_zap
  dw _sfx_collide

instrument_list:
  dw Piano_0
  dw Instrument1_1
  dw Instrument2_2
  dw Instrument3_3
  dw Instrument4_4
  dw Note_cut_5
  dw Shot_6
  dw Instrument5_7
  dw Laser_8
  dw Instrument6_9
  dw Instrument7_10
  dw Instrument8_11
  dw Instrument9_12
  dw Sing_13
  dw Note_Cut_14
  dw dpcm_15
  dw Sing_16
  dw Triangle_On_17
  dw SingMinArp_18
  dw Guitar_19
  dw SingMajArp_20
  dw SingDimArp_21
  dw Zap_22
  dw Collide_23
  dw Drum1_24
  dw Drum2_25
  dw Drum3_26
  dw Triangle_On_27
  dw silent_28

dpcm_list:
  dw dpcm_samples_list
  dw dpcm_note_to_sample_index
  dw dpcm_note_to_sample_length
  dw dpcm_note_to_loop_pitch_index

Piano_0:
  db 5,19,21,23,ARP_TYPE_ABSOLUTE
  db 12,10,6,4,3,4,5,8,10,8,5,3,3,ENV_STOP
  db 0,ENV_STOP
  db 128,DUTY_ENV_STOP
  db ENV_STOP

Instrument1_1:
  db 5,24,26,28,ARP_TYPE_ABSOLUTE
  db 11,8,7,8,10,8,5,3,1,1,2,4,5,5,3,2,1,1,ENV_STOP
  db 0,ENV_STOP
  db 64,DUTY_ENV_STOP
  db ENV_STOP

Instrument2_2:
  db 5,13,15,17,ARP_TYPE_ABSOLUTE
  db 10,10,10,10,10,10,0,ENV_STOP
  db 0,ENV_STOP
  db 64,DUTY_ENV_STOP
  db ENV_STOP

Instrument3_3:
  db 5,11,13,15,ARP_TYPE_ABSOLUTE
  db 12,5,3,1,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Instrument4_4:
  db 5,24,26,28,ARP_TYPE_ABSOLUTE
  db 11,8,7,8,10,8,5,3,1,1,2,4,5,5,3,2,1,1,ENV_STOP
  db 0,ENV_STOP
  db 128,DUTY_ENV_STOP
  db ENV_STOP

Note_cut_5:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Shot_6:
  db 5,38,40,42,ARP_TYPE_ABSOLUTE
  db 15,6,10,11,11,10,9,8,7,6,5,4,3,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Instrument5_7:
  db 5,14,16,18,ARP_TYPE_ABSOLUTE
  db 14,14,14,11,4,2,2,2,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Laser_8:
  db 5,22,37,39,ARP_TYPE_ABSOLUTE
  db 14,13,12,11,10,9,8,8,7,6,5,4,3,2,1,0,ENV_STOP
  db 10,10,10,10,10,10,10,10,10,10,10,10,10,10,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Instrument6_9:
  db 5,14,16,19,ARP_TYPE_ABSOLUTE
  db 6,9,11,11,7,6,5,5,ENV_STOP
  db 0,ENV_STOP
  db 128,0,DUTY_ENV_STOP
  db ENV_STOP

Instrument7_10:
  db 5,12,14,16,ARP_TYPE_ABSOLUTE
  db 15,2,0,0,0,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Instrument8_11:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Instrument9_12:
  db 5,14,16,18,ARP_TYPE_ABSOLUTE
  db 9,9,9,6,2,1,1,1,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Sing_13:
  db 5,27,48,50,ARP_TYPE_ABSOLUTE
  db 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,38
  db 192,DUTY_ENV_STOP
  db ENV_STOP

Note_Cut_14:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

dpcm_15:
  db 5,14,16,18,ARP_TYPE_ABSOLUTE
  db 8,4,3,2,2,1,1,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Sing_16:
  db 5,27,48,50,ARP_TYPE_ABSOLUTE
  db 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,38
  db 128,DUTY_ENV_STOP
  db ENV_STOP

Triangle_On_17:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 1,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

SingMinArp_18:
  db 5,27,48,50,ARP_TYPE_ABSOLUTE
  db 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,38
  db 128,DUTY_ENV_STOP
  db 0,3,7,12,ENV_LOOP,50

Guitar_19:
  db 5,70,91,94,ARP_TYPE_ABSOLUTE
  db 3,3,4,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,1,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,81
  db 192,64,DUTY_ENV_STOP
  db ENV_STOP

SingMajArp_20:
  db 5,27,48,50,ARP_TYPE_ABSOLUTE
  db 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,38
  db 128,DUTY_ENV_STOP
  db 0,4,7,12,ENV_LOOP,50

SingDimArp_21:
  db 5,27,48,50,ARP_TYPE_ABSOLUTE
  db 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
  db 0,0,0,0,0,0,0,0,0,255,255,1,1,1,1,255,255,255,255,ENV_LOOP,38
  db 128,DUTY_ENV_STOP
  db 0,3,6,12,ENV_LOOP,50

Zap_22:
  db 5,22,24,26,ARP_TYPE_ABSOLUTE
  db 14,13,12,11,10,9,8,8,7,6,5,4,3,2,1,0,ENV_STOP
  db 0,ENV_STOP
  db 64,DUTY_ENV_STOP
  db ENV_STOP

Collide_23:
  db 5,22,37,39,ARP_TYPE_ABSOLUTE
  db 14,13,12,11,10,9,8,8,7,6,5,4,3,2,1,0,ENV_STOP
  db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,ENV_STOP
  db 192,DUTY_ENV_STOP
  db ENV_STOP

Drum1_24:
  db 5,15,17,19,ARP_TYPE_FIXED
  db 5,4,3,3,2,2,1,1,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db 7,ENV_STOP

Drum2_25:
  db 5,11,13,15,ARP_TYPE_ABSOLUTE
  db 4,3,2,1,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

Drum3_26:
  db 5,25,27,29,ARP_TYPE_FIXED
  db 4,4,5,5,6,6,5,5,4,4,3,3,2,2,1,1,1,1,0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db 0,1,2,3,4,5,6,7,8,ENV_STOP

Triangle_On_27:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 1,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

silent_28:
  db 5,7,9,11,ARP_TYPE_ABSOLUTE
  db 0,ENV_STOP
  db 0,ENV_STOP
  db 0,DUTY_ENV_STOP
  db ENV_STOP

dpcm_samples_list:
  db <(dpcm_sample_bde >> 6)
  db <(dpcm_sample_sd1 >> 6)
  db <(dpcm_sample_sfx >> 6)

dpcm_note_to_sample_index:
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$01,$02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

dpcm_note_to_sample_length:
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0f,$2f,$86,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

dpcm_note_to_loop_pitch_index:
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0f,$0f,$0f,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

_robot_adv:
  db 0
  db 6
  db 0
  db 5
  dw _robot_adv_square1
  dw _robot_adv_square2
  dw _robot_adv_triangle
  dw _robot_adv_noise
  dw _robot_adv_dpcm

_robot_adv_square1:
_robot_adv_square1_loop:
  db CAL,<(_robot_adv_square1_0),>(_robot_adv_square1_0)
  db CAL,<(_robot_adv_square1_1),>(_robot_adv_square1_1)
  db CAL,<(_robot_adv_square1_2),>(_robot_adv_square1_2)
  db CAL,<(_robot_adv_square1_3),>(_robot_adv_square1_3)
  db GOT
  dw _robot_adv_square1_loop

_robot_adv_square2:
_robot_adv_square2_loop:
  db CAL,<(_robot_adv_square2_0),>(_robot_adv_square2_0)
  db CAL,<(_robot_adv_square2_1),>(_robot_adv_square2_1)
  db CAL,<(_robot_adv_square2_2),>(_robot_adv_square2_2)
  db CAL,<(_robot_adv_square2_3),>(_robot_adv_square2_3)
  db GOT
  dw _robot_adv_square2_loop

_robot_adv_triangle:
_robot_adv_triangle_loop:
  db CAL,<(_robot_adv_triangle_0),>(_robot_adv_triangle_0)
  db CAL,<(_robot_adv_triangle_1),>(_robot_adv_triangle_1)
  db CAL,<(_robot_adv_triangle_2),>(_robot_adv_triangle_2)
  db CAL,<(_robot_adv_triangle_3),>(_robot_adv_triangle_3)
  db GOT
  dw _robot_adv_triangle_loop

_robot_adv_noise:
_robot_adv_noise_loop:
  db CAL,<(_robot_adv_noise_0),>(_robot_adv_noise_0)
  db CAL,<(_robot_adv_noise_1),>(_robot_adv_noise_1)
  db CAL,<(_robot_adv_noise_2),>(_robot_adv_noise_2)
  db CAL,<(_robot_adv_noise_3),>(_robot_adv_noise_3)
  db GOT
  dw _robot_adv_noise_loop

_robot_adv_dpcm:
_robot_adv_dpcm_loop:
  db CAL,<(_robot_adv_dpcm_0),>(_robot_adv_dpcm_0)
  db CAL,<(_robot_adv_dpcm_0),>(_robot_adv_dpcm_0)
  db CAL,<(_robot_adv_dpcm_0),>(_robot_adv_dpcm_0)
  db CAL,<(_robot_adv_dpcm_0),>(_robot_adv_dpcm_0)
  db GOT
  dw _robot_adv_dpcm_loop

_robot_adv_square1_0:
  db STI,19,SL1,DS3,D3,C3,D3,SL4,C3,SL1,C3,STI,28,A0,STI,19
  db C3,STI,28,A0,STI,19,C3,C3,STI,28,SL2,A0,STI,19,SL1,D3,C3
  db B2,C3,SL4,B2,SL1,B2,STI,28,A0,STI,19,B2,STI,28,A0,STI,19
  db B2,B2,STI,28,SL2,A0,STI,19,SL1,C3,B2,A2,B2,SL8,A2,SL4,A2
  db SL8,G2,SL1,DS3,D3,C3,B2,C3,B2,A2,G2
  db RET

_robot_adv_square1_1:
  db STI,19,SL1,DS3,D3,C3,D3,SL4,C3,SL1,C3,STI,28,A0,STI,19
  db C3,STI,28,A0,STI,19,C3,C3,STI,28,SL2,A0,STI,19,SL1,D3,C3
  db B2,C3,SL4,B2,SL1,B2,STI,28,A0,STI,19,B2,STI,28,A0,STI,19
  db B2,B2,STI,28,SL2,A0,STI,19,SL1,C3,B2,A2,B2,SL8,A2,SL4,A2
  db SL8,G2,SL1,DS3,D3,C3,B2,C3,B2,C3,D3
  db RET

_robot_adv_square1_2:
  db STI,19,SL1,AS2,C3,AS2,SL5,C3,SL1,C3,AS2,GS2,G2,F2,DS2,D2
  db C2,SL0,D2,SL1,C3,D3,C3,SL5,D3,SL1,D3,C3,B2,A2,B2,C3,D3,F3
  db SL0,DS3
  db RET

_robot_adv_square1_3:
  db STI,19,SL1,AS2,C3,AS2,SL5,C3,SL1,C3,AS2,C3,D3,DS3,F3,G3,AS3
  db SL0,F3,SL1,AS3,B3,AS3,SL5,B3,SL1,G4,F4,DS4,D4,C4,B3,A3,G3
  db SL0,DS3
  db RET

_robot_adv_square2_0:
  db STI,19,SL1,G3,F3,DS3,F3,SL4,DS3,SL1,DS3,STI,28,A0,STI,19
  db DS3,STI,28,A0,STI,19,DS3,DS3,STI,28,SL2,A0,STI,19,SL1,F3
  db DS3,D3,DS3,SL4,D3,SL1,D3,STI,28,A0,STI,19,D3,STI,28,A0,STI,19
  db D3,D3,STI,28,SL2,A0,STI,19,SL1,DS3,D3,C3,D3,SL8,C3,SL4,FS3
  db SL8,G3,SL1,G3,F3,DS3,D3,DS3,D3,C3,B2
  db RET

_robot_adv_square2_1:
  db STI,19,SL1,G3,F3,DS3,F3,SL4,DS3,SL1,DS3,STI,28,A0,STI,19
  db DS3,STI,28,A0,STI,19,DS3,DS3,STI,28,SL2,A0,STI,19,SL1,F3
  db DS3,D3,DS3,SL4,D3,SL1,D3,STI,28,A0,STI,19,D3,STI,28,A0,STI,19
  db D3,D3,STI,28,SL2,A0,STI,19,SL1,DS3,D3,C3,D3,SL8,C3,SL4,A3
  db SL8,B3,SL1,G3,F3,DS3,D3,DS3,D3,DS3,F3
  db RET

_robot_adv_square2_2:
  db STI,19,SL1,G3,GS3,G3,SL5,GS3,SL1,GS3,G3,F3,DS3,D3,C3,AS2
  db GS2,SL0,AS2,SL1,DS3,F3,DS3,SL5,F3,SL1,F3,DS3,D3,C3,D3,G2
  db A2,B2,SL0,C3
  db RET

_robot_adv_square2_3:
  db STI,19,SL1,G3,GS3,G3,SL5,GS3,SL1,GS3,G3,GS3,AS3,C4,D4,DS4
  db F4,SL0,D4,SL1,FS4,G4,FS4,SL5,G4,SL1,B4,A4,G4,F4,DS4,D4,C4
  db B3,SL0,C4
  db RET

_robot_adv_triangle_0:
  db STI,27,SL1,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,SL3,C3
  db STI,28,SL1,A0,STI,27,SL3,C3,STI,28,SL1,A0,STI,27,SL3,C3,STI,28
  db SL1,A0,STI,27,G3,STI,28,A0,STI,27,G3,STI,28,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,SL3,G3,STI,28,SL1,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,A3,STI,28,A0,STI,27,A3,STI,28
  db A0,STI,27,SL3,A3,STI,28,SL1,A0,STI,27,SL3,FS3,STI,28
  db SL1,A0,STI,27,SL3,FS3,STI,28,SL1,A0,STI,27,G3,STI,28
  db A0,STI,27,G3,STI,28,A0,STI,27,SL3,G3,STI,28,SL1,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,SL3,D3,STI,28,SL1,A0
  db RET

_robot_adv_triangle_1:
  db STI,27,SL1,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,SL3,C3
  db STI,28,SL1,A0,STI,27,SL3,C3,STI,28,SL1,A0,STI,27,SL3,C3,STI,28
  db SL1,A0,STI,27,G3,STI,28,A0,STI,27,G3,STI,28,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,SL3,G3,STI,28,SL1,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,A3,STI,28,A0,STI,27,A3,STI,28
  db A0,STI,27,SL3,A3,STI,28,SL1,A0,STI,27,SL3,FS3,STI,28
  db SL1,A0,STI,27,SL3,FS3,STI,28,SL1,A0,STI,27,G3,STI,28
  db A0,STI,27,G3,STI,28,A0,STI,27,SL3,G3,STI,28,SL1,A0,STI,27
  db SL3,G3,STI,28,SL1,A0,STI,27,SL3,D3,STI,28,SL1,A0
  db RET

_robot_adv_triangle_2:
  db STI,27,SL1,GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27
  db GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27,GS2,STI,28
  db A0,STI,27,GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27,GS2
  db STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27
  db AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28
  db A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2
  db STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0
  db RET

_robot_adv_triangle_3:
  db STI,27,SL1,GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27
  db GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27,GS2,STI,28
  db A0,STI,27,GS2,STI,28,A0,STI,27,GS2,STI,28,A0,STI,27,GS2
  db STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27
  db AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28
  db A0,STI,27,AS2,STI,28,A0,STI,27,AS2,STI,28,A0,STI,27,AS2
  db STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27,B2,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27,C3,STI,28,A0,STI,27
  db C3,STI,28,A0,STI,27,C3,STI,28,A0
  db RET

_robot_adv_noise_0:
  db STI,15,SL1,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15
  db 13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14
  db 15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15
  db 14,15,13,15,14,15,13,15,14,15
  db RET

_robot_adv_noise_1:
  db STI,15,SL1,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15
  db 13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14
  db 15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15
  db 14,15,13,15,14,15,13,15,14,15
  db RET

_robot_adv_noise_2:
  db STI,15,SL1,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15
  db 13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14
  db 15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15
  db 14,15,13,15,14,15,13,15,14,15
  db RET

_robot_adv_noise_3:
  db STI,15,SL1,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15
  db 13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14
  db 15,13,15,14,15,13,15,14,15,13,15,14,15,13,15,14,15,13,15
  db 14,15,13,15,14,15,13,15,14,15
  db RET

_robot_adv_dpcm_0:
  db STI,15,SL1,C3,SL3,C3,SL2,CS3,SL1,C3,SL5,C3,SL2,CS3,C3,SL1
  db C3,SL3,C3,SL2,CS3,SL1,C3,SL3,C3,SL2,C3,CS3,SL1,CS3,CS3,C3
  db SL3,C3,SL2,CS3,SL1,C3,SL5,C3,SL2,CS3,C3,SL1,C3,SL3,C3,SL2
  db CS3,SL1,C3,SL3,C3,SL2,C3,SL1,CS3,CS3,CS3,CS3
  db RET

_k466:
  db 0
  db 7
  db 213
  db 5
  dw _k466_square1
  dw _k466_square2
  dw _k466_triangle
  dw 0
  dw 0

_k466_square1:
_k466_square1_loop:
  db CAL,<(_k466_square1_0),>(_k466_square1_0)
  db CAL,<(_k466_square1_1),>(_k466_square1_1)
  db CAL,<(_k466_square1_2),>(_k466_square1_2)
  db CAL,<(_k466_square1_3),>(_k466_square1_3)
  db CAL,<(_k466_square1_4),>(_k466_square1_4)
  db CAL,<(_k466_square1_5),>(_k466_square1_5)
  db CAL,<(_k466_square1_6),>(_k466_square1_6)
  db CAL,<(_k466_square1_7),>(_k466_square1_7)
  db GOT
  dw _k466_square1_loop

_k466_square2:
_k466_square2_loop:
  db CAL,<(_k466_square2_0),>(_k466_square2_0)
  db CAL,<(_k466_square2_1),>(_k466_square2_1)
  db CAL,<(_k466_square2_2),>(_k466_square2_2)
  db CAL,<(_k466_square2_3),>(_k466_square2_3)
  db CAL,<(_k466_square2_4),>(_k466_square2_4)
  db CAL,<(_k466_square2_5),>(_k466_square2_5)
  db CAL,<(_k466_square2_6),>(_k466_square2_6)
  db CAL,<(_k466_square2_7),>(_k466_square2_7)
  db GOT
  dw _k466_square2_loop

_k466_triangle:
_k466_triangle_loop:
  db CAL,<(_k466_triangle_0),>(_k466_triangle_0)
  db CAL,<(_k466_triangle_1),>(_k466_triangle_1)
  db CAL,<(_k466_triangle_2),>(_k466_triangle_2)
  db CAL,<(_k466_triangle_3),>(_k466_triangle_3)
  db CAL,<(_k466_triangle_3),>(_k466_triangle_3)
  db CAL,<(_k466_triangle_3),>(_k466_triangle_3)
  db CAL,<(_k466_triangle_3),>(_k466_triangle_3)
  db CAL,<(_k466_triangle_3),>(_k466_triangle_3)
  db GOT
  dw _k466_triangle_loop

_k466_square1_0:
  db STI,28,SL3,A0,STI,0,GS4,C5,GS4,F4,C4,CS4,GS3,AS3,G4,AS4
  db G4,E4,C4,CS4,AS3
  db RET

_k466_square1_1:
  db STI,0,SL3,C4,F4,GS4,F4,C4,GS3,F3,C3,CS4,E3,F3,C4,G3,AS3
  db GS3,G3
  db RET

_k466_square1_2:
  db STI,5,SLL,18,C4,STI,0,SL2,E4,F4,G4,F4,E4,SLE,F4,SL2,E4,F4
  db G4
  db RET

_k466_square1_3:
  db STI,0,SL2,F4,E4,SLE,F4,SL2,D4,DS4,F4,DS4,D4,SLE,C4,SL2,B3
  db C4,D4
  db RET

_k466_square1_4:
  db STI,0,SL2,C4,B3,SLE,C4,SL2,B3,C4,D4,SL3,G4,F4,F4,DS4,DS4
  db D4,D4,C4
  db RET

_k466_square1_5:
  db STI,0,SLL,18,B3,SL2,C4,B3,C4,SLL,18,D4,SL2,C4,B3,C4
  db RET

_k466_square1_6:
  db STI,0,SLL,18,D4,SL2,D4,DS4,F4,DS4,D4,SLE,C4,SL2,D4,DS4,F4
  db RET

_k466_square1_7:
  db STI,0,SL3,G3,F4,DS4,C4,F4,D4,C4,B3,SLL,24,C4
  db RET

_k466_square2_0:
  db STI,0,SLC,F2,F2,G2,G2
  db RET

_k466_square2_1:
  db STI,0,SLC,GS3,GS3,SL6,AS3,GS3,G3,C3
  db RET

_k466_square2_2:
  db STI,0,SL3,F2,F3,GS3,F3,CS3,AS2,G2,E3,GS2,F3,GS3,F3,CS3,AS2
  db G2,E3
  db RET

_k466_square2_3:
  db STI,0,SL3,GS2,F3,GS3,F3,D3,F3,G2,B2,C2,C3,DS3,C3,GS2,C3,D2
  db B2
  db RET

_k466_square2_4:
  db STI,0,SL3,DS2,C3,DS3,C3,GS2,C3,D2,B2,SL6,DS2,C3,F2,GS2
  db RET

_k466_square2_5:
  db STI,0,SL3,G2,F3,GS3,F3,D3,F3,GS2,F3,G2,F3,GS3,F3,D3,F3,GS2
  db F3
  db RET

_k466_square2_6:
  db STI,0,SL3,G2,F3,GS3,F3,D3,F3,G2,B2,C2,C3,DS3,C3,GS2,C3,F2
  db GS2
  db RET

_k466_square2_7:
  db STI,0,SLC,G1,G1,SLL,24,C1
  db RET

_k466_triangle_0:
  db STI,28,SLL,24,A0,STI,0,SLC,F3,E3
  db RET

_k466_triangle_1:
  db STI,0,SLC,F3,C3,SL6,CS3,C3,AS2,C3
  db RET

_k466_triangle_2:
  db STI,5,SLL,48,C4
  db RET

_k466_triangle_3:
  db STI,28,SLL,48,A0
  db RET

_k11:
  db 0
  db 5
  db 42
  db 4
  dw _k11_square1
  dw _k11_square2
  dw _k11_triangle
  dw _k11_noise
  dw 0

_k11_square1:
_k11_square1_loop:
  db CAL,<(_k11_square1_0),>(_k11_square1_0)
  db CAL,<(_k11_square1_1),>(_k11_square1_1)
  db CAL,<(_k11_square1_2),>(_k11_square1_2)
  db CAL,<(_k11_square1_3),>(_k11_square1_3)
  db CAL,<(_k11_square1_4),>(_k11_square1_4)
  db CAL,<(_k11_square1_5),>(_k11_square1_5)
  db CAL,<(_k11_square1_6),>(_k11_square1_6)
  db GOT
  dw _k11_square1_loop

_k11_square2:
_k11_square2_loop:
  db CAL,<(_k11_square2_0),>(_k11_square2_0)
  db CAL,<(_k11_square2_1),>(_k11_square2_1)
  db CAL,<(_k11_square2_2),>(_k11_square2_2)
  db CAL,<(_k11_square2_3),>(_k11_square2_3)
  db CAL,<(_k11_square2_4),>(_k11_square2_4)
  db CAL,<(_k11_square2_5),>(_k11_square2_5)
  db CAL,<(_k11_square2_6),>(_k11_square2_6)
  db GOT
  dw _k11_square2_loop

_k11_triangle:
_k11_triangle_loop:
  db CAL,<(_k11_triangle_0),>(_k11_triangle_0)
  db CAL,<(_k11_triangle_1),>(_k11_triangle_1)
  db CAL,<(_k11_triangle_2),>(_k11_triangle_2)
  db CAL,<(_k11_triangle_3),>(_k11_triangle_3)
  db CAL,<(_k11_triangle_4),>(_k11_triangle_4)
  db CAL,<(_k11_triangle_5),>(_k11_triangle_5)
  db CAL,<(_k11_triangle_6),>(_k11_triangle_6)
  db GOT
  dw _k11_triangle_loop

_k11_noise:
_k11_noise_loop:
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db CAL,<(_k11_noise_0),>(_k11_noise_0)
  db GOT
  dw _k11_noise_loop

_k11_square1_0:
  db STI,1,SL8,G3,SL1,C4,B3,C4,B3,C4,B3,A3,B3,SLC,C4,SL4,D4,DS4
  db F4,G4,C4,B3,A3,G3,F3
  db RET

_k11_square1_1:
  db STI,1,SL4,DS3,F3,G3,C3,B2,A2,G2,D4,DS4,F4,G4,C4,B3,A3,G3
  db D4
  db RET

_k11_square1_2:
  db STI,4,SL4,DS4,G3,D4,G3,C4,SL2,B3,A3,B3,G3,B3,D4,SL4,DS4
  db G3,D4,G3,C4,SL2,B3,A3,B3,G3,B3,D4
  db RET

_k11_square1_3:
  db STI,4,SL4,F4,G3,DS4,G3,D4,SL2,C4,B3,C4,G3,C4,DS4,SL4,F4,G3
  db DS4,G3,D4,SL2,C4,B3,C4,G3,C4,DS4
  db RET

_k11_square1_4:
  db STI,1,SL2,DS4,D4,C4,AS3,C4,AS3,A3,G3,A3,G3,FS3,E3,FS3,D3
  db E3,FS3,G3,D3,G3,AS3,SL4,D4,C4,SL1,C4,AS3,C4,AS3,C4,AS3,A3
  db G3,AS3,A3,AS3,A3,AS3,A3,G3,FS3
  db RET

_k11_square1_5:
  db STI,1,SL2,G3,D3,G3,AS3,SL4,D4,C4,SL1,C4,AS3,C4,AS3,C4,AS3
  db A3,G3,AS3,A3,AS3,A3,AS3,A3,G3,FS3,SL2,D4,G3,AS3,D4,SL4,G4
  db C4,SL1,C4,AS3,C4,AS3,C4,AS3,A3,G3,AS3,A3,AS3,A3,AS3,A3,G3
  db FS3
  db RET

_k11_square1_6:
  db STI,1,SL2,G3,G4,F4,DS4,D4,C4,B3,A3,G3,G3,F3,DS3,D3,C3,B2
  db A2,SL8,G2,D4,SL0,G4
  db RET

_k11_square2_0:
  db STI,1,SL8,C3,D3,SL4,DS3,D3,C3,B2,C3,D3,DS3,F3,G3,A2,B2,G2
  db RET

_k11_square2_1:
  db STI,1,SL4,C2,D2,DS2,F2,SL8,G2,SL4,G1,B2,C3,D3,DS3,F3,SL0
  db G3
  db RET

_k11_square2_2:
  db STI,4,SL8,G4,F4,DS4,D4,G4,F4,DS4,D4
  db RET

_k11_square2_3:
  db STI,4,SL8,GS4,G4,F4,DS4,GS4,G4,F4,DS4
  db RET

_k11_square2_4:
  db STI,1,SL4,C5,AS4,A4,G4,FS4,E4,D4,C4,SLC,AS3,SL4,DS3,SL8
  db D3,C3
  db RET

_k11_square2_5:
  db STI,1,SLC,AS2,SL4,DS3,SL8,D3,C3,SLC,AS2,SL4,C2,SL8,D2,D1
  db RET

_k11_square2_6:
  db STI,1,SLL,34,G1,SL2,D2,E2,FS2,G2,B1,C2,D2,SL0,G1
  db RET

_k11_triangle_0:
  db STI,2,SL8,C3,D3,SL4,DS3,D3,C3,B2,C3,D3,DS3,F3,G3,A2,B2,G2
  db RET

_k11_triangle_1:
  db STI,2,SL4,C2,D2,DS2,F2,SL8,G2,SL4,G1,B2,C3,D3,DS3,F3,SL0
  db G3
  db RET

_k11_triangle_2:
  db STI,2,SL4,DS4,G3,D4,G3,C4,SL2,B3,A3,B3,G3,B3,D4,SL4,DS4
  db G3,D4,G3,C4,SL2,B3,A3,B3,G3,B3,D4
  db RET

_k11_triangle_3:
  db STI,2,SL4,F4,G3,DS4,G3,D4,SL2,C4,B3,C4,G3,C4,DS4,SL4,F4,G3
  db DS4,G3,D4,SL2,C4,B3,C4,G3,C4,DS4
  db RET

_k11_triangle_4:
  db STI,2,SL2,DS4,D4,C4,AS3,C4,AS3,A3,G3,A3,G3,FS3,E3,FS3,D3
  db E3,FS3,G3,D3,G3,AS3,SL4,D4,C4,SL1,C4,AS3,C4,AS3,C4,AS3,A3
  db G3,AS3,A3,AS3,A3,AS3,A3,G3,FS3
  db RET

_k11_triangle_5:
  db STI,1,SLC,AS2,SL4,DS3,SL8,D3,C3,SLC,AS2,SL4,C2,SL8,D2,D1
  db RET

_k11_triangle_6:
  db STI,1,SLL,34,G1,SL2,D2,E2,FS2,G2,B1,C2,D2,SL0,G1
  db RET

_k11_noise_0:
  db STI,3,SL8,3,3,SL4,3,0,3,0,3,0,3,0,3,0,3,0
  db RET

_soler42:
  db 0
  db 3
  db 128
  db 2
  dw _soler42_square1
  dw _soler42_square2
  dw _soler42_triangle
  dw _soler42_noise
  dw 0

_soler42_square1:
_soler42_square1_loop:
  db CAL,<(_soler42_square1_0),>(_soler42_square1_0)
  db CAL,<(_soler42_square1_1),>(_soler42_square1_1)
  db CAL,<(_soler42_square1_2),>(_soler42_square1_2)
  db CAL,<(_soler42_square1_3),>(_soler42_square1_3)
  db CAL,<(_soler42_square1_4),>(_soler42_square1_4)
  db CAL,<(_soler42_square1_5),>(_soler42_square1_5)
  db CAL,<(_soler42_square1_6),>(_soler42_square1_6)
  db CAL,<(_soler42_square1_7),>(_soler42_square1_7)
  db CAL,<(_soler42_square1_8),>(_soler42_square1_8)
  db CAL,<(_soler42_square1_9),>(_soler42_square1_9)
  db CAL,<(_soler42_square1_10),>(_soler42_square1_10)
  db CAL,<(_soler42_square1_11),>(_soler42_square1_11)
  db CAL,<(_soler42_square1_12),>(_soler42_square1_12)
  db CAL,<(_soler42_square1_13),>(_soler42_square1_13)
  db GOT
  dw _soler42_square1_loop

_soler42_square2:
_soler42_square2_loop:
  db CAL,<(_soler42_square2_0),>(_soler42_square2_0)
  db CAL,<(_soler42_square2_1),>(_soler42_square2_1)
  db CAL,<(_soler42_square2_2),>(_soler42_square2_2)
  db CAL,<(_soler42_square2_3),>(_soler42_square2_3)
  db CAL,<(_soler42_square2_4),>(_soler42_square2_4)
  db CAL,<(_soler42_square2_5),>(_soler42_square2_5)
  db CAL,<(_soler42_square2_6),>(_soler42_square2_6)
  db CAL,<(_soler42_square2_7),>(_soler42_square2_7)
  db CAL,<(_soler42_square2_8),>(_soler42_square2_8)
  db CAL,<(_soler42_square2_9),>(_soler42_square2_9)
  db CAL,<(_soler42_square2_10),>(_soler42_square2_10)
  db CAL,<(_soler42_square2_11),>(_soler42_square2_11)
  db CAL,<(_soler42_square2_12),>(_soler42_square2_12)
  db CAL,<(_soler42_square2_13),>(_soler42_square2_13)
  db GOT
  dw _soler42_square2_loop

_soler42_triangle:
_soler42_triangle_loop:
  db CAL,<(_soler42_triangle_0),>(_soler42_triangle_0)
  db CAL,<(_soler42_triangle_1),>(_soler42_triangle_1)
  db CAL,<(_soler42_triangle_2),>(_soler42_triangle_2)
  db CAL,<(_soler42_triangle_3),>(_soler42_triangle_3)
  db CAL,<(_soler42_triangle_4),>(_soler42_triangle_4)
  db CAL,<(_soler42_triangle_5),>(_soler42_triangle_5)
  db CAL,<(_soler42_triangle_6),>(_soler42_triangle_6)
  db CAL,<(_soler42_triangle_7),>(_soler42_triangle_7)
  db CAL,<(_soler42_triangle_8),>(_soler42_triangle_8)
  db CAL,<(_soler42_triangle_9),>(_soler42_triangle_9)
  db CAL,<(_soler42_triangle_10),>(_soler42_triangle_10)
  db CAL,<(_soler42_triangle_11),>(_soler42_triangle_11)
  db CAL,<(_soler42_triangle_12),>(_soler42_triangle_12)
  db CAL,<(_soler42_triangle_13),>(_soler42_triangle_13)
  db GOT
  dw _soler42_triangle_loop

_soler42_noise:
_soler42_noise_loop:
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_0),>(_soler42_noise_0)
  db CAL,<(_soler42_noise_1),>(_soler42_noise_1)
  db GOT
  dw _soler42_noise_loop

_soler42_square1_0:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db RET

_soler42_square1_1:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1
  db AS1,AS2,C2,D2,D3,FS3,D3,C3,A2
  db RET

_soler42_square1_2:
  db STI,7,SL4,AS2,D3,G2,FS2,D3,D2,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db RET

_soler42_square1_3:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1
  db AS1,AS2,C2,D2,D3,FS3,D3,C3,A2
  db RET

_soler42_square1_4:
  db STI,7,SL2,A2,STI,12,A2,STI,7,A3,STI,12,A3,STI,7,C4,STI,12
  db C4,STI,7,A3,STI,12,A3,STI,7,FS3,STI,12,FS3,STI,7,D3,STI,12
  db D3,STI,7,G2,STI,12,G2,STI,7,G3,STI,12,G3,STI,7,AS3,STI,12
  db AS3,STI,7,G3,STI,12,G3,STI,7,E3,STI,12,E3,STI,7,C3,STI,12
  db C3,STI,7,F2,STI,12,F2,STI,7,F3,STI,12,F3,STI,7,A3,STI,12
  db A3,STI,7,F3,STI,12,F3,STI,7,D3,STI,12,D3,STI,7,AS2,STI,12
  db AS2,STI,7,E2,STI,12,E2,STI,7,E3,STI,12,E3,STI,7,G3,STI,12
  db G3,STI,7,E3,STI,12,E3,STI,7,CS3,STI,12,CS3,STI,7,A2,STI,12
  db A2
  db RET

_soler42_square1_5:
  db STI,7,SL4,D2,D3,F3,C2,C3,E3,AS1,AS2,D3,A1,A2,C3,G1,G2,AS2
  db F1,F2,A2,E1,E2,G2,D1,D2,F2
  db RET

_soler42_square1_6:
  db STI,7,SL4,A0,CS1,E1,A1,CS2,E2,A1,CS2,E2,A2,CS3,E3,A1,A2,B1
  db CS2,A2,D2,E2,A2,F2,G2,A2,F2
  db RET

_soler42_square1_7:
  db STI,7,SL4,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2,E2,A2,F2
  db G2,A2,F2,E2,A2,D2,CS2,A2,D2
  db RET

_soler42_square1_8:
  db STI,7,SL4,A1,A2,CS3,A2,E2,CS2,D2,D3,F3,A3,F3,D3,G1,G2,AS2
  db D3,AS2,G2,A1,A2,D3,A1,A2,CS3
  db RET

_soler42_square1_9:
  db STI,7,SL4,D1,D2,F2,A2,F2,D2,A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2
  db A2,F2,E2,A2,D2,CS2,A2,D2
  db RET

_soler42_square1_10:
  db STI,7,SL4,A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2
  db A2,D2,A1,A2,CS3,A2,E2,CS2
  db RET

_soler42_square1_11:
  db STI,7,SL2,D1,STI,12,D1,STI,7,D2,STI,12,D2,STI,7,F2,STI,12
  db F2,STI,7,A2,STI,12,A2,STI,7,F2,STI,12,F2,STI,7,D2,STI,12
  db D2,STI,7,G1,STI,12,G1,STI,7,G2,STI,12,G2,STI,7,AS2,STI,12
  db AS2,STI,7,D3,STI,12,D3,STI,7,AS2,STI,12,AS2,STI,7,G2,STI,12
  db G2,STI,7,A1,STI,12,A1,STI,7,A2,STI,12,A2,STI,7,D3,STI,12
  db D3,STI,7,A1,STI,12,A1,STI,7,A2,STI,12,A2,STI,7,CS3,STI,12
  db CS3,STI,7,D2,STI,12,D2,STI,7,D3,STI,12,D3,STI,7,F3,STI,12
  db F3,STI,7,A3,STI,12,A3,STI,7,F3,STI,12,F3,STI,7,D3,STI,12
  db D3
  db RET

_soler42_square1_12:
  db STI,7,SL2,G1,STI,12,G1,STI,7,G2,STI,12,G2,STI,7,AS2,STI,12
  db AS2,STI,7,D3,STI,12,D3,STI,7,AS2,STI,12,AS2,STI,7,G2,STI,12
  db G2,STI,7,A1,STI,12,A1,STI,7,A2,STI,12,A2,STI,7,D3,STI,12
  db D3,STI,7,A1,STI,12,A1,STI,7,A2,STI,12,A2,STI,7,CS3,STI,12
  db CS3,STI,7,D2,STI,12,D2,STI,7,A2,STI,12,A2,STI,7,CS2,STI,12
  db CS2,STI,7,D2,STI,12,D2,STI,7,A2,STI,12,A2,STI,7,CS2,STI,12
  db CS2,STI,7,D2,STI,12,D2,STI,7,A2,STI,12,A2,STI,7,CS2,STI,12
  db CS2,STI,7,D2,STI,12,D2,STI,7,A2,STI,12,A2,STI,7,CS2,STI,12
  db CS2
  db RET

_soler42_square1_13:
  db STI,7,SL4,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,E2,D2
  db C2,AS1,A1
  db RET

_soler42_square2_0:
  db STI,28,SL0,A0,STI,9,SL4,D3,SL2,D3,SL1,AS2,D3,SL0,G3,SL4
  db D3,SL2,D3,SL1,AS2,D3,SL0,G3,SL4,D3,SL2,D3,SL1,AS2,D3,SL8
  db G3,SL4,D3,SL8,D3,SL4,C3
  db RET

_soler42_square2_1:
  db STI,9,SL1,C3,AS2,C3,SL5,AS2,SL4,A2,SL1,A2,G2,A2,SL5,G2,SL4
  db A2,SL1,C3,AS2,C3,SL5,AS2,SL4,A2,SL1,A2,G2,A2,SL5,G2,SL4
  db A2,SL1,C3,AS2,C3,SL5,AS2,SL4,C3,SL1,DS3,D3,DS3,SL5,D3,SL4
  db E3,SL1,G3,FS3,G3,SL5,FS3,SL4,G3,A3,AS3,C4
  db RET

_soler42_square2_2:
  db STI,9,SL4,C4,SL8,AS3,SL1,AS3,A3,AS3,SL7,A3,SL1,G3,A3,SL0
  db G3,SL4,D3,SL2,D3,SL1,AS2,D3,SL0,G3,SL4,D3,SL2,D3,SL1,AS2
  db D3,SL8,G3,SL4,D3,SL8,D3,SL4,C3
  db RET

_soler42_square2_3:
  db STI,9,SL1,C3,AS2,C3,SL5,AS2,SL4,A2,SL1,A2,G2,A2,SL5,G2,SL4
  db A2,SL1,C3,AS2,C3,SL5,AS2,SL4,A2,SL1,A2,G2,A2,SL5,G2,SL4
  db A2,SL1,C3,AS2,C3,SL5,AS2,SL4,C3,SL1,DS3,D3,DS3,SL5,D3,SL4
  db E3,SL1,G3,FS3,G3,SL5,FS3,SL4,G3,SL8,A3,SL4,AS3
  db RET

_soler42_square2_4:
  db STI,9,SL1,A3,SLF,C4,SL1,AS3,SL3,D4,SL1,A3,SL3,C4,SL1,A3,SL7
  db C4,SL1,G3,SL7,AS3,SL1,A3,SL3,C4,SL1,G3,SL3,AS3,SL1,G3,SL7
  db AS3,SL1,F3,SL7,A3,SL1,G3,SL3,AS3,SL1,F3,SL3,A3,SL1,F3,SL7
  db A3,SL1,E3,SL7,G3,SL1,F3,SL3,A3,SL1,E3,SL3,G3
  db RET

_soler42_square2_5:
  db STI,9,SL1,G3,F3,G3,SL5,F3,SL4,A3,SL1,F3,E3,F3,SL5,E3,SL4
  db A3,SL1,E3,D3,E3,SL5,D3,SL4,A3,SL1,D3,C3,D3,SL5,C3,SL4,A3
  db SL1,C3,AS2,C3,SL5,AS2,SL4,A3,SL1,AS2,A2,AS2,SL5,A2,SL4,A3
  db SL1,A2,G2,A2,SL5,G2,SL4,A3,SL1,G2,F2,G2,SL5,F2,SL4,A3
  db RET

_soler42_square2_6:
  db STI,9,SL0,E2,SL1,CS3,SL3,E3,SL1,CS3,SL3,E3,SL1,A2,CS3,E3
  db SLD,A3,SL1,CS3,SL3,E3,SL1,CS3,SL3,E3,SL1,A2,CS3,E3,SLL,17
  db A3,SL4,A3,SL1,D3,CS3,D3,SL5,CS3,SL4,D3,SL8,E3,SL4,F3
  db RET

_soler42_square2_7:
  db STI,9,SL1,A3,G3,A3,SL5,G3,SL4,F3,SL8,E3,SL4,F3,SL1,G3,F3
  db G3,SL5,F3,SLC,E3,SL4,A3,SL1,D3,CS3,D3,SL5,CS3,SL4,D3,SL8
  db E3,SL4,F3,SL1,A3,G3,A3,SL5,G3,SL4,F3,SL8,E3,SL4,F3
  db RET

_soler42_square2_8:
  db STI,9,SL1,G3,F3,G3,SL5,F3,SL8,E3,SL4,A3,G3,SL8,G3,F3,SL4
  db D4,C4,SL8,C4,AS3,SL4,AS3,G3,SLC,F3,SL1,CS3,F3,E3,F3,SL8
  db E3
  db RET

_soler42_square2_9:
  db STI,9,SL8,E3,SL6,D3,SL2,A3,G3,F3,E3,D3,SL4,D3,SL0,CS3,SL4
  db A3,SL1,D3,CS3,D3,SL5,CS3,SL4,D3,SL8,E3,SL4,F3,SL1,A3,G3,A3
  db SL5,G3,SL4,F3,SL8,E3,SL4,F3
  db RET

_soler42_square2_10:
  db STI,9,SL1,G3,F3,G3,SL5,F3,SLC,E3,SL4,A3,SL1,D3,CS3,D3,SL5
  db CS3,SL4,D3,SL8,E3,SL4,F3,SL1,A3,G3,A3,SL5,G3,SL4,F3,SL8
  db E3,SL4,F3,SL1,G3,F3,G3,SL5,F3,SL8,E3,SL4,A3,G3
  db RET

_soler42_square2_11:
  db STI,9,SL8,G3,F3,SL4,D4,C4,SL8,C4,AS3,SL4,AS3,G3,SLC,F3,SL1
  db CS3,E3,F3,E3,F3,SL7,E3,SL8,E3,D3,SL4,D4,C4
  db RET

_soler42_square2_12:
  db STI,9,SL8,C4,AS3,SL4,AS3,G3,SLC,F3,SL1,CS3,E3,F3,E3,F3,SL7
  db E3,SL8,D2,SL4,E2,SL8,F2,SL4,E2,SL8,D2,SL4,E2,SL8,F2,SL4
  db E2
  db RET

_soler42_square2_13:
  db STI,9,SL8,D2,SL4,CS2,SL8,D2,SL4,CS2,SL8,D2,SL4,CS2,SL8,D2
  db SL4,CS2,D2,STI,11,SLL,20,F3
  db RET

_soler42_triangle_0:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db RET

_soler42_triangle_1:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1
  db AS1,AS2,C2,D2,D3,FS3,D3,C3,A2
  db RET

_soler42_triangle_2:
  db STI,7,SL4,AS2,D3,G2,FS2,D3,D2,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db G1,G2,FS1,G1,G2,FS1,G1,G2,FS1
  db RET

_soler42_triangle_3:
  db STI,7,SL4,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,FS1,G1,G2,A1
  db AS1,AS2,C2,D2,D3,FS3,D3,C3,A2
  db RET

_soler42_triangle_4:
  db STI,7,SL4,A2,A3,C4,A3,FS3,D3,G2,G3,AS3,G3,E3,C3,F2,F3,A3
  db F3,D3,AS2,E2,E3,G3,E3,CS3,A2
  db RET

_soler42_triangle_5:
  db STI,7,SL4,D2,D3,F3,C2,C3,E3,AS1,AS2,D3,A1,A2,C3,G1,G2,AS2
  db F1,F2,A2,E1,E2,G2,D1,D2,F2
  db RET

_soler42_triangle_6:
  db STI,7,SL4,A0,CS1,E1,A1,CS2,E2,A1,CS2,E2,A2,CS3,E3,A1,A2,B1
  db CS2,A2,D2,E2,A2,F2,G2,A2,F2
  db RET

_soler42_triangle_7:
  db STI,9,SL4,E2,A2,D2,CS2,A2,D2,A1,A2,B1,CS2,A2,D2,E2,A2,F2
  db G2,A2,F2,E2,A2,D2,CS2,A2,D2
  db RET

_soler42_triangle_8:
  db STI,7,SL4,A1,A2,CS3,A2,E2,CS2,D2,D3,F3,A3,F3,D3,G1,G2,AS2
  db D3,AS2,G2,A1,A2,D3,A1,A2,CS3
  db RET

_soler42_triangle_9:
  db STI,7,SL4,D1,D2,F2,A2,F2,D2,A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2
  db A2,F2,E2,A2,D2,CS2,A2,D2
  db RET

_soler42_triangle_10:
  db STI,7,SL4,A1,A2,B1,CS2,A2,D2,E2,A2,F2,G2,A2,F2,E2,A2,D2,CS2
  db A2,D2,A1,A2,CS3,A2,E2,CS2
  db RET

_soler42_triangle_11:
  db STI,7,SL4,D1,D2,F2,A2,F2,D2,G1,G2,AS2,D3,AS2,G2,A1,A2,D3
  db A1,A2,CS3,D2,D3,F3,A3,F3,D3
  db RET

_soler42_triangle_12:
  db STI,7,SL4,G1,G2,AS2,D3,AS2,G2,A1,A2,D3,A1,A2,CS3,D2,A2,CS2
  db D2,A2,CS2,D2,A2,CS2,D2,A2,CS2
  db RET

_soler42_triangle_13:
  db STI,7,SL4,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,A2,CS2,D2,E2,D2
  db C2,AS1,A1
  db RET

_soler42_noise_0:
  db STI,10,SL4,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5
  db RET

_soler42_noise_1:
  db STI,10,SL4,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5,0,0,5
  db RET

_antagonist:
  db 0
  db 5
  db 42
  db 4
  dw _antagonist_square1
  dw _antagonist_square2
  dw _antagonist_triangle
  dw 0
  dw 0

_antagonist_square1:
_antagonist_square1_loop:
  db CAL,<(_antagonist_square1_0),>(_antagonist_square1_0)
  db CAL,<(_antagonist_square1_0),>(_antagonist_square1_0)
  db CAL,<(_antagonist_square1_1),>(_antagonist_square1_1)
  db CAL,<(_antagonist_square1_1),>(_antagonist_square1_1)
  db CAL,<(_antagonist_square1_2),>(_antagonist_square1_2)
  db CAL,<(_antagonist_square1_2),>(_antagonist_square1_2)
  db CAL,<(_antagonist_square1_3),>(_antagonist_square1_3)
  db GOT
  dw _antagonist_square1_loop

_antagonist_square2:
_antagonist_square2_loop:
  db CAL,<(_antagonist_square2_0),>(_antagonist_square2_0)
  db CAL,<(_antagonist_square2_1),>(_antagonist_square2_1)
  db CAL,<(_antagonist_square2_2),>(_antagonist_square2_2)
  db CAL,<(_antagonist_square2_2),>(_antagonist_square2_2)
  db CAL,<(_antagonist_square2_3),>(_antagonist_square2_3)
  db CAL,<(_antagonist_square2_3),>(_antagonist_square2_3)
  db CAL,<(_antagonist_square2_4),>(_antagonist_square2_4)
  db GOT
  dw _antagonist_square2_loop

_antagonist_triangle:
_antagonist_triangle_loop:
  db CAL,<(_antagonist_triangle_0),>(_antagonist_triangle_0)
  db CAL,<(_antagonist_triangle_1),>(_antagonist_triangle_1)
  db CAL,<(_antagonist_triangle_1),>(_antagonist_triangle_1)
  db CAL,<(_antagonist_triangle_1),>(_antagonist_triangle_1)
  db CAL,<(_antagonist_triangle_3),>(_antagonist_triangle_3)
  db CAL,<(_antagonist_triangle_3),>(_antagonist_triangle_3)
  db CAL,<(_antagonist_triangle_4),>(_antagonist_triangle_4)
  db GOT
  dw _antagonist_triangle_loop

_antagonist_square1_0:
  db STI,13,SL4,C2,C3,B2,C3,G2,C3,D3,DS3,FS2,D3,C3,D3,F2,B2,A2
  db B2
  db RET

_antagonist_square1_1:
  db STI,13,SL4,C3,C4,B3,C4,G3,C4,D4,DS4,FS3,D4,C4,D4,F3,B3,A3
  db B3
  db RET

_antagonist_square1_2:
  db STI,13,SL2,C4,B3,C4,DS4,SLL,24,G4,SL2,D4,C4,D4,F4,SLL,24
  db B4
  db RET

_antagonist_square1_3:
  db STI,13,SL2,GS4,G4,GS4,C5,SL0,DS5,SL8,F5,SL2,D5,DS5,D5,C5
  db SLL,24,B4
  db RET

_antagonist_square2_0:
  db STI,14,SLL,64,C2
  db RET

_antagonist_square2_1:
  db STI,28,SLL,64,A0
  db RET

_antagonist_square2_2:
  db STI,13,SL2,C2,D2,DS2,G2,SLL,24,C3,SL2,FS2,G2,A2,C3,SL8,A3
  db GS3,G3
  db RET

_antagonist_square2_3:
  db STI,28,SL8,A0,STI,13,SL2,G2,FS2,G2,C3,SL8,DS3,F3,SL0,D3,SL2
  db G2,FS2,G2,B2,SL8,G3
  db RET

_antagonist_square2_4:
  db STI,13,SL8,GS2,SL2,C3,AS2,C3,DS3,SL0,GS3,SL2,F3,G3,F3,DS3
  db SLL,24,D3
  db RET

_antagonist_triangle_0:
  db STI,14,SLL,64,C2
  db RET

_antagonist_triangle_1:
  db STI,13,SL0,C2,DS2,D2,G2
  db RET

_antagonist_triangle_3:
  db STI,13,SLL,32,C2,G2
  db RET

_antagonist_triangle_4:
  db STI,13,SLL,24,GS2,SL8,F2,SLL,24,G2,SL8,G1
  db RET

_arps:
  db 0
  db 3
  db 128
  db 2
  dw _arps_square1
  dw _arps_square2
  dw _arps_triangle
  dw 0
  dw 0

_arps_square1:
_arps_square1_loop:
  db CAL,<(_arps_square1_0),>(_arps_square1_0)
  db CAL,<(_arps_square1_1),>(_arps_square1_1)
  db GOT
  dw _arps_square1_loop

_arps_square2:
_arps_square2_loop:
  db CAL,<(_arps_square2_0),>(_arps_square2_0)
  db CAL,<(_arps_square2_1),>(_arps_square2_1)
  db GOT
  dw _arps_square2_loop

_arps_triangle:
_arps_triangle_loop:
  db CAL,<(_arps_triangle_0),>(_arps_triangle_0)
  db CAL,<(_arps_triangle_1),>(_arps_triangle_1)
  db GOT
  dw _arps_triangle_loop

_arps_square1_0:
  db STI,18,SL0,A2,D3,STI,20,G2,C3
  db RET

_arps_square1_1:
  db STI,20,SL0,F2,STI,21,B2,STI,20,E2,STI,18,A2
  db RET

_arps_square2_0:
  db STI,16,SL2,A3,G3,F3,E3,G3,F3,E3,G3,SL0,F3,SL2,G3,F3,E3,D3
  db F3,E3,D3,F3,SL0,E3
  db RET

_arps_square2_1:
  db STI,16,SL2,F3,E3,D3,C3,D3,C3,B2,A2,SL0,GS2,SL2,B2,A2,GS2
  db FS2,GS2,E2,FS2,GS2,SL0,A2
  db RET

_arps_triangle_0:
  db STI,17,SL8,A2,C3,D3,A2,G2,B2,C3,G2
  db RET

_arps_triangle_1:
  db STI,17,SL8,F2,A2,B2,F2,E2,GS2,A2,E2
  db RET

_noise_arps:
  db 0
  db 5
  db 42
  db 4
  dw 0
  dw 0
  dw 0
  dw _noise_arps_noise
  dw 0

_noise_arps_noise:
_noise_arps_noise_loop:
  db CAL,<(_noise_arps_noise_0),>(_noise_arps_noise_0)
  db GOT
  dw _noise_arps_noise_loop

_noise_arps_noise_0:
  db STI,24,SL2,12,STI,25,13,STI,24,11,10,STI,26,SL4,9,STI,24
  db SL2,11,10,12,STI,25,13,STI,24,11,10,STI,26,SL4,9,STI,24
  db SL2,11,10,12,STI,25,13,STI,24,11,10,STI,26,SL4,9,STI,24
  db SL2,11,10,12,STI,25,13,STI,24,11,10,STI,26,SL4,9,STI,24
  db SL2,11,10
  db RET

_sfx_shot:
  db 0, 1
  db 0, 1
  dw 0
  dw 0
  dw 0
  dw _sfx_shot_noise
  dw 0

_sfx_shot_noise:
  db CAL,<(_sfx_shot_noise_0),>(_sfx_shot_noise_0)
  db TRM
_sfx_shot_noise_0:
  db SLL,32,STI,6,8
  db RET

_sfx_laser:
  db 0, 1
  db 0, 1
  dw _sfx_laser_square1
  dw 0
  dw 0
  dw 0
  dw 0

_sfx_laser_square1:
  db CAL,<(_sfx_laser_square1_0),>(_sfx_laser_square1_0)
  db TRM
_sfx_laser_square1_0:
  db SLL,16,STI,8,B7
  db RET

_sfx_dpcm:
  db 0, 1
  db 0, 1
  dw 0
  dw 0
  dw 0
  dw 0
  dw _sfx_dpcm_dpcm

_sfx_dpcm_dpcm:
  db CAL,<(_sfx_dpcm_dpcm_0),>(_sfx_dpcm_dpcm_0)
  db TRM
_sfx_dpcm_dpcm_0:
  db SLL,8,STI,15,D3
  db RET

_sfx_zap:
  db 0, 1
  db 0, 1
  dw 0
  dw 0
  dw 0
  dw _sfx_zap_noise
  dw 0

_sfx_zap_noise:
  db CAL,<(_sfx_zap_noise_0),>(_sfx_zap_noise_0)
  db TRM
_sfx_zap_noise_0:
  db SLL,16,STI,22,4
  db RET

_sfx_collide:
  db 0, 1
  db 0, 1
  dw 0
  dw 0
  dw 0
  dw _sfx_collide_noise
  dw 0

_sfx_collide_noise:
  db CAL,<(_sfx_collide_noise_0),>(_sfx_collide_noise_0)
  db TRM
_sfx_collide_noise_0:
  db SLL,16,STI,23,0
  db RET

}

align 64

{		; tracker_dpcm.inc 

dpcm_sample_bde:
  db $a9,$fe,$fb,$7f,$fc,$3f,$f0,$9f,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$f0,$ff,$ff
  db $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$7f,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$f6,$bb,$bb,$ef,$de,$bf,$bf,$ff,$f7,$7f,$ff
  db $f5,$ff,$55,$55,$a5,$44,$04,$01,$00,$02,$11,$81,$08,$41,$44,$22,$49,$4a,$a9,$4a,$ad,$55,$ad,$d6
  db $da,$d6,$dd,$da,$ee,$7e,$df,$f5,$de,$df,$ee,$dd,$bb,$6d,$df,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$17
  db $41,$88,$10,$21,$08,$84,$04,$41,$10,$21,$42,$22,$49,$52,$aa,$aa,$aa,$d6,$da,$b6,$ed,$b6,$bb,$dd
  db $de,$ed,$6e,$dd,$b6,$b6,$ad,$d5,$aa,$5a,$55,$a5,$aa,$4a,$95,$4a,$a5,$52,$a9,$54,$4a,$a5,$52,$55
  db $4a,$a5,$54,$2a,$95,$52,$55,$55,$a9,$56,$ab,$d5,$6a,$ad,$b5,$56,$ad,$55,$49,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

dpcm_sample_sd1:
  db $09,$00,$bc,$bd,$ff,$ff,$ff,$ff,$03,$7f,$00,$00,$00,$00,$00,$00,$80,$27,$fc,$ff,$ff,$ff,$ff,$ff
  db $ff,$ff,$3f,$bc,$00,$00,$c0,$03,$00,$00,$00,$00,$00,$00,$80,$87,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$07
  db $fe,$41,$00,$00,$00,$00,$00,$00,$10,$00,$60,$ff,$00,$5f,$ff,$ff,$ff,$ff,$ff,$ff,$3f,$00,$3c,$00
  db $00,$00,$00,$00,$00,$f0,$7f,$f0,$ff,$ff,$ff,$08,$ff,$ff,$f3,$0f,$f0,$07,$00,$00,$c4,$0f,$c0,$3f
  db $fc,$01,$00,$fe,$01,$fc,$3f,$aa,$07,$f0,$ff,$ff,$bf,$92,$ff,$07,$00,$00,$10,$80,$38,$00,$fe,$81
  db $3d,$f0,$ff,$ff,$ff,$fc,$03,$6e,$02,$c8,$13,$ff,$1f,$00,$08,$18,$f3,$00,$fc,$bf,$21,$19,$e2,$87
  db $3f,$fc,$fe,$0f,$f8,$e4,$94,$02,$f8,$7f,$04,$80,$3b,$30,$0e,$d9,$1f,$02,$87,$ff,$70,$e4,$8b,$ff
  db $ff,$07,$00,$47,$7c,$78,$ec,$27,$60,$00,$00,$fe,$0f,$dc,$81,$ff,$3d,$1d,$43,$71,$fc,$f8,$e1,$8f
  db $87,$3f,$00,$8e,$27,$06,$00,$ff,$05,$04,$1e,$1f,$be,$cf,$ae,$86,$97,$c7,$fe,$17,$07,$a4,$62,$1e
  db $60,$be,$a4,$26,$01,$fd,$07,$70,$f0,$ff,$21,$05,$fe,$77,$00,$7f,$ff,$b2,$04,$a0,$c6,$35,$01,$f8
  db $db,$47,$21,$ad,$8f,$0a,$81,$ff,$1f,$78,$b0,$83,$86,$ca,$ff,$0d,$17,$f4,$0f,$00,$07,$ff,$fc,$00
  db $e0,$43,$27,$af,$8b,$bf,$06,$aa,$2b,$3c,$bc,$58,$ac,$6a,$3e,$88,$6e,$65,$aa,$4e,$2f,$08,$be,$44
  db $21,$65,$fe,$cf,$4b,$f0,$3b,$30,$aa,$9a,$ff,$42,$04,$1e,$60,$ba,$ec,$5b,$7a,$c9,$40,$67,$34,$2f
  db $79,$49,$fa,$a9,$2f,$30,$b0,$4f,$de,$01,$8f,$aa,$1a,$52,$da,$bf,$a8,$58,$94,$56,$ec,$0e,$f4,$72
  db $aa,$59,$9a,$aa,$76,$56,$3d,$50,$29,$7c,$40,$9d,$b1,$4d,$fb,$b8,$83,$17,$e4,$7a,$38,$96,$4a,$eb
  db $33,$90,$ba,$aa,$ae,$a2,$8e,$3a,$12,$27,$e2,$66,$af,$19,$ad,$f0,$9a,$8f,$78,$e3,$64,$b3,$82,$a8
  db $cb,$aa,$0d,$74,$e5,$12,$69,$f0,$af,$ea,$03,$59,$8b,$3b,$73,$9a,$2b,$76,$45,$16,$c1,$2b,$d6,$26
  db $2e,$f4,$22,$2e,$b0,$ee,$ad,$6a,$65,$4e,$a6,$2e,$6b,$e5,$3a,$94,$aa,$4b,$94,$8a,$b4,$d4,$8a,$16
  db $55,$5a,$6d,$dd,$2e,$ed,$8c,$7d,$62,$31,$5d,$18,$35,$aa,$aa,$88,$a2,$5b,$67,$95,$43,$67,$8d,$93
  db $ba,$b2,$55,$8f,$55,$e9,$d0,$2a,$55,$b5,$a9,$54,$49,$31,$19,$dc,$9d,$c4,$dd,$6a,$aa,$2a,$f4,$53
  db $cb,$e9,$aa,$4a,$a8,$a5,$7a,$69,$94,$2a,$b4,$54,$95,$d2,$5c,$d7,$6a,$aa,$5a,$99,$96,$f6,$a8,$aa
  db $5a,$92,$d2,$aa,$5a,$ea,$a2,$b4,$e8,$0c,$71,$52,$b7,$b6,$ac,$ac,$aa,$2d,$5d,$6a,$ab,$94,$4c,$a9
  db $54,$ad,$2c,$cd,$aa,$aa,$aa,$52,$a5,$ea,$aa,$aa,$b4,$aa,$52,$d6,$6a,$97,$52,$56,$2b,$95,$aa,$aa
  db $aa,$aa,$b2,$aa,$a9,$92,$ea,$ac,$aa,$aa,$aa,$96,$aa,$2a,$6b,$59,$a5,$aa,$5a,$4a,$aa,$da,$5a,$aa
  db $aa,$6a,$a5,$b2,$ac,$5a,$95,$aa,$d2,$aa,$2a,$35,$e5,$6a,$55,$a5,$aa,$2a,$55,$55,$ab,$aa,$96,$5a
  db $4b,$2a,$d5,$aa,$aa,$aa,$6a,$95,$2a,$d5,$6a,$6a,$a9,$aa,$aa,$4a,$5a,$5a,$ab,$aa,$aa,$56,$aa,$5a
  db $56,$6d,$29,$a5,$5a,$2a,$29,$75,$ab,$54,$55,$ab,$aa,$a8,$56,$ab,$a6,$aa,$ba,$96,$54,$a9,$56,$35
  db $55,$a9,$aa,$52,$aa,$ac,$ad,$aa,$aa,$aa,$4a,$a9,$6c,$ab,$aa,$aa,$5a,$4b,$aa,$aa,$56,$55,$a9,$da
  db $aa,$92,$2a,$d5,$aa,$a8,$6a,$ad,$aa,$aa,$aa,$aa,$aa,$aa,$a5,$aa,$aa,$aa,$aa,$aa,$6a,$2b,$a9,$2a
  db $ad,$aa,$aa,$aa,$aa,$aa,$8a,$b4,$aa,$b6,$aa,$aa,$aa,$aa,$aa,$aa,$9a,$56,$ad,$56,$92,$aa,$aa,$2a
  db $95,$6a,$ab,$4a,$55,$b9,$56,$aa,$aa,$a6,$aa,$4a,$ad,$aa,$aa,$aa,$aa,$aa,$4a,$ad,$aa,$aa,$6a,$d5
  db $d5,$d5,$d5,$d5,$d5,$d5,$d5,$d5,$d5
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

dpcm_sample_sfx:
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$4d,$4d,$55,$55,$55,$55,$55,$95,$55
  db $55,$56,$55,$55,$35,$55,$33,$55,$55,$65,$55,$55,$55,$8d,$56,$55,$b5,$d4,$54,$53,$55,$55,$55,$55
  db $59,$56,$65,$95,$35,$4d,$ab,$34,$55,$55,$65,$55,$55,$55,$55,$55,$ad,$b4,$2a,$d3,$54,$55,$55,$9a
  db $a6,$aa,$65,$55,$55,$b5,$55,$aa,$aa,$54,$55,$aa,$aa,$a9,$99,$96,$55,$b5,$99,$69,$c6,$ca,$cc,$54
  db $96,$52,$99,$e6,$b4,$55,$b5,$96,$72,$1a,$55,$55,$9a,$6a,$55,$95,$59,$4d,$9b,$99,$aa,$2c,$35,$55
  db $55,$29,$a5,$aa,$99,$5b,$35,$3b,$99,$56,$26,$53,$55,$65,$5a,$a9,$51,$73,$35,$9d,$6a,$9a,$54,$55
  db $59,$96,$55,$55,$a6,$5a,$ad,$39,$cb,$b4,$68,$4a,$55,$a9,$8c,$b1,$9a,$d6,$5c,$6d,$d5,$52,$65,$4a
  db $95,$a5,$59,$66,$15,$ad,$69,$75,$d5,$e1,$a8,$52,$55,$55,$25,$69,$9a,$f1,$5c,$c7,$b3,$9a,$c6,$24
  db $55,$59,$c6,$34,$96,$a6,$ba,$3a,$8f,$cb,$38,$c6,$54,$4d,$a6,$26,$56,$33,$b6,$b5,$b5,$9a,$c9,$98
  db $4a,$55,$95,$54,$ac,$cc,$e6,$56,$ae,$73,$26,$15,$33,$55,$95,$d1,$18,$c7,$99,$ed,$5c,$67,$1c,$53
  db $cc,$32,$96,$31,$99,$c6,$56,$5d,$6d,$67,$16,$4b,$46,$53,$95,$19,$c5,$cc,$5c,$6e,$6d,$67,$c6,$32
  db $26,$4d,$55,$ca,$24,$67,$36,$5b,$3b,$97,$19,$cb,$a8,$8a,$95,$49,$cc,$b2,$a6,$6d,$67,$b3,$ca,$4c
  db $66,$92,$95,$64,$2c,$73,$d6,$56,$ab,$9b,$c9,$92,$a9,$c9,$c4,$c4,$4c,$d9,$e6,$56,$67,$9b,$a5,$49
  db $99,$51,$95,$22,$4b,$39,$97,$5b,$eb,$9a,$c9,$49,$a5,$52,$25,$25,$53,$b6,$a6,$67,$f3,$36,$95,$a3
  db $92,$49,$c9,$98,$8c,$cd,$cc,$dc,$ee,$66,$36,$66,$26,$32,$1a,$93,$31,$26,$5b,$f3,$ba,$b7,$a3,$32
  db $19,$99,$58,$ac,$24,$c9,$d2,$96,$77,$df,$33,$c9,$98,$a1,$94,$a9,$8a,$c4,$64,$cc,$fe,$ee,$6f,$46
  db $46,$26,$26,$53,$23,$25,$61,$92,$b3,$ff,$7b,$9b,$91,$91,$d8,$8c,$d1,$98,$10,$88,$d9,$db,$bf,$df
  db $99,$91,$88,$cd,$65,$0a,$45,$00,$c2,$f6,$fe,$ef,$e7,$66,$22,$a3,$b9,$56,$12,$22,$00,$50,$f6,$ff
  db $77,$bb,$33,$1b,$19,$9b,$b3,$11,$01,$00,$90,$d9,$ff,$fd,$ee,$e6,$66,$54,$4d,$ed,$32,$02,$00,$00
  db $64,$ef,$ff,$b7,$af,$75,$a6,$93,$cd,$5a,$85,$00,$00,$00,$f4,$ef,$ff,$b3,$b3,$fb,$da,$96,$46,$35
  db $11,$00,$00,$00,$da,$ff,$ff,$7c,$da,$f7,$df,$45,$12,$46,$32,$00,$00,$00,$e8,$fe,$ff,$ef,$e6,$ef
  db $7f,$67,$40,$60,$46,$41,$00,$00,$00,$f6,$ff,$ff,$ff,$ee,$ff,$af,$08,$00,$c8,$4c,$04,$00,$00,$80
  db $ff,$ff,$ff,$ff,$fe,$ff,$07,$00,$00,$cc,$4c,$00,$00,$00,$e0,$ff,$ff,$ff,$ff,$ff,$df,$04,$00,$00
  db $d5,$14,$04,$00,$00,$f4,$ff,$ff,$ff,$ff,$ff,$23,$0a,$00,$48,$c9,$11,$12,$00,$80,$f8,$ff,$ff,$ff
  db $ff,$17,$33,$b2,$01,$30,$a2,$16,$70,$02,$80,$41,$ff,$ff,$ff,$ff,$8b,$42,$a6,$1b,$ac,$80,$50,$c4
  db $0e,$95,$40,$c8,$fc,$ff,$ff,$bf,$28,$62,$ee,$9c,$42,$40,$90,$6b,$c7,$08,$20,$a4,$fe,$ff,$ff,$dc
  db $8a,$69,$aa,$1d,$11,$41,$cc,$aa,$55,$88,$80,$a0,$f2,$ff,$ff,$7f,$4e,$22,$da,$da,$85,$20,$44,$da
  db $99,$11,$04,$80,$5a,$ff,$ff,$ff,$67,$91,$62,$5e,$9d,$10,$42,$91,$95,$52,$92,$50,$91,$d5,$fe,$ff
  db $fe,$b6,$52,$21,$27,$4e,$28,$52,$c4,$4a,$39,$52,$28,$a1,$66,$ff,$ff,$ff,$53,$11,$11,$27,$39,$21
  db $95,$94,$15,$56,$a4,$a4,$52,$57,$ff,$fd,$df,$29,$03,$89,$c8,$f4,$64,$43,$0a,$2a,$75,$d3,$15,$99
  db $54,$ee,$ee,$ef,$36,$53,$22,$41,$95,$ad,$ce,$48,$21,$d3,$6e,$55,$51,$a2,$aa,$dd,$b6,$76,$ad,$a9
  db $90,$94,$ca,$56,$b7,$52,$52,$a5,$5a,$56,$a5,$a2,$44,$55,$7d,$b7,$6b,$46,$45,$29,$6b,$fb,$6d,$25
  db $04,$a5,$b4,$aa,$25,$89,$94,$68,$da,$fb,$5d,$37,$33,$31,$99,$bb,$9f,$12,$08,$51,$32,$57,$2d,$09
  db $41,$c5,$ee,$fe,$f7,$cd,$a5,$8c,$a4,$b2,$d6,$95,$89,$50,$90,$d4,$55,$1b,$29,$49,$ad,$77,$ef,$ed
  db $4a,$89,$4a,$b4,$74,$6b,$4b,$49,$94,$d0,$aa,$ab,$15,$09,$51,$ed,$7e,$6b,$4d,$4a,$55,$ed,$d5,$96
  db $aa,$32,$a9,$48,$45,$55,$d5,$54,$42,$22,$6d,$bf,$77,$b3,$49,$2b,$3b,$5b,$a9,$84,$a5,$9a,$56,$52
  db $45,$25,$95,$2a,$69,$6a,$b7,$6f,$57,$29,$51,$95,$6d,$6f,$69,$c4,$c4,$aa,$55,$2a,$25,$49,$25,$95
  db $2a,$b5,$dd,$d7,$ad,$52,$52,$55,$bf,$bb,$12,$81,$54,$55,$35,$55,$49,$12,$25,$a5,$da,$ee,$b7,$df
  db $6a,$81,$44,$6a,$f5,$f5,$09,$05,$29,$d5,$5a,$ad,$4a,$89,$44,$59,$db,$6d,$d5,$d6,$a6,$2a,$54,$e0
  db $d3,$af,$5e,$a8,$50,$55,$bd,$ba,$11,$11,$42,$b4,$ea,$d6,$ae,$56,$5b,$65,$82,$0a,$7e,$fd,$f7,$09
  db $05,$54,$d5,$ab,$2b,$12,$01,$42,$55,$6f,$7d,$b5,$b5,$5d,$2a,$62,$82,$9f,$fd,$ed,$41,$01,$2d,$f5
  db $ea,$42,$12,$00,$d2,$f5,$bb,$57,$b5,$6a,$27,$1b,$58,$e0,$e3,$3f,$7f,$e8,$00,$43,$3d,$7d,$50,$01
  db $00,$5c,$fd,$d7,$57,$ad,$7c,$cb,$05,$4a,$60,$f3,$bf,$3f,$59,$00,$a1,$2d,$3f,$28,$01,$00,$b6,$fe
  db $ff,$a5,$1d,$bd,$6a,$05,$44,$60,$f5,$ff,$5f,$56,$40,$44,$47,$2f,$54,$00,$04,$af,$ff,$fd,$52,$0b
  db $9f,$b6,$42,$01,$29,$f9,$f7,$bf,$1e,$60,$80,$8b,$1d,$69,$00,$81,$d7,$7f,$f7,$b4,$92,$27,$5d,$a8
  db $81,$26,$7e,$f5,$9f,$1e,$a8,$01,$07,$3b,$60,$40,$93,$7d,$fd,$76,$d5,$a2,$07,$6f,$f0,$80,$07,$7e
  db $f8,$fb,$8b,$07,$06,$e8,$80,$03,$0f,$fc,$f0,$c3,$df,$7e,$f0,$e0,$50,$15,$0f,$3e,$f1,$83,$1f,$7f
  db $78,$a0,$20,$82,$0e,$7e,$f8,$c3,$4f,$3f,$f8,$81,$45,$3c,$78,$da,$ac,$93,$17,$5d,$f0,$c1,$0e,$f8
  db $c0,$03,$1e,$fc,$e9,$0f,$3f,$78,$c0,$83,$0f,$7e,$f8,$c1,$0f,$2f,$b4,$a0,$03,$1f,$7c,$f0,$83,$0f
  db $7c,$f0,$83,$0f,$3e,$f8,$c1,$07,$3f,$7c,$f0,$21,$47,$56,$f8,$d0,$87,$0f,$7c,$e0,$81,$1f,$fc,$f0
  db $81,$0f,$7e,$f8,$83,$07,$3e,$f0,$e1,$07,$1e,$59,$55,$4d,$b9,$70,$85,$9e,$f8,$61,$0f,$1e,$f8,$c4
  db $0f,$3d,$78,$c1,$8b,$5d,$f1,$42,$15,$ba,$d8,$96,$1d,$b5,$a2,$16,$7a,$d1,$13,$3f,$f8,$e0,$03,$1f
  db $f8,$c1,$07,$3f,$f4,$c0,$13,$1e,$ec,$e9,$25,$17,$55,$71,$a5,$55,$35,$55,$a5,$95,$2d,$b5,$54,$53
  db $1d,$6d,$54,$11,$13,$f7,$dc,$b7,$26,$14,$68,$e8,$53,$5f,$7a,$d0,$85,$4d,$ba,$64,$93,$2d,$b5,$d4
  db $a4,$8c,$5a,$5d,$ed,$ca,$12,$55,$cc,$cc,$5a,$56,$55,$55,$b3,$aa,$52,$55,$a9,$55,$ab,$aa,$a4,$4a
  db $ad,$da,$d2,$a6,$54,$29,$a7,$ac,$5a,$55,$ab,$aa,$54,$55,$59,$65,$55,$1d,$b5,$54,$95,$9a,$6a,$55
  db $ad,$aa,$52,$55,$5a,$65,$95,$55,$d6,$b2,$93,$15,$55,$d2,$55,$3b,$56,$52,$25,$5b,$5a,$d5,$54,$55
  db $b5,$aa,$94,$92,$56,$5d,$dd,$cc,$14,$35,$55,$a5,$52,$ab,$b6,$ea,$92,$8a,$4c,$da,$6a,$55,$55,$55
  db $ad,$2a,$95,$a4,$d6,$75,$5b,$45,$94,$64,$55,$5b,$55,$55,$cb,$36,$59,$50,$a1,$97,$bd,$da,$92,$45
  db $4d,$55,$29,$6a,$f5,$ad,$17,$26,$c0,$50,$5f,$77,$d5,$91,$2a,$b5,$54,$09,$9b,$fa,$da,$4b,$25,$a4
  db $a8,$6b,$6d,$aa,$52,$55,$d6,$54,$45,$55,$5d,$eb,$44,$25,$b2,$dd,$dd,$11,$21,$c4,$de,$fd,$33,$05
  db $44,$94,$5a,$db,$d6,$b6,$56,$89,$44,$48,$ed,$bb,$5b,$45,$54,$a9,$5a,$55,$55,$55,$ab,$aa,$52,$4a
  db $b6,$55,$ab,$4a,$a9,$aa,$55,$55,$51,$57,$6f,$5d,$01,$01,$d5,$fe,$ef,$4d,$00,$01,$a5,$bd,$dd,$e6
  db $96,$2a,$51,$88,$aa,$7e,$bb,$4b,$8a,$a4,$54,$6b,$55,$55,$55,$6d,$55,$51,$8a,$aa,$dd,$56,$95,$54
  db $aa,$55,$55,$52,$b3,$bd,$b6,$11,$41,$48,$dd,$f7,$5e,$25,$10,$c1,$5a,$77,$b5,$55,$55,$2a,$25,$15
  db $bb,$75,$ab,$2a,$54,$aa,$56,$ad,$34,$65,$55,$55,$b5,$52,$a5,$5a,$55,$55,$55,$55,$55,$55,$55,$5a
  db $d5,$5a,$95,$54,$64,$d6,$b6,$5b,$12,$89,$52,$bb,$b5,$aa,$2a,$55,$55,$aa,$aa,$56,$6b,$55,$4a,$a9
  db $54,$5b,$b5,$aa,$52,$95,$d4,$5a,$d5,$aa,$54,$95,$aa,$56,$55,$ad,$aa,$52,$95,$aa,$56,$55,$2b,$55
  db $a5,$aa,$6a,$55,$55,$ab,$52,$55,$a5,$aa,$56,$b5,$aa,$52,$55,$a9,$56,$55,$55,$55,$55,$55,$55,$a5
  db $aa,$56,$ad,$2a,$55,$aa,$aa,$55,$55,$55,$55,$55,$a5,$6a,$55,$35,$ad,$54,$55,$55,$aa,$5a,$ad,$aa
  db $4a,$95,$aa,$6a,$55,$b5,$aa,$52,$55,$95,$aa,$56,$d5,$aa,$52,$55,$aa,$5a,$55,$55,$55,$55,$55,$55
  db $55,$a9,$55,$d5,$aa,$4a,$55,$55,$55,$aa,$55,$d5,$aa,$54,$a5,$54,$ad,$55,$d5,$aa,$54,$95,$aa,$6a
  db $d5,$5a,$95,$52,$4a,$d5,$5a,$ad,$96,$4a,$95,$aa,$ac,$5a,$b5,$5a,$2a,$55,$aa,$aa,$55,$ab,$aa,$54
  db $55,$a9,$6a,$55,$55,$55,$55,$55,$a9,$aa,$56,$d5,$aa,$2a,$55,$55,$55,$55,$55,$ad,$aa,$52,$55,$a9
  db $6a,$55,$55,$53,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$56,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
  db $55,$55,$55,$55,$55,$55,$55,$55,$55
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00

}



if demoGame
org $FFFA     ;first of the three vectors starts here
dw vblank     ;when an NMI happens (once per frame if enabled) the
               ;processor will jump to the label NMI:
dw reset      ;when the processor first turns on or is reset, it will jump
               ;to the label RESET:
dw irq        ;external interrupt IRQ is not used in this tutorial

{		; bg_chr.inc 
base $0000    
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$07,$00,$00,$00,$00,$00,$00,$00,$07
    db $00,$00,$00,$3f,$3f,$3f,$7f,$80,$00,$00,$00,$3f,$7f,$7f,$7f,$ff
    db $00,$00,$00,$ff,$ff,$ff,$ff,$01,$00,$00,$00,$ff,$ff,$ff,$ff,$ff
    db $00,$00,$00,$f0,$e0,$e0,$e0,$fc,$00,$00,$00,$f0,$e0,$e0,$e0,$fc
    db $00,$00,$00,$01,$03,$03,$03,$3f,$00,$00,$00,$01,$03,$07,$07,$3f
    db $00,$00,$00,$ff,$ff,$ff,$ff,$80,$00,$00,$00,$ff,$ff,$ff,$ff,$ff
    db $00,$00,$00,$ff,$ff,$ff,$fe,$00,$00,$00,$00,$ff,$ff,$ff,$fe,$fc
    db $00,$00,$00,$00,$00,$00,$00,$fe,$00,$00,$00,$00,$00,$00,$00,$fe
    db $00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$01,$01,$01,$03
    db $07,$07,$7f,$fe,$fe,$fe,$fc,$fc,$0f,$0f,$7f,$fe,$fe,$fe,$fc,$fc
    db $80,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00
    db $01,$03,$03,$00,$00,$00,$00,$00,$03,$03,$07,$07,$00,$00,$00,$00
    db $fc,$f8,$f8,$00,$00,$00,$01,$01,$fc,$f8,$f8,$f0,$01,$01,$01,$03
    db $3f,$7f,$7f,$fe,$fe,$fe,$fc,$fc,$7f,$7f,$ff,$fe,$fe,$fe,$fc,$fc
    db $00,$01,$01,$03,$03,$03,$07,$07,$01,$01,$03,$03,$07,$07,$07,$0f
    db $fe,$fc,$fc,$f8,$f8,$f8,$f0,$f0,$fe,$fc,$fc,$f8,$f8,$f8,$f0,$f0
    db $01,$03,$03,$03,$07,$07,$07,$0f,$03,$03,$07,$07,$07,$0f,$0f,$0f
    db $fc,$f8,$f8,$f8,$f0,$f0,$f0,$e0,$fc,$f8,$f8,$f8,$f1,$f1,$f0,$e0
    db $00,$7f,$7f,$ff,$ff,$00,$00,$00,$00,$7f,$ff,$ff,$ff,$ff,$00,$00
    db $00,$ff,$ff,$ff,$ff,$3f,$3f,$7f,$00,$ff,$ff,$ff,$ff,$ff,$7f,$7f
    db $01,$c3,$c3,$c3,$87,$87,$87,$0f,$03,$c3,$c7,$c7,$87,$8f,$8f,$0f
    db $01,$c3,$c0,$c0,$80,$80,$80,$00,$03,$c3,$c7,$c0,$80,$80,$80,$00
    db $fc,$ff,$3f,$7f,$7f,$00,$00,$00,$fc,$ff,$ff,$7f,$ff,$ff,$00,$00
    db $00,$ff,$ff,$fe,$fe,$1f,$1f,$3f,$00,$ff,$ff,$fe,$fe,$ff,$3f,$3f
    db $00,$00,$00,$00,$00,$c3,$c3,$87,$00,$00,$00,$00,$00,$c3,$c7,$87
    db $00,$1f,$1f,$3f,$3f,$f8,$f8,$f0,$00,$1f,$3f,$3f,$7f,$ff,$f8,$f0
    db $00,$f8,$f8,$f8,$f0,$0f,$0e,$1e,$00,$f8,$f8,$f8,$f0,$ef,$1e,$1e
    db $00,$0f,$0f,$0f,$1f,$1f,$1f,$3f,$00,$0f,$1f,$1f,$1f,$3f,$3f,$3f
    db $00,$e0,$e0,$e0,$c0,$c0,$c0,$80,$00,$e0,$e0,$e0,$c0,$c0,$c0,$80
    db $00,$3f,$3f,$3f,$7f,$7f,$7f,$fe,$00,$3f,$7f,$7f,$7f,$ff,$ff,$fe
    db $00,$87,$87,$87,$0f,$0f,$0f,$1f,$00,$87,$8f,$8f,$0f,$1f,$1f,$1f
    db $00,$ff,$ff,$ff,$ff,$e0,$e0,$c0,$00,$ff,$ff,$ff,$ff,$ff,$e0,$c0
    db $00,$fe,$fe,$fc,$fc,$3f,$3f,$7f,$00,$fe,$fe,$fc,$fc,$ff,$7f,$7f
    db $00,$00,$00,$00,$00,$87,$87,$0f,$00,$00,$00,$00,$00,$87,$8f,$0f
    db $00,$3f,$3f,$7f,$7f,$f0,$f0,$e0,$00,$3f,$7f,$7f,$ff,$ff,$f0,$e0
    db $07,$ff,$ff,$ff,$ff,$1f,$1f,$3f,$0f,$ff,$ff,$ff,$ff,$ff,$3f,$3f
    db $f0,$e0,$e0,$e0,$c0,$c0,$c0,$80,$f0,$e0,$e0,$e0,$c0,$c0,$c0,$80
    db $0f,$0f,$1f,$1f,$03,$03,$03,$07,$1f,$1f,$1f,$3f,$3f,$07,$07,$07
    db $e0,$e0,$c0,$c0,$ff,$ff,$ff,$ff,$e0,$e0,$c0,$c0,$ff,$ff,$ff,$ff
    db $00,$00,$00,$00,$ff,$ff,$ff,$ff,$00,$00,$00,$01,$ff,$ff,$ff,$ff
    db $7f,$7f,$fe,$fe,$fe,$fc,$fc,$fc,$ff,$ff,$fe,$fe,$fe,$fc,$fc,$fc
    db $00,$00,$00,$00,$00,$00,$00,$3f,$00,$00,$00,$00,$00,$00,$00,$3f
    db $00,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$01,$ff
    db $3f,$3f,$7f,$7f,$7f,$fe,$fe,$fe,$7f,$7f,$7f,$ff,$ff,$fe,$fe,$fe
    db $87,$87,$0f,$0f,$0f,$1f,$1f,$1f,$8f,$8f,$0f,$1f,$1f,$1f,$3f,$3f
    db $f0,$f0,$e0,$e0,$e0,$c0,$c0,$ff,$f0,$f0,$e0,$e0,$e0,$c0,$c0,$ff
    db $1e,$1c,$3c,$3c,$38,$78,$78,$f0,$3e,$3c,$3c,$7c,$78,$78,$f9,$f1
    db $3f,$3f,$7f,$7f,$7f,$fe,$fe,$ff,$7f,$7f,$7f,$ff,$ff,$fe,$fe,$ff
    db $80,$80,$01,$01,$01,$03,$03,$ff,$81,$81,$01,$03,$03,$03,$07,$ff
    db $fe,$fe,$fc,$fc,$fc,$f8,$f8,$f8,$fe,$fe,$fc,$fc,$fc,$f8,$f8,$f8
    db $1f,$1f,$3f,$3f,$3f,$7f,$7f,$7f,$3f,$3f,$3f,$7f,$7f,$7f,$ff,$ff
    db $c0,$c0,$80,$80,$80,$01,$01,$01,$c0,$c0,$80,$81,$81,$01,$03,$03
    db $0f,$0f,$1f,$1f,$1f,$3f,$3f,$3f,$1f,$1f,$1f,$3f,$3f,$3f,$7f,$7f
    db $e0,$e0,$c0,$c0,$c0,$80,$80,$ff,$e0,$e0,$c0,$c0,$c0,$80,$81,$ff
    db $80,$80,$00,$00,$00,$00,$00,$00,$80,$80,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$0f,$01,$01,$01,$00,$00,$00,$00
    db $ff,$ff,$ff,$00,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$00,$00,$00,$00
    db $c0,$c0,$80,$00,$00,$00,$00,$00,$f8,$c0,$80,$00,$00,$00,$00,$00
    db $7f,$7f,$7f,$00,$00,$00,$00,$00,$7f,$ff,$ff,$ff,$00,$00,$00,$00
    db $e0,$e0,$c0,$00,$00,$00,$00,$00,$fc,$e0,$c0,$80,$00,$00,$00,$00
    db $03,$03,$07,$00,$00,$00,$00,$00,$3f,$07,$07,$0f,$00,$00,$00,$00
    db $ff,$ff,$ff,$00,$00,$00,$00,$00,$ff,$ff,$ff,$fe,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$e1,$00,$00,$00,$00,$00,$00,$00
    db $1f,$1f,$3f,$00,$00,$00,$00,$00,$ff,$3f,$3f,$7f,$00,$00,$00,$00
    db $80,$80,$00,$00,$00,$00,$00,$00,$f0,$81,$01,$01,$00,$00,$00,$00
    db $fe,$fe,$fe,$00,$00,$00,$00,$00,$fe,$fe,$fe,$fc,$00,$00,$00,$00
    db $03,$03,$03,$00,$00,$00,$00,$00,$03,$07,$07,$07,$00,$00,$00,$00
    db $f8,$f8,$f8,$00,$00,$00,$00,$00,$f8,$f8,$f8,$f0,$00,$00,$00,$00
    db $07,$07,$0f,$00,$00,$00,$00,$00,$7f,$0f,$0f,$1f,$00,$00,$00,$00
    db $fc,$fc,$fc,$00,$00,$00,$00,$00,$fc,$fc,$fc,$f8,$00,$00,$00,$00
    db $00,$00,$00,$00,$c0,$b2,$8d,$84,$00,$00,$00,$00,$c0,$b2,$8d,$84
    db $00,$03,$07,$02,$00,$00,$00,$00,$00,$03,$07,$02,$00,$00,$00,$00
    db $84,$04,$18,$38,$10,$00,$01,$01,$84,$04,$18,$38,$10,$00,$01,$01
    db $00,$00,$00,$00,$00,$7c,$fe,$83,$00,$00,$00,$00,$00,$7c,$fe,$83
    db $00,$18,$14,$10,$10,$10,$63,$e2,$00,$18,$14,$10,$10,$10,$63,$e2
    db $00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$80
    db $00,$00,$00,$08,$0f,$08,$08,$08,$00,$00,$00,$08,$0f,$08,$08,$08
    db $00,$00,$00,$00,$ff,$e0,$e0,$e0,$00,$00,$00,$00,$ff,$e0,$e0,$e0
    db $00,$00,$00,$00,$80,$f8,$e6,$e1,$00,$00,$00,$00,$80,$f8,$e6,$e1
    db $00,$00,$00,$00,$03,$03,$03,$01,$00,$00,$00,$00,$00,$01,$00,$00
    db $00,$1f,$7f,$fc,$c0,$03,$9c,$f0,$00,$00,$03,$3c,$c0,$00,$00,$00
    db $03,$fe,$ff,$0e,$3f,$e0,$41,$40,$03,$06,$f6,$0e,$3f,$60,$41,$40
    db $01,$ff,$ff,$df,$b0,$ff,$70,$6f,$01,$00,$02,$00,$80,$c0,$40,$40
    db $00,$00,$80,$c0,$e0,$e0,$f0,$78,$00,$00,$00,$80,$00,$00,$00,$00
    db $42,$02,$02,$0c,$1c,$08,$00,$00,$42,$02,$02,$0c,$1c,$08,$00,$00
    db $00,$00,$00,$00,$03,$01,$00,$00,$00,$00,$00,$00,$00,$0e,$3f,$7f
    db $00,$00,$00,$00,$a0,$a0,$a0,$a0,$00,$00,$07,$0f,$1f,$1f,$1f,$1f
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff
    db $00,$00,$00,$00,$1a,$1a,$1a,$1a,$00,$00,$c0,$e0,$e1,$e1,$e1,$e1
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$e0,$f0,$f8
    db $08,$0e,$0e,$0e,$08,$09,$09,$08,$08,$0e,$0e,$0e,$08,$09,$09,$08
    db $00,$1e,$1e,$1e,$00,$e1,$e1,$00,$00,$1e,$1e,$1e,$00,$e1,$e1,$00
    db $01,$1d,$1f,$1e,$02,$e2,$e2,$02,$01,$1d,$1f,$1e,$02,$e2,$e2,$02
    db $50,$60,$3f,$13,$0b,$15,$2e,$5f,$50,$60,$3f,$01,$01,$01,$00,$00
    db $7f,$ff,$fe,$fe,$ff,$ff,$ff,$7f,$40,$c0,$90,$00,$01,$02,$8c,$50
    db $bc,$54,$e3,$f2,$ff,$74,$e0,$e8,$00,$00,$01,$80,$01,$00,$40,$88
    db $00,$e0,$90,$08,$c0,$20,$10,$03,$00,$e0,$90,$08,$c0,$20,$10,$00
    db $00,$00,$00,$00,$00,$00,$80,$c0,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$0c,$10,$26,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$03,$07,$0f,$0f,$1f,$3f
    db $00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db $a0,$b0,$d8,$5c,$6f,$77,$38,$77,$1f,$0f,$07,$83,$80,$80,$c0,$80
    db $00,$00,$00,$00,$ff,$ff,$00,$ff,$ff,$ff,$ff,$ff,$00,$00,$00,$00
    db $1a,$3a,$7a,$f4,$e8,$d0,$30,$d0,$e1,$c1,$81,$03,$07,$0f,$0f,$0f
    db $00,$02,$02,$06,$06,$0d,$08,$09,$fc,$fc,$fc,$f8,$f8,$f0,$f3,$f2
    db $00,$00,$00,$20,$00,$80,$40,$00,$00,$70,$f8,$d8,$70,$30,$80,$80
    db $02,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$03,$00,$00,$00,$00
    db $20,$20,$a0,$20,$00,$00,$00,$00,$60,$60,$e0,$e0,$00,$00,$00,$00
    db $06,$06,$06,$07,$04,$04,$04,$04,$06,$06,$06,$07,$04,$04,$04,$04
    db $0f,$0f,$08,$f8,$00,$00,$00,$00,$0f,$0f,$08,$f8,$00,$00,$00,$00
    db $fc,$c0,$00,$00,$00,$00,$00,$00,$fc,$c0,$00,$00,$00,$00,$00,$00
    db $5f,$af,$5f,$bf,$5f,$bf,$5f,$bd,$00,$00,$00,$00,$00,$00,$00,$00
    db $ff,$ff,$fe,$fe,$ff,$f5,$ef,$ff,$21,$52,$4a,$86,$07,$04,$04,$00
    db $1f,$df,$c7,$1d,$fe,$ff,$db,$bf,$08,$08,$04,$04,$04,$84,$42,$22
    db $87,$c7,$ec,$6c,$af,$47,$01,$4c,$00,$00,$00,$00,$00,$00,$00,$00
    db $20,$30,$c9,$8d,$0b,$1b,$fb,$fb,$00,$00,$00,$00,$00,$00,$00,$00
    db $6e,$de,$de,$fc,$fc,$f8,$d0,$b0,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$02,$00,$01,$00,$00,$00,$01,$03,$05,$0f,$0e
    db $40,$60,$70,$30,$18,$4e,$87,$07,$3f,$1f,$0f,$8f,$c7,$81,$30,$70
    db $00,$01,$03,$07,$0e,$1d,$3b,$f6,$ff,$fe,$fc,$f8,$f0,$e0,$c0,$01
    db $ef,$dc,$b0,$60,$c0,$80,$00,$00,$00,$03,$0f,$1f,$3f,$7f,$ff,$ff
    db $ff,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    db $e8,$74,$36,$1b,$0d,$0e,$06,$03,$07,$83,$c1,$e0,$f0,$f0,$f8,$fc
    db $10,$10,$26,$41,$48,$c0,$c0,$50,$e7,$e1,$c8,$9e,$96,$1e,$0c,$00
    db $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00
    db $04,$04,$04,$06,$0e,$1e,$3c,$78,$04,$04,$04,$06,$0e,$1e,$3c,$78
    db $5e,$af,$5f,$2f,$57,$2b,$15,$0a,$00,$00,$00,$00,$00,$00,$00,$00
    db $fe,$7d,$7b,$87,$ff,$ff,$ff,$ff,$00,$00,$00,$01,$00,$00,$00,$00
    db $76,$fb,$ff,$ff,$f9,$e7,$df,$bf,$12,$4a,$a5,$53,$a9,$41,$01,$00
    db $df,$ff,$80,$7f,$ff,$ff,$ff,$ff,$00,$00,$00,$00,$00,$00,$00,$80
    db $37,$87,$07,$8f,$e6,$d7,$f7,$ff,$00,$00,$00,$00,$00,$00,$00,$00
    db $a0,$ec,$6e,$ce,$de,$cc,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00
    db $02,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$00
    db $09,$90,$21,$42,$94,$08,$11,$00,$f0,$66,$ce,$9c,$29,$73,$26,$0f
    db $ec,$ec,$1e,$1f,$21,$42,$44,$88,$03,$03,$01,$c0,$c0,$9c,$99,$33
    db $00,$00,$00,$00,$80,$40,$20,$40,$ff,$ff,$ff,$ff,$7f,$3f,$9f,$80
    db $00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00
    db $03,$01,$01,$03,$07,$08,$12,$01,$fc,$fe,$fe,$fc,$f8,$f0,$e4,$0e
    db $8c,$80,$88,$a0,$10,$08,$24,$00,$30,$3c,$14,$0c,$64,$f0,$d8,$7c
    db $00,$01,$03,$07,$0f,$1e,$3c,$78,$00,$01,$03,$07,$0f,$1e,$3c,$78
    db $f0,$e0,$c0,$80,$00,$00,$00,$00,$f0,$e0,$c0,$80,$00,$00,$00,$00
    db $00,$00,$03,$07,$0f,$19,$1f,$15,$00,$00,$03,$04,$08,$10,$01,$00
    db $00,$ff,$ff,$ff,$ff,$7f,$f8,$f7,$00,$b3,$80,$0b,$00,$07,$08,$27
    db $05,$c2,$e1,$b0,$f8,$fc,$7f,$1f,$00,$c0,$20,$30,$18,$8c,$67,$11
    db $7f,$ba,$55,$aa,$55,$0a,$05,$82,$00,$00,$00,$00,$00,$00,$00,$80
    db $7f,$ff,$ff,$ff,$7e,$bd,$5f,$ce,$00,$00,$00,$00,$00,$00,$00,$00
    db $ff,$e7,$ff,$6a,$f5,$aa,$55,$ba,$80,$40,$40,$40,$20,$20,$10,$10
    db $ff,$ff,$df,$9e,$1e,$9e,$0c,$01,$00,$00,$00,$00,$00,$00,$00,$01
    db $80,$00,$07,$1f,$7d,$5f,$cc,$df,$00,$00,$07,$15,$55,$0b,$4c,$00
    db $00,$00,$00,$c0,$60,$20,$70,$f8,$00,$00,$00,$c0,$60,$20,$70,$38
    db $00,$00,$00,$00,$00,$00,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$c0,$00,$00,$00,$00,$00,$00,$00,$00
    db $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $28,$10,$25,$01,$00,$00,$00,$00,$53,$e7,$4a,$0e,$00,$00,$00,$00
    db $84,$84,$08,$29,$10,$00,$00,$00,$39,$39,$73,$52,$27,$c0,$fb,$1d
    db $22,$22,$22,$49,$41,$00,$00,$00,$cc,$cc,$cc,$96,$9e,$00,$bd,$de
    db $20,$12,$50,$08,$00,$00,$00,$00,$cf,$e5,$a7,$73,$63,$1c,$e8,$00
    db $80,$40,$00,$00,$00,$00,$00,$00,$38,$90,$c0,$80,$00,$00,$00,$00
    db $00,$01,$03,$07,$0f,$1e,$5c,$a8,$00,$01,$03,$07,$0f,$1e,$1c,$48
    db $17,$17,$1a,$0c,$0d,$17,$1e,$00,$00,$00,$00,$00,$00,$03,$1e,$00
    db $fc,$68,$fb,$c3,$c7,$87,$fb,$03,$0c,$20,$78,$41,$42,$80,$f8,$03
    db $07,$fd,$fe,$fe,$ff,$ff,$ff,$fe,$02,$85,$3a,$00,$11,$09,$e1,$fc
    db $82,$8d,$b8,$9f,$8f,$85,$80,$00,$80,$00,$b8,$9f,$8f,$85,$80,$00
    db $b5,$4e,$95,$6c,$e0,$c0,$00,$00,$00,$00,$00,$60,$e0,$c0,$00,$00
    db $54,$a9,$5b,$a6,$0f,$19,$36,$36,$10,$09,$0b,$06,$0f,$19,$36,$36
    db $07,$8d,$db,$ff,$7f,$b7,$e0,$c0,$04,$81,$c8,$f4,$78,$b5,$e0,$c0
    db $ff,$79,$fb,$ff,$db,$ff,$00,$00,$c3,$00,$02,$10,$40,$50,$00,$00
    db $f8,$f8,$f4,$fc,$b8,$e0,$00,$00,$b8,$38,$94,$0c,$38,$00,$00,$00
    db $08,$00,$00,$01,$00,$00,$00,$00,$07,$07,$07,$02,$00,$00,$00,$00
    db $40,$40,$c0,$0e,$12,$22,$06,$00,$80,$80,$00,$00,$0c,$1c,$18,$00
    db $00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$03,$64,$94,$14,$20,$00,$00,$00,$00,$03,$63,$e3,$c3,$00
    db $00,$00,$00,$80,$80,$40,$88,$14,$00,$00,$00,$00,$00,$80,$00,$08
    db $00,$00,$03,$04,$04,$00,$00,$60,$00,$00,$00,$03,$03,$03,$00,$60
    db $28,$00,$00,$80,$00,$00,$00,$00,$c8,$e0,$40,$00,$80,$00,$00,$00
    db $19,$0f,$06,$00,$00,$00,$00,$00,$19,$0f,$06,$00,$00,$00,$00,$00
    db $02,$04,$00,$00,$00,$00,$00,$00,$1c,$18,$00,$00,$00,$00,$00,$00
    db $00,$01,$03,$07,$0f,$1f,$3e,$1c,$00,$01,$03,$07,$0f,$1f,$3e,$1c
    db $f8,$f0,$e0,$c0,$80,$00,$00,$00,$f8,$f0,$e0,$c0,$80,$00,$00,$00
    db $00,$00,$00,$08,$08,$08,$08,$e9,$00,$00,$00,$08,$08,$08,$08,$e9
    db $00,$00,$00,$00,$00,$00,$00,$70,$00,$00,$00,$00,$00,$00,$00,$70
    db $00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$00,$00,$00,$f0
    db $00,$00,$00,$00,$00,$00,$00,$f1,$00,$00,$00,$00,$00,$00,$00,$f1
    db $00,$00,$00,$00,$00,$00,$00,$e2,$00,$00,$00,$00,$00,$00,$00,$e2
    db $00,$00,$00,$00,$00,$00,$00,$e1,$00,$00,$00,$00,$00,$00,$00,$e1
    db $00,$00,$00,$00,$00,$00,$00,$f8,$00,$00,$00,$00,$00,$00,$00,$f8
    db $08,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00
    db $01,$01,$01,$01,$01,$00,$00,$00,$01,$01,$01,$01,$01,$00,$00,$00
    db $19,$09,$09,$09,$19,$e9,$01,$01,$19,$09,$09,$09,$19,$e9,$01,$01
    db $89,$08,$08,$09,$89,$70,$00,$00,$89,$08,$08,$09,$89,$70,$00,$00
    db $09,$09,$f9,$09,$19,$e8,$00,$00,$09,$09,$f9,$09,$19,$e8,$00,$00
    db $19,$08,$08,$08,$19,$e9,$00,$00,$19,$08,$08,$08,$19,$e9,$00,$00
    db $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$00,$00,$00,$01,$00,$00
    db $02,$02,$e2,$12,$12,$e1,$00,$00,$02,$02,$e2,$12,$12,$e1,$00,$00
    db $13,$12,$12,$12,$12,$e2,$00,$00,$13,$12,$12,$12,$12,$e2,$00,$00
    db $12,$12,$12,$11,$12,$11,$02,$02,$12,$12,$12,$11,$12,$11,$02,$02
    db $10,$10,$10,$e0,$00,$f0,$08,$08,$10,$10,$10,$e0,$00,$f0,$08,$08
    db $01,$00,$00,$00,$00,$00,$00,$f0,$01,$00,$00,$00,$00,$00,$00,$f0
    db $00,$00,$00,$14,$14,$24,$24,$45,$00,$00,$00,$14,$14,$24,$24,$45
    db $00,$00,$00,$00,$00,$00,$00,$c4,$00,$00,$00,$00,$00,$00,$00,$c4
    db $00,$00,$00,$00,$00,$00,$00,$3d,$00,$00,$00,$00,$00,$00,$00,$3d
    db $00,$00,$00,$60,$80,$80,$80,$e4,$00,$00,$00,$60,$80,$80,$80,$e4
    db $01,$00,$00,$00,$00,$00,$00,$40,$01,$00,$00,$00,$00,$00,$00,$40
    db $f0,$00,$00,$00,$00,$00,$00,$00,$f0,$00,$00,$00,$00,$00,$00,$00
    db $01,$00,$00,$01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$00,$00,$00
    db $08,$08,$f8,$08,$19,$e9,$02,$02,$08,$08,$f8,$08,$19,$e9,$02,$02
    db $46,$84,$84,$84,$06,$05,$00,$00,$46,$84,$84,$84,$06,$05,$00,$00
    db $24,$20,$20,$20,$24,$c4,$00,$00,$24,$20,$20,$20,$24,$c4,$00,$00
    db $40,$40,$38,$04,$04,$78,$00,$00,$40,$40,$38,$04,$04,$78,$00,$00
    db $82,$82,$81,$82,$82,$84,$00,$00,$82,$82,$81,$82,$82,$84,$00,$00
    db $80,$80,$00,$80,$80,$40,$00,$00,$80,$80,$00,$80,$80,$40,$00,$00
    db $00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$01,$01
    db $00,$00,$00,$02,$02,$f7,$02,$02,$00,$00,$00,$02,$02,$f7,$02,$02
    db $00,$00,$00,$00,$00,$8f,$10,$00,$00,$00,$00,$00,$00,$8f,$10,$00
    db $00,$00,$00,$00,$00,$17,$98,$90,$00,$00,$00,$00,$00,$17,$98,$90
    db $00,$00,$00,$80,$80,$e4,$84,$80,$00,$00,$00,$80,$80,$e4,$84,$80
    db $00,$00,$00,$00,$00,$5c,$62,$42,$00,$00,$00,$00,$00,$5c,$62,$42
    db $00,$00,$00,$00,$00,$3c,$42,$02,$00,$00,$00,$00,$00,$3c,$42,$02
    db $00,$00,$00,$00,$00,$42,$42,$42,$00,$00,$00,$00,$00,$42,$42,$42
    db $00,$00,$00,$00,$00,$3c,$40,$40,$00,$00,$00,$00,$00,$3c,$40,$40
    db $00,$00,$00,$00,$00,$78,$84,$84,$00,$00,$00,$00,$00,$78,$84,$84
    db $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00
    db $e2,$12,$12,$e1,$00,$00,$00,$00,$e2,$12,$12,$e1,$00,$00,$00,$00
    db $0f,$10,$11,$8e,$00,$00,$00,$00,$0f,$10,$11,$8e,$00,$00,$00,$00
    db $90,$90,$90,$90,$00,$00,$00,$00,$90,$90,$90,$90,$00,$00,$00,$00
    db $80,$80,$84,$64,$00,$00,$00,$00,$80,$80,$84,$64,$00,$00,$00,$00
    db $42,$42,$62,$5c,$40,$40,$40,$00,$42,$42,$62,$5c,$40,$40,$40,$00
    db $3e,$42,$46,$3a,$00,$00,$00,$00,$3e,$42,$46,$3a,$00,$00,$00,$00
    db $42,$42,$46,$3a,$00,$00,$00,$00,$42,$42,$46,$3a,$00,$00,$00,$00
    db $38,$04,$04,$78,$00,$00,$00,$00,$38,$04,$04,$78,$00,$00,$00,$00
    db $fc,$80,$80,$7c,$00,$00,$00,$00,$fc,$80,$80,$7c,$00,$00,$00,$00
}

{		; spr_chr.inc 
org $1000
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$01,$24,$00,$00,$00,$00,$00,$0f,$39,$f7
  db $00,$00,$00,$00,$00,$00,$f0,$38,$00,$00,$00,$00,$00,$f8,$fc,$fc
  db $00,$00,$00,$01,$01,$01,$03,$07,$01,$01,$03,$03,$03,$07,$0f,$1f
  db $68,$f8,$f8,$b8,$fc,$ff,$bf,$ff,$ec,$fc,$fc,$fc,$ff,$ff,$ff,$ff
  db $1c,$1e,$1f,$1f,$3e,$ff,$bf,$0c,$1e,$1f,$1f,$1f,$ff,$ff,$ff,$bf
  db $00,$00,$80,$80,$80,$80,$80,$00,$00,$80,$c0,$c0,$c0,$c0,$c0,$80
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
  db $0c,$1e,$3e,$2f,$37,$7b,$7d,$3e,$3f,$7f,$7f,$7f,$ff,$ff,$ff,$ff
  db $ef,$3f,$1f,$07,$80,$80,$c0,$c0,$ff,$ff,$ff,$ff,$df,$e8,$f0,$e0
  db $00,$80,$80,$f0,$00,$00,$00,$00,$8c,$c0,$f0,$f8,$f0,$00,$00,$00
  db $00,$00,$07,$03,$00,$00,$00,$00,$00,$00,$0f,$07,$03,$00,$00,$00
  db $00,$00,$f8,$f8,$70,$00,$00,$01,$00,$3c,$fc,$fc,$fe,$78,$01,$03
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$c0
  db $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01
  db $5f,$6e,$6e,$77,$3e,$10,$00,$00,$ff,$ff,$ff,$ff,$ff,$fe,$f8,$e0
  db $80,$c0,$80,$00,$00,$00,$00,$00,$e0,$e0,$c0,$80,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$03,$07,$08,$00
  db $03,$03,$03,$17,$ff,$ff,$3f,$1f,$07,$07,$17,$ff,$ff,$ff,$3f,$1f
  db $c0,$f8,$fe,$ff,$7f,$bf,$fe,$f8,$f0,$fe,$ff,$ff,$ff,$ff,$ff,$ff
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$90,$a8,$94,$2b
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
  db $00,$00,$01,$0f,$1f,$3f,$3f,$3f,$02,$07,$0f,$1f,$7f,$ff,$ff,$7f
  db $00,$00,$80,$e0,$f8,$be,$7e,$fc,$00,$80,$e0,$f8,$fe,$ff,$ff,$fe
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00
  db $1f,$10,$00,$00,$00,$00,$00,$00,$1f,$1f,$11,$20,$c0,$80,$00,$00
  db $e0,$80,$00,$00,$00,$00,$00,$00,$fc,$f0,$e1,$82,$81,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$55,$aa,$55,$aa,$54,$6c,$3e,$0f
  db $00,$00,$00,$00,$00,$00,$00,$00,$e0,$f0,$90,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$01,$2a,$55,$2a,$15,$12,$23,$41
  db $00,$00,$00,$00,$00,$00,$00,$00,$5c,$b8,$58,$b0,$60,$c0,$c0,$80
  db $07,$01,$00,$00,$00,$00,$00,$00,$3f,$07,$01,$01,$01,$00,$00,$00
  db $fc,$f8,$f0,$e0,$60,$10,$00,$00,$fe,$fc,$f8,$f0,$f0,$78,$1c,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00
pad $2000
}

endif 
