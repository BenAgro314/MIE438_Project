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
	.globl _skip_to
	.globl _initialize_player
	.globl _tick_player
	.globl _collide
	.globl _init_background
	.globl _vbl_interrupt_title
	.globl _vbl_interrupt_game
	.globl _lcd_interrupt_game
	.globl _gbt_update
	.globl _gbt_loop
	.globl _gbt_stop
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
	.globl _saved_tick
	.globl _tick
	.globl _jpad
	.globl _prev_jpad
	.globl _lose
	.globl _win
	.globl _on_ground
	.globl _player_sprite_num
	.globl _player_x
	.globl _player_y
	.globl _grav_invert
	.globl _current_vehicle
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
_current_vehicle::
	.ds 1
_grav_invert::
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
_saved_tick::
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
;geometry_boy.c:261: void lcd_interrupt_game()
;	---------------------------------
; Function lcd_interrupt_game
; ---------------------------------
_lcd_interrupt_game::
;geometry_boy.c:263: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:264: } // hide the window, triggers at the scanline LYC
	ret
_attempts_title:
	.db #0x41	;  65	'A'
	.db #0x54	;  84	'T'
	.db #0x54	;  84	'T'
	.db #0x45	;  69	'E'
	.db #0x4d	;  77	'M'
	.db #0x50	;  80	'P'
	.db #0x54	;  84	'T'
;geometry_boy.c:267: void vbl_interrupt_game()
;	---------------------------------
; Function vbl_interrupt_game
; ---------------------------------
_vbl_interrupt_game::
;geometry_boy.c:269: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:270: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:271: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:272: SCX_REG = old_scroll_x; // + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:273: }
	ret
;geometry_boy.c:275: void vbl_interrupt_title()
;	---------------------------------
; Function vbl_interrupt_title
; ---------------------------------
_vbl_interrupt_title::
;geometry_boy.c:277: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:278: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:279: SCX_REG = old_scroll_x + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #_player_dx
	add	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:280: }
	ret
;geometry_boy.c:300: void init_background(char *map, uint16_t map_width)
;	---------------------------------
; Function init_background
; ---------------------------------
_init_background::
;geometry_boy.c:303: count = 0;
	xor	a, a
	ld	hl, #_count
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:304: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00102$:
;geometry_boy.c:306: set_bkg_tiles(0, render_row, 32, 1, map + count);
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
;geometry_boy.c:307: count += map_width;
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
;geometry_boy.c:304: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
;geometry_boy.c:309: }
	ret
;geometry_boy.c:384: void collide(int8_t vel_y)
;	---------------------------------
; Function collide
; ---------------------------------
_collide::
	add	sp, #-31
;geometry_boy.c:389: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#33
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 01192$
	bit	7, d
	jr	NZ, 01193$
	cp	a, a
	jr	01193$
01192$:
	bit	7, d
	jr	Z, 01193$
	scf
01193$:
	ld	a, #0x00
	rla
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#33
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
	ldhl	sp,	#30
	ld	(hl), #0x00
