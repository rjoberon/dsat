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
                    print(pos, pos - oldpos, sep='\t')
                    oldpos = pos
                pos += 3


def vis_content(fname):
    # get file size
    fbytes = os.path.getsize(fname)
    img = Image.new('1', (1024, fbytes // 1024 + 1024), "white")
    pixels = img.load()
    with open(fname, "rb") as f:
        pos = 0
        oldpos = 0
        while ((b := f.read(1))):
            pos += 1
            if b == b'\x43':                 # C
                b = b + f.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    #print(b.decode(), f.read(7))
                    pixels[pos % 1024, pos // 1024] = 1
                    print(pos, pos - oldpos, sep='\t')
                    oldpos = pos
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
