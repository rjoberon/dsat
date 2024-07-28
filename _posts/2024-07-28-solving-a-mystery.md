---
title: Solving a mystery (and finding something unexpected again)
image: /img/aerial1.jpg
description: We discover two different types of data in the last uncharted part of dsatnord.mp.
tags: ["dsat", coordinates]
---

We have now mapped almost all parts of `dsatnord.mp` except for the
one I have dubbed
[unknown2](https://dsat.igada.de/2024/04/23/searching-for-the-index.html). Looking
at the greyscale byte representation again, we can see roughly five
regions with distinct patterns:

![greyscale byte reprsentation of the unknown2 part](/img/un2.png)

With Gimp I identified the numbers of the rows of the image that
roughly divide the parts: 553, 1050, 1508, and 1574. I then started to
[analyze the different parts using
autocorrelation](/src/Unknown2.ipynb) to find the byte size of
(potential) records. For the first part from row 0 to row 553 I found
a high correlation for a record size of 8 bytes:

![autocorrelation for the first part of the unknown2 part](/img/un2_1_autocorrelation.png)

With the experience I have gained analysing the previous parts, I
extracted two 32 bit values from each record and quickly found that
they yield the following scatter plot when they are interpreted as
unsigned integers:

![scatter plot of two 32 bit unsigned int values per record](/img/un2_1_int.png)

This finding is one reason for the title of this post: [as before, we
have found coordinates of borders and
highways](/2024/05/06/finding-something-unexpected.html). Interestingly,
this time we found them in at least three different scales (or zoom
levels). I have not checked further, yet, how the different zoom
levels are ordered within that part and leave that as future work.
Anyways: I added a `borders_and_highways1` part to
[dsat.ksy](/src/dsat.ksy) and renamed the existing part to
`borders_and_highways2`.

Browsing through `dsatnord.mp` with the updated `dsat.ksy` using the
[Kaitai Struct
Visualizer](https://github.com/kaitai-io/kaitai_struct_visualizer/)
(ksv) brought the next surprise. Having a look at the hex values after
the newly discovered part with the coordinates for the borders and
highways, I saw again the character sequence `BM` – [the format
indicator for Windows bitmap
files](/2024/07/04/finding-something-unexpected-again.html). (This is
the second reason for the title of this post.) I thought: [Nachtigall
ick hör dir
trapsen!](https://de.wikipedia.org/wiki/Des_Knaben_Wunderhorn)

Now the power of Katai Struct comes into play again: I imported the
[specification for BMP
files](https://github.com/kaitai-io/kaitai_struct_formats/blob/master/image/bmp.ksy)
and added a new element of `type: bmp` after the
`borders_and_highways1` element. Parsing that caused no problems, so
the chance that I had found another BMP file was high. Thus, I
extracted it with `dd` (using the [size information from the BMP
header as
before](/2024/07/04/finding-something-unexpected-again.html)):

```sh
dd if=dsatnord.mp of=img.bmp bs=1 skip=10694797 count=975894
```

The result was a 570x570 colour aerial image of an industrial area
which appeared familiar to me. However, before I could solve that
mystery, I checked the hex values after the newly discovered part and
found another `BM` string. 😄

The data contains a 574x577 colour image, a zoomed-in version of the
first image.

My immediate thought was that this probably shows a building from the
company that produced D-Sat 1 and that it was maybe some kind of
[easter egg](https://en.wikipedia.org/wiki/Easter_egg_(media)) that is
shown when one zooms into the corresponding location. So I checked the
help pages of D-Sat 1 and among some other addresses found this one:

![help page of the distributor](/img/vertrieb.png)

When I [checked the address using Google
Maps](https://maps.app.goo.gl/idr71oZNXaFPr1eU9) I basically saw an
updated version of the aerial view from the 1990s I had found. Bingo!

Since Mannheim is in the south of Germany, the highest resolution
images for that area are located on the second CD-ROM (in the file
`dsatsued.mp`). So I started D-Sat 1 with that second CD-ROM and
quickly saw what I had seen before but forgotten:

![TOPWARE logo in D-Sat 1](/img/topware0.jpg)

Already visible at the lowest zoom level (fully zoomed out): The logo
of the distributor ("TOPWARE") placed at Mannheim. A double click on
the logo immediately shows a 500x500 section of the first aerial image
I have found in a separate window titled "Markerbild". Another double
click on that image shows a 500x500 section of the second aerial
image. Looking at the content of the CD-ROM I discovered why the
images looked familiar to me:

```sh
> ls -l *.bmp
-r-------- 1 foo foo 251078 28. Jan 1997  mannh1.bmp
-r-------- 1 foo foo 251078 28. Jan 1997  mannh2.bmp
> file *.bmp
mannh1.bmp: PC bitmap, Windows 3.x format, 500 x 500 x 8, image size 250000, resolution 23621 x 23621 px/m, 256 important colors, cbSize 251078, bits offset 1078
mannh2.bmp: PC bitmap, Windows 3.x format, 500 x 500 x 8, image size 250000, resolution 23621 x 23621 px/m, 256 important colors, cbSize 251078, bits offset 1078
```
I have not checked (yet) whether `dsatsued.mp` contains those two
files, although I am pretty certain that they are contained, since
a `grep` on `dsatsued.mp` for the last six bytes of
the first image (`grep -obUaP "\x44\x4a\x40\x42\x00\x00"
../dsatsued.mp`)
yielded a result.
However, given their exact 500x500 size it seems likely the two
separate bitmap files are
shown.

It turned out that the first CD-ROM (for the north of Germany) also
contains those two files and clicking on the TOPWARE logo also works
on this CD-ROM. So it is likely that the two bitmaps with the same
content (but a slightly different size) from `dsatnord.mp` are not
used at all.

Having thought a bit more about this discovery I looked again at lower
four fifths of the greyscale representation of the `unknown2` part
(first image in this post) and realized why it always looked so
suspicious to me: it basically shows a distorted greyscale version of
the two images. With the right number of columns – three times the
image width, since the three RGB values result in three greyscale
pixels – and a the correct start byte the aerial image should be
visible. So I did this:

```sh
dd if=dsatnord.mp of=aerial1.dat bs=1 skip=10694851 count=975840
./src/mp.py -c vis_bytes --width=1712 --out=aerial1.png aerial1.dat
# alternative: convert -size 1712x570 -depth 8 gray:aerial1.dat aerial1.png
```
And here's the result:

![raw version of aerial1.bmp where each third column represents
another RGB colour](/img/aerial1.jpg)

Exactly as I expected it. How satisfying.

And then I also realised: that's it! There's nothing more to discover
in `dsatnord.mp`. Just some null bytes and some boring strings and
maybe a few bytes at the end (which are likely quite boring). So my
"endeavour to reverse-engineer the file format of D-Sat 1" was kind of
successful. But does it also finish here? Well, no! There are still
two quests to solve: the mystery of the coordinates (or better: their
projections) and the decoding of the [image format for the
tiles](/2024/04/03/learning-about-the-image-format.html).


Thus, in one of my next posts I will provide an overview on what we
know and what we do not know so far about the content and structure of
`dsatnord.mp`. Furthermore, I have already planned three more posts
which will cover the following topics:
- the different coordinate systems I have found and my approach to
  make sense of them
- the raster image format used for the tiles and information I could
  find about it (the impatient can have a look at
  [Cod.ipynb](/src/Cod.ipynb)).
- what I discovered when I started the *Lightning Strike Image
  Compressor V2.5*.

Happy reverse-engineering to everybody!
