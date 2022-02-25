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
uint16_t old_background_x_shift = 8;
// vars for scrolling
uint8_t scx_cnt;
uint8_t render_row;
uint16_t count;
// for bank restoring
uint8_t saved_bank;

void scroll_bkg_x(uint8_t x_shift, char *map, uint16_t map_width)
{
    scroll_bkg(x_shift, 0);
    background_x_shift = (background_x_shift + x_shift);
    // scx_cnt += x_shift;
    if (background_x_shift >= old_background_x_shift)
    {
        old_background_x_shift = (background_x_shift / 8) * 8 + 8;
        // scx_cnt = 0;
        count = background_x_shift / 8 - 1;
        count = (count + 32) % map_width;
        for (render_row = 0; render_row < 18; render_row++)
        {
            set_bkg_tiles((background_x_shift / 8 - 1) % 32, render_row, 1, 1, map + count);
            count += map_width;
        }
    }
}

void init_background(char *map, uint16_t map_width)
{
    count = 0;
    for (render_row = 0; render_row < 18; render_row++)
    {
        set_bkg_tiles(0, render_row, 32, 1, map + count);
        count += map_width;
    }
}

void clear_background(){
    background_x_shift = 0;
    old_background_x_shift = 8;
    move_bkg(background_x_shift, 0);
    char empty[] = {0x00};
    for (render_row = 0; render_row < 18; render_row++)
    {
        for (int render_col = 0; render_col < 20; render_col ++ ){
            set_bkg_tiles(render_col, render_row, 1, 1, empty);
        }
    }
}

uint8_t x_px_to_tile_ind(uint8_t x_px)
{
    return (x_px - XOFF) / 8;
}

uint8_t y_px_to_tile_ind(uint8_t y_px)
{
    return (y_px - YOFF) / 8;
}

uint8_t get_tile_by_px(uint8_t x_px, uint8_t y_px)
{
    return get_bkg_tile_xy(
        x_px_to_tile_ind(
            x_px + background_x_shift),
        y_px_to_tile_ind(y_px));
}

uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button)
{
    return (button == target) && !(prev_button == target);
}

void collide(int8_t vel_y)
{
    // get all tiles the sprite is colliding with
    int tiles[4] = {
        get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y),                    // top right
        get_tile_by_px(player_x, player_y),                                       // top left
        get_tile_by_px(player_x + PLAYER_WIDTH - 1, player_y + PLAYER_WIDTH - 1), // bottom right
        get_tile_by_px(player_x, player_y + PLAYER_WIDTH - 1)                     // bottom left
    };
    for (uint8_t i = 0; i < 4; i++)
    {
        uint8_t tile = tiles[i];
#ifndef INVINCIBLE
        if (tile == 0x5)
        { // TODO: formalize tile indices
            player_dx = 0;
            player_dy = 0;
            player_x = (player_x / 8) * 8;
            lose = 1;
        }
#endif
        if (tile == 0x3)
        { // black block or floor block
            if (vel_y > 0)
            { // falling down
                player_y = (player_y / 8) * 8;
                player_dy = 0;
                on_ground = 1;
            }
            else if (vel_y < 0)
            { // jumping up
                player_y = (player_y / 8) * 8 + 8;
            }
            else
            { // player cannot go through walls
#ifndef INVINCIBLE
                player_dx = 0;
                player_dy = 0;
                player_x = (player_x / 8) * 8;
                lose = 1;
#endif
            }
        }
        if (tile == 0xB)
        { // jump tile
            player_dy = -9;
        }
        if (tile == 0xA && jpad == J_UP)
        {
            player_dy = -PLAYER_JUMP_VEL;
        }
    }
    if (vel_y == 0)
    {
        uint8_t down_right = get_tile_by_px(player_x + PLAYER_WIDTH, player_y + PLAYER_WIDTH);
        uint8_t down_left = get_tile_by_px(player_x, player_y + PLAYER_WIDTH);
        if (down_right == 0x1 || down_right == 0x5 || down_left == 0x1 || down_right == 0x5)
        {
            on_ground = 1;
        }
    }
}

