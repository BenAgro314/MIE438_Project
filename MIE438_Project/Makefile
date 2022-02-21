CC = ../gbdk/bin/lcc# -Wa-l -Wl-m -Wl-j -Wm-ys -Wl-yo4 -Wl-ya4 -Wl-yt1

#BINS = geometry_boy.gb

#all: $(BINS)


make:
	$(CC) -Wa-l -Wf-bo2 -c -o bank2.o sprites/title_map.c
	$(CC) -Wa-l -Wf-bo2 -c -o bank3.o sprites/level1.c
	$(CC) -Wa-l -c -o geometry_boy.o geometry_boy.c
	$(CC) -Wl-m -Wl-yt1 -Wl-yo4 -o geometry_boy.gb bank2.o bank3.o geometry_boy.o
	rm -f *.sym
#%.gb: %.c 
#	$(CC) -o $@ $<

clean:
	rm -f *.o *.lst *.map *.gb *~ *.rel *.cdb *.ihx *.lnk *.sym *.asm *.noi
