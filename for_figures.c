#include <gb/gb.h>
#include <gbdk/platform.h>
#include <gbdk/console.h>
#include <gbdk/font.h>

#include <stdio.h>
#include <stdlib.h>

// tiles (bank 2)
#include "tiles.h"

#define GB_TILESET_LEN 14
#define AERO_TILESET_LEN 36

uint8_t render_row;
uint8_t render_col;
uint8_t count;

const unsigned char empty8[] = {
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
};


inline void init_tiles()
{
    SWITCH_ROM_MBC1(tilesBank);
    set_bkg_data(0, GB_TILESET_LEN, gb_tileset_v2); // load tiles into VRAM
    set_bkg_data(GB_TILESET_LEN, AERO_TILESET_LEN, aero + 3 * 16);
    set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN, 1, aero + 47 * 16); // colon
    set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 1, 1, aero + 67 * 16); // percent
    set_bkg_data(GB_TILESET_LEN + AERO_TILESET_LEN + 2, 9, progress_bar_tiles);
}

inline void init_parallax_tiles(){
    SWITCH_ROM_MBC1(tilesBank);
    set_bkg_data(8*0, 8, parallax_tileset_v2);
    set_bkg_data(8*1, 8, small_spike_parallax);
    set_bkg_data(8*2, 8, big_spike_parallax);
    set_bkg_data(8*3, 8, half_block_parallax);
    set_bkg_data(8*4, 8, jump_circle_parallax);
    set_bkg_data(8*5, 8, jump_tile_parallax);
    set_bkg_data(8*6, 8, down_spike_parallax);
    set_bkg_data(8*7, 8, back_spike_parallax);
    set_bkg_data(8*8, 8, ship_parallax);
}

inline void view_all_tiles()
{
    count = 0;
    for (render_row = 0; render_row < 18; render_row++)
    {
        for (render_col = 0; render_col < 20; render_col++)
        {
            set_bkg_tile_xy(render_col, render_row, count);
            count += 1;
        }
    }
}

void main()
{
    //init_tiles();
    init_parallax_tiles();
    SHOW_BKG;
    DISPLAY_ON;

    view_all_tiles();
}
