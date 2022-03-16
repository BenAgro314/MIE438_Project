#!/usr/bin/env python

import argparse
from matplotlib import pyplot as plt

WHITE = 0
LGREY = 1
DGREY = 2
BLACK = 3

parser = argparse.ArgumentParser(description='Convery pixel image to an array of tiles')
parser.add_argument('in_path', help='path to image file')
parser.add_argument('out_name', help='name to give the .c, .h, file and output tile array')
parser.add_argument('--invert', const = True, default = False, action = 'store_const', help='invert the colors in the tileset')
parser.add_argument('--opaque', const = True, default = False, action = 'store_const', help='remove transparency (white -> lgrey')
args = parser.parse_args()
in_path = args.in_path
out_name = args.out_name

image = plt.imread(in_path)
assert image.shape[0] % 8 ==0 and image.shape[1] %8 ==0, "Image dims must be divisible by 8."
colors = set()
for row in image:
    for px in row:
        colors.add(tuple(px))

colors = list(colors)
colors.sort(key = lambda x: sum(x[:-1]))
assert len(colors) >= 2 and len(colors) <= 4, "Need at least two colors and less than 4 colors."
if len(colors) == 2:
    color_map = {
        colors[0]: WHITE if (not args.opaque) else (DGREY if (args.invert) else LGREY),
        colors[1]: BLACK,
    }
elif len(colors) == 3:
    color_map = {
        colors[0]: WHITE if (not args.opaque) else (DGREY if (args.invert) else LGREY),
        colors[1]: BLACK,
        colors[1]: DGREY,
        colors[2]: BLACK,
    }
else:
    assert (not args.opaque), "Four colors not supported with opaque mode"
    color_map = {
        colors[0]: WHITE,
        colors[1]: LGREY,
        colors[2]: DGREY,
        colors[2]: BLACK,
    }

# chop into 8x8
tiles = []
invert = not args.invert
zero = '0'
one = '1'
if invert:
    zero = '1'
    one = '0'



for row_base in range(0, image.shape[0], 8):
    for col_base in range(0, image.shape[1], 8):
        for row in range(row_base, row_base + 8):
            row_binary_lgrey = ''
            row_binary_dgrey = ''
            for col in range(col_base, col_base + 8):
                px = image[row][col]
                if color_map[tuple(px)] == WHITE:
                    row_binary_lgrey += zero
                    row_binary_dgrey += zero
                elif color_map[tuple(px)] == LGREY:
                    row_binary_lgrey += one
                    row_binary_dgrey += zero
                elif color_map[tuple(px)] == DGREY:
                    row_binary_lgrey += zero
                    row_binary_dgrey += one
                else:
                    row_binary_lgrey += one
                    row_binary_dgrey += one
            row_hex_lgrey = hex(int(row_binary_lgrey, 2))    
            row_hex_dgrey = hex(int(row_binary_dgrey, 2))    
            tiles.append(row_hex_dgrey)
            tiles.append(row_hex_lgrey)

num_tiles = image.shape[0]*image.shape[1]//64
#print(len(tiles))
#print(image.shape)

out_c = open(out_name + ".c", "w")
out_c.write("/*\n")
out_c.write(f"Input image: {in_path}\n")
out_c.write(f"Num Tiles: {num_tiles}\n")
out_c.write("*/\n\n")
out_c.write("/* Start of tile array. */\n")
out_c.write("const unsigned char " + out_name + "[] ={\n")
for i in range(0, len(tiles), 8):
    row = tiles[i:i+8]
    out_c.write("\t" + ",".join(row) + ",\n")
out_c.write("};")
out_c.close()

out_h = open(out_name + '.h', "w")
out_h.write("/*\n")
out_h.write(f"Input image: {in_path}\n")
out_h.write(f"Num Tiles: {num_tiles}\n")
out_h.write("*/\n\n")
out_h.write(f"#define {out_name}Bank 0\n")
out_h.write(f"extern const unsigned char {out_name}[];\n")