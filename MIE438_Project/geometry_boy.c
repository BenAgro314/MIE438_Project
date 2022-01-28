#include <gb/gb.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

#include "sprites/player.c"

void initialize_player(){
    set_sprite_data(0, 4, player);
    for (int i = 0; i < 4; i ++){
        set_sprite_tile(i, i);
    }
}

void move_player_sprite(uint8_t x, uint8_t y) {
  move_sprite(0, x,     y    );
  move_sprite(1, x,     y + 8);
  move_sprite(2, x + 8, y    );
  move_sprite(3, x + 8, y + 8);
}

void main(){
    SPRITES_8x8;
    initialize_player();
    move_player_sprite(20, 136);
    SHOW_SPRITES;
}



