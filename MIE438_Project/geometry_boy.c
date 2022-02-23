#include <gb/gb.h>
#include <gbdk/platform.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

// sprites and tiles
#include "sprites/player.c"
#include "sprites/gb_tileset.c"
#include "sprites/parallax_tileset.c"
#include "utils/out_test.c"

//maps
#include "sprites/title_map.h"
#include "sprites/level1.h"

// debug flags
//#define INVINCIBLE

#define TRUE 1
#define False 0

#define XOFF 8
#define YOFF 16

#define FLOOR               144
#define CEILING             24

#define LOOP_DELAY          20

#define GRAVITY             1
#define MAX_FALL_SPEED      7
#define PLAYER_JUMP_VEL     6
#define ACCELERATION        1 
#define ROTATION_SPEED      15 

#define PLAYER_START_Y 144
#define PLAYER_START_X 32
#define PLAYER_WIDTH 8
//#define APPLY_GRAV_EVERY 1

// TODO: docstrings

// player jump height 2.133 blocks: https://geometry-dash.fandom.com/wiki/Transporters
// data on scroll speeds: https://gdforum.freeforums.net/thread/55538/easy-speed-maths-numbers-speeds?page=1
// 10.37 blocks/s at normal speed
// jump dist at normal speed 3.6 blocks https://geometry-dash.fandom.com/f/p/2846072015683784356

typedef enum{
    TITLE,
    GAME,
    LEVEL_SELECT
} screen_t;

// parallax tileset

// we use globals because they are faster (not on the stack)
int8_t player_dy = 0; 
int8_t player_dx = 3; // note we don't move the player, just the background
// player velocities
uint8_t player_y = PLAYER_START_Y;
uint8_t player_x = PLAYER_START_X;
// player status
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


#define TITLE_WIDTH 8
#define TITLE_HEIGHT 2
#define TITLE_START_X 54
#define TITLE_START_Y 32
#define SPACE_PX 1
char game_title[] = {
    'G', 'E', 'O', 'M', 'E', 'T', 'R', 'Y',
    ' ', ' ', 'B', 'O', 'Y', ' ', ' ', ' ',
};

void scroll_bkg_x(uint8_t x_shift, char* map, uint16_t map_width){
    scroll_bkg(x_shift, 0);
    background_x_shift = (background_x_shift + x_shift);
    //scx_cnt += x_shift;
    if (background_x_shift >= old_background_x_shift){
        old_background_x_shift = (background_x_shift/8)*8 + 8;
        //scx_cnt = 0;
        count = background_x_shift/8 - 1;
        count = (count + 32)%map_width;
        for (render_row = 0; render_row < 18; render_row++){
            set_bkg_tiles((background_x_shift/8 - 1)%32, render_row, 1, 1, map + count);
            count += map_width;
        }
    }
}

void init_background(char * map, uint16_t map_width){
    count = 0;
    for (render_row = 0; render_row < 18; render_row++){
        set_bkg_tiles(0, render_row, 32, 1, map + count);
        count += map_width;
    }
}

uint8_t x_px_to_tile_ind(uint8_t x_px){
    return (x_px - XOFF) / 8;
}

uint8_t y_px_to_tile_ind(uint8_t y_px){
    return (y_px - YOFF) / 8;
}

uint8_t get_tile_by_px(uint8_t x_px, uint8_t y_px){
    return get_bkg_tile_xy(
        x_px_to_tile_ind(
            x_px + background_x_shift
        )
        , y_px_to_tile_ind(y_px)
    );
}

uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button){
    return (button == target) && !(prev_button == target);
}


void collide(int8_t vel_y){
    // get all tiles the sprite is colliding with
    int tiles[4] = {
        get_tile_by_px(player_x + PLAYER_WIDTH-1, player_y), // top right
        get_tile_by_px(player_x, player_y), // top left
        get_tile_by_px(player_x+PLAYER_WIDTH -1, player_y + PLAYER_WIDTH-1), // bottom right
        get_tile_by_px(player_x, player_y + PLAYER_WIDTH-1) // bottom left
    };
    for (uint8_t i = 0; i < 4; i++){
        uint8_t tile = tiles[i];
        #ifndef INVINCIBLE
        if (tile == 0x5){ // TODO: formalize tile indices
            player_dx = 0;
            player_dy = 0;
            player_x = (player_x/8)*8;
            lose = 1;
        }
        #endif
        if (tile == 0x3){ // black block or floor block
            if (vel_y > 0){ // falling down
                player_y = (player_y/8)*8;
                player_dy = 0;
                on_ground = 1;
            } else if (vel_y < 0) {// jumping up
                player_y = (player_y/8)*8 + 8;
            } else { // player cannot go through walls
                #ifndef INVINCIBLE
                player_dx = 0;
                player_dy = 0;
                player_x = (player_x/8)*8;
                lose = 1;
                #endif
            }
        }
        if (tile == 0xB){ // jump tile
            player_dy = -9;
        }
        if (tile == 0xA && jpad == J_UP){
            player_dy = -PLAYER_JUMP_VEL;
        }
    }
    if (vel_y == 0){
        uint8_t down_right = get_tile_by_px(player_x+PLAYER_WIDTH, player_y + PLAYER_WIDTH);
        uint8_t down_left = get_tile_by_px(player_x, player_y + PLAYER_WIDTH);
        if (down_right == 0x1 || down_right == 0x5 || down_left == 0x1 || down_right == 0x5){
            on_ground = 1;
        }
    }
}

