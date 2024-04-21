---
title: Searching for the index
---

Now let us inspect the [unknown segments between
tiles](/2024-04-22-getting-an-overview-on-the-file-content.markdown)
where I suspect the index for the tiles. First, we extract all unknown
parts:

```sh
dd if=dsatnord.mp of=un1.dat bs=1 count=316020
dd if=dsatnord.mp of=un2.dat bs=1 skip=10127037 count=2538456
dd if=dsatnord.mp of=un3.dat bs=1 skip=13522709 count=2672062
dd if=dsatnord.mp of=un4.dat bs=1 skip=644833451 count=460
```

Now let us visualise the two larger segments `un2.dat` and `un3.dat`
as follows: we interpret each byte as a greyscale value in the range
0...255:

## unknown2

![](/img/un2.png)

(image created with `./src/mp.py -c vis_bytes --out img/un2.png un2.dat`)

We can distinguish several segments.

## unknown3

![](/img/un3.png)

(image created with `./src/mp.py -c vis_bytes --out img/un3.png un3.dat`)

We see two segments, each with a quite regular pattern. The regularity
of the second segment is revealed already by `hexdump`:

```
0028c530  35 48 dd 1f 89 48 17 01  cd cd 3d 02 00 00 91 df  |5H...H....=.....|
0028c540  35 48 f2 0d 89 48 18 01  cd cd 3d 02 00 00 c3 e5  |5H...H....=.....|
0028c550  35 48 25 ec 88 48 19 01  cd cd 3d 02 00 00 21 13  |5H%..H....=...!.|
0028c560  36 48 ef bf 88 48 1a 01  cd cd 3d 02 00 00 e0 ff  |6H...H....=.....|
0028c570  35 48 c6 a4 88 48 1b 01  cd cd 3d 02 00 00 2e de  |5H...H....=.....|
0028c580  35 48 2a a4 88 48 1c 01  cd cd 3d 02 00 00 45 ad  |5H*..H....=...E.|
0028c590  35 48 51 a8 88 48 1d 01  cd cd 3d 02 00 00 fe b1  |5HQ..H....=.....|
0028c5a0  35 48 eb 9a 88 48 1e 01  cd cd 3d 02 00 00 ae cc  |5H...H....=.....|
0028c5b0  35 48 c3 8b 88 48 1f 01  cd cd 3d 02 00 80        |5H...H....=...|
```