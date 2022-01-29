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

#define TRUE 1
#define False 0

#define XOFF 8
#define YOFF 16

#define FLOOR               144
#define CEILING             24

#define LOOP_DELAY          30
#define BACKGROUND_SCROLL_PX_PER_TICK 2

#define GRAVITY             1
#define PLAYER_JUMP_VEL     6
#define ACCELERATION        1 
#define ROTATION_SPEED      15 

#define PLAYER_START_Y 144
#define PLAYER_START_X 32

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
uint8_t player_y = PLAYER_START_Y;
uint8_t player_x = PLAYER_START_X;
uint8_t prev_jpad = 0;
uint8_t jpad = 0;
uint8_t tick = 0;

uint8_t debounce_input(uint8_t target, uint8_t prev_button, uint8_t button){
    return (button == target) && !(prev_button == target);
}

void tick_player(){
    if (debounce_input(J_UP, prev_jpad, jpad)){
        if (player_y >= FLOOR){
            player_dy = -PLAYER_JUMP_VEL;
        }
    }

    player_y += player_dy;

    if (player_y < FLOOR){
        player_dy += GRAVITY;
    } else {
        player_y = FLOOR;
        player_dy = 0;
    }
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

    set_bkg_tiles(0, 0, 40, 18, simple_map); // map specifies where tiles go
    SHOW_BKG;
    DISPLAY_ON;

    while (1){
        //wait_vbl_done();
        // note that (0,0) is in the top left corner
        //if (tick % GAME_SPEED == 0){
        //    tick++;
        //    continue;
        //}

        prev_jpad = jpad;
        jpad = joypad();

        if (debounce_input(J_A, jpad, prev_jpad)){ // press A to exit
            //printf("EXITING\n");
            return TITLE;
        }

        tick_player();
        render_player();
        scroll_bkg(BACKGROUND_SCROLL_PX_PER_TICK, 0);//

        tick++;
        delay(LOOP_DELAY);
    }
}

screen_t title(){
   //printf("\n\t\tPress A to play\n");
    set_bkg_data(0, 9, test_tiles); // load tiles into VRAM
    set_bkg_tiles(0, 0, 40, 18, test_map); // map specifies where tiles go
    SHOW_BKG;
    DISPLAY_ON;
    HIDE_SPRITES;
    while (1) {
        prev_jpad = jpad;
        jpad = joypad();
        if (debounce_input(J_START, jpad, prev_jpad)){
            return GAME;
        }
        scroll_bkg(BACKGROUND_SCROLL_PX_PER_TICK, 0);
        delay(30);
    }
}

void main(){

    BGP_REG = OBP0_REG = OBP1_REG = 0xE4;
    SPRITES_8x8;
    screen_t current_screen = TITLE;

    while (1){
        if (current_screen == TITLE){
            current_screen = title();
        } else if (current_screen == GAME){
            current_screen = game();
        }
    }
}



