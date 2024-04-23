#!/usr/bin/python3
# -*- coding: utf-8 -*-

#
# Reads .mp files
#
# Usage: mp.py --help
#
# Author: rja
#
# Changes:
# 2024-04-23 (rja)
# - implemented dump_ints
# 2024-04-21 (rja)
# - implemented vis_content and accompanying functions
# - implemented vis_bytes and dump_bytes
# 2024-04-20 (rja)
# - added support to extract tiles
# 2024-04-02 (rja)
# - initial version

import argparse
from PIL import Image
import os
import cod

version = "0.0.3"


def dump_offsets(fname):
    with open(fname, "rb") as f:
        pos = -1
        oldpos = -1
        while ((b := f.read(1))):
            pos += 1
            if b == b'\x43':                 # C
                b = b + f.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    # bytes 8+9
                    c60, size, width, height = cod.parse_header(b + f.read(16))
                    print(pos, pos - oldpos, c60, size, width, height, sep='\t')
                    oldpos = pos
                    pos += 16
                pos += 3


def get_color(twidth, bsize, bpp):
    """
    twidth : pixel width of tile (250, 500, 1000)
    bsize : bytes in block
    bpp : bytes per pixel
    """
    col = int(bsize / bpp * 255)           # color intensity in range [0..255]
    if twidth == 250:
        return (col, 0, 0)                 # red
    elif twidth == 500:
        return (0, col, 0)                 # green
    elif twidth == 1000:
        return (0, 0, col)                 # blue
    elif twidth == -1:                     # hack: city database
        return (col, 0, col)               # magenda
    return (0, 0, 0)


def get_pixels(spos, epos, twidth, bpp):
    """
    spos : start position of tile (byte offset)
    epos : end position of tile (byte offset)
    twidth : pixel width of tile (250, 500, 1000)
    bpp : bytes per pixel
    """
    #
    # |    <|-----|-----|-----|-----|-->  |
    # ^                             ^
    # spos                          epos
    #

    fb = (spos // bpp + 1) * bpp - spos    # bytes in first block
    nb = epos // bpp - spos // bpp - 1     # number of full blocks
    lb = epos - (epos // bpp) * bpp        # bytes in last block

    return [get_color(twidth, fb, bpp)] + ([get_color(twidth, bpp, bpp)] * nb) + [get_color(twidth, lb, bpp)]


def set_pixels(pixels, spos, pix, bpp, width):
    """
    pixels : bitmap to draw on
    spos : start position of tile (byte offset)
    bpp : bytes per pixel
    width : width of bitmap
    """
    sposblock = spos // bpp                # start block
    for i, p in enumerate(pix):
        cposblock = sposblock + i          # current block
        row = cposblock // width
        col = cposblock % width
        set_color(pixels, col, row, p)


def set_color(pixels, col, row, c):
    """
    pixels : bitmap to draw on
    col : column for pixel to set
    row : row for pixel to set_color
    c : color to set/add
    """
    currc = pixels[col, row]               # current color of pixel
    newc = (
        min(255, currc[0] + c[0]),
        min(255, currc[1] + c[1]),
        min(255, currc[2] + c[2])
    )
    pixels[col, row] = newc


def set_citydb(pixels, bpp, width):
    """
    FIXME: hard-coded offsets for city database in dsatnord.mp
    """
    spos = 12665493
    epos = 13522709
    pix = get_pixels(spos, epos, -1, bpp)
    set_pixels(pixels, spos, pix, bpp, width)


def vis_content(fname, foutname, bpp=2**10, width=2**10):
    """
    Visualise the distribution of tiles (and other content) by coloring pixels of a bitmap.

    One pixel represents bpp (default: 1024) bytes of the original file.

    bpp : bytes per pixel
    width : image width

    """
    fbytes = os.path.getsize(fname)        # file size
    height = (fbytes // (bpp * width)) + 1 # image height
    print(fbytes, width, height)

    img = Image.new('RGB', (width, height), "black")
    pixels = img.load()

    with open(fname, "rb") as f:
        pos = -1
        while ((b := f.read(1))):
            pos += 1
            if b == b'\x43':                 # C
                b = b + f.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    c60, tsize, twidth, theight = cod.parse_header(b + f.read(16))
                    pix = get_pixels(pos, pos + tsize, twidth, bpp)
                    set_pixels(pixels, pos, pix, bpp, width)
                    pos += 16
                pos += 3
        # FIXME: hard-coded city database offsets
        set_citydb(pixels, bpp, width)
        img.save(foutname, "PNG")


def extract_tile(finname, foutname, offset):
    with open(finname, "rb") as fin, open(foutname, 'wb') as fout:
        fin.seek(offset)
        b = fin.read(4)
        fout.write(b)
        while ((b := fin.read(1))):
            if b == b'\x43':                 # C
                b = b + fin.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    return
                else:
                    fout.write(b)
            else:
                fout.write(b)


def vis_bytes(fname, foutname):
    with open(fname, "rb") as f:
        fbytes = os.path.getsize(fname)        # file size
        width = 1024
        height = fbytes // width + 1            # image height
        img = Image.new('L', (width, height), "black")
        pixels = img.load()
        for pos in range(os.path.getsize(fname)):
            f.seek(pos)
            b = f.read(1)
            pixels[pos % width, pos // width] = int.from_bytes(b, signed=False)
        img.save(foutname, "PNG")


def dump_bytes(fname):
    with open(fname, "rb") as f:
        for pos in range(os.path.getsize(fname)):
            f.seek(pos)
            b = f.read(4)
            lint = int.from_bytes(b, byteorder='little', signed=False)
            print(pos, "{:10d}".format(lint), sep='\t')


def dump_ints(fname):
    with open(fname, "rb") as f:
        # skip 16 byte header
        f.seek(16)
        pos = 16
        while ((b := f.read(4))):
            lint = int.from_bytes(b, byteorder='little', signed=False)
            print(pos, "{:10d}".format(lint), sep='\t')
            pos += 4

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='read .mp files.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('input', type=str, help='input file')
    parser.add_argument('-c', '--command', choices=['offsets', 'extract', 'vis', 'dump_bytes', 'vis_bytes', 'dump_ints'], default='offsets')
    parser.add_argument('--offset', type=int, help='offset to extract')
    parser.add_argument('--width', type=int, help='vis: image width', default=2**10)
    parser.add_argument('--bpp', type=int, help='vis: bytes per pixel', default=2**10)
    parser.add_argument('-o', '--out', type=str, help='output file')
    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

    if args.command == 'offsets':
        dump_offsets(args.input)
    elif args.command == 'extract':
        extract_tile(args.input, args.out, args.offset)
    elif args.command == 'vis':
        vis_content(args.input, args.out, args.bpp, args.width)
    elif args.command == 'dump_bytes':
        dump_bytes(args.input)
    elif args.command == 'dump_ints':
        dump_ints(args.input)
    elif args.command == 'vis_bytes':
        vis_bytes(args.input, args.out)
