import std/sequtils
import std/math
# Brush kinds to add
# - algorithm (JSON) driven
# - image (PNG) driven

type
  BRUSHES* = enum
    SLASH, SQUARE, CROSS, CIRCLE, ROTABLE_MANUALLY, ROTABLE_X, ROTABLE_Y, ROTABLE_CROSS

iterator getBrushes: BRUSHES =
    for br in BRUSHES.low..BRUSHES.high:
      yield br
let brushList*  = toSeq(getBrushes())
let brushCount* = brushList.len

proc cycleBrushes* (b: BRUSHES, order: int): BRUSHES =
    proc getIndex (b: BRUSHES): int =
      for ix, brushS in brushList:
        if brushS == b: return ix

    proc setIndex (ix: int, o: int): int =
      if ix+o > brushList.len-1:
        return setIndex(ix, o-brushList.len)
      elif ix+o < 0:
        return setIndex(ix, o+brushList.len)
      else:
        return (ix+o)

    let ix = getIndex(b)
    return brushList[setIndex(ix, order)] # -1 because we aim for index

iterator brushSlash* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      let x = pos[0] + i
      let y = pos[1] + i
      yield (x, y)

iterator brushSquare* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      for j in -brush..brush:
        let x = pos[0] + i
        let y = pos[1] + j
        yield (x, y)

iterator brushCross* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      let x = pos[0] + i
      let y = pos[1]
      yield (x, y)
    for j in -brush..brush:
      let x = pos[0]
      let y = pos[1] + j
      yield (x, y)

iterator brushCircle* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      for j in -brush..brush:
        if i*i + j*j <= brush*brush:
          let x = pos[0] + i
          let y = pos[1] + j
          yield (x, y)

iterator brushRotableManually* (brush: int, pos: (int, int), angle: int): (int, int) =
    for i in -brush..brush:
      let sx = cos(angle.float * PI / 180)
      let sy = sin(angle.float * PI / 180)
      yield ((pos[0].float + sx * i.float).int, (pos[1].float + sy * i.float).int)

iterator brushRotableX* (brush: int, pos: (int, int)): (int, int) =
    let angle = pos[0]
    for i in -brush..brush:
      let sx = cos(angle.float * PI / 180)
      let sy = sin(angle.float * PI / 180)
      yield ((pos[0].float + sx * i.float).int, (pos[1].float + sy * i.float).int)

iterator brushRotableY* (brush: int, pos: (int, int)): (int, int) =
    let angle = pos[1]
    for i in -brush..brush:
      let sx = cos(angle.float * PI / 180)
      let sy = sin(angle.float * PI / 180)
      yield ((pos[0].float + sx * i.float).int, (pos[1].float + sy * i.float).int)

iterator brushRotableCross* (brush: int, pos: (int, int)): (int, int) =
    let angle = pos[0]*pos[1]
    for i in -brush..brush:
      let sx = cos(angle.float * PI / 180)
      let sy = sin(angle.float * PI / 180)
      yield ((pos[0].float + sx * i.float).int, (pos[1].float + sy * i.float).int)

proc brushPick* (kind: BRUSHES, brush: int, pos: (int, int), angle: int): seq[(int, int)] =
    case kind:
      of SLASH:
        result = brushSlash(brush, pos).toSeq
      of SQUARE:
        result = brushSquare(brush, pos).toSeq
      of CROSS:
        result = brushCross(brush, pos).toSeq
      of CIRCLE:
        result = brushCircle(brush, pos).toSeq
      of ROTABLE_X:
        result = brushRotableX(brush, pos).toSeq
      of ROTABLE_Y:
        result = brushRotableY(brush, pos).toSeq
      of ROTABLE_CROSS:
        result = brushRotableCross(brush, pos).toSeq
      of ROTABLE_MANUALLY:
        result = brushRotableManually(brush, pos, angle).toSeq

#[ iterators made by Lyofi for not exactly brushes XD
iterator brushTriangle* (brush: int, pos: (int, int)): (int, int) =  # >
    for i in -brush..brush:
      let x = pos[0]-abs(i)
      let y = pos[1]+i
      yield (x, y)

iterator brushTriangleB* (brush: int, pos: (int, int)): (int, int) =  # >> (stronger >)
    for i in -brush..brush:
      for j in 0..brush:
        let x = pos[0]-abs(i)+j-brush
        let y = pos[1]+i
        yield (x, y)

iterator brushTriangleC* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      for j in 0..abs(i):
        let x = pos[0]+abs(i)+j
        let y = pos[1]+i
        yield (x, y)

iterator brushTriangleD* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      for j in 0..(brush-abs(i)):
        let x = pos[0]+abs(i)+j
        let y = pos[1]+i
        yield (x, y)

iterator brushTriangleE* (brush: int, pos: (int, int)): (int, int) =
    for i in -brush..brush:
      for j in 0..(brush-abs(i)):
        let x = pos[0]-abs(i)+j
        let y = pos[1]+i
        yield (x, y)
iterator brushUnknown* (brush: int, pos: (int, int), angle: int = pos[0]): (int, int) =
    for i in -brush..brush:
      let sx = cos(angle.float * PI / 180)
      let sy = sin(angle.float * PI / 180)
      yield (pos[0] + sx.int * i, pos[1] + sy.int * i)
 ]#