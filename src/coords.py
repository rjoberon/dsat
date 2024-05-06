#!/usr/bin/python3
# -*- coding: utf-8 -*-

#
# Extract and transform coordinates
#
# Usage:
#
# Author: rja
#
# Changes:
# 2024-04-24 (rja)
# - initial version

import argparse
from struct import unpack

version = "0.0.1"

soff = 12665493
eoff = 13522709

def get_city(fname, city, soff=soff, eoff=eoff):
    off = soff
    with open(fname, "rb") as f:
        f.seek(off)
        while ((data := f.read(64)) and off < eoff):
            # first 40 Bytes: city name
            cname = data[:40].decode("latin1").rstrip('\x00')
            if city == cname:
                east_int  = int.from_bytes(data[44:47], byteorder="little", signed=False)
                north_int = int.from_bytes(data[52:553], byteorder="little", signed=False)
                east_float  = unpack('<d', data[40:48])[0]
                north_float = unpack('<d', data[48:56])[0]
                return east_int, north_int, east_float, north_float
            off += 64


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read city coordinates', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('city', type=str, help='city')
    parser.add_argument('-f', '--file', type=str, help="input file", default="dsatnord.mp")
    parser.add_argument('-v', '--version', action="version", version="%(prog)s " + version)

    args = parser.parse_args()

    city = get_city(args.file, args.city)
    print(city)
