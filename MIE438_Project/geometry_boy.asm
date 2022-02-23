;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12539 (Linux)
;--------------------------------------------------------
	.module geometry_boy
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _title
	.globl _game
	.globl _init_tiles
	.globl _initialize_player
	.globl _render_player
	.globl _tick_player
	.globl _collide
	.globl _debounce_input
	.globl _get_tile_by_px
	.globl _y_px_to_tile_ind
	.globl _x_px_to_tile_ind
	.globl _init_background
	.globl _scroll_bkg_x
	.globl _set_sprite_data
	.globl _get_bkg_tile_xy
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _delay
	.globl _game_title
	.globl _old_background_x_shift
	.globl _background_x_shift
	.globl _tick
	.globl _jpad
	.globl _prev_jpad
	.globl _lose
	.globl _win
	.globl _on_ground
	.globl _player_x
	.globl _player_y
	.globl _player_dx
	.globl _player_dy
	.globl _saved_bank
	.globl _count
	.globl _render_row
	.globl _scx_cnt
	.globl _out_test
	.globl _parallax_tileset
	.globl _gb_tileset
	.globl _player
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_scx_cnt::
	.ds 1
_render_row::
	.ds 1
_count::
	.ds 2
_saved_bank::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_player_dy::
	.ds 1
_player_dx::
	.ds 1
_player_y::
	.ds 1
_player_x::
	.ds 1
_on_ground::
	.ds 1
_win::
	.ds 1
_lose::
	.ds 1
_prev_jpad::
	.ds 1
_jpad::
	.ds 1
_tick::
	.ds 1
_background_x_shift::
	.ds 2
_old_background_x_shift::
	.ds 2
_game_title::
	.ds 16
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
	.area _CODE
;geometry_boy.c:94: void scroll_bkg_x(uint8_t x_shift, char* map, uint16_t map_width){
;	---------------------------------
; Function scroll_bkg_x
; ---------------------------------
_scroll_bkg_x::
;geometry_boy.c:95: scroll_bkg(x_shift, 0);
	ldhl	sp,	#2
	ld	c, (hl)
;../gbdk/include/gb/gb.h:1023: SCX_REG+=x, SCY_REG+=y;
	ldh	a, (_SCX_REG + 0)
	add	a, c
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:96: background_x_shift = (background_x_shift + x_shift);
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #_background_x_shift
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_background_x_shift + 1)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, #_background_x_shift
	ld	(hl), c
	inc	hl
	ld	(hl), a
