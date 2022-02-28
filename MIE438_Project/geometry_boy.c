#include <gb/gb.h>
#include <gbdk/platform.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

// sprites and tiles
#include "sprites/players.c"
#include "sprites/gb_tileset.c"
#include "sprites/parallax_tileset.c"
#include "sprites/nima.c"
#include "sprites/aero.c"
#include "sprites/aero_cursors.c"
#include "sprites/progress_bar_tiles.c"

// maps
#include "sprites/title_map.h"
#include "sprites/level1.h"

// debug flags
//#define INVINCIBLE

#define TRUE 1
#define FALSE 0

#define XOFF 8
#define YOFF 16

#define FLOOR 144
#define CEILING 24

#define LOOP_DELAY 20

#define GRAVITY 1
#define MAX_FALL_SPEED 7
#define PLAYER_JUMP_VEL 6
#define PLAYER_SUPER_JUMP_VEL 9
#define ACCELERATION 1
#define ROTATION_SPEED 15

#define PLAYER_START_Y 144
#define PLAYER_START_X 32
#define PLAYER_WIDTH 8
//#define APPLY_GRAV_EVERY 1

// TODO: docstrings

// player jump height 2.133 blocks: https://geometry-dash.fandom.com/wiki/Transporters
// data on scroll speeds: https://gdforum.freeforums.net/thread/55538/easy-speed-maths-numbers-speeds?page=1
// 10.37 blocks/s at normal speed
// jump dist at normal speed 3.6 blocks https://geometry-dash.fandom.com/f/p/2846072015683784356

typedef enum
{
    TITLE,
    GAME,
    LEVEL_SELECT,
    PLAYER_SELECT,
} screen_t;

// parallax tileset

// we use globals because they are faster (not on the stack)
int8_t player_dy = 0;
int8_t player_dx = 3; // note we don't move the player, just the background
// player velocities
uint8_t player_y = PLAYER_START_Y;
uint8_t player_x = PLAYER_START_X;
// player status
uint8_t player_sprite_num = 0;
uint8_t on_ground = 1;
uint8_t win = 0;
uint8_t lose = 0;
// joypad
uint8_t prev_jpad = 0;
uint8_t jpad = 0;
// game/level state
uint8_t tick = 0;
uint16_t background_x_shift = 0;
uint16_t old_background_x_shift = 8 + 3;
uint16_t old_scroll_x = 0;
// vars for scrolling
uint8_t scx_cnt;
uint8_t render_row;
uint8_t render_col;
uint16_t count;
// for bank restoring
uint8_t saved_bank;
// for vbl_wait timing
uint8_t vbl_count;
// for parallax
uint8_t white_tile_ind = 0;
uint8_t green_tile_ind = 128; // 8*16;

// level stuff
uint8_t level_ind = 0;
uint8_t num_levels = 1;
unsigned char * level_maps[1] = {level1};
uint16_t level_widths[1] = {level1Width};
uint8_t level_banks[1] = {level1Bank};
uint16_t current_attempts = 0;
uint16_t px_progress_bar = 0;
uint16_t old_px_progress_bar = 0;
// tracking stats
// from pan docs: A000 - BFFF	8 KiB External RAM	From cartridge, switchable bank if any
#define START_RAM 0xa000
#define START_ATTEMPTS 0xa001
#define START_PROGRESS 0xa100
char * saved = (uint8_t *) START_RAM;
uint16_t* attempts[1] = {
    (int *) START_ATTEMPTS, 
}; // *(attempts[i]) is the number of attempts at level i
uint16_t* px_progress[1] = {
    (int *) START_PROGRESS,
}; // *(px_progress[i]) is the maximum pixel progress at level i


inline void reset_tracking(){
    vbl_count = 0;
    background_x_shift = 0;
    old_scroll_x = 0;
    old_background_x_shift = 8 + 3;
    player_y = PLAYER_START_Y;
    player_x = PLAYER_START_X;
    player_dx = 3;
    on_ground = 1;
    lose = 0;
    win = 0;
    tick = 0;
    white_tile_ind = 0;
    green_tile_ind = 128; // 8*16;
    prev_jpad = 0;
    jpad = 0;
    SCX_REG = 0;
}

