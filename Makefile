CC = ../gbdk/bin/lcc# -Wa-l -Wl-m -Wl-j -Wm-ys -Wl-yo4 -Wl-ya4 -Wl-yt1

#C:\Users\info\Documents\Y3-Robo-Winter\MIE438\MIE438_Project\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -c -o main.o main.c
#C:\Users\info\Documents\Y3-Robo-Winter\MIE438\MIE438_Project\gbdk\bin\lcc -DUSE_SFR_FOR_REG -Wl-yt1 -Wl-yo4 -Wl-ya0 -o test.gb main.o output.o gbt_player.o gbt_player_bank1.o


# originaly used -Wl-yt1, -Wl-yt3 and -Wl-yo4 was added to allow for saving
# see https://github.com/mrombout/gbdk_playground/tree/master/save_ram

ifeq ($(OS),Windows_NT)
	WINE := ""
else
	WINE := wine
endif
make:
	$(WINE) music/mod2gbt music/song_gdash.mod song 3
	$(CC) -Wa-l -Wf-bo3 -c -o build/title_map.o sprites/title_map_v2.c
	$(CC) -Wa-l -Wf-bo4 -c -o build/level1.o sprites/level1_v2.c
	$(CC) -Wa-l -Wf-bo4 -c -o build/level2.o sprites/level2.c
	$(CC) -Wa-l -Wf-bo5 -c -o build/level3.o sprites/level3.c
	$(CC) -Wa-l -Wf-bo2 -c -o build/tiles.o tiles.c
	$(CC) -Wa-l -c -o build/geometry_boy.o geometry_boy.c
	$(CC) -Wa-l -Wl-m -Wl-j -Wf-bo3 -c -o build/music_output.o output.c
	$(CC) -c -o build/gbt_player.o music/gbt_player.s
	$(CC) -c -o build/gbt_player_bank1.o music/gbt_player_bank1.s

	
	$(CC) -Wl-m -Wl-yt3 -Wl-yo8 -Wl-ya4 -o geometry_boy.gb build/title_map.o build/level1.o build/level2.o build/level3.o build/geometry_boy.o build/music_output.o build/gbt_player.o build/gbt_player_bank1.o build/tiles.o
	rm -f *.sym

clean:
	rm -f *.o *.lst *.map *.gb *~ *.rel *.cdb *.ihx *.lnk *.sym *.asm *.noi *.sav
	rm -f build/*.o build/*.lst build/*.map build/*.gb build/*~ build/*.rel build/*.cdb build/*.ihx build/*.lnk build/*.sym build/*.asm build/*.noi build/*.sav

# parallax_tileset_v2.o small_spike_parallax.o big_spike_parallax.o half_block_parallax.o jump_circle_parallax.o jump_tile_parallax.o nima.o aero.o players.o gb_tileset_v2.o progress_bar_tiles.o aero_cursors.o

#$(CC) -Wa-l -Wf-bo2 -c -o parallax_tileset_v2.o sprites/parallax_tileset_v2.c
#$(CC) -Wa-l -Wf-bo2 -c -o small_spike_parallax.o sprites/small_spike_parallax.c
#$(CC) -Wa-l -Wf-bo2 -c -o big_spike_parallax.o sprites/big_spike_parallax.c
#$(CC) -Wa-l -Wf-bo2 -c -o half_block_parallax.o sprites/half_block_parallax.c
#$(CC) -Wa-l -Wf-bo2 -c -o jump_circle_parallax.o sprites/jump_circle_parallax.c
#$(CC) -Wa-l -Wf-bo2 -c -o jump_tile_parallax.o sprites/jump_tile_parallax.c
#$(CC) -Wa-l -Wf-bo2 -c -o nima.o sprites/nima.c
#$(CC) -Wa-l -Wf-bo2 -c -o aero.o sprites/aero.c
#$(CC) -Wa-l -Wf-bo2 -c -o gb_tileset_v2.o sprites/gb_tileset_v2.c
#$(CC) -Wa-l -Wf-bo2 -c -o progress_bar_tiles.o sprites/progress_bar_tiles.c
#$(CC) -Wa-l -Wf-bo2 -c -o aero_cursors.o sprites/aero_cursors.c
#$(CC) -Wa-l -Wf-bo2 -c -o players.o sprites/players.c

# From Makebin source:
#
#-Wl-yt<NN> where <NN> is one of the numbers below
#
# 0147: Cartridge type:
# 0-ROM ONLY            12-ROM+MBC3+RAM
# 1-ROM+MBC1            13-ROM+MBC3+RAM+BATT
# 2-ROM+MBC1+RAM        19-ROM+MBC5
# 3-ROM+MBC1+RAM+BATT   1A-ROM+MBC5+RAM
# 5-ROM+MBC2            1B-ROM+MBC5+RAM+BATT
# 6-ROM+MBC2+BATTERY    1C-ROM+MBC5+RUMBLE
# 8-ROM+RAM             1D-ROM+MBC5+RUMBLE+SRAM
# 9-ROM+RAM+BATTERY     1E-ROM+MBC5+RUMBLE+SRAM+BATT
# B-ROM+MMM01           1F-Pocket Camera
# C-ROM+MMM01+SRAM      FD-Bandai TAMA5
# D-ROM+MMM01+SRAM+BATT FE - Hudson HuC-3
# F-ROM+MBC3+TIMER+BATT FF - Hudson HuC-1
# 10-ROM+MBC3+TIMER+RAM+BATT
# 11-ROM+MBC3
