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
    size: header.header_size
  - id: data
    type: ls_data
    size: header.data_size
types:
  ls_header:
    seq:
      - id: magic
        contents: "CIS3"
      - id: unknown1
        contents: "."
      - id: unknown2
        size: 3
      - id: header_size
        type: u2
        doc: 56 for greyscale, 60 for color
      - id: data_size
        type: u4
      - id: unknown3
        contents: [0]
      - id: unknown4
        size: 1
      - id: width
        type: u2
        doc: image width
      - id: height
        type: u2
        doc: image height
  ls_data:
    seq:
      - id: unknown
        size-eos: true