const char attempts_title[] = {
    'A', 'T', 'T', 'E', 'M', 'P', 'T', 
};

inline void init_HUD(){
    for (render_row = 0; render_row < 3; render_row++){
        for (render_col = 0; render_col < 20; render_col ++){
            set_win_tile_xy(render_col, render_row, 0x03);
        }
    }
    for (render_col = 0; render_col < 7; render_col ++){
        set_win_tile_xy(render_col, 0, 39 + (attempts_title[render_col] - 65));
    }
    set_win_tile_xy(7, 0, 65); // colon
    for (render_col = 8; render_col < 11; render_col ++){
        set_win_tile_xy(render_col, 0, 29);
    }
    old_px_progress_bar = 0;
    px_progress_bar = 0;
}

inline void update_HUD_attempts(){
    uint16_t temp = current_attempts;
    for (render_col = 10; render_col >=8; render_col --){
        set_win_tile_xy(render_col, 0, temp % 10 + 29);
        temp = temp / 10;
    }
    // progress bar is 8 tiles = 64 px:
}

#define PROGRESS_BAR_TILES 18

void update_HUD_bar(){
    px_progress_bar = PROGRESS_BAR_TILES*(background_x_shift + player_x)/(level_widths[level_ind]); // 20 *8 * (px_progress)/(level_width*8)
    render_col = 0;
    if (px_progress_bar >= old_px_progress_bar){
        while (px_progress_bar > 8){
            render_col++;
            px_progress_bar -= 8;
        }
        set_win_tile_xy(render_col, 1, 0x42 + px_progress_bar); 
    } else {
        while (render_col < PROGRESS_BAR_TILES){
            set_win_tile_xy(render_col, 1, 0x42); 
            render_col++;
        }
    }
    old_px_progress_bar = px_progress_bar;
}

void lcd_interrupt_game(){
    HIDE_WIN;
}//hide the window, triggers at the scanline LYC

// see this for info: http://zalods.blogspot.com/2016/07/game-boy-development-tips-and-tricks-ii.html
void vbl_interrupt_game(){
    SHOW_WIN;
    vbl_count ++;
    old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
    SCX_REG = old_scroll_x;// + player_dx;
}

void vbl_interrupt_title(){
    vbl_count++;
    old_scroll_x += (background_x_shift - old_scroll_x + 1) >> 1;
    SCX_REG = old_scroll_x + player_dx;
}

void scroll_bkg_x(uint8_t x_shift, char *map, uint16_t map_width)
{
    background_x_shift = (background_x_shift + x_shift);
    if (background_x_shift >= old_background_x_shift)
    {
        // + x_shift ensures we don't ever see the newly written data
        old_background_x_shift = ((background_x_shift >> 3) << 3) + 8 + x_shift; //old_background_x_shift = (background_x_shift / 8) * 8 + 8 + x_shift;
        count = (background_x_shift >> 3) - 1;
        count = (count + 32) % map_width;
        for (render_row = 0; render_row < 18; render_row++)
        {
            // & 31 is the same as modulo 32
            set_bkg_tiles(((background_x_shift >> 3) - 1) & 31, render_row, 1, 1, map + count);
            count += map_width;
        }
    }
}

void init_background(char *map, uint16_t map_width)
{
    // initialize the background to map
    count = 0;
    for (render_row = 0; render_row < 18; render_row++)
    {
        set_bkg_tiles(0, render_row, 32, 1, map + count);
        count += map_width;
    }
}

inline void clear_background(){
    // write 0 to all background tiles
    for (render_row = 0; render_row < 18; render_row++)
    {
        for (render_col = 0; render_col < 20; render_col ++){
            set_bkg_tile_xy(render_col, render_row, 0);
        }
    }
}

inline uint8_t x_px_to_tile_ind(uint8_t x_px)
{
    return (x_px - XOFF) >> 3; // >> 3 is the same as /8
}

inline uint8_t y_px_to_tile_ind(uint8_t y_px)
{
    return (y_px - YOFF) >> 3;
}

