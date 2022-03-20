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
	.globl _aero_light
	.globl _aero
	.globl _nima
	.globl _jump_tile_parallax
	.globl _jump_circle_parallax
	.globl _half_block_parallax
	.globl _big_spike_parallax
	.globl _small_spike_parallax
	.globl _parallax_tileset_v2
	.globl _gb_tileset_v2
	.globl _players
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
;geometry_boy.c:228: void update_HUD_bar()
;	---------------------------------
; Function update_HUD_bar
; ---------------------------------
_update_HUD_bar::
;geometry_boy.c:230: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind]); // 20 *8 * (px_progress)/(level_width*8)
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
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	call	__divuint
	add	sp, #4
	ld	hl, #_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:231: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:234: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:232: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00108$
;geometry_boy.c:234: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:235: while (px_progress_bar > 8)
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
;geometry_boy.c:237: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:238: px_progress_bar -= 8;
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
;geometry_boy.c:240: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
	ld	a, (#_px_progress_bar)
	add	a, #0x2f
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
;geometry_boy.c:244: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:245: while (render_col < NUM_PROGRESS_BAR_TILES)
00104$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	ret	NC
;geometry_boy.c:247: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x2f01
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:248: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:251: }
	jr	00104$
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
_parallax_tileset_v2:
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
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
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
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
_small_spike_parallax:
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x99	; 153
	.db #0x18	; 24
	.db #0xbd	; 189
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xd8	; 216
	.db #0x18	; 24
	.db #0xfc	; 252
	.db #0x3c	; 60
	.db #0xfe	; 254
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x18	; 24
	.db #0x7c	; 124
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x1e	; 30
	.db #0x18	; 24
	.db #0x3e	; 62
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x1b	; 27
	.db #0x18	; 24
	.db #0x3f	; 63
	.db #0x3c	; 60
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
_big_spike_parallax:
	.db #0x99	; 153
	.db #0x18	; 24
	.db #0x99	; 153
	.db #0x18	; 24
	.db #0xbd	; 189
	.db #0x3c	; 60
	.db #0xbd	; 189
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xd8	; 216
	.db #0x18	; 24
	.db #0xd8	; 216
	.db #0x18	; 24
	.db #0xfc	; 252
	.db #0x3c	; 60
	.db #0xfc	; 252
	.db #0x3c	; 60
	.db #0xfe	; 254
	.db #0x7e	; 126
	.db #0xfe	; 254
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x78	; 120	'x'
	.db #0x18	; 24
	.db #0x78	; 120	'x'
	.db #0x18	; 24
	.db #0x7c	; 124
	.db #0x3c	; 60
	.db #0x7c	; 124
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x38	; 56	'8'
	.db #0x18	; 24
	.db #0x38	; 56	'8'
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
	.db #0x1c	; 28
	.db #0x18	; 24
	.db #0x1c	; 28
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
	.db #0x1e	; 30
	.db #0x18	; 24
	.db #0x1e	; 30
	.db #0x18	; 24
	.db #0x3e	; 62
	.db #0x3c	; 60
	.db #0x3e	; 62
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x1b	; 27
	.db #0x18	; 24
	.db #0x1b	; 27
	.db #0x18	; 24
	.db #0x3f	; 63
	.db #0x3c	; 60
	.db #0x3f	; 63
	.db #0x3c	; 60
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
_half_block_parallax:
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
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
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
_jump_circle_parallax:
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0xa5	; 165
	.db #0x18	; 24
	.db #0xa5	; 165
	.db #0x18	; 24
	.db #0x99	; 153
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x98	; 152
	.db #0x00	; 0
	.db #0xa4	; 164
	.db #0x18	; 24
	.db #0xa4	; 164
	.db #0x18	; 24
	.db #0x98	; 152
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x30	; 48	'0'
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
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x18	; 24
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
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x0c	; 12
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
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0x18	; 24
	.db #0x25	; 37
	.db #0x18	; 24
	.db #0x19	; 25
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x00	; 0
_jump_tile_parallax:
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
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
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
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
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
_nima:
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
_aero:
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf7	; 247
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
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x8f	; 143
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xe1	; 225
	.db #0xff	; 255
	.db #0xc9	; 201
	.db #0xff	; 255
	.db #0x99	; 153
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x8f	; 143
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x8f	; 143
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe1	; 225
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x90	; 144
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x98	; 152
	.db #0xff	; 255
	.db #0x91	; 145
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0x91	; 145
	.db #0xff	; 255
	.db #0x98	; 152
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x88	; 136
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x8c	; 140
	.db #0xff	; 255
	.db #0x84	; 132
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x90	; 144
	.db #0xff	; 255
	.db #0x98	; 152
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x8c	; 140
	.db #0xff	; 255
	.db #0xc2	; 194
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x98	; 152
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x8f	; 143
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x88	; 136
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x94	; 148
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x88	; 136
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x88	; 136
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x88	; 136
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xeb	; 235
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0x8b	; 139
	.db #0xff	; 255
	.db #0xe8	; 232
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0xeb	; 235
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xf9	; 249
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0xcf	; 207
	.db #0xff	; 255
	.db #0xcf	; 207
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xcf	; 207
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xbe	; 190
	.db #0xff	; 255
	.db #0xa2	; 162
	.db #0xff	; 255
	.db #0xae	; 174
	.db #0xff	; 255
	.db #0xa2	; 162
	.db #0xff	; 255
	.db #0xbe	; 190
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xf7	; 247
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
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xbf	; 191
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
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xbe	; 190
	.db #0xff	; 255
	.db #0xde	; 222
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xf6	; 246
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0xf6	; 246
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xde	; 222
	.db #0xff	; 255
	.db #0xbe	; 190
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0x80	; 128
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0x98	; 152
	.db #0xff	; 255
	.db #0x9c	; 156
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xda	; 218
	.db #0xff	; 255
	.db #0xaa	; 170
	.db #0xff	; 255
	.db #0xa9	; 169
	.db #0xff	; 255
	.db #0xaa	; 170
	.db #0xff	; 255
	.db #0xda	; 218
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfd	; 253
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xaf	; 175
	.db #0xff	; 255
	.db #0xaf	; 175
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xaf	; 175
	.db #0xff	; 255
	.db #0xaf	; 175
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0xfd	; 253
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0x0e	; 14
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x0e	; 14
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0xe0	; 224
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0x83	; 131
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf9	; 249
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xf9	; 249
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0x5f	; 95
	.db #0xff	; 255
	.db #0x5f	; 95
	.db #0xff	; 255
	.db #0x5f	; 95
	.db #0xff	; 255
	.db #0x5f	; 95
	.db #0xff	; 255
	.db #0x5f	; 95
	.db #0xff	; 255
	.db #0x40	; 64
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x77	; 119	'w'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x7e	; 126
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
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0xff	; 255
	.db #0x7f	; 127
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
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xdf	; 223
	.db #0xff	; 255
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0xb5	; 181
	.db #0xff	; 255
	.db #0xcb	; 203
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xe9	; 233
	.db #0xff	; 255
	.db #0xd6	; 214
	.db #0xff	; 255
	.db #0xb9	; 185
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0x9f	; 159
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0xe3	; 227
	.db #0xff	; 255
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0x8f	; 143
	.db #0xff	; 255
	.db #0x9f	; 159
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
_aero_light:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x18	; 24
	.db #0x38	; 56	'8'
	.db #0x30	; 48	'0'
	.db #0x38	; 56	'8'
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
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x36	; 54	'6'
	.db #0x36	; 54	'6'
	.db #0x66	; 102	'f'
	.db #0x66	; 102	'f'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x6f	; 111	'o'
	.db #0x6f	; 111	'o'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x67	; 103	'g'
	.db #0x67	; 103	'g'
	.db #0x6e	; 110	'n'
	.db #0x6e	; 110	'n'
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x6e	; 110	'n'
	.db #0x6e	; 110	'n'
	.db #0x67	; 103	'g'
	.db #0x67	; 103	'g'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x77	; 119	'w'
	.db #0x77	; 119	'w'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x73	; 115	's'
	.db #0x73	; 115	's'
	.db #0x7b	; 123
	.db #0x7b	; 123
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x6f	; 111	'o'
	.db #0x6f	; 111	'o'
	.db #0x67	; 103	'g'
	.db #0x67	; 103	'g'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x73	; 115	's'
	.db #0x73	; 115	's'
	.db #0x3d	; 61
	.db #0x3d	; 61
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x67	; 103	'g'
	.db #0x67	; 103	'g'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x77	; 119	'w'
	.db #0x77	; 119	'w'
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x6b	; 107	'k'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x77	; 119	'w'
	.db #0x77	; 119	'w'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x77	; 119	'w'
	.db #0x77	; 119	'w'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x77	; 119	'w'
	.db #0x77	; 119	'w'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x1f	; 31
	.db #0x1f	; 31
	.db #0x74	; 116	't'
	.db #0x74	; 116	't'
	.db #0x17	; 23
	.db #0x17	; 23
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x14	; 20
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x5d	; 93
	.db #0x5d	; 93
	.db #0x51	; 81	'Q'
	.db #0x51	; 81	'Q'
	.db #0x5d	; 93
	.db #0x5d	; 93
	.db #0x41	; 65	'A'
	.db #0x41	; 65	'A'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x08	; 8
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x2a	; 42
	.db #0x3e	; 62
	.db #0x2a	; 42
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x7f	; 127
	.db #0x6b	; 107	'k'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x08	; 8
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
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x40	; 64
	.db #0x40	; 64
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
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
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
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x3c	; 60
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
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.db #0x00	; 0
	.db #0x63	; 99	'c'
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
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
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
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x06	; 6
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
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0x31	; 49	'1'
	.db #0x4a	; 74	'J'
	.db #0x4a	; 74	'J'
	.db #0x34	; 52	'4'
	.db #0x34	; 52	'4'
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x16	; 22
	.db #0x16	; 22
	.db #0x29	; 41
	.db #0x29	; 41
	.db #0x46	; 70	'F'
	.db #0x46	; 70	'F'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x60	; 96
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
;geometry_boy.c:253: void lcd_interrupt_game()
;	---------------------------------
; Function lcd_interrupt_game
; ---------------------------------
_lcd_interrupt_game::
;geometry_boy.c:255: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:256: } // hide the window, triggers at the scanline LYC
	ret
