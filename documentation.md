---
title: Documentation
description: This page documents findings from the analyses described in the posts.
layout: default
---

# Content of the D-Sat 1 CD-ROMs

| file name     | size [bytes] | comment                                                 |
| :------------ | -----------: | :------------------------------------------------------ |
| cserve        |              | directory with Compuserve installation files            |
| dsat.exe      |       947712 | D-Sat 1 executable                                      |
| dsat.hlp      |       376321 | Help file                                               |
| dsat.ini      |          337 | Initialisation file                                     |
| dsatnord.mp   |    644833911 | Data file (focus of this web site)                      |
| dsat.vec      |        37460 | (apparently) vector data for highways (and maybe more)  |
| install.exe   |       147939 | Installer                                               |
| lsd26dll.dll  |        69632 | DLL to decode the CIS/COD encoded raster images (tiles) |
| mannh1.bmp    |       251078 | Aerial image of the Topware headquarter in Mannheim     |
| mannh2.bmp    |       251078 | Aerial image of the Topware headquarter in Mannheim     |
| mmsystem.dll  |       105520 | DLL for Microsoft Windows multimedia APIs               |
| prodinfo.hlp  |       437806 | Help file                                               |
| readme.txt    |         1499 | README                                                  |
| techinfo.hlp  |        88923 | Help file                                               |
| win32s        |              | directory                                               |

That is the content for the disc DSATNORD. The disc DSATSUED is
identical, except that it contains `dsatsued.mp` (668446819 bytes)
instead of `dsatnord.mp`.

# Content of dsatnord.mp

More concisely described in [dsat.ksy](src/dsat.ksy) using [Kaitai Struct](https://kaitai.io/).

| start offset | end offset |           size | number of records | record size | name               | description                                            |
| -----------: | ---------: | -------------: | ----------------: | ----------: | :----------------- | :----------------------------------------------------- |
|            0 |         15 |             16 |                 1 |          16 | [header][l:hea]    |                                                        |
|           16 |     316019 |         316004 |             79001 |           4 | [offsets][l:off]   | offsets of the tiles                                   |
|       316020 |    1070096 |         754077 |                20 |             | [tiles0][l:til]    | color tiles of size 250x250 (zoom level 0)             |
|      1070097 |   10127036 |        9056940 |               169 |             | [tiles1][l:til]    | color tiles of size 500x500 (zoom level 1)             |
|     10127037 |   10694796 |         567760 |             70970 |           8 | [paths][l:top]     | borders and highways                                   |
|     10694797 |   12665492 |        1970696 |                 2 |             | [topware][l:top]   | aerial photos (BMP) of the Topware headquarter         |
|     12665493 |   13522708 |         857216 |             13394 |          64 | [places][l:pla]    | places and their coordinates                           |
|     13522709 |   13523092 |            384 |                   |             | unknown            |                                                        |
|     13523093 |   14503570 |         980478 |               201 |        4878 | [citysigns][l:sig] | signs for cities (75x50 BMP images)                    |
|     14503571 |   16194770 |        1691200 |            105700 |          16 | [paths][l:pat]     | borders and highways                                   |
|     16194771 |   86822576 |       70627806 |              2240 |             | [tiles2][l:til]    | color tiles of size 500x500 (zoom level 2)             |
|     86822577 |  644805638 |      557983062 |             24700 |             | [tiles3][l:til]    | greyscale tiles of size 1000x1000 (zoom level 3)       |
|    644805639 |  644824915 |          19277 |                   |             | unknown            |                                                        |
|    644824916 |  644833910 |           8995 |                   |             | unknown            |                                                        |

Notes: *Offsets*, *sizes*, and *record sizes* are given in bytes. If
given, *record size* × *number of records* = *size* should hold.

[l:hea]: /2024/04/23/searching-for-the-index.html
[l:off]: /2024/05/11/visualising-entropy.html
[l:pat]: /2024/05/06/finding-something-unexpected.html
[l:pla]: /2005/03/26/decoding-the-city-database.html
[l:sig]: /2024/07/04/finding-something-unexpected-again.html
[l:til]: /2024/04/02/finding-the-tiles.html
[l:top]: /2024/07/28/solving-a-mystery.html
