---
title: Visualising Entropy
---

Our quest to [find the tile index of D-Sat 1](/2024/04/23/searching-for-the-index.html) continues. [I have described before, what I mean with "tile index"](/2024/05/06/finding-somehing-unexpected.html) and I have also given a clue that I found something in the first part of the big blob of data `dsatnord.mp` which I named `un1.dat`.

In this post we will
1. extract the byte offsets of the tiles from `dsatnord.mp`,
2. search for those byte offsets in [the unknown parts](/2024/04/23/searching-for-the-index.html) of `dsatnord.mp`, and
3. analyse the found data.

This post is based on [a Jupyter Notebook which contains the code to
repeat the analysis](/src/Visualising_Entropy.ipynb).

Apart from a much better understanding on how tiles are stored and accessed in D-Sat 1, our visually most appealing outcome is this picture:

![1000x1000 tiles in a 165 by 250 grid](/img/ve_tiles1000_165x250.png)

You might recognize some known shape but wonder what the colors indicate. We will come to that but for now let's just say that the image is proof of the (at least partial) solution to the quest of finding the tile index.

This post describes the journey towards getting (and understanding) that image in very much detail. Thus, it is rather long and probably contains too much information for some – and still, there are bits and pieces missing.

## Extracting the byte offsets of the tiles

[As described before](/2024/05/06/finding-somehing-unexpected.html), we are looking for information about the tiles that contain the satellite images. Since the tiles are stored sequentially in `dsatnord.mp`, the most simple way to identify them is their [byte offset](/2024/04/21/visualising-the-tile-size-distribution.html) within that file. If an index describing the tiles exists, that index likely contains the offsets of the tiles as pointers (integer numbers). Thus, we first extract those offsets from `dsatnord.mp`.

## Searching for the byte offsets

Now we can search within `dsatnord.mp` for individual offsets to find candidate parts for the index. We can restrict our search to [the three parts whose function we do not know, yet](/2024/04/22/getting-an-overview-on-the-file-content.html) and we start with the first part `un1.dat`, ranging from byte 0 to byte 316020 in `dsatnord.mp`.

How can we search for the offsets? One approach is to start with a handful of (randomly chosen) offsets.


```python
random_offsets = tiles.sample(5).offset.to_list()
random_offsets
```

    [30243192, 616207380, 203431531, 496386351, 376324742]


