#include <gb/gb.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

//#include "sprites/player.c"
#include "sprites/test_map.c"
#include "sprites/test_tiles.c"
#include "sprites/player8x8.c"
#include "sprites/simple_map.c"
#include "sprites/level1.c"
#include "sprites/long_map.c"

// debug flags
//#define INVINCIBLE

#define TRUE 1
#define False 0

#define XOFF 8
#define YOFF 16

#define FLOOR               144
#define CEILING             24

#define LOOP_DELAY          25

#define GRAVITY             1
#define MAX_FALL_SPEED      8
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
    GAME
} screen_t;

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
        if (tile == 0x8){ // TODO: formalize tile indices
            player_dx = 0;
            player_dy = 0;
            player_x = (player_x/8)*8;
            lose = 1;
        }
        #endif
        if (tile == 0x1 || tile == 0x5){ // black block or floor block
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
    //move_sprite(1, player_x,     player_y + 8);
    //move_sprite(2, player_x + 8, player_y    );
    //move_sprite(3, player_x + 8, player_y + 8);
}

void initialize_player(){
    set_sprite_data(0, 1, player8x8);
    //for (int i = 0; i < 4; i ++){
        //set_sprite_tile(i, i);
    //}
}

screen_t game(){

    initialize_player();
    render_player(); // render at initial position
    SHOW_SPRITES;

    set_bkg_submap(0, 0, 32, 18, long_map, long_mapWidth); // map specifies where tiles go
    SHOW_BKG;
    DISPLAY_ON;
    background_x_shift = 0; 
    old_background_x_shift = 8; 
    move_bkg(background_x_shift, 0);

    while (1){
        wait_vbl_done();

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad)){ // press A to exit
            return TITLE;
        }

        tick_player();

        render_player();

        scroll_bkg_x(player_dx, long_map, long_mapWidth);

        if (lose){ // TODO: add this to a reset function
            background_x_shift = 0; 
            player_y = PLAYER_START_Y;
            player_x = PLAYER_START_X;
            player_dx = 3;
            on_ground = 1;
            old_background_x_shift = 8;
            lose = 0;
            set_bkg_submap(0, 0, 32, 18, long_map, long_mapWidth); // map specifies where tiles go
            move_bkg(background_x_shift, 0);
        }

        tick++;
        delay(LOOP_DELAY);
    }
}

screen_t scrolling_test(){
    wait_vbl_done();
    set_bkg_data(0, 9, test_tiles); // load tiles into VRAM
    set_bkg_submap(0,0,32,18, long_map, long_mapWidth);
    SHOW_BKG;
    DISPLAY_ON;
    while (1){
        wait_vbl_done();
        scroll_bkg_x(player_dx, long_map, long_mapWidth);
        delay(LOOP_DELAY);
    }
}

screen_t title(){
    wait_vbl_done();
    set_bkg_data(0, 9, test_tiles); // load tiles into VRAM
    set_bkg_submap(0, 0, 32, 18, test_map, test_mapWidth); // map specifies where tiles go
    SHOW_BKG;
    DISPLAY_ON;
    HIDE_SPRITES;
    while (1) {
        prev_jpad = jpad;
        jpad = joypad();
        //set_bkg_tile_xy(1, 1, 1);
        if (debounce_input(J_START, jpad, prev_jpad)){
            return GAME;
        }
        scroll_bkg_x(player_dx, test_map, test_mapWidth);
        delay(LOOP_DELAY);
    }
}

void main(){

    enable_interrupts();
    BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    screen_t current_screen = TITLE;

    while (1){
        if (current_screen == TITLE){
            current_screen = title();
        } else if (current_screen == GAME){
            current_screen = game();
            //current_screen = scrolling_test();
        }
    }
}