inline uint8_t get_tile_by_px(uint8_t x_px, uint8_t y_px)
{
    return get_bkg_tile_xy(
        x_px_to_tile_ind(x_px + background_x_shift),
        y_px_to_tile_ind(y_px)
    );
}

inline uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button)
{
    return (button == target) && !(prev_button == target);
}

inline uint8_t inside_player(uint8_t x, uint8_t y){
    // returns 1 if (x,y) is inside the player, otherwise returns 0
    if (x >= player_x && x < (player_x + PLAYER_WIDTH) && y >= player_y && y < (player_y + PLAYER_WIDTH)){
        return 1;
    }
    return 0;
}

inline uint8_t rect_collision_with_player(uint8_t x_left, uint8_t x_right, uint8_t y_top, uint8_t y_bot){
    return (
        player_x <= x_right &&
        player_x + PLAYER_WIDTH - 1 >= x_left  &&
        player_y <= y_bot &&
        player_y + PLAYER_WIDTH - 1 >= y_top
    );
}

void collide(int8_t vel_y)
{
    // get all tiles the sprite is colliding with
    //uint8_t tiles[4] = {
        //get_tile_by_px(player_x, player_y),                    // top right
        //get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y),                                       // top left
        //get_tile_by_px(player_x, player_y + PLAYER_WIDTH - 1), // bottom right
        //get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH - 1)                     // bottom left
    //};
    uint8_t tile_x;
    uint8_t tile_y;
    uint8_t tile;
    for (uint8_t i = 0; i < 4; i++)
    {
        tile_x = (player_x + (PLAYER_WIDTH - 1) * (i % 2));
        tile_y = (player_y + (PLAYER_WIDTH - 1) * (i < 2));
        tile = get_tile_by_px(tile_x, tile_y);
        tile_x = tile_x & 0xF8;  // divide by 8 then multiply by 8
        tile_y = tile_y & 0xF8;
        if (tile == 0x5 || tile == 0x4)
        { // TODO: formalize tile indices
#ifndef INVINCIBLE
            player_dx = 0;
            player_dy = 0;
            player_x = (player_x / 8) * 8;
            lose = 1;
#endif
        }
        else if (tile == 0x3)
        {
            if (vel_y > 0)
            { // falling down
                player_y = player_y & 0xF8; //(player_y / 8) * 8;
                player_dy = 0;
                on_ground = 1;
            }
            else if (vel_y < 0)
            { // jumping up
                player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
            }
            else
            { // player cannot go through walls
#ifndef INVINCIBLE
                player_dx = 0;
                player_dy = 0;
                player_x = player_x & 0xF8 ; //(player_x / 8) * 8;
                lose = 1;
#endif
            }
        } 
        else if (tile == 0xC){ // half block
            if (rect_collision_with_player(tile_x, tile_x + 7 , tile_y + 4, tile_y + 7)){
                if (vel_y > 0)
                { // falling down
                    player_y = tile_y - 4;
                    player_dy = 0;
                    on_ground = 1;
                }
                else if (vel_y < 0)
                { // jumping up
                    player_y = (player_y & 0xF8) + 8; //(player_y / 8) * 8 + 8;
                }
                else
                { // player cannot go through walls
    #ifndef INVINCIBLE
                    player_dx = 0;
                    player_dy = 0;
                    player_x = player_x & 0xF8 ; //(player_x / 8) * 8;
                    lose = 1;
    #endif
                }
            }

        }
        else if (tile == 0xB) { // jump tile, hitbox is 2x8 rectangle at bottom, and no lookahead
            if (rect_collision_with_player(tile_x, tile_x + 7, tile_y + 6, tile_y + 7) && vel_y == 0){
                player_dy = -PLAYER_SUPER_JUMP_VEL;
            }
        }
        else if (tile == 0xA) // jump circle , hitbox is 4x4 square in center
        {
            if (jpad == J_UP && vel_y == 0){ // pressing up and no lookadhead
                if (rect_collision_with_player(tile_x + 2, tile_x + 5, tile_y + 2, tile_y + 5)){
                    player_dy = -PLAYER_JUMP_VEL;
                }
            }
        }
    }
    if (vel_y == 0)
    {
        if (get_tile_by_px(player_x + PLAYER_WIDTH-1, player_y + PLAYER_WIDTH) == 0x3 || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == 0x3)
        {
            on_ground = 1;
        }
        if (get_tile_by_px(player_x + PLAYER_WIDTH-1, player_y + PLAYER_WIDTH) == 0xC || get_tile_by_px(player_x, player_y + PLAYER_WIDTH) == 0xC)
        {
            tile_x = (player_x) & 0xF8;
            tile_y = (player_y + PLAYER_WIDTH) & 0xF8;
            if (rect_collision_with_player(tile_x, tile_x + 7 , tile_y + 3, tile_y + 7)){
                on_ground = 1;
            }
            tile_x = (player_x + PLAYER_WIDTH - 1) & 0xF8;
            if (rect_collision_with_player(tile_x, tile_x + 7 , tile_y + 3, tile_y + 7)){
                on_ground = 1;
            }
        }
    }
}