;geometry_boy.c:259: void vbl_interrupt_game()
;	---------------------------------
; Function vbl_interrupt_game
; ---------------------------------
_vbl_interrupt_game::
;geometry_boy.c:261: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:262: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:263: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:264: SCX_REG = old_scroll_x; // + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:265: }
	ret
;geometry_boy.c:267: void vbl_interrupt_title()
;	---------------------------------
; Function vbl_interrupt_title
; ---------------------------------
_vbl_interrupt_title::
;geometry_boy.c:269: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:270: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:271: SCX_REG = old_scroll_x + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #_player_dx
	add	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:272: }
	ret
;geometry_boy.c:274: void scroll_bkg_x(uint8_t x_shift, char *map, uint16_t map_width)
;	---------------------------------
; Function scroll_bkg_x
; ---------------------------------
_scroll_bkg_x::
;geometry_boy.c:276: background_x_shift = (background_x_shift + x_shift);
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
;geometry_boy.c:277: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ret	C
;geometry_boy.c:280: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
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
;geometry_boy.c:281: count = (background_x_shift >> 3) - 1;
	dec	de
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
;geometry_boy.c:282: count = (count + 32) % map_width;
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
;geometry_boy.c:283: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00104$:
;geometry_boy.c:286: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
;geometry_boy.c:287: count += map_width;
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
;geometry_boy.c:283: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00104$
;geometry_boy.c:290: }
	ret
;geometry_boy.c:292: void init_background(char *map, uint16_t map_width)
;	---------------------------------
; Function init_background
; ---------------------------------
_init_background::
;geometry_boy.c:295: count = 0;
	xor	a, a
	ld	hl, #_count
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:296: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00102$:
;geometry_boy.c:298: set_bkg_tiles(0, render_row, 32, 1, map + count);
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
;geometry_boy.c:299: count += map_width;
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
;geometry_boy.c:296: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
;geometry_boy.c:301: }
	ret
;geometry_boy.c:372: void collide(int8_t vel_y)
;	---------------------------------
; Function collide
; ---------------------------------
_collide::
	add	sp, #-20
;geometry_boy.c:377: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#22
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00443$
	bit	7, d
	jr	NZ, 00444$
	cp	a, a
	jr	00444$
00443$:
	bit	7, d
	jr	Z, 00444$
	scf
00444$:
	ld	a, #0x00
	rla
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#22
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
	ldhl	sp,	#19
	ld	(hl), #0x00
