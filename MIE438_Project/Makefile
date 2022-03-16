CC = ../gbdk/bin/lcc# -Wa-l -Wl-m -Wl-j -Wm-ys -Wl-yo4 -Wl-ya4 -Wl-yt1

#C:\Users\info\Documents\Y3-Robo-Winter\MIE438\MIE438_Project\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -c -o main.o main.c
#C:\Users\info\Documents\Y3-Robo-Winter\MIE438\MIE438_Project\gbdk\bin\lcc -DUSE_SFR_FOR_REG -Wl-yt1 -Wl-yo4 -Wl-ya0 -o test.gb main.o output.o gbt_player.o gbt_player_bank1.o


# originaly used -Wl-yt1, -Wl-yt3 and -Wl-yo4 was added to allow for saving
# see https://github.com/mrombout/gbdk_playground/tree/master/save_ram

make:
	music/mod2gbt music/song_gdash.mod song 2
	$(CC) -Wa-l -Wf-bo2 -c -o bank2.o sprites/title_map_v2.c
	$(CC) -Wa-l -Wf-bo3 -c -o bank3.o sprites/level1_v2.c
	$(CC) -Wa-l -c -o geometry_boy.o geometry_boy.c
	$(CC) -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -c -o output.o output.c
	$(CC) -DUSE_SFR_FOR_REG -c -o gbt_player.o music/gbt_player.s
	$(CC) -DUSE_SFR_FOR_REG -c -o gbt_player_bank1.o music/gbt_player_bank1.s

	
	$(CC) -Wl-m -Wl-yt3 -Wl-yo4 -Wl-ya4 -o geometry_boy.gb bank2.o bank3.o geometry_boy.o output.o gbt_player.o gbt_player_bank1.o
	rm -f *.sym

clean:
	rm -f *.o *.lst *.map *.gb *~ *.rel *.cdb *.ihx *.lnk *.sym *.asm *.noi *.sav

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