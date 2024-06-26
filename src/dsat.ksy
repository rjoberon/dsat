# -*- mode: yaml -*-
meta:
  id: dsat
  title: D-Sat 1 file format for storing tiles and metadata
  xref:
    webpage: https://dsat.igada.de/
  file-extension: mp
  endian: le
  imports:
    - cis
seq:
  - id: header
    type: header
  - id: tile_offsets
    type: offset_list
    doc: offsets of the tiles
  - id: tiles_zoom0
    type: tiles
    size: 754077
    doc: 20 color tiles of size 250x250 (zoom level 0)
  - id: tiles_zoom1
    type: tiles
    size: 9056940
    doc: 169 color tiles of size 500x500 (zoom level 1)
  - id: unknown2
    size: 2538456
  - id: cities
    type: cities
    size: 13394 * 64
    doc: list of 13394 cities and their coordinates
  - id: unknown3_1
    size: 980862
  - id: unknown3_2
    size: 1691200
    doc: borders and highways
  - id: tiles_zoom2
    type: tiles
    size: 70627806
    doc: 2240 color tiles of size 500x500 (zoom level 2)
  - id: tiles_zoom3
    type: tiles
    size: 644804703 + 936 - 86822577
    # last working offset; extracted from
    # from "mp.py -c offsets dsatnord.mp"
    # by taking second-to-last start offset 644804703,
    # adding the tile size (936) and
    # subtracting the offset of the first 1000x1000 tile (86822577)
    # → there is a gap to the last tile
    doc: 24700 greyscale tiles of size 1000x1000 (zoom level 3)
  - id: unknown4new
    size: 644824916 - 644804703 - 936
    doc: gap between last tile and second-to-last tile
    # offset of last tile (644824916) minus offset of second-to-last
    # (644804703) tile plus its size (936)
  - id: unknown4
    size: 8995
    doc: starts also with "CIS3" but header size is 0 → broken?
    # that's the last tile mp.py outputs because it finds the magic
    # number but it is not a complete tile
#  - id: unknown4_01
#    size
types:
  header:
    # 50 31 32 00 44 53 41 54  98 34 01 00 f2 2d 0f 00  |P12.DSAT.4...-..|
    seq:
      - id: magic
        contents: 'P12'
      - id: delim
        contents: [0x00]
      - id: dsat
        contents: 'DSAT'
      - id: unknown
        contents: [0x98, 0x34, 0x01, 0x00, 0xf2, 0x2d, 0x0f, 0x00]
# tile offsets → https://dsat.igada.de/2024/05/11/visualising-entropy.html
  offset_list:
    seq:
      - id: offsets_zoom0
        size: 20*4 # 16 to 96
        type: offsets
        doc: |
          20 offsets for 20 color tiles of size 250x250 (zoom level 0)
          arranged in a grid of 4 columns and 5 rows
      - id: offsets_zoom1
        size: 169*4 # 96 to 772
        type: offsets
        doc: |
          169 offsets for 169 color tiles of size 500x500 (zoom level 1)
          arranged in a grid of 13 columns and 13 rows
      - id: here_be_dragons1
        size: 2280 # 772 to 3052
        doc: not clear, what this is
      - id: const_16194771
        size: 30*4 # 3052 to 3172
        type: offsets
        doc: |
          fixed value 16194771 (offset of first 500x500 tile)
          repeated 30 times (for whatever reason)
      - id: const_4278772525
        size: 844 # 3172 to 4016
        type: offsets
        doc: not clear, what this is (fixed value 4278772525)
      - id: offsets_zoom2
        size: 15976 - 4016 # 4016 to 15976 (2990 offsets of 4 byte each)
        type: offsets
        doc: |
          3020 offsets for 2240 color tiles of size 500x500 (zoom level 2)
          arranged in a grid of 50 columns and 60 rows
      - id: offsets_zoom3
        size: 41245 * 4 # 15976 to 180956
        type: offsets
        doc: |
          41245 offsets for 24700 greyscale tiles of size 1000x1000 (zoom level 3)
          arranged in a grid of 250 columns and 165 rows
      - id: here_be_dragons2
        size: 135064 # 180956 to 316020
        doc: whatever remains → have a look
  offsets:
    seq:
      - id: offset
        type: u4
        repeat: eos
# city database → https://dsat.igada.de/2005/03/26/decoding-the-city-database.html
  cities:
    seq:
      - id: cities
        type: city
        repeat: expr
        repeat-expr: 13394 # FIXME: how to model?
  city:
    seq:
      - id: name
        type: str
        size: 40
        encoding: ISO-8859-1
      - id: position
        type: position
  position:
    seq:
      - id: longitude
        type: f8
      - id: latitude
        type: f8
      - id: unknown3
        # contents: [0x09, 0x00, 0x00, 0x00, 0x00, 0x00]
        size: 8
# image tiles → https://dsat.igada.de/2024/04/22/getting-an-overview-on-the-file-content.html
  tiles:
    seq:
      - id: tiles
        type: cis
        repeat: eos # FIXME: how to model?