void tick_player(){
    if (jpad == J_UP) { //debounce_input(J_UP, prev_jpad, jpad)){ // if jumping
        if (on_ground){
            player_dy = -PLAYER_JUMP_VEL;
        }
    }
    if (!on_ground){
        //if (tick % APPLY_GRAV_EVERY == 0){
        player_dy += GRAVITY;
        //}
        if (player_dy > MAX_FALL_SPEED){ // terminal velocity
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

void render_player(){ // i want a better name for this function
    move_sprite(0, player_x,     player_y    );
}

void initialize_player(){
    set_sprite_data(0, 1, player);
    set_sprite_tile(0,0);
}

void init_tiles(){
    set_bkg_data(0, 13, gb_tileset); // load tiles into VRAM
    set_bkg_data(13, 16, parallax_tileset); // load tiles into VRAM
}

screen_t game(){
    wait_vbl_done();

    initialize_player();
    render_player(); // render at initial position
    SHOW_SPRITES;

    init_tiles();

    //set_bkg_data(0, 17, test_tiles); // load tiles into VRAM
    background_x_shift = 0; 
    old_background_x_shift = 8; 
    move_bkg(background_x_shift, 0);

    SHOW_BKG;
    DISPLAY_ON;

    SWITCH_ROM_MBC1(level1Bank);
    //set_bkg_submap(0, 0, 32, 18, level1, level1Width); // map specifies where tiles go
    init_background(level1, level1Width);
    SWITCH_ROM_MBC1(saved_bank);


    uint8_t white_tile_ind = 0;
    uint8_t green_tile_ind = 128; //8*16;
    while (1){
        wait_vbl_done();

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad)){ // press A to exit
            return TITLE;
        }


        tick_player();

        render_player();

        SWITCH_ROM_MBC1(level1Bank);
        scroll_bkg_x(player_dx, level1, level1Width);
        SWITCH_ROM_MBC1(saved_bank);

        if (lose){ // TODO: add this to a reset function
            background_x_shift = 0; 
            player_y = PLAYER_START_Y;
            player_x = PLAYER_START_X;
            player_dx = 3;
            on_ground = 1;
            old_background_x_shift = 8;
            lose = 0;
            SWITCH_ROM_MBC1(level1Bank);
            init_background(level1, level1Width);
            //set_bkg_submap(0, 0, 32, 18, level1, level1Width); // map specifies where tiles go
            move_bkg(background_x_shift, 0);
            SWITCH_ROM_MBC1(saved_bank);
        }

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

        tick++;
        delay(LOOP_DELAY);
    }
}

screen_t title(){
    wait_vbl_done();

    //set_sprite_data(1, 26, out_test + 13*16); // load tiles into VRAM
    for (uint8_t i = 0; i < TITLE_WIDTH*TITLE_HEIGHT; i++){
        if (game_title[i] == ' '){
            continue;
        }
        set_sprite_data(1 + i, 1, out_test + 16*(13 + game_title[i] - 65)); // load tiles into VRAM
        //uint8_t ind = game_title[i] - 65 + 1;
        set_sprite_tile(i+1,i+1);
        //move_sprite(i+1, TITLE_START_X + (8 + SPACE_PX)*(i%TITLE_WIDTH) + 4*(i/TITLE_WIDTH), TITLE_START_Y + (8 + SPACE_PX)*(i/TITLE_WIDTH));
    }
    SHOW_SPRITES;

    init_tiles();

    SHOW_BKG;
    DISPLAY_ON;

    SWITCH_ROM_MBC1(title_mapBank);
    //set_bkg_submap(0,0, 32,18, title_map, title_mapWidth);
    init_background(title_map, title_mapWidth);

    SWITCH_ROM_MBC1(saved_bank);

    uint8_t white_tile_ind = 0;
    uint8_t green_tile_ind = 128; //8*16;
    uint8_t moving_letter_ind = 0;
    uint8_t up = 1;
    uint8_t offset = 0;
    while (1){
        wait_vbl_done();
        SWITCH_ROM_MBC1(title_mapBank);
        scroll_bkg_x(player_dx, title_map, title_mapWidth);
        SWITCH_ROM_MBC1(saved_bank);
        saved_bank = _current_bank;
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

            if (up){
                offset += 1;
                if (offset == 2){
                    up = 0;
                }
            } else {
                offset -=1;
                if (offset == 0){
                    up = 1;
                    moving_letter_ind = (moving_letter_ind + 1) % (TITLE_WIDTH*TITLE_HEIGHT);
                }
            }

            move_sprite(
                moving_letter_ind+1, 
                TITLE_START_X + (8 + SPACE_PX)*(moving_letter_ind%TITLE_WIDTH) + 4*(moving_letter_ind/TITLE_WIDTH),
                TITLE_START_Y + (8 + SPACE_PX)*(moving_letter_ind/TITLE_WIDTH) - offset
            );


        }
        prev_jpad = jpad;
        jpad = joypad();
        //set_bkg_tile_xy(1, 1, 1);
        if (debounce_input(J_START, jpad, prev_jpad)){
            for (uint8_t i = 1; i < TITLE_WIDTH*TITLE_HEIGHT+1; i++){
                hide_sprite(i);
            }
            return GAME;
        }
        tick++;
        delay(LOOP_DELAY);
    }
}


void main(){

    enable_interrupts();
    //BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    saved_bank = _current_bank;
    screen_t current_screen = TITLE;

    while (1){
        if (current_screen == TITLE){
            current_screen = title();
        } else if (current_screen == GAME){
            current_screen = game();
        } 
    }
}



