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
# 2024-06-24 (rja)
# - migrated to generated parser by kaitai struct
# 2024-05-10 (rja)
# - renamed variables to reflect header size and data size
# 2024-04-20 (rja)
# - initial version

import argparse
from cis import Cis

version = "0.1.0"

# | image             | width | height |  size |   b10 | size - b10 |  b16 |  b18 |
# |-------------------+-------+--------+-------+-------+------------+------+------|
# | fox.cod           |   640 |    480 |  4758 |  4698 |         60 |  640 |  480 |
# | wolf.cod          |   768 |    512 |  7555 |  7495 |         60 |  768 |  512 |
# | tile.cod          |   500 |    500 | 30886 | 30826 |         60 |  500 |  500 |
# | tile_99756991.cod |  1000 |   1000 | 24154 | 24098 |         56 | 1000 | 1000 |
# #+TBLFM: $6=$-2-$-1


def print_bytes(bytes):
    """Print the bytes as hex."""
    for i, b in enumerate(bytes):
        print("{:02x}".format(b), end=' ')
        if (i + 1) % 16 == 0:
            print()
    print()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='read .cod files.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('input', type=str, help='input file')

    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

    c = Cis.from_file(args.input)

    print("width", c.header.width, sep=':\t')
    print("height", c.header.height, sep=':\t')
    print("header", c.header.header_size, sep=':\t')
    print("data", c.header.data_size, sep=':\t')
    print_bytes(c.header.unknown5)
