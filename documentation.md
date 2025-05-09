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

| start offset | length [bytes] | end offset | name      | comment                                                |
| -----------: | -------------: | ---------: | :-------- | :----------------------------------------------------- |
|            0 |             16 |         16 | header    |                                                        |
|           16 |         316004 |     316020 | offsets   | offsets of the tiles                                   |
|       316020 |         754077 |    1070097 | tiles0    | 20 color tiles of size 250x250 (zoom level 0)          |
|      1070097 |        9056940 |   10127037 | tiles1    | 169 color tiles of size 500x500 (zoom level 1)         |
|     10127037 |         567760 |   10694797 | paths     | borders and highways                                   |
|     10694797 |        1970696 |   12665493 | topware   | two BMP images (aerials of the topware headquarter)    |
|     12665493 |         857216 |   13522709 | places    | list of 13394 places and their coordinates             |
|     13522709 |            384 |   13523093 | unknown   |                                                        |
|     13523093 |         980478 |   14503571 | citysigns | signs (75x50 BMP images) for 201 cities                |
|     14503571 |        1691200 |   16194771 | paths     | borders and highways                                   |
|     16194771 |       70627806 |   86822577 | tiles2    | 2240 color tiles of size 500x500 (zoom level 2)        |
|     86822577 |      557983062 |  644805639 | tiles3    | 24700 greyscale tiles of size 1000x1000 (zoom level 3) |
|    644805639 |          19277 |  644824916 | unknown   |                                                        |
|    644824916 |           8995 |  644833911 | unknown   |                                                        |