;geometry_boy.c:98: if (background_x_shift >= old_background_x_shift){
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ret	C
;geometry_boy.c:99: old_background_x_shift = (background_x_shift/8)*8 + 8;
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #0x0008
	add	hl, bc
	ld	a, l
	ld	(_old_background_x_shift), a
	ld	a, h
	ld	(_old_background_x_shift + 1), a
;geometry_boy.c:101: count = background_x_shift/8 - 1;
	dec	de
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
;geometry_boy.c:102: count = (count + 32)%map_width;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0x20
	ld	c, a
	jr	NC, 00119$
	inc	b
00119$:
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:103: for (render_row = 0; render_row < 18; render_row++){
	ld	hl, #_render_row
	ld	(hl), #0x00
00105$:
;geometry_boy.c:104: set_bkg_tiles((background_x_shift/8 - 1)%32, render_row, 1, 1, map + count);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_count
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	dec	de
	ld	a, e
	and	a, #0x1f
	push	bc
	ld	h, #0x01
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	h, #0x01
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	hl, #_render_row
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;geometry_boy.c:105: count += map_width;
	ld	hl, #_count
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:103: for (render_row = 0; render_row < 18; render_row++){
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00105$
;geometry_boy.c:108: }
	ret
_player:
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x66	; 102	'f'
	.db #0x99	; 153
	.db #0x66	; 102	'f'
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x81	; 129
	.db #0x7e	; 126
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0xff	; 255
_gb_tileset:
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
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
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
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0xff	; 255
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
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
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
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
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x18	; 24
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
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
_parallax_tileset:
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
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
_out_test:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x1e	; 30
	.db #0x16	; 22
	.db #0x1e	; 30
	.db #0x12	; 18
	.db #0x16	; 22
	.db #0x32	; 50	'2'
	.db #0x72	; 114	'r'
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x32	; 50	'2'
	.db #0x3a	; 58
	.db #0x19	; 25
	.db #0x1d	; 29
	.db #0x32	; 50	'2'
	.db #0x3a	; 58
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
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
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x62	; 98	'b'
	.db #0x7e	; 126
	.db #0xc2	; 194
	.db #0xf3	; 243
	.db #0xc2	; 194
	.db #0xe3	; 227
	.db #0xc6	; 198
	.db #0xe7	; 231
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x5e	; 94
	.db #0x5e	; 94
	.db #0x6c	; 108	'l'
	.db #0x6f	; 111	'o'
	.db #0x0c	; 12
	.db #0x3e	; 62
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0xbc	; 188
	.db #0xbc	; 188
	.db #0xe6	; 230
	.db #0xfe	; 254
	.db #0x46	; 70	'F'
	.db #0x77	; 119	'w'
	.db #0x0c	; 12
	.db #0x2f	; 47
	.db #0x70	; 112	'p'
	.db #0x76	; 118	'v'
	.db #0xcc	; 204
	.db #0xfc	; 252
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0xbc	; 188
	.db #0xbc	; 188
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x0e	; 14
	.db #0x3f	; 63
	.db #0x04	; 4
	.db #0x07	; 7
	.db #0x86	; 134
	.db #0x86	; 134
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x32	; 50	'2'
	.db #0x3e	; 62
	.db #0x64	; 100	'd'
	.db #0x7d	; 125
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x0c	; 12
	.db #0x7f	; 127
	.db #0x1c	; 28
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x60	; 96
	.db #0x7f	; 127
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x86	; 134
	.db #0xbe	; 190
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x72	; 114	'r'
	.db #0x7e	; 126
	.db #0xe0	; 224
	.db #0xf9	; 249
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xc6	; 198
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0xcc	; 204
	.db #0xef	; 239
	.db #0x18	; 24
	.db #0x7e	; 126
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x3e	; 62
	.db #0x3f	; 63
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0xc6	; 198
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0xe2	; 226
	.db #0xfe	; 254
	.db #0xe6	; 230
	.db #0xf7	; 247
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x0c	; 12
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x1e	; 30
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x2c	; 44
	.db #0x2c	; 44
	.db #0x6c	; 108	'l'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0xc6	; 198
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0xdc	; 220
	.db #0xdc	; 220
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x77	; 119	'w'
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0xe6	; 230
	.db #0xfe	; 254
	.db #0xe6	; 230
	.db #0xf7	; 247
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0xc0	; 192
	.db #0xf3	; 243
	.db #0xc6	; 198
	.db #0xe6	; 230
	.db #0xce	; 206
	.db #0xef	; 239
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0xdc	; 220
	.db #0xdc	; 220
	.db #0x62	; 98	'b'
	.db #0x7e	; 126
	.db #0x62	; 98	'b'
	.db #0x73	; 115	's'
	.db #0x66	; 102	'f'
	.db #0x77	; 119	'w'
	.db #0xe6	; 230
	.db #0xf7	; 247
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x62	; 98	'b'
	.db #0x7e	; 126
	.db #0x78	; 120	'x'
	.db #0x79	; 121	'y'
	.db #0x60	; 96
	.db #0x7c	; 124
	.db #0xce	; 206
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xf2	; 242
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x79	; 121	'y'
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x62	; 98	'b'
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x71	; 113	'q'
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0xe0	; 224
	.db #0xfc	; 252
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xc0	; 192
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0xc0	; 192
	.db #0xf3	; 243
	.db #0xde	; 222
	.db #0xfe	; 254
	.db #0xce	; 206
	.db #0xef	; 239
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x74	; 116	't'
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3a	; 58
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x66	; 102	'f'
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x66	; 102	'f'
	.db #0x7f	; 127
	.db #0x6e	; 110	'n'
	.db #0x7f	; 127
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0x86	; 134
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x43	; 67	'C'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0xf8	; 248
	.db #0xfc	; 252
	.db #0x70	; 112	'p'
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0xe6	; 230
	.db #0xe6	; 230
	.db #0x6e	; 110	'n'
	.db #0x7f	; 127
	.db #0x78	; 120	'x'
	.db #0x7f	; 127
	.db #0x68	; 104	'h'
	.db #0x7c	; 124
	.db #0x64	; 100	'd'
	.db #0x74	; 116	't'
	.db #0xc6	; 198
	.db #0xf6	; 246
	.db #0x86	; 134
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x43	; 67	'C'
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
	.db #0x60	; 96
	.db #0x78	; 120	'x'
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x8e	; 142
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x47	; 71	'G'
	.db #0xc4	; 196
	.db #0xc4	; 196
	.db #0x46	; 70	'F'
	.db #0x66	; 102	'f'
	.db #0x6e	; 110	'n'
	.db #0x6f	; 111	'o'
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xb6	; 182
	.db #0xff	; 255
	.db #0xb6	; 182
	.db #0xff	; 255
	.db #0xa4	; 164
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x52	; 82	'R'
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x66	; 102	'f'
	.db #0x66	; 102	'f'
	.db #0x76	; 118	'v'
	.db #0x77	; 119	'w'
	.db #0x6e	; 110	'n'
	.db #0x7f	; 127
	.db #0x6e	; 110	'n'
	.db #0x7f	; 127
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0x86	; 134
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x43	; 67	'C'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0xc6	; 198
	.db #0xf7	; 247
	.db #0xc6	; 198
	.db #0xe7	; 231
	.db #0xce	; 206
	.db #0xef	; 239
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0xdc	; 220
	.db #0xdc	; 220
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x77	; 119	'w'
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0xe0	; 224
	.db #0xfe	; 254
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xc0	; 192
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0xc6	; 198
	.db #0xf7	; 247
	.db #0xf6	; 246
	.db #0xf7	; 247
	.db #0xcc	; 204
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x76	; 118	'v'
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3b	; 59
	.db #0xdc	; 220
	.db #0xdc	; 220
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x77	; 119	'w'
	.db #0x78	; 120	'x'
	.db #0x7f	; 127
	.db #0xec	; 236
	.db #0xfc	; 252
	.db #0xee	; 238
	.db #0xfe	; 254
	.db #0xc6	; 198
	.db #0xf7	; 247
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x30	; 48	'0'
	.db #0x33	; 51	'3'
	.db #0x0c	; 12
	.db #0x1c	; 28
	.db #0xc6	; 198
	.db #0xce	; 206
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x10	; 16
	.db #0x3f	; 63
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
	.db #0x70	; 112	'p'
	.db #0x78	; 120	'x'
	.db #0x70	; 112	'p'
	.db #0x78	; 120	'x'
	.db #0x60	; 96
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x66	; 102	'f'
	.db #0x76	; 118	'v'
	.db #0x4e	; 78	'N'
	.db #0x7f	; 127
	.db #0xce	; 206
	.db #0xef	; 239
	.db #0xdc	; 220
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xfe	; 254
	.db #0x78	; 120	'x'
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x86	; 134
	.db #0x86	; 134
	.db #0xce	; 206
	.db #0xcf	; 207
	.db #0x5c	; 92
	.db #0x7f	; 127
	.db #0x78	; 120	'x'
	.db #0x7e	; 126
	.db #0x78	; 120	'x'
	.db #0x7c	; 124
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x92	; 146
	.db #0x92	; 146
	.db #0xb6	; 182
	.db #0xff	; 255
	.db #0xb6	; 182
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xdc	; 220
	.db #0xfe	; 254
	.db #0x98	; 152
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x4c	; 76	'L'
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0xee	; 238
	.db #0xee	; 238
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x38	; 56	'8'
	.db #0x3e	; 62
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x4e	; 78	'N'
	.db #0x7e	; 126
	.db #0x82	; 130
	.db #0xe7	; 231
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0xc6	; 198
	.db #0xc6	; 198
	.db #0x6e	; 110	'n'
	.db #0x6f	; 111	'o'
	.db #0x1c	; 28
	.db #0x3f	; 63
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x38	; 56	'8'
	.db #0x3c	; 60
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x9c	; 156
	.db #0x9c	; 156
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x4c	; 76	'L'
	.db #0x7f	; 127
	.db #0x10	; 16
	.db #0x3e	; 62
	.db #0x2c	; 44
	.db #0x3c	; 60
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x72	; 114	'r'
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x2e	; 46
	.db #0x2e	; 46
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0xee	; 238
	.db #0xfe	; 254
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0xec	; 236
	.db #0xfe	; 254
	.db #0x48	; 72	'H'
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x46	; 70	'F'
	.db #0x5e	; 94
	.db #0x4e	; 78	'N'
	.db #0x6f	; 111	'o'
	.db #0x18	; 24
	.db #0x3f	; 63
	.db #0x10	; 16
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x3c	; 60
	.db #0x3e	; 62
	.db #0x38	; 56	'8'
	.db #0x3e	; 62
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0xc6	; 198
	.db #0xfe	; 254
	.db #0xba	; 186
	.db #0xff	; 255
	.db #0xa2	; 162
	.db #0xff	; 255
	.db #0xba	; 186
	.db #0xff	; 255
	.db #0xc6	; 198
	.db #0xff	; 255
	.db #0x7c	; 124
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0x78	; 120	'x'
	.db #0x7e	; 126
	.db #0x70	; 112	'p'
	.db #0x7c	; 124
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x10	; 16
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x08	; 8
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
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x21	; 33
	.db #0x21	; 33
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x21	; 33
	.db #0x21	; 33
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x00	; 0
	.db #0x8e	; 142
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xdc	; 220
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0xec	; 236
	.db #0x00	; 0
	.db #0xee	; 238
	.db #0x00	; 0
	.db #0xc6	; 198
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0x56	; 86	'V'
	.db #0x56	; 86	'V'
	.db #0x55	; 85	'U'
	.db #0x55	; 85	'U'
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x05	; 5
	.db #0x07	; 7
	.db #0x05	; 5
	.db #0x8d	; 141
	.db #0x88	; 136
	.db #0x8d	; 141
	.db #0x88	; 136
	.db #0xd8	; 216
	.db #0x50	; 80	'P'
	.db #0xd8	; 216
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x50	; 80	'P'
	.db #0xd8	; 216
	.db #0x88	; 136
	.db #0xd8	; 216
	.db #0x88	; 136
	.db #0x8d	; 141
	.db #0x05	; 5
	.db #0x0d	; 13
	.db #0x05	; 5
	.db #0x07	; 7
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0xf1	; 241
	.db #0xf1	; 241
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf1	; 241
	.db #0xf1	; 241
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x30	; 48	'0'
	.db #0x3f	; 63
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x28	; 40
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xbf	; 191
	.db #0xbf	; 191
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x8f	; 143
	.db #0x8f	; 143
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
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
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0xc2	; 194
	.db #0xc2	; 194
	.db #0xc4	; 196
	.db #0xe5	; 229
	.db #0x0c	; 12
	.db #0x6e	; 110	'n'
	.db #0x38	; 56	'8'
	.db #0x3e	; 62
	.db #0x70	; 112	'p'
	.db #0x7c	; 124
	.db #0xe6	; 230
	.db #0xfe	; 254
	.db #0xc6	; 198
	.db #0xf7	; 247
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x08	; 8
	.db #0x0e	; 14
	.db #0x10	; 16
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x1c	; 28
	.db #0x10	; 16
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x0e	; 14
	.db #0x0f	; 15
	.db #0x0c	; 12
	.db #0x0f	; 15
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x30	; 48	'0'
	.db #0x3c	; 60
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x20	; 32
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
;geometry_boy.c:110: void init_background(char * map, uint16_t map_width){
;	---------------------------------
; Function init_background
; ---------------------------------
_init_background::
;geometry_boy.c:111: count = 0;
	xor	a, a
	ld	hl, #_count
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:112: for (render_row = 0; render_row < 18; render_row++){
	ld	hl, #_render_row
	ld	(hl), #0x00
00102$:
;geometry_boy.c:113: set_bkg_tiles(0, render_row, 32, 1, map + count);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_count
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	hl, #0x120
	push	hl
	ld	a, (#_render_row)
	ld	h, a
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;geometry_boy.c:114: count += map_width;
	ld	hl, #_count
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:112: for (render_row = 0; render_row < 18; render_row++){
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
;geometry_boy.c:116: }
	ret
;geometry_boy.c:118: uint8_t x_px_to_tile_ind(uint8_t x_px){
;	---------------------------------
; Function x_px_to_tile_ind
; ---------------------------------
_x_px_to_tile_ind::
	add	sp, #-4
;geometry_boy.c:119: return (x_px - XOFF) / 8;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	bit	7, (hl)
	jr	Z, 00103$
	pop	de
	push	de
	ld	hl, #0xffff
	add	hl, de
	ld	c, l
	ld	b, h
00103$:
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	e, c
;geometry_boy.c:120: }
	add	sp, #4
	ret
;geometry_boy.c:122: uint8_t y_px_to_tile_ind(uint8_t y_px){
;	---------------------------------
; Function y_px_to_tile_ind
; ---------------------------------
_y_px_to_tile_ind::
	add	sp, #-4
;geometry_boy.c:123: return (y_px - YOFF) / 8;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	bit	7, (hl)
	jr	Z, 00103$
	pop	de
	push	de
	ld	hl, #0xfff7
	add	hl, de
	ld	c, l
	ld	b, h
00103$:
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	e, c
;geometry_boy.c:124: }
	add	sp, #4
	ret
;geometry_boy.c:126: uint8_t get_tile_by_px(uint8_t x_px, uint8_t y_px){
;	---------------------------------
; Function get_tile_by_px
; ---------------------------------
_get_tile_by_px::
;geometry_boy.c:131: , y_px_to_tile_ind(y_px)
	ldhl	sp,	#3
	ld	a, (hl)
	push	af
	inc	sp
	call	_y_px_to_tile_ind
	inc	sp
	ld	b, e
;geometry_boy.c:129: x_px + background_x_shift
	ld	a, (#_background_x_shift)
	ldhl	sp,	#2
	add	a, (hl)
	push	bc
	push	af
	inc	sp
	call	_x_px_to_tile_ind
	inc	sp
	ld	a, e
	inc	sp
	push	af
	inc	sp
	call	_get_bkg_tile_xy
	pop	hl
;geometry_boy.c:133: }
	ret
;geometry_boy.c:135: uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button){
;	---------------------------------
; Function debounce_input
; ---------------------------------
_debounce_input::
;geometry_boy.c:136: return (button == target) && !(prev_button == target);
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	sub	a, (hl)
	jr	NZ, 00103$
	ldhl	sp,	#3
	ld	a, (hl-)
	sub	a, (hl)
	jr	NZ, 00104$
00103$:
	ld	e, #0x00
	ret
00104$:
	ld	e, #0x01
;geometry_boy.c:137: }
	ret
;geometry_boy.c:140: void collide(int8_t vel_y){
;	---------------------------------
; Function collide
; ---------------------------------
_collide::
	add	sp, #-18
;geometry_boy.c:142: int tiles[4] = {
	ldhl	sp,	#0
	ld	a, l
	ld	d, h
	ldhl	sp,	#8
	ld	(hl+), a
	ld	(hl), d
	ld	a, (#_player_x)
	add	a, #0x07
	ld	hl, #_player_y
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_get_tile_by_px
	pop	hl
	ld	c, e
	ld	b, #0x00
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	push	bc
	ld	a, (#_player_y)
	ld	h, a
	ld	a, (#_player_x)
	ld	l, a
	push	hl
	call	_get_tile_by_px
	pop	hl
	pop	bc
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (#_player_y)
	add	a, #0x07
	ld	d, a
	ld	a, (#_player_x)
	add	a, #0x07
	push	bc
	push	de
	inc	sp
	push	af
	inc	sp
	call	_get_tile_by_px
	pop	hl
	pop	bc
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (#_player_y)
	add	a, #0x07
	push	bc
	push	af
	inc	sp
	ld	a, (#_player_x)
	push	af
	inc	sp
	call	_get_tile_by_px
	pop	hl
	pop	bc
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;geometry_boy.c:148: for (uint8_t i = 0; i < 4; i++){
	ldhl	sp,	#20
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00219$
	bit	7, d
	jr	NZ, 00220$
	cp	a, a
	jr	00220$
00219$:
	bit	7, d
	jr	Z, 00220$
	scf
00220$:
	ld	a, #0x00
	rla
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	rlca
	and	a,#0x01
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#17
	ld	(hl), #0x00
00125$:
	ldhl	sp,	#17
;geometry_boy.c:149: uint8_t tile = tiles[i];
	ld	a,(hl)
	cp	a,#0x04
	jp	NC,00116$
	ld	d, #0x00
	add	a, a
	rl	d
	ld	e, a
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#12
;geometry_boy.c:151: if (tile == 0x5){ // TODO: formalize tile indices
	ld	(hl), a
	sub	a, #0x05
	jr	NZ, 00102$
;geometry_boy.c:152: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:153: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:154: player_x = (player_x/8)*8;
	ld	a, (#_player_x)
	ldhl	sp,	#13
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	dec	hl
	bit	7, (hl)
	jr	Z, 00129$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
00129$:
	ldhl	sp,#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_x),a
;geometry_boy.c:155: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
00102$:
;geometry_boy.c:158: if (tile == 0x3){ // black block or floor block
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x03
	jp	NZ,00110$
;geometry_boy.c:160: player_y = (player_y/8)*8;
	ld	hl, #_player_y
	ld	c, (hl)
	ld	b, #0x00
	ld	a, b
	rlca
	and	a,#0x01
	ldhl	sp,	#16
	ld	(hl), a
	ld	hl, #0x0007
	add	hl, bc
	ld	e, l
	ld	d, h
;geometry_boy.c:159: if (vel_y > 0){ // falling down
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
;geometry_boy.c:160: player_y = (player_y/8)*8;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
	ld	c, e
	ld	b, d
00130$:
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_y),a
;geometry_boy.c:161: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:162: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jr	00110$
00107$:
;geometry_boy.c:163: } else if (vel_y < 0) {// jumping up
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:164: player_y = (player_y/8)*8 + 8;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
	ld	c, e
	ld	b, d
00131$:
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x08
	ld	(#_player_y),a
	jr	00110$
00104$:
;geometry_boy.c:167: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:168: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:169: player_x = (player_x/8)*8;
	ld	hl, #_player_x
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	c, l
	ld	b, h
	bit	7, h
	jr	Z, 00132$
	ld	bc, #0x7
	add	hl,bc
	ld	c, l
	ld	b, h
00132$:
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_x),a
;geometry_boy.c:170: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
00110$:
;geometry_boy.c:174: if (tile == 0xB){ // jump tile
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x0b
	jr	NZ, 00112$
;geometry_boy.c:175: player_dy = -9;
	ld	hl, #_player_dy
	ld	(hl), #0xf7
00112$:
;geometry_boy.c:177: if (tile == 0xA && jpad == J_UP){
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x0a
	jr	NZ, 00126$
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00126$
;geometry_boy.c:178: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
00126$:
;geometry_boy.c:148: for (uint8_t i = 0; i < 4; i++){
	ldhl	sp,	#17
	inc	(hl)
	jp	00125$
00116$:
;geometry_boy.c:181: if (vel_y == 0){
	ldhl	sp,	#20
	ld	a, (hl)
	or	a, a
	jr	NZ, 00127$
;geometry_boy.c:182: uint8_t down_right = get_tile_by_px(player_x+PLAYER_WIDTH, player_y + PLAYER_WIDTH);
	ld	a, (#_player_y)
	add	a, #0x08
	ld	b, a
	ld	a, (#_player_x)
	add	a, #0x08
	push	bc
	inc	sp
	push	af
	inc	sp
	call	_get_tile_by_px
	pop	hl
	ld	c, e
;geometry_boy.c:183: uint8_t down_left = get_tile_by_px(player_x, player_y + PLAYER_WIDTH);
	ld	a, (#_player_y)
	add	a, #0x08
	push	bc
	push	af
	inc	sp
	ld	a, (#_player_x)
	push	af
	inc	sp
	call	_get_tile_by_px
	pop	hl
	pop	bc
;geometry_boy.c:184: if (down_right == 0x1 || down_right == 0x5 || down_left == 0x1 || down_right == 0x5){
	ld	a, c
	dec	a
	jr	Z, 00117$
	ld	a, c
	sub	a, #0x05
	ld	a, #0x01
	jr	Z, 00234$
	xor	a, a
00234$:
	ld	c, a
	or	a, a
	jr	NZ, 00117$
	dec	e
	jr	Z, 00117$
	ld	a, c
	or	a, a
	jr	Z, 00127$
00117$:
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
00127$:
;geometry_boy.c:188: }
	add	sp, #18
	ret
;geometry_boy.c:190: void tick_player(){
;	---------------------------------
; Function tick_player
; ---------------------------------
_tick_player::
;geometry_boy.c:191: if (jpad == J_UP) { //debounce_input(J_UP, prev_jpad, jpad)){ // if jumping
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00104$
;geometry_boy.c:192: if (on_ground){
	ld	a, (#_on_ground)
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:193: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
00104$:
;geometry_boy.c:196: if (!on_ground){
	ld	a, (#_on_ground)
	or	a, a
	jr	NZ, 00108$
;geometry_boy.c:198: player_dy += GRAVITY;
	ld	hl, #_player_dy
	inc	(hl)
;geometry_boy.c:200: if (player_dy > MAX_FALL_SPEED){ // terminal velocity
	ld	e, (hl)
	ld	a,#0x07
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00133$
	bit	7, d
	jr	NZ, 00134$
	cp	a, a
	jr	00134$
00133$:
	bit	7, d
	jr	Z, 00134$
	scf
00134$:
	jr	NC, 00108$
;geometry_boy.c:201: player_dy = MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x07
00108$:
;geometry_boy.c:205: collide(0);
	xor	a, a
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:207: player_y += player_dy;
	ld	a, (#_player_y)
	ld	hl, #_player_dy
	add	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:210: on_ground = 0;
	ld	hl, #_on_ground
	ld	(hl), #0x00
;geometry_boy.c:212: collide(player_dy);
	ld	a, (#_player_dy)
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:213: }
	ret
;geometry_boy.c:215: void render_player(){ // i want a better name for this function
;	---------------------------------
; Function render_player
; ---------------------------------
_render_player::
;geometry_boy.c:216: move_sprite(0, player_x,     player_y    );
	ld	hl, #_player_y
	ld	b, (hl)
	ld	hl, #_player_x
	ld	c, (hl)
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:216: move_sprite(0, player_x,     player_y    );
;geometry_boy.c:217: }
	ret
;geometry_boy.c:219: void initialize_player(){
;	---------------------------------
; Function initialize_player
; ---------------------------------
_initialize_player::
;geometry_boy.c:220: set_sprite_data(0, 1, player);
	ld	de, #_player
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_sprite_data
	add	sp, #4
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;geometry_boy.c:221: set_sprite_tile(0,0);
;geometry_boy.c:222: }
	ret
;geometry_boy.c:224: void init_tiles(){
;	---------------------------------
; Function init_tiles
; ---------------------------------
_init_tiles::
;geometry_boy.c:225: set_bkg_data(0, 13, gb_tileset); // load tiles into VRAM
	ld	de, #_gb_tileset
	push	de
	ld	hl, #0xd00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:226: set_bkg_data(13, 16, parallax_tileset); // load tiles into VRAM
	ld	de, #_parallax_tileset
	push	de
	ld	hl, #0x100d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:227: }
	ret
;geometry_boy.c:229: screen_t game(){
;	---------------------------------
; Function game
; ---------------------------------
_game::
	dec	sp
;geometry_boy.c:230: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:232: initialize_player();
	call	_initialize_player
;geometry_boy.c:233: render_player(); // render at initial position
	call	_render_player
;geometry_boy.c:234: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:236: init_tiles();
	call	_init_tiles
;geometry_boy.c:239: background_x_shift = 0; 
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:240: old_background_x_shift = 8; 
	ld	hl, #_old_background_x_shift
	ld	a, #0x08
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;../gbdk/include/gb/gb.h:1009: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;geometry_boy.c:243: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:244: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:246: SWITCH_ROM_MBC1(level1Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
;geometry_boy.c:248: init_background(level1, level1Width);
	ld	de, #0x0200
	ld	(hl), d
	push	de
	ld	de, #_level1
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:249: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:252: uint8_t white_tile_ind = 0;
	ld	c, #0x00
;geometry_boy.c:253: uint8_t green_tile_ind = 128; //8*16;
	ldhl	sp,	#0
	ld	(hl), #0x80
;geometry_boy.c:254: while (1){
00110$:
;geometry_boy.c:255: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:257: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:258: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:260: if (debounce_input(J_A, jpad, prev_jpad)){ // press A to exit
	push	bc
	ld	a, (#_prev_jpad)
	push	af
	inc	sp
	ld	a, (#_jpad)
	ld	h, a
	ld	l, #0x10
	push	hl
	call	_debounce_input
	add	sp, #3
	ld	a, e
	pop	bc
	or	a, a
	jr	Z, 00102$
;geometry_boy.c:261: return TITLE;
	ld	e, #0x00
	jp	00114$
00102$:
;geometry_boy.c:265: tick_player();
	push	bc
	call	_tick_player
	call	_render_player
	pop	bc
;geometry_boy.c:269: SWITCH_ROM_MBC1(level1Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:270: scroll_bkg_x(player_dx, level1, level1Width);
	push	bc
	ld	de, #0x0200
	push	de
	ld	de, #_level1
	push	de
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
	pop	bc
;geometry_boy.c:271: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:273: if (lose){ // TODO: add this to a reset function
	ld	a, (#_lose)
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:274: background_x_shift = 0; 
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:275: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:276: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:277: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:278: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:279: old_background_x_shift = 8;
	ld	hl, #_old_background_x_shift
	ld	a, #0x08
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:280: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:281: SWITCH_ROM_MBC1(level1Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:282: init_background(level1, level1Width);
	push	bc
	ld	de, #0x0200
	push	de
	ld	de, #_level1
	push	de
	call	_init_background
	add	sp, #4
	pop	bc
;geometry_boy.c:284: move_bkg(background_x_shift, 0);
	ld	a, (#_background_x_shift)
	ldh	(_SCX_REG + 0), a
;../gbdk/include/gb/gb.h:1009: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCY_REG + 0), a
;geometry_boy.c:285: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
00104$:
;geometry_boy.c:288: white_tile_ind -= 16; 
	ld	a, c
	add	a, #0xf0
;geometry_boy.c:289: if (white_tile_ind <= 0){
	ld	c, a
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:290: white_tile_ind = 240;
	ld	c, #0xf0
00106$:
;geometry_boy.c:292: green_tile_ind -= 16;
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0xf0
	ld	(hl), a
;geometry_boy.c:293: if (green_tile_ind <= 0){
	ld	a, (hl)
	or	a, a
	jr	NZ, 00108$
;geometry_boy.c:294: green_tile_ind = 240; // 16*15
	ld	(hl), #0xf0
00108$:
;geometry_boy.c:296: set_bkg_data(6, 1, parallax_tileset + white_tile_ind); // load tiles into VRAM
	ld	hl, #_parallax_tileset
	ld	b, #0x00
	add	hl, bc
	push	hl
	ld	hl, #0x106
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:297: set_bkg_data(7, 1, parallax_tileset + green_tile_ind); // load tiles into VRAM
	ld	de, #_parallax_tileset
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	hl, #0x107
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:299: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:300: delay(LOOP_DELAY);
	push	bc
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	pop	bc
	jp	00110$
00114$:
;geometry_boy.c:302: }
	inc	sp
	ret
;geometry_boy.c:304: screen_t title(){
;	---------------------------------
; Function title
; ---------------------------------
_title::
	add	sp, #-10
;geometry_boy.c:305: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:308: for (uint8_t i = 0; i < TITLE_WIDTH*TITLE_HEIGHT; i++){
	ldhl	sp,	#9
	ld	(hl), #0x00
00128$:
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00104$
;geometry_boy.c:309: if (game_title[i] == ' '){
	ld	de, #_game_title
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl)
	sub	a, #0x20
	jr	Z, 00103$
;geometry_boy.c:312: set_sprite_data(1 + i, 1, out_test + 16*(13 + game_title[i] - 65)); // load tiles into VRAM
	ldhl	sp,	#8
	ld	a, (hl)
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, #0xffcc
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	a, #0x04
00214$:
	ldhl	sp,	#5
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00214$
	ld	de, #_out_test
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	b, (hl)
	inc	b
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:314: set_sprite_tile(i+1,i+1);
	ld	c, b
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	ld	(hl), c
;geometry_boy.c:314: set_sprite_tile(i+1,i+1);
00103$:
;geometry_boy.c:308: for (uint8_t i = 0; i < TITLE_WIDTH*TITLE_HEIGHT; i++){
	ldhl	sp,	#9
	inc	(hl)
	jr	00128$
00104$:
;geometry_boy.c:317: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:319: init_tiles();
	call	_init_tiles
;geometry_boy.c:321: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:322: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:324: SWITCH_ROM_MBC1(title_mapBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:326: init_background(title_map, title_mapWidth);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:328: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:330: uint8_t white_tile_ind = 0;
	ldhl	sp,	#0
;geometry_boy.c:331: uint8_t green_tile_ind = 128; //8*16;
	xor	a, a
	ld	(hl+), a
;geometry_boy.c:332: uint8_t moving_letter_ind = 0;
	ld	a, #0x80
	ld	(hl+), a
;geometry_boy.c:333: uint8_t up = 1;
	xor	a, a
	ld	(hl+), a
;geometry_boy.c:334: uint8_t offset = 0;
	ld	a, #0x01
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:335: while (1){
00122$:
;geometry_boy.c:336: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:337: SWITCH_ROM_MBC1(title_mapBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:338: scroll_bkg_x(player_dx, title_map, title_mapWidth);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map
	push	de
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
;geometry_boy.c:339: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:340: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(hl), a
;geometry_boy.c:341: if (tick % 1 == 0){
	xor	a, a
	ldhl	sp,	#8
	ld	(hl+), a
	ld	(hl), a
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00117$
;geometry_boy.c:342: white_tile_ind -= 16; 
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0xf0
	ld	(hl), a
;geometry_boy.c:343: if (white_tile_ind <= 0){
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:344: white_tile_ind = 240;
	ld	(hl), #0xf0
00106$:
;geometry_boy.c:346: green_tile_ind -= 16;
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, #0xf0
	ld	(hl), a
;geometry_boy.c:347: if (green_tile_ind <= 0){
	ld	a, (hl)
	or	a, a
	jr	NZ, 00108$
;geometry_boy.c:348: green_tile_ind = 240; // 16*15
	ld	(hl), #0xf0
00108$:
;geometry_boy.c:350: set_bkg_data(6, 1, parallax_tileset + white_tile_ind); // load tiles into VRAM
	ld	de, #_parallax_tileset
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	hl, #0x106
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:351: set_bkg_data(7, 1, parallax_tileset + green_tile_ind); // load tiles into VRAM
	ld	de, #_parallax_tileset
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	hl, #0x107
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:354: offset += 1;
	ldhl	sp,	#4
;geometry_boy.c:353: if (up){
	ld	a, (hl-)
	ld	c, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
;geometry_boy.c:354: offset += 1;
	inc	hl
	ld	a, c
	inc	a
	ld	(hl), a
;geometry_boy.c:355: if (offset == 2){
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00115$
;geometry_boy.c:356: up = 0;
	ldhl	sp,	#3
	ld	(hl), #0x00
	jr	00115$
00114$:
;geometry_boy.c:359: offset -=1;
	ld	a, c
	dec	a
	ldhl	sp,	#4
	ld	(hl), a
;geometry_boy.c:360: if (offset == 0){
	ld	a, (hl)
	or	a, a
	jr	NZ, 00115$
;geometry_boy.c:361: up = 1;
	dec	hl
;geometry_boy.c:362: moving_letter_ind = (moving_letter_ind + 1) % (TITLE_WIDTH*TITLE_HEIGHT);
	ld	a, #0x01
	ld	(hl-), a
	ld	c, (hl)
	ld	b, #0x00
	inc	bc
	ld	de, #0x0010
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	ldhl	sp,	#2
	ld	(hl), e
00115$:
;geometry_boy.c:369: TITLE_START_Y + (8 + SPACE_PX)*(moving_letter_ind/TITLE_WIDTH) - offset
	ldhl	sp,	#2
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, b
	rlca
	and	a,#0x01
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #0x0007
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00134$
	inc	hl
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
00134$:
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	a,e
	add	a, a
	add	a, a
	add	a, a
	add	a, e
	add	a, #0x20
	ldhl	sp,	#4
	ld	e, (hl)
	sub	a, e
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:368: TITLE_START_X + (8 + SPACE_PX)*(moving_letter_ind%TITLE_WIDTH) + 4*(moving_letter_ind/TITLE_WIDTH),
	ld	a, c
	and	a, #0x07
	ld	e, a
	add	a, a
	add	a, a
	add	a, a
	add	a, e
	add	a, #0x36
	ldhl	sp,	#9
	ld	(hl), a
	ld	e, c
	ld	d, b
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00135$
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
00135$:
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	ld	a, e
	add	a, a
	add	a, a
	ldhl	sp,	#9
	add	a, (hl)
	ld	c, a
;geometry_boy.c:367: moving_letter_ind+1, 
	ldhl	sp,	#2
	ld	b, (hl)
	inc	b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	e, l
	ld	d, h
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;geometry_boy.c:370: );
00117$:
;geometry_boy.c:374: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:375: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:377: if (debounce_input(J_START, jpad, prev_jpad)){
	ld	a, (#_prev_jpad)
	push	af
	inc	sp
	ld	a, (#_jpad)
	ld	h, a
	ld	l, #0x80
	push	hl
	call	_debounce_input
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00120$
;geometry_boy.c:378: for (uint8_t i = 1; i < TITLE_WIDTH*TITLE_HEIGHT+1; i++){
	ld	c, #0x01
00130$:
	ld	a, c
	sub	a, #0x11
	jr	NC, 00118$
;../gbdk/include/gb/gb.h:1425: shadow_OAM[nb].y = 0;
	ld	de, #_shadow_OAM+0
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	(hl), #0x00
;geometry_boy.c:378: for (uint8_t i = 1; i < TITLE_WIDTH*TITLE_HEIGHT+1; i++){
	inc	c
	jr	00130$
00118$:
;geometry_boy.c:381: return GAME;
	ld	e, #0x01
	jr	00132$
00120$:
;geometry_boy.c:383: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:384: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00122$
00132$:
;geometry_boy.c:386: }
	add	sp, #10
	ret
;geometry_boy.c:389: void main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:393: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:394: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(#_saved_bank),a
;geometry_boy.c:395: screen_t current_screen = TITLE;
	ld	e, #0x00
;geometry_boy.c:397: while (1){
00107$:
;geometry_boy.c:398: if (current_screen == TITLE){
	ld	a, e
	or	a, a
	jr	NZ, 00104$
;geometry_boy.c:399: current_screen = title();
	call	_title
	jr	00107$
00104$:
;geometry_boy.c:400: } else if (current_screen == GAME){
	ld	a, e
	dec	a
	jr	NZ, 00107$
;geometry_boy.c:401: current_screen = game();
	call	_game
;geometry_boy.c:404: }
	jr	00107$
	.area _CODE
	.area _INITIALIZER
__xinit__player_dy:
	.db #0x00	;  0
__xinit__player_dx:
	.db #0x03	;  3
__xinit__player_y:
	.db #0x90	; 144
__xinit__player_x:
	.db #0x20	; 32
__xinit__on_ground:
	.db #0x01	; 1
__xinit__win:
	.db #0x00	; 0
__xinit__lose:
	.db #0x00	; 0
__xinit__prev_jpad:
	.db #0x00	; 0
__xinit__jpad:
	.db #0x00	; 0
__xinit__tick:
	.db #0x00	; 0
__xinit__background_x_shift:
	.dw #0x0000
__xinit__old_background_x_shift:
	.dw #0x0008
__xinit__game_title:
	.db #0x47	;  71	'G'
	.db #0x45	;  69	'E'
	.db #0x4f	;  79	'O'
	.db #0x4d	;  77	'M'
	.db #0x45	;  69	'E'
	.db #0x54	;  84	'T'
	.db #0x52	;  82	'R'
	.db #0x59	;  89	'Y'
	.db #0x20	;  32
	.db #0x20	;  32
	.db #0x42	;  66	'B'
	.db #0x4f	;  79	'O'
	.db #0x59	;  89	'Y'
	.db #0x20	;  32
	.db #0x20	;  32
	.db #0x20	;  32
	.area _CABS (ABS)
