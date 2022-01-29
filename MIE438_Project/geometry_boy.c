#include <gb/gb.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

#include "sprites/player.c"

#define TRUE 1
#define False 0

#define FLOOR               140u
#define CEILING             24u

#define LOOP_DELAY          30 

#define GRAVITY             1
#define JUMP_ACCELERATION   10
#define ACCELERATION        1 
#define ROTATION_SPEED      15 

#define PLAYER_START_Y 136
#define PLAYER_START_X 26

// TODO: docstrings

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
            player_dy -= JUMP_ACCELERATION;
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
    move_sprite(1, player_x,     player_y + 8);
    move_sprite(2, player_x + 8, player_y    );
    move_sprite(3, player_x + 8, player_y + 8);
}

void initialize_player(){
    set_sprite_data(0, 4, player);
    for (int i = 0; i < 4; i ++){
        set_sprite_tile(i, i);
    }
}

screen_t game(){

    initialize_player();
    render_player(); // render at initial position
    SHOW_SPRITES;

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
            printf("EXITING\n");
            return TITLE;
        }

        tick_player();
        render_player();

        tick++;
        delay(LOOP_DELAY);
    }
}

screen_t title(){
   printf("\n\t\tPress A to play\n");
   while (1) {
        prev_jpad = jpad;
        jpad = joypad();
        if (debounce_input(J_START, jpad, prev_jpad)){
            return GAME;
        }
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