Then there are two options to search for them: either we transform the offsets into byte values or we transform the bytes of the target file into integers. I chose the second approach. In both cases we need to decide how to represent an integer, which basically requires us to settle the parameters of [`int.from_bytes`](https://docs.python.org/3/library/stdtypes.html#int.from_bytes): number of bytes, byte order, and whether the value has a sign or not. Given the size of `dsatnord.mp`, two bytes (16 bit) are clearly not sufficient, so the next typical choice is 4 bytes (32 bit). To represent (absolute) offsets we do not need a sign and little endianness is the typical [byte order of the hardware](https://en.wikipedia.org/wiki/Endianness#Hardware) D-Sat was running on.

So we want to check all successive four bytes in the first part of `dsatnord.mp`, but we can not be sure that the index starts at byte 0. The simplest thing to do then is to just take every byte position and check the integer formed by the successive four bytes:


```python
with open("../dsatnord.mp", "rb") as f:
    for pos in range(316020):
        f.seek(pos)
        lint = int.from_bytes(f.read(4), byteorder='little', signed=False)
        if lint in random_offsets:
            print("found offset", lint, "at byte position", pos)
```

    found offset 30243192 at byte position 7756
    found offset 203431531 at byte position 90504
    found offset 376324742 at byte position 130820
    found offset 496386351 at byte position 155140
    found offset 616207380 at byte position 176132


That looks good! Some more analysis revealed that actually *all* tile offsets are contained in the first part `un1.dat`. Furthermore, there are (almost) no gaps between offsets, that is, (almost) each successive 4 byte integer represents an offset of a tile. This also means that this index does not contain any coordinates! This was quite unexpected and the reason why [I continued searching for the index](/2024/05/06/finding-somehing-unexpected.html), although I already knew that `un1.dat` contains the offsets.
Last but not least, the first offset starts at byte 16, so I assume the first 16 bytes of `dsatnord.mp` constitute the file header, which looks as follows:

```
50 31 32 00 44 53 41 54  98 34 01 00 f2 2d 0f 00  |P12.DSAT.4...-..|
```

## Analysing the data

Now we want to understand how the index is structured. Therefore, we first read the offsets into a dataframe:

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe tr td {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>un1off</th>
      <th>offset</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16</td>
      <td>316020</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20</td>
      <td>328719</td>
    </tr>
    <tr>
      <th>2</th>
      <td>24</td>
      <td>351371</td>
    </tr>
    <tr>
      <th>3</th>
      <td>28</td>
      <td>384572</td>
    </tr>
    <tr>
      <th>4</th>
      <td>32</td>
      <td>405841</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>78996</th>
      <td>316000</td>
      <td>644833911</td>
    </tr>
    <tr>
      <th>78997</th>
      <td>316004</td>
      <td>644833911</td>
    </tr>
    <tr>
      <th>78998</th>
      <td>316008</td>
      <td>644833911</td>
    </tr>
    <tr>
      <th>78999</th>
      <td>316012</td>
      <td>644833911</td>
    </tr>
    <tr>
      <th>79000</th>
      <td>316016</td>
      <td>3650133385</td>
    </tr>
  </tbody>
</table>
<p>79001 rows × 2 columns</p>
</div>



Does this make sense? Let us again have a look at [the number and sizes of tiles we have found](/2024/04/22/getting-an-overview-on-the-file-content.html):

| start offset | end offset | tile size | number of tiles |
| -----------: | ---------: | --------: | --------------: |
| 316020       | 1070097    | 250x250   | 20              |
| 1070097      | 10127037   | 500x500   | 169             |
| 16194771     | 86822577   | 500x500   | 2240            |
| 86822577     | 644833451  | 1000x1000 | 24701           |
|              |            |           | sum: 27130      |

The 79001 numbers are way more than the 27130 tiles we have found. To better understand what is going on, let us plot the data:


```python
import matplotlib.pyplot as plt

plt.rcParams['figure.figsize'] = (10, 6)
plt.axhline(644833911, color="magenta", linewidth=0.5)  # size of dsatnord.mp
plt.plot(offsets["un1off"], offsets["offset"], '.')
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.show()
```



![Offsets of tiles and their offsets](img/ve_offsets.png)



The horizontal axis shows the actual offset of each value at the beginning of `dsatnord.mp` (i.e., the part I call `un1.dat`). The vertical axis shows each value found at that offset and we interpret these values as offsets (pointers) into `dsatnord.mp`, that is, the offsets of the tiles.

The magenta line depicts the actual size of `dsatnord.mp`, so at the beginning and at the end there are clearly some values that can not be offsets into `dsatnord.mp`. The (roughly) first half contains increasing values and the second half (almost?) constant values. We cannot see from this plot which values are actually offsets of the tiles, but we can join the data with the actual offsets of the tiles and visualise that:


```python
df = pd.merge(left=offsets, right=tiles, on=["offset"], how="left")
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>un1off</th>
      <th>offset</th>
      <th>size</th>
      <th>width</th>
      <th>height</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16</td>
      <td>316020</td>
      <td>12699.0</td>
      <td>250.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20</td>
      <td>328719</td>
      <td>22652.0</td>
      <td>250.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>24</td>
      <td>351371</td>
      <td>33201.0</td>
      <td>250.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>28</td>
      <td>384572</td>
      <td>21269.0</td>
      <td>250.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>32</td>
      <td>405841</td>
      <td>40818.0</td>
      <td>250.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>78996</th>
      <td>316000</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>78997</th>
      <td>316004</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>78998</th>
      <td>316008</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>78999</th>
      <td>316012</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>79000</th>
      <td>316016</td>
      <td>3650133385</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>79001 rows × 5 columns</p>
</div>



The undefined (`NaN`) values for size, width, and height at the end show that these are not offsets of tiles. We can now color the points in the plot according to tiles of which size they represent:


```python
ax = df[df.width == 250].plot.scatter("un1off", "offset", label="250", color="red", s=0.5)
df[df.width ==  500].plot.scatter("un1off", "offset", label="500", color="green", s=0.5, ax=ax)
df[df.width == 1000].plot.scatter("un1off", "offset", label="1000", color="blue", s=0.5, ax=ax)
df[df.width.isnull()].plot.scatter("un1off", "offset", label="NaN", color="magenta", s=0.5, ax=ax)
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```



![Offsets of tiles and their offsets (colored by tile size)](img/ve_offsets_colored.png)



Hardly visible are the 20 tiles of size 250x250 at the beginning, which are followed by 169 tiles of size 500x500 which are also hardly visible. Then follow some outliers, 2240 tiles of size 500x500, and 24701 tiles of size 1000x1000. The second half of the file does not contain offsets of tiles.

Clearly, it is interesting to understand the purpose of the values I have called "outliers" but for let us skip them:


```python
ax = df[df.width == 250].plot.scatter("un1off", "offset", label="250", color="red", s=0.5)
df[df.width ==  500].plot.scatter("un1off", "offset", label="500", color="green", s=0.5, ax=ax)
df[df.width == 1000].plot.scatter("un1off", "offset", label="1000", color="blue", s=0.5, ax=ax)
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```



![Offsets of tiles and their offsets (colored by tile size, without outliers)](img/ve_offsets_colored_wo_outliers.png)



That is the plot I started pondering about a lot. It turned out that at this scale it is difficult (if not impossible) to get an understanding of what we see (and why). So I started to zoom into some regions (actually, using interactive plots enabled by `%matplotlib notebook`):


```python
ax = df[df.width == 250].plot.scatter("un1off", "offset", label="250", color="red", s=0.5)
df[df.width ==  500].plot.scatter("un1off", "offset", label="500", color="green", s=0.5, ax=ax)
df[df.width == 1000].plot.scatter("un1off", "offset", label="1000", color="blue", s=0.5, ax=ax)
plt.xlim(0, 20000)        # zoom into first 20kB of dsatnord.mp
plt.ylim(0, 100000000)    # limit offsets to values shown in that region
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```



![Offsets of tiles and their offsets (colored by tile size, without
outliers, zoomed)](img/ve_offsets_colored_wo_outliers_zoom1.png)



We can now see the 250x250 tiles at the very beginning, the first 169 tiles of size 500x500, the gaps caused by outliers, and then a "staircase"-like distribution of the remaining 2240 tiles of size 500x500. Let us further zoom into the first part before the gaps:


```python
ax = df[df.width == 250].plot.scatter("un1off", "offset", label="250", color="red", s=0.5)
df[df.width ==  500].plot.scatter("un1off", "offset", label="500", color="green", s=0.5, ax=ax)
df[df.width == 1000].plot.scatter("un1off", "offset", label="1000", color="blue", s=0.5, ax=ax)
plt.xlim(0, 1000)
plt.ylim(0, 11000000)
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```



![Offsets of tiles and their offsets (colored by tile size, without
outliers, zoomed)](img/ve_offsets_colored_wo_outliers_zoom2.png)



Now we can see a "staircase" pattern also for the first 169 tiles of size 500x500. Remember, that the tiles in `dsatnord.mp` are (almost all) stored adjacently without any gaps and that the vertical axis shows their byte offsets. So the flat parts of the curve are caused by tiles that occupy not much memory. That was one very important observation towards understanding how the tiles are ordered.

But why should the tiles have vastly different memory sizes? After all, they represent squares with the same side length. The reason must be the compression ratio: some tiles could be better compressed. And the reason for that must be that the image they showed must have a lower entropy, that is, could be easier compressed. In our case of satellite images the reason could be that the landscape they showed is rather "dull", for example, a body of water.

In the meantime, I had also extracted and converted the 20 tiles of size 250x250 and checked how they were arranged: basically in a grid of 5 rows and 4 columns, stored in row-major order starting from the top left corner.

Combining this information together with the thoughts about the memory sizes of tiles, I decided to plot their byte size in a heatmap with the tiles arranged in a 5 by 4 grid:


```python
import seaborn as sns

df0 = df.loc[df["width"] == 250, ["size"]].reset_index(drop=True)
df0["col"] = df0.index % 4
df0["row"] = df0.index // 4
df0 = df0.pivot(columns="col", index="row", values="size")
plt.gca().set_aspect('equal')
sns.heatmap(df0, cbar_kws={'label': 'size in bytes'})
plt.show()
```


![250x250 tiles in a 5 by 4 grid](img/ve_tiles250.png)




We can see that the upper left tile does not occupy much memory. That is because it shows almost only the North Sea (which I confirmed by looking at the actual image) which is almost completely blue without any structure and thus can be compressed very well. Actually, most of the tiles in row 0 cover sea and thus could be compressed very well.

So let us have a look at the next zoom level. We need to figure out how the 169 tiles of size 500x500 could be arranged. Since 169 = 13 * 13, we try 13 rows and 13 columns:


```python
df1 = df.loc[(df["un1off"] >= 96) & (df["un1off"] <= 768), ["size"]].reset_index(drop=True)
df1["col"] = df1.index % 13
df1["row"] = df1.index // 13
df1 = df1.pivot(columns="col", index="row", values="size")
plt.gca().set_aspect('equal')
sns.heatmap(df1, cbar_kws={'label': 'size in bytes'})
plt.show()
```



![500x500 tiles in a 13 by 13 grid](img/ve_tiles500_13x13.png)



Columns 0 and 12 look as if something has been cut off but the north could resemble the coastline of Germany.

Now we could just continue zooming in using the remaining tiles, but before I did that, I made another observation: the frequency distribution of tile offsets clearly showed that several offsets were repeated. To visualise that in our initial plot, let us first mark duplicated offsets:


```python
df["dup"] = df["offset"].duplicated(keep=False)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>un1off</th>
      <th>offset</th>
      <th>size</th>
      <th>width</th>
      <th>height</th>
      <th>dup</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>16</td>
      <td>316020</td>
      <td>12699.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>20</td>
      <td>328719</td>
      <td>22652.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>24</td>
      <td>351371</td>
      <td>33201.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>28</td>
      <td>384572</td>
      <td>21269.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>32</td>
      <td>405841</td>
      <td>40818.0</td>
      <td>250.0</td>
      <td>250.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>78996</th>
      <td>316000</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>78997</th>
      <td>316004</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>78998</th>
      <td>316008</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>78999</th>
      <td>316012</td>
      <td>644833911</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>True</td>
    </tr>
    <tr>
      <th>79000</th>
      <td>316016</td>
      <td>3650133385</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
<p>79001 rows × 6 columns</p>
</div>



Now let us plot the offsets of the 250x250 and 500x500 tiles only and highlight duplicate values in magenta:


```python
ax = df[df.width == 250].plot.scatter("un1off", "offset", label="250", color="red", s=0.5)
df[(df.width == 500) & ~df.dup].plot.scatter("un1off", "offset", label="500", color="green", s=0.5, ax=ax)
df[(df.width == 500) & df.dup].plot.scatter("un1off", "offset", label="500 (dup)", color="magenta", s=0.5, ax=ax)
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```



![Offsets of tiles and their offsets (colored by tile size, without
outliers, duplicates highlighted)](img/ve_offsets_colored_wo_outliers_duplicates.png)




We can see quite some duplicates and, apparently, they are the reason for the staircase effect in the 2240 500x500 tiles.

When zooming in, we can observe a similar effect for the 1000x1000 tiles:


```python
ax = df[(df.width == 1000) & (df.dup == False)].plot.scatter("un1off", "offset", label="1000", color="blue", s=0.5)
df[(df.width == 1000) & (df.dup == True)].plot.scatter("un1off", "offset", label="1000 (dup)", color="magenta", s=0.5, ax=ax)
plt.xlim(50000, 100000)          # zoom
plt.ylim(100000000, 200000000)   # zoom
plt.xlabel("offset of the value")
plt.ylabel("value (= offset of the tile)")
plt.legend(title="width")
plt.show()
```


![Offsets of tiles and their offsets (colored by tile size, without
outliers, duplicates highlighted, zoomed)](img/ve_offsets_colored_wo_outliers_duplicates_zoom1.png)




And these were the plots which kept me awake. I thought: if this is really the tile index, why are some tiles repeated? And why is there this regular but changing pattern of repetitions and non-repetitions?

In such situations it helps to have someone else have a look and brainstorm what this could be. And as with [the magic number for the tiles](https://dsat.igada.de/2024/04/02/finding-the-tiles.html), my colleague Jan helped a lot to form the following hypothesis: *The repeated tiles fill the area outside Germany to form a rectangle.*

This would mean that I could just continue plotting the tiles in a rectangular grid without any need to know the shape of Germany. That came somewhat as a surprise and showed some simplicity that I did not expect.

So the next zoom level would be the remaining 2240 tiles of size 500x500. However, my first tries did not work and I got a garbled image. Having a look at one of our initial plots, we can see that at offset 3052 the offset 16194771 for the first 500x500 tile is repeated 30 times and then there is a gap (from bytes 3172 to 4012) filled with the "outlier" value 4278772525. So let us skip this first (repeated) tile and use only the tiles from byte 4016 to byte 15972. This makes 2989 = (15972 − 4016) / 4 (repeated) tiles which can be factored into 7 * 7 * 61. So one gues could be to use a grid of 49 columns and 61 rows:


```python
import seaborn as sns
df2 = df.loc[(df["un1off"] >= 4016) & (df["un1off"] <= 15972), ["size"]].reset_index(drop=True)
cols = 49
df2["col"] = df2.index % cols
df2["row"] = df2.index // cols
df2 = df2.pivot(columns="col", index="row", values="size")
plt.gca().set_aspect('equal')
sns.heatmap(df2, cbar_kws={'label': 'size in bytes'})
plt.show()
```



![500x500 tiles in a 61 by 49 grid](img/ve_tiles500_61x49.png)




We can clearly see some shearing distortion, which means we did not choose the right number of columns. So the best guess is to try adjacent values and having started with 49, 50 is one next best choice:


```python
import seaborn as sns
df2 = df.loc[(df["un1off"] >= 4016) & (df["un1off"] <= 15972), ["size"]].reset_index(drop=True)
cols = 50
df2["col"] = df2.index % cols
df2["row"] = df2.index // cols
df2 = df2.pivot(columns="col", index="row", values="size")
plt.gca().set_aspect('equal')
sns.heatmap(df2, cbar_kws={'label': 'size in bytes'})
plt.show()
```


![500x500 tiles in a 59 by 50 grid](img/ve_tiles500_59x50.png)



That looks familiar, doesn't it? The coast line of Germany is clearly visible. The vertical stripes outside of Germany are caused by the repetition of the "border" tiles, that is, the last tiles east and west that cover Germany. By not storing tiles that do not cover Germany, precious space could be saved on the CD-ROM. And by just repeating the border tiles, programming was simplified, since the shape of Germany was not required to load tiles – they tiles were just arranged in a rectangular grid.

What we can also see is that so far all tiles cover the whole of Germany although we are analysing tiles from the first CD-ROM covering only the north of Germany. This will be different for the tiles of size 1000x1000 with the highest resolution (I spare you a detour and directly show you the correct result with 250 columns which I found as second guess after 200 columns):


```python
import seaborn as sns
# first 1000x1000 tile at offset 15976
# last 1000x1000 tile at offset 180952
# → 41245 tiles (incl. duplicates)
# and then 66 1000x1000 tiles from offset 304796 to offset 305056
df3 = df.loc[(df["un1off"] >= 15976) & (df["un1off"] <= 180952), ["size"]].reset_index(drop=True)
cols = 250
df3["col"] = df3.index % cols
df3["row"] = df3.index // cols
df3 = df3.pivot(columns="col", index="row", values="size")
plt.gca().set_aspect('equal')
sns.heatmap(df3, cbar_kws={'label': 'size in bytes'})
plt.show()
```



![1000x1000 tiles in a 165 by 250 grid](img/ve_tiles1000_165x250.png)



I hope you are as astonished as I was when I first saw that image. This definitely shows the north of Germany – the coastline and even the inland shape is clearly identifiable. Beyond this, there are more things to observe and explain:
1. The horizontal bars east and west outside Germany are (again) caused by the repetition of the border tiles.
2. We only see the northern half, since the southern half is stored on the second CD-ROM in the file `dsatsued.mp`. Almost we have not analysed that file so far, it is almost certain that it is structurally the same as `dsatnord.mp`.
3. Although the color of each pixel just indicates the byte size of the 1000x1000 pixel tile at that location, we can clearly see some structure. In particular, we can identify the Ruhr area in the west and several large cities, for example, Hamburg, Bremen, Hannover, Berlin, and Dresden. The reason for that is that the plot basically **visualises entropy**: images of the complex structure of streets and houses in cities have a higher entropy and thus can not be compressed as well as low-entropy images of fields, meadows and woods. How well data can be compressed is a measure of its entropy.
4. Particularly in the middle of the image we can see "traces" of larger patches going from the bottom to the top in an angle of roughly 60° (measured from the bottom). My hypothesis is that these are caused by the orbit of the satellite who took the images. Depending on the weather (and other) conditions over a region during flyover, the quality of the images might be different, causing different entropy.


So we now know how the tiles are arranged and that there's basically a(nother) "pixel coordinate system". What is missing is information on how to translate between those and well-known coordinate systems and projections. From a pessimistic point of view this means we are not much farther with our knowledge than from [the first post](https://dsat.igada.de/2005/03/26/decoding-the-city-database.html). However, today I would like to take the optimistic point of view and state that we have already reverse-engineered a very big part of the file format of D-Sat 1.
