#!/usr/bin/python3
# -*- coding: utf-8 -*-

#
# Handle .cod files.
#
# Usage: cod.py --help
#
# Author: rja
#
# Changes:
# 2024-05-10 (rja)
# - renamed variables to reflect header size and data size
# 2024-04-20 (rja)
# - initial version

import os
import argparse

version = "0.0.3"

# | image             | width | height |  size |   b10 | size - b10 |  b16 |  b18 |
# |-------------------+-------+--------+-------+-------+------------+------+------|
# | fox.cod           |   640 |    480 |  4758 |  4698 |         60 |  640 |  480 |
# | wolf.cod          |   768 |    512 |  7555 |  7495 |         60 |  768 |  512 |
# | tile.cod          |   500 |    500 | 30886 | 30826 |         60 |  500 |  500 |
# | tile_99756991.cod |  1000 |   1000 | 24154 | 24098 |         56 | 1000 | 1000 |
# #+TBLFM: $6=$-2-$-1


def print_bytes(fname, n=20):
    """Print the first n bytes of the file as 16 bit little endian unsigned ints."""
    fsize = os.path.getsize(fname)
    print("size =", fsize)
    with open(fname, "rb") as f:
        for i in range(n):
            f.seek(i)
            b = f.read(2)
            lint = int.from_bytes(b, byteorder='little', signed=False) # unsigned little endian
            print(i, "{:10d}".format(lint), sep='\t')


def print_header(fname):
    with open(fname, "rb") as f:
        hsize, dsize, width, height = parse_header(f.read(20))
        print(hsize, dsize, width, height, sep='\t')


def parse_header(hbytes):
    """Parse and return the (so far) known header fields."""
    hsize  = int.from_bytes(hbytes[8:10], byteorder='little', signed=False)  # header size
    dsize  = int.from_bytes(hbytes[10:14], byteorder='little', signed=False) # data size
    width  = int.from_bytes(hbytes[16:18], byteorder='little', signed=False)
    height = int.from_bytes(hbytes[18:20], byteorder='little', signed=False)
    return hsize, dsize, width, height


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='read .cod files.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('input', type=str, help='input file')

    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

#    print_bytes(args.input)
    print_header(args.input)
