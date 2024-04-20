---
title: Decoding the DSat data file
---

# Information

## Image format

Images are apparently stored in the [lightning strike wavelet-compressed
raster image
format](http://justsolve.archiveteam.org/wiki/Lightning_Strike):

-   archived [web page from the
    company](https://web.archive.org/web/19970613234152/http://www.infinop.com/nhtml/lsinfo.shtml)

-   there is a [patent describing the
    approach](https://patents.google.com/patent/WO1998040842A1)

-   archived [homepage of one of the
    developers](https://web.archive.org/web/19990220121339/http://www.compsci.com/%7Echao/)
    and [her publication
    list](https://web.archive.org/web/19990220160521/http://www.compsci.com/%7Echao/Publication/);
    [relevant
    paper](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=3c08d5095a328950539dd8aa13cd11c5d05063f7):
    Hongyang Chao & Paul Fisher, An Approach of integer reversible
    wavelet transform for Lossless image compression, in /Advances in
    Computational Mathematics: Guangzhou, China -- the proceedings of
    Guangzhou International Symposium on Computational Mathematics/,
    Aug. 11-15, 1997, Guangzhou, P.R.China

-   There existed [a browser plugin to decode such
    images](ftp://ftp.sunet.se/mirror/archive/ftp.sunet.se/pub/pc/windows/winsock-indstate/Windows95/WWW-Browsers/Plug-In/).

    -   There also existed a [Java browser
        applet](https://web.archive.org/web/19970613234343/http://www.infinop.com/nhtml/java/index.shtml)
        whose classes were available (after [filling out a
        form](https://web.archive.org/web/19970613235015/http://www.infinop.com/nhtml/download.shtml)),
        both directly usable (e.g.,
        [Lightning.class](https://web.archive.org/web/19970613234343/http://www.infinop.com/nhtml/java/Lightning.class),
        not archived) and as archive on a [download
        page](https://web.archive.org/web/19970613234713/http://www.infinop.com/nhtml/download.shtml)
        (classes.tgz, not archived).

-   there seem to be [different (incompatible)
    versions](https://web.archive.org/web/19970613235015/http://www.infinop.com/nhtml/javafaq.shtml):

    > /I have tried to use some .cod images from my website inside the
    > Java applet, and they do not display correctly. What could be
    > wrong?/
    >
    > Most likely, they were compressed with an earlier version of
    > Lightning Strike. The Java applet was designed for use with
    > Lightning Strike 2.6 images, and for the sake of size and download
    > time, was not made backward compatible. Try opening the images in
    > the Lightning Strike 2.6 compressor and then resaving them in the
    > new format.

### testing images using old Firefox

-   get [Firefox
    1.5.0.9](https://ftp.mozilla.org/pub/firefox/releases/1.5.0.9/win32/en-GB/)
    and install it in Wine
-   copy NPLS32.DLL into plugins folder
-   run Firefox and open [test
    image](https://entropymine.com/samples/cod/fox.cod)

## Coordinate format

-   an older [usenet discussion on how to decode the geo
    coordinates](https://groups.google.com/g/de.org.ccc/c/xlaNafyxmrM/m/hXZj7J5ksc8J)
    -   did we consider
        [SK-42](https://en.wikipedia.org/wiki/SK-42_reference_system)
        and derivatives?

# Next Steps

-   [ ] Visualise the structure of dsatnord.mp, that is, where are city
    names and coordinates, where are the tiles, etc. Maybe that helps to
    find the index for the tiles.
-   [ ] testing the Netscape plugin:
    -   [ ] install it in a VM together with an older version of Firefox
    -   [ ] test it with a [sample
        image](http://justsolve.archiveteam.org/wiki/Lightning_Strike)
    -   [ ] write one tile into a file and try to open it
-   [ ] test
    [SK-42](https://en.wikipedia.org/wiki/SK-42_reference_system) and
    derivatives

# Files

-   `dsatnord.mp` - data for D-Sat 1 CD 1
-   `NPLS32.DLL` - browser plugin for Netscape/Firefox
