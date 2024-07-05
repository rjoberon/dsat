# -*- mode: yaml -*-
meta:
  id: dsat
  title: D-Sat 1 file format for storing tiles and metadata
  xref:
    webpage: https://dsat.igada.de/
  file-extension: mp
  endian: le
  imports:
    - cis # https://github.com/rjoberon/dsat/blob/main/src/cis.ksy
    - bmp # https://github.com/kaitai-io/kaitai_struct_formats/blob/master/image/bmp.ksy
seq:
  - id: header
    type: header
  - id: tile_offsets
    type: offset_list
    doc: offsets of the tiles
  - id: tiles_zoom0
    type: tiles
    size: 754077
    # does not work:
    # type: cis
    # size: tiles_zoom0.header.data_size + tiles_zoom0.header.header_size
    # repeat: eos
    doc: 20 color tiles of size 250x250 (zoom level 0)
  - id: tiles_zoom1
    type: tiles
    size: 9056940
    doc: 169 color tiles of size 500x500 (zoom level 1)
  - id: borders_and_highways1
    type: points
    size: 567760
  - id: tiles_bmp
    size: 975894 + 994802
    type: tiles_bmp
    doc: |
      a 570x570x24 bitmap showing an aerial photo of an industrial
      area (TOPWARE/CD-Service AG, Markircher Str. 25, 68229 Mannheim
      – which was responsible for distribution and support of D-Sat 1)
      and another 574x577x24 bitmap showing a zoomed-in part of the
      first image
  - id: cities
    type: cities
    size: 13394 * 64
    doc: list of 13394 cities and their coordinates
  - id: unknown3_11
    size: 24*16
    doc: |
      strings: "D:\Dsat\Dsat23\CityDlg.cpp" "c:\temp\cityname.bin"
      "Suche wiederholt" "Suche wiederholt"
  - id: city_signs
    type: city_signs
    size: 4878 * 201
    doc: |
      201 Windows Bitmap (BMP) files of size 75x50, each showing a
      German town sign (black text on yellow background) for some
      larger towns
  - id: borders_and_highways2
    type: points_and_more
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
        size: 2990*4 # 4016 to 15976 (2990 offsets of 4 byte each)
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
        repeat: eos
  city:
    seq:
      - id: name
        type: str
        size: 40
        terminator: 0
        encoding: ISO-8859-1
      - id: position
        type: position
  city_signs:
    seq:
      - id: city_signs
        type: bmp
        size: 4878
        doc: Windows bitmap file (BMP) of 75x50x8 pixels (indexed color palette)
        repeat: eos
  position:
    seq:
      - id: longitude
        type: f8
      - id: latitude
        type: f8
      - id: unknown
        type: u1
        valid:
          any-of: [9, 11, 17, 26]
      - id: empty
        size: 7
        contents: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
# image tiles → https://dsat.igada.de/2024/04/22/getting-an-overview-on-the-file-content.html
  tiles:
    seq:
      - id: tiles
        type: cis
        repeat: eos
  tiles_bmp:
    seq:
      - id: tile1
        type: bmp
        size: 975894
        # does not work:
        # size: tile1.file_hdr.len_file
      - id: tile2
        type: bmp
        size: 994802
  points:
    seq:
      - id: point
        type: point
        repeat: eos
  points_and_more:
    seq:
      - id: point
        type: point_and_info
        repeat: eos
  point:
    seq:
      - id: longitude
        type: u4
      - id: latitude
        type: u4
  point_and_info:
    seq:
      - id: longitude
        type: f4
      - id: latitude
        type: f4
      - id: b9
        size: 1
      - id: b10
        type: u1
        valid:
          any-of: [0, 1, 2, 3, 4, 5, 6]
      - id: b11_12
        size: 2
        contents: [0xcd, 0xcd]
      - id: b13
        size: 1
      - id: point_type
        type: u1
        valid:
          any-of: [0, 1, 2, 3 ]
        doc: |
          0 seems to encode highways
          1 seems to encode state borders
          2 seems to (mainly) encode the federal border
      - id: b15_16
        type: u2
        valid:
          any-of: [0, 32768]
