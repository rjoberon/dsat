# D-Sat 1

For current development status see [below](#below).

## Introduction

D-Sat 1 is a satellite atlas of Germany, consisting of pictures taken
by russian COSMOS satellites in 1991. Besides viewing the pictures, it
is also possible to search for over 13000 German cities (see
[screenshot](/img/screenshot_dsat1_sandersdorf.png)) and to read the
coordinates of the locations under the mouse pointer. D-Sat 1 was
published in 1996, several versions followed (up to D-Sat 6 AFAIK),
the companies which programmed and distributed D-Sat (SCOUT Systems
and TopWare) are bankrupt now.

Besides the proprietary file format and compression algorithm of the
pictures, the coordinate system (projection/datum) are AFAIK also
unknown. My intention is to decode at least the data of the city
database and to use that data to find out the used coordinate system.

The file **dsatnord.mp** contains the whole city database (dsatsued.mp
also, but not tested). The first location is **\"Aach\"**, offset
unknown (extracted it once and then forgot it \...). I decoded the
main parts of the city database (was\'n so difficult, see below), but
I recognized that the coordinates in the database differ from the
coordinates which are shown if I put the mouse pointer on the basis of
the \"town sign\".

So the basic problem is to find the connection between screen
coordinates (under the mouse pointer), city coordinates (from the
database) and true coordinates. Unfortunately, it is very boring work
to write down the screen coordinates, because it is impossible for me
to get them automatically. So the database of screen coordinates is
very small. On the other hand, I have over 13000 coordinates of German
cities with the problem that some of them are completely wrong (there
existed a corrected update to D-Sat 1, I\'m trying to decode that) and
there is rule which part of the city has been chosen as reference
point.  Therefore, automatic comparison, for example, with OpenGeoDB
data is very difficult.

Unfortunately, some rumours in the Internet also say that the pictures
of D-Sat 1 are very badly geo-referenced. So maybe it is impossible to
discover projection and datum, because it is just very badly
geo-referenced GKK/Potsdam?

## format of city data base

The format of the data is 64 bytes per city:

-   40 Bytes cityname (ASCII)
-   24 Bytes coordinates + other data (to identify), consisting of
    -   Bytes 1-4: have exclusively the following values:


              0    0    0    0
              0    0    0  128
             20  174   71  225
             20  174   71   97
             41   92  143  194
             41   92  143   66
             61   10  215  163
             82  184   30  133
            195  245   40   92
            215  163  112   61
            236   81  184  158
            236   81  184   30

    -   Bytes 5-7: easting, stored as little endian

    -   Byte 8: always 65

    -   Bytes 9-11: always 0

    -   Byte 12: 1995 x 0; 584 x 32; 1878 x 64; 622 x 96; 1825 x 128;
        593 x 160; 1889 x 192; 618 x 224

    -   Bytes 13-15: northing, stored as little endian

    -   Bye 16: always 65

    -   Byte 17: 8486 x 9; 37 x 11; 3 x 17; 447 x 26

    -   Bytes 18-24: always 0

Note: Bytes 1-4, 12 and 17 are geographically independent, i.e. the
values have nothing to do with the location of the cities.

### some sample data

     Byte                     1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24
     Alsenz              __  41   92  143  194  184   76   25   65    0    0    0  192  140   11   85   65    9    0    0    0    0    0    0    0
     Alsfeld             __  20  174   71  225  165  173   31   65    0    0    0  224   81  122   85   65   26    0    0    0    0    0    0    0
     Alsheim             __  41   92  143  194   10  159   27   65    0    0    0  192  170   15   85   65    9    0    0    0    0    0    0    0
     Alsleben/ Saale     __   0    0    0  128   40  234   36   65    0    0    0    0  183  228   85   65   26    0    0    0    0    0    0    0
     Alt Bennebek        __   0    0    0  128    2   30   32   65    0    0    0  128   57    2   87   65    9    0    0    0    0    0    0    0
     Alt Bork            __ 236   81  184  158  134   88   39   65    0    0    0   64  148   28   86   65    9    0    0    0    0    0    0    0
     Alt Duvenstedt      __   0    0    0  128   72  138   32   65    0    0    0   96   47    0   87   65    9    0    0    0    0    0    0    0
     Alt Golm            __  41   92  143   66  103  241   41   65    0    0    0   32  105   46   86   65    9    0    0    0    0    0    0    0
     Alt Krenzlin        __ 236   81  184   30   67  245   35   65    0    0    0   64  118  146   86   65    9    0    0    0    0    0    0    0
     Alt Madlitz         __  41   92  143  194  244   64   42   65    0    0    0   64  137   55   86   65    9    0    0    0    0    0    0    0
     Alt Mahlisch        __  41   92  143  194   33  130   42   65    0    0    0  192   12   65   86   65    9    0    0    0    0    0    0    0
     Alt Meteln          __  41   92  143  194  123  252   35   65    0    0    0   96   18  193   86   65    9    0    0    0    0    0    0    0
     Alt Mölln           __ 236   81  184   30  106  154   34   65    0    0    0   64  141  177   86   65    9    0    0    0    0    0    0    0
     Alt Rehse           __  41   92  143  194   34  181   39   65    0    0    0   64   40  171   86   65    9    0    0    0    0    0    0    0
     Alt Schwerin        __  41   92  143   66  217   15   38   65    0    0    0  128  252  169   86   65    9    0    0    0    0    0    0    0
     Alt Schönau         __  41   92  143  194  133  207   38   65    0    0    0   64   22  179   86   65    9    0    0    0    0    0    0    0
     Alt Sührkow         __  41   92  143  194  180  156   38   65    0    0    0  160  111  202   86   65    9    0    0    0    0    0    0    0
     Alt Tucheband       __   0    0    0  128  189  174   42   65    0    0    0  192  165   73   86   65    9    0    0    0    0    0    0    0
     Alt Zauche          __   0    0    0    0  203  206   41   65    0    0    0  128  246    3   86   65    9    0    0    0    0    0    0    0
     Alt Zeschdorf       __   0    0    0    0  228  146   42   65    0    0    0  128   30   61   86   65    9    0    0    0    0    0    0    0
     Alt-Schadow         __  20  174   71   97  112  159   41   65    0    0    0  192  164   25   86   65    9    0    0    0    0    0    0    0
     Altbach             __  20  174   71   97  167   30   32   65    0    0    0   32  249  158   84   65    9    0    0    0    0    0    0    0
     Altbrandsleben      __   0    0    0  128  188  249   35   65    0    0    0    0  170   11   86   65    9    0    0    0    0    0    0    0

### put into an image \...

OK, so let\'s take all 13378 cities, their easting/northing and put them
into a cartesian coordinate system: [orte.ps.gz](/img/orte.ps.gz); function
used to transform the coordinates into PostScript-compatible values:
PS_E = (500.0/1835000.0) \* (E-1114000), PS_N = (1000.0/262144.0) \*
(N-5505000)\
![](/img/dsat1_dekodiert_1.png) Nice, isn\'t it? :-)\
(besides an east-west-compression - which may result from conversion to
Postscript-Coordinates?!)

For me this picture was the prove, that I really found the coordinates
of the cities and not some other data. I also tried to colorize the
points, depending on the value of the unidentified bytes, but that
yielded no pattern - the colors were spread all over germany.

### comparison to known data

explanation of the columns in the following table:

-   file_E/file_N: easting/northing which I got from the decoded city
    database
-   screen_E/screen_N: easting/northing which is shown on screen, when I
    put the mouse pointer on the basis of the town sign (see
    [screenshot](/img/screenshot_dsat1_sandersdorf.png))
-   GKK/Potsdam, UTM/WGS84: I tried to find the locations of the town
    signs in the topographical map 1:25000 and wrote down the
    coordinates (see red cross in [screenshot
    TK25](/img/screenshot_tk25_sandersdorf.png) and compare with [screenshot
    D-Sat 1](/img/screenshot_dsat1_sandersdorf.png)). Of course, this is very
    error prone, because it\'s impossible to get the exact location.
-   screen_E-GKK_E: difference between screen-easting and
    GKK/Potsdam-easting
-   screen_N-GKK_N: difference between screen-northing and
    GKK/Potsdam-northing

The fact, that I have only two geo-referenced Top25-maps is the reason
for the few data here. :-(

  city                                                                                                             file_E    file_N    screen_E     screen_N     \_GKK/Potsdam\_(4)\_   UTM/WGS84\_(33U)     screen_E - GKK_E   screen_N - GKK_N
  ---------------------------------------------------------------------------------------------------------------- --------- --------- ------------ ------------ ---------------------- -------------------- ------------------ ------------------
  Salzfurtkapelle                                                                                                  2488688   5629157   4507038.0m   5729278.0m   4512121E - 5728869N    304711E - 5730783N   -5083              409
  Wolfen                                                                                                           2501091   5628611   4513170.0m   5726920.0m   4518355E - 5726409N    310938E - 5727642N   -5185              511
  Sandersdorf (Screenshots: [TK25](/img/screenshot_tk25_sandersdorf.jpg), [D-Sat1](/img/screenshot_dsat1_sandersdorf.png))   2501138   5627385   4513056.0m   5722012.0m   4518214E - 5721479N    310460E - 5723154N   -5158              533
  Thalheim                                                                                                         2496565   5628002   4510842.0m   5724544.0m   4515992E - 5724054N    308346E - 5725823N   -5150              490
  Jeßnitz                                                                                                          2507842   5629039   4516584.0m   5728546.0m   4521814E - 5727937N    314323E - 5729459N   -5230              609
  Greppin                                                                                                          2506254   5627847   4515666.0m   5723788.0m   4520853E - 5723274N    313171E - 5724839N   -5187              514
  Paplitz                                                                                                          2662879   5640168   4595124.0m   5771098.0m   4601091E - 5769517N    395230E - 5767732N   -5967              1581
  Horstwalde                                                                                                       2653560   5641043   4590582.0m   5774734.0m   4596532E - 5773231N    390830E - 5771630N   -5950              1503

In [dsat_difference_vector.ps](/img/dsat_difference_vector.ps) I have
drawn the difference vectors to the real locations (screen_E-GKK_E and
screen_N-GKK_N). Note: the signs are drawn wrong (always positive). To
me that looks good, i.e. there seems to be a systematic error to the
real locations.\ generation of file (plus header/footer):

    awk '{f=200} {print "newpath " ($4-4507000)/f " "($5-5720000)/f \
          " 1 0 360 arc fill \
          newpath " ($4-4507000)/f " " ($5-5720000)/f " moveto " \
          ($6-4507000)/f " " ((2*$5)-$7-5720000)/f " lineto stroke "}' \
          < vergleich_2  > dsat_difference_vector.ps

Difference Vectors: ![](/img/dsat_difference_vector.jpg)

### it gets worse

In D-Sat you can put markers on the map to remember locations. The
location of the markers is saved in dsat.ini. Very simple format:

    M005Key1=5
    M005Key2=32838
    M005Key3=248766
    M005File=

Key1 selects the symbol, which is shown on the screen, so the other two
values should be the coordinates of the marker. The problem is very
simple:

     city           : file_E  : file_N  :  screen_E  : screen_N  :dsat.ini :dsat.ini
     List           : 1853914 : 5719936 :  4261239.0 : 6101200.0 :   32838 : 248766
     Oberstdorf     : 2242906 : 5509437 :  4371513.0 : 5252560.0 :  881472 : 359034
     Selfkant       : 1128882 : 5610221 :  4068213.0 : 5665063.0 :  468978 :  55734
     Deschka        : 2890943 : 5620266 :  4704306.0 : 5688157.0 :  445878 : 691830

(BTW: these are the most northern, southern, western and eastern cities
inside D-Sat.) The first two values file_E/file_N are extracted by me
from the dsatnord.mp file, the second two values screen_E/screen_N are
shown on the screen and the third two values are from the markers, I put
on the city-location.

### Help!

If you have ideas that could help to decode any of that coordinates,
[I](https://amor.cms.hu-berlin.de/~jaeschkr/) would be glad to hear
from you.  I\'m also interested in information regarding the rumour,
that the pictures in D-Sat1 are very badly geo-referenced and so it is
impossible to get correct coordinates.

### [Current development status]{#below}

Thanks to Mikael Rekola, because he pointed out that the coordinates
in the city database could also be stored as (long) floating
point. And that could be indeed true! I\'m still doing some
comparisons, but actually the floating point values again give a map
of Germany: [new.ps.gz](/img/new.ps.gz). This map is much more
distorted, if I don\'t scale it appropriately.

The second and third column show the new values for locations given
above:

    ort file_e   file_n    screene screenn gkk_e   gkk_n
    sfk 720056.4 5739412.0 4507038 5729278 4512121 5728869
    wol 726257.7 5737228.0 4513170 5726920 4518355 5726409
    sdf 726281.1 5732326.0 4513056 5722012 4518214 5721479
    tha 723994.5 5734795.5 4510842 5724544 4515992 5724054
    jes 729633.4 5738941.0 4516584 5728546 4521814 5727937
    gre 728839.4 5734175.0 4515666 5723788 4520853 5723274
    pap 807151.8 5783457.0 4595124 5771098 4601091 5769517
    hor 802492.2 5786956.0 4590582 5774734 4596532 5773231

------------------------------------------------------------------------

Last change: 2005-03-26
