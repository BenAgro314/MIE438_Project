# Sprites

## Organization

- `sprites/old`: contains old files used for testing
- `sprites/src`: contains gbtd and gbmd source files
- `sprites/`: contains `.c` and `.h` sprite and map files

## Files

`player.c`

- 8x8 player sprite

`gb_tileset.c`

0. white
1. light grey
2. dark grey
3. black
4. big black spike
5. small black spike
6. white for parallax
7. light grey for parallax
8. dark grey for parallax
9. black for parallax
10. jump circle
11. jump tile
12. black half platform

`parallax_tileset.c`

w represents white column, g represents light grey column

0.  [w, w, w, w, w, w, w, w]
1.  [w, w, w, w, w, w, w, g]
2.  [w, w, w, w, w, w, g, g]
3.  [w, w, w, w, w, g, g, g]
4.  [w, w, w, w, g, g, g, g]
5.  [w, w, w, g, g, g, g, g]
6.  [w, w, g, g, g, g, g, g]
7.  [w, g, g, g, g, g, g, g]
8.  [g, g, g, g, g, g, g, g]
9.  [g, g, g, g, g, g, g, w]
10. [g, g, g, g, g, g, w, w]
11. [g, g, g, g, g, w, w, w]
12. [g, g, g, g, w, w, w, w]
13. [g, g, g, w, w, w, w, w]
14. [g, g, w, w, w, w, w, w]
15. [g, w, w, w, w, w, w, w]

