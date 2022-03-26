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
;geometry_boy.c:255: void lcd_interrupt_game()
;	---------------------------------
; Function lcd_interrupt_game
; ---------------------------------
_lcd_interrupt_game::
;geometry_boy.c:257: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:258: } // hide the window, triggers at the scanline LYC
	ret
_attempts_title:
	.db #0x41	;  65	'A'
	.db #0x54	;  84	'T'
	.db #0x54	;  84	'T'
	.db #0x45	;  69	'E'
	.db #0x4d	;  77	'M'
	.db #0x50	;  80	'P'
	.db #0x54	;  84	'T'
;geometry_boy.c:261: void vbl_interrupt_game()
;	---------------------------------
; Function vbl_interrupt_game
; ---------------------------------
_vbl_interrupt_game::
;geometry_boy.c:263: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:264: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:265: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:266: SCX_REG = old_scroll_x; // + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:267: }
	ret
;geometry_boy.c:269: void vbl_interrupt_title()
;	---------------------------------
; Function vbl_interrupt_title
; ---------------------------------
_vbl_interrupt_title::
;geometry_boy.c:271: vbl_count++;
	ld	hl, #_vbl_count
	inc	(hl)
;geometry_boy.c:272: old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
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
;geometry_boy.c:273: SCX_REG = old_scroll_x + player_dx;
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #_player_dx
	add	a, (hl)
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:274: }
	ret
;geometry_boy.c:294: void init_background(char *map, uint16_t map_width)
;	---------------------------------
; Function init_background
; ---------------------------------
_init_background::
;geometry_boy.c:297: count = 0;
	xor	a, a
	ld	hl, #_count
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:298: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00102$:
;geometry_boy.c:300: set_bkg_tiles(0, render_row, 32, 1, map + count);
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
;geometry_boy.c:301: count += map_width;
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
;geometry_boy.c:298: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
;geometry_boy.c:303: }
	ret
;geometry_boy.c:378: void collide(int8_t vel_y)
;	---------------------------------
; Function collide
; ---------------------------------
_collide::
	add	sp, #-30
;geometry_boy.c:383: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#32
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
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
00227$:
;geometry_boy.c:385: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a, (#_player_x)
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:386: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
	ld	a, (#_player_y)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#26
	ld	(hl), a
;geometry_boy.c:383: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#29
;geometry_boy.c:385: tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
	ld	a,(hl)
	cp	a,#0x04
	jp	NC,00175$
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
;geometry_boy.c:386: tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
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
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ldhl	sp,	#28
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
;geometry_boy.c:339: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
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
;geometry_boy.c:388: tile_x = tile_x & 0xF8; // divide by 8 then multiply by 8
	ldhl	sp,	#28
	ld	a, (hl)
	and	a, #0xf8
;geometry_boy.c:389: tile_y = tile_y & 0xF8;
	ld	(hl-), a
	ld	a, (hl-)
	and	a, #0xf8
;geometry_boy.c:395: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ld	(hl), a
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	a, (#_player_x)
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#28
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#23
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:395: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x07
	ldhl	sp,	#9
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
;geometry_boy.c:396: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
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
;geometry_boy.c:397: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
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
;geometry_boy.c:398: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
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
;geometry_boy.c:402: player_x = (player_x / 8) * 8;
	ldhl	sp,	#7
	ld	a, (hl)
	rlca
	and	a,#0x01
	ldhl	sp,	#23
	ld	(hl), a
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	ldhl	sp,	#24
	ld	(hl), a
;geometry_boy.c:391: if (tile == SMALL_SPIKE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x05
	jp	NZ,00173$
;geometry_boy.c:395: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00231$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00231$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00231$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00232$
00231$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00233$
00232$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00233$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:395: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 7, tile_y + 7) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:396: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00240$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00240$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00240$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00241$
00240$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00242$
00241$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00242$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:396: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 6, tile_y + 6) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:397: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00249$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00249$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00249$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00250$
00249$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00251$
00250$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00251$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:397: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 5, tile_y + 5) ||
	or	a, a
	jp	NZ, 00101$
;geometry_boy.c:398: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
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
;geometry_boy.c:372: player_x <= x_right &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00258$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00258$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00258$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01050$
	bit	7, d
	jr	NZ, 01051$
	cp	a, a
	jr	01051$
01050$:
	bit	7, d
	jr	Z, 01051$
	scf
01051$:
	jr	NC, 00259$
00258$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00260$
00259$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00260$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:398: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y +4, tile_y + 4)
	or	a, a
	jp	Z, 00228$
00101$:
;geometry_boy.c:400: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:401: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:402: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00267$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00267$:
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
;geometry_boy.c:403: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00173$:
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
	ldhl	sp,	#26
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:412: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
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
;geometry_boy.c:413: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#5
	ld	a, (hl)
	inc	a
	ldhl	sp,	#27
	ld	(hl), a
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#12
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
	ld	a, #0x00
	rla
	ldhl	sp,	#28
	ld	(hl), a
;geometry_boy.c:407: else if (tile == BIG_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ,00170$
;geometry_boy.c:410: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	ldhl	sp,	#14
	ld	c, (hl)
	ldhl	sp,	#9
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00268$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00268$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#8
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00268$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	b, #0x00
	ldhl	sp,	#12
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
	jr	NC, 00269$
00268$:
	xor	a, a
	jr	00270$
00269$:
	ld	a, #0x01
00270$:
;geometry_boy.c:410: rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:411: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00277$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
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
	jr	C, 00277$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00277$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00278$
00277$:
	xor	a, a
	jr	00279$
00278$:
	ld	a, #0x01
00279$:
;geometry_boy.c:411: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 4, tile_y + 5) ||
	or	a, a
	jp	NZ, 00106$
;geometry_boy.c:412: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00286$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
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
	jr	C, 00286$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#25
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00286$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01064$
	bit	7, d
	jr	NZ, 01065$
	cp	a, a
	jr	01065$
01064$:
	bit	7, d
	jr	Z, 01065$
	scf
01065$:
	jr	NC, 00287$
00286$:
	xor	a, a
	jr	00288$
00287$:
	ld	a, #0x01
00288$:
;geometry_boy.c:412: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 2, tile_y + 3) ||
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:413: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00295$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
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
	jr	C, 00295$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00295$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00296$
00295$:
	xor	a, a
	jr	00297$
00296$:
	ld	a, #0x01
00297$:
;geometry_boy.c:413: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y, tile_y + 1)
	or	a, a
	jp	Z, 00228$
00106$:
;geometry_boy.c:415: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:416: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:417: player_x = (player_x / 8) * 8;
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
	jr	Z, 00304$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00304$:
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
;geometry_boy.c:418: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00170$:
;geometry_boy.c:422: else if (tile == INVERTED_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0a
	jp	NZ,00167$
;geometry_boy.c:425: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	ldhl	sp,	#27
	ld	c, (hl)
	ldhl	sp,	#9
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00305$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00305$
;geometry_boy.c:374: player_y <= y_bot &&
	ld	a, c
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00305$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00306$
00305$:
	ld	c, #0x00
	jr	00307$
00306$:
	ld	c, #0x01
00307$:
	ld	a, c
;geometry_boy.c:425: rect_collision_with_player(tile_x, tile_x + 7, tile_y, tile_y + 1) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:426: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00314$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00314$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00314$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00315$
00314$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00316$
00315$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00316$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:426: rect_collision_with_player(tile_x + 1, tile_x + 6, tile_y + 2, tile_y + 3) ||
	or	a, a
	jp	NZ, 00111$
;geometry_boy.c:427: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00323$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00323$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00323$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00324$
00323$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00325$
00324$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00325$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:427: rect_collision_with_player(tile_x +2, tile_x + 5, tile_y + 4, tile_y + 5) ||
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:428: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00332$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01078$
	bit	7, d
	jr	NZ, 01079$
	cp	a, a
	jr	01079$
01078$:
	bit	7, d
	jr	Z, 01079$
	scf
01079$:
	jr	C, 00332$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00332$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01080$
	bit	7, d
	jr	NZ, 01081$
	cp	a, a
	jr	01081$
01080$:
	bit	7, d
	jr	Z, 01081$
	scf
01081$:
	jr	NC, 00333$
00332$:
	ldhl	sp,	#28
	ld	(hl), #0x00
	jr	00334$
00333$:
	ldhl	sp,	#28
	ld	(hl), #0x01
00334$:
	ldhl	sp,	#28
	ld	a, (hl)
;geometry_boy.c:428: rect_collision_with_player(tile_x + 3, tile_x + 4, tile_y + 6, tile_y + 7)
	or	a, a
	jp	Z, 00228$
00111$:
;geometry_boy.c:430: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:431: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:432: player_x = (player_x / 8) * 8;
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
	jr	Z, 00341$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00341$:
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
;geometry_boy.c:433: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00167$:
;geometry_boy.c:437: else if (tile == BACK_SPIKE_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jp	NZ,00164$
;geometry_boy.c:440: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	ldhl	sp,	#16
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00342$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00342$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#20
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00342$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01084$
	bit	7, d
	jr	NZ, 01085$
	cp	a, a
	jr	01085$
01084$:
	bit	7, d
	jr	Z, 01085$
	scf
01085$:
	jr	NC, 00343$
00342$:
	xor	a, a
	jr	00344$
00343$:
	ld	a, #0x01
00344$:
;geometry_boy.c:440: rect_collision_with_player(tile_x, tile_x + 1, tile_y + 3, tile_y + 4) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:441: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00351$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	C, 00351$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#25
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00351$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01088$
	bit	7, d
	jr	NZ, 01089$
	cp	a, a
	jr	01089$
01088$:
	bit	7, d
	jr	Z, 01089$
	scf
01089$:
	jr	NC, 00352$
00351$:
	ldhl	sp,	#26
	ld	(hl), #0x00
	jr	00353$
00352$:
	ldhl	sp,	#26
	ld	(hl), #0x01
00353$:
	ldhl	sp,	#26
	ld	a, (hl)
;geometry_boy.c:441: rect_collision_with_player(tile_x + 2, tile_x + 3, tile_y + 2, tile_y + 5) ||
	or	a, a
	jp	NZ, 00116$
;geometry_boy.c:442: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, c
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00360$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01090$
	bit	7, d
	jr	NZ, 01091$
	cp	a, a
	jr	01091$
01090$:
	bit	7, d
	jr	Z, 01091$
	scf
01091$:
	jr	C, 00360$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00360$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00361$
00360$:
	ldhl	sp,	#27
	ld	(hl), #0x00
	jr	00362$
00361$:
	ldhl	sp,	#27
	ld	(hl), #0x01
00362$:
	ldhl	sp,	#27
	ld	a, (hl)
;geometry_boy.c:442: rect_collision_with_player(tile_x +4, tile_x + 5, tile_y + 1, tile_y + 6) ||
	or	a, a
	jr	NZ, 00116$
;geometry_boy.c:443: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#9
	ld	b, (hl)
	ldhl	sp,	#15
	ld	c, (hl)
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00369$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
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
	jr	C, 00369$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00369$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ldhl	sp,	#28
	bit	0, (hl)
	jr	Z, 00370$
00369$:
	ld	c, #0x00
	jr	00371$
00370$:
	ld	c, #0x01
00371$:
	ld	a, c
;geometry_boy.c:443: rect_collision_with_player(tile_x + 6, tile_x + 7, tile_y, tile_y + 7)
	or	a, a
	jp	Z, 00228$
00116$:
;geometry_boy.c:445: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:446: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:447: player_x = (player_x / 8) * 8;
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
	jr	Z, 00378$
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
00378$:
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
;geometry_boy.c:448: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00164$:
;geometry_boy.c:462: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	a, (#_player_y)
;geometry_boy.c:469: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ld	hl, #_player_x
	ld	c, (hl)
;geometry_boy.c:462: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	and	a, #0xf8
;geometry_boy.c:469: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	push	af
	ld	a, c
	and	a, #0xf8
	ldhl	sp,	#29
;geometry_boy.c:462: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ld	(hl+), a
	pop	af
	add	a, #0x08
	ld	(hl), a
;geometry_boy.c:452: else if (tile == BLACK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00161$
;geometry_boy.c:454: if (vel_y > 0)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:456: player_y = player_y & 0xF8; //(player_y / 8) * 8;
	ld	hl, #_player_y
	ld	a, (hl)
	and	a, #0xf8
	ld	(hl), a
;geometry_boy.c:457: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:458: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00228$
00125$:
;geometry_boy.c:460: else if (vel_y < 0)
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:462: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00228$
00122$:
;geometry_boy.c:467: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:468: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:469: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:470: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00161$:
;geometry_boy.c:474: else if (tile == HALF_BLOCK_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jp	NZ,00158$
;geometry_boy.c:476: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#26
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,	#9
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00379$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00379$
;geometry_boy.c:374: player_y <= y_bot &&
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00379$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01100$
	bit	7, d
	jr	NZ, 01101$
	cp	a, a
	jr	01101$
01100$:
	bit	7, d
	jr	Z, 01101$
	scf
01101$:
	jr	NC, 00380$
00379$:
	ld	c, #0x00
	jr	00381$
00380$:
	ld	c, #0x01
00381$:
	ld	a, c
;geometry_boy.c:476: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 4, tile_y + 7))
	or	a, a
	jp	Z, 00228$
;geometry_boy.c:478: if (vel_y > 0)
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:480: player_y = tile_y - 4;
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0xfc
	ld	(#_player_y),a
;geometry_boy.c:481: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:482: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00228$
00131$:
;geometry_boy.c:484: else if (vel_y < 0)
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:486: player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(#_player_y),a
	jp	00228$
00128$:
;geometry_boy.c:491: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:492: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:493: player_x = player_x & 0xF8; //(player_x / 8) * 8;
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(#_player_x),a
;geometry_boy.c:494: lose = 1;
	ld	hl, #_lose
	ld	(hl), #0x01
	jp	00228$
00158$:
;geometry_boy.c:499: else if (tile == JUMP_TILE_TILE)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00155$
;geometry_boy.c:501: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#9
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, (hl)
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00388$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00388$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00388$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	NC, 00389$
00388$:
	ld	c, #0x00
	jr	00390$
00389$:
	ld	c, #0x01
00390$:
	ld	a, c
;geometry_boy.c:501: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0)
	or	a, a
	jp	Z, 00228$
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00228$
;geometry_boy.c:503: player_dy = -PLAYER_SUPER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xf7
	jp	00228$
00155$:
;geometry_boy.c:506: else if (tile == JUMP_CIRCLE_TILE) // jump circle , hitbox is 4x4 square in center
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00152$
;geometry_boy.c:508: if (jpad == J_UP && vel_y == 0)
	ld	a, (#_jpad)
	sub	a, #0x04
	jp	NZ,00228$
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00228$
;geometry_boy.c:510: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, b
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00397$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	b, #0x00
	ldhl	sp,	#10
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
	jr	C, 00397$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#28
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00397$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01112$
	bit	7, d
	jr	NZ, 01113$
	cp	a, a
	jr	01113$
01112$:
	bit	7, d
	jr	Z, 01113$
	scf
01113$:
	jr	NC, 00398$
00397$:
	xor	a, a
	jr	00399$
00398$:
	ld	a, #0x01
00399$:
;geometry_boy.c:510: if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5))
	or	a, a
	jr	Z, 00228$
;geometry_boy.c:512: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
	jr	00228$
00152$:
;geometry_boy.c:515: } else if (tile == SHIP_PORTAL_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0b
	jr	NZ, 00149$
;geometry_boy.c:516: current_vehicle = SHIP;
	ld	hl, #_current_vehicle
	ld	(hl), #0x01
	jr	00228$
00149$:
;geometry_boy.c:517: } else if (tile == CUBE_PORTAL_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0d
	jr	NZ, 00146$
;geometry_boy.c:518: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
	jr	00228$
00146$:
;geometry_boy.c:520: else if (tile == WIN_TILE){
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00228$
;geometry_boy.c:521: player_dx = 0;
	ld	hl, #_player_dx
	ld	(hl), #0x00
;geometry_boy.c:522: player_dy = 0;
	ld	hl, #_player_dy
	ld	(hl), #0x00
;geometry_boy.c:523: player_x = (player_x / 8) * 8;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00406$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00406$:
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
;geometry_boy.c:524: win = 1;
	ld	hl, #_win
	ld	(hl), #0x01
00228$:
;geometry_boy.c:383: for (uint8_t i = 0; i < 4; i++)
	ldhl	sp,	#29
	inc	(hl)
	jp	00227$
00175$:
;geometry_boy.c:528: if (vel_y == 0)
	ldhl	sp,	#32
	ld	a, (hl)
	or	a, a
	jp	NZ, 00229$
;geometry_boy.c:530: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	ldhl	sp,	#25
	ld	a, (hl)
	add	a, #0x08
	ld	c, a
	ldhl	sp,	#28
	ld	a, (hl+)
	add	a, #0x07
	ld	(hl), a
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#26
	add	a, (hl)
	ldhl	sp,	#29
;geometry_boy.c:339: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:530: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jp	Z,00184$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#27
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:339: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:530: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == BLACK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == BLACK_TILE)
	sub	a, #0x03
	jr	NZ, 00185$
00184$:
;geometry_boy.c:532: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jp	00229$
00185$:
;geometry_boy.c:537: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	ld	a, (#_player_y)
	add	a, #0x08
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (#_player_x)
	add	a, #0x07
	ldhl	sp,	#27
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:339: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:537: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	Z,00181$
	ld	a, (#_player_y)
	add	a, #0x08
	ld	c, a
	ld	a, (#_player_x)
	ldhl	sp,	#27
;geometry_boy.c:344: return (y_px - YOFF) >> 3;
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	a, (#_background_x_shift)
	ldhl	sp,	#29
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
;geometry_boy.c:339: return (x_px - XOFF) >> 3; // >> 3 is the same as /8
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
;geometry_boy.c:350: x_px_to_tile_ind(x_px + background_x_shift),
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_get_bkg_tile_xy
	pop	hl
	ld	a, e
;geometry_boy.c:537: if (get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == HALF_BLOCK_TILE)
	sub	a, #0x08
	jp	NZ,00229$
00181$:
;geometry_boy.c:539: tile_x = (player_x)&0xF8;
	ld	a, (#_player_x)
	and	a, #0xf8
	ld	e, a
;geometry_boy.c:540: tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
	ld	a, (#_player_y)
	add	a, #0x08
	and	a, #0xf8
;geometry_boy.c:541: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
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
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #_player_x
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
	ld	a, (#_player_y)
	ldhl	sp,	#26
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
	ld	hl, #0x0007
	add	hl, bc
	ld	c, l
	ld	b, h
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00407$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01126$
	bit	7, d
	jr	NZ, 01127$
	cp	a, a
	jr	01127$
01126$:
	bit	7, d
	jr	Z, 01127$
	scf
01127$:
	jr	C, 00407$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#23
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00407$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01128$
	bit	7, d
	jr	NZ, 01129$
	cp	a, a
	jr	01129$
01128$:
	bit	7, d
	jr	Z, 01129$
	scf
01129$:
	jr	NC, 00408$
00407$:
	xor	a, a
	jr	00409$
00408$:
	ld	a, #0x01
00409$:
;geometry_boy.c:541: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00179$
;geometry_boy.c:543: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
	jr	00229$
00179$:
;geometry_boy.c:547: tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
	ld	a, (#_player_x)
	add	a, #0x07
	and	a, #0xf8
;geometry_boy.c:548: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
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
;geometry_boy.c:372: player_x <= x_right &&
	ld	a, d
	ld	hl, #_player_x
	sub	a, (hl)
	jr	C, 00416$
;geometry_boy.c:373: player_x + PLAYER_WIDTH - 1 >= x_left &&
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
	jr	Z, 01130$
	bit	7, d
	jr	NZ, 01131$
	cp	a, a
	jr	01131$
01130$:
	bit	7, d
	jr	Z, 01131$
	scf
01131$:
	jr	C, 00416$
;geometry_boy.c:374: player_y <= y_bot &&
	ldhl	sp,	#27
	ld	a, (hl)
	ld	hl, #_player_y
	sub	a, (hl)
	jr	C, 00416$
;geometry_boy.c:375: player_y + PLAYER_WIDTH - 1 >= y_top);
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
	jr	Z, 01132$
	bit	7, d
	jr	NZ, 01133$
	cp	a, a
	jr	01133$
01132$:
	bit	7, d
	jr	Z, 01133$
	scf
01133$:
	jr	NC, 00417$
00416$:
	xor	a, a
	jr	00418$
00417$:
	ld	a, #0x01
00418$:
;geometry_boy.c:548: if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 3, tile_y + 7))
	or	a, a
	jr	Z, 00229$
;geometry_boy.c:550: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
00229$:
;geometry_boy.c:556: }
	add	sp, #30
	ret
;geometry_boy.c:558: void tick_player()
;	---------------------------------
; Function tick_player
; ---------------------------------
_tick_player::
;geometry_boy.c:567: } else if (current_vehicle == SHIP) {
	ld	a, (#_current_vehicle)
	dec	a
	ld	a, #0x01
	jr	Z, 00176$
	xor	a, a
00176$:
	ld	c, a
;geometry_boy.c:560: if (jpad == J_UP)
	ld	a, (#_jpad)
	sub	a, #0x04
	jr	NZ, 00109$
;geometry_boy.c:562: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00106$
;geometry_boy.c:563: if (on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	Z, 00109$
;geometry_boy.c:565: player_dy = -PLAYER_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfa
	jr	00109$
00106$:
;geometry_boy.c:567: } else if (current_vehicle == SHIP) {
	ld	a, c
	or	a, a
	jr	Z, 00109$
;geometry_boy.c:568: player_dy = -SHIP_JUMP_VEL;
	ld	hl, #_player_dy
	ld	(hl), #0xfd
00109$:
;geometry_boy.c:571: if (!on_ground)
	ld	a, (#_on_ground)
	or	a, a
	jr	NZ, 00122$
;geometry_boy.c:574: player_dy += GRAVITY;
	ld	hl, #_player_dy
	ld	b, (hl)
	inc	b
;geometry_boy.c:573: if (current_vehicle == CUBE){
	ld	hl, #_current_vehicle
	ld	a, (hl)
	or	a, a
	jr	NZ, 00119$
;geometry_boy.c:574: player_dy += GRAVITY;
	ld	hl, #_player_dy
	ld	(hl), b
;geometry_boy.c:575: if (player_dy > CUBE_MAX_FALL_SPEED)
	ld	e, (hl)
	ld	a,#0x07
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00179$
	bit	7, d
	jr	NZ, 00180$
	cp	a, a
	jr	00180$
00179$:
	bit	7, d
	jr	Z, 00180$
	scf
00180$:
	jr	NC, 00122$
;geometry_boy.c:576: player_dy = CUBE_MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x07
	jr	00122$
00119$:
;geometry_boy.c:577: } else if (current_vehicle == SHIP){
	ld	a, c
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:578: if (tick % 2 == 0){
	push	hl
	ld	hl, #_tick
	bit	0, (hl)
	pop	hl
	jr	NZ, 00113$
;geometry_boy.c:579: player_dy += GRAVITY;
	ld	hl, #_player_dy
	ld	(hl), b
00113$:
;geometry_boy.c:581: if (player_dy > SHIP_MAX_FALL_SPEED)
	ld	hl, #_player_dy
	ld	e, (hl)
	ld	a,#0x04
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00183$
	bit	7, d
	jr	NZ, 00184$
	cp	a, a
	jr	00184$
00183$:
	bit	7, d
	jr	Z, 00184$
	scf
00184$:
	jr	NC, 00122$
;geometry_boy.c:582: player_dy = SHIP_MAX_FALL_SPEED;
	ld	hl, #_player_dy
	ld	(hl), #0x04
00122$:
;geometry_boy.c:586: collide(0);
	xor	a, a
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:588: player_y += player_dy;
	ld	a, (#_player_y)
	ld	hl, #_player_dy
	add	a, (hl)
	ld	(#_player_y),a
;geometry_boy.c:591: on_ground = 0;
	ld	hl, #_on_ground
	ld	(hl), #0x00
;geometry_boy.c:593: collide(player_dy);
	ld	a, (#_player_dy)
	push	af
	inc	sp
	call	_collide
	inc	sp
;geometry_boy.c:594: }
	ret
;geometry_boy.c:607: void initialize_player()
;	---------------------------------
; Function initialize_player
; ---------------------------------
_initialize_player::
;geometry_boy.c:609: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:610: set_sprite_data(0, 1, players + (player_sprite_num << 4)); // cube
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
;geometry_boy.c:611: set_sprite_data(1, 1, gb_tileset_v2 + (11<<4));  // ship
	ld	de, #(_gb_tileset_v2 + 176)
	push	de
	ld	hl, #0x101
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:612: SWITCH_ROM_MBC1(saved_bank);
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
;geometry_boy.c:614: set_sprite_tile(1, 1);
;geometry_boy.c:615: }
	ret
;geometry_boy.c:617: void skip_to(uint16_t background_x, uint8_t char_y) {
;	---------------------------------
; Function skip_to
; ---------------------------------
_skip_to::
	add	sp, #-10
;geometry_boy.c:619: while (background_x_shift < background_x){
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
;geometry_boy.c:620: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:621: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
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
;geometry_boy.c:278: background_x_shift = (background_x_shift + x_shift);
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
;geometry_boy.c:279: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00107$
;geometry_boy.c:282: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
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
;geometry_boy.c:283: count = (background_x_shift >> 3) - 1;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	dec	de
	ld	hl, #_count
	ld	a, e
	ld	(hl+), a
;geometry_boy.c:284: count = (count + 32) % map_width;
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
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00128$:
;geometry_boy.c:288: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
;geometry_boy.c:289: count += map_width;
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
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00128$
;geometry_boy.c:621: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
00107$:
;geometry_boy.c:622: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:232: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
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
;geometry_boy.c:233: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;geometry_boy.c:234: if (px_progress_bar >= old_px_progress_bar)
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
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:237: while (px_progress_bar > 8)
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
;geometry_boy.c:239: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:240: px_progress_bar -= 8;
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
;geometry_boy.c:242: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
	ld	a, (#_px_progress_bar)
	add	a, #0x34
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
;geometry_boy.c:246: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:247: while (render_col < NUM_PROGRESS_BAR_TILES)
00112$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jp	NC, 00101$
;geometry_boy.c:249: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3401
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:250: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00112$
;geometry_boy.c:623: update_HUD_bar();
00103$:
;geometry_boy.c:625: player_y = char_y;
	ldhl	sp,	#14
	ld	a, (hl)
	ld	hl, #_player_y
	ld	(hl), a
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
	ld	c, (hl)
	ld	hl, #_player_x
	ld	b, (hl)
;geometry_boy.c:598: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00125$
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
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
;geometry_boy.c:600: move_sprite(1, 0, 0);
	jr	00130$
00125$:
;geometry_boy.c:601: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00130$
;geometry_boy.c:602: move_sprite(1, player_x, player_y);
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
;geometry_boy.c:626: render_player();
00130$:
;geometry_boy.c:627: }
	add	sp, #10
	ret
;geometry_boy.c:629: screen_t game()
;	---------------------------------
; Function game
; ---------------------------------
_game::
	add	sp, #-8
;geometry_boy.c:631: gbt_play(song_Data, musicBank, 1);
	ld	hl, #0x103
	push	hl
	ld	de, #_song_Data
	push	de
	call	_gbt_play
	add	sp, #4
;geometry_boy.c:632: gbt_loop(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_gbt_loop
	inc	sp
;geometry_boy.c:633: STAT_REG |= 0x40; // enable LYC=LY interrupt
	ldh	a, (_STAT_REG + 0)
	or	a, #0x40
	ldh	(_STAT_REG + 0), a
;geometry_boy.c:634: LYC_REG = 16;     // the scanline on which to trigger
	ld	a, #0x10
	ldh	(_LYC_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:636: add_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_add_LCD
	pop	hl
;geometry_boy.c:637: add_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:639: set_interrupts(LCD_IFLAG | VBL_IFLAG);
	ld	a, #0x03
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:641: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:643: initialize_player();
	call	_initialize_player
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
	ld	hl, #_player_y
	ld	c, (hl)
	ld	hl, #_player_x
	ld	b, (hl)
;geometry_boy.c:598: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00130$
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
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
;geometry_boy.c:600: move_sprite(1, 0, 0);
	jr	00132$
00130$:
;geometry_boy.c:601: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:602: move_sprite(1, player_x, player_y);
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
;geometry_boy.c:644: render_player(); // render at initial position
00132$:
;geometry_boy.c:645: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:155: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:156: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xe00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:157: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240e
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:158: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:159: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x133
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:160: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x934
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:161: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:649: current_attempts = 0;
	xor	a, a
	ld	hl, #_current_attempts
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:197: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00205$:
;geometry_boy.c:199: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00203$:
;geometry_boy.c:201: set_win_tile_xy(render_col, render_row, BLACK_TILE);
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
;geometry_boy.c:199: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00203$
;geometry_boy.c:197: for (render_row = 0; render_row < 3; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00205$
;geometry_boy.c:204: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00207$:
;geometry_boy.c:206: set_win_tile_xy(render_col, 0, LETTER_TILES + (attempts_title[render_col] - 65));
	ld	a, #<(_attempts_title)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_title)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:204: for (render_col = 0; render_col < 7; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jr	C, 00207$
;geometry_boy.c:208: set_win_tile_xy(7, 0, COLON_TILE); // colon
	ld	a, #0x32
	push	af
	inc	sp
	ld	hl, #0x07
	push	hl
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:209: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x08
00209$:
;geometry_boy.c:211: set_win_tile_xy(render_col, 0, NUMBER_TILES);
	ld	a, #0x0e
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
;geometry_boy.c:209: for (render_col = 8; render_col < 11; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0b
	jr	C, 00209$
;geometry_boy.c:213: old_px_progress_bar = 0;
	xor	a, a
	ld	hl, #_old_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:214: px_progress_bar = 0;
	xor	a, a
	ld	hl, #_px_progress_bar
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:652: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:653: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:655: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:656: init_background(level_maps[level_ind], level_widths[level_ind]);
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
;geometry_boy.c:657: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:658: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:659: set_bkg_data(CUBE_PORTAL_TILE, 1, players + (player_sprite_num << 4));     // load tiles into VRAM
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
	ld	hl, #0x10d
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:660: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:667: while (1)
00119$:
;geometry_boy.c:669: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00102$
;geometry_boy.c:671: wait_vbl_done();
	call	_wait_vbl_done
00102$:
;geometry_boy.c:673: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:675: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:676: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:678: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ld	hl, #_jpad
	ld	c, (hl)
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:678: if (debounce_input(J_B, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jp	Z, 00106$
;geometry_boy.c:680: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:681: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:682: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
;geometry_boy.c:684: *(px_progress[level_ind]) = background_x_shift + player_x;
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	inc	hl
	ld	(hl), b
00104$:
;geometry_boy.c:686: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:688: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:689: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:691: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:692: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:598: if (current_vehicle == CUBE){
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
;geometry_boy.c:600: move_sprite(1, 0, 0);
	jr	00152$
00150$:
;geometry_boy.c:601: } else if (current_vehicle == SHIP){
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
;geometry_boy.c:693: render_player();
00152$:
;geometry_boy.c:694: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:695: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:696: gbt_stop();
	call	_gbt_stop
;geometry_boy.c:697: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00215$
00106$:
;geometry_boy.c:700: tick_player();
	call	_tick_player
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
	ld	hl, #_player_y
	ld	c, (hl)
	ld	hl, #_player_x
	ld	e, (hl)
;geometry_boy.c:598: if (current_vehicle == CUBE){
	ld	a, (#_current_vehicle)
	or	a, a
	jr	NZ, 00160$
;geometry_boy.c:599: move_sprite(0, player_x, player_y);
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
;geometry_boy.c:600: move_sprite(1, 0, 0);
	jr	00162$
00160$:
;geometry_boy.c:601: } else if (current_vehicle == SHIP){
	ld	a, (#_current_vehicle)
	dec	a
	jr	NZ, 00162$
;geometry_boy.c:602: move_sprite(1, player_x, player_y);
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
;geometry_boy.c:701: render_player();
00162$:
;geometry_boy.c:703: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:704: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
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
;geometry_boy.c:278: background_x_shift = (background_x_shift + x_shift);
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
;geometry_boy.c:279: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00166$
;geometry_boy.c:282: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
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
;geometry_boy.c:283: count = (background_x_shift >> 3) - 1;
	dec	bc
	ld	hl, #_count
	ld	a, c
	ld	(hl+), a
;geometry_boy.c:284: count = (count + 32) % map_width;
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
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00211$:
;geometry_boy.c:288: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
;geometry_boy.c:289: count += map_width;
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
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00211$
;geometry_boy.c:704: scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
00166$:
;geometry_boy.c:705: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:232: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
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
;geometry_boy.c:233: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:234: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00174$
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:237: while (px_progress_bar > 8)
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
;geometry_boy.c:239: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:240: px_progress_bar -= 8;
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
;geometry_boy.c:242: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
	ld	a, (#_px_progress_bar)
	add	a, #0x34
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
;geometry_boy.c:246: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:247: while (render_col < NUM_PROGRESS_BAR_TILES)
00171$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00176$
;geometry_boy.c:249: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3401
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:250: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00171$
;geometry_boy.c:707: update_HUD_bar();
00176$:
;geometry_boy.c:709: if (lose)
	ld	a, (#_lose)
	or	a, a
	jp	Z, 00114$
;geometry_boy.c:711: SWITCH_ROM_MBC1(level_banks[level_ind]);
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
;geometry_boy.c:712: init_background(level_maps[level_ind], level_widths[level_ind]);
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
;geometry_boy.c:713: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:714: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:715: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:716: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
;geometry_boy.c:718: *(px_progress[level_ind]) = background_x_shift + player_x;
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00108$:
;geometry_boy.c:720: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:722: current_attempts++;
	ld	hl, #_current_attempts
	inc	(hl)
	jr	NZ, 00432$
	inc	hl
	inc	(hl)
00432$:
;geometry_boy.c:219: uint16_t temp = current_attempts;
	ld	a, (#_current_attempts)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (#_current_attempts + 1)
	ldhl	sp,	#7
	ld	(hl), a
;geometry_boy.c:220: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	ld	(hl), #0x0a
00213$:
;geometry_boy.c:222: set_win_tile_xy(render_col, 0, temp % 10 + NUMBER_TILES);
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
	add	a, #0x0e
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
;geometry_boy.c:223: temp = temp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #4
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;geometry_boy.c:220: for (render_col = 10; render_col >= 8; render_col--)
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00213$
;geometry_boy.c:232: px_progress_bar = NUM_PROGRESS_BAR_TILES * (background_x_shift + player_x) / (level_widths[level_ind] - LEVEL_END_OFFSET); 
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
;geometry_boy.c:233: render_col = 0;
	ld	hl, #_render_col
	ld	(hl), #0x00
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_px_progress_bar
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;geometry_boy.c:234: if (px_progress_bar >= old_px_progress_bar)
	ld	de, #_px_progress_bar
	ld	hl, #_old_px_progress_bar
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00187$
;geometry_boy.c:236: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:237: while (px_progress_bar > 8)
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
;geometry_boy.c:239: render_col++;
	ld	hl, #_render_col
	inc	(hl)
;geometry_boy.c:240: px_progress_bar -= 8;
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
;geometry_boy.c:242: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES + px_progress_bar);
	ld	a, (#_px_progress_bar)
	add	a, #0x34
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
;geometry_boy.c:246: old_px_progress_bar = px_progress_bar;
	ld	hl, #_old_px_progress_bar
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;geometry_boy.c:247: while (render_col < NUM_PROGRESS_BAR_TILES)
00184$:
	ld	hl, #_render_col
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00189$
;geometry_boy.c:249: set_win_tile_xy(render_col, 1, PROGRESS_BAR_TILES);
	ld	de, #0x3401
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;geometry_boy.c:250: render_col++;
	ld	hl, #_render_col
	inc	(hl)
	jr	00184$
;geometry_boy.c:724: update_HUD_bar();
00189$:
;geometry_boy.c:725: wait_vbl_done();
	call	_wait_vbl_done
	jp	00115$
00114$:
;geometry_boy.c:732: } else if (win){
	ld	hl, #_win
	ld	a, (hl)
	or	a, a
	jp	Z, 00115$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:734: remove_LCD(lcd_interrupt_game);
	ld	de, #_lcd_interrupt_game
	push	de
	call	_remove_LCD
	pop	hl
;geometry_boy.c:735: remove_VBL(vbl_interrupt_game);
	ld	de, #_vbl_interrupt_game
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:737: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:738: *(attempts[level_ind]) = *(attempts[level_ind])+1;
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
;geometry_boy.c:739: if (background_x_shift + player_x > *(px_progress[level_ind]))
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
;geometry_boy.c:741: *(px_progress[level_ind]) = (level_widths[level_ind] - LEVEL_END_OFFSET) << 3;
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
;geometry_boy.c:743: player_x = 0;
	ld	hl, #_player_x
	ld	(hl), #0x00
;geometry_boy.c:744: player_y = 0;
	ld	hl, #_player_y
	ld	(hl), #0x00
;geometry_boy.c:598: if (current_vehicle == CUBE){
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
;geometry_boy.c:600: move_sprite(1, 0, 0);
	jr	00201$
00199$:
;geometry_boy.c:601: } else if (current_vehicle == SHIP){
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
;geometry_boy.c:745: render_player();
00201$:
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:747: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:748: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:749: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:750: gbt_stop();
	call	_gbt_stop
;geometry_boy.c:751: return LEVEL_SELECT;
	ld	e, #0x02
	jp	00215$
00115$:
;geometry_boy.c:754: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:755: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00117$
;geometry_boy.c:757: parallax_tile_ind = 0;
	ld	(hl), #0x00
00117$:
;geometry_boy.c:759: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:760: set_bkg_data(WHITE_TILE, 1, parallax_tileset_v2 + parallax_tile_ind);     // load tiles into VRAM
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
;geometry_boy.c:761: set_bkg_data(SMALL_SPIKE_TILE, 1, small_spike_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:762: set_bkg_data(BIG_SPIKE_TILE, 1, big_spike_parallax + parallax_tile_ind);    // load tiles into VRAM
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
;geometry_boy.c:763: set_bkg_data(HALF_BLOCK_TILE, 1, half_block_parallax + parallax_tile_ind);  // load tiles into VRAM
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
;geometry_boy.c:764: set_bkg_data(JUMP_CIRCLE_TILE, 1, jump_circle_parallax + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:765: set_bkg_data(JUMP_TILE_TILE, 1, jump_tile_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:766: set_bkg_data(INVERTED_SPIKE_TILE, 1, down_spike_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:767: set_bkg_data(SHIP_PORTAL_TILE, 1, ship_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:768: set_bkg_data(BACK_SPIKE_TILE, 1, back_spike_parallax + parallax_tile_ind);   // load tiles into VRAM
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
;geometry_boy.c:769: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:771: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:772: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:773: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
;geometry_boy.c:774: gbt_update(); // This will change to ROM bank 1. Basically play the music
	call	_gbt_update
;geometry_boy.c:775: delay(8);     // LOOP_DELAY
	ld	de, #0x0008
	push	de
	call	_delay
	pop	hl
	jp	00119$
00215$:
;geometry_boy.c:777: }
	add	sp, #8
	ret
;geometry_boy.c:804: screen_t title()
;	---------------------------------
; Function title
; ---------------------------------
_title::
	add	sp, #-9
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:807: add_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_add_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:809: set_interrupts(VBL_IFLAG);
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;geometry_boy.c:810: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:155: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:156: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xe00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:157: set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
	ld	de, #(_aero + 48)
	push	de
	ld	hl, #0x240e
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:158: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
	ld	de, #(_aero + 752)
	push	de
	ld	hl, #0x132
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:159: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
	ld	de, #(_aero + 1072)
	push	de
	ld	hl, #0x133
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:160: set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
	ld	de, #_progress_bar_tiles
	push	de
	ld	hl, #0x934
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:161: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:815: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:816: init_background(title_map_v2, title_map_v2Width);
	ld	de, #0x003c
	push	de
	ld	de, #_title_map_v2
	push	de
	call	_init_background
	add	sp, #4
;geometry_boy.c:817: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:820: if (title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	Z, 00109$
;geometry_boy.c:822: for (int i = 0; i < 11; i++)
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
;geometry_boy.c:824: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:825: set_sprite_data(TITLE_OAM + i, 1, nima + 16 * (13 + game_title[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:826: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:827: set_sprite_tile(TITLE_OAM + i, TITLE_OAM + i);
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
;geometry_boy.c:828: if (i > 7)
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
;geometry_boy.c:830: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
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
;geometry_boy.c:830: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00202$
00102$:
;geometry_boy.c:834: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
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
;geometry_boy.c:834: move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
00202$:
;geometry_boy.c:822: for (int i = 0; i < 11; i++)
	ldhl	sp,	#7
	inc	(hl)
	jp	NZ,00201$
	inc	hl
	inc	(hl)
	jp	00201$
00104$:
;geometry_boy.c:837: for (uint8_t i = 0; i < 6; i++)
	ld	c, #0x00
00204$:
;geometry_boy.c:840: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00107$
	sub	a, #0x05
	jr	NC, 00106$
;geometry_boy.c:842: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:843: set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:844: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:845: set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
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
;geometry_boy.c:846: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
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
;geometry_boy.c:846: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00106$:
;geometry_boy.c:848: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:849: set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
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
;geometry_boy.c:850: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:851: set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
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
;geometry_boy.c:852: move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
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
;geometry_boy.c:837: for (uint8_t i = 0; i < 6; i++)
	inc	c
	jp	00204$
00107$:
;geometry_boy.c:855: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:856: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:857: SWITCH_ROM_MBC1(saved_bank);
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
;geometry_boy.c:861: scroll_sprite(TITLE_OAM + 10, 0, -2);
00109$:
;geometry_boy.c:864: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:865: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:867: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:869: uint8_t title_index = 0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;geometry_boy.c:871: while (1)
00155$:
;geometry_boy.c:873: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00111$
;geometry_boy.c:875: wait_vbl_done();
	call	_wait_vbl_done
00111$:
;geometry_boy.c:877: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:879: SWITCH_ROM_MBC1(title_map_v2Bank);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x03
;geometry_boy.c:880: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
	ld	a, (#_player_dx)
;geometry_boy.c:278: background_x_shift = (background_x_shift + x_shift);
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
;geometry_boy.c:279: if (background_x_shift >= old_background_x_shift)
	ld	de, #_background_x_shift
	ld	hl, #_old_background_x_shift
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	C, 00174$
;geometry_boy.c:282: old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; // old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
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
;geometry_boy.c:283: count = (background_x_shift >> 3) - 1;
	dec	bc
	ld	hl, #_count
	ld	a, c
	ld	(hl+), a
;geometry_boy.c:284: count = (count + 32) % map_width;
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
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00206$:
;geometry_boy.c:288: set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
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
;geometry_boy.c:289: count += map_width;
	ld	hl, #_count
	ld	a, (hl)
	add	a, #0x3c
	ld	(hl+), a
	ld	a, (hl)
	adc	a, #0x00
	ld	(hl), a
;geometry_boy.c:285: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00206$
;geometry_boy.c:880: scroll_bkg_x(player_dx, title_map_v2, title_map_v2Width);
00174$:
;geometry_boy.c:881: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:883: parallax_tile_ind += 16;
	ld	hl, #_parallax_tile_ind
	ld	a, (hl)
	add	a, #0x10
	ld	(hl), a
;geometry_boy.c:884: if (parallax_tile_ind > 112)
	ld	a, #0x70
	sub	a, (hl)
	jr	NC, 00113$
;geometry_boy.c:886: parallax_tile_ind = 0;
	ld	(hl), #0x00
00113$:
;geometry_boy.c:888: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:889: set_bkg_data(WHITE_TILE, 1, parallax_tileset_v2 + parallax_tile_ind); // load tiles into VRAM
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
;geometry_boy.c:890: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:899: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#5
	ld	a, (hl-)
	ld	(hl), a
;geometry_boy.c:894: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:899: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:892: if (!title_loaded)
	ld	a, (#_title_loaded)
	or	a, a
	jp	NZ, 00152$
;geometry_boy.c:894: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00153$
;geometry_boy.c:896: if (title_index < 11)
	dec	hl
	ld	a, (hl)
	sub	a, #0x0b
	jp	NC, 00246$
;geometry_boy.c:898: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:899: set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
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
;geometry_boy.c:900: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:901: set_sprite_tile(TITLE_OAM + title_index, TITLE_OAM + title_index);
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
;geometry_boy.c:902: if (title_index > 7)
	ld	a, #0x07
	ldhl	sp,	#5
	sub	a, (hl)
	jr	NC, 00115$
;geometry_boy.c:904: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
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
;geometry_boy.c:904: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
	jr	00116$
00115$:
;geometry_boy.c:908: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
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
;geometry_boy.c:908: move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
00116$:
;geometry_boy.c:910: title_index = title_index + 1;
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	jp	00153$
;geometry_boy.c:914: for (uint8_t i = 0; i < 6; i++)
00246$:
	ld	c, #0x00
00209$:
;geometry_boy.c:917: if (i < 5)
	ld	a,c
	cp	a,#0x06
	jp	NC,00119$
	sub	a, #0x05
	jr	NC, 00118$
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
;geometry_boy.c:923: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
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
;geometry_boy.c:923: move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
00118$:
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
	jp	00209$
00119$:
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
;geometry_boy.c:939: title_loaded = 1;
	ld	hl, #_title_loaded
	ld	(hl), #0x01
;geometry_boy.c:940: title_index = 0;
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
;geometry_boy.c:941: scroll_sprite(TITLE_OAM + 10, 0, -2);
	jp	00153$
00152$:
;geometry_boy.c:948: if (tick % 4 == 0)
	ldhl	sp,	#7
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00129$
;geometry_boy.c:950: if (title_index == 0)
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00126$
;geometry_boy.c:952: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:953: scroll_sprite(TITLE_OAM + 10, 0, +2);
	jr	00127$
00126$:
;geometry_boy.c:957: scroll_sprite(TITLE_OAM + title_index, 0, -2);
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
;geometry_boy.c:958: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
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
;geometry_boy.c:958: scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
00127$:
;geometry_boy.c:960: title_index = (title_index + 1) % 11;
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
;geometry_boy.c:963: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:964: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:966: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#6
	ld	(hl), a
;geometry_boy.c:963: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#7
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:966: if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00133$
;geometry_boy.c:968: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
	jr	00134$
00133$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:970: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00134$
;geometry_boy.c:972: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
00134$:
;geometry_boy.c:975: if (cursor_title_position != cursor_title_position_old)
	ld	a, (#_cursor_title_position)
	ld	hl, #_cursor_title_position_old
	sub	a, (hl)
	jr	Z, 00149$
;geometry_boy.c:977: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00138$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x68
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:979: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
	jr	00139$
00138$:
;geometry_boy.c:981: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00139$
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 40)
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	a, #0x78
	ld	(hl+), a
	ld	(hl), #0x30
;geometry_boy.c:983: move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
00139$:
;geometry_boy.c:985: cursor_title_position_old = cursor_title_position;
	ld	a, (#_cursor_title_position)
	ld	(#_cursor_title_position_old),a
	jp	00153$
00149$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:988: else if (debounce_input(J_SELECT, jpad, prev_jpad))
	or	a, a
	jp	Z, 00153$
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:309: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:310: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:311: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:312: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00213$:
;geometry_boy.c:314: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00211$:
;geometry_boy.c:316: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:314: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00211$
;geometry_boy.c:312: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00213$
;geometry_boy.c:992: remove_VBL(vbl_interrupt_title);
	ld	de, #_vbl_interrupt_title
	push	de
	call	_remove_VBL
	inc	sp
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:994: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:994: for (uint8_t i = 0; i < 40; i++)
	inc	c
	jr	00216$
00140$:
;geometry_boy.c:998: if (cursor_title_position == 0)
	ld	a, (#_cursor_title_position)
	or	a, a
	jr	NZ, 00144$
;geometry_boy.c:1000: cursor_title_position_old = 1; // force a change the next time title runs
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x01
;geometry_boy.c:1001: return LEVEL_SELECT;
	ld	e, #0x02
	jr	00218$
00144$:
;geometry_boy.c:1003: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00153$
;geometry_boy.c:1005: cursor_title_position_old = 0;
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
;geometry_boy.c:1006: return PLAYER_SELECT;
	ld	e, #0x03
	jr	00218$
00153$:
;geometry_boy.c:1011: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:1013: delay(LOOP_DELAY);    // LOOP_DELAY
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00155$
00218$:
;geometry_boy.c:1015: }
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
;geometry_boy.c:1022: screen_t player_select()
;	---------------------------------
; Function player_select
; ---------------------------------
_player_select::
	add	sp, #-9
;geometry_boy.c:1025: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:309: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:310: set_bkg_data(0, 1, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:311: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:312: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00153$:
;geometry_boy.c:314: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00151$:
;geometry_boy.c:316: set_bkg_tile_xy(render_col, render_row, 0);
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
;geometry_boy.c:314: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00151$
;geometry_boy.c:312: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00153$
;geometry_boy.c:1029: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1031: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors + 16); // Load into VRAM
	ld	de, #(_aero_cursors + 16)
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1033: set_sprite_data(PLAYER_SPRITES_OAM, 16, players); // Load into VRAM
	ld	de, #_players
	push	de
	ld	hl, #0x100b
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1034: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;../gbdk/include/gb/gb.h:1326: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 42)
	ld	(hl), #0x0a
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1038: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1043: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	ld	(hl), #0x00
00156$:
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00101$
;geometry_boy.c:1045: set_sprite_tile(PLAYER_SPRITES_OAM + i, PLAYER_SPRITES_OAM + i);
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
;geometry_boy.c:1048: ((i / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1047: ((i % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	and	a, #0x03
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1046: move_sprite(PLAYER_SPRITES_OAM + i,
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
;geometry_boy.c:1043: for (uint8_t i = 0; i < 16; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00156$
00101$:
;geometry_boy.c:1051: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1053: uint8_t is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1057: while (1)
00125$:
;geometry_boy.c:1059: if (vbl_count == 0)
	ld	a, (#_vbl_count)
	or	a, a
	jr	NZ, 00103$
;geometry_boy.c:1061: wait_vbl_done();
	call	_wait_vbl_done
00103$:
;geometry_boy.c:1063: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:1065: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1066: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1068: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#1
	ld	(hl), a
;geometry_boy.c:1065: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#2
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1070: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1072: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1071: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x03
	ld	e, a
	ld	d, #0x00
;geometry_boy.c:1070: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1071: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, e
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ld	e, a
;geometry_boy.c:1068: if (debounce_input(J_UP, jpad, prev_jpad))
	ld	a, c
	or	a, a
	jr	Z, 00117$
;geometry_boy.c:1072: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1071: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1070: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1072: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1074: player_sprite_num += 12;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0c
	ld	(hl), a
;geometry_boy.c:1075: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1079: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1078: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1079: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00117$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1082: else if (debounce_input(J_DOWN, jpad, prev_jpad))
	or	a, a
	jr	Z, 00114$
;geometry_boy.c:1086: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1085: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1084: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	(hl+), a
;geometry_boy.c:1086: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1088: player_sprite_num += 4;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x04
	ld	(hl), a
;geometry_boy.c:1089: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1093: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1092: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1093: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00114$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1096: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00111$
;geometry_boy.c:1100: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1099: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1098: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
;geometry_boy.c:1100: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1102: player_sprite_num += 15;
	ld	hl, #_player_sprite_num
	ld	a, (hl)
	add	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1103: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1107: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1106: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1107: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jp	00118$
00111$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1110: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00108$
;geometry_boy.c:1114: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1113: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
;geometry_boy.c:1112: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ldhl	sp,	#8
	ld	b, (hl)
;geometry_boy.c:1114: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1116: player_sprite_num += 1;
	ld	hl, #_player_sprite_num
	inc	(hl)
	ld	a, (hl)
;geometry_boy.c:1117: player_sprite_num %= 16;
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	c, (hl)
	ld	b, #0x00
;geometry_boy.c:1121: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1120: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
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
;geometry_boy.c:1121: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	jr	00118$
00108$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1124: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00118$
;geometry_boy.c:1127: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:1127: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#8
	inc	(hl)
	jr	00159$
00104$:
;geometry_boy.c:1131: return TITLE;
	ld	e, #0x00
	jp	00161$
00118$:
;geometry_boy.c:1134: if (tick % 4 == 0)
	ld	a, (#_tick)
	and	a, #0x03
	jp	NZ,00123$
;geometry_boy.c:1039: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ld	a, (#_player_sprite_num)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
;geometry_boy.c:1070: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	hl, #_player_sprite_num
	ld	b, (hl)
;geometry_boy.c:1072: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
	ldhl	sp,	#5
	ld	a, (hl+)
	rlca
	and	a,#0x01
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
;geometry_boy.c:1071: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
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
;geometry_boy.c:1070: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, b
	add	a, #0x0b
	push	hl
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
;geometry_boy.c:1071: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	a, c
	swap	a
	rlca
	and	a, #0xe0
	add	a, #0x24
	ldhl	sp,	#8
	ld	(hl), a
;geometry_boy.c:1136: if (is_up)
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
;geometry_boy.c:1140: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:1139: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ld	(hl+), a
	inc	hl
;geometry_boy.c:1138: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1140: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
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
;geometry_boy.c:1141: is_up = 0;
	ldhl	sp,	#0
	ld	(hl), #0x00
	jr	00123$
00120$:
;geometry_boy.c:1147: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1146: ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
	ldhl	sp,	#8
;geometry_boy.c:1145: move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
	ld	a, (hl-)
	ld	c, a
;geometry_boy.c:1147: ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
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
;geometry_boy.c:1148: is_up = 1;
	ldhl	sp,	#0
	ld	(hl), #0x01
00123$:
;geometry_boy.c:1151: tick++;
	ld	hl, #_tick
	inc	(hl)
;geometry_boy.c:1153: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00125$
00161$:
;geometry_boy.c:1155: }
	add	sp, #9
	ret
;geometry_boy.c:1175: screen_t level_select()
;	---------------------------------
; Function level_select
; ---------------------------------
_level_select::
	add	sp, #-6
;geometry_boy.c:1178: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1179: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1180: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1182: wait_vbl_done();
	call	_wait_vbl_done
;geometry_boy.c:325: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:326: set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
	ld	de, #_gb_tileset_v2
	push	de
	ld	hl, #0xe00
	push	hl
	call	_set_bkg_data
	add	sp, #4
;geometry_boy.c:327: SWITCH_ROM_MBC1(saved_bank);
	ld	hl, #_saved_bank
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	ld	de, #0x2000
	ld	a, (hl)
	ld	(de), a
;geometry_boy.c:328: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	ld	(hl), #0x00
00157$:
;geometry_boy.c:330: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	ld	(hl), #0x00
00155$:
;geometry_boy.c:332: set_bkg_tile_xy(render_col, render_row, 3);
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
;geometry_boy.c:330: for (render_col = 0; render_col < 20; render_col++)
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00155$
;geometry_boy.c:328: for (render_row = 0; render_row < 18; render_row++)
	ld	hl, #_render_row
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00157$
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	xor	a, a
	ldh	(_SCX_REG + 0), a
;geometry_boy.c:1187: SWITCH_ROM_MBC1(tilesBank);
	ld	a, #0x02
	ldh	(__current_bank + 0), a
	ld	hl, #0x2000
	ld	(hl), #0x02
;geometry_boy.c:1188: set_sprite_data(CURSOR_TEXT_OAM, 1, aero_cursors); // Load into VRAM
	ld	de, #_aero_cursors
	push	de
	ld	hl, #0x10a
	push	hl
	call	_set_sprite_data
	add	sp, #4
;geometry_boy.c:1189: SWITCH_ROM_MBC1(saved_bank);
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
;geometry_boy.c:1194: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	ld	(hl), #0x00
00159$:
;geometry_boy.c:1195: set_bkg_tile_xy(render_col + LEVEL_TEXT_START_COL, LEVEL_TEXT_ROW, LETTER_TILES + (level_text[render_col] - 65));
	ld	a, #<(_level_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_level_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:1194: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00159$
;geometry_boy.c:1198: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00161$:
;geometry_boy.c:1199: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, PROGRESS_TEXT_ROW, LETTER_TILES + (progress_text[render_col] - 65));
	ld	a, #<(_progress_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_progress_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:1198: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00161$
;geometry_boy.c:1202: for (render_col = 0; render_col < 8; render_col++){
	ld	(hl), #0x00
00163$:
;geometry_boy.c:1203: set_bkg_tile_xy(render_col + PROGRESS_TEXT_START_COL, ATTEMPTS_TEXT_ROW, LETTER_TILES + (attempts_text[render_col] - 65));
	ld	a, #<(_attempts_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_attempts_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:1202: for (render_col = 0; render_col < 8; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00163$
;geometry_boy.c:1206: for (render_col = 0; render_col < 5; render_col++){
	ld	(hl), #0x00
00165$:
;geometry_boy.c:1207: set_bkg_tile_xy(render_col + START_TEXT_START_COL, START_TEXT_ROW, LETTER_TILES + (start_text[render_col] - 65));
	ld	a, #<(_start_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_start_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:1206: for (render_col = 0; render_col < 5; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00165$
;geometry_boy.c:1210: for (render_col = 0; render_col < 4; render_col++){
	ld	(hl), #0x00
00167$:
;geometry_boy.c:1211: set_bkg_tile_xy(render_col + START_TEXT_START_COL, BACK_TEXT_ROW, LETTER_TILES + (back_text[render_col] - 65));
	ld	a, #<(_back_text)
	ld	hl, #_render_col
	add	a, (hl)
	ld	c, a
	ld	a, #>(_back_text)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	add	a, #0xd7
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
;geometry_boy.c:1210: for (render_col = 0; render_col < 4; render_col++){
	ld	hl, #_render_col
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00167$
;geometry_boy.c:1215: uint8_t tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1216: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00169$:
;geometry_boy.c:1217: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0e
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
;geometry_boy.c:1218: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1216: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00169$
;geometry_boy.c:1224: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1225: progress = *(px_progress[level_ind]);
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
;geometry_boy.c:1226: saved_attempts = *(attempts[level_ind]);
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
;geometry_boy.c:1227: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1228: progress = progress * 100;
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
;geometry_boy.c:1229: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
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
;geometry_boy.c:1230: progress = progress >> 3;
	ld	a, #0x03
00419$:
	srl	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ, 00419$
;geometry_boy.c:1233: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00171$:
;geometry_boy.c:1234: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
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
	add	a, #0x0e
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
;geometry_boy.c:1235: progress = progress / 10;
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
;geometry_boy.c:1233: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00171$
;geometry_boy.c:1237: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3305
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1239: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00173$:
;geometry_boy.c:1240: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
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
	add	a, #0x0e
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
;geometry_boy.c:1241: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1239: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00173$
;geometry_boy.c:1245: while (1)
	ld	hl, #_cursor_title_position_old
	ld	(hl), #0x00
00139$:
;geometry_boy.c:1248: prev_jpad = jpad;
	ld	a, (#_jpad)
	ld	(#_prev_jpad),a
;geometry_boy.c:1249: jpad = joypad();
	call	_joypad
	ld	hl, #_jpad
	ld	(hl), e
;geometry_boy.c:1250: render = 0;
	ldhl	sp,	#2
	ld	(hl), #0x00
;geometry_boy.c:1252: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (#_prev_jpad)
	ldhl	sp,	#3
	ld	(hl), a
;geometry_boy.c:1248: prev_jpad = jpad;
	ld	a, (#_jpad)
	ldhl	sp,	#4
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1252: if (debounce_input(J_DOWN, jpad, prev_jpad))
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;geometry_boy.c:1254: cursor_title_position = 1;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x01
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x78
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1255: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (BACK_TEXT_ROW << 3) + YOFF);
	jp	00132$
00131$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1257: else if (debounce_input(J_UP, jpad, prev_jpad))
	or	a, a
	jr	Z, 00128$
;geometry_boy.c:1259: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;../gbdk/include/gb/gb.h:1399: OAM_item_t * itm = &shadow_OAM[nb];
;../gbdk/include/gb/gb.h:1400: itm->y=y, itm->x=x;
	ld	hl, #(_shadow_OAM + 40)
	ld	(hl), #0x68
	ld	hl, #(_shadow_OAM + 41)
	ld	(hl), #0x30
;geometry_boy.c:1260: move_sprite(CURSOR_TEXT_OAM, (START_TEXT_START_COL << 3) + XOFF - 16, (START_TEXT_ROW << 3) + YOFF);
	jp	00132$
00128$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1263: else if (debounce_input(J_LEFT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00125$
;geometry_boy.c:1265: if (level_ind > 0){
	ld	hl, #_level_ind
	ld	a, (hl)
	or	a, a
	jp	Z, 00132$
;geometry_boy.c:1266: level_ind--;
	dec	(hl)
;geometry_boy.c:1267: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jp	00132$
00125$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1271: else if (debounce_input(J_RIGHT, jpad, prev_jpad))
	or	a, a
	jr	Z, 00122$
;geometry_boy.c:1273: if (level_ind < NUM_LEVELS - 1){
	ld	hl, #_level_ind
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0x81
	jr	NC, 00132$
;geometry_boy.c:1274: level_ind ++;
	inc	(hl)
;geometry_boy.c:1275: render = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
	jr	00132$
00122$:
;geometry_boy.c:356: return (button == target) && !(prev_button == target);
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
;geometry_boy.c:1279: else if (debounce_input(J_SELECT, jpad, prev_jpad)) // || debounce_input(J_START, jpad, prev_jpad))
	or	a, a
	jr	Z, 00132$
;geometry_boy.c:1283: for (uint8_t i = 0; i < 40; i++)
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
;geometry_boy.c:1283: for (uint8_t i = 0; i < 40; i++)
	ldhl	sp,	#5
	inc	(hl)
	jr	00176$
00113$:
;geometry_boy.c:1288: if (cursor_title_position == 0)
	ld	hl, #_cursor_title_position
	ld	a, (hl)
;geometry_boy.c:1290: cursor_title_position = 0;
	or	a,a
	jr	NZ, 00117$
	ld	(hl),a
;geometry_boy.c:1291: return GAME;
	ld	e, #0x01
	jp	00184$
00117$:
;geometry_boy.c:1294: else if (cursor_title_position == 1)
	ld	a, (#_cursor_title_position)
	dec	a
	jr	NZ, 00132$
;geometry_boy.c:1296: cursor_title_position = 0;
	ld	hl, #_cursor_title_position
	ld	(hl), #0x00
;geometry_boy.c:1297: return TITLE;
	ld	e, #0x00
	jp	00184$
00132$:
;geometry_boy.c:1301: if (render){
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	Z, 00137$
;geometry_boy.c:1303: tmp = level_ind + 1;
	ld	hl, #_level_ind
	ld	c, (hl)
	inc	c
;geometry_boy.c:1304: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x01
00178$:
;geometry_boy.c:1305: set_bkg_tile_xy(LEVEL_TEXT_START_COL + 6 + render_col, LEVEL_TEXT_ROW, NUMBER_TILES + (tmp % 10));
	ld	b, #0x00
	push	bc
	ld	de, #0x000a
	push	de
	push	bc
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a, e
	add	a, #0x0e
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
;geometry_boy.c:1306: tmp = tmp / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divsint
	add	sp, #4
	ld	c, e
;geometry_boy.c:1304: for (render_col = 1; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00178$
;geometry_boy.c:1309: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1310: progress = *(px_progress[level_ind]);
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
;geometry_boy.c:1311: saved_attempts = *(attempts[level_ind]);
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
;geometry_boy.c:1312: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1313: progress = progress * 100;
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
;geometry_boy.c:1314: progress = progress / (level_widths[level_ind] -LEVEL_END_OFFSET);
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
;geometry_boy.c:1315: progress = progress >> 3;
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
;geometry_boy.c:1318: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x02
00180$:
;geometry_boy.c:1319: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, PROGRESS_TEXT_ROW + 1, NUMBER_TILES + (progress % 10));
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
	add	a, #0x0e
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
;geometry_boy.c:1320: progress = progress / 10;
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
;geometry_boy.c:1318: for (render_col = 2; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00180$
;geometry_boy.c:1322: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 5, PROGRESS_TEXT_ROW + 1, PERCENT_TILE);
	ld	hl, #0x3305
	push	hl
	ld	a, #0x0b
	push	af
	inc	sp
	call	_set_bkg_tile_xy
	add	sp, #3
;geometry_boy.c:1324: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	ld	(hl), #0x03
00182$:
;geometry_boy.c:1325: set_bkg_tile_xy(PROGRESS_TEXT_START_COL + 2 + render_col, ATTEMPTS_TEXT_ROW + 1, NUMBER_TILES + (saved_attempts % 10));
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
	add	a, #0x0e
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
;geometry_boy.c:1326: saved_attempts = saved_attempts / 10;
	ld	de, #0x000a
	push	de
	push	bc
	call	__divuint
	add	sp, #6
	push	de
;geometry_boy.c:1324: for (render_col = 3; render_col != 0xFF; render_col--){
	ld	hl, #_render_col
	dec	(hl)
	ld	a, (hl)
	inc	a
	jr	NZ, 00182$
00137$:
;geometry_boy.c:1330: delay(LOOP_DELAY);
	ld	de, #0x0014
	push	de
	call	_delay
	pop	hl
	jp	00139$
00184$:
;geometry_boy.c:1332: }
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
;geometry_boy.c:1334: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-7
;geometry_boy.c:166: vbl_count = 0;
	ld	hl, #_vbl_count
	ld	(hl), #0x00
;geometry_boy.c:167: background_x_shift = 0;
	xor	a, a
	ld	hl, #_background_x_shift
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:168: old_scroll_x = 0;
	xor	a, a
	ld	hl, #_old_scroll_x
	ld	(hl+), a
	ld	(hl), a
;geometry_boy.c:169: old_background_x_shift = 8 + 3;
	ld	hl, #_old_background_x_shift
	ld	a, #0x0b
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;geometry_boy.c:170: player_y = PLAYER_START_Y;
	ld	hl, #_player_y
	ld	(hl), #0x90
;geometry_boy.c:171: player_x = PLAYER_START_X;
	ld	hl, #_player_x
	ld	(hl), #0x20
;geometry_boy.c:172: player_dx = 3;
	ld	hl, #_player_dx
	ld	(hl), #0x03
;geometry_boy.c:173: on_ground = 1;
	ld	hl, #_on_ground
	ld	(hl), #0x01
;geometry_boy.c:174: lose = 0;
	ld	hl, #_lose
	ld	(hl), #0x00
;geometry_boy.c:175: win = 0;
	ld	hl, #_win
	ld	(hl), #0x00
;geometry_boy.c:176: tick = 0;
	ld	hl, #_tick
	ld	(hl), #0x00
;geometry_boy.c:177: saved_tick =0;
	ld	hl, #_saved_tick
	ld	(hl), #0x00
;geometry_boy.c:178: parallax_tile_ind = 0;
	ld	hl, #_parallax_tile_ind
	ld	(hl), #0x00
;geometry_boy.c:179: current_vehicle = CUBE;
	ld	hl, #_current_vehicle
	ld	(hl), #0x00
;geometry_boy.c:180: prev_jpad = 0;
	ld	hl, #_prev_jpad
	ld	(hl), #0x00
;geometry_boy.c:181: jpad = 0;
	ld	hl, #_jpad
	ld	(hl), #0x00
;geometry_boy.c:182: SCX_REG = 0;
	ld	a, #0x00
	ldh	(_SCX_REG + 0), a
;../gbdk/include/gb/gb.h:660: __asm__("di");
	di
;geometry_boy.c:1340: set_interrupts(VBL_IFLAG); // interrupt set after finished drawing the screen
	ld	a, #0x01
	push	af
	inc	sp
	call	_set_interrupts
	inc	sp
;../gbdk/include/gb/gb.h:644: __asm__("ei");
	ei
;geometry_boy.c:1345: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;geometry_boy.c:1346: saved_bank = _current_bank;
	ldh	a, (__current_bank + 0)
	ld	(#_saved_bank),a
;geometry_boy.c:1347: screen_t current_screen = TITLE;
	ld	c, #0x00
;geometry_boy.c:1349: ENABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x0a
;geometry_boy.c:1350: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ldhl	sp,	#6
	ld	(hl), #0x00
00123$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00101$
;geometry_boy.c:1351: attempts[i] = (uint16_t *) (START_ATTEMPTS + (i << 1));
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
;geometry_boy.c:1352: px_progress[i] = (uint16_t *) (START_PROGRESS + (i << 1));
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
;geometry_boy.c:1350: for (uint8_t i = 0; i < NUM_LEVELS; i++){
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jr	00123$
00101$:
;geometry_boy.c:1355: if (*saved != 's')
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
;geometry_boy.c:1357: *saved = 's';
	ld	(hl), #0x73
;geometry_boy.c:1358: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00104$
;geometry_boy.c:1360: *(attempts[i]) = 0;
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
;geometry_boy.c:1361: *(px_progress[i]) = 0;
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
;geometry_boy.c:1358: for (uint8_t i = 0; i < NUM_LEVELS; i++)
	ldhl	sp,	#6
	inc	(hl)
	jr	00126$
00104$:
;geometry_boy.c:1364: DISABLE_RAM_MBC1;
	ld	hl, #0x0000
	ld	(hl), #0x00
;geometry_boy.c:1366: while (1)
00117$:
;geometry_boy.c:1368: wait_vbl_done(); // wait until finished drawing the screen
	call	_wait_vbl_done
;geometry_boy.c:1371: if (current_screen == TITLE)
	ld	a, c
	or	a, a
	jr	NZ, 00114$
;geometry_boy.c:1373: current_screen = title();
	call	_title
	ld	c, e
	jr	00117$
00114$:
;geometry_boy.c:1375: else if (current_screen == LEVEL_SELECT)
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00111$
;geometry_boy.c:1377: level_ind = 0;
	ld	hl, #_level_ind
	ld	(hl), #0x00
;geometry_boy.c:1378: current_screen = level_select();
	call	_level_select
	ld	c, e
	jr	00117$
00111$:
;geometry_boy.c:1380: else if (current_screen == PLAYER_SELECT)
	ld	a, c
	sub	a, #0x03
	jr	NZ, 00108$
;geometry_boy.c:1382: current_screen = player_select();
	call	_player_select
	ld	c, e
	jr	00117$
00108$:
;geometry_boy.c:1384: else if (current_screen == GAME)
	ld	a, c
	dec	a
	jr	NZ, 00117$
;geometry_boy.c:1386: current_screen = game();
	call	_game
	ld	c, e
	jr	00117$
;geometry_boy.c:1389: }
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
