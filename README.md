---
title: D-Sat
layout: home
permalink: index.html
---
An endeavour to reverse-engineer the file format of D-Sat 1.

## What is it about?

D-Sat was a series of CD/DVD-ROMs from the 1990s which contained
aerial and satellite imagery of Germany.[^1] The data was stored in a
proprietary file format and thus can only be used with the original
Windows programs. Since this is not sustainable, this project seeks to
reverse-engineer the file format and develop tools to access the
contained data (coordinates, images, etc.).

[The first post on decoding the city
database](/2005/03/26/decoding-the-city-database.html) is a good
starting point for further reading.

[^1]: The CD/DVD-ROMs of D-Sat 1 and 2 are available in the [Internet
    Archive](https://archive.org/details/software).

## Next Steps

- [ ] test
  [SK-42](https://en.wikipedia.org/wiki/SK-42_reference_system) and
  derivatives (check older [usenet discussion on how to decode the geo
  coordinates](https://groups.google.com/g/de.org.ccc/c/xlaNafyxmrM/m/hXZj7J5ksc8J))

## Files

| file name     | comment                                                                          |
|---------------+----------------------------------------------------------------------------------|
| `dsatnord.mp` | data for D-Sat 1 CD 1                                                            |
| `NPLS32.DLL`  | [NPAPI](https://en.wikipedia.org/wiki/NPAPI) browser plugin for Netscape/Firefox |