00271$:
;geometry_boy.c:391: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a, (#_player_x)
	ldhl	sp,	#29
	ld	(hl), a
;geometry_boy.c:392: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
	ld	a, (#_player_y)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:389: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#30
;geometry_boy.c:391: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a,(hl)
	cp	a,#0x04
	jp	NC,00190$
	dec	hl
	dec	hl
	and	a, #0x01
	ld	(hl), a
	ld	c, a
	add	a, a
	add	a, c
	add	a, a
	add	a, c
	ldhl	sp,	#29
	add	a, (hl)
;geometry_boy.c:392: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
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
	ldhl	sp,	#28
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ld	(hl), a
	ldhl	sp,	#23
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
	ldhl	sp,	#26
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#22
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#23
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
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ldhl	sp,	#29
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#23
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
	ldhl	sp,	#27
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
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
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
;geometry_boy.c:393: tile = get_tile_by_px(tile_x, tile_y);
	ld	a, (hl+)
	ld	(hl), a
;geometry_boy.c:394: tile_x = tile_x & 0xF8; // divide by 8 then multiply by 8
	ldhl	sp,	#29
	ld	a, (hl)
	and	a, #0xf8
;geometry_boy.c:395: tile_y = tile_y & 0xF8;
	ld	(hl-), a
	ld	a, (hl-)
	and	a, #0xf8
;geometry_boy.c:401: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ld	(hl), a
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	a, (#_player_x)
	ldhl	sp,	#7
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#29
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#24
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:401: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#10
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
;geometry_boy.c:402: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x06
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x06
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	inc	a
	ldhl	sp,	#17
	ld	(hl), a
;geometry_boy.c:403: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x05
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x05
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x02
	ldhl	sp,	#20
	ld	(hl), a
;geometry_boy.c:404: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x04
	ldhl	sp,	#21
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x04
	ldhl	sp,	#22
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x03
	ldhl	sp,	#23
	ld	(hl), a
;geometry_boy.c:408: player_x = (player_x / 8) * 8;
	ldhl	sp,	#8
	ld	a, (hl)
	rlca
	and	a,#0x01
	ldhl	sp,	#24
	ld	(hl), a
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#11
	ld	e, l
	ld	d, h
	ldhl	sp,	#28
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01194$
	bit	7, d
	jr	NZ, 01195$
	cp	a, a
	jr	01195$
01194$:
	bit	7, d
	jr	Z, 01195$
	scf
01195$:
	ld	a, #0x00
	rla
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:397: if (tile == SMALL_SPIKE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x05
	jp	NZ,00188$
;geometry_boy.c:401: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl-)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00275$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00275$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00275$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01198$
	bit	7, d
	jr	NZ, 01199$
	cp	a, a
	jr	01199$
01198$:
	bit	7, d
	jr	Z, 01199$
	scf
01199$:
	jr	NC, 00276$
00275$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00277$
00276$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00277$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:401: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:402: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00284$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#11
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
	jr	Z, 01200$
	bit	7, d
	jr	NZ, 01201$
	cp	a, a
	jr	01201$
01200$:
	bit	7, d
	jr	Z, 01201$
	scf
01201$:
	jr	C, 00284$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00284$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01202$
	bit	7, d
	jr	NZ, 01203$
	cp	a, a
	jr	01203$
01202$:
	bit	7, d
	jr	Z, 01203$
	scf
01203$:
	jr	NC, 00285$
00284$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00286$
00285$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00286$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:402: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:403: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00293$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#11
	ld	e, l
	ld	d, h
	ldhl	sp,	#19
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 01204$
	bit	7, d
	jr	NZ, 01205$
	cp	a, a
	jr	01205$
01204$:
	bit	7, d
	jr	Z, 01205$
	scf
01205$:
	jr	C, 00293$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00293$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01206$
	bit	7, d
	jr	NZ, 01207$
	cp	a, a
	jr	01207$
01206$:
	bit	7, d
	jr	Z, 01207$
	scf
01207$:
	jr	NC, 00294$
00293$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00295$
00294$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00295$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:403: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:404: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00302$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	a, (hl)
	ldhl	sp,	#22
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#11
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
	jr	Z, 01208$
	bit	7, d
	jr	NZ, 01209$
	cp	a, a
	jr	01209$
01208$:
	bit	7, d
	jr	Z, 01209$
	scf
01209$:
	jr	C, 00302$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00302$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01210$
	bit	7, d
	jr	NZ, 01211$
	cp	a, a
	jr	01211$
01210$:
	bit	7, d
	jr	Z, 01211$
	scf
01211$:
	jr	NC, 00303$
00302$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00304$
00303$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00304$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:404: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	or	a, a
	jp	Z, 00272$
00101$:
;geometry_boy.c:406: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:407: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:408: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00311$
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00311$:
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
;geometry_boy.c:409: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00188$:
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:418: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x03
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0x02
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:419: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#6
	ld	a, (hl)
	inc	a
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01212$
	bit	7, d
	jr	NZ, 01213$
	cp	a, a
	jr	01213$
01212$:
	bit	7, d
	jr	Z, 01213$
	scf
01213$:
	ld	a, #0x00
	rla
	ldhl	sp,	#29
	ld	(hl), a
;geometry_boy.c:413: else if (tile == BIG_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ,00185$
;geometry_boy.c:416: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	ldhl	sp,	#15
	ld	c, (hl)
	ldhl	sp,	#10
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00312$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00312$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#9
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00312$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01216$
	bit	7, d
	jr	NZ, 01217$
	cp	a, a
	jr	01217$
01216$:
	bit	7, d
	jr	Z, 01217$
	scf
01217$:
	jr	NC, 00313$
00312$:
	xor	a, a
	jr	00314$
00313$:
	ld	a, #0x01
00314$:
;geometry_boy.c:416: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:417: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00321$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01218$
	bit	7, d
	jr	NZ, 01219$
	cp	a, a
	jr	01219$
01218$:
	bit	7, d
	jr	Z, 01219$
	scf
01219$:
	jr	C, 00321$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#25
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00321$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#21
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01220$
	bit	7, d
	jr	NZ, 01221$
	cp	a, a
	jr	01221$
01220$:
	bit	7, d
	jr	Z, 01221$
	scf
01221$:
	jr	NC, 00322$
00321$:
	xor	a, a
	jr	00323$
00322$:
	ld	a, #0x01
00323$:
;geometry_boy.c:417: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:418: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00330$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01222$
	bit	7, d
	jr	NZ, 01223$
	cp	a, a
	jr	01223$
01222$:
	bit	7, d
	jr	Z, 01223$
	scf
01223$:
	jr	C, 00330$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00330$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01224$
	bit	7, d
	jr	NZ, 01225$
	cp	a, a
	jr	01225$
01224$:
	bit	7, d
	jr	Z, 01225$
	scf
01225$:
	jr	NC, 00331$
00330$:
	xor	a, a
	jr	00332$
00331$:
	ld	a, #0x01
00332$:
;geometry_boy.c:418: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:419: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00339$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01226$
	bit	7, d
	jr	NZ, 01227$
	cp	a, a
	jr	01227$
01226$:
	bit	7, d
	jr	Z, 01227$
	scf
01227$:
	jr	C, 00339$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00339$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#29
	bit	0, (hl)
	jr	Z, 00340$
00339$:
	xor	a, a
	jr	00341$
00340$:
	ld	a, #0x01
00341$:
;geometry_boy.c:419: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	or	a, a
	jp	Z, 00272$
00106$:
;geometry_boy.c:421: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:422: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:423: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00348$
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
00348$:
	ldhl	sp,	#29
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
;geometry_boy.c:424: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00185$:
;geometry_boy.c:428: else if (tile == INVERTED_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0a
	jp	NZ,00182$
;geometry_boy.c:431: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	ldhl	sp,	#10
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00349$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00349$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00349$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#29
	bit	0, (hl)
	jr	Z, 00350$
00349$:
	ld	c, #0x00
	jr	00351$
00350$:
	ld	c, #0x01
00351$:
	ld	a, c
;geometry_boy.c:431: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:432: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00358$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01230$
	bit	7, d
	jr	NZ, 01231$
	cp	a, a
	jr	01231$
01230$:
	bit	7, d
	jr	Z, 01231$
	scf
01231$:
	jr	C, 00358$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00358$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01232$
	bit	7, d
	jr	NZ, 01233$
	cp	a, a
	jr	01233$
01232$:
	bit	7, d
	jr	Z, 01233$
	scf
01233$:
	jr	NC, 00359$
00358$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00360$
00359$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00360$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:432: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:433: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00367$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01234$
	bit	7, d
	jr	NZ, 01235$
	cp	a, a
	jr	01235$
01234$:
	bit	7, d
	jr	Z, 01235$
	scf
01235$:
	jr	C, 00367$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00367$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01236$
	bit	7, d
	jr	NZ, 01237$
	cp	a, a
	jr	01237$
01236$:
	bit	7, d
	jr	Z, 01237$
	scf
01237$:
	jr	NC, 00368$
00367$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00369$
00368$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00369$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:433: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:434: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00376$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01238$
	bit	7, d
	jr	NZ, 01239$
	cp	a, a
	jr	01239$
01238$:
	bit	7, d
	jr	Z, 01239$
	scf
01239$:
	jr	C, 00376$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00376$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01240$
	bit	7, d
	jr	NZ, 01241$
	cp	a, a
	jr	01241$
01240$:
	bit	7, d
	jr	Z, 01241$
	scf
01241$:
	jr	NC, 00377$
00376$:
	ldhl	sp,	#29
	ld	(hl), #0x00
	jr	00378$
00377$:
	ldhl	sp,	#29
	ld	(hl), #0x01
00378$:
	ldhl	sp,	#29
	ld	a, (hl)
;geometry_boy.c:434: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
	or	a, a
	jp	Z, 00272$
00111$:
;geometry_boy.c:436: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:437: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:438: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00385$
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
00385$:
	ldhl	sp,	#29
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
;geometry_boy.c:439: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00182$:
;geometry_boy.c:443: else if (tile == BACK_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jp	NZ,00179$
;geometry_boy.c:446: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	ldhl	sp,	#17
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00386$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00386$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#21
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00386$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01244$
	bit	7, d
	jr	NZ, 01245$
	cp	a, a
	jr	01245$
01244$:
	bit	7, d
	jr	Z, 01245$
	scf
01245$:
	jr	NC, 00387$
00386$:
	xor	a, a
	jr	00388$
00387$:
	ld	a, #0x01
00388$:
;geometry_boy.c:446: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:447: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#23
	ld	c, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00395$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01246$
	bit	7, d
	jr	NZ, 01247$
	cp	a, a
	jr	01247$
01246$:
	bit	7, d
	jr	Z, 01247$
	scf
01247$:
	jr	C, 00395$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00395$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01248$
	bit	7, d
	jr	NZ, 01249$
	cp	a, a
	jr	01249$
01248$:
	bit	7, d
	jr	Z, 01249$
	scf
01249$:
	jr	NC, 00396$
00395$:
	ldhl	sp,	#27
	ld	(hl), #0x00
	jr	00397$
00396$:
	ldhl	sp,	#27
	ld	(hl), #0x01
00397$:
	ldhl	sp,	#27
	ld	a, (hl)
;geometry_boy.c:447: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:448: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#19
	ld	c, (hl)
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00404$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01250$
	bit	7, d
	jr	NZ, 01251$
	cp	a, a
	jr	01251$
01250$:
	bit	7, d
	jr	Z, 01251$
	scf
01251$:
	jr	C, 00404$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00404$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01252$
	bit	7, d
	jr	NZ, 01253$
	cp	a, a
	jr	01253$
01252$:
	bit	7, d
	jr	Z, 01253$
	scf
01253$:
	jr	NC, 00405$
00404$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00406$
00405$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00406$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:448: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
	or	a, a
	jr	NZ, 00116$
;geometry_boy.c:449: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#10
	ld	b, (hl)
	ldhl	sp,	#16
	ld	c, (hl)
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00413$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01254$
	bit	7, d
	jr	NZ, 01255$
	cp	a, a
	jr	01255$
01254$:
	bit	7, d
	jr	Z, 01255$
	scf
01255$:
	jr	C, 00413$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00413$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#29
	bit	0, (hl)
	jr	Z, 00414$
00413$:
	ld	c, #0x00
	jr	00415$
00414$:
	ld	c, #0x01
00415$:
	ld	a, c
;geometry_boy.c:449: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	or	a, a
	jp	Z, 00272$
00116$:
;geometry_boy.c:451: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:452: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:453: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00422$
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
00422$:
	ldhl	sp,	#29
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
;geometry_boy.c:454: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00179$:
;geometry_boy.c:463: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	hl, #_player_y
	ld	a, (hl)
;geometry_boy.c:465: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ld	c, (hl)
;geometry_boy.c:485: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ld	hl, #_player_x
	ld	b, (hl)
;geometry_boy.c:463: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	and	a, #0xf8
	ld	e, a
;geometry_boy.c:465: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ld	a, c
	and	a, #0xf8
	ldhl	sp,	#26
;geometry_boy.c:485: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ld	(hl+), a
	inc	hl
	ld	a, b
	and	a, #0xf8
;geometry_boy.c:463: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	(hl+), a
	ld	a, e
	add	a, #0x08
	ld	(hl), a
;geometry_boy.c:458: else if (tile == BLACK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00176$
;geometry_boy.c:460: if (vel_y > 0)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:462: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:463: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00272$
00122$:
;geometry_boy.c:465: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ldhl	sp,	#26
	ld	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:466: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:467: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00272$
00131$:
;geometry_boy.c:470: else if (vel_y < 0)
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:472: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:473: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ldhl	sp,	#26
	ld	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:474: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:475: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00272$
00125$:
;geometry_boy.c:477: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00272$
00128$:
;geometry_boy.c:483: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:484: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:485: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:486: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00176$:
;geometry_boy.c:490: else if (tile == HALF_BLOCK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jp	NZ,00173$
;geometry_boy.c:492: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl), a
	ldhl	sp,	#10
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00423$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00423$
;geometry_boy.c:380: player_y <= y_bot &&
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00423$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#21
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#13
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
	jr	Z, 01260$
	bit	7, d
	jr	NZ, 01261$
	cp	a, a
	jr	01261$
01260$:
	bit	7, d
	jr	Z, 01261$
	scf
01261$:
	jr	NC, 00424$
00423$:
	ldhl	sp,	#27
	ld	(hl), #0x00
	jr	00425$
00424$:
	ldhl	sp,	#27
	ld	(hl), #0x01
00425$:
	ldhl	sp,	#27
	ld	a, (hl)
;geometry_boy.c:492: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	or	a, a
	jp	Z, 00272$
;geometry_boy.c:494: if (vel_y > 0)
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00143$
;geometry_boy.c:496: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00134$
;geometry_boy.c:497: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00272$
00134$:
;geometry_boy.c:499: player_y = tile_y - 4;
	ldhl	sp,	#6
	ld	a, (hl)
	add	a, #0xfc
	ld	(#_player_y),a
;geometry_boy.c:500: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:501: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00272$
00143$:
;geometry_boy.c:504: else if (vel_y < 0)
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00140$
;geometry_boy.c:506: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00137$
;geometry_boy.c:507: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ldhl	sp,	#26
	ld	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:508: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:509: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00272$
00137$:
;geometry_boy.c:512: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00272$
00140$:
;geometry_boy.c:518: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:519: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:520: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:521: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00272$
00173$:
;geometry_boy.c:526: else if (tile == JUMP_TILE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00170$
;geometry_boy.c:528: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#10
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00432$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00432$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00432$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01264$
	bit	7, d
	jr	NZ, 01265$
	cp	a, a
	jr	01265$
01264$:
	bit	7, d
	jr	Z, 01265$
	scf
01265$:
	jr	NC, 00433$
00432$:
	ld	c, #0x00
	jr	00434$
00433$:
	ld	c, #0x01
00434$:
	ld	a, c
;geometry_boy.c:528: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	or	a, a
	jp	Z, 00272$
	ldhl	sp,	#33
	ld	a, (hl)
	or	a, a
	jp	NZ, 00272$
;geometry_boy.c:530: player_dy = -PLAYER_SUPER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xf7
	jp	00272$
00170$:
;geometry_boy.c:533: else if (tile == JUMP_CIRCLE_TILE) // jump circle , hitbox is 4x4 square in center
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00167$
;geometry_boy.c:535: if (jpad == J_UP && vel_y == 0)
	ld	a, (#_jpad)
	sub	a, #0x04
	jp	NZ,00272$
	ldhl	sp,	#33
	ld	a, (hl)
	or	a, a
	jp	NZ, 00272$
;geometry_boy.c:537: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00441$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#11
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01270$
	bit	7, d
	jr	NZ, 01271$
	cp	a, a
	jr	01271$
01270$:
	bit	7, d
	jr	Z, 01271$
	scf
01271$:
	jr	C, 00441$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#29
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00441$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01272$
	bit	7, d
	jr	NZ, 01273$
	cp	a, a
	jr	01273$
01272$:
	bit	7, d
	jr	Z, 01273$
	scf
01273$:
	jr	NC, 00442$
00441$:
	xor	a, a
	jr	00443$
00442$:
	ld	a, #0x01
00443$:
;geometry_boy.c:537: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	or	a, a
	jp	Z, 00272$
;geometry_boy.c:539: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
	jp	00272$
00167$:
;geometry_boy.c:542: } else if (tile == SHIP_PORTAL_TILE && ((tick - saved_tick) > 10)){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0b
	jr	NZ, 00163$
	ld	a, (#_tick)
	ld	c, #0x00
	ld	hl, #_saved_tick
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	b, #0x00
	sub	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sbc	a, b
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, h
	ld	d, #0x00
	ld	a, #0x0a
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	bit	7, e
	jr	Z, 01276$
	bit	7, d
	jr	NZ, 01277$
	cp	a, a
	jr	01277$
01276$:
	bit	7, d
	jr	Z, 01277$
	scf
01277$:
	jr	NC, 00163$
;geometry_boy.c:543: saved_tick = tick;
	ld	a, (#_tick)
	ld	(#_saved_tick),a
;geometry_boy.c:544: if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00158$
;geometry_boy.c:545: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
	jr	00272$
00158$:
;geometry_boy.c:546: } else if (current_vehicle == CUBE){
	ld	hl, #_current_vehicle
	ld	a, (hl)
	or	a, a
	jr	NZ, 00272$
;geometry_boy.c:547: current_vehicle = SHIP;
	ld	(hl), #0x01
	jr	00272$
00163$:
;geometry_boy.c:550: else if (tile == WIN_TILE){
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00272$
;geometry_boy.c:551: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:552: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:553: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00450$
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00450$:
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
;geometry_boy.c:554: win = 1;
	ld	hl, #_win
	ld	(hl), #0x01
00272$:
;geometry_boy.c:389: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#30
	inc	(hl)
	jp	00271$
00190$:
;geometry_boy.c:558: if (vel_y == 0)
	ldhl	sp,	#33
	ld	a, (hl)
	or	a, a
	jp	NZ, 00273$
;geometry_boy.c:561: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == BLACK_TILE || get_tile_by_px(player_x, player_y - 1) == BLACK_TILE)
	ldhl	sp,	#29
	ld	a, (hl+)
	add	a, #0x07
	ld	(hl), a
;geometry_boy.c:560: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jp	Z, 00216$
;geometry_boy.c:561: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == BLACK_TILE || get_tile_by_px(player_x, player_y - 1) == BLACK_TILE)
	ldhl	sp,	#26
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ld	a, (hl-)
	dec	a
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
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#27
	add	a, (hl)
	ldhl	sp,	#30
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:561: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == BLACK_TILE || get_tile_by_px(player_x, player_y - 1) == BLACK_TILE)
	sub	a, #0x03
	jp	Z,00199$
	ld	hl, #_player_y
	ld	c, (hl)
	dec	c
	ld	a, (#_player_x)
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:561: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == BLACK_TILE || get_tile_by_px(player_x, player_y - 1) == BLACK_TILE)
	sub	a, #0x03
	jr	NZ, 00200$
00199$:
;geometry_boy.c:563: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00273$
00200$:
;geometry_boy.c:568: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y - 1) == HALF_BLOCK_TILE)
	ld	a, (#_player_y)
	dec	a
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#26
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:568: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y - 1) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	Z,00196$
	ld	hl, #_player_y
	ld	c, (hl)
	dec	c
	ld	a, (#_player_x)
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:568: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y - 1) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y - 1) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	NZ,00273$
00196$:
;geometry_boy.c:570: tile_x = (player_x)&0xF8;
	ld	a, (#_player_x)
	and	a, #0xf8
	ldhl	sp,	#22
	ld	(hl), a
;geometry_boy.c:571: tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
	ld	a, (#_player_y)
	add	a, #0x08
	and	a, #0xf8
;geometry_boy.c:572: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	c, a
	add	a, #0x07
	ldhl	sp,	#23
	ld	(hl), a
	ld	a, (hl+)
	ld	(hl+), a
	ld	a, c
	add	a, #0x03
	ld	(hl), a
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	add	a, #0x07
	ld	e, a
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	a, (#_player_x)
	ld	d, #0x00
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	hl, #_player_y
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	push	de
	ld	e, a
	ld	hl, #0x0007
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#29
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	hl, #0x0007
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#31
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#30
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, e
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00451$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#22
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#27
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01288$
	bit	7, d
	jr	NZ, 01289$
	cp	a, a
	jr	01289$
01288$:
	bit	7, d
	jr	Z, 01289$
	scf
01289$:
	jr	C, 00451$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00451$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#29
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01290$
	bit	7, d
	jr	NZ, 01291$
	cp	a, a
	jr	01291$
01290$:
	bit	7, d
	jr	Z, 01291$
	scf
01291$:
	jr	NC, 00452$
00451$:
	ldhl	sp,	#26
	ld	(hl), #0x00
	jr	00453$
00452$:
	ldhl	sp,	#26
	ld	(hl), #0x01
00453$:
	ldhl	sp,	#26
	ld	a, (hl)
;geometry_boy.c:572: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00194$
;geometry_boy.c:574: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00273$
00194$:
;geometry_boy.c:578: tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#26
	ld	(hl-), a
	dec	hl
	and	a, #0xf8
;geometry_boy.c:579: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	(hl-), a
	add	a, #0x07
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00460$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#27
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01292$
	bit	7, d
	jr	NZ, 01293$
	cp	a, a
	jr	01293$
01292$:
	bit	7, d
	jr	Z, 01293$
	scf
01293$:
	jr	C, 00460$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00460$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#25
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#29
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a, b
	bit	7,a
	jr	Z, 01294$
	bit	7, d
	jr	NZ, 01295$
	cp	a, a
	jr	01295$
01294$:
	bit	7, d
	jr	Z, 01295$
	scf
01295$:
	jr	NC, 00461$
00460$:
	ldhl	sp,	#30
	ld	(hl), #0x00
	jr	00462$
00461$:
	ldhl	sp,	#30
	ld	(hl), #0x01
00462$:
	ldhl	sp,	#30
	ld	a, (hl)
;geometry_boy.c:579: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jp	Z, 00273$
;geometry_boy.c:581: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00273$
00216$:
;geometry_boy.c:587: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	ldhl	sp,	#26
	ld	a, (hl)
	add	a, #0x08
	ldhl	sp,	#29
	ld	(hl), a
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ld	a, (hl-)
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
	ldhl	sp,	#26
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#29
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
	ld	a, (hl+)
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#27
	add	a, (hl)
	ldhl	sp,	#30
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:587: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jp	Z,00211$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:587: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jr	NZ, 00212$
00211$:
;geometry_boy.c:589: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00273$
00212$:
;geometry_boy.c:594: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	ld	a, (#_player_y)
	add	a, #0x08
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#26
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:594: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	Z,00208$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#28
;geometry_boy.c:350: return (y_px - YOFF) >> 3;
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
	ldhl	sp,	#30
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#27
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
	ld	(hl), a
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#30
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:345: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
	ld	(hl), a
	ldhl	sp,	#27
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
	ldhl	sp,	#30
;geometry_boy.c:356: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:594: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	NZ,00273$
00208$:
;geometry_boy.c:596: tile_x = (player_x)&0xF8;
	ld	a, (#_player_x)
	and	a, #0xf8
	ld	e, a
;geometry_boy.c:597: tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
	ld	a, (#_player_y)
	add	a, #0x08
	and	a, #0xf8
;geometry_boy.c:598: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	c, a
	add	a, #0x07
	ldhl	sp,	#23
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
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#27
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #0x0007
	add	hl, bc
	ld	c, l
	ld	b, h
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	push	de
	ldhl	sp,#29
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#31
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#30
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00469$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01302$
	bit	7, d
	jr	NZ, 01303$
	cp	a, a
	jr	01303$
01302$:
	bit	7, d
	jr	Z, 01303$
	scf
01303$:
	jr	C, 00469$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00469$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#29
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
	jr	Z, 01304$
	bit	7, d
	jr	NZ, 01305$
	cp	a, a
	jr	01305$
01304$:
	bit	7, d
	jr	Z, 01305$
	scf
01305$:
	jr	NC, 00470$
00469$:
	xor	a, a
	jr	00471$
00470$:
	ld	a, #0x01
00471$:
;geometry_boy.c:598: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00206$
;geometry_boy.c:600: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jr	00273$
00206$:
;geometry_boy.c:604: tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
	ld	a, (#_player_x)
	add	a, #0x07
	and	a, #0xf8
;geometry_boy.c:605: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	ld	e, a
	add	a, #0x07
	ld	d, a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;geometry_boy.c:378: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00478$
;geometry_boy.c:379: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01306$
	bit	7, d
	jr	NZ, 01307$
	cp	a, a
	jr	01307$
01306$:
	bit	7, d
	jr	Z, 01307$
	scf
01307$:
	jr	C, 00478$
;geometry_boy.c:380: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00478$
;geometry_boy.c:381: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#27
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
	jr	Z, 01308$
	bit	7, d
	jr	NZ, 01309$
	cp	a, a
	jr	01309$
01308$:
	bit	7, d
	jr	Z, 01309$
	scf
01309$:
	jr	NC, 00479$
00478$:
	xor	a, a
	jr	00480$
00479$:
	ld	a, #0x01
00480$:
;geometry_boy.c:605: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00273$
;geometry_boy.c:607: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
00273$:
;geometry_boy.c:614: }
	add	sp, #31
	ret
;geometry_boy.c:616: void tick_player()
;	---------------------------------
; Function tick_player
; ---------------------------------
_tick_player::
;geometry_boy.c:629: } else if (current_vehicle == SHIP) {
	ld	a, (#_current_vehicle)
	dec	a
	ld	a, #0x01
	jr	Z, 00229$
	xor	a, a
00229$:
	ld	c, a
;geometry_boy.c:618: if (jpad == J_UP)
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00115$
;geometry_boy.c:620: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00112$
;geometry_boy.c:621: if (on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	Z, 00115$
;geometry_boy.c:623: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00102$
;geometry_boy.c:624: player_dy = PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0x06
	jr	00115$
00102$:
;geometry_boy.c:626: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
	jr	00115$
00112$:
;geometry_boy.c:629: } else if (current_vehicle == SHIP) {
	ld	a, c
	or	a, a
	jr	Z, 00115$
;geometry_boy.c:630: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00107$
;geometry_boy.c:631: player_dy = SHIP_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0x03
	jr	00115$
00107$:
;geometry_boy.c:633: player_dy = -SHIP_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfd
00115$:
;geometry_boy.c:637: if (!on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jp	NZ, 00140$
;geometry_boy.c:641: player_dy -= GRAVITY;
	ld	hl, #_player_dy
	ld	d, (hl)
	dec	d
;geometry_boy.c:645: player_dy += GRAVITY;
	ld	e, (hl)
	inc	e
;geometry_boy.c:639: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00137$
;geometry_boy.c:640: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00121$
;geometry_boy.c:641: player_dy -= GRAVITY;
	ld	hl, #_player_dy
	ld	(hl), d
;geometry_boy.c:642: if (player_dy < -CUBE_MAX_FALL_SPEED)
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x79
	jr	NC, 00140$
;geometry_boy.c:643: player_dy = -CUBE_MAX_FALL_SPEED;
	ld	(hl), #0xf9
	jr	00140$
00121$:
;geometry_boy.c:645: player_dy += GRAVITY;
	ld	hl, #_player_dy
;geometry_boy.c:646: if (player_dy > CUBE_MAX_FALL_SPEED)
	ld	(hl),e
	ld	a,#0x07
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00232$
	bit	7, d
	jr	NZ, 00233$
	cp	a, a
	jr	00233$
00232$:
	bit	7, d
	jr	Z, 00233$
	scf
00233$:
	jr	NC, 00140$
;geometry_boy.c:647: player_dy = CUBE_MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x07
	jr	00140$
00137$:
;geometry_boy.c:649: } else if (current_vehicle == SHIP){
	ld	a, c
	or	a, a
	jr	Z, 00140$
;geometry_boy.c:651: if (tick % 2 == 0){
	ld	a, (#_tick)
	and	a, #0x01
	ld	c, a
	ld	b, #0x00
;geometry_boy.c:650: if (grav_invert){
	ld	a, (#_grav_invert)
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:651: if (tick % 2 == 0){
	ld	a, b
	or	a, c
	jr	NZ, 00124$
;geometry_boy.c:652: player_dy -= GRAVITY;
	ld	hl, #_player_dy
	ld	(hl), d
00124$:
;geometry_boy.c:654: if (player_dy < -SHIP_MAX_FALL_SPEED)
	ld	hl, #_player_dy
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x7c
	jr	NC, 00140$
;geometry_boy.c:655: player_dy = -SHIP_MAX_FALL_SPEED;
	ld	(hl), #0xfc
	jr	00140$
00132$:
;geometry_boy.c:657: if (tick % 2 == 0){
	ld	a, b
	or	a, c
	jr	NZ, 00128$
;geometry_boy.c:658: player_dy += GRAVITY;
	ld	hl, #_player_dy
	ld	(hl), e
00128$:
;geometry_boy.c:660: if (player_dy > SHIP_MAX_FALL_SPEED)
	ld	hl, #_player_dy
	ld	e, (hl)
	ld	a,#0x04
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00234$
	bit	7, d
	jr	NZ, 00235$
	cp	a, a
	jr	00235$
00234$:
	bit	7, d
	jr	Z, 00235$
	scf
00235$:
	jr	NC, 00140$
;geometry_boy.c:661: player_dy = SHIP_MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x04
00140$:
;geometry_boy.c:666: collide(0);
	xor	a, a
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:668: player_y += player_dy;
	ld	a, (#_player_y)
	ld	hl, #_player_dy
	add	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:671: on_ground = 0;
	ld	hl, #_on_ground
	ld	(hl), #0x00
;geometry_boy.c:673: collide(player_dy);
	ld	a, (#_player_dy)
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:674: }
	ret
;geometry_boy.c:687: void initialize_player()
;	---------------------------------
; Function initialize_player
; ---------------------------------
_initialize_player::
;geometry_boy.c:689: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:690: set_sprite_data(0, 1, players + (player_sprite_num << 4)); // cube
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
;geometry_boy.c:691: set_sprite_data(1, 1, gb_tileset_v2 + (11<<4));  // ship
	ld	de, #(_gb_tileset_v2 + 176)
	push	de
	ld	hl, #0x101
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:692: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
	ld	hl, #(_shadow_OAM + 6)
	ld	(hl), #0x01
;geometry_boy.c:694: set_sprite_tile(1, 1);
;geometry_boy.c:695: }
	ret
;geometry_boy.c:697: void skip_to(uint16_t background_x, uint8_t char_y) {
;	---------------------------------
; Function skip_to
; ---------------------------------
_skip_to::
	add	sp, #-10
;geometry_boy.c:699: while (background_x_shift < background_x){
	ld	bc, #_level_banks+0
00101$:
	ld	de, #_background_x_shift
	ldhl	sp,	#12
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	NC, 00103$
;geometry_boy.c:700: SWITCH_ROM_MBC1(level_banks[level_ind]);
	ld	a, c
	ld	hl, #_level_ind
	add	a, (hl)
	ld	e, a
	ld	a, b
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	ldh	(__current_bank + 0), a
	ld	(#0x2000),a
;geometry_boy.c:701: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
	ld	a, (#_level_ind)
	ld	e, #0x00
	add	a, a
	rl	e
	ldhl	sp,	#6
	ld	(hl+), a
	ld	a, e
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_level_widths
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	de, #_level_maps
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_player_dx
	ld	e, (hl)
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
;geometry_boy.c:284: background_x_shift = (background_x_shift + x_shift);
	ldhl	sp,	#8
	ld	a, e
	ld	(hl+), a
	ld	(hl), #0x00
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	a, h
	ld	hl, #_background_x_shift
	ld	(hl), e
	inc	hl
	ld	(hl), a
;geometry_boy.c:285: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00107$
;geometry_boy.c:288: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
	ld	a, (#_background_x_shift)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (#_background_x_shift + 1)
	ldhl	sp,	#9
	ld	(hl), a
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
	ld	d, (hl)
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, #0x08
	ld	e, a
	jr	NC, 00189$
	inc	d
00189$:
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	a, h
	ld	hl, #_old_background_x_shift
	ld	(hl), e
	inc	hl
	ld	(hl), a
;geometry_boy.c:289: count = (background_x_shift >> 3) - 1;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	dec	de
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
;geometry_boy.c:290: count = (count + 32) % map_width;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, (hl)
	add	a, #0x20
	ld	e, a
	jr	NC, 00190$
	inc	d
00190$:
	push	bc
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	de
	call	__moduint
	add	sp, #4
	pop	bc
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00128$:
;geometry_boy.c:294: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
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
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
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
;geometry_boy.c:295: count += map_width;
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
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00128$
;geometry_boy.c:701: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
00107$:
;geometry_boy.c:702: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:238: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
	ld	hl, #_player_x
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
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
	ld	l, (hl)
;	spillPairReg hl
	add	a, #0xec
	ld	e, a
	ld	a, l
	adc	a, #0xff
	push	bc
	ld	d, a
	push	de
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__divuint
	add	sp, #4
	pop	bc
	ld	hl, #_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:239: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;geometry_boy.c:240: if (px_progress_bar >= old_px_progress_bar)
	push	de
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	pop	de
	jr	C, 00115$
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:243: while (px_progress_bar > 8)
00108$:
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, #0x08
	cp	a, e
	ld	a, #0x00
	sbc	a, d
	jr	NC, 00110$
;geometry_boy.c:245: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:246: px_progress_bar -= 8;
	ld	a, e
	add	a, #0xf8
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	hl, #_px_progress_bar
	ld	(hl), e
	inc	hl
	ld	(hl), a
	jr	00108$
00110$:
;geometry_boy.c:248: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
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
	jp	00101$
00115$:
;geometry_boy.c:252: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:253: while (render_col < NUM_PROGRESS_BAR_TILES)
00112$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jp	NC, 00101$
;geometry_boy.c:255: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3301
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:256: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00112$
;geometry_boy.c:703: update_HUD_bar();
00103$:
;geometry_boy.c:705: player_y = char_y;
	ldhl	sp,	#14
	ld	a, (hl)
	ld	hl, #_player_y
	ld	(hl), a
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
	ld	c, (hl)
	ld	hl, #_player_x
	ld	b, (hl)
;geometry_boy.c:678: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00125$
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
	ld	e, b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), e
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #(_shadow_OAM + 4)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:680: move_sprite(1, 0, 0);
	jr	00130$
00125$:
;geometry_boy.c:681: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00130$
;geometry_boy.c:682: move_sprite(1, player_x, player_y);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:706: render_player();
00130$:
;geometry_boy.c:707: }
	add	sp, #10
	ret
;geometry_boy.c:709: screen_t game()
;	---------------------------------
; Function game
; ---------------------------------
_game::
	add	sp, #-8
;geometry_boy.c:711: gbt_play(song_Data, musicBank, 1);
	ld	hl, #0x103
	push	hl
	ld	de, #_song_Data
	push	de
	call	_gbt_play
	add	sp, #4
;geometry_boy.c:712: gbt_loop(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_gbt_loop
	inc	sp
;geometry_boy.c:713: STAT_REG |= 0x40; // enable LYC=LY interrupt
	ldh	a, (_STAT_REG + 0)
	or	a, #0x40
	ldh	(_STAT_REG + 0), a
;geometry_boy.c:714: LYC_REG = 16;     // the scanline on which to trigger
	ld	a, #0x10
	ldh	(_LYC_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:716: add_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_add_LCD
	pop	hl
;geometry_boy.c:717: add_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:719: set_interrupts(LCD_IFLAG | VBL_IFLAG);
	ld	a, #0x03
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:721: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:723: initialize_player();
	call	_initialize_player
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
	ld	hl, #_player_y
	ld	c, (hl)
	ld	hl, #_player_x
	ld	b, (hl)
;geometry_boy.c:678: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00130$
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:680: move_sprite(1, 0, 0);
	jr	00132$
00130$:
;geometry_boy.c:681: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:682: move_sprite(1, player_x, player_y);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:724: render_player(); // render at initial position
00132$:
;geometry_boy.c:725: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:161: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:162: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xd00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:163: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:164: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x131
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:165: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:166: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x933
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:167: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:729: current_attempts = 0;
	xor	a, a
	ld	hl, #_current_attempts
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:203: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00205$:
;geometry_boy.c:205: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00203$:
;geometry_boy.c:207: set_win_tile_xy(render_col, render_row, BLACK_TILE);
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
;geometry_boy.c:205: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00203$
;geometry_boy.c:203: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00205$
;geometry_boy.c:210: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00207$:
;geometry_boy.c:212: set_win_tile_xy(render_col, 0, LETTER_TILES + (attempts_title[render_col] - 65));
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
;geometry_boy.c:210: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jr	C, 00207$
;geometry_boy.c:214: set_win_tile_xy(7, 0, COLON_TILE); // colon
	ld	a, #0x31
	push	af
	inc	sp
	ld	hl, #0x07
	push	hl
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:215: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x08
00209$:
;geometry_boy.c:217: set_win_tile_xy(render_col, 0, NUMBER_TILES);
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
;geometry_boy.c:215: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0b
	jr	C, 00209$
;geometry_boy.c:219: old_px_progress_bar = 0;
	xor	a, a
	ld	hl, #_old_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:220: px_progress_bar = 0;
	xor	a, a
	ld	hl, #_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:732: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:733: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:735: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:736: init_background(level_maps[level_ind], level_widths[level_ind]);
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
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:737: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:744: while (1)
00119$:
;geometry_boy.c:746: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00102$
;geometry_boy.c:748: wait_vbl_done();
	call	_wait_vbl_done
00102$:
;geometry_boy.c:750: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:752: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:753: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:755: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ld	hl, #_jpad
	ld	c, (hl)
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
	sub	a, #0x20
	jr	NZ, 00217$
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00218$
00217$:
	ld	c, #0x00
	jr	00219$
00218$:
	ld	c, #0x01
00219$:
;geometry_boy.c:755: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jp	Z, 00106$
;geometry_boy.c:757: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:758: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:759: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#6
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
	jr	NC, 00104$
;geometry_boy.c:761: *(px_progress[level_ind]) = background_x_shift + player_x;
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	inc	hl
	ld	(hl), b
00104$:
;geometry_boy.c:763: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:765: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:766: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:768: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:769: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:678: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00150$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:680: move_sprite(1, 0, 0);
	jr	00152$
00150$:
;geometry_boy.c:681: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00152$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:770: render_player();
00152$:
;geometry_boy.c:771: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:772: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:773: gbt_stop();
	call	_gbt_stop
;geometry_boy.c:774: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00215$
00106$:
;geometry_boy.c:777: tick_player();
	call	_tick_player
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
	ld	hl, #_player_y
	ld	c, (hl)
	ld	hl, #_player_x
	ld	e, (hl)
;geometry_boy.c:678: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00160$
;geometry_boy.c:679: move_sprite(0, player_x, player_y);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), e
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:680: move_sprite(1, 0, 0);
	jr	00162$
00160$:
;geometry_boy.c:681: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00162$
;geometry_boy.c:682: move_sprite(1, player_x, player_y);
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 4)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	(hl), e
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:778: render_player();
00162$:
;geometry_boy.c:780: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:781: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
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
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_player_dx
	ld	e, (hl)
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
;geometry_boy.c:284: background_x_shift = (background_x_shift + x_shift);
	xor	a, a
	ld	hl, #_background_x_shift
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ldhl	sp,	#6
	ld	(hl), e
	inc	hl
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, #_background_x_shift
	ld	(hl), c
	inc	hl
	ld	(hl), a
;geometry_boy.c:285: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00166$
;geometry_boy.c:288: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	ld	d, h
	add	a, #0x08
	ld	e, a
	jr	NC, 00430$
	inc	d
00430$:
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	a, h
	ld	hl, #_old_background_x_shift
	ld	(hl), e
	inc	hl
	ld	(hl), a
;geometry_boy.c:289: count = (background_x_shift >> 3) - 1;
	dec	bc
	ld	hl, #_count
	ld	a, c
	ld	(hl+), a
;geometry_boy.c:290: count = (count + 32) % map_width;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0x20
	ld	c, a
	jr	NC, 00431$
	inc	b
00431$:
	pop	de
	push	de
	push	de
	push	bc
	call	__moduint
	add	sp, #4
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00211$:
;geometry_boy.c:294: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
	ldhl	sp,#2
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
;geometry_boy.c:295: count += map_width;
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
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00211$
;geometry_boy.c:781: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
00166$:
;geometry_boy.c:782: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:238: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
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
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	add	a, #0xec
	ld	e, a
	ld	a, h
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
;geometry_boy.c:239: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:240: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00174$
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:243: while (px_progress_bar > 8)
00167$:
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x08
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00169$
;geometry_boy.c:245: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:246: px_progress_bar -= 8;
	ld	a, c
	add	a, #0xf8
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	hl, #_px_progress_bar
	ld	(hl), c
	inc	hl
	ld	(hl), a
	jr	00167$
00169$:
;geometry_boy.c:248: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
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
	jr	00176$
00174$:
;geometry_boy.c:252: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:253: while (render_col < NUM_PROGRESS_BAR_TILES)
00171$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00176$
;geometry_boy.c:255: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3301
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:256: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00171$
;geometry_boy.c:784: update_HUD_bar();
00176$:
;geometry_boy.c:786: if (lose)
	ld	a, (#_lose)
	or	a, a
	jp	Z, 00114$
;geometry_boy.c:788: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:789: init_background(level_maps[level_ind], level_widths[level_ind]);
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
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	hl, #_level_maps
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	call	_init_background
	add	sp, #4
;geometry_boy.c:790: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:791: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:792: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:793: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#6
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
;geometry_boy.c:795: *(px_progress[level_ind]) = background_x_shift + player_x;
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00108$:
;geometry_boy.c:797: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:799: current_attempts++;
	ld	hl, #_current_attempts
	inc	(hl)
	jr	NZ, 00432$
	inc	hl
	inc	(hl)
00432$:
;geometry_boy.c:225: uint16_t temp = current_attempts;
	ld	a, (#_current_attempts)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (#_current_attempts + 1)
	ldhl	sp,	#7
	ld	(hl), a
;geometry_boy.c:226: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	ld	(hl), #0x0a
00213$:
;geometry_boy.c:228: set_win_tile_xy(render_col, 0, temp % 10 + NUMBER_TILES);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
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
;geometry_boy.c:229: temp = temp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:226: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00213$
;geometry_boy.c:238: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
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
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	add	a, #0xec
	ld	e, a
	ld	a, h
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
;geometry_boy.c:239: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:240: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00187$
;geometry_boy.c:242: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:243: while (px_progress_bar > 8)
00180$:
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x08
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00182$
;geometry_boy.c:245: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:246: px_progress_bar -= 8;
	ld	a, c
	add	a, #0xf8
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	hl, #_px_progress_bar
	ld	(hl), c
	inc	hl
	ld	(hl), a
	jr	00180$
00182$:
;geometry_boy.c:248: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
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
	jr	00189$
00187$:
;geometry_boy.c:252: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:253: while (render_col < NUM_PROGRESS_BAR_TILES)
00184$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00189$
;geometry_boy.c:255: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3301
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:256: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00184$
;geometry_boy.c:801: update_HUD_bar();
00189$:
;geometry_boy.c:802: wait_vbl_done();
	call	_wait_vbl_done
	jp	00115$
00114$:
;geometry_boy.c:809: } else if (win){
	ld	hl, #_win
	ld	a, (hl)
	or	a, a
	jp	Z, 00115$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:811: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:812: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:814: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:815: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:816: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
	ldhl	sp,	#4
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
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
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
;geometry_boy.c:818: *(px_progress[level_ind]) = (level_widths[level_ind] - LEVEL_END_OFFSET) << 3;
	ldhl	sp,#4
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
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00110$:
;geometry_boy.c:820: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:821: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:678: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00199$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:680: move_sprite(1, 0, 0);
	jr	00201$
00199$:
;geometry_boy.c:681: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00201$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+4
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	xor	a, a
	ld	(bc), a
	inc	bc
	xor	a, a
	ld	(bc), a
;geometry_boy.c:822: render_player();
00201$:
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:824: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:825: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:826: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:827: gbt_stop();
	call	_gbt_stop
;geometry_boy.c:828: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00215$
00115$:
;geometry_boy.c:831: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:832: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00117$
;geometry_boy.c:834: parallax_tile_ind = 0;
	ld	(hl), #0x00
00117$:
;geometry_boy.c:836: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:837: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind);     // load tiles into VRAM
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
;geometry_boy.c:838: set_bkg_data(0x5, 1, small_spike_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:839: set_bkg_data(0x4, 1, big_spike_parallax + parallax_tile_ind);    // load tiles into VRAM
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
;geometry_boy.c:840: set_bkg_data(0x08, 1, half_block_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:841: set_bkg_data(0x06, 1, jump_circle_parallax + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:842: set_bkg_data(0x07, 1, jump_tile_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:843: set_bkg_data(0x0A, 1, down_spike_parallax + parallax_tile_ind);   // load tiles into VRAM
	ld	a, #<(_down_spike_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_down_spike_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x10a
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:844: set_bkg_data(0x0B, 1, ship_parallax + parallax_tile_ind);   // load tiles into VRAM
	ld	a, #<(_ship_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_ship_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x10b
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:845: set_bkg_data(0x0C, 1, back_spike_parallax + parallax_tile_ind);   // load tiles into VRAM
	ld	a, #<(_back_spike_parallax)
	ld	hl, #_parallax_tile_ind
	add	a, (hl)
	ld	c, a
	ld	a, #>(_back_spike_parallax)
	adc	a, #0x00
	ld	b, a
	push	bc
	ld	hl, #0x10c
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:846: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:848: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:849: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:850: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
;geometry_boy.c:851: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:852: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
	jp	00119$
00215$:
;geometry_boy.c:854: }
	add	sp, #8
	ret
;geometry_boy.c:881: screen_t title()
;	---------------------------------
; Function title
; ---------------------------------
_title::
	add	sp, #-9
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:884: add_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:886: set_interrupts(VBL_IFLAG);
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:887: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:161: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:162: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xd00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:163: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:164: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x131
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:165: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:166: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x933
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:167: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:892: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:893: init_background(title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:894: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:897: if (title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	Z, 00109$
;geometry_boy.c:899: for (int i = 0; i < 11; i++)
	xor	a, a
	ldhl	sp,	#7
	ld	(hl+), a
	ld	(hl), a
00201$:
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, #0x0b
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	bit	7,a
	jr	Z, 00423$
	bit	7, d
	jr	NZ, 00424$
	cp	a, a
	jr	00424$
00423$:
	bit	7, d
	jr	Z, 00424$
	scf
00424$:
	jp	NC, 00104$
;geometry_boy.c:901: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:902: set_sprite_data(TITLE_OAM + i, 1, nima + 16 * (13 + game_title[i] - 65)); // load tiles into VRAM
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
00425$:
	ldhl	sp,	#3
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00425$
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
;geometry_boy.c:903: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:904: set_sprite_tile(TITLE_OAM + i, TITLE_OAM + i);
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
00426$:
	ldhl	sp,	#5
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00426$
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
;geometry_boy.c:905: if (i > 7)
	ldhl	sp,	#7
	ld	a, #0x07
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00427$
	bit	7, d
	jr	NZ, 00428$
	cp	a, a
	jr	00428$
00427$:
	bit	7, d
	jr	Z, 00428$
	scf
00428$:
	jr	NC, 00102$
;geometry_boy.c:907: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
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
00429$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00429$
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
;geometry_boy.c:907: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00202$
00102$:
;geometry_boy.c:911: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
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
00430$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00430$
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
;geometry_boy.c:911: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
00202$:
;geometry_boy.c:899: for (int i = 0; i < 11; i++)
	ldhl	sp,	#7
	inc	(hl)
	jp	NZ,00201$
	inc	hl
	inc	(hl)
	jp	00201$
00104$:
;geometry_boy.c:914: for (uint8_t i = 0; i < 6; i++)
	ld	c, #0x00
00204$:
;geometry_boy.c:917: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00107$
	sub	a, #0x05
	jr	NC, 00106$
;geometry_boy.c:919: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:920: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:921: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:922: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
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
;geometry_boy.c:923: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
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
;geometry_boy.c:923: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00106$:
;geometry_boy.c:925: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:926: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:927: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:928: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
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
;geometry_boy.c:929: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
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
;geometry_boy.c:914: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00204$
00107$:
;geometry_boy.c:932: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:933: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:934: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
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
;geometry_boy.c:938: scroll_sprite(TITLE_OAM + 10, 0, -2);
00109$:
;geometry_boy.c:941: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:942: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:944: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:946: uint8_t title_index = 0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;geometry_boy.c:948: while (1)
00155$:
;geometry_boy.c:950: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:952: wait_vbl_done();
	call	_wait_vbl_done
00111$:
;geometry_boy.c:954: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:956: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:957: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
	ld	a, (#_player_dx)
;geometry_boy.c:284: background_x_shift = (background_x_shift + x_shift);
	ld	e, #0x00
	ld	hl, #_background_x_shift
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ldhl	sp,	#7
	ld	(hl+), a
	ld	a, e
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	a, h
	ld	hl, #_background_x_shift
	ld	(hl), c
	inc	hl
	ld	(hl), a
;geometry_boy.c:285: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00174$
;geometry_boy.c:288: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
	ld	hl, #_background_x_shift
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	ld	d, h
	add	a, #0x08
	ld	e, a
	jr	NC, 00432$
	inc	d
00432$:
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	a, h
	ld	hl, #_old_background_x_shift
	ld	(hl), e
	inc	hl
	ld	(hl), a
;geometry_boy.c:289: count = (background_x_shift >> 3) - 1;
	dec	bc
	ld	hl, #_count
	ld	a, c
	ld	(hl+), a
;geometry_boy.c:290: count = (count + 32) % map_width;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0020
	add	hl, bc
	ld	de, #0x003c
	push	de
	push	hl
	call	__moduint
	add	sp, #4
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00206$:
;geometry_boy.c:294: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
	ld	a, #<(_title_map_v2)
	ld	hl, #_count
	add	a, (hl)
	inc	hl
	ld	c, a
	ld	a, #>(_title_map_v2)
	adc	a, (hl)
	ld	b, a
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
;geometry_boy.c:295: count += map_width;
	ld	hl, #_count
	ld	a, (hl)
	add	a, #0x3c
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;geometry_boy.c:291: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00206$
;geometry_boy.c:957: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
00174$:
;geometry_boy.c:958: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:960: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:961: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00113$
;geometry_boy.c:963: parallax_tile_ind = 0;
	ld	(hl), #0x00
00113$:
;geometry_boy.c:965: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:966: set_bkg_data(0, 1, parallax_tileset_v2 + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:967: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:976: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#5
	ld	a, (hl-)
	ld	(hl), a
;geometry_boy.c:971: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:976: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:969: if (!title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	NZ, 00152$
;geometry_boy.c:971: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00153$
;geometry_boy.c:973: if (title_index < 11)
	dec	hl
	ld	a, (hl)
	sub	a, #0x0b
	jp	NC, 00246$
;geometry_boy.c:975: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:976: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
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
;geometry_boy.c:977: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:978: set_sprite_tile(TITLE_OAM + title_index, TITLE_OAM + title_index);
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
;geometry_boy.c:979: if (title_index > 7)
	ld	a, #0x07
	ldhl	sp,	#5
	sub	a, (hl)
	jr	NC, 00115$
;geometry_boy.c:981: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
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
;geometry_boy.c:981: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00116$
00115$:
;geometry_boy.c:985: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
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
;geometry_boy.c:985: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
00116$:
;geometry_boy.c:987: title_index = title_index + 1;
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	jp	00153$
;geometry_boy.c:991: for (uint8_t i = 0; i < 6; i++)
00246$:
	ld	c, #0x00
00209$:
;geometry_boy.c:994: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00119$
	sub	a, #0x05
	jr	NC, 00118$
;geometry_boy.c:996: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:997: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:998: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:999: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
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
;geometry_boy.c:1000: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
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
;geometry_boy.c:1000: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00118$:
;geometry_boy.c:1002: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1003: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:1004: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:1005: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
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
;geometry_boy.c:1006: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
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
;geometry_boy.c:991: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00209$
00119$:
;geometry_boy.c:1009: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1010: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1011: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1016: title_loaded = 1;
	ld	hl, #_title_loaded
	ld	(hl), #0x01
;geometry_boy.c:1017: title_index = 0;
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
;geometry_boy.c:1018: scroll_sprite(TITLE_OAM + 10, 0, -2);
	jp	00153$
00152$:
;geometry_boy.c:1025: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00129$
;geometry_boy.c:1027: if (title_index == 0)
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00126$
;geometry_boy.c:1029: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:1030: scroll_sprite(TITLE_OAM + 10, 0, +2);
	jr	00127$
00126$:
;geometry_boy.c:1034: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:1035: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
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
;geometry_boy.c:1035: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
00127$:
;geometry_boy.c:1037: title_index = (title_index + 1) % 11;
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
;geometry_boy.c:1040: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1041: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1043: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#6
	ld	(hl), a
;geometry_boy.c:1040: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#7
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00220$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00221$
00220$:
	ldhl	sp,	#8
	ld	(hl), #0x00
	jr	00222$
00221$:
	ldhl	sp,	#8
	ld	(hl), #0x01
00222$:
	ldhl	sp,	#8
	ld	a, (hl)
;geometry_boy.c:1043: if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00133$
;geometry_boy.c:1045: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
	jr	00134$
00133$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00223$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00224$
00223$:
	xor	a, a
	jr	00225$
00224$:
	ld	a, #0x01
00225$:
;geometry_boy.c:1047: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00134$
;geometry_boy.c:1049: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
00134$:
;geometry_boy.c:1052: if (cursor_title_position != cursor_title_position_old)
	ld	a, (#_cursor_title_position)
	ld	hl, #_cursor_title_position_old
	sub	a, (hl)
	jr	Z, 00149$
;geometry_boy.c:1054: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00138$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1056: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
	jr	00139$
00138$:
;geometry_boy.c:1058: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00139$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1060: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
00139$:
;geometry_boy.c:1062: cursor_title_position_old = cursor_title_position;
	ld	a, (#_cursor_title_position)
	ld	(#_cursor_title_position_old),a
	jp	00153$
00149$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00226$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00227$
00226$:
	xor	a, a
	jr	00228$
00227$:
	ld	a, #0x01
00228$:
;geometry_boy.c:1065: else if (debounce_input(J_SELECT, jpad, prev_jpad))
	or	a, a
	jp	Z, 00153$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:315: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:316: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:317: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:318: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00213$:
;geometry_boy.c:320: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00211$:
;geometry_boy.c:322: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:320: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00211$
;geometry_boy.c:318: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00213$
;geometry_boy.c:1069: remove_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:1071: for (uint8_t i = 0; i < 40; i++)
	ld	c, #0x00
00216$:
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
;geometry_boy.c:1071: for (uint8_t i = 0; i < 40; i++)
	inc	c
	jr	00216$
00140$:
;geometry_boy.c:1075: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00144$
;geometry_boy.c:1077: cursor_title_position_old = 1; // force a change the next time title runs
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x01
;geometry_boy.c:1078: return LEVEL_SELECT;
	ld	e, #0x02
	jr	00218$
00144$:
;geometry_boy.c:1080: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00153$
;geometry_boy.c:1082: cursor_title_position_old = 0;
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
;geometry_boy.c:1083: return PLAYER_SELECT;
	ld	e, #0x03
	jr	00218$
00153$:
;geometry_boy.c:1088: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:1090: delay(LOOP_DELAY);    // LOOP_DELAY
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00155$
00218$:
;geometry_boy.c:1092: }
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
;geometry_boy.c:1099: screen_t player_select()
;	---------------------------------
; Function player_select
; ---------------------------------
_player_select::
	add	sp, #-9
;geometry_boy.c:1102: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:315: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:316: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:317: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:318: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00153$:
;geometry_boy.c:320: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00151$:
;geometry_boy.c:322: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:320: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00151$
;geometry_boy.c:318: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00153$
;geometry_boy.c:1106: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1108: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors + 16); // Load into VRAM
	ld	de, #(_aero_cursors + 16)
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1110: set_sprite_data(PLAYER_SPRITES_OAM, 16, players); // Load into VRAM
	ld	de, #_players
	push	de
	ld	hl, #0x100b
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1111: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1115: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1120: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00156$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00101$
;geometry_boy.c:1122: set_sprite_tile(PLAYER_SPRITES_OAM + i, PLAYER_SPRITES_OAM + i);
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
;geometry_boy.c:1125: ((i / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1124: ((i % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1123: move_sprite(PLAYER_SPRITES_OAM + i,
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
;geometry_boy.c:1120: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00156$
00101$:
;geometry_boy.c:1128: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1130: uint8_t is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1134: while (1)
00125$:
;geometry_boy.c:1136: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00103$
;geometry_boy.c:1138: wait_vbl_done();
	call	_wait_vbl_done
00103$:
;geometry_boy.c:1140: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:1142: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1143: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1145: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#1
	ld	(hl), a
;geometry_boy.c:1142: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#2
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1147: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1149: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1148: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x03
	ld	e, a
	ld	d, #0x00
;geometry_boy.c:1147: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1148: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, e
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1145: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jr	Z, 00117$
;geometry_boy.c:1149: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1148: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1147: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1149: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1151: player_sprite_num += 12;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0c
	ld	(hl), a
;geometry_boy.c:1152: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1156: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1155: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1156: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00117$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1159: else if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00114$
;geometry_boy.c:1163: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1162: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1161: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	(hl+), a
;geometry_boy.c:1163: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1165: player_sprite_num += 4;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x04
	ld	(hl), a
;geometry_boy.c:1166: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1170: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1169: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1170: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00114$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1173: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00111$
;geometry_boy.c:1177: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1176: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1175: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1177: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1179: player_sprite_num += 15;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1180: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1184: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1183: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1184: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00111$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1187: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00108$
;geometry_boy.c:1191: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1190: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1189: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
	ld	b, (hl)
;geometry_boy.c:1191: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1193: player_sprite_num += 1;
	ld	hl, #_player_sprite_num
	inc	(hl)
	ld	a, (hl)
;geometry_boy.c:1194: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1198: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1197: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1198: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jr	00118$
00108$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1201: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00118$
;geometry_boy.c:1204: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:1204: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00159$
00104$:
;geometry_boy.c:1208: return TITLE;
	ld	e, #0x00
	jp	00161$
00118$:
;geometry_boy.c:1211: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	jp	NZ,00123$
;geometry_boy.c:1116: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1147: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1149: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#5
	ld	a, (hl+)
	rlca
	and	a,#0x01
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
;geometry_boy.c:1148: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
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
;geometry_boy.c:1147: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	push	hl
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
;geometry_boy.c:1148: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1213: if (is_up)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
;geometry_boy.c:1217: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:1216: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	(hl+), a
	inc	hl
;geometry_boy.c:1215: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1217: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:1218: is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
	jr	00123$
00120$:
;geometry_boy.c:1224: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1223: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#8
;geometry_boy.c:1222: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1224: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1225: is_up = 1;
	ldhl	sp,	#0
	ld	(hl), #0x01
00123$:
;geometry_boy.c:1228: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:1230: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00125$
00161$:
;geometry_boy.c:1232: }
	add	sp, #9
	ret
;geometry_boy.c:1252: screen_t level_select()
;	---------------------------------
; Function level_select
; ---------------------------------
_level_select::
	add	sp, #-6
;geometry_boy.c:1255: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1256: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1257: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1259: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:331: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:332: set_bkg_data(0, 9, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0x900
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:333: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:334: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00157$:
;geometry_boy.c:336: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00155$:
;geometry_boy.c:338: set_bkg_tile_xy(render_col, render_row, 3);
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
;geometry_boy.c:336: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00155$
;geometry_boy.c:334: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00157$
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1264: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1265: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1266: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:1271: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	ld	(hl), #0x00
00159$:
;geometry_boy.c:1272: set_bkg_tile_xy(render_col + LEVEL_TEXT_START_COL, LEVEL_TEXT_ROW, LETTER_TILES + (level_text[render_col] - 65));
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
;geometry_boy.c:1271: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00159$
;geometry_boy.c:1275: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00161$:
;geometry_boy.c:1276: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, PROGRESS_TEXT_ROW, LETTER_TILES + (progress_text[render_col] - 65));
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
;geometry_boy.c:1275: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00161$
;geometry_boy.c:1279: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00163$:
;geometry_boy.c:1280: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, ATTEMPTS_TEXT_ROW, LETTER_TILES + (attempts_text[render_col] - 65));
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
;geometry_boy.c:1279: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00163$
;geometry_boy.c:1283: for (render_col = 0; render_col < 5; render_col++){
	ld	(hl), #0x00
00165$:
;geometry_boy.c:1284: set_bkg_tile_xy(render_col + START_TEXT_START_COL, START_TEXT_ROW, LETTER_TILES + (start_text[render_col] - 65));
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
;geometry_boy.c:1283: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00165$
;geometry_boy.c:1287: for (render_col = 0; render_col < 4; render_col++){
	ld	(hl), #0x00
00167$:
;geometry_boy.c:1288: set_bkg_tile_xy(render_col + START_TEXT_START_COL, BACK_TEXT_ROW, LETTER_TILES + (back_text[render_col] - 65));
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
;geometry_boy.c:1287: for (render_col = 0; render_col < 4; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00167$
;geometry_boy.c:1292: uint8_t tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1293: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00169$:
;geometry_boy.c:1294: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
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
;geometry_boy.c:1295: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1293: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00169$
;geometry_boy.c:1301: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1302: progress = *(px_progress[level_ind]);
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
;geometry_boy.c:1303: saved_attempts = *(attempts[level_ind]);
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
;geometry_boy.c:1304: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1305: progress = progress * 100;
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
;geometry_boy.c:1306: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
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
;geometry_boy.c:1307: progress = progress >> 3;
	ld	a, #0x03
00419$:
	srl	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ, 00419$
;geometry_boy.c:1310: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00171$:
;geometry_boy.c:1311: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
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
;geometry_boy.c:1312: progress = progress / 10;
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
;geometry_boy.c:1310: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00171$
;geometry_boy.c:1314: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3205
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1316: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00173$:
;geometry_boy.c:1317: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
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
;geometry_boy.c:1318: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1316: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00173$
;geometry_boy.c:1322: while (1)
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
00139$:
;geometry_boy.c:1325: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1326: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1327: render = 0;
	ldhl	sp,	#2
	ld	(hl), #0x00
;geometry_boy.c:1329: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#3
	ld	(hl), a
;geometry_boy.c:1325: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#4
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1329: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:1331: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x78
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1332: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (BACK_TEXT_ROW << 3) + YOFF);
	jp	00132$
00131$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1334: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:1336: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x68
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1337: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (START_TEXT_ROW << 3) + YOFF);
	jp	00132$
00128$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1340: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:1342: if (level_ind > 0){
	ld	hl, #_level_ind
	ld	a, (hl)
	or	a, a
	jp	Z, 00132$
;geometry_boy.c:1343: level_ind--;
	dec	(hl)
;geometry_boy.c:1344: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jp	00132$
00125$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1348: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:1350: if (level_ind < NUM_LEVELS - 1){
	ld	hl, #_level_ind
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x81
	jr	NC, 00132$
;geometry_boy.c:1351: level_ind ++;
	inc	(hl)
;geometry_boy.c:1352: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jr	00132$
00122$:
;geometry_boy.c:362: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1356: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:1360: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:1360: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#5
	inc	(hl)
	jr	00176$
00113$:
;geometry_boy.c:1365: if (cursor_title_position == 0)
	ld	hl, #_cursor_title_position
	ld	a, (hl)
;geometry_boy.c:1367: cursor_title_position = 0;
	or	a,a
	jr	NZ, 00117$
	ld	(hl),a
;geometry_boy.c:1368: return GAME;
	ld	e, #0x01
	jp	00184$
00117$:
;geometry_boy.c:1371: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:1373: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;geometry_boy.c:1374: return TITLE;
	ld	e, #0x00
	jp	00184$
00132$:
;geometry_boy.c:1378: if (render){
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	Z, 00137$
;geometry_boy.c:1380: tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1381: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00178$:
;geometry_boy.c:1382: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
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
;geometry_boy.c:1383: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1381: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00178$
;geometry_boy.c:1386: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1387: progress = *(px_progress[level_ind]);
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
;geometry_boy.c:1388: saved_attempts = *(attempts[level_ind]);
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
;geometry_boy.c:1389: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1390: progress = progress * 100;
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
;geometry_boy.c:1391: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
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
;geometry_boy.c:1392: progress = progress >> 3;
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
;geometry_boy.c:1395: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00180$:
;geometry_boy.c:1396: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
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
;geometry_boy.c:1397: progress = progress / 10;
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
;geometry_boy.c:1395: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00180$
;geometry_boy.c:1399: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3205
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1401: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00182$:
;geometry_boy.c:1402: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
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
;geometry_boy.c:1403: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1401: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00182$
00137$:
;geometry_boy.c:1407: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00139$
00184$:
;geometry_boy.c:1409: }
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
;geometry_boy.c:1411: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-7
;geometry_boy.c:172: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:173: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:174: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:175: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:176: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:177: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:178: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:179: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:180: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:181: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:182: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:183: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:184: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:185: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:186: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:187: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:188: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:1417: set_interrupts(VBL_IFLAG); // interrupt set after finished drawing the screen
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:1422: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1423: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(#_saved_bank),a
;geometry_boy.c:1424: screen_t current_screen = TITLE;
	ld	c, #0x00
;geometry_boy.c:1426: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1427: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ldhl	sp,	#6
	ld	(hl), #0x00
00123$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00101$
;geometry_boy.c:1428: attempts[i] = (uint16_t *) (START_ATTEMPTS + (i << 1));
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
;geometry_boy.c:1429: px_progress[i] = (uint16_t *) (START_PROGRESS + (i << 1));
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
;geometry_boy.c:1427: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jr	00123$
00101$:
;geometry_boy.c:1432: if (*saved != 's')
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
;geometry_boy.c:1434: *saved = 's';
	ld	(hl), #0x73
;geometry_boy.c:1435: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00104$
;geometry_boy.c:1437: *(attempts[i]) = 0;
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
;geometry_boy.c:1438: *(px_progress[i]) = 0;
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
;geometry_boy.c:1435: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	inc	(hl)
	jr	00126$
00104$:
;geometry_boy.c:1441: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1443: while (1)
00117$:
;geometry_boy.c:1445: wait_vbl_done(); // wait until finished drawing the screen
	call	_wait_vbl_done
;geometry_boy.c:1448: if (current_screen == TITLE)
	ld	a, c
	or	a, a
	jr	NZ, 00114$
;geometry_boy.c:1450: current_screen = title();
	call	_title
	ld	c, e
	jr	00117$
00114$:
;geometry_boy.c:1452: else if (current_screen == LEVEL_SELECT)
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00111$
;geometry_boy.c:1454: level_ind = 0;
	ld	hl, #_level_ind
	ld	(hl), #0x00
;geometry_boy.c:1455: current_screen = level_select();
	call	_level_select
	ld	c, e
	jr	00117$
00111$:
;geometry_boy.c:1457: else if (current_screen == PLAYER_SELECT)
	ld	a, c
	sub	a, #0x03
	jr	NZ, 00108$
;geometry_boy.c:1459: current_screen = player_select();
	call	_player_select
	ld	c, e
	jr	00117$
00108$:
;geometry_boy.c:1461: else if (current_screen == GAME)
	ld	a, c
	dec	a
	jr	NZ, 00117$
;geometry_boy.c:1463: current_screen = game();
	call	_game
	ld	c, e
	jr	00117$
;geometry_boy.c:1466: }
	add	sp, #7
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__player_dy:
	.db #0x00	;  0
__xinit__player_dx:
	.db #0x03	;  3
__xinit__current_vehicle:
	.db #0x00	; 0
__xinit__grav_invert:
	.db #0x01	; 1
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
__xinit__saved_tick:
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