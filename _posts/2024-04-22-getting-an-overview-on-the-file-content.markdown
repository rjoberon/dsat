---
title: Getting an overview on the file content
---

In [the last
post](/2024/04/21/visualising-the-tile-size-distribution.html) we
already gained a good overview on the distribution of tiles in
`dsatnord.mp`. Together with [the first
post](/2005/03/26/decoding-the-city-database.html) this allows us to
find the parts of the file which we do not understand, yet.

To get an overview, we visualise the distribution of the tiles (of
different size) and the city database by coloring the pixels of a
bitmap:

```sh
./src/mp.py -c vis -o img/dsatnord.png  dsatnord.mp
```

To include the city database, we need the start and end offset. [The
first city is "Aach"]((/2005/03/26/decoding-the-city-database.html))
and its offset 12665493 we get easily using `grep -a -b -o Aach
dsatnord.mp`. To find the last city, I started with "Zwickau" (`grep
-a -b -o Zwickau dsatnord.mp` – taking the last offset) and then
continued with `hexdump -C -s 13519509 dsatnord.mp| head -n250`. The
last city is "Üxheim" at offset 13522645, so the city database should
end at 13522645 + 64 = 13522709.

While we are at it (searching through `dsatnord.mp`), here are some
interesting strings I found:
- `D:\Dsat\Dsat23\CityDlg.cpp..c:\temp\cityname.bin` (at offset
  13522709, that is, immediately after the city database)
- `bmp.02..mp`, `stbmp002.bmp`

Anyways, here is the resulting bitmap showing the locations of the
tiles and city database:

![](/img/dsatnord.png)

Each pixel represents 1024 bytes (= 1 Kibibyte) of the original file.
The image is 1024 pixels wide such that each row represents
1 Mebibyte.

color legend:
- blue: 24701 tiles of size 1000x1000
- green: 2409 tiles of size 500x500
- red: 20 tiles of size 250x250 (at the very beginning)
- magenta: 13522709 - 12665493 = 857216 bytes city database (for
  857216 / 64 = 13394 cities)

The positions of the segments are as follows:

|     start |       end |    length | size [MB] | segment         | comment                     |
|-----------+-----------+-----------+-----------+-----------------+-----------------------------|
|         0 |    316020 |    316020 |       0.3 | unknown1        |                             |
|    316020 |   1070097 |    754077 |       0.7 | tiles 250x250   | 20 tiles                    |
|   1070097 |  10127037 |   9056940 |       8.6 | tiles 500x500   | 169 tiles                   |
|  10127037 |  12665493 |   2538456 |       2.4 | unknown2        |                             |
|  12665493 |  13522709 |    857216 |       0.8 | city database   | 13394 cities, 64 bytes each |
|  13522709 |  16194771 |   2672062 |       2.5 | unknown3        |                             |
|  16194771 |  86822577 |  70627806 |      67.4 | tiles 500x500   | 2240 tiles                  |
|  86822577 | 644833451 | 558010874 |     532.2 | tiles 1000x1000 | 24701 tiles                 |
| 644833451 | 644833911 |       460 |       0.0 | unknown4        |                             |

<!-- #+TBLFM: $3=$-1-$-2::$4=$-1/1024/1024;%2.1f -->

Conclusion: There seem to be two sets of 500x500 tiles (also by size,
as we [observed
before](/2024/04/21/visualising-the-tile-size-distribution.html)) and
inbetween them is the city database and unidentified space. I guess
(and hope) that we can find the tile index there.
