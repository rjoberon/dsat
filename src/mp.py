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
# 2024-04-20 (rja)
# - added support to extract tiles
# 2024-04-02 (rja)
# - initial version

import argparse
from PIL import Image
import os
import cod

version = "0.0.2"


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


def get_color(width, bsize):
    col = bsize / 1024 * 255
    if width == 250:
        return (col, 0, 0)
    elif width == 500:
        return (0, col, 0)
    elif width == 1000:
        return (0, 0, col)
    return (0, 0, 0)


def set_pixel(pixels, pos, size, width):
    row = pos // 2**20
    col = (pos - (row * 2**20)) // 1024
    #pixels[pos % 1024, pos // 1024] = 1


def vis_content(fname):
    # get file size
    fbytes = os.path.getsize(fname)
    isize = ((fbytes // 2**20) + 1, 1024)
    print(fbytes, isize)

    img = Image.new('1', isize, "white")
    pixels = img.load()

    with open(fname, "rb") as f:
        pos = -1
        oldpos = -1
        while ((b := f.read(1))):
            pos += 1
            if b == b'\x43':                 # C
                b = b + f.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    c60, size, width, height = cod.parse_header(b + f.read(16))
                    set_pixel(pixels, pos, size, width)
                    oldpos = pos
                    pos += 16
                pos += 3
        fbase, fext = os.path.splitext(fname)
        img.save(fbase + ".png", "PNG")


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


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='read .mp files.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('input', type=str, help='input file')
    parser.add_argument('-c', '--command', choices=['offsets', 'extract', 'vis'], default='offsets')
    parser.add_argument('--offset', type=int, help='offset to extract')
    parser.add_argument('-o', '--out', type=str, help='output file')
    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

    if args.command == 'offsets':
        dump_offsets(args.input)
    elif args.command == 'extract':
        extract_tile(args.input, args.out, args.offset)
    elif args.command == 'vis':
        vis_content(args.input)
