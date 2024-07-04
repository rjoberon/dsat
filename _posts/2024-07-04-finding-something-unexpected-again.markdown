---
title: Finding something unexpected again
image: /img/aachen.png
description:
---

This week I was poking around in the few remaining unknown territories
of `dsatnord.mp` with the excellent [Kaitai Struct
Visualizer](https://github.com/kaitai-io/kaitai_struct_visualizer/)
(ksv) again. I have known for quite some time now that [the city
database](/2005/03/26/decoding-the-city-database.html) is followed by
some strings that seem to be related to the development of that
database, namely `D:\Dsat\Dsat23\CityDlg.cpp` and
`c:\temp\cityname.bin`. When I showed my colleagues that part using
ksv, it looked like this:

![Kaitai Struct Visualizer showing an unknown part of dsatnord.mp](/img/unknown3_1.png)

At the left we see the structure I have identified so far and right of
it we see the hex values of the data and their ASCII counterpart (if
it exists). The grey background highlights the so far uncharted part
after the city database that starts with the mentioned strings.

While inspecting the hex values someone said "look, down there it
continues with 'BM' – is there a bitmap?" Indeed, the abovementioned
strings are followed by several null bytes and then we can see the
byte sequence 0x42 0x4d or `BM` in ASCII. Having written a parser for
[Windows Bitmap files](https://en.wikipedia.org/wiki/BMP_file_format)
a couple of years ago and, more recently, Python code to write such
files byte by byte, I also immediately recognized this as the format
indicator for Windows Bitmap files. So let's inspect this closer!

And here the power of Kaitai Struct comes in, as its [collection of
file format definitions](https://formats.kaitai.io/) contains [one for
bitmap files](https://formats.kaitai.io/bmp/). So I just grabbed [the
specification
file](https://github.com/kaitai-io/kaitai_struct_formats/blob/master/image/bmp.ksy)
and included it in a brief specification that basically skips the data
up to the relevant part:

```yaml
meta:
  id: unknown3_1
  endian: le
  imports:
    - bmp
seq:
  - id: skip
    size: 16 + 316004 + 754077 + 9056940 + 2538456 + (13394 * 64)
  - id: un3_1
    size: 980862
    type: un3
types:
  un3:
    seq:
      - id: strings
        size: 24*16
      - id: isthisabitmap
        type: bmp
        size: 10000
```

Opening ksv with `ksv dsatnord.mp unknown3_1.ksy` gave no warnings or
error messages but instead showed this:

![The part indeed seems to contain a bitmap image.](/img/thisisabitmap.png)

So this could indeed be a bitmap file, 75 pixels wide and 50 pixels
high. It's size should then be 4878 bytes (field `len_file`) and thus
I used `dd` to extract that part:

```sh
dd if=dsatnord.mp of=bitmap.bmp bs=1 skip=$((16 + 316004 + 754077 + 9056940 + 2538456 + (13394 * 64) + 24*16)) count=4878
```

Here's the result:

![Aachen](/img/aachen.png)

A town sign of Aachen! What a surprise.

The obvious question then was: what comes next? A quick look at ksv
showed another `BM` sequence right after that bitmap. So there's more!
What is it? Look:

![Aalen](/img/aalen.png)

Another one! You can now probably guess what happened: it's not just
two but more ... but how many? 201! Here they are (conveniently
arranged in a 17 by 12 grid):

![All 201 city signs](/img/city_signs.png)

These are all town signs of larger German towns. I first thought these
might be the district towns ("Kreisstädte") but since [Germany
currently has only 294 districts
("Landkreise")](https://de.wikipedia.org/wiki/Liste_der_Landkreise_in_Deutschland)
this cannot be true. Due to local government reorganizations in the
past decades the number should have been even higher in the 1990s. So
another mystery to solve.

What I found also remarkable is the fact that 4878*201 = 980478 bytes
(more than a [double density DOS formatted floppy disk could
fit](https://en.wikipedia.org/wiki/List_of_floppy_disk_formats)) were
used to represent very simple town signs in an uncompressed image
format. The code to create the signs at runtime should have required
much less space but maybe there was not time to write the code.
