# Geometry Boy

Details can be found in the project report is located at [MIE438_Project_Report.pdf](MIE438_Project_Report.pdf)

A demo video is available here: [https://youtu.be/1WBaEiE1EUo](https://youtu.be/1WBaEiE1EUo)

## Running the Game

There is a pre-compiled ROM file [ROMs/geometry_boy.gb](ROMs/geometry_boy.gb) which can be run with the provided `bgb.exe` binary.

If you are on a linux machine (with `wine` installed):
``` bash
wine bgb.exe ROMs/geometry_boy.gb
```

If you are on windows, you can run the `bgb.exe` executable and drag and drop the `geometry_boy.gb` ROM file into it.

## Compiling the Game

If you want to compile the game, you will have to download the latest [Game Boy Development Kit (GBDK) executables](https://github.com/gbdk-2020/gbdk-2020/releases).

Then change the path in the [Makefile](Makefile) to locate the top level compiler `lcc`:
``` bash
CC = <your path here> # e.g., ../gbdk/bin/lcc
```

Then run `make` to compile the `geometry_boy.gb` ROM file.




