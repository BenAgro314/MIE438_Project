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
	.globl _level_select
	.globl _player_select
	.globl _title
	.globl _game
	.globl _initialize_player
	.globl _render_player
	.globl _tick_player
	.globl _collide
	.globl _init_background
	.globl _scroll_bkg_x
	.globl _vbl_interrupt_title
	.globl _vbl_interrupt_game
	.globl _lcd_interrupt_game
	.globl _update_HUD_bar
	.globl _gbt_update
	.globl _gbt_loop
	.globl _gbt_play
	.globl _set_sprite_data
	.globl _set_win_tile_xy
	.globl _get_bkg_tile_xy
	.globl _set_bkg_tile_xy
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _wait_vbl_done
	.globl _set_interrupts
	.globl _joypad
	.globl _delay
	.globl _add_LCD
	.globl _add_VBL
	.globl _remove_LCD
	.globl _remove_VBL
	.globl _cursor_title_position_old
	.globl _cursor_title_position
	.globl _title_loaded
	.globl _saved
	.globl _old_px_progress_bar
	.globl _px_progress_bar
	.globl _current_attempts
	.globl _level_banks
	.globl _level_widths
	.globl _level_maps
	.globl _level_ind
	.globl _parallax_tile_ind
	.globl _old_scroll_x
	.globl _old_background_x_shift
	.globl _background_x_shift
	.globl _tick
	.globl _jpad
	.globl _prev_jpad
	.globl _lose
	.globl _win
	.globl _on_ground
	.globl _player_sprite_num
	.globl _player_x
	.globl _player_y
	.globl _player_dx
	.globl _player_dy
	.globl _px_progress
	.globl _attempts
	.globl _vbl_count
	.globl _saved_bank
	.globl _count
	.globl _render_col
	.globl _render_row
	.globl _scx_cnt
	.globl _back_text
	.globl _attempts_text
	.globl _progress_text
	.globl _level_text
	.globl _player_text
	.globl _start_text
	.globl _game_title
	.globl _attempts_title
	.globl _progress_bar_tiles
	.globl _aero_cursors
	.globl _gb_tileset_v2
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
_render_col::
	.ds 1
_count::
	.ds 2
_saved_bank::
	.ds 1
_vbl_count::
	.ds 1
_attempts::
	.ds 4
_px_progress::
	.ds 4
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
_player_sprite_num::
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
_old_scroll_x::
	.ds 2
_parallax_tile_ind::
	.ds 1
_level_ind::
	.ds 1
_level_maps::
	.ds 4
_level_widths::
	.ds 4
_level_banks::
	.ds 2
_current_attempts::
	.ds 2
_px_progress_bar::
	.ds 2
_old_px_progress_bar::
	.ds 2
_saved::
	.ds 2
_title_loaded::
	.ds 1
_cursor_title_position::
	.ds 1
_cursor_title_position_old::
	.ds 1
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
;geometry_boy.c:242: void update_HUD_bar()
;	---------------------------------
; Function update_HUD_bar
; ---------------------------------
_update_HUD_bar::
;geometry_boy.c:244: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
	ld	hl, #_player_x
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
	ld	b, h
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	de, #_level_widths+0
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	l, (hl)
;	spillPairReg hl
	add	a, #0xec
	ld	e, a
	ld	a, l
	adc	a, #0xff
	ld	d, a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ld	hl, #_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:245: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:248: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:246: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00108$
;geometry_boy.c:248: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:249: while (px_progress_bar > 8)
00101$:
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x08
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00103$
;geometry_boy.c:251: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:252: px_progress_bar -= 8;
	ld	a, c
	add	a, #0xf8
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	hl, #_px_progress_bar
	ld	(hl), c
	inc	hl
	ld	(hl), a
	jr	00101$
00103$:
;geometry_boy.c:254: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
	ld	a, (#_px_progress_bar)
	add	a, #0x33
	ld	h, a
	ld	l, #0x01
	push	hl
	ld	a, (#_render_col)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
	ret
00108$:
;geometry_boy.c:258: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:259: while (render_col < NUM_PROGRESS_BAR_TILES)
00104$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	ret	NC
;geometry_boy.c:261: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3301
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:262: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:265: }
	jr	00104$
_gb_tileset_v2:
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
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
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
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x03	; 3
	.db #0x03	; 3
_aero_cursors:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
_progress_bar_tiles:
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
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0x3f	; 63
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0x01	; 1
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
_attempts_title:
	.db #0x41	;  65	'A'
	.db #0x54	;  84	'T'
	.db #0x54	;  84	'T'
	.db #0x45	;  69	'E'
	.db #0x4d	;  77	'M'
	.db #0x50	;  80	'P'
	.db #0x54	;  84	'T'
;geometry_boy.c:267: void lcd_interrupt_game()
;	---------------------------------
; Function lcd_interrupt_game
; ---------------------------------
_lcd_interrupt_game::
;geometry_boy.c:269: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:270: } // hide the window, triggers at the scanline LYC
	ret
;geometry_boy.c:273: void vbl_interrupt_game()
;	---------------------------------
; Function vbl_interrupt_game
; ---------------------------------
_vbl_interrupt_game::
;geometry_boy.c:275: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:276: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:277: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
	ld	a, (#_background_x_shift)
	ld	hl, #_old_scroll_x
	sub	a, (hl)
	ld	c, a
	ld	a, (#_background_x_shift + 1)
	ld	hl, #_old_scroll_x + 1
	sbc	a, (hl)
	dec	hl
	ld	b, a
	inc	bc
	srl	b
	rr	c
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_old_scroll_x + 1)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, #_old_scroll_x
	ld	(hl), c
	inc	hl
;geometry_boy.c:278: SCX_REG = old_scroll_x; // + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:279: }
	ret
;geometry_boy.c:281: void vbl_interrupt_title()
;	---------------------------------
; Function vbl_interrupt_title
; ---------------------------------
_vbl_interrupt_title::
;geometry_boy.c:283: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:284: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
	ld	a, (#_background_x_shift)
	ld	hl, #_old_scroll_x
	sub	a, (hl)
	ld	c, a
	ld	a, (#_background_x_shift + 1)
	ld	hl, #_old_scroll_x + 1
	sbc	a, (hl)
	dec	hl
	ld	b, a
	inc	bc
	srl	b
	rr	c
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_old_scroll_x + 1)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, #_old_scroll_x
	ld	(hl), c
	inc	hl
;geometry_boy.c:285: SCX_REG = old_scroll_x + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #_player_dx
	add	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:286: }
	ret
;geometry_boy.c:288: void scroll_bkg_x(uint8_t x_shift, char *map, uint16_t map_width)
;	---------------------------------
; Function scroll_bkg_x
; ---------------------------------
_scroll_bkg_x::
;geometry_boy.c:290: background_x_shift = (background_x_shift + x_shift);
	ldhl	sp,	#2
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
	ld	e, l
	ld	a, h
	ld	hl, #_background_x_shift
	ld	(hl), e
	inc	hl
	ld	(hl), a
;geometry_boy.c:291: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ret	C
;geometry_boy.c:294: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
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
	ld	a, l
	add	a, #0x08
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	jr	NC, 00118$
	inc	h
00118$:
	add	hl, bc
	ld	a, l
	ld	(_old_background_x_shift), a
	ld	a, h
	ld	(_old_background_x_shift + 1), a
;geometry_boy.c:295: count = (background_x_shift >> 3) - 1;
	dec	de
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
;geometry_boy.c:296: count = (count + 32) % map_width;
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
;geometry_boy.c:297: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00104$:
;geometry_boy.c:300: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
	ld	a, e
	dec	a
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
;geometry_boy.c:301: count += map_width;
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
;geometry_boy.c:297: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00104$
;geometry_boy.c:304: }
	ret
;geometry_boy.c:306: void init_background(char *map, uint16_t map_width)
;	---------------------------------
; Function init_background
; ---------------------------------
_init_background::
;geometry_boy.c:309: count = 0;
	xor	a, a
	ld	hl, #_count
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:310: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00102$:
;geometry_boy.c:312: set_bkg_tiles(0, render_row, 32, 1, map + count);
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
;geometry_boy.c:313: count += map_width;
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
;geometry_boy.c:310: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
;geometry_boy.c:315: }
	ret
;geometry_boy.c:386: void collide(int8_t vel_y)
;	---------------------------------
; Function collide
; ---------------------------------
_collide::
	add	sp, #-30
;geometry_boy.c:391: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#32
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 01014$
	bit	7, d
	jr	NZ, 01015$
	cp	a, a
	jr	01015$
01014$:
	bit	7, d
	jr	Z, 01015$
	scf
01015$:
	ld	a, #0x00
	rla
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl)
	rlca
	and	a,#0x01
	ldhl	sp,	#1
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#29
	ld	(hl), #0x00
