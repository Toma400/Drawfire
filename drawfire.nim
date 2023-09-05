import std/strformat
import nimfire/colors
import nimfire/input
import nimfire/image # required for saving canvas as PNG
import nimfire/types # required for 'brushDraw' proc
import nimfire/draw
import nimfire
import os

var w    = initWindow((1280, 920), "Drawfire", bg_colour=GREEN)
var cr   = newRect(pos=(950, 50), size=(50, 50), BLACK)
var logo = newImage("banner.png", (0, 600))

var canvas = newRect(pos=(0, 0), size=(800, 600), WHITE) # we create canvas Rect
w.drawRect(canvas)
w.drawImage(logo)

type
  BRUSHES = enum
    SLASH, SQUARE, CROSS
var brush = 1 # size of a brush
var brush_type = SLASH

proc brushDrawSlash(w: var Window, pos: (int, int)) = # '\' slash
  for i in -brush..brush:
    let x = pos[0] + i
    let y = pos[1] + i
    w.fillPos((x, y), cr.colour)
    setPixel(canvas, (x, y), cr.colour) # we add setPixel here, because this let us
                                        # notify Rect object about the change done
                                        # (will be useful for saving it later)

proc brushDrawSquare(w: var Window, pos: (int, int)) = # square
  for i in -brush..brush:
    for j in -brush..brush:
      let x = pos[0] + i
      let y = pos[1] + j
      w.fillPos((x, y), cr.colour)
      setPixel(canvas, (x, y), cr.colour)

proc brushDrawCross(w: var Window, pos: (int, int)) = # cross
  for i in -brush..brush:
    let x = pos[0] + i
    let y = pos[1]
    w.fillPos((x, y), cr.colour)
    setPixel(canvas, (x, y), cr.colour)
  for j in -brush..brush:
    let x = pos[0]
    let y = pos[1] + j
    w.fillPos((x, y), cr.colour)
    setPixel(canvas, (x, y), cr.colour)

proc save(r: Rect) =
    for i in 1..100_000:
      if not fileExists(fmt"image{i}.png"):
        saveImage(r.toImage(), fmt"image{i}.png")
        break


while w.tick():
  w.drawRect(cr) # draws Rect showing current colour

  if w.getKeyPressed(KEY.B):
    cr.setColour(BLACK)
  elif w.getKeyPressed(KEY.G):
    cr.setColour(GREEN)
  elif w.getKeyPressed(KEY.R):
    cr.setColour(RED)
  elif w.getKeyPressed(KEY.W):
    cr.setColour(WHITE)
  elif w.getKeyPressed(KEY.L):
    cr.setColour(BLUE)
  elif w.getKeyPressed(KEY.Y):
    cr.setColour(YELLOW)
  elif w.getKeyPressed(KEY.P):
    cr.setColour(PURPLE)
  elif w.getKeyPressed(KEY.Q):
    w.clear()
    clearPixels(canvas)
    w.drawRect(canvas)                    # we add redrawing canvas here, since this makes our canvas empty again
    w.drawImage(logo)
  elif w.getKeyPressed(KEY.UP):
    brush += 1
  elif w.getKeyPressed(KEY.DOWN):
    if brush > 1:
      brush -= 1
  elif w.getKeyPressed(KEY.LEFT):
    case brush_type:
      of SLASH:  brush_type = SQUARE
      of SQUARE: brush_type = CROSS
      of CROSS:  brush_type = SLASH
  elif w.getKeyPressed(KEY.RIGHT):
    case brush_type:
      of SLASH:  brush_type = CROSS
      of SQUARE: brush_type = SLASH
      of CROSS:  brush_type = SQUARE
  elif w.getKeyPressed(KEY.TAB):
    save(canvas)

  # drawing with mouse
  if w.getMousePressed(LEFT):
    var pos = w.getMousePos()
    if collide(canvas, pos): # and we also add condition for drawing to do drawing only when it is within canvas
      case brush_type:
        of SLASH:  brushDrawSlash(w, pos)
        of SQUARE: brushDrawSquare(w, pos)
        of CROSS:  brushDrawCross(w, pos)

  w.update(manual=true)

w.finish()