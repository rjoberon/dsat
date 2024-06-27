---
title: Documenting the file format
description: Understanding how the tile index works and how tiles are arranged in the file.
image: /img/dsat_kaitai.png
---

Since [the first post on decoding the city
database](/2005/03/26/decoding-the-city-database.html) I have learned
so much more about the structure of the D-Sat file format: [where the
image tiles are
located](https://dsat.igada.de/2024/04/02/finding-the-tiles.html),
[how they are
indexed](https://dsat.igada.de/2024/05/11/visualising-entropy.html)
and [which information the image header
reveals](https://dsat.igada.de/2024/04/20/understanding-the-image-header.html),
as well as [that the file also contains points describing borders and
highways](https://dsat.igada.de/2024/05/06/finding-somehing-unexpected.html). It
is time to document this knowledge and with [Kaitai
Struct](http://kaitai.io/) I found a solution for that: I can describe
the file format [in a simple YAML file](/src/dsat.ksy), automatically
generate code to parse files, and also visualize the structure:

![Visualization of the D-Sat file structure](/img/dsat_kaitai.png)
