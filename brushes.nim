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
          let x = pos[0] * i
          let y = pos[1] * j
          yield (x, y)