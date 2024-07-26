---
title: Learning about the image format
description: The tiles are stored in the lightning strike wavelet-compressed raster image format.
tags: ["cis-cod", "tiles"]
---


The tiles are apparently stored in the [lightning strike
wavelet-compressed raster image
format](http://justsolve.archiveteam.org/wiki/Lightning_Strike). Apparently,
there exists no free software to work with such files. Here's what we found:

- archived [web page from the
  company](https://web.archive.org/web/19970613234152/http://www.infinop.com/nhtml/lsinfo.shtml)
  that developed the format
- there is a [patent describing the
  approach](https://patents.google.com/patent/WO1998040842A1)
- archived [homepage of one of the
  developers](https://web.archive.org/web/19990220121339/http://www.compsci.com/%7Echao/)
  and [her publication
  list](https://web.archive.org/web/19990220160521/http://www.compsci.com/%7Echao/Publication/);
  [relevant
  paper](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=3c08d5095a328950539dd8aa13cd11c5d05063f7):
  Hongyang Chao & Paul Fisher, An Approach of integer reversible
  wavelet transform for Lossless image compression, in *Advances in
  Computational Mathematics: Guangzhou, China -- the proceedings of
  Guangzhou International Symposium on Computational Mathematics*,
  Aug. 11-15, 1997, Guangzhou, P.R.China
- There existed [a browser plugin to decode such
  images](ftp://ftp.sunet.se/mirror/archive/ftp.sunet.se/pub/pc/windows/winsock-indstate/Windows95/WWW-Browsers/Plug-In/).
    - There also existed a [Java browser
      applet](https://web.archive.org/web/19970613234343/http://www.infinop.com/nhtml/java/index.shtml)
      whose classes were available (after [filling out a
      form](https://web.archive.org/web/19970613235015/http://www.infinop.com/nhtml/download.shtml)),
      both directly usable (e.g.,
      [Lightning.class](https://web.archive.org/web/19970613234343/http://www.infinop.com/nhtml/java/Lightning.class),
      not archived) and as archive on a [download
      page](https://web.archive.org/web/19970613234713/http://www.infinop.com/nhtml/download.shtml)
      (classes.tgz, not archived).
- There seem to be [different (incompatible)
  versions](https://web.archive.org/web/19970613235015/http://www.infinop.com/nhtml/javafaq.shtml):

    > *I have tried to use some .cod images from my website inside the
    > Java applet, and they do not display correctly. What could be
    > wrong?*
    >
    > Most likely, they were compressed with an earlier version of
    > Lightning Strike. The Java applet was designed for use with
    > Lightning Strike 2.6 images, and for the sake of size and download
    > time, was not made backward compatible. Try opening the images in
    > the Lightning Strike 2.6 compressor and then resaving them in the
    > new format.
