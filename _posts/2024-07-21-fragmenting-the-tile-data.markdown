---
title: Fragmenting the tile data
image: /img/subband_sizes_tiles1000.png
description:
---

When looking at the data segment [CIS/COD
images](/2024/04/03/learning-about-the-image-format.html) (i.e., the
tiles) the byte sequence `0x63 0x6f 0x64` (ASCII: `cod`) appears
several times and thus is conspicuous. According to [a wiki page
describing a derived video
codec](https://wiki.multimedia.cx/index.php/Lightning_Strike_Video_Codec)
it marks the end of a "plane", a basic building blog of
wavelet-compressed images. In this post we explore the distribution of
these blocks.

Let us start to analyse how many such parts we find in images for the
different tile sizes:

## 20 colour tiles of size 250x250

| number of parts | frequency |
|-----------------+-----------|
|              39 |        17 |
|              42 |         2 |
|              48 |         1 |

## 169 colour tiles of size 500x500

| number of parts | frequency |
|-----------------+-----------|
|              36 |       162 |
|              39 |         7 |

## 2240 colour tiles of size 500x500

| number of parts | frequency |
|-----------------+-----------|
|              36 |      2238 |
|              37 |         1 |
|              39 |         1 |

## 24700 greyscale tiles of size 1000x1000

| number of parts | frequency |
|-----------------+-----------|
|              13 |     24667 |
|              14 |        33 |

We can clearly see that most images of one tile size/type have the
same number of parts: typically 36 for colour images and 13 for
greyscale images (with the exception of the 250x250 overview images
which have mainly 39 parts).

Without going into further detail (yet) I can state that each part
likely represents a "sub-band" of the wavelet decomposition which has
a certain depth for each component (e.g., colour). The most simplest
case are the greyscale tiles where we have 13 parts which would fit
nicely to the following sub-band structure of depth 4:

![13 sub-bands](/img/13subbands.png)

(Given the depth *d*, the number of sub-bands can be computed as *3d +
1*.)

The following plot shows the size distribution of the components over
all greyscale 1000x1000 tiles for each sub-band:

![sub-band sizes for all 1000x1000 greyscale tiles](/img/subband_sizes_tiles1000.png)