void tick_player()
{
    if (jpad == J_UP)
    { 
        if (on_ground)
        {
            player_dy = -PLAYER_JUMP_VEL;
        }
    }
    if (!on_ground)
    {
        player_dy += GRAVITY;
        if (player_dy > MAX_FALL_SPEED) player_dy = MAX_FALL_SPEED;
    }
    // x axis collisions
    collide(0);

    player_y += player_dy;

    // assume player is not on ground. This will be corrected after collision check
    on_ground = 0;
    // y axis collisions
    collide(player_dy);
}

void render_player()
{ // i want a better name for this function
    move_sprite(0, player_x, player_y);
}

void initialize_player()
{
    set_sprite_data(0, 1, players+(player_sprite_num << 4)); // << 4 is the same as *16
    set_sprite_tile(0, 0);
}

void init_tiles()
{
    set_bkg_data(0, 13, gb_tileset);        // load tiles into VRAM
    set_bkg_data(13, 16, parallax_tileset); // load tiles into VRAM
    set_bkg_data(29, 36, aero + 3*16);
    set_bkg_data(65, 1, aero + 47*16);
    set_bkg_data(66, 9, progress_bar_tiles);
}

screen_t game()
{
    STAT_REG|=0x40;//enable LYC=LY interrupt
    LYC_REG=16;//the scanline on which to trigger
    disable_interrupts();
    add_LCD(lcd_interrupt_game);
    add_VBL(vbl_interrupt_game);
    enable_interrupts();
    set_interrupts(LCD_IFLAG|VBL_IFLAG);

    wait_vbl_done();

    initialize_player();
    render_player(); // render at initial position
    SHOW_SPRITES;

    init_tiles();
    reset_tracking();
    current_attempts = 0;
    init_HUD();

    SHOW_BKG;
    DISPLAY_ON;

    SWITCH_ROM_MBC1(level_banks[level_ind]);
    init_background(level_maps[level_ind], level_widths[level_ind]);
    SWITCH_ROM_MBC1(saved_bank);

    while (1)
    {
        if (vbl_count == 0){
            wait_vbl_done();
        }
        vbl_count = 0;

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad))
        { // press A to exit
            return TITLE;
        }

        tick_player();

        render_player();

        SWITCH_ROM_MBC1(level1Bank);
        SWITCH_ROM_MBC1(level_banks[level_ind]);
        scroll_bkg_x(player_dx, level_maps[level_ind], level_widths[level_ind]);
        SWITCH_ROM_MBC1(saved_bank);

        if (lose)
        { // TODO: add this to a reset function
            wait_vbl_done();
            SWITCH_ROM_MBC1(level_banks[level_ind]);
            init_background(level_maps[level_ind], level_widths[level_ind]);
            SWITCH_ROM_MBC1(saved_bank);
            reset_tracking();
            ENABLE_RAM_MBC1;
            *(attempts[level_ind])++;
            if (background_x_shift + player_x > *(px_progress[level_ind])){
                *(px_progress[level_ind]) = background_x_shift + player_x;
            }
            DISABLE_RAM_MBC1;
            current_attempts++;
            update_HUD_attempts();
            update_HUD_bar();
        }

        white_tile_ind -= 16;
        if (white_tile_ind <= 0)
        {
            white_tile_ind = 240;
        }
        green_tile_ind -= 16;
        if (green_tile_ind <= 0)
        {
            green_tile_ind = 240; // 16*15
        }
        set_bkg_data(6, 1, parallax_tileset + white_tile_ind); // load tiles into VRAM
        set_bkg_data(7, 1, parallax_tileset + green_tile_ind); // load tiles into VRAM

        if (tick % 4 == 0){
            update_HUD_bar();
        }

        tick++;
        delay(LOOP_DELAY);
    }
}

//------------------------TITLE AND SELECTION SCREEN------------------------------------
// Length 11
const char game_title[] = {
    'G', 'E', 'O', 'M', 'E', 'T', 'R', 'Y', 'B', 'O', 'Y'};

#define TITLE_OAM 11
#define TITLE_START_X 48
#define TITLE_START_Y 16

const char start_text[] = {'S', 'T', 'A', 'R', 'T'};
#define START_TEXT_OAM 22
#define START_TEXT_START_X 60
#define START_TEXT_START_Y 88

const char player_text[] = {'P', 'L', 'A', 'Y', 'E', 'R'};
#define PLAYER_TEXT_OAM 27
#define PLAYER_TEXT_START_X 56
#define PLAYER_TEXT_START_Y 104

#define CURSOR_TEXT_OAM 10
#define TITLE_CURSOR_START_X 48
#define LIGHT_CURSOR (aero_cursors)
#define DARK_CURSOR (aero_cursors + 16)
uint8_t title_loaded = 0; // only want to delay the first time
uint8_t cursor_title_position = 0;
uint8_t cursor_title_position_old = 0;

screen_t title()
{
    disable_interrupts();
    add_VBL(vbl_interrupt_title);
    enable_interrupts();
    set_interrupts(VBL_IFLAG);
    wait_vbl_done();

    init_tiles();
    reset_tracking();

    SWITCH_ROM_MBC1(title_mapBank);
    init_background(title_map, title_mapWidth);
    SWITCH_ROM_MBC1(saved_bank);
    
    if (title_loaded) {
        for (int i = 0; i < 11; i++){
            set_sprite_data(TITLE_OAM + i, 1, nima + 16 * (13 + game_title[i] - 65)); // load tiles into VRAM
            set_sprite_tile(TITLE_OAM + i, TITLE_OAM + i);
            if (i > 7)
            {
                move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * (i - 8) + 20, TITLE_START_Y + YOFF + 10);
            }
            else
            {
                move_sprite(TITLE_OAM + i, TITLE_START_X + XOFF + 8 * i, TITLE_START_Y + YOFF);
            }
        }
        for (uint8_t i = 0; i < 6; i++)
        {
            // ASCII Letters - 65, plus 13 to skip the numbers and other stuff
            if (i < 5) {
                set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
                set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
                move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
            }
            set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
            set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
            move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
        }
        // Load cursor
        set_sprite_data(CURSOR_TEXT_OAM, 1, (char *) LIGHT_CURSOR); // Load into VRAM
        // Starting at OAM 10 want to use 0-9 for something else. Title at 11
        set_sprite_tile(CURSOR_TEXT_OAM, CURSOR_TEXT_OAM);
        move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
        scroll_sprite(TITLE_OAM + 10, 0, -2);
    }

    SHOW_BKG;
    DISPLAY_ON;

    SHOW_SPRITES;

    uint8_t title_index = 0;

    while (1)
    {
        if (vbl_count == 0){
            wait_vbl_done();
        }
        vbl_count = 0;

        SWITCH_ROM_MBC1(title_mapBank);
        scroll_bkg_x(player_dx, title_map, title_mapWidth);
        SWITCH_ROM_MBC1(saved_bank);

        white_tile_ind -= 16; 
        if (white_tile_ind <= 0){
            white_tile_ind = 240;
        }
        green_tile_ind -= 16;
        if (green_tile_ind <= 0){
            green_tile_ind = 240; // 16*15
        }
        set_bkg_data(6, 1, parallax_tileset + white_tile_ind); // load tiles into VRAM
        set_bkg_data(7, 1, parallax_tileset + green_tile_ind); // load tiles into VRAM

        if (!title_loaded) {
            if (tick % 4 == 0){ // change from 6 to 4 because power of 2 modulu is optimized
                if (title_index < 11){
                    set_sprite_data(TITLE_OAM + title_index, 1, nima + 16 * (13 + game_title[title_index] - 65)); // load tiles into VRAM
                    set_sprite_tile(TITLE_OAM + title_index, TITLE_OAM + title_index);
                    if (title_index > 7)
                    {
                        move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * (title_index - 8) + 20, TITLE_START_Y + YOFF + 10);
                    }
                    else
                    {
                        move_sprite(TITLE_OAM + title_index, TITLE_START_X + XOFF + 8 * title_index, TITLE_START_Y + YOFF);
                    }
                    title_index = title_index + 1;
                } else {
                    for (uint8_t i = 0; i < 6; i++)
                    {
                        // ASCII Letters - 65, plus 13 to skip the numbers and other stuff
                        if (i < 5) {
                            set_sprite_data(START_TEXT_OAM + i, 1, aero + 16 * (13 + start_text[i] - 65)); // load tiles into VRAM
                            set_sprite_tile(START_TEXT_OAM + i, START_TEXT_OAM + i);
                            move_sprite(START_TEXT_OAM + i, 8 * i + START_TEXT_START_X + XOFF, START_TEXT_START_Y + YOFF);
                        }
                        set_sprite_data(PLAYER_TEXT_OAM + i, 1, aero + 16 * (13 + player_text[i] - 65)); // load tiles into VRAM
                        set_sprite_tile(PLAYER_TEXT_OAM + i, PLAYER_TEXT_OAM + i);
                        move_sprite(PLAYER_TEXT_OAM + i, PLAYER_TEXT_START_X + XOFF + 8 * i, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
                    }
                    // Load cursor
                    set_sprite_data(CURSOR_TEXT_OAM, 1, (char *) LIGHT_CURSOR); // Load into VRAM
                    // Starting at OAM 10 want to use 0-9 for something else. Title at 11
                    set_sprite_tile(CURSOR_TEXT_OAM, CURSOR_TEXT_OAM);
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);

                    title_loaded = 1;
                    title_index = 0;
                    scroll_sprite(TITLE_OAM + 10, 0, -2);
                }
            }
        } else {
            // Making the letters bounce
            if (tick % 4 == 0)
            {
                if (title_index == 0)
                {
                    scroll_sprite(TITLE_OAM + title_index, 0, -2);
                    scroll_sprite(TITLE_OAM + 10, 0, +2);
                }
                else
                {
                    scroll_sprite(TITLE_OAM + title_index, 0, -2);
                    scroll_sprite(TITLE_OAM + title_index - 1, 0, +2);
                }
                title_index  = (title_index + 1)% 11;
            }
            //-----Dealing with IO Now-------
            prev_jpad = jpad;
            jpad = joypad();

            
            if (debounce_input(J_DOWN, jpad, prev_jpad)){
                cursor_title_position = 1;
            } else if (debounce_input(J_UP, jpad, prev_jpad)){
                cursor_title_position = 0;
            }

            if (cursor_title_position != cursor_title_position_old){
                if (cursor_title_position == 0)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
                }
                else if (cursor_title_position == 1)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
                }
                cursor_title_position_old = cursor_title_position;
            }


            else if (debounce_input(J_SELECT, jpad, prev_jpad))
            {
                disable_interrupts();
                clear_background();
                remove_VBL(vbl_interrupt_title);
                enable_interrupts();
                for (uint8_t i = 0; i < 40; i++)
                {
                    hide_sprite(i);
                }
                if (cursor_title_position == 0)
                {
                    cursor_title_position_old = 1; // force a change the next time title runs
                    return LEVEL_SELECT;
                }
                else if (cursor_title_position == 1)
                {
                    cursor_title_position_old = 0; 
                    return PLAYER_SELECT;
                }
            }
        }

        tick++;
        delay(LOOP_DELAY);
    }
}

