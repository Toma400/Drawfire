import std/strformat
import nimfire/colors
import nimfire/input
import nimfire/image # required for saving canvas as PNG
import nimfire/types # required for 'brushDraw' proc
import nimfire/draw
import nimfire
import brushes
import buttons
import os

var w    = initWindow((1280, 920), "Drawfire", resizable=true, bg_colour=CHOCOLATE)
var logo = newImage("banner.png", (0, 600))

# var canvbg = newRect(pos=(0, 0), size=(800, 600), WHITE) # background of canvas (if transparency is set, it allows for white background)
var canvas = newRect(pos=(0, 0), size=(800, 600), WHITE) # canvas (for drawing)

type
  BRUSHES = enum
    SLASH, SQUARE, CROSS, CIRCLE
var brush = 1 # size of a brush
var brush_type = SLASH
var brush_rect = newRect(pos=(820, 20), size=(180, 180), IWAI) # background
var brush_kind = newRect(pos=(910, 110), size=(50, 50), BLACK)  # marker showcasing type of brush & colour

proc brushDraw(w: var Window, pos: (int, int), b: BRUSHES) =
    var coords = newSeq[(int, int)]()
    case b:
      of SLASH:
        for c in brushSlash(brush, pos): coords.add(c)
      of SQUARE:
        for c in brushSquare(brush, pos): coords.add(c)
      of CROSS:
        for c in brushCross(brush, pos): coords.add(c)
      of CIRCLE:
        for c in brushCircle(brush, pos): coords.add(c)
    for coord in coords:
      w.fillPos(coord, brush_kind.colour)
      setPixel(canvas, coord, brush_kind.colour)

proc save(r: Rect) =
    for i in 1..100_000:
      if not fileExists(fmt"image{i}.png"):
        saveImage(r.toImage(), fmt"image{i}.png")
        break

proc clear() =
    w.clear()
    clearPixels(canvas)
    # w.drawRect(canvbg)
    w.drawRect(canvas)
    w.drawRect(brush_rect)
    block Buttons:
      w.drawRect(blueButton)
      w.drawRect(greenButton)
      w.drawRect(redButton)
      w.drawRect(yellowButton)
      w.drawRect(lightBlueButton)
      w.drawRect(limeButton)
      w.drawRect(orangeButton)
      w.drawRect(brownButton)
      w.drawRect(purpleButton)
      w.drawRect(blackButton)
      w.drawRect(whiteButton)
      w.drawRect(grayButton)
      w.drawRect(cyanButton)
      w.drawRect(creamButton)
    block Images:
      w.drawImage(logo)

clear()

while w.tick():
  brushDraw(w, brush_kind.pos, brush_type)

  if w.getKeyPressed(KEY.B):
    brush_kind.setColour(BLACK)
  elif w.getKeyPressed(KEY.G):
    brush_kind.setColour(GREEN)
  elif w.getKeyPressed(KEY.R):
    brush_kind.setColour(RED)
  elif w.getKeyPressed(KEY.W):
    brush_kind.setColour(WHITE)
  elif w.getKeyPressed(KEY.L):
    brush_kind.setColour(BLUE)
  elif w.getKeyPressed(KEY.Y):
    brush_kind.setColour(YELLOW)
  elif w.getKeyPressed(KEY.P):
    brush_kind.setColour(PURPLE)
  elif w.getKeyPressed(KEY.Q):
    clear()
  elif w.getKeyPressed(KEY.UP):
    w.drawRect(brush_rect)
    brush += 1
  elif w.getKeyPressed(KEY.DOWN):
    w.drawRect(brush_rect)
    if brush > 1:
      brush -= 1
  elif w.getKeyPressed(KEY.LEFT):
    w.drawRect(brush_rect)
    case brush_type:
      of SLASH:  brush_type = SQUARE
      of SQUARE: brush_type = CROSS
      of CROSS:  brush_type = CIRCLE
      of CIRCLE: brush_type = SLASH
  elif w.getKeyPressed(KEY.RIGHT):
    w.drawRect(brush_rect)
    case brush_type:
      of SLASH:  brush_type = CIRCLE
      of SQUARE: brush_type = SLASH
      of CROSS:  brush_type = SQUARE
      of CIRCLE: brush_type = CROSS
  elif w.getKeyPressed(KEY.TAB):
    save(canvas)
  elif w.getKeyPressed(KEY.T):
    if canvas.colour == toRGBX(0, 0, 0, 0): setColour(canvas, WHITE)
    else:                                   setColour(canvas, toRGBX(0, 0, 0, 0))
    clear()

  # drawing with mouse
  if w.getMousePressed(LEFT):
    var pos = w.getMousePos()
    if collide(canvas, pos): # and we also add condition for drawing to do drawing only when it is within canvas
      brushDraw(w, pos, brush_type)
    else:
      if collide(blueButton, pos):        brush_kind.setColour(BLUE)
      elif collide(greenButton, pos):     brush_kind.setColour(GREEN)
      elif collide(redButton, pos):       brush_kind.setColour(RED)
      elif collide(yellowButton, pos):    brush_kind.setColour(YELLOW)
      elif collide(lightBlueButton, pos): brush_kind.setColour(toRGBX(135, 171, 203, 255))
      elif collide(limeButton, pos):      brush_kind.setColour(LIME)
      elif collide(orangeButton, pos):    brush_kind.setColour(ORANGE_RED)
      elif collide(brownButton, pos):     brush_kind.setColour(ACAJOU)
      elif collide(purpleButton, pos):    brush_kind.setColour(PURPLE)
      elif collide(blackButton, pos):     brush_kind.setColour(BLACK)
      elif collide(whiteButton, pos):     brush_kind.setColour(WHITE)
      elif collide(grayButton, pos):      brush_kind.setColour(toRGBX(126, 133, 138, 255))
      elif collide(cyanButton, pos):      brush_kind.setColour(TEAL)
      elif collide(creamButton, pos):     brush_kind.setColour(CREAM)

  w.update(manual=true)

w.finish()