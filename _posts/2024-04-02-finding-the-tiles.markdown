---
title: Finding the tiles
---

To find the image tiles in `dsatnord.mp` and possibly decode them, we
had a look at the decompiled `lsd26dll.dll`. My colleague Jan found
the function `CLsDecode::GetImageDataSize` and figured out that the
first lines

```c
if (*arg1 == 0x43 && arg1[1] == 0x49 && arg1[2] == 0x53)
    if (arg1[3] != 0x33)
        return 0
    if (arg1[5] == 0x30)
```

are basically a check for the string "CIS3". So the next thing we did
was to [search for that sequence](/src/mp.py) in `dsatnord.mp`. We
found 27130 offsets (`mp.py -c offsets dsatnord.mp > offsets.tsv`:

| byte offset | bytes from previous offset |
|-------------+----------------------------|
|      316020 |                          - |
|      328719 |                      12699 |
|      351371 |                      22652 |
|      384572 |                      33201 |
|      405841 |                      21269 |
|      446659 |                      40818 |
|      483024 |                      36365 |
|      525098 |                      42074 |
|      566987 |                      41889 |
|      619866 |                      52879 |

Plotting these looks as follows:

![](/img/offsets.png)

Not much to see, so let us restrict the vertical axis to the range [0:100000]:

![](/img/offsets_zoom.png)

Now we can clearly see some patterns, for example:

1. some very low (constant?) values
2. most values are between (roughly) 10k and 30k
3. some vertical patterns