#define PLAYER_SPRITES_OAM 11
#define PLAYERS_GRID_STARTX 28
#define PLAYERS_GRID_STARTY 20
#define PLAYERS_GRID_SPACING 32

screen_t player_select()
{

    wait_vbl_done();
    clear_background();

    // Load cursor
    uint8_t cursor_position = 0;
    set_sprite_data(CURSOR_TEXT_OAM, 1, (char* ) DARK_CURSOR); // Load into VRAM
    // Starting at OAM 10 want to use 0-9 for something else. PLAYER_SPRITES start at 11
    set_sprite_tile(CURSOR_TEXT_OAM, CURSOR_TEXT_OAM);
    move_sprite(CURSOR_TEXT_OAM,
                ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
                ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);

    // Load all character sprites
    set_sprite_data(PLAYER_SPRITES_OAM, 16, players); // Load into VRAM

    // Loading in characters

    for (uint8_t i = 0; i < 16; i++)
    {
        set_sprite_tile(PLAYER_SPRITES_OAM + i, PLAYER_SPRITES_OAM + i);
        move_sprite(PLAYER_SPRITES_OAM + i,
                    ((i % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                    ((i / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
    }

    SHOW_SPRITES;

    uint8_t is_up = 0;

    reset_tracking();

    while (1)
    {
        if (vbl_count == 0){
            wait_vbl_done();
        }
        vbl_count = 0;

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_UP, jpad, prev_jpad))
        {
            move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);

            player_sprite_num += 12;
            player_sprite_num %= 16;

            move_sprite(CURSOR_TEXT_OAM,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
        }

        else if (debounce_input(J_DOWN, jpad, prev_jpad))
        {
            move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);

            player_sprite_num += 4;
            player_sprite_num %= 16;

            move_sprite(CURSOR_TEXT_OAM,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
        }

        else if (debounce_input(J_LEFT, jpad, prev_jpad))
        {
            move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);

            player_sprite_num += 15;
            player_sprite_num %= 16;

            move_sprite(CURSOR_TEXT_OAM,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
        }

        else if (debounce_input(J_RIGHT, jpad, prev_jpad))
        {
            move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);

            player_sprite_num += 1;
            player_sprite_num %= 16;

            move_sprite(CURSOR_TEXT_OAM,
                        ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF - 16,
                        ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
        }

        else if (debounce_input(J_SELECT, jpad, prev_jpad))// || debounce_input(J_START, jpad, prev_jpad))
        {

            for (uint8_t i = 0; i < 40; i++)
            {
                hide_sprite(i);
            }
            return TITLE;
        }

        if (tick % 4 == 0)
        {
            if (is_up)
            {
                move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                            ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                            ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF - 2);
                is_up = 0;
            }
            else
            {
                move_sprite(PLAYER_SPRITES_OAM + player_sprite_num,
                            ((player_sprite_num % 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTX + XOFF,
                            ((player_sprite_num / 4) * PLAYERS_GRID_SPACING) + PLAYERS_GRID_STARTY + YOFF);
                is_up = 1;
            }
        }
        tick++;

        delay(LOOP_DELAY);
    }
}


void main()
{
    reset_tracking();
    enable_interrupts();
    // BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    saved_bank = _current_bank;
    screen_t current_screen = TITLE;

    ENABLE_RAM_MBC1;
    if (*saved != 's'){
        *saved = 's';
        for (uint8_t i = 0; i < num_levels; i++){
            *(attempts[i]) = 0;
            *(px_progress[i]) = 0;
        }
    }
    DISABLE_RAM_MBC1;

    while (1)
    {
        if (current_screen == TITLE)
        {
            current_screen = title();
        }
        else if (current_screen == LEVEL_SELECT)
        {
            level_ind = 0;
            current_screen = GAME;
        }
        else if (current_screen == PLAYER_SELECT)
        {
            current_screen = player_select();
        }
        else if (current_screen == GAME)
        {
            current_screen = game();
        }
    }
}
