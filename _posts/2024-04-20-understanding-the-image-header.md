---
title: Understanding the image header
description: The image header contains the size of the file and the header.
tags: ["cis-cod", "tiles"]
---

One important question remains: Are the tiles in `dsatnord.mp` stored
with or without gaps? To find this out, we would need to know the
actual byte size of each tile. But how to find that out? Well, one
guess is that the data/file size of each image is stored in its
header. The following Python code prints each consecutive 16 bits (two
bytes) among the first 20 bytes as unsigned little endian integer:

```python
with open(fname, "rb") as f:
    for i in range(20):
        f.seek(i)
        b = f.read(2)
        lint = int.from_bytes(b, byteorder='little', signed=False) # unsigned little endian
        print(i, "{:10d}".format(lint), sep='\t')
```

For [fox.cod](https://entropymine.com/samples/cod/fox.cod) (4758
bytes, 640x480 pixels),
[wolf.cod](https://entropymine.com/samples/cod/wolf.cod) (7555 bytes,
768x512 pixels) and our tile (30886 bytes, 500x500 pixels) this
results in the following output:

| offset | fox.cod | wolf.cod | tile.cod | remark    |
|--------+---------+----------+----------+-----------|
|      0 |   18755 |    18755 |    18755 | "CI"      |
|      1 |   21321 |    21321 |    21321 | "IS"      |
|      2 |   13139 |    13139 |    13139 | "S3"      |
|      3 |   11827 |    11827 |    11827 | "3."      |
|      4 |   12334 |    12334 |    12334 |           |
|      5 |    2608 |     2608 |     6704 |           |
|      6 |      10 |       10 |     1050 |           |
|      7 |   15360 |    15360 |    15364 |           |
|      8 |      60 |       60 |       60 | constant? |
|      9 |   23040 |    18176 |    27136 |           |
|     10 |    4698 |     7495 |    30826 | size - 60 |
|     11 |      18 |       29 |      120 |           |
|     12 |       0 |        0 |        0 |           |
|     13 |       0 |        0 |        0 |           |
|     14 |       0 |        0 |        0 |           |
|     15 |   32768 |        0 |    62464 |           |
|     16 |     640 |      768 |      500 | width     |
|     17 |   57346 |        3 |    62465 |           |
|     18 |     480 |      512 |      500 | height    |
|     19 |    6145 |     6146 |     6145 |           |

[As noted before](/2024/04/02/finding-the-tiles.html), the first four
bytes are the magic number "CIS3". At byte offset 10 we see the file
size (minus 60 bytes), at byte offset 16 the image width and at byte
offset 18 the image height.

The zeros at byte positions 12 and 13 indicate that the file size is
likely stored as 32 bit unsigned integer.

Thus, the structure of the first 20 bytes of the (60 byte?) header
seems to be as follows:

| Name                       | Size    | Value    | Comment                              |
|----------------------------+---------+----------+--------------------------------------|
| file header / magic number | 4 bytes | "CIS3"   |                                      |
|                            | 1 byte  | "."      | part of file header?                 |
| unknown                    | 3 byte  |          |                                      |
| header size                | 2 bytes | 56 or 60 | greyscale: 56 bytes, color: 60 bytes |
| data size                  | 4 bytes |          | file size - header size              |
| unknown                    | 1 byte  | 0x00     | always zero?                         |
| unknown                    | 1 byte  |          |                                      |
| image width                | 2 byte  |          |                                      |
| image height               | 2 byte  |          |                                      |

(to be continued)
