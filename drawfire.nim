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

proc getBanner(): Image =
  if fileExists("banner.png"): return newImage("banner.png", (0, 600))
  else:                        return newRect((0, 600), (1280, 320), CHOCOLATE).toImage

var w    = initWindow((1280, 920), "Drawfire", bg_colour=CHOCOLATE)
var logo = getBanner()

# var canvbg = newRect(pos=(0, 0), size=(800, 600), WHITE) # background of canvas (if transparency is set, it allows for white background)
var canvas = newRect(pos=(0, 0), size=(800, 600), WHITE) # canvas (for drawing)

var angle = 30
var brush = 15 # size of a brush
var brush_type = BRUSHES.SLASH
var brush_rect = newRect(pos=(820, 20), size=(180, 180), IWAI) # background
var brush_kind = newRect(pos=(910, 110), size=(50, 50), BLACK)  # marker showcasing type of brush & colour

proc brushDraw(w: var Window, pos: (int, int), b: BRUSHES) =
    var coords = brushPick(b, brush, pos, angle)
    for coord in coords:
      w.fillPos(coord, brush_kind.colour)
      setPixelAbsolute(canvas, coord, brush_kind.colour)

proc dynamicBrush(w: var Window) =
    let p = (910, 245)
    let s = 15           # size of icon
    var c = CHOCOLATE    # default colour: background
    if brush_type in [ROTABLE_CROSS, ROTABLE_X, ROTABLE_Y, ROTABLE_MANUALLY]:
      if   brush_type == ROTABLE_CROSS:    c = RED
      elif brush_type == ROTABLE_X:        c = GREEN
      elif brush_type == ROTABLE_Y:        c = BLUE
      elif brush_type == ROTABLE_MANUALLY: c = CYAN
    for x in -s..s:
      if x > 0:
        w.fillPos((p[0]+x, p[1]+x), c)
        w.fillPos((p[0]+x, p[1]-x), c)
      if x == 0:
        for y in -s..s:
          w.fillPos((p[0], p[1]+y), c)
          if y == 0:
            for x2 in -s..s:
              w.fillPos((p[0]+x2, p[1]), c)
      if x < 0:
        w.fillPos((p[0]+x, p[1]+x), c)
        w.fillPos((p[0]+x, p[1]-x), c)

proc save(r: Rect) =
    for i in 1..100_000:
      if not fileExists(fmt"image{i}.png"):
        saveImage(r.toImage(), fmt"image{i}.png")
        break

proc trRedraw(cond: bool = true) =
    if cond:
      if isTransparent(canvas):
        setColour(canvas, WHITE)
      else:
        setColour(canvas, toRGBX(0, 0, 0, 0))
    w.drawRect(trButton)
    if isTransparent(canvas):
      w.drawRect(trButtonAE1)
      w.drawRect(trButtonAE2)
    else:
      w.drawRect(trButtonAE2)
      w.drawRect(trButtonAE1)

proc clear() =
    w.clear()
    clearPixels(canvas)
    # w.drawRect(canvbg)
    w.drawRect(canvas)
    w.drawRect(brush_rect)
    block GUI:
      w.drawRect(leftBrushButton)
      w.drawRect(rightBrushButton)
      w.drawRect(saveButton)
      w.drawRect(saveButtonAE1)
      w.drawRect(saveButtonAE2)
      w.drawRect(saveButtonAE3)
      w.drawRect(cleanButton)
      w.cleanButtonCross()
      w.dynamicBrush()
      trRedraw(false)
      w.leftBrushButtonArrow(10)
      w.rightBrushButtonArrow(10)
    block Buttons:
      for cbut in colourButtons:
        w.drawRect(cbut)
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
    brush_type = cycleBrushes(brush_type, 1)
    w.dynamicBrush()
  elif w.getKeyPressed(KEY.RIGHT):
    w.drawRect(brush_rect)
    brush_type = cycleBrushes(brush_type, -1)
    w.dynamicBrush()
  elif w.getKeyPressed(KEY.L_BRACKET):
    w.drawRect(brush_rect)
    angle += -1
  elif w.getKeyPressed(KEY.R_BRACKET):
    w.drawRect(brush_rect)
    angle += 1
  elif w.getKeyPressed(KEY.TAB):
    save(canvas)
  elif w.getKeyPressed(KEY.T):
    trRedraw()
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
      else:
        if collide(leftBrushButton, pos):
          w.drawRect(brush_rect)
          brush_type = cycleBrushes(brush_type, 1)
          w.dynamicBrush()
        elif collide(rightBrushButton, pos):
          w.drawRect(brush_rect)
          brush_type = cycleBrushes(brush_type, -1)
          w.dynamicBrush()
        elif collide(saveButton, pos):
          save(canvas)
        elif collide(trButton, pos):
          trRedraw()
          clear()
        elif collide(cleanButton, pos):
          clear()
  if w.getMousePressed(RIGHT):
    var pos = w.getMousePos()
    if collide(canvas, pos):
      brushDraw(w, pos, brush_type)
      # fill(w, pos[0], pos[1]) # previously - bucket

  w.update(manual=true)

w.finish()