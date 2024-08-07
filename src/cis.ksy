# -*- mode: yaml -*-
# Lightning Strike image format → https://dsat.igada.de/2024/04/20/understanding-the-image-header.html
meta:
  id: cis
  title: Lightning Strike image format
  file-extension: cod
  endian: le
  xref:
    mime: image/cis-cod
    justsolve: Lightning_Strike
    wikidata: Q28206493
seq:
  - id: header
    type: ls_header
    # size: header.header_size # → gives error in Python code
  - id: data
    type: ls_data
    size: header.data_size
types:
  ls_header:
    seq:
      - id: magic
        contents: "CIS"
      - id: version
        size: 3
        type: str
        encoding: ASCII
        doc: |
          so far seen: "2.5" and "3.0" but the remainder of this spec
          only works for 3.0
      - id: unknown2
        size: 2
      - id: header_size
        type: u2
        doc: 56 for greyscale, 60 for color
      - id: data_size
        type: u4
      - id: unknown3
        size: 1
        doc: |
          so far seen: 0x00, 0x52
      - id: unknown4
        size: 1
      - id: width
        type: u2
        doc: image width
      - id: height
        type: u2
        doc: image height
      - id: unknown5
        size: header_size - 20
  ls_data:
    seq:
      - id: planes
#        type: ls_plane
#        repeat: eos
        size-eos: true
#  ls_plane:
#    seq:
#      - id: plane
#        terminator: 0x63_6f_64