00221$:
;geometry_boy.c:393: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a, (#_player_x)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:394: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
	ld	a, (#_player_y)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:391: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#29
;geometry_boy.c:393: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a,(hl)
	cp	a,#0x04
	jp	NC,00169$
	dec	hl
	dec	hl
	and	a, #0x01
	ld	(hl), a
	ld	c, a
	add	a, a
	add	a, c
	add	a, a
	add	a, c
	ldhl	sp,	#28
	add	a, (hl)
;geometry_boy.c:394: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
	ld	(hl+), a
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x00
	rla
	ld	c, a
	add	a, a
	add	a, c
	add	a, a
	add	a, c
	ldhl	sp,	#27
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ld	(hl), a
	ldhl	sp,	#22
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#21
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#22
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl), a
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ldhl	sp,	#28
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
;geometry_boy.c:347: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#22
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#26
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (hl-)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_get_bkg_tile_xy
	pop	hl
	ldhl	sp,	#4
	ld	(hl), e
;geometry_boy.c:396: tile_x = tile_x & 0xF8; // divide by 8 then multiply by 8
	ldhl	sp,	#28
	ld	a, (hl)
	and	a, #0xf8
;geometry_boy.c:397: tile_y = tile_y & 0xF8;
	ld	(hl-), a
	ld	a, (hl-)
	and	a, #0xf8
;geometry_boy.c:403: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ld	(hl), a
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	a, (#_player_x)
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#28
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#23
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:403: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#9
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
;geometry_boy.c:404: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x06
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x06
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	inc	a
	ldhl	sp,	#16
	ld	(hl), a
;geometry_boy.c:405: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x05
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x05
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x02
	ldhl	sp,	#19
	ld	(hl), a
;geometry_boy.c:406: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x04
	ldhl	sp,	#20
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x04
	ldhl	sp,	#21
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x03
	ldhl	sp,	#22
	ld	(hl), a
;geometry_boy.c:410: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	rlca
	and	a,#0x01
	ldhl	sp,	#23
	ld	(hl), a
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#10
	ld	e, l
	ld	d, h
	ldhl	sp,	#27
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01016$
	bit	7, d
	jr	NZ, 01017$
	cp	a, a
	jr	01017$
01016$:
	bit	7, d
	jr	Z, 01017$
	scf
01017$:
	ld	a, #0x00
	rla
	ldhl	sp,	#24
	ld	(hl), a
;geometry_boy.c:399: if (tile == SMALL_SPIKE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x05
	jp	NZ,00167$
;geometry_boy.c:403: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00225$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00225$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00225$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01020$
	bit	7, d
	jr	NZ, 01021$
	cp	a, a
	jr	01021$
01020$:
	bit	7, d
	jr	Z, 01021$
	scf
01021$:
	jr	NC, 00226$
00225$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00227$
00226$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00227$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:403: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:404: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00234$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#10
	ld	e, l
	ld	d, h
	ldhl	sp,	#15
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01022$
	bit	7, d
	jr	NZ, 01023$
	cp	a, a
	jr	01023$
01022$:
	bit	7, d
	jr	Z, 01023$
	scf
01023$:
	jr	C, 00234$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00234$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01024$
	bit	7, d
	jr	NZ, 01025$
	cp	a, a
	jr	01025$
01024$:
	bit	7, d
	jr	Z, 01025$
	scf
01025$:
	jr	NC, 00235$
00234$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00236$
00235$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00236$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:404: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:405: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00243$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#10
	ld	e, l
	ld	d, h
	ldhl	sp,	#18
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01026$
	bit	7, d
	jr	NZ, 01027$
	cp	a, a
	jr	01027$
01026$:
	bit	7, d
	jr	Z, 01027$
	scf
01027$:
	jr	C, 00243$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00243$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01028$
	bit	7, d
	jr	NZ, 01029$
	cp	a, a
	jr	01029$
01028$:
	bit	7, d
	jr	Z, 01029$
	scf
01029$:
	jr	NC, 00244$
00243$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00245$
00244$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00245$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:405: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:406: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00252$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#21
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#10
	ld	e, l
	ld	d, h
	ldhl	sp,	#21
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01030$
	bit	7, d
	jr	NZ, 01031$
	cp	a, a
	jr	01031$
01030$:
	bit	7, d
	jr	Z, 01031$
	scf
01031$:
	jr	C, 00252$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00252$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01032$
	bit	7, d
	jr	NZ, 01033$
	cp	a, a
	jr	01033$
01032$:
	bit	7, d
	jr	Z, 01033$
	scf
01033$:
	jr	NC, 00253$
00252$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00254$
00253$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00254$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:406: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	or	a, a
	jp	Z, 00222$
00101$:
;geometry_boy.c:408: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:409: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:410: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00261$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00261$:
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
;geometry_boy.c:411: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00167$:
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:420: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x03
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x02
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:421: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#5
	ld	a, (hl)
	inc	a
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01034$
	bit	7, d
	jr	NZ, 01035$
	cp	a, a
	jr	01035$
01034$:
	bit	7, d
	jr	Z, 01035$
	scf
01035$:
	ld	a, #0x00
	rla
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:415: else if (tile == BIG_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ,00164$
;geometry_boy.c:418: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	ldhl	sp,	#14
	ld	c, (hl)
	ldhl	sp,	#9
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00262$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00262$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#8
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00262$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01038$
	bit	7, d
	jr	NZ, 01039$
	cp	a, a
	jr	01039$
01038$:
	bit	7, d
	jr	Z, 01039$
	scf
01039$:
	jr	NC, 00263$
00262$:
	xor	a, a
	jr	00264$
00263$:
	ld	a, #0x01
00264$:
;geometry_boy.c:418: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:419: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00271$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01040$
	bit	7, d
	jr	NZ, 01041$
	cp	a, a
	jr	01041$
01040$:
	bit	7, d
	jr	Z, 01041$
	scf
01041$:
	jr	C, 00271$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00271$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#20
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01042$
	bit	7, d
	jr	NZ, 01043$
	cp	a, a
	jr	01043$
01042$:
	bit	7, d
	jr	Z, 01043$
	scf
01043$:
	jr	NC, 00272$
00271$:
	xor	a, a
	jr	00273$
00272$:
	ld	a, #0x01
00273$:
;geometry_boy.c:419: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:420: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00280$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01044$
	bit	7, d
	jr	NZ, 01045$
	cp	a, a
	jr	01045$
01044$:
	bit	7, d
	jr	Z, 01045$
	scf
01045$:
	jr	C, 00280$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#25
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00280$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01046$
	bit	7, d
	jr	NZ, 01047$
	cp	a, a
	jr	01047$
01046$:
	bit	7, d
	jr	Z, 01047$
	scf
01047$:
	jr	NC, 00281$
00280$:
	xor	a, a
	jr	00282$
00281$:
	ld	a, #0x01
00282$:
;geometry_boy.c:420: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:421: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00289$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01048$
	bit	7, d
	jr	NZ, 01049$
	cp	a, a
	jr	01049$
01048$:
	bit	7, d
	jr	Z, 01049$
	scf
01049$:
	jr	C, 00289$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00289$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00290$
00289$:
	xor	a, a
	jr	00291$
00290$:
	ld	a, #0x01
00291$:
;geometry_boy.c:421: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	or	a, a
	jp	Z, 00222$
00106$:
;geometry_boy.c:423: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:424: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:425: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00298$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00298$:
	ldhl	sp,	#28
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
	ld	(hl), a
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_x),a
;geometry_boy.c:426: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00164$:
;geometry_boy.c:430: else if (tile == INVERTED_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0a
	jp	NZ,00161$
;geometry_boy.c:433: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	ldhl	sp,	#27
	ld	c, (hl)
	ldhl	sp,	#9
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00299$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00299$
;geometry_boy.c:382: player_y <= y_bot &&
	ld	a, c
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00299$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00300$
00299$:
	ld	c, #0x00
	jr	00301$
00300$:
	ld	c, #0x01
00301$:
	ld	a, c
;geometry_boy.c:433: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:434: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00308$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01052$
	bit	7, d
	jr	NZ, 01053$
	cp	a, a
	jr	01053$
01052$:
	bit	7, d
	jr	Z, 01053$
	scf
01053$:
	jr	C, 00308$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00308$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01054$
	bit	7, d
	jr	NZ, 01055$
	cp	a, a
	jr	01055$
01054$:
	bit	7, d
	jr	Z, 01055$
	scf
01055$:
	jr	NC, 00309$
00308$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00310$
00309$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00310$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:434: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:435: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00317$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01056$
	bit	7, d
	jr	NZ, 01057$
	cp	a, a
	jr	01057$
01056$:
	bit	7, d
	jr	Z, 01057$
	scf
01057$:
	jr	C, 00317$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00317$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01058$
	bit	7, d
	jr	NZ, 01059$
	cp	a, a
	jr	01059$
01058$:
	bit	7, d
	jr	Z, 01059$
	scf
01059$:
	jr	NC, 00318$
00317$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00319$
00318$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00319$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:435: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:436: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00326$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01060$
	bit	7, d
	jr	NZ, 01061$
	cp	a, a
	jr	01061$
01060$:
	bit	7, d
	jr	Z, 01061$
	scf
01061$:
	jr	C, 00326$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00326$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01062$
	bit	7, d
	jr	NZ, 01063$
	cp	a, a
	jr	01063$
01062$:
	bit	7, d
	jr	Z, 01063$
	scf
01063$:
	jr	NC, 00327$
00326$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00328$
00327$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00328$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:436: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
	or	a, a
	jp	Z, 00222$
00111$:
;geometry_boy.c:438: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:439: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:440: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00335$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00335$:
	ldhl	sp,	#28
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
	ld	(hl), a
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_x),a
;geometry_boy.c:441: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00161$:
;geometry_boy.c:445: else if (tile == BACK_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jp	NZ,00158$
;geometry_boy.c:448: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	ldhl	sp,	#16
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00336$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00336$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#20
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00336$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01066$
	bit	7, d
	jr	NZ, 01067$
	cp	a, a
	jr	01067$
01066$:
	bit	7, d
	jr	Z, 01067$
	scf
01067$:
	jr	NC, 00337$
00336$:
	xor	a, a
	jr	00338$
00337$:
	ld	a, #0x01
00338$:
;geometry_boy.c:448: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:449: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#22
	ld	c, (hl)
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00345$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01068$
	bit	7, d
	jr	NZ, 01069$
	cp	a, a
	jr	01069$
01068$:
	bit	7, d
	jr	Z, 01069$
	scf
01069$:
	jr	C, 00345$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#25
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00345$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01070$
	bit	7, d
	jr	NZ, 01071$
	cp	a, a
	jr	01071$
01070$:
	bit	7, d
	jr	Z, 01071$
	scf
01071$:
	jr	NC, 00346$
00345$:
	ldhl	sp,	#26
	ld	(hl), #0x00
	jr	00347$
00346$:
	ldhl	sp,	#26
	ld	(hl), #0x01
00347$:
	ldhl	sp,	#26
	ld	a, (hl)
;geometry_boy.c:449: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:450: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#18
	ld	c, (hl)
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00354$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01072$
	bit	7, d
	jr	NZ, 01073$
	cp	a, a
	jr	01073$
01072$:
	bit	7, d
	jr	Z, 01073$
	scf
01073$:
	jr	C, 00354$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00354$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01074$
	bit	7, d
	jr	NZ, 01075$
	cp	a, a
	jr	01075$
01074$:
	bit	7, d
	jr	Z, 01075$
	scf
01075$:
	jr	NC, 00355$
00354$:
	ldhl	sp,	#27
	ld	(hl), #0x00
	jr	00356$
00355$:
	ldhl	sp,	#27
	ld	(hl), #0x01
00356$:
	ldhl	sp,	#27
	ld	a, (hl)
;geometry_boy.c:450: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
	or	a, a
	jr	NZ, 00116$
;geometry_boy.c:451: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#9
	ld	b, (hl)
	ldhl	sp,	#15
	ld	c, (hl)
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00363$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01076$
	bit	7, d
	jr	NZ, 01077$
	cp	a, a
	jr	01077$
01076$:
	bit	7, d
	jr	Z, 01077$
	scf
01077$:
	jr	C, 00363$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00363$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00364$
00363$:
	ld	c, #0x00
	jr	00365$
00364$:
	ld	c, #0x01
00365$:
	ld	a, c
;geometry_boy.c:451: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	or	a, a
	jp	Z, 00222$
00116$:
;geometry_boy.c:453: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:454: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:455: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00372$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00372$:
	ldhl	sp,	#28
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
	ld	(hl), a
	add	a, a
	add	a, a
	add	a, a
	ld	(#_player_x),a
;geometry_boy.c:456: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00158$:
;geometry_boy.c:470: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	a, (#_player_y)
;geometry_boy.c:477: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ld	hl, #_player_x
	ld	c, (hl)
;geometry_boy.c:470: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	and	a, #0xf8
;geometry_boy.c:477: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	push	af
	ld	a, c
	and	a, #0xf8
	ldhl	sp,	#29
;geometry_boy.c:470: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	(hl+), a
	pop	af
	add	a, #0x08
	ld	(hl), a
;geometry_boy.c:460: else if (tile == BLACK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00155$
;geometry_boy.c:462: if (vel_y > 0)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:464: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ld	hl, #_player_y
	ld	a, (hl)
	and	a, #0xf8
	ld	(hl), a
;geometry_boy.c:465: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:466: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00222$
00125$:
;geometry_boy.c:468: else if (vel_y < 0)
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:470: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00222$
00122$:
;geometry_boy.c:475: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:476: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:477: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:478: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00155$:
;geometry_boy.c:482: else if (tile == HALF_BLOCK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jp	NZ,00152$
;geometry_boy.c:484: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#9
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00373$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00373$
;geometry_boy.c:382: player_y <= y_bot &&
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00373$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#22
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#12
	ld	e, l
	ld	d, h
	ldhl	sp,	#22
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01082$
	bit	7, d
	jr	NZ, 01083$
	cp	a, a
	jr	01083$
01082$:
	bit	7, d
	jr	Z, 01083$
	scf
01083$:
	jr	NC, 00374$
00373$:
	ld	c, #0x00
	jr	00375$
00374$:
	ld	c, #0x01
00375$:
	ld	a, c
;geometry_boy.c:484: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	or	a, a
	jp	Z, 00222$
;geometry_boy.c:486: if (vel_y > 0)
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:488: player_y = tile_y - 4;
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0xfc
	ld	(#_player_y),a
;geometry_boy.c:489: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:490: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00222$
00131$:
;geometry_boy.c:492: else if (vel_y < 0)
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:494: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00222$
00128$:
;geometry_boy.c:499: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:500: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:501: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:502: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00222$
00152$:
;geometry_boy.c:507: else if (tile == JUMP_TILE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00149$
;geometry_boy.c:509: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#9
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00382$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00382$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00382$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01086$
	bit	7, d
	jr	NZ, 01087$
	cp	a, a
	jr	01087$
01086$:
	bit	7, d
	jr	Z, 01087$
	scf
01087$:
	jr	NC, 00383$
00382$:
	ld	c, #0x00
	jr	00384$
00383$:
	ld	c, #0x01
00384$:
	ld	a, c
;geometry_boy.c:509: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	or	a, a
	jp	Z, 00222$
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00222$
;geometry_boy.c:511: player_dy = -PLAYER_SUPER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xf7
	jp	00222$
00149$:
;geometry_boy.c:514: else if (tile == JUMP_CIRCLE_TILE) // jump circle , hitbox is 4x4 square in center
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00146$
;geometry_boy.c:516: if (jpad == J_UP && vel_y == 0)
	ld	a, (#_jpad)
	sub	a, #0x04
	jp	NZ,00222$
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00222$
;geometry_boy.c:518: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00391$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01092$
	bit	7, d
	jr	NZ, 01093$
	cp	a, a
	jr	01093$
01092$:
	bit	7, d
	jr	Z, 01093$
	scf
01093$:
	jr	C, 00391$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00391$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#12
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01094$
	bit	7, d
	jr	NZ, 01095$
	cp	a, a
	jr	01095$
01094$:
	bit	7, d
	jr	Z, 01095$
	scf
01095$:
	jr	NC, 00392$
00391$:
	xor	a, a
	jr	00393$
00392$:
	ld	a, #0x01
00393$:
;geometry_boy.c:518: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	or	a, a
	jr	Z, 00222$
;geometry_boy.c:520: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
	jr	00222$
00146$:
;geometry_boy.c:524: else if (tile == WIN_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00222$
;geometry_boy.c:525: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:526: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:527: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00400$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00400$:
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
;geometry_boy.c:528: win = 1;
	ld	hl, #_win
	ld	(hl), #0x01
00222$:
;geometry_boy.c:391: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#29
	inc	(hl)
	jp	00221$
00169$:
;geometry_boy.c:532: if (vel_y == 0)
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00223$
;geometry_boy.c:534: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x08
	ld	c, a
	ldhl	sp,	#28
	ld	a, (hl+)
	add	a, #0x07
	ld	(hl), a
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ldhl	sp,	#24
	ld	a, c
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#28
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#26
	add	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:347: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#26
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:534: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jp	Z,00178$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#27
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ld	(hl-), a
	dec	hl
	ld	a, c
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#29
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:347: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#26
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:534: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jr	NZ, 00179$
00178$:
;geometry_boy.c:536: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00223$
00179$:
;geometry_boy.c:541: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	ld	a, (#_player_y)
	add	a, #0x08
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#27
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#29
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:347: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#26
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:541: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	Z,00175$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#27
;geometry_boy.c:352: return (y_px - YOFF) >> 3;
	ld	(hl-), a
	dec	hl
	ld	a, c
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#29
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:347: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#26
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	sra	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:358: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:541: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	NZ,00223$
00175$:
;geometry_boy.c:543: tile_x = (player_x)&0xF8;
	ld	a, (#_player_x)
	and	a, #0xf8
	ld	e, a
;geometry_boy.c:544: tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
	ld	a, (#_player_y)
	add	a, #0x08
	and	a, #0xf8
;geometry_boy.c:545: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	c, a
	add	a, #0x07
	ldhl	sp,	#22
	ld	(hl), a
	ld	a, (hl+)
	ld	(hl+), a
	ld	a, c
	add	a, #0x03
	ld	(hl), a
	ld	a, (hl+)
	ld	(hl), a
	ld	a, e
	add	a, #0x07
	ld	d, a
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#26
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #0x0007
	add	hl, bc
	ld	c, l
	ld	b, h
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	push	de
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#30
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#29
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00401$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	e, h
	ld	d, b
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	bit	7, e
	jr	Z, 01104$
	bit	7, d
	jr	NZ, 01105$
	cp	a, a
	jr	01105$
01104$:
	bit	7, d
	jr	Z, 01105$
	scf
01105$:
	jr	C, 00401$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#23
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00401$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	a, (hl+)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#28
	ld	e, l
	ld	d, h
	ldhl	sp,	#26
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01106$
	bit	7, d
	jr	NZ, 01107$
	cp	a, a
	jr	01107$
01106$:
	bit	7, d
	jr	Z, 01107$
	scf
01107$:
	jr	NC, 00402$
00401$:
	xor	a, a
	jr	00403$
00402$:
	ld	a, #0x01
00403$:
;geometry_boy.c:545: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00173$
;geometry_boy.c:547: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jr	00223$
00173$:
;geometry_boy.c:551: tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
	ld	a, (#_player_x)
	add	a, #0x07
	and	a, #0xf8
;geometry_boy.c:552: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	e, a
	add	a, #0x07
	ld	d, a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;geometry_boy.c:380: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00410$
;geometry_boy.c:381: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	e, h
	ld	d, b
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	bit	7, e
	jr	Z, 01108$
	bit	7, d
	jr	NZ, 01109$
	cp	a, a
	jr	01109$
01108$:
	bit	7, d
	jr	Z, 01109$
	scf
01109$:
	jr	C, 00410$
;geometry_boy.c:382: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00410$
;geometry_boy.c:383: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	a, (hl+)
	inc	hl
	ld	c, a
	ld	b, #0x00
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01110$
	bit	7, d
	jr	NZ, 01111$
	cp	a, a
	jr	01111$
01110$:
	bit	7, d
	jr	Z, 01111$
	scf
01111$:
	jr	NC, 00411$
00410$:
	xor	a, a
	jr	00412$
00411$:
	ld	a, #0x01
00412$:
;geometry_boy.c:552: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00223$
;geometry_boy.c:554: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
00223$:
;geometry_boy.c:560: }
	add	sp, #30
	ret
;geometry_boy.c:562: void tick_player()
;	---------------------------------
; Function tick_player
; ---------------------------------
_tick_player::
;geometry_boy.c:564: if (jpad == J_UP)
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00104$
;geometry_boy.c:566: if (on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:568: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
00104$:
;geometry_boy.c:571: if (!on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	NZ, 00108$
;geometry_boy.c:573: player_dy += GRAVITY;
	ld	hl, #_player_dy
	inc	(hl)
;geometry_boy.c:574: if (player_dy > MAX_FALL_SPEED)
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
;geometry_boy.c:575: player_dy = MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x07
00108$:
;geometry_boy.c:578: collide(0);
	xor	a, a
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:580: player_y += player_dy;
	ld	a, (#_player_y)
	ld	hl, #_player_dy
	add	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:583: on_ground = 0;
	ld	hl, #_on_ground
	ld	(hl), #0x00
;geometry_boy.c:585: collide(player_dy);
	ld	a, (#_player_dy)
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:586: }
	ret
;geometry_boy.c:588: void render_player()
;	---------------------------------
; Function render_player
; ---------------------------------
_render_player::
;geometry_boy.c:590: move_sprite(0, player_x, player_y);
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
;geometry_boy.c:590: move_sprite(0, player_x, player_y);
;geometry_boy.c:591: }
	ret
;geometry_boy.c:593: void initialize_player()
;	---------------------------------
; Function initialize_player
; ---------------------------------
_initialize_player::
;geometry_boy.c:595: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:596: set_sprite_data(0, 1, players + (player_sprite_num << 4)); // << 4 is the same as *16
	ld	bc, #_players+0
	ld	hl, #_player_sprite_num
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	push	hl
	xor	a, a
	inc	a
	push	af
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:597: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;geometry_boy.c:598: set_sprite_tile(0, 0);
;geometry_boy.c:599: }
	ret
;geometry_boy.c:601: screen_t game()
;	---------------------------------
; Function game
; ---------------------------------
_game::
	add	sp, #-6
;geometry_boy.c:603: STAT_REG |= 0x40; // enable LYC=LY interrupt
	ldh	a, (_STAT_REG + 0)
	or	a, #0x40
	ldh	(_STAT_REG + 0), a
;geometry_boy.c:604: LYC_REG = 16;     // the scanline on which to trigger
	ld	a, #0x10
	ldh	(_LYC_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:606: add_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_add_LCD
	pop	hl
;geometry_boy.c:607: add_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:609: set_interrupts(LCD_IFLAG | VBL_IFLAG);
	ld	a, #0x03
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:611: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:613: initialize_player();
	call	_initialize_player
;geometry_boy.c:614: render_player(); // render at initial position
	call	_render_player
;geometry_boy.c:615: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:167: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xd00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:168: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:169: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:170: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x131
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:171: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:172: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:173: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x933
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:619: current_attempts = 0;
	xor	a, a
	ld	hl, #_current_attempts
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:209: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00141$:
;geometry_boy.c:211: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00139$:
;geometry_boy.c:213: set_win_tile_xy(render_col, render_row, BLACK_TILE);
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, (#_render_row)
	ld	h, a
	ld	a, (#_render_col)
	ld	l, a
	push	hl
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:211: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00139$
;geometry_boy.c:209: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00141$
;geometry_boy.c:216: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00143$:
;geometry_boy.c:218: set_win_tile_xy(render_col, 0, LETTER_TILES + (attempts_title[render_col] - 65));
	ld	a, #<(_attempts_title)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_title)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:216: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jr	C, 00143$
;geometry_boy.c:220: set_win_tile_xy(7, 0, COLON_TILE); // colon
	ld	a, #0x31
	push	af
	inc	sp
	ld	hl, #0x07
	push	hl
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:221: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x08
00145$:
;geometry_boy.c:223: set_win_tile_xy(render_col, 0, NUMBER_TILES);
	ld	a, #0x0d
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (#_render_col)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:221: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0b
	jr	C, 00145$
;geometry_boy.c:225: old_px_progress_bar = 0;
	xor	a, a
	ld	hl, #_old_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:226: px_progress_bar = 0;
	xor	a, a
	ld	hl, #_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:622: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:623: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:625: SWITCH_ROM_MBC1(level_banks[level_ind]);
	ld	a, #<(_level_banks)
	ld	hl, #_level_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_banks)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ldh	(__current_bank + 0), a
	ld	(#0x2000),a
;geometry_boy.c:626: init_background(level_maps[level_ind], level_widths[level_ind]);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_level_widths
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:627: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:629: while (1)
00119$:
;geometry_boy.c:631: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00102$
;geometry_boy.c:633: wait_vbl_done();
	call	_wait_vbl_done
00102$:
;geometry_boy.c:635: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:637: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:638: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:640: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ld	hl, #_jpad
	ld	c, (hl)
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	sub	a, #0x20
	jr	NZ, 00151$
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00152$
00151$:
	ld	c, #0x00
	jr	00153$
00152$:
	ld	c, #0x01
00153$:
;geometry_boy.c:640: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jp	Z, 00106$
;geometry_boy.c:642: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:643: *(attempts[level_ind]) = *(attempts[level_ind])+1;
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_attempts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	ld	a,	(hl-)
;	spillPairReg hl
	ld	e, (hl)
	ld	d, a
	inc	de
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;geometry_boy.c:644: if (background_x_shift + player_x > *(px_progress[level_ind]))
	ld	hl, #_player_x
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
	ld	b, h
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_px_progress
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#2
	ld	e, l
	ld	d, h
	ldhl	sp,	#4
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	NC, 00104$
;geometry_boy.c:646: *(px_progress[level_ind]) = background_x_shift + player_x;
	pop	de
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
00104$:
;geometry_boy.c:648: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:650: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:651: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:653: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:654: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:655: render_player();
	call	_render_player
;geometry_boy.c:656: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:657: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:658: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00149$
00106$:
;geometry_boy.c:661: tick_player();
	call	_tick_player
;geometry_boy.c:662: render_player();
	call	_render_player
;geometry_boy.c:664: SWITCH_ROM_MBC1(level_banks[level_ind]);
	ld	a, #<(_level_banks)
	ld	hl, #_level_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_banks)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ldh	(__current_bank + 0), a
	ld	(#0x2000),a
;geometry_boy.c:665: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_level_widths
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
;geometry_boy.c:666: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:668: update_HUD_bar();
	call	_update_HUD_bar
;geometry_boy.c:670: if (lose)
	ld	a, (#_lose)
	or	a, a
	jp	Z, 00114$
;geometry_boy.c:672: SWITCH_ROM_MBC1(level_banks[level_ind]);
	ld	a, #<(_level_banks)
	ld	hl, #_level_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_banks)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ldh	(__current_bank + 0), a
	ld	(#0x2000),a
;geometry_boy.c:673: init_background(level_maps[level_ind], level_widths[level_ind]);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_level_widths
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:674: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:675: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:676: *(attempts[level_ind]) = *(attempts[level_ind])+1;
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_attempts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	ld	a,	(hl-)
;	spillPairReg hl
	ld	e, (hl)
	ld	d, a
	inc	de
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;geometry_boy.c:677: if (background_x_shift + player_x > *(px_progress[level_ind]))
	ld	hl, #_player_x
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
	ld	b, h
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_px_progress
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jr	NC, 00108$
;geometry_boy.c:679: *(px_progress[level_ind]) = background_x_shift + player_x;
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00108$:
;geometry_boy.c:681: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:683: current_attempts++;
	ld	hl, #_current_attempts
	inc	(hl)
	jr	NZ, 00258$
	inc	hl
	inc	(hl)
00258$:
;geometry_boy.c:231: uint16_t temp = current_attempts;
	ld	hl, #_current_attempts
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
;geometry_boy.c:232: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	ld	(hl), #0x0a
00147$:
;geometry_boy.c:234: set_win_tile_xy(render_col, 0, temp % 10 + NUMBER_TILES);
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0d
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (#_render_col)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:235: temp = temp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ld	c, e
	ld	b, d
;geometry_boy.c:232: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00147$
;geometry_boy.c:685: update_HUD_bar();
	call	_update_HUD_bar
;geometry_boy.c:686: wait_vbl_done();
	call	_wait_vbl_done
	jp	00115$
00114$:
;geometry_boy.c:687: } else if (win){
	ld	hl, #_win
	ld	a, (hl)
	or	a, a
	jp	Z, 00115$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:689: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:690: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:692: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:693: *(attempts[level_ind]) = *(attempts[level_ind])+1;
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_attempts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	ld	a,	(hl-)
;	spillPairReg hl
	ld	e, (hl)
	ld	d, a
	inc	de
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;geometry_boy.c:694: if (background_x_shift + player_x > *(px_progress[level_ind]))
	ld	hl, #_player_x
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
	ld	b, h
	ld	hl, #_level_ind
	ld	e, (hl)
	ld	d, #0x00
	sla	e
	rl	d
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ld	de, #_px_progress
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jr	NC, 00110$
;geometry_boy.c:696: *(px_progress[level_ind]) = (level_widths[level_ind] - LEVEL_END_OFFSET) << 3;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_level_widths
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	add	a, #0xec
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	adc	a, #0xff
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00110$:
;geometry_boy.c:698: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:699: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:700: render_player();
	call	_render_player
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:702: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:703: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:704: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:705: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00149$
00115$:
;geometry_boy.c:708: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:709: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00117$
;geometry_boy.c:711: parallax_tile_ind = 0;
	ld	(hl), #0x00
00117$:
;geometry_boy.c:713: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:714: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind);     // load tiles into VRAM
	ld	a, #<(_parallax_tileset_v2)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_parallax_tileset_v2)
	adc	a, #0x00
	ld	b, a
	push	bc
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:715: set_bkg_data(0x5, 1, small_spike_parallax + parallax_tile_ind);  // load tiles into VRAM
	ld	a, #<(_small_spike_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_small_spike_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x105
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:716: set_bkg_data(0x4, 1, big_spike_parallax + parallax_tile_ind);    // load tiles into VRAM
	ld	a, #<(_big_spike_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_big_spike_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x104
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:717: set_bkg_data(0x08, 1, half_block_parallax + parallax_tile_ind);  // load tiles into VRAM
	ld	a, #<(_half_block_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_half_block_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x108
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:718: set_bkg_data(0x06, 1, jump_circle_parallax + parallax_tile_ind); // load tiles into VRAM
	ld	a, #<(_jump_circle_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_jump_circle_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x106
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:719: set_bkg_data(0x07, 1, jump_tile_parallax + parallax_tile_ind);   // load tiles into VRAM
	ld	a, #<(_jump_tile_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_jump_tile_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x107
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:720: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:722: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:723: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:724: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
;geometry_boy.c:725: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:726: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
	jp	00119$
00149$:
;geometry_boy.c:728: }
	add	sp, #6
	ret
;geometry_boy.c:757: screen_t title()
;	---------------------------------
; Function title
; ---------------------------------
_title::
	add	sp, #-9
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:760: add_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:762: set_interrupts(VBL_IFLAG);
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:763: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:167: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xd00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:168: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:169: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:170: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x131
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:171: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:172: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:173: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x933
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:768: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:769: init_background(title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:770: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:773: if (title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	Z, 00109$
;geometry_boy.c:775: for (int i = 0; i < 11; i++)
	xor	a, a
	ldhl	sp,	#7
	ld	(hl+), a
	ld	(hl), a
00197$:
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, #0x0b
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	bit	7,a
	jr	Z, 00407$
	bit	7, d
	jr	NZ, 00408$
	cp	a, a
	jr	00408$
00407$:
	bit	7, d
	jr	Z, 00408$
	scf
00408$:
	jp	NC, 00104$
;geometry_boy.c:777: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:778: set_sprite_data(TITLE_OAM + i, 1, nima + 16 * (13 + game_title[i] - 65)); // load tiles into VRAM
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_game_title
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl+), a
	rlca
	sbc	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xffcc
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	a, #0x04
00409$:
	ldhl	sp,	#3
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00409$
	ld	de, #_nima
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (hl+)
	add	a, #0x0b
	ld	(hl), a
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:779: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:780: set_sprite_tile(TITLE_OAM + i, TITLE_OAM + i);
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00410$:
	ldhl	sp,	#5
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00410$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:781: if (i > 7)
	ldhl	sp,	#7
	ld	a, #0x07
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00411$
	bit	7, d
	jr	NZ, 00412$
	cp	a, a
	jr	00412$
00411$:
	bit	7, d
	jr	Z, 00412$
	scf
00412$:
	jr	NC, 00102$
;geometry_boy.c:783: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0xf8
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	ld	(hl), a
	ld	a, (hl)
	add	a, #0x4c
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00413$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00413$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x2a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;geometry_boy.c:783: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00198$
00102$:
;geometry_boy.c:787: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	add	a, #0x38
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00414$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00414$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x20
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;geometry_boy.c:787: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
00198$:
;geometry_boy.c:775: for (int i = 0; i < 11; i++)
	ldhl	sp,	#7
	inc	(hl)
	jp	NZ,00197$
	inc	hl
	inc	(hl)
	jp	00197$
00104$:
;geometry_boy.c:790: for (uint8_t i = 0; i < 6; i++)
	ld	c, #0x00
00200$:
;geometry_boy.c:793: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00107$
	sub	a, #0x05
	jr	NC, 00106$
;geometry_boy.c:795: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:796: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
	ld	hl, #_start_text
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #0xffcc
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_aero
	add	hl, de
	ld	a, c
	add	a, #0x16
	ld	b, a
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:797: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:798: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
	ld	a, b
	ldhl	sp,	#8
	ld	(hl), a
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
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:799: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x44
	ld	d, a
	ld	e, b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	pop	de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:799: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00106$:
;geometry_boy.c:801: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:802: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
	ld	hl, #_player_text
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #0xffcc
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_aero
	add	hl, de
	ld	a, c
	add	a, #0x1b
	ld	b, a
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:803: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:804: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
	ld	d, b
	ld	e, b
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	pop	de
	ld	(hl), d
;geometry_boy.c:805: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x40
	ld	e, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	pop	de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:790: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00200$
00107$:
;geometry_boy.c:808: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+84
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (bc)
	add	a, #0xfe
	ld	(bc), a
	inc	bc
	ld	a, (bc)
	ld	(bc), a
;geometry_boy.c:812: scroll_sprite(TITLE_OAM + 10, 0, -2);
00109$:
;geometry_boy.c:815: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:816: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:818: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:820: uint8_t title_index = 0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;geometry_boy.c:822: while (1)
00155$:
;geometry_boy.c:824: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:826: wait_vbl_done();
	call	_wait_vbl_done
00111$:
;geometry_boy.c:828: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:830: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:831: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
;geometry_boy.c:832: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:834: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:835: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00113$
;geometry_boy.c:837: parallax_tile_ind = 0;
	ld	(hl), #0x00
00113$:
;geometry_boy.c:839: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:840: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind); // load tiles into VRAM
	ld	a, #<(_parallax_tileset_v2)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_parallax_tileset_v2)
	adc	a, #0x00
	ld	b, a
	push	bc
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:841: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:850: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#5
	ld	a, (hl-)
	ld	(hl), a
;geometry_boy.c:845: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:850: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:843: if (!title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	NZ, 00152$
;geometry_boy.c:845: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00153$
;geometry_boy.c:847: if (title_index < 11)
	dec	hl
	ld	a, (hl)
	sub	a, #0x0b
	jp	NC, 00238$
;geometry_boy.c:849: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:850: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ld	de, #_game_title
	ldhl	sp,	#5
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, #0xffcc
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_nima
	add	hl, de
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#11
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:851: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:852: set_sprite_tile(TITLE_OAM + title_index, TITLE_OAM + title_index);
	ldhl	sp,	#8
	ld	c, (hl)
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, (hl)
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
;geometry_boy.c:853: if (title_index > 7)
	ld	a, #0x07
	ldhl	sp,	#5
	sub	a, (hl)
	jr	NC, 00115$
;geometry_boy.c:855: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
	dec	hl
	ld	a, (hl)
	add	a, #0xf8
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x4c
	ld	c, a
	ldhl	sp,	#8
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x2a
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:855: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00116$
00115$:
;geometry_boy.c:859: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x38
	ld	c, a
	ldhl	sp,	#8
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x20
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:859: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
00116$:
;geometry_boy.c:861: title_index = title_index + 1;
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	jp	00153$
;geometry_boy.c:865: for (uint8_t i = 0; i < 6; i++)
00238$:
	ld	c, #0x00
00203$:
;geometry_boy.c:868: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00119$
	sub	a, #0x05
	jr	NC, 00118$
;geometry_boy.c:870: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:871: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
	ld	hl, #_start_text
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #0xffcc
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_aero
	add	hl, de
	ld	a, c
	add	a, #0x16
	ld	b, a
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:872: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:873: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
	ld	d, b
	ld	e, b
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	pop	de
	ld	(hl), d
;geometry_boy.c:874: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x44
	ld	d, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	a, #<(_shadow_OAM)
	add	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, #>(_shadow_OAM)
	adc	a, h
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:874: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00118$:
;geometry_boy.c:876: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:877: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
	ld	hl, #_player_text
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #0xffcc
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_aero
	add	hl, de
	ld	a, c
	add	a, #0x1b
	ld	b, a
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:878: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:879: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
	ld	d, b
	ld	e, b
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	pop	de
	ld	(hl), d
;geometry_boy.c:880: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x40
	ld	e, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, b
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	pop	de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:865: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00203$
00119$:
;geometry_boy.c:883: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:888: title_loaded = 1;
	ld	hl, #_title_loaded
	ld	(hl), #0x01
;geometry_boy.c:889: title_index = 0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+84
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (bc)
	add	a, #0xfe
	ld	(bc), a
	inc	bc
	ld	a, (bc)
	ld	(bc), a
;geometry_boy.c:890: scroll_sprite(TITLE_OAM + 10, 0, -2);
	jp	00153$
00152$:
;geometry_boy.c:897: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00129$
;geometry_boy.c:899: if (title_index == 0)
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00126$
;geometry_boy.c:901: scroll_sprite(TITLE_OAM + title_index, 0, -2);
	ldhl	sp,	#8
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
	ld	bc, #_shadow_OAM+0
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (hl)
	add	a, #0xfe
	ld	(hl+), a
	ld	a, (hl)
	ld	(hl), a
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+84
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (bc)
	add	a, #0x02
	ld	(bc), a
	inc	bc
	ld	a, (bc)
	ld	(bc), a
;geometry_boy.c:902: scroll_sprite(TITLE_OAM + 10, 0, +2);
	jr	00127$
00126$:
;geometry_boy.c:906: scroll_sprite(TITLE_OAM + title_index, 0, -2);
	ldhl	sp,	#8
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
	ld	bc, #_shadow_OAM+0
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (hl)
	add	a, #0xfe
	ld	(hl+), a
	ld	a, (hl)
	ld	(hl), a
;geometry_boy.c:907: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0a
;../gbdk/include/gb/gb.h:1415: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, a
	ld	bc, #_shadow_OAM+0
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
;../gbdk/include/gb/gb.h:1416: itm->y+=y, itm->x+=x;
	ld	a, (hl)
	add	a, #0x02
	ld	(hl+), a
	ld	a, (hl)
	ld	(hl), a
;geometry_boy.c:907: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
00127$:
;geometry_boy.c:909: title_index = (title_index + 1) % 11;
	ldhl	sp,	#5
	ld	c, (hl)
	ld	b, #0x00
	inc	bc
	ld	de, #0x000b
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	ldhl	sp,	#5
	ld	(hl), e
00129$:
;geometry_boy.c:912: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:913: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:915: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#6
	ld	(hl), a
;geometry_boy.c:912: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#7
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00214$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00215$
00214$:
	ldhl	sp,	#8
	ld	(hl), #0x00
	jr	00216$
00215$:
	ldhl	sp,	#8
	ld	(hl), #0x01
00216$:
	ldhl	sp,	#8
	ld	a, (hl)
;geometry_boy.c:915: if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00133$
;geometry_boy.c:917: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
	jr	00134$
00133$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00217$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00218$
00217$:
	xor	a, a
	jr	00219$
00218$:
	ld	a, #0x01
00219$:
;geometry_boy.c:919: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00134$
;geometry_boy.c:921: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
00134$:
;geometry_boy.c:924: if (cursor_title_position != cursor_title_position_old)
	ld	a, (#_cursor_title_position)
	ld	hl, #_cursor_title_position_old
	sub	a, (hl)
	jr	Z, 00149$
;geometry_boy.c:926: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00138$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:928: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
	jr	00139$
00138$:
;geometry_boy.c:930: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00139$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:932: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
00139$:
;geometry_boy.c:934: cursor_title_position_old = cursor_title_position;
	ld	a, (#_cursor_title_position)
	ld	(#_cursor_title_position_old),a
	jp	00153$
00149$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00220$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00221$
00220$:
	xor	a, a
	jr	00222$
00221$:
	ld	a, #0x01
00222$:
;geometry_boy.c:937: else if (debounce_input(J_SELECT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00153$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:321: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00207$:
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00205$:
;geometry_boy.c:326: set_bkg_tile_xy(render_col, render_row, 0);
	xor	a, a
	push	af
	inc	sp
	ld	a, (#_render_row)
	ld	h, a
	ld	a, (#_render_col)
	ld	l, a
	push	hl
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00205$
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00207$
;geometry_boy.c:941: remove_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:943: for (uint8_t i = 0; i < 40; i++)
	ld	c, #0x00
00210$:
	ld	a, c
	sub	a, #0x28
	jr	NC, 00140$
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
;geometry_boy.c:943: for (uint8_t i = 0; i < 40; i++)
	inc	c
	jr	00210$
00140$:
;geometry_boy.c:947: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00144$
;geometry_boy.c:949: cursor_title_position_old = 1; // force a change the next time title runs
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x01
;geometry_boy.c:950: return LEVEL_SELECT;
	ld	e, #0x02
	jr	00212$
00144$:
;geometry_boy.c:952: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00153$
;geometry_boy.c:954: cursor_title_position_old = 0;
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
;geometry_boy.c:955: return PLAYER_SELECT;
	ld	e, #0x03
	jr	00212$
00153$:
;geometry_boy.c:960: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:962: delay(LOOP_DELAY);    // LOOP_DELAY
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00155$
00212$:
;geometry_boy.c:964: }
	add	sp, #9
	ret
_game_title:
	.db #0x47	;  71	'G'
	.db #0x45	;  69	'E'
	.db #0x4f	;  79	'O'
	.db #0x4d	;  77	'M'
	.db #0x45	;  69	'E'
	.db #0x54	;  84	'T'
	.db #0x52	;  82	'R'
	.db #0x59	;  89	'Y'
	.db #0x42	;  66	'B'
	.db #0x4f	;  79	'O'
	.db #0x59	;  89	'Y'
_start_text:
	.db #0x53	;  83	'S'
	.db #0x54	;  84	'T'
	.db #0x41	;  65	'A'
	.db #0x52	;  82	'R'
	.db #0x54	;  84	'T'
_player_text:
	.db #0x50	;  80	'P'
	.db #0x4c	;  76	'L'
	.db #0x41	;  65	'A'
	.db #0x59	;  89	'Y'
	.db #0x45	;  69	'E'
	.db #0x52	;  82	'R'
;geometry_boy.c:971: screen_t player_select()
;	---------------------------------
; Function player_select
; ---------------------------------
_player_select::
	add	sp, #-9
;geometry_boy.c:974: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:321: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00153$:
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00151$:
;geometry_boy.c:326: set_bkg_tile_xy(render_col, render_row, 0);
	xor	a, a
	push	af
	inc	sp
	ld	a, (#_render_row)
	ld	h, a
	ld	a, (#_render_col)
	ld	l, a
	push	hl
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00151$
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00153$
;geometry_boy.c:979: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)DARK_CURSOR); // Load into VRAM
	ld	de, #(_aero_cursors + 16)
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	hl, #_player_sprite_num
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	c, l
	ld	b, h
	bit	7, h
	jr	Z, 00163$
	ld	c, l
	ld	b, h
	inc	bc
	inc	bc
	inc	bc
00163$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	b, a
;geometry_boy.c:983: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
	ld	a, l
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x14
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:987: SWITCH_ROM_MBC1(parallax_tileset_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:988: set_sprite_data(PLAYER_SPRITES_OAM, 16, players); // Load into VRAM
	ld	de, #_players
	push	de
	ld	hl, #0x100b
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:989: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:993: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00156$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00101$
;geometry_boy.c:995: set_sprite_tile(PLAYER_SPRITES_OAM + i, PLAYER_SPRITES_OAM + i);
	ld	a, (hl)
	add	a, #0x0b
	ld	c, a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	l, a
	ld	de, #_shadow_OAM+0
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	inc	hl
	inc	hl
	ld	(hl), c
;geometry_boy.c:998: ((i / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00164$
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
00164$:
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	d, a
;geometry_boy.c:997: ((i % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:996: move_sprite(PLAYER_SPRITES_OAM + i,
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, #0x0b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_shadow_OAM
	add	hl, bc
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, d
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:993: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00156$
00101$:
;geometry_boy.c:1001: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1003: uint8_t is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1007: while (1)
00125$:
;geometry_boy.c:1009: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00103$
;geometry_boy.c:1011: wait_vbl_done();
	call	_wait_vbl_done
00103$:
;geometry_boy.c:1013: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:1015: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1016: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1018: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#1
	ld	(hl), a
;geometry_boy.c:1015: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#2
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00165$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00166$
00165$:
	ld	c, #0x00
	jr	00167$
00166$:
	ld	c, #0x01
00167$:
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1020: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1022: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#4
	ld	a, (hl+)
	rlca
	and	a,#0x01
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
;geometry_boy.c:1021: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x03
	ld	e, a
	ld	d, #0x00
;geometry_boy.c:1020: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1021: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, e
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1018: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jr	Z, 00117$
;geometry_boy.c:1022: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00168$
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00168$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	d, a
;geometry_boy.c:1021: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1020: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1022: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_shadow_OAM
	add	hl, bc
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, d
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:1024: player_sprite_num += 12;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0c
	ld	(hl), a
;geometry_boy.c:1025: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1029: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00169$
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
00169$:
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1028: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x14
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, e
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:1029: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00117$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00170$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00171$
00170$:
	xor	a, a
	jr	00172$
00171$:
	ld	a, #0x01
00172$:
;geometry_boy.c:1032: else if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00114$
;geometry_boy.c:1036: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00173$
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00173$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ldhl	sp,	#7
;geometry_boy.c:1035: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1034: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	(hl+), a
;geometry_boy.c:1036: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_shadow_OAM
	add	hl, bc
	ld	c, l
	ld	b, h
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(bc), a
	inc	bc
	ld	a, e
	ld	(bc), a
;geometry_boy.c:1038: player_sprite_num += 4;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x04
	ld	(hl), a
;geometry_boy.c:1039: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1043: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00174$
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
00174$:
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1042: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x14
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, e
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:1043: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00114$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00175$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00176$
00175$:
	xor	a, a
	jr	00177$
00176$:
	ld	a, #0x01
00177$:
;geometry_boy.c:1046: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00111$
;geometry_boy.c:1050: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00178$
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00178$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	d, a
;geometry_boy.c:1049: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1048: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1050: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_shadow_OAM
	add	hl, bc
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, d
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:1052: player_sprite_num += 15;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1053: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1057: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00179$
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
00179$:
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1056: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x14
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, e
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:1057: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00111$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#1
	ld	a, (hl)
	dec	a
	jr	NZ, 00180$
	ldhl	sp,	#2
	ld	a, (hl)
	dec	a
	jr	NZ, 00181$
00180$:
	xor	a, a
	jr	00182$
00181$:
	ld	a, #0x01
00182$:
;geometry_boy.c:1060: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00108$
;geometry_boy.c:1064: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00183$
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00183$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	c, a
;geometry_boy.c:1063: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1062: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
	ld	b, (hl)
;geometry_boy.c:1064: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	l, b
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #_shadow_OAM
	add	hl, de
	pop	de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), e
;geometry_boy.c:1066: player_sprite_num += 1;
	ld	hl, #_player_sprite_num
	inc	(hl)
	ld	a, (hl)
;geometry_boy.c:1067: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1071: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00184$
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	inc	hl
00184$:
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, l
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1070: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x14
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, e
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:1071: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jr	00118$
00108$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00185$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00186$
00185$:
	xor	a, a
	jr	00187$
00186$:
	ld	a, #0x01
00187$:
;geometry_boy.c:1074: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00118$
;geometry_boy.c:1077: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00159$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x28
	jr	NC, 00104$
;../gbdk/include/gb/gb.h:1425: shadow_OAM[nb].y = 0;
	ld	bc, #_shadow_OAM+0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	(hl), #0x00
;geometry_boy.c:1077: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00159$
00104$:
;geometry_boy.c:1081: return TITLE;
	ld	e, #0x00
	jp	00161$
00118$:
;geometry_boy.c:1084: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	jp	NZ,00123$
;geometry_boy.c:984: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1020: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1022: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#5
	ld	a, (hl+)
	rlca
	and	a,#0x01
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
;geometry_boy.c:1021: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, (hl-)
	ld	d, a
	inc	de
	inc	de
	inc	de
	ld	a, (hl)
	and	a, #0x03
	ld	c, a
	ld	l, #0x00
;	spillPairReg hl
;	spillPairReg hl
;geometry_boy.c:1020: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	push	hl
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
;geometry_boy.c:1021: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1086: if (is_up)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
;geometry_boy.c:1090: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00188$
	ld	c, e
	ld	b, d
00188$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x22
	ldhl	sp,	#6
;geometry_boy.c:1089: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	(hl+), a
	inc	hl
;geometry_boy.c:1088: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1090: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
	ld	e, l
	ld	d, h
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;geometry_boy.c:1091: is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
	jr	00123$
00120$:
;geometry_boy.c:1097: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00189$
	ld	c, e
	ld	b, d
00189$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	b, a
;geometry_boy.c:1096: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#8
;geometry_boy.c:1095: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1097: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:1098: is_up = 1;
	ldhl	sp,	#0
	ld	(hl), #0x01
00123$:
;geometry_boy.c:1101: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:1103: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00125$
00161$:
;geometry_boy.c:1105: }
	add	sp, #9
	ret
;geometry_boy.c:1125: screen_t level_select()
;	---------------------------------
; Function level_select
; ---------------------------------
_level_select::
	add	sp, #-6
;geometry_boy.c:1128: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1129: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1130: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1132: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:335: set_bkg_data(0, 9, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0x900
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:336: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00157$:
;geometry_boy.c:338: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00155$:
;geometry_boy.c:340: set_bkg_tile_xy(render_col, render_row, 3);
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, (#_render_row)
	ld	h, a
	ld	a, (#_render_col)
	ld	l, a
	push	hl
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:338: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00155$
;geometry_boy.c:336: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00157$
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1137: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1142: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	ld	(hl), #0x00
00159$:
;geometry_boy.c:1143: set_bkg_tile_xy(render_col + LEVEL_TEXT_START_COL, LEVEL_TEXT_ROW, LETTER_TILES + (level_text[render_col] - 65));
	ld	a, #<(_level_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	ld	b, a
	ld	a, (hl)
	add	a, #0x06
	push	bc
	inc	sp
	ld	h, #0x02
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1142: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00159$
;geometry_boy.c:1146: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00161$:
;geometry_boy.c:1147: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, PROGRESS_TEXT_ROW, LETTER_TILES + (progress_text[render_col] - 65));
	ld	a, #<(_progress_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_progress_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	ld	b, a
	ld	a, (hl)
	add	a, #0x06
	push	bc
	inc	sp
	ld	h, #0x04
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1146: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00161$
;geometry_boy.c:1150: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00163$:
;geometry_boy.c:1151: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, ATTEMPTS_TEXT_ROW, LETTER_TILES + (attempts_text[render_col] - 65));
	ld	a, #<(_attempts_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	ld	b, a
	ld	a, (hl)
	add	a, #0x06
	push	bc
	inc	sp
	ld	h, #0x07
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1150: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00163$
;geometry_boy.c:1154: for (render_col = 0; render_col < 5; render_col++){
	ld	(hl), #0x00
00165$:
;geometry_boy.c:1155: set_bkg_tile_xy(render_col + START_TEXT_START_COL, START_TEXT_ROW, LETTER_TILES + (start_text[render_col] - 65));
	ld	a, #<(_start_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_start_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	ld	b, a
	ld	a, (hl)
	add	a, #0x07
	push	bc
	inc	sp
	ld	h, #0x0b
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1154: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00165$
;geometry_boy.c:1158: for (render_col = 0; render_col < 4; render_col++){
	ld	(hl), #0x00
00167$:
;geometry_boy.c:1159: set_bkg_tile_xy(render_col + START_TEXT_START_COL, BACK_TEXT_ROW, LETTER_TILES + (back_text[render_col] - 65));
	ld	a, #<(_back_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_back_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd6
	ld	b, a
	ld	a, (hl)
	add	a, #0x07
	push	bc
	inc	sp
	ld	h, #0x0d
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1158: for (render_col = 0; render_col < 4; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00167$
;geometry_boy.c:1163: uint8_t tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1164: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00169$:
;geometry_boy.c:1165: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0d
	ld	d, a
	ld	hl, #_render_col
	ld	a, (hl)
	add	a, #0x0c
	push	de
	inc	sp
	ld	h, #0x02
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1166: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1164: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00169$
;geometry_boy.c:1172: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1173: progress = *(px_progress[level_ind]);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_px_progress
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	ld	e, a
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:1174: saved_attempts = *(attempts[level_ind]);
	ld	hl, #_attempts
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;geometry_boy.c:1175: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1176: progress = progress * 100;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	de, #0x0000
	push	de
	ld	e, #0x64
	push	de
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:1177: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_level_widths
	add	hl, de
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0xec
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	de, #0x0000
	push	de
	push	bc
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__divulong
	add	sp, #8
	ld	c, l
	ld	b, h
;geometry_boy.c:1178: progress = progress >> 3;
	ld	a, #0x03
00419$:
	srl	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ, 00419$
;geometry_boy.c:1181: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00171$:
;geometry_boy.c:1182: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
	push	bc
	push	de
	ld	hl, #0x0000
	push	hl
	ld	l, #0x0a
	push	hl
	push	bc
	push	de
	call	__modulong
	add	sp, #8
	push	hl
	ldhl	sp,	#8
	ld	(hl), e
	ldhl	sp,	#9
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	pop	de
	pop	bc
	ldhl	sp,	#2
	ld	a, (hl)
	add	a, #0x0d
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_render_col)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
	add	a, #0x08
	push	de
	push	hl
	inc	sp
	ld	h, #0x05
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
	pop	de
;geometry_boy.c:1183: progress = progress / 10;
	ld	hl, #0x0000
	push	hl
	ld	l, #0x0a
	push	hl
	push	bc
	push	de
	call	__divulong
	add	sp, #8
	ld	c, l
	ld	b, h
;geometry_boy.c:1181: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00171$
;geometry_boy.c:1185: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3205
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1187: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00173$:
;geometry_boy.c:1188: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
	pop	bc
	push	bc
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0d
	ld	d, a
	ld	hl, #_render_col
	ld	a, (hl)
	add	a, #0x08
	push	de
	inc	sp
	ld	h, #0x08
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1189: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1187: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00173$
;geometry_boy.c:1193: while (1)
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
00139$:
;geometry_boy.c:1196: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1197: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1198: render = 0;
	ldhl	sp,	#2
	ld	(hl), #0x00
;geometry_boy.c:1200: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#3
	ld	(hl), a
;geometry_boy.c:1196: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#4
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00186$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00187$
00186$:
	xor	a, a
	jr	00188$
00187$:
	ld	a, #0x01
00188$:
	ldhl	sp,	#5
	ld	(hl), a
;geometry_boy.c:1200: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:1202: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x78
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1203: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (BACK_TEXT_ROW << 3) + YOFF);
	jp	00132$
00131$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#3
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00189$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00190$
00189$:
	xor	a, a
	jr	00191$
00190$:
	ld	a, #0x01
00191$:
;geometry_boy.c:1205: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:1207: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x68
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1208: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (START_TEXT_ROW << 3) + YOFF);
	jp	00132$
00128$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#3
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00192$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00193$
00192$:
	xor	a, a
	jr	00194$
00193$:
	ld	a, #0x01
00194$:
;geometry_boy.c:1211: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:1213: if (level_ind > 0){
	ld	hl, #_level_ind
	ld	a, (hl)
	or	a, a
	jp	Z, 00132$
;geometry_boy.c:1214: level_ind--;
	dec	(hl)
;geometry_boy.c:1215: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jp	00132$
00125$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#3
	ld	a, (hl)
	dec	a
	jr	NZ, 00195$
	ldhl	sp,	#4
	ld	a, (hl)
	dec	a
	jr	NZ, 00196$
00195$:
	xor	a, a
	jr	00197$
00196$:
	ld	a, #0x01
00197$:
;geometry_boy.c:1219: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:1221: if (level_ind < NUM_LEVELS - 1){
	ld	hl, #_level_ind
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x81
	jr	NC, 00132$
;geometry_boy.c:1222: level_ind ++;
	inc	(hl)
;geometry_boy.c:1223: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jr	00132$
00122$:
;geometry_boy.c:364: return (button == target) && !(prev_button == target);
	ldhl	sp,	#3
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00198$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00199$
00198$:
	xor	a, a
	jr	00200$
00199$:
	ld	a, #0x01
00200$:
;geometry_boy.c:1227: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:1231: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#5
	ld	(hl), #0x00
00176$:
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x28
	jr	NC, 00113$
;../gbdk/include/gb/gb.h:1425: shadow_OAM[nb].y = 0;
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl, #_shadow_OAM
	add	hl, bc
	ld	(hl), #0x00
;geometry_boy.c:1231: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#5
	inc	(hl)
	jr	00176$
00113$:
;geometry_boy.c:1236: if (cursor_title_position == 0)
	ld	hl, #_cursor_title_position
	ld	a, (hl)
;geometry_boy.c:1238: cursor_title_position = 0;
	or	a,a
	jr	NZ, 00117$
	ld	(hl),a
;geometry_boy.c:1239: return GAME;
	ld	e, #0x01
	jp	00184$
00117$:
;geometry_boy.c:1242: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:1244: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;geometry_boy.c:1245: return TITLE;
	ld	e, #0x00
	jp	00184$
00132$:
;geometry_boy.c:1249: if (render){
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	Z, 00137$
;geometry_boy.c:1251: tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1252: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00178$:
;geometry_boy.c:1253: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0d
	ld	d, a
	ld	hl, #_render_col
	ld	a, (hl)
	add	a, #0x0c
	push	de
	inc	sp
	ld	h, #0x02
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1254: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1252: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00178$
;geometry_boy.c:1257: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1258: progress = *(px_progress[level_ind]);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_px_progress
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	ld	e, a
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:1259: saved_attempts = *(attempts[level_ind]);
	ld	hl, #_attempts
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;geometry_boy.c:1260: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1261: progress = progress * 100;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	de, #0x0000
	push	de
	ld	e, #0x64
	push	de
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:1262: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
	ld	hl, #_level_ind
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	ld	de, #_level_widths
	add	hl, de
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0xec
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	de, #0x0000
	push	de
	push	bc
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__divulong
	add	sp, #8
	ld	c, l
	ld	b, h
;geometry_boy.c:1263: progress = progress >> 3;
	ld	a, #0x03
00450$:
	srl	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ, 00450$
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:1266: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00180$:
;geometry_boy.c:1267: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
	ld	de, #0x0000
	push	de
	ld	e, #0x0a
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__modulong
	add	sp, #8
	ld	a, e
	add	a, #0x0d
	ld	b, a
	ld	hl, #_render_col
	ld	a, (hl)
	add	a, #0x08
	push	bc
	inc	sp
	ld	h, #0x05
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1268: progress = progress / 10;
	ld	de, #0x0000
	push	de
	ld	e, #0x0a
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__divulong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:1266: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00180$
;geometry_boy.c:1270: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3205
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1272: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00182$:
;geometry_boy.c:1273: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
	pop	bc
	push	bc
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0d
	ld	d, a
	ld	hl, #_render_col
	ld	a, (hl)
	add	a, #0x08
	push	de
	inc	sp
	ld	h, #0x08
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1274: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1272: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00182$
00137$:
;geometry_boy.c:1278: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00139$
00184$:
;geometry_boy.c:1280: }
	add	sp, #6
	ret
_level_text:
	.db #0x4c	;  76	'L'
	.db #0x45	;  69	'E'
	.db #0x56	;  86	'V'
	.db #0x45	;  69	'E'
	.db #0x4c	;  76	'L'
_progress_text:
	.db #0x50	;  80	'P'
	.db #0x52	;  82	'R'
	.db #0x4f	;  79	'O'
	.db #0x47	;  71	'G'
	.db #0x52	;  82	'R'
	.db #0x45	;  69	'E'
	.db #0x53	;  83	'S'
	.db #0x53	;  83	'S'
_attempts_text:
	.db #0x41	;  65	'A'
	.db #0x54	;  84	'T'
	.db #0x54	;  84	'T'
	.db #0x45	;  69	'E'
	.db #0x4d	;  77	'M'
	.db #0x50	;  80	'P'
	.db #0x54	;  84	'T'
	.db #0x53	;  83	'S'
_back_text:
	.db #0x42	;  66	'B'
	.db #0x41	;  65	'A'
	.db #0x43	;  67	'C'
	.db #0x4b	;  75	'K'
;geometry_boy.c:1282: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-7
;geometry_boy.c:178: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:179: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:180: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:181: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:182: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:183: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:184: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:185: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:186: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:187: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:188: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:189: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:192: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:193: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:194: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:1287: gbt_play(song_Data, 2, 1);
	ld	hl, #0x102
	push	hl
	ld	de, #_song_Data
	push	de
	call	_gbt_play
	add	sp, #4
;geometry_boy.c:1288: gbt_loop(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_gbt_loop
	inc	sp
;geometry_boy.c:1290: set_interrupts(VBL_IFLAG); // interrupt set after finished drawing the screen
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:1295: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1296: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(#_saved_bank),a
;geometry_boy.c:1297: screen_t current_screen = TITLE;
	ld	c, #0x00
;geometry_boy.c:1299: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1300: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ldhl	sp,	#6
	ld	(hl), #0x00
00123$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00101$
;geometry_boy.c:1301: attempts[i] = (uint16_t *) (START_ATTEMPTS + (i << 1));
	ld	a, (hl)
	ld	b, #0x00
	add	a, a
	rl	b
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), b
	ld	de, #_attempts
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xa001
	add	hl, de
	pop	de
	ld	b, l
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), b
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:1302: px_progress[i] = (uint16_t *) (START_PROGRESS + (i << 1));
	pop	de
	push	de
	ld	hl, #_px_progress
	add	hl, de
	push	hl
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xa100
	add	hl, de
	pop	de
	ld	b, l
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), b
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	(de), a
	inc	de
;geometry_boy.c:1300: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jr	00123$
00101$:
;geometry_boy.c:1305: if (*saved != 's')
	ld	hl, #_saved
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (_saved + 1)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (hl)
	sub	a, #0x73
	jr	Z, 00104$
;geometry_boy.c:1307: *saved = 's';
	ld	(hl), #0x73
;geometry_boy.c:1308: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00104$
;geometry_boy.c:1310: *(attempts[i]) = 0;
	ld	a, (hl)
	ld	b, #0x00
	add	a, a
	rl	b
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), b
	ld	de, #_attempts
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:1311: *(px_progress[i]) = 0;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_px_progress
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:1308: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	inc	(hl)
	jr	00126$
00104$:
;geometry_boy.c:1314: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1316: while (1)
00117$:
;geometry_boy.c:1318: wait_vbl_done(); // wait until finished drawing the screen
	call	_wait_vbl_done
;geometry_boy.c:1321: if (current_screen == TITLE)
	ld	a, c
	or	a, a
	jr	NZ, 00114$
;geometry_boy.c:1323: current_screen = title();
	call	_title
	ld	c, e
	jr	00117$
00114$:
;geometry_boy.c:1325: else if (current_screen == LEVEL_SELECT)
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00111$
;geometry_boy.c:1327: level_ind = 0;
	ld	hl, #_level_ind
	ld	(hl), #0x00
;geometry_boy.c:1328: current_screen = level_select();
	call	_level_select
	ld	c, e
	jr	00117$
00111$:
;geometry_boy.c:1330: else if (current_screen == PLAYER_SELECT)
	ld	a, c
	sub	a, #0x03
	jr	NZ, 00108$
;geometry_boy.c:1332: current_screen = player_select();
	call	_player_select
	ld	c, e
	jr	00117$
00108$:
;geometry_boy.c:1334: else if (current_screen == GAME)
	ld	a, c
	dec	a
	jr	NZ, 00117$
;geometry_boy.c:1336: current_screen = game();
	call	_game
	ld	c, e
	jr	00117$
;geometry_boy.c:1339: }
	add	sp, #7
	ret
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
__xinit__player_sprite_num:
	.db #0x00	; 0
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
	.dw #0x000b
__xinit__old_scroll_x:
	.dw #0x0000
__xinit__parallax_tile_ind:
	.db #0x00	; 0
__xinit__level_ind:
	.db #0x00	; 0
__xinit__level_maps:
	.dw _level1_v2
	.dw _level2
__xinit__level_widths:
	.dw #0x01c7
	.dw #0x01c7
__xinit__level_banks:
	.db #0x04	; 4
	.db #0x04	; 4
__xinit__current_attempts:
	.dw #0x0000
__xinit__px_progress_bar:
	.dw #0x0000
__xinit__old_px_progress_bar:
	.dw #0x0000
__xinit__saved:
	.dw #0xa000
__xinit__title_loaded:
	.db #0x00	; 0
__xinit__cursor_title_position:
	.db #0x00	; 0
__xinit__cursor_title_position_old:
	.db #0x00	; 0
	.area _CABS (ABS)
