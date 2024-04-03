#!/usr/bin/python3
# -*- coding: utf-8 -*-

#
# Reads .mp files
#
# Usage:
#
# Author: rja
#
# Changes:
# 2024-04-02 (rja)
# - initial version

import argparse

version = "0.0.1"


def read_tiles(fname):
    with open(fname, "rb") as f:
        pos = 0
        oldpos = 0
        while ((b := f.read(1))):
            pos += 1
            if b == b'\x43':                 # C
                b = b + f.read(3)
                if b == b'\x43\x49\x53\x33': # CIS3
                    #print(b.decode(), f.read(7))
                    print(pos, pos - oldpos)
                    oldpos = pos
                pos += 3



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='read .mp files.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('input', type=str, help='input file')
    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

    read_tiles(args.input)