00174$:
;geometry_boy.c:379: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a, (#_player_x)
	ldhl	sp,	#18
	ld	(hl), a
;geometry_boy.c:380: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
	ld	a, (#_player_y)
	ldhl	sp,	#15
	ld	(hl), a
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#16
	ld	(hl), a
;geometry_boy.c:377: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#19
;geometry_boy.c:379: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a,(hl)
	cp	a,#0x04
	jp	NC,00138$
	dec	hl
	dec	hl
	and	a, #0x01
	ld	(hl), a
	ld	c, a
	add	a, a
	add	a, c
	add	a, a
	add	a, c
	ldhl	sp,	#18
	add	a, (hl)
;geometry_boy.c:380: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
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
	ldhl	sp,	#17
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:338: return (y_px - YOFF) >> 3;
	ld	(hl), a
	ldhl	sp,	#12
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
	ldhl	sp,	#15
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#12
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
	ldhl	sp,	#14
	ld	(hl), a
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ldhl	sp,	#18
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
;geometry_boy.c:333: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#12
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
	ldhl	sp,	#16
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
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
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
;geometry_boy.c:382: tile_x = tile_x & 0xF8; // divide by 8 then multiply by 8
	ldhl	sp,	#18
	ld	a, (hl)
	and	a, #0xf8
;geometry_boy.c:383: tile_y = tile_y & 0xF8;
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0xf8
	ld	(hl), a
;geometry_boy.c:389: player_x = (player_x / 8) * 8;
	ld	a, (#_player_x)
	ldhl	sp,	#15
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
;geometry_boy.c:384: if (tile == SMALL_SPIKE_TILE || tile == BIG_SPIKE_TILE)
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	sub	a, #0x05
	jr	Z, 00134$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00135$
00134$:
;geometry_boy.c:387: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:388: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:389: player_x = (player_x / 8) * 8;
	ldhl	sp,	#15
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	dec	hl
	bit	7, (hl)
	jr	Z, 00178$
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), a
00178$:
	ldhl	sp,#17
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
;geometry_boy.c:390: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00175$
00135$:
;geometry_boy.c:403: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	a, (#_player_y)
;geometry_boy.c:410: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ld	hl, #_player_x
	ld	c, (hl)
;geometry_boy.c:403: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	and	a, #0xf8
;geometry_boy.c:410: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	push	af
	ld	a, c
	and	a, #0xf8
	ldhl	sp,	#9
;geometry_boy.c:403: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	(hl+), a
	pop	af
	add	a, #0x08
	ld	(hl), a
;geometry_boy.c:393: else if (tile == BLACK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00132$
;geometry_boy.c:395: if (vel_y > 0)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
;geometry_boy.c:397: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ld	hl, #_player_y
	ld	a, (hl)
	and	a, #0xf8
	ld	(hl), a
;geometry_boy.c:398: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:399: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00175$
00105$:
;geometry_boy.c:401: else if (vel_y < 0)
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
;geometry_boy.c:403: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00175$
00102$:
;geometry_boy.c:408: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:409: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:410: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:411: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00175$
00132$:
;geometry_boy.c:417: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#13
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:417: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#9
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#16
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
	ld	(hl), a
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#5
	ld	e, l
	ld	d, h
	ldhl	sp,	#11
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00450$
	bit	7, d
	jr	NZ, 00451$
	cp	a, a
	jr	00451$
00450$:
	bit	7, d
	jr	Z, 00451$
	scf
00451$:
	ld	a, #0x00
	rla
	ld	c, a
;geometry_boy.c:415: else if (tile == HALF_BLOCK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jp	NZ,00129$
;geometry_boy.c:417: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#15
	ld	b, (hl)
	ldhl	sp,	#9
	ld	e, (hl)
	inc	e
	inc	e
	inc	e
	inc	e
	ldhl	sp,	#16
;geometry_boy.c:366: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00179$
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
	bit	0, c
	jr	NZ, 00179$
;geometry_boy.c:368: player_y <= y_bot &&
	ld	a, b
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00179$
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	c, e
	ld	b, #0x00
	ldhl	sp,	#17
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00454$
	bit	7, d
	jr	NZ, 00455$
	cp	a, a
	jr	00455$
00454$:
	bit	7, d
	jr	Z, 00455$
	scf
00455$:
	jr	NC, 00180$
00179$:
	xor	a, a
	jr	00181$
00180$:
	ld	a, #0x01
00181$:
;geometry_boy.c:417: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	or	a, a
	jp	Z, 00175$
;geometry_boy.c:419: if (vel_y > 0)
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
;geometry_boy.c:421: player_y = tile_y - 4;
	ldhl	sp,	#9
	ld	a, (hl)
	add	a, #0xfc
	ld	(#_player_y),a
;geometry_boy.c:422: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:423: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00175$
00111$:
;geometry_boy.c:425: else if (vel_y < 0)
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
;geometry_boy.c:427: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00175$
00108$:
;geometry_boy.c:432: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:433: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:434: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:435: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00175$
00129$:
;geometry_boy.c:440: else if (tile == JUMP_TILE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00126$
;geometry_boy.c:442: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	ldhl	sp,	#15
	ld	b, (hl)
	ldhl	sp,	#9
	ld	a, (hl)
	add	a, #0x06
	ld	e, a
	ldhl	sp,	#16
;geometry_boy.c:366: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00188$
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
	bit	0, c
	jr	NZ, 00188$
;geometry_boy.c:368: player_y <= y_bot &&
	ld	a, b
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00188$
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	c, e
	ld	b, #0x00
	ldhl	sp,	#17
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00458$
	bit	7, d
	jr	NZ, 00459$
	cp	a, a
	jr	00459$
00458$:
	bit	7, d
	jr	Z, 00459$
	scf
00459$:
	jr	NC, 00189$
00188$:
	xor	a, a
	jr	00190$
00189$:
	ld	a, #0x01
00190$:
;geometry_boy.c:442: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	or	a, a
	jp	Z, 00175$
	ldhl	sp,	#22
	ld	a, (hl)
	or	a, a
	jp	NZ, 00175$
;geometry_boy.c:444: player_dy = -PLAYER_SUPER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xf7
	jp	00175$
00126$:
;geometry_boy.c:447: else if (tile == JUMP_CIRCLE_TILE) // jump circle , hitbox is 4x4 square in center
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jp	NZ,00175$
;geometry_boy.c:449: if (jpad == J_UP && vel_y == 0)
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00175$
	ldhl	sp,	#22
	ld	a, (hl)
	or	a, a
	jr	NZ, 00175$
;geometry_boy.c:451: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	ldhl	sp,	#9
	ld	a, (hl)
	add	a, #0x05
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	add	a, #0x02
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	add	a, #0x05
	ld	b, a
	ld	c, (hl)
	inc	c
	inc	c
;geometry_boy.c:366: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00197$
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#5
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00464$
	bit	7, d
	jr	NZ, 00465$
	cp	a, a
	jr	00465$
00464$:
	bit	7, d
	jr	Z, 00465$
	scf
00465$:
	jr	C, 00197$
;geometry_boy.c:368: player_y <= y_bot &&
	ldhl	sp,	#15
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00197$
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 00466$
	bit	7, d
	jr	NZ, 00467$
	cp	a, a
	jr	00467$
00466$:
	bit	7, d
	jr	Z, 00467$
	scf
00467$:
	jr	NC, 00198$
00197$:
	xor	a, a
	jr	00199$
00198$:
	ld	a, #0x01
00199$:
;geometry_boy.c:451: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	or	a, a
	jr	Z, 00175$
;geometry_boy.c:453: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
00175$:
;geometry_boy.c:377: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#19
	inc	(hl)
	jp	00174$
00138$:
;geometry_boy.c:459: if (vel_y == 0)
	ldhl	sp,	#22
	ld	a, (hl)
	or	a, a
	jp	NZ, 00176$
;geometry_boy.c:461: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	ldhl	sp,	#15
	ld	a, (hl)
	add	a, #0x08
	ld	c, a
	ldhl	sp,	#18
	ld	a, (hl+)
	add	a, #0x07
	ld	(hl), a
;geometry_boy.c:338: return (y_px - YOFF) >> 3;
	ldhl	sp,	#14
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
	ldhl	sp,	#18
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
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#16
	add	a, (hl)
	ldhl	sp,	#19
;geometry_boy.c:333: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#16
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
	ldhl	sp,	#15
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
	ldhl	sp,	#19
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:461: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jp	Z,00147$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#17
;geometry_boy.c:338: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#16
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
	ldhl	sp,	#18
	ld	(hl), a
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:333: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#16
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
	ldhl	sp,	#15
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
	ldhl	sp,	#19
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:461: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jr	NZ, 00148$
00147$:
;geometry_boy.c:463: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00176$
00148$:
;geometry_boy.c:468: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	ld	a, (#_player_y)
	add	a, #0x08
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#17
;geometry_boy.c:338: return (y_px - YOFF) >> 3;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#15
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
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#16
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
	ldhl	sp,	#18
	ld	(hl), a
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:333: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#16
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
	ldhl	sp,	#15
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
	ldhl	sp,	#19
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:468: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	Z,00144$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#17
;geometry_boy.c:338: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#16
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
	ldhl	sp,	#18
	ld	(hl), a
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:333: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#16
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
	ldhl	sp,	#15
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
	ldhl	sp,	#19
;geometry_boy.c:344: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:468: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	NZ,00176$
00144$:
;geometry_boy.c:470: tile_x = (player_x)&0xF8;
	ld	a, (#_player_x)
	and	a, #0xf8
	ld	e, a
;geometry_boy.c:471: tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
	ld	a, (#_player_y)
	add	a, #0x08
	and	a, #0xf8
;geometry_boy.c:472: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	c, a
	add	a, #0x07
	ldhl	sp,	#12
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
;geometry_boy.c:389: player_x = (player_x / 8) * 8;
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#16
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:389: player_x = (player_x / 8) * 8;
	ld	hl, #0x0007
	add	hl, bc
	ld	c, l
	ld	b, h
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	push	de
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
;geometry_boy.c:366: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00206$
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 00474$
	bit	7, d
	jr	NZ, 00475$
	cp	a, a
	jr	00475$
00474$:
	bit	7, d
	jr	Z, 00475$
	scf
00475$:
	jr	C, 00206$
;geometry_boy.c:368: player_y <= y_bot &&
	ldhl	sp,	#13
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00206$
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#18
	ld	e, l
	ld	d, h
	ldhl	sp,	#16
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00476$
	bit	7, d
	jr	NZ, 00477$
	cp	a, a
	jr	00477$
00476$:
	bit	7, d
	jr	Z, 00477$
	scf
00477$:
	jr	NC, 00207$
00206$:
	xor	a, a
	jr	00208$
00207$:
	ld	a, #0x01
00208$:
;geometry_boy.c:472: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00142$
;geometry_boy.c:474: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jr	00176$
00142$:
;geometry_boy.c:478: tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
	ld	a, (#_player_x)
	add	a, #0x07
	and	a, #0xf8
;geometry_boy.c:479: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	e, a
	add	a, #0x07
	ld	d, a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;geometry_boy.c:366: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00215$
;geometry_boy.c:367: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 00478$
	bit	7, d
	jr	NZ, 00479$
	cp	a, a
	jr	00479$
00478$:
	bit	7, d
	jr	Z, 00479$
	scf
00479$:
	jr	C, 00215$
;geometry_boy.c:368: player_y <= y_bot &&
	ldhl	sp,	#17
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00215$
;geometry_boy.c:369: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#16
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
	jr	Z, 00480$
	bit	7, d
	jr	NZ, 00481$
	cp	a, a
	jr	00481$
00480$:
	bit	7, d
	jr	Z, 00481$
	scf
00481$:
	jr	NC, 00216$
00215$:
	xor	a, a
	jr	00217$
00216$:
	ld	a, #0x01
00217$:
;geometry_boy.c:479: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00176$
;geometry_boy.c:481: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
00176$:
;geometry_boy.c:487: }
	add	sp, #20
	ret
;geometry_boy.c:489: void tick_player()
;	---------------------------------
; Function tick_player
; ---------------------------------
_tick_player::
;geometry_boy.c:491: if (jpad == J_UP)
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00104$
;geometry_boy.c:493: if (on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:495: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
00104$:
;geometry_boy.c:498: if (!on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	NZ, 00108$
;geometry_boy.c:500: player_dy += GRAVITY;
	ld	hl, #_player_dy
	inc	(hl)
;geometry_boy.c:501: if (player_dy > MAX_FALL_SPEED)
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
;geometry_boy.c:502: player_dy = MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x07
00108$:
;geometry_boy.c:505: collide(0);
	xor	a, a
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:507: player_y += player_dy;
	ld	a, (#_player_y)
	ld	hl, #_player_dy
	add	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:510: on_ground = 0;
	ld	hl, #_on_ground
	ld	(hl), #0x00
;geometry_boy.c:512: collide(player_dy);
	ld	a, (#_player_dy)
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:513: }
	ret
;geometry_boy.c:515: void render_player()
;	---------------------------------
; Function render_player
; ---------------------------------
_render_player::
;geometry_boy.c:517: move_sprite(0, player_x, player_y);
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
;geometry_boy.c:517: move_sprite(0, player_x, player_y);
;geometry_boy.c:518: }
	ret
;geometry_boy.c:520: void initialize_player()
;	---------------------------------
; Function initialize_player
; ---------------------------------
_initialize_player::
;geometry_boy.c:522: set_sprite_data(0, 1, players + (player_sprite_num << 4)); // << 4 is the same as *16
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
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;geometry_boy.c:523: set_sprite_tile(0, 0);
;geometry_boy.c:524: }
	ret
;geometry_boy.c:526: screen_t game()
;	---------------------------------
; Function game
; ---------------------------------
_game::
	dec	sp
	dec	sp
;geometry_boy.c:528: STAT_REG |= 0x40; // enable LYC=LY interrupt
	ldh	a, (_STAT_REG + 0)
	or	a, #0x40
	ldh	(_STAT_REG + 0), a
;geometry_boy.c:529: LYC_REG = 16;     // the scanline on which to trigger
	ld	a, #0x10
	ldh	(_LYC_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:531: add_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_add_LCD
	pop	hl
;geometry_boy.c:532: add_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:534: set_interrupts(LCD_IFLAG | VBL_IFLAG);
	ld	a, #0x03
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:536: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:538: initialize_player();
	call	_initialize_player
;geometry_boy.c:539: render_player(); // render at initial position
	call	_render_player
;geometry_boy.c:540: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:155: set_bkg_data(0, 9, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0x900
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:156: set_bkg_data(9, 36, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x2409
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:157: set_bkg_data(45, 1, aero + 47 * 16);
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x12d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:158: set_bkg_data(46, 1, aero + 67 * 16);
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x12e
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:159: set_bkg_data(47, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x92f
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:544: current_attempts = 0;
	xor	a, a
	ld	hl, #_current_attempts
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:195: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00129$:
;geometry_boy.c:197: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00127$:
;geometry_boy.c:199: set_win_tile_xy(render_col, render_row, BLACK_TILE);
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
;geometry_boy.c:197: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00127$
;geometry_boy.c:195: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00129$
;geometry_boy.c:202: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00131$:
;geometry_boy.c:204: set_win_tile_xy(render_col, 0, LETTER_TILES + (attempts_title[render_col] - 65));
	ld	a, #<(_attempts_title)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_title)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:202: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jr	C, 00131$
;geometry_boy.c:206: set_win_tile_xy(7, 0, COLON_TILE); // colon
	ld	a, #0x2d
	push	af
	inc	sp
	ld	hl, #0x07
	push	hl
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:207: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x08
00133$:
;geometry_boy.c:209: set_win_tile_xy(render_col, 0, NUMBER_TILES);
	ld	a, #0x09
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
;geometry_boy.c:207: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0b
	jr	C, 00133$
;geometry_boy.c:211: old_px_progress_bar = 0;
	xor	a, a
	ld	hl, #_old_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:212: px_progress_bar = 0;
	xor	a, a
	ld	hl, #_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:547: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:548: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:550: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:551: init_background(level_maps[level_ind], level_widths[level_ind]);
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
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:552: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:554: while (1)
00112$:
;geometry_boy.c:556: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00102$
;geometry_boy.c:558: wait_vbl_done();
	call	_wait_vbl_done
00102$:
;geometry_boy.c:560: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:562: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:563: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:565: if (debounce_input(J_A, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ld	hl, #_jpad
	ld	c, (hl)
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	sub	a, #0x10
	jr	NZ, 00139$
	ld	a, c
	sub	a, #0x10
	jr	NZ, 00140$
00139$:
	ld	c, #0x00
	jr	00141$
00140$:
	ld	c, #0x01
00141$:
;geometry_boy.c:565: if (debounce_input(J_A, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jr	Z, 00104$
;geometry_boy.c:567: return TITLE;
	ld	e, #0x00
	jp	00137$
00104$:
;geometry_boy.c:570: tick_player();
	call	_tick_player
;geometry_boy.c:571: render_player();
	call	_render_player
;geometry_boy.c:573: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:574: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
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
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	push	de
	push	bc
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
;geometry_boy.c:575: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:577: update_HUD_bar();
	call	_update_HUD_bar
;geometry_boy.c:579: if (lose)
	ld	a, (#_lose)
	or	a, a
	jp	Z, 00108$
;geometry_boy.c:581: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:582: init_background(level_maps[level_ind], level_widths[level_ind]);
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
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:583: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:585: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:586: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:587: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
	jr	NC, 00106$
;geometry_boy.c:589: *(px_progress[level_ind]) = background_x_shift + player_x;
	pop	hl
	push	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00106$:
;geometry_boy.c:591: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:592: current_attempts++;
	ld	hl, #_current_attempts
	inc	(hl)
	jr	NZ, 00231$
	inc	hl
	inc	(hl)
00231$:
;geometry_boy.c:217: uint16_t temp = current_attempts;
	ld	a, (#_current_attempts)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_current_attempts + 1)
	ldhl	sp,	#1
	ld	(hl), a
;geometry_boy.c:218: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	ld	(hl), #0x0a
00135$:
;geometry_boy.c:220: set_win_tile_xy(render_col, 0, temp % 10 + NUMBER_TILES);
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
	add	a, #0x09
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
;geometry_boy.c:221: temp = temp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:218: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00135$
;geometry_boy.c:594: update_HUD_bar();
	call	_update_HUD_bar
;geometry_boy.c:595: wait_vbl_done();
	call	_wait_vbl_done
00108$:
;geometry_boy.c:598: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:599: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00110$
;geometry_boy.c:601: parallax_tile_ind = 0;
	ld	(hl), #0x00
00110$:
;geometry_boy.c:603: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind);     // load tiles into VRAM
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
;geometry_boy.c:604: set_bkg_data(0x5, 1, small_spike_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:605: set_bkg_data(0x4, 1, big_spike_parallax + parallax_tile_ind);    // load tiles into VRAM
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
;geometry_boy.c:606: set_bkg_data(0x08, 1, half_block_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:607: set_bkg_data(0x06, 1, jump_circle_parallax + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:608: set_bkg_data(0x07, 1, jump_tile_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:610: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:611: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:612: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
;geometry_boy.c:613: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:614: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
	jp	00112$
00137$:
;geometry_boy.c:616: }
	inc	sp
	inc	sp
	ret
;geometry_boy.c:645: screen_t title()
;	---------------------------------
; Function title
; ---------------------------------
_title::
	add	sp, #-9
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:648: add_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:650: set_interrupts(VBL_IFLAG);
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:651: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:155: set_bkg_data(0, 9, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0x900
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:156: set_bkg_data(9, 36, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x2409
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:157: set_bkg_data(45, 1, aero + 47 * 16);
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x12d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:158: set_bkg_data(46, 1, aero + 67 * 16);
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x12e
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:159: set_bkg_data(47, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x92f
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:656: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:657: init_background(title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:658: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:660: if (title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	Z, 00109$
;geometry_boy.c:662: for (int i = 0; i < 11; i++)
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
;geometry_boy.c:664: set_sprite_data(TITLE_OAM + i, 1, nima + 16 * (13 + game_title[i] - 65)); // load tiles into VRAM
	ld	de, #_game_title
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
;geometry_boy.c:665: set_sprite_tile(TITLE_OAM + i, TITLE_OAM + i);
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#2
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
;geometry_boy.c:666: if (i > 7)
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
;geometry_boy.c:668: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
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
;geometry_boy.c:668: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00198$
00102$:
;geometry_boy.c:672: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
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
;geometry_boy.c:672: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
00198$:
;geometry_boy.c:662: for (int i = 0; i < 11; i++)
	ldhl	sp,	#7
	inc	(hl)
	jp	NZ,00197$
	inc	hl
	inc	(hl)
	jp	00197$
00104$:
;geometry_boy.c:675: for (uint8_t i = 0; i < 6; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00200$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x06
	jp	NC, 00107$
;geometry_boy.c:678: if (i < 5)
	ld	a, (hl)
	sub	a, #0x05
	jr	NC, 00106$
;geometry_boy.c:680: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
	ld	de, #_start_text
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
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
	ld	de, #_aero
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, #0x16
	ld	b, a
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:681: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
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
;geometry_boy.c:682: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x44
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
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
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:682: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00106$:
;geometry_boy.c:684: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
	ld	de, #_player_text
	ldhl	sp,	#8
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
	ld	de, #_aero
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, #0x1b
	ld	b, a
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:685: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
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
;geometry_boy.c:686: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x40
	ld	c, a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
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
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), c
;geometry_boy.c:675: for (uint8_t i = 0; i < 6; i++)
	ldhl	sp,	#8
	inc	(hl)
	jp	00200$
00107$:
;geometry_boy.c:689: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
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
;geometry_boy.c:693: scroll_sprite(TITLE_OAM + 10, 0, -2);
00109$:
;geometry_boy.c:696: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:697: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:699: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:701: uint8_t title_index = 0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;geometry_boy.c:703: while (1)
00155$:
;geometry_boy.c:705: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:707: wait_vbl_done();
	call	_wait_vbl_done
00111$:
;geometry_boy.c:709: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:711: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:712: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	ld	a, (#_player_dx)
	push	af
	inc	sp
	call	_scroll_bkg_x
	add	sp, #5
;geometry_boy.c:713: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:715: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:716: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00113$
;geometry_boy.c:718: parallax_tile_ind = 0;
	ld	(hl), #0x00
00113$:
;geometry_boy.c:720: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:728: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#5
	ld	a, (hl-)
	ld	(hl), a
;geometry_boy.c:724: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:728: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:722: if (!title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	NZ, 00152$
;geometry_boy.c:724: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00153$
;geometry_boy.c:726: if (title_index < 11)
	dec	hl
	ld	a, (hl)
	sub	a, #0x0b
	jr	NC, 00238$
;geometry_boy.c:728: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ld	de, #_game_title
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
;geometry_boy.c:729: set_sprite_tile(TITLE_OAM + title_index, TITLE_OAM + title_index);
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
;geometry_boy.c:730: if (title_index > 7)
	ld	a, #0x07
	ldhl	sp,	#5
	sub	a, (hl)
	jr	NC, 00115$
;geometry_boy.c:732: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
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
;geometry_boy.c:732: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00116$
00115$:
;geometry_boy.c:736: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
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
;geometry_boy.c:736: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
00116$:
;geometry_boy.c:738: title_index = title_index + 1;
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	jp	00153$
;geometry_boy.c:742: for (uint8_t i = 0; i < 6; i++)
00238$:
	ld	c, #0x00
00203$:
;geometry_boy.c:745: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00119$
	sub	a, #0x05
	jr	NC, 00118$
;geometry_boy.c:747: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:748: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
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
;geometry_boy.c:749: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
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
;geometry_boy.c:749: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00118$:
;geometry_boy.c:751: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:752: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
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
;geometry_boy.c:753: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x40
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
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:742: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00203$
00119$:
;geometry_boy.c:756: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
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
;geometry_boy.c:761: title_loaded = 1;
	ld	hl, #_title_loaded
	ld	(hl), #0x01
;geometry_boy.c:762: title_index = 0;
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
;geometry_boy.c:763: scroll_sprite(TITLE_OAM + 10, 0, -2);
	jp	00153$
00152$:
;geometry_boy.c:770: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00129$
;geometry_boy.c:772: if (title_index == 0)
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00126$
;geometry_boy.c:774: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:775: scroll_sprite(TITLE_OAM + 10, 0, +2);
	jr	00127$
00126$:
;geometry_boy.c:779: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:780: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
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
;geometry_boy.c:780: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
00127$:
;geometry_boy.c:782: title_index = (title_index + 1) % 11;
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
;geometry_boy.c:785: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:786: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:788: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#6
	ld	(hl), a
;geometry_boy.c:785: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#7
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:788: if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00133$
;geometry_boy.c:790: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
	jr	00134$
00133$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:792: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00134$
;geometry_boy.c:794: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
00134$:
;geometry_boy.c:797: if (cursor_title_position != cursor_title_position_old)
	ld	a, (#_cursor_title_position)
	ld	hl, #_cursor_title_position_old
	sub	a, (hl)
	jr	Z, 00149$
;geometry_boy.c:799: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00138$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:801: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
	jr	00139$
00138$:
;geometry_boy.c:803: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00139$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:805: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
00139$:
;geometry_boy.c:807: cursor_title_position_old = cursor_title_position;
	ld	a, (#_cursor_title_position)
	ld	(#_cursor_title_position_old),a
	jp	00153$
00149$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:810: else if (debounce_input(J_SELECT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00153$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:307: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:308: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00207$:
;geometry_boy.c:310: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00205$:
;geometry_boy.c:312: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:310: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00205$
;geometry_boy.c:308: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00207$
;geometry_boy.c:814: remove_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:816: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:816: for (uint8_t i = 0; i < 40; i++)
	inc	c
	jr	00210$
00140$:
;geometry_boy.c:820: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00144$
;geometry_boy.c:822: cursor_title_position_old = 1; // force a change the next time title runs
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x01
;geometry_boy.c:823: return LEVEL_SELECT;
	ld	e, #0x02
	jr	00212$
00144$:
;geometry_boy.c:825: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00153$
;geometry_boy.c:827: cursor_title_position_old = 0;
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
;geometry_boy.c:828: return PLAYER_SELECT;
	ld	e, #0x03
	jr	00212$
00153$:
;geometry_boy.c:833: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:835: delay(LOOP_DELAY);    // LOOP_DELAY
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00155$
00212$:
;geometry_boy.c:837: }
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
;geometry_boy.c:844: screen_t player_select()
;	---------------------------------
; Function player_select
; ---------------------------------
_player_select::
	add	sp, #-9
;geometry_boy.c:847: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:307: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:308: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00153$:
;geometry_boy.c:310: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00151$:
;geometry_boy.c:312: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:310: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00151$
;geometry_boy.c:308: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00153$
;geometry_boy.c:852: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)DARK_CURSOR); // Load into VRAM
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
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:856: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:860: set_sprite_data(PLAYER_SPRITES_OAM, 16, players); // Load into VRAM
	ld	de, #_players
	push	de
	ld	hl, #0x100b
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:864: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00156$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00101$
;geometry_boy.c:866: set_sprite_tile(PLAYER_SPRITES_OAM + i, PLAYER_SPRITES_OAM + i);
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
;geometry_boy.c:869: ((i / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:868: ((i % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:867: move_sprite(PLAYER_SPRITES_OAM + i,
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
;geometry_boy.c:864: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00156$
00101$:
;geometry_boy.c:872: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:874: uint8_t is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:878: while (1)
00125$:
;geometry_boy.c:880: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00103$
;geometry_boy.c:882: wait_vbl_done();
	call	_wait_vbl_done
00103$:
;geometry_boy.c:884: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:886: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:887: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:889: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#1
	ld	(hl), a
;geometry_boy.c:886: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#2
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:891: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:893: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:892: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x03
	ld	e, a
	ld	d, #0x00
;geometry_boy.c:891: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:892: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, e
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:889: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jr	Z, 00117$
;geometry_boy.c:893: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:892: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:891: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:893: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:895: player_sprite_num += 12;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0c
	ld	(hl), a
;geometry_boy.c:896: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:900: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:899: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:900: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00117$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:903: else if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00114$
;geometry_boy.c:907: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:906: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:905: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	(hl+), a
;geometry_boy.c:907: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:909: player_sprite_num += 4;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x04
	ld	(hl), a
;geometry_boy.c:910: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:914: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:913: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:914: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00114$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:917: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00111$
;geometry_boy.c:921: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:920: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:919: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:921: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:923: player_sprite_num += 15;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0f
	ld	(hl), a
;geometry_boy.c:924: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:928: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:927: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:928: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00111$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:931: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00108$
;geometry_boy.c:935: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:934: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:933: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
	ld	b, (hl)
;geometry_boy.c:935: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:937: player_sprite_num += 1;
	ld	hl, #_player_sprite_num
	inc	(hl)
	ld	a, (hl)
;geometry_boy.c:938: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:942: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:941: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:942: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jr	00118$
00108$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:945: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00118$
;geometry_boy.c:948: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:948: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00159$
00104$:
;geometry_boy.c:952: return TITLE;
	ld	e, #0x00
	jp	00161$
00118$:
;geometry_boy.c:955: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	jp	NZ,00123$
;geometry_boy.c:857: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:891: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:893: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#5
	ld	a, (hl+)
	rlca
	and	a,#0x01
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
;geometry_boy.c:892: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
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
;geometry_boy.c:891: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	push	hl
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
;geometry_boy.c:892: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:957: if (is_up)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
;geometry_boy.c:961: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:960: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	(hl+), a
	inc	hl
;geometry_boy.c:959: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:961: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:962: is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
	jr	00123$
00120$:
;geometry_boy.c:968: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:967: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#8
;geometry_boy.c:966: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:968: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:969: is_up = 1;
	ldhl	sp,	#0
	ld	(hl), #0x01
00123$:
;geometry_boy.c:972: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:974: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00125$
00161$:
;geometry_boy.c:976: }
	add	sp, #9
	ret
;geometry_boy.c:996: screen_t level_select()
;	---------------------------------
; Function level_select
; ---------------------------------
_level_select::
	add	sp, #-4
;geometry_boy.c:999: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1001: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:321: set_bkg_data(0, 9, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0x900
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00157$:
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00155$:
;geometry_boy.c:326: set_bkg_tile_xy(render_col, render_row, 3);
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
;geometry_boy.c:324: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00155$
;geometry_boy.c:322: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00157$
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1006: set_sprite_data(CURSOR_TEXT_OAM, 1, (char *)LIGHT_CURSOR); // Load into VRAM
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
;geometry_boy.c:1011: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	ld	(hl), #0x00
00159$:
;geometry_boy.c:1012: set_bkg_tile_xy(render_col + LEVEL_TEXT_START_COL, LEVEL_TEXT_ROW, LETTER_TILES + (level_text[render_col] - 65));
	ld	a, #<(_level_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:1011: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00159$
;geometry_boy.c:1015: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00161$:
;geometry_boy.c:1016: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, PROGRESS_TEXT_ROW, LETTER_TILES + (progress_text[render_col] - 65));
	ld	a, #<(_progress_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_progress_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:1015: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00161$
;geometry_boy.c:1019: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00163$:
;geometry_boy.c:1020: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, ATTEMPTS_TEXT_ROW, LETTER_TILES + (attempts_text[render_col] - 65));
	ld	a, #<(_attempts_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:1019: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00163$
;geometry_boy.c:1023: for (render_col = 0; render_col < 5; render_col++){
	ld	(hl), #0x00
00165$:
;geometry_boy.c:1024: set_bkg_tile_xy(render_col + START_TEXT_START_COL, START_TEXT_ROW, LETTER_TILES + (start_text[render_col] - 65));
	ld	a, #<(_start_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_start_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:1023: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00165$
;geometry_boy.c:1027: for (render_col = 0; render_col < 4; render_col++){
	ld	(hl), #0x00
00167$:
;geometry_boy.c:1028: set_bkg_tile_xy(render_col + START_TEXT_START_COL, BACK_TEXT_ROW, LETTER_TILES + (back_text[render_col] - 65));
	ld	a, #<(_back_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_back_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd2
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
;geometry_boy.c:1027: for (render_col = 0; render_col < 4; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00167$
;geometry_boy.c:1032: uint8_t tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1033: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00169$:
;geometry_boy.c:1034: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x09
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
;geometry_boy.c:1035: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1033: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00169$
;geometry_boy.c:1041: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1042: progress = 100 * (*(px_progress[level_ind])) / (level_widths[level_ind]);
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
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	inc	sp
	inc	sp
	push	hl
	ld	hl, #_level_widths
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	push	bc
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	de
	call	__divuint
	add	sp, #4
	pop	bc
	ldhl	sp,	#3
	ld	(hl), e
;geometry_boy.c:1043: saved_attempts = *(attempts[level_ind]);
	ld	hl, #_attempts
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	h, (hl)
;	spillPairReg hl
	ld	l, c
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:1044: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1047: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00171$:
;geometry_boy.c:1048: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
	ldhl	sp,	#3
	ld	e, (hl)
	ld	d, #0x00
	push	bc
	push	de
	ld	hl, #0x000a
	push	hl
	push	de
	call	__modsint
	add	sp, #4
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	add	a, #0x09
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
;geometry_boy.c:1049: progress = progress / 10;
	push	bc
	ld	hl, #0x000a
	push	hl
	push	de
	call	__divsint
	add	sp, #4
	pop	bc
	ldhl	sp,	#3
	ld	(hl), e
;geometry_boy.c:1047: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00171$
;geometry_boy.c:1051: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x2e05
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1053: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00173$:
;geometry_boy.c:1054: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x09
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
;geometry_boy.c:1055: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ld	c, e
	ld	b, d
;geometry_boy.c:1053: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00173$
;geometry_boy.c:1059: while (1)
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
00139$:
;geometry_boy.c:1062: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1063: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1064: render = 0;
	ld	c, #0x00
;geometry_boy.c:1066: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	hl, #_prev_jpad
	ld	b, (hl)
;geometry_boy.c:1062: prev_jpad = jpad;
	ld	hl, #_jpad
	ld	e, (hl)
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	ld	a, b
	sub	a, #0x08
	jr	NZ, 00186$
	ld	a, e
	sub	a, #0x08
	jr	NZ, 00187$
00186$:
	xor	a, a
	jr	00188$
00187$:
	ld	a, #0x01
00188$:
;geometry_boy.c:1066: if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:1068: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1069: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (BACK_TEXT_ROW << 3) + YOFF);
	jp	00132$
00131$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	ld	a, b
	sub	a, #0x04
	jr	NZ, 00189$
	ld	a, e
	sub	a, #0x04
	jr	NZ, 00190$
00189$:
	xor	a, a
	jr	00191$
00190$:
	ld	a, #0x01
00191$:
;geometry_boy.c:1071: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:1073: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1074: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (START_TEXT_ROW << 3) + YOFF);
	jp	00132$
00128$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	ld	a, b
	sub	a, #0x02
	jr	NZ, 00192$
	ld	a, e
	sub	a, #0x02
	jr	NZ, 00193$
00192$:
	xor	a, a
	jr	00194$
00193$:
	ld	a, #0x01
00194$:
;geometry_boy.c:1077: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:1079: if (level_ind > 0){
	ld	hl, #_level_ind
	ld	a, (hl)
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:1080: level_ind--;
	dec	(hl)
;geometry_boy.c:1081: render = 1;
	ld	c, #0x01
	jr	00132$
00125$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	ld	a, b
	dec	a
	jr	NZ, 00195$
	ld	a, e
	dec	a
	jr	NZ, 00196$
00195$:
	xor	a, a
	jr	00197$
00196$:
	ld	a, #0x01
00197$:
;geometry_boy.c:1085: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:1087: if (level_ind < NUM_LEVELS - 1){
	ld	hl, #_level_ind
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x81
	jr	NC, 00132$
;geometry_boy.c:1088: level_ind ++;
	inc	(hl)
;geometry_boy.c:1089: render = 1;
	ld	c, #0x01
	jr	00132$
00122$:
;geometry_boy.c:350: return (button == target) && !(prev_button == target);
	ld	a, b
	sub	a, #0x40
	jr	NZ, 00198$
	ld	a, e
	sub	a, #0x40
	jr	NZ, 00199$
00198$:
	xor	a, a
	jr	00200$
00199$:
	ld	a, #0x01
00200$:
;geometry_boy.c:1093: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:1097: for (uint8_t i = 0; i < 40; i++)
	ld	b, #0x00
00176$:
	ld	a, b
	sub	a, #0x28
	jr	NC, 00113$
;../gbdk/include/gb/gb.h:1425: shadow_OAM[nb].y = 0;
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
	ld	(hl), #0x00
;geometry_boy.c:1097: for (uint8_t i = 0; i < 40; i++)
	inc	b
	jr	00176$
00113$:
;geometry_boy.c:1102: if (cursor_title_position == 0)
	ld	hl, #_cursor_title_position
	ld	a, (hl)
;geometry_boy.c:1104: cursor_title_position = 0;
	or	a,a
	jr	NZ, 00117$
	ld	(hl),a
;geometry_boy.c:1105: return GAME;
	ld	e, #0x01
	jp	00184$
00117$:
;geometry_boy.c:1108: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:1110: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;geometry_boy.c:1111: return TITLE;
	ld	e, #0x00
	jp	00184$
00132$:
;geometry_boy.c:1115: if (render){
	ld	a, c
	or	a, a
	jp	Z, 00137$
;geometry_boy.c:1117: tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1118: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00178$:
;geometry_boy.c:1119: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x09
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
;geometry_boy.c:1120: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1118: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00178$
;geometry_boy.c:1123: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1124: progress = 100 * (*(px_progress[level_ind])) / (level_widths[level_ind]);
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
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	inc	sp
	inc	sp
	push	hl
	ld	hl, #_level_widths
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	push	bc
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	de
	call	__divuint
	add	sp, #4
	pop	bc
	ldhl	sp,	#3
	ld	(hl), e
;geometry_boy.c:1125: saved_attempts = *(attempts[level_ind]);
	ld	hl, #_attempts
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:1126: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1129: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00180$:
;geometry_boy.c:1130: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
	ldhl	sp,	#3
	ld	e, (hl)
	ld	d, #0x00
	push	bc
	push	de
	ld	hl, #0x000a
	push	hl
	push	de
	call	__modsint
	add	sp, #4
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	pop	de
	pop	bc
	ld	a, l
	add	a, #0x09
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
;geometry_boy.c:1131: progress = progress / 10;
	push	bc
	ld	hl, #0x000a
	push	hl
	push	de
	call	__divsint
	add	sp, #4
	pop	bc
	ldhl	sp,	#3
	ld	(hl), e
;geometry_boy.c:1129: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00180$
;geometry_boy.c:1133: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x2e05
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1135: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00182$:
;geometry_boy.c:1136: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x09
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
;geometry_boy.c:1137: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ld	c, e
	ld	b, d
;geometry_boy.c:1135: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00182$
00137$:
;geometry_boy.c:1141: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00139$
00184$:
;geometry_boy.c:1143: }
	add	sp, #4
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
;geometry_boy.c:1145: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-7
;geometry_boy.c:164: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:165: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:166: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:167: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:168: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:169: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:170: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:171: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:172: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:173: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:174: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:175: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:178: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:179: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:180: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:1150: gbt_play(song_Data, 2, 1);
	ld	hl, #0x102
	push	hl
	ld	de, #_song_Data
	push	de
	call	_gbt_play
	add	sp, #4
;geometry_boy.c:1151: gbt_loop(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_gbt_loop
	inc	sp
;geometry_boy.c:1153: set_interrupts(VBL_IFLAG); // interrupt set after finished drawing the screen
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:1158: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1159: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(#_saved_bank),a
;geometry_boy.c:1160: screen_t current_screen = TITLE;
	ld	c, #0x00
;geometry_boy.c:1162: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1163: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ldhl	sp,	#6
	ld	(hl), #0x00
00123$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00101$
;geometry_boy.c:1164: attempts[i] = (uint16_t *) (START_ATTEMPTS + (i << 1));
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
;geometry_boy.c:1165: px_progress[i] = (uint16_t *) (START_PROGRESS + (i << 1));
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
;geometry_boy.c:1163: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jr	00123$
00101$:
;geometry_boy.c:1168: if (*saved != 's')
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
;geometry_boy.c:1170: *saved = 's';
	ld	(hl), #0x73
;geometry_boy.c:1171: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00104$
;geometry_boy.c:1173: *(attempts[i]) = 0;
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
;geometry_boy.c:1174: *(px_progress[i]) = 0;
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
;geometry_boy.c:1171: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	inc	(hl)
	jr	00126$
00104$:
;geometry_boy.c:1177: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1179: while (1)
00117$:
;geometry_boy.c:1181: wait_vbl_done(); // wait until finished drawing the screen
	call	_wait_vbl_done
;geometry_boy.c:1184: if (current_screen == TITLE)
	ld	a, c
	or	a, a
	jr	NZ, 00114$
;geometry_boy.c:1186: current_screen = title();
	call	_title
	ld	c, e
	jr	00117$
00114$:
;geometry_boy.c:1188: else if (current_screen == LEVEL_SELECT)
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00111$
;geometry_boy.c:1190: level_ind = 0;
	ld	hl, #_level_ind
	ld	(hl), #0x00
;geometry_boy.c:1191: current_screen = level_select();
	call	_level_select
	ld	c, e
	jr	00117$
00111$:
;geometry_boy.c:1193: else if (current_screen == PLAYER_SELECT)
	ld	a, c
	sub	a, #0x03
	jr	NZ, 00108$
;geometry_boy.c:1195: current_screen = player_select();
	call	_player_select
	ld	c, e
	jr	00117$
00108$:
;geometry_boy.c:1197: else if (current_screen == GAME)
	ld	a, c
	dec	a
	jr	NZ, 00117$
;geometry_boy.c:1199: current_screen = game();
	call	_game
	ld	c, e
	jr	00117$
;geometry_boy.c:1202: }
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
	.db #0x03	; 3
	.db #0x03	; 3
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
