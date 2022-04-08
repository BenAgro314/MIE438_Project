CC = ../gbdk/bin/lcc

#ifeq ($(OS),Windows_NT)
#	WINE := ""
#else
#	WINE := wine
#endif

make: | build
	$(CC) -Wf-bo2 -c -o build/music_output.o music_sample.c 
	$(CC) -Wf-bo2 -c -o build/tiles.o tiles.c
	$(CC) -Wf-bo3 -c -o build/title_map.o sprites/title_map_v2.c
	$(CC) -Wf-bo3 -c -o build/level1.o sprites/level1_v2.c
	$(CC) -Wf-bo4 -c -o build/level2.o sprites/level2.c
	$(CC) -Wf-bo4 -c -o build/level3.o sprites/level3.c
	$(CC) -Wf-bo0 -c -o build/geometry_boy.o geometry_boy.c
	$(CC) -Wf-bo1 -c -o build/gbt_player.o music/gbt_player.s
	$(CC) -Wf-bo1 -c -o build/gbt_player_bank1.o music/gbt_player_bank1.s

	
	$(CC) -Wl-yt0x1B -Wl-yo8 -Wl-ya1 -o geometry_boy.gb build/title_map.o build/level1.o build/level2.o build/level3.o build/geometry_boy.o build/music_output.o build/gbt_player.o build/gbt_player_bank1.o build/tiles.o
	rm -f *.sym

for_figures: | build
	$(CC) -Wf-bo2 -c -o build/tiles.o tiles.c
	$(CC) -Wf-bo0 -c -o build/for_figures.o for_figures.c
	
	$(CC) -Wl-yt3 -Wl-yo4 -Wl-ya4 -o for_figures.gb build/tiles.o build/for_figures.o
	rm -f *.sym

build:
	mkdir $@

clean:
	rm -f *.o *.lst *.map *.gb *~ *.rel *.cdb *.ihx *.lnk *.sym *.asm *.noi *.sav
	rm -f build/*.o build/*.lst build/*.map build/*.gb build/*~ build/*.rel build/*.cdb build/*.ihx build/*.lnk build/*.sym build/*.asm build/*.noi build/*.sav