void tick_player()
{
    if (jpad == J_UP)
    { // debounce_input(J_UP, prev_jpad, jpad)){ // if jumping
        if (on_ground)
        {
            player_dy = -PLAYER_JUMP_VEL;
        }
    }
    if (!on_ground)
    {
        // if (tick % APPLY_GRAV_EVERY == 0){
        player_dy += GRAVITY;
        //}
        if (player_dy > MAX_FALL_SPEED)
        { // terminal velocity
            player_dy = MAX_FALL_SPEED;
        }
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
    set_sprite_data(0, 1, players+(16*player_sprite_num));
    set_sprite_tile(0, 0);
}

void init_tiles()
{
    set_bkg_data(0, 13, gb_tileset);        // load tiles into VRAM
    set_bkg_data(13, 16, parallax_tileset); // load tiles into VRAM
}

screen_t game()
{
    wait_vbl_done();

    initialize_player();
    render_player(); // render at initial position
    SHOW_SPRITES;

    init_tiles();

    background_x_shift = 0;
    old_background_x_shift = 8;
    move_bkg(background_x_shift, 0);

    SHOW_BKG;
    DISPLAY_ON;

    SWITCH_ROM_MBC1(level1Bank);
    // set_bkg_submap(0, 0, 32, 18, level1, level1Width); // map specifies where tiles go
    init_background(level1, level1Width);
    SWITCH_ROM_MBC1(saved_bank);

    uint8_t white_tile_ind = 0;
    uint8_t green_tile_ind = 128; // 8*16;
    tick = 0;
    while (1)
    {
        wait_vbl_done();

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad))
        { // press A to exit
            return TITLE;
        }

        tick_player();

        render_player();

        SWITCH_ROM_MBC1(level1Bank);
        scroll_bkg_x(player_dx, level1, level1Width);
        SWITCH_ROM_MBC1(saved_bank);

        if (lose)
        { // TODO: add this to a reset function
            background_x_shift = 0;
            player_y = PLAYER_START_Y;
            player_x = PLAYER_START_X;
            player_dx = 3;
            on_ground = 1;
            old_background_x_shift = 8;
            lose = 0;
            SWITCH_ROM_MBC1(level1Bank);
            init_background(level1, level1Width);
            // set_bkg_submap(0, 0, 32, 18, level1, level1Width); // map specifies where tiles go
            move_bkg(background_x_shift, 0);
            SWITCH_ROM_MBC1(saved_bank);
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

        tick++;
        delay(LOOP_DELAY);
    }
}

//------------------------TITLE AND SELECTION SCREEN------------------------------------
// Length 11
char game_title[] = {
    'G', 'E', 'O', 'M', 'E', 'T', 'R', 'Y', 'B', 'O', 'Y'};

#define TITLE_OAM 11
#define TITLE_START_X 48
#define TITLE_START_Y 24

char start_text[] = {'S', 'T', 'A', 'R', 'T'};
#define START_TEXT_OAM 22
#define START_TEXT_START_X 60
#define START_TEXT_START_Y 104

char player_text[] = {'P', 'L', 'A', 'Y', 'E', 'R'};
#define PLAYER_TEXT_OAM 27
#define PLAYER_TEXT_START_X 56
#define PLAYER_TEXT_START_Y 120

#define CURSOR_TEXT_OAM 10
#define TITLE_CURSOR_START_X 48
#define LIGHT_CURSOR (aero_cursors)
#define DARK_CURSOR (aero_cursors + 16)
uint8_t title_loaded = 0; // only want to delay the first time

screen_t title()
{
    wait_vbl_done();

    init_tiles();

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

    uint8_t cursor_position = 0;
    uint8_t title_index = 0;

    prev_jpad = 0;
    jpad = 0;
    tick = 0;
    uint8_t white_tile_ind = 0;
    uint8_t green_tile_ind = 128; //8*16;
    while (1)
    {
        wait_vbl_done();

        SWITCH_ROM_MBC1(title_mapBank);
        scroll_bkg_x(player_dx, title_map, title_mapWidth);
        SWITCH_ROM_MBC1(saved_bank);

        if (tick % 1 == 0){
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
        }

        if (!title_loaded) {
            if (tick % 6 == 0){
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
            if (tick % 3 == 0)
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

            if (debounce_input(J_DOWN, jpad, prev_jpad))
            {
                cursor_position++;
                cursor_position %= 2;
                if (cursor_position == 0)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
                }
                else if (cursor_position == 1)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
                }
            }

            else if (debounce_input(J_UP, jpad, prev_jpad))
            {
                cursor_position++;
                cursor_position %= 2;
                if (cursor_position == 0)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, START_TEXT_START_Y + YOFF);
                }
                else if (cursor_position == 1)
                {
                    move_sprite(CURSOR_TEXT_OAM, TITLE_CURSOR_START_X, (uint8_t)(PLAYER_TEXT_START_Y + YOFF));
                }
            }

            else if (debounce_input(J_SELECT, jpad, prev_jpad))
            {
                clear_background();
                for (uint8_t i = 0; i < 40; i++)
                {
                    hide_sprite(i);
                }
                if (cursor_position == 0)
                {
                    return LEVEL_SELECT;
                }
                else if (cursor_position == 1)
                {
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
    prev_jpad = 0;
    jpad = 0;

    tick = 0;
    while (1)
    {
        wait_vbl_done();
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

        if (tick % 3 == 0)
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

    enable_interrupts();
    // BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    saved_bank = _current_bank;
    screen_t current_screen = TITLE;

    while (1)
    {
        if (current_screen == TITLE)
        {
            current_screen = title();
        }
        else if (current_screen == LEVEL_SELECT)
        {
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
