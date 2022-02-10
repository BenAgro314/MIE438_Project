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

#define TRUE 1
#define False 0

#define XOFF 8
#define YOFF 16

#define FLOOR               144
#define CEILING             24

#define LOOP_DELAY          30

#define GRAVITY             1
#define PLAYER_JUMP_VEL     6
#define ACCELERATION        1 
#define ROTATION_SPEED      15 

#define PLAYER_START_Y 144
#define PLAYER_START_X 32
#define PLAYER_HALF_WIDTH 4
#define PLAYER_WIDTH 4

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
int8_t player_dx = 2; // note we don't acutall move the player, just the background
uint8_t player_y = PLAYER_START_Y;
uint8_t player_x = PLAYER_START_X;
uint8_t prev_jpad = 0;
uint8_t jpad = 0;
uint8_t tick = 0;
uint8_t background_x_shift = 0;

// scrolling from http://www.devrs.com/gb/files/mapscroll.txt
uint16_t scroll_x;
uint8_t scx_cnt;
uint8_t tempa; 
int count;

void scroll_bkg_x(uint8_t x_shift){
    background_x_shift = (background_x_shift + x_shift);
    move_bkg(background_x_shift, 0);
}

uint8_t x_px_to_tile_ind(uint8_t x_px){
    return (x_px - XOFF) / 8;
}

uint8_t y_px_to_tile_ind(uint8_t y_px){
    return (y_px - YOFF) / 8;
}

uint8_t get_tile_by_px(uint8_t x_px, uint8_t y_px){
    return get_bkg_tile_xy(x_px_to_tile_ind(x_px + background_x_shift) , y_px_to_tile_ind(y_px));
}

uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button){
    return (button == target) && !(prev_button == target);
}

//uint8_t on_floor(){
//    // return floor y coordinates if on the floor, otherwise return -1
//    uint8_t t_left = get_tile_by_px(player_x, player_y + PLAYER_WIDTH + PLAYER_HALF_WIDTH);
//    uint8_t t_right = get_tile_by_px(player_x+PLAYER_WIDTH, player_y + PLAYER_WIDTH + PLAYER_HALF_WIDTH);
//    if (t_left == 1 || t_right == 1 || t_left == 5 || t_right == 5){
//        return y_px_to_tile_ind(player_y)*8 + YOFF;
//    }
//    return 0;
//}
//
//uint8_t check_death_collision(){
//    uint8_t t_top = get_tile_by_px(player_x+PLAYER_WIDTH - 1, player_y + 1);
//    uint8_t t_bottom = get_tile_by_px(player_x+PLAYER_WIDTH -1, player_y + PLAYER_WIDTH - 1);
//    if (t_top == 1 || t_bottom == 1 || t_top == 8 || t_bottom == 8){
//        return 1;
//    }
//    uint8_t t_left = get_tile_by_px(player_x, player_y + PLAYER_WIDTH + PLAYER_HALF_WIDTH);
//    uint8_t t_right = get_tile_by_px(player_x+PLAYER_WIDTH, player_y + PLAYER_WIDTH + PLAYER_HALF_WIDTH);
//    if (t_left == 8 || t_right == 8){
//        return 1;
//    }
//    return 0;
//}

uint8_t tick_player(){
    if (debounce_input(J_UP, prev_jpad, jpad)){
        if (player_y >= FLOOR){
            player_dy = -PLAYER_JUMP_VEL;
        }
    }

    player_y += player_dy;

    //if (check_death_collision()){
    //    return 0;
    //}

    //uint8_t floor = on_floor();
    if (player_y < FLOOR){
        player_dy += GRAVITY;
    } else {
        player_y = FLOOR;
        player_dy = 0;
    }
    return 1;
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

    set_bkg_submap(0, 0, 32, 18, level1, 40); // map specifies where tiles go
    SHOW_BKG;
    DISPLAY_ON;
    background_x_shift = 0; 
    move_bkg(background_x_shift, 0);

    while (1){
        //wait_vbl_done();
        // note that (0,0) is in the top left corner
        //if (tick % GAME_SPEED == 0){
        //    tick++;
        //    continue; //}

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad)){ // press A to exit
            //printf("EXITING\n");
            return TITLE;
        }


        if (!tick_player()){
            return TITLE;
        }

        render_player();
        scroll_bkg_x(player_dx);

        //set_bkg_tile_xy(x_px_to_tile_ind(player_x + background_x_shift), y_px_to_tile_ind(player_y), 1);
        //set_bkg_tile_xy(background_x_shift/8, 1, 1);
        //if (get_tile_by_px(player_x, player_y) == 1){
        //    printf("EXITING\n");
        //    return TITLE;
        //};

        tick++;
        delay(LOOP_DELAY);
    }
}

screen_t scrolling_test(){
    count = 0;
    wait_vbl_done();

    set_bkg_data(0, 9, test_tiles); // load tiles into VRAM
    for (uint8_t row = 0; row<18; row++){
        set_bkg_tiles(0, row, 32, 1, long_map + count);
        count += long_mapWidth;
    }
    SHOW_BKG;
    DISPLAY_ON;

    while (1){
        wait_vbl_done();
        scroll_bkg(player_dx, 0);
        scroll_x= scroll_x + player_dx;
        scx_cnt+=player_dx;
        if (scx_cnt == 8){ // if we have scrolled
            scx_cnt = 0;
            count = scroll_x / 8 - 1;
            count = (count + 32)%long_mapWidth;
            for (uint8_t row = 0; row < 18; row++){
                set_bkg_tiles((scroll_x/8 - 1)%32, row, 1, 1, long_map + count);
                count += long_mapWidth;
            }
        }
        delay(30);
    }

    return TITLE;
}

screen_t title(){
   //printf("\n\t\tPress A to play\n");
    set_bkg_data(0, 9, test_tiles); // load tiles into VRAM
    set_bkg_submap(0, 0, 32, 18, test_map, 40); // map specifies where tiles go
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
        scroll_bkg_x(player_dx);
        delay(30);
    }
}

void main(){

    enable_interrupts();
    BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    screen_t current_screen = GAME;

    while (1){
        if (current_screen == TITLE){
            current_screen = title();
        } else if (current_screen == GAME){
            //current_screen = game();
            current_screen = scrolling_test();
        }
    }
}



