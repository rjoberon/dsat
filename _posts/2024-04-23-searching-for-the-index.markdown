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

![](/img/un2.png)

(image created with `./src/mp.py -c vis_bytes --out img/un2.png un2.dat`)

![](/img/un3.png)

(image created with `./src/mp.py -c vis_bytes --out img/un3.png un3.dat`)
