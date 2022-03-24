;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12539 (Linux)
;--------------------------------------------------------
	.module players
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _players
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_2
	.area _CODE_2
_players:
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x99	; 153
	.db #0x81	; 129
	.db #0x99	; 153
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xdb	; 219
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xc3	; 195
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xf0	; 240
	.db #0xf7	; 247
	.db #0xf0	; 240
	.db #0xc7	; 199
	.db #0xc0	; 192
	.db #0xdf	; 223
	.db #0xc0	; 192
	.db #0xdf	; 223
	.db #0xc0	; 192
	.db #0xc7	; 199
	.db #0xc0	; 192
	.db #0xf7	; 247
	.db #0xf0	; 240
	.db #0xf7	; 247
	.db #0xf0	; 240
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xc3	; 195
	.db #0x81	; 129
	.db #0xdb	; 219
	.db #0x81	; 129
	.db #0xf3	; 243
	.db #0x81	; 129
	.db #0xe7	; 231
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xe7	; 231
	.db #0x81	; 129
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xc3	; 195
	.db #0xdb	; 219
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xc3	; 195
	.db #0xdb	; 219
	.db #0xe7	; 231
	.db #0x07	; 7
	.db #0xe7	; 231
	.db #0x07	; 7
	.db #0xe7	; 231
	.db #0x07	; 7
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0xe7	; 231
	.db #0xe0	; 224
	.db #0xe7	; 231
	.db #0xe0	; 224
	.db #0xe7	; 231
	.db #0xe0	; 224
	.db #0xa7	; 167
	.db #0xc7	; 199
	.db #0xa0	; 160
	.db #0xc7	; 199
	.db #0xa7	; 167
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe5	; 229
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0xe3	; 227
	.db #0xe5	; 229
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x66	; 102	'f'
	.db #0xff	; 255
	.db #0x66	; 102	'f'
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0xff	; 255
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x24	; 36
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x99	; 153
	.db #0x18	; 24
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xbd	; 189
	.db #0x18	; 24
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x91	; 145
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x89	; 137
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xfe	; 254
	.db #0x43	; 67	'C'
	.db #0xfc	; 252
	.db #0x27	; 39
	.db #0xf8	; 248
	.db #0x1f	; 31
	.db #0xf8	; 248
	.db #0x1f	; 31
	.db #0xe4	; 228
	.db #0x3f	; 63
	.db #0xc2	; 194
	.db #0x7f	; 127
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x04	; 4
	.db #0x64	; 100	'd'
	.db #0x06	; 6
	.db #0xa6	; 166
	.db #0x0f	; 15
	.db #0x2f	; 47
	.db #0x06	; 6
	.db #0x20	; 32
	.db #0x06	; 6
	.db #0x20	; 32
	.db #0x3e	; 62
	.db #0x1e	; 30
	.db #0x06	; 6
	.db #0x16	; 22
	.db #0x06	; 6
	.db #0x16	; 22
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xdb	; 219
	.db #0xdb	; 219
	.db #0xdb	; 219
	.db #0xdb	; 219
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.area _INITIALIZER
	.area _CABS (ABS)
