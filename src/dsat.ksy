meta:
  id: dsat
  title: D-Sat 1 file format for storing tiles and metadata
  xref:
    webpage: https://dsat.igada.de/
  file-extension: mp
  endian: le
seq:
  - id: header
    type: header
  - id: tile_offsets
    type: offsets
    doc: offsets of the tiles
  - id: tiles_zoom0
    type: tiles
    doc: 20 color tiles of size 250x250 (zoom level 0)
  - id: tiles_zoom1
    type: tiles
    doc: 169 color tiles of size 500x500 (zoom level 1)
  - id: unknown2
    size: 2538456
  - id: cities
    type: cities
    doc: list of 13394 cities and their coordinates
  - id: unknown3_1
    size: 980862
  - id: unknown3_2
    size: 1691200
    doc: borders and highways
  - id: tiles_zoom2
    type: tiles
    doc: 2240 color tiles of size 500x500 (zoom level 2)
  - id: tiles_zoom3
    type: tiles
    doc: 24701 greyscale tiles of size 1000x1000 (zoom level 3)
  - id: unknown4
    size: 460
types:
  header:
    # 50 31 32 00 44 53 41 54  98 34 01 00 f2 2d 0f 00  |P12.DSAT.4...-..|
    seq:
      - id: magic
        contents: 'P12'
      - id: delim
        size: 1
        valid:
          eq: 0x00
      - id: dsat
        contents: 'DSAT'
      - id: unknown
        size: 8
        contents: [0x98, 0x34, 0x01, 0x00, 0xf2, 0x2d, 0x0f, 0x00]
# tile offsets → https://dsat.igada.de/2024/05/11/visualising-entropy.html
  offsets:
    seq:
      - id: todo_aufteilung # TODO: Unterstrukturen einfügen
        size: 316004
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
        encoding: latin-1
      - id: position
        type: position
  position:
    seq:
      - id: longitude
        type: f8
      - id: latitude
        type: f8
      - id: unknown1
        contents: [0x65]
      - id: unknown2
        size: 1
      - id: unknown3
        contents: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
# image tiles → https://dsat.igada.de/2024/04/22/getting-an-overview-on-the-file-content.html
  tiles:
    seq:
      - id: tiles
        type: ls_image
        repeat: until # FIXME: how to model?
        repeat-until:
  ls_image:
    meta:
      id: cis
      title: Lightning Strike image file format
      file-extension: cod
      xref:
        mime: image/cis-cod
        justsolve: Lightning_Strike
        wikidata: Q28206493
    seq:
      - id: header
        type: ls_header
      - id: data
        type: ls_data
        size: data_size
# Lightning Strike image format → https://dsat.igada.de/2024/04/20/understanding-the-image-header.html
  ls_header:
    seq:
      - id: magic
        contents: "CIS3"
      - id: unknown1
        contents: "."
      - id: unknown2
      - id: header_size
        type: u2
        contents: [56, 60]
      - id: data_size
        type: u4
      - id: unknown3
        size: 1
        contents: [0x00]
      - id: unknown4
        size: 1
      - id: width
        type: u2
      - id: height
        type: u2
  ls_data:
    seq:
      - id: unknown
        size: header.data_size
