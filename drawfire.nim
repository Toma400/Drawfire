from pixie/fileformats/png import encodePng
import clipboard
import std/private/osdirs
import std/strformat
import std/sequtils
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
  if fileExists("banner.png"): return newImage("banner_small.png", (800, 480))
  else:                        return newRect((0, 600), (1280, 320), CHOCOLATE).toImage

var w    = initWindow((1280, 600), "Drawfire", bg_colour=CHOCOLATE) # 920
var logo = getBanner()

# var canvbg = newRect(pos=(0, 0), size=(800, 600), WHITE) # background of canvas (if transparency is set, it allows for white background)
var canvas = newRect(pos=(0, 0), size=(800, 600), WHITE) # canvas (for drawing)
var images = newSeq[string]() # will handle

# loaded image
var load = 0
var timer = 0
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

proc cycleImages(mode: int = 0) =
    images = toSeq(walkFiles("image*.png"))
    if mode == 1:
      if images.len > load+1 and load+1 > 0:
        load += 1
        timer = 20
      elif load+1 == images.len:
        load  = 0
        timer = 20
    elif mode == -1:
      # 4 > [-1] && 0 > 0
      if load > 0:
        load -= 1
        timer = 20
      elif load == 0:
        load = images.len-1
        timer = 20
    try: # handling wrong size
      canvas.matrix = newImage(images[load]).matrix
      w.drawRect(canvas)
    except: discard

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
      w.drawRect(leftImageButton)
      w.drawRect(rightImageButton)
      w.drawRect(loadImageButton)
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

  if timer > 0: timer -= 1 # ticks down the timer

  if w.getKeyPressed(KEY.UP):
    w.drawRect(brush_rect)
    brush += 1
  elif w.getKeyPressed(KEY.DOWN):
    w.drawRect(brush_rect)
    if brush > 1:
      brush -= 1
  elif w.getKeyPressed(KEY.LEFT) and timer == 0:
    w.drawRect(brush_rect)
    brush_type = cycleBrushes(brush_type, -1)
    w.dynamicBrush()
    timer = 20
  elif w.getKeyPressed(KEY.RIGHT) and timer == 0:
    w.drawRect(brush_rect)
    brush_type = cycleBrushes(brush_type, +1)
    w.dynamicBrush()
    timer = 20
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
  elif w.getKeyPressed(KEY.L_CTRL) or w.getKeyPressed(KEY.R_CTRL):
    discard
  #     let p = clipboardWithName(CboardGeneral) # _H:0001 | _H:0007 | _H:0010 | _H:000D | HTML Format
  #     writeData(p, "_H:0001", encodePng((canvas.toImage).png))
  #     # setClipboardString(w.scr.win.ct, "Hello world".cstring) # encodePng((canvas.toImage).png)
  #     # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setclipboarddata
  #     # https://learn.microsoft.com/en-us/windows/win32/dataxchg/standard-clipboard-formats
  # https://github.com/search?q=clipboard+language%3ANim+&type=code
  # https://github.com/search?q=repo%3Ayglukhov%2Fclipboard%20writeData&type=code
  # https://duckduckgo.com/?q=image+to+byte&ia=web
  # https://duckduckgo.com/?q=base64+into+bytes+nim&ia=answer

  # drawing with mouse
  if w.getMousePressed(LEFT):
    var pos = w.getMousePos()
    if collide(canvas, pos): # and we also add condition for drawing to do drawing only when it is within canvas
      brushDraw(w, pos, brush_type)
    else:
      if collide(blueButton, pos):        brush_kind.setColour(getColors("1"))
      elif collide(greenButton, pos):     brush_kind.setColour(getColors("2"))
      elif collide(redButton, pos):       brush_kind.setColour(getColors("3"))
      elif collide(yellowButton, pos):    brush_kind.setColour(getColors("4"))
      elif collide(lightBlueButton, pos): brush_kind.setColour(getColors("5"))
      elif collide(limeButton, pos):      brush_kind.setColour(getColors("6"))
      elif collide(orangeButton, pos):    brush_kind.setColour(getColors("7"))
      elif collide(brownButton, pos):     brush_kind.setColour(getColors("8"))
      elif collide(purpleButton, pos):    brush_kind.setColour(getColors("9"))
      elif collide(blackButton, pos):     brush_kind.setColour(getColors("10"))
      elif collide(whiteButton, pos):     brush_kind.setColour(getColors("11"))
      elif collide(grayButton, pos):      brush_kind.setColour(getColors("12"))
      elif collide(cyanButton, pos):      brush_kind.setColour(getColors("13"))
      elif collide(creamButton, pos):     brush_kind.setColour(getColors("14"))
      elif collide(baikoButton, pos):     brush_kind.setColour(getColors("15"))
      elif collide(crayButton, pos):      brush_kind.setColour(getColors("16"))
      else:
        if collide(leftBrushButton, pos) and timer == 0:
          w.drawRect(brush_rect)
          brush_type = cycleBrushes(brush_type, -1)
          w.dynamicBrush()
          timer = 20
        elif collide(rightBrushButton, pos) and timer == 0:
          w.drawRect(brush_rect)
          brush_type = cycleBrushes(brush_type, +1)
          w.dynamicBrush()
          timer = 20
        elif collide(saveButton, pos):
          save(canvas)
        elif collide(leftImageButton, pos) and timer == 0:
          cycleImages(-1)
        elif collide(rightImageButton, pos) and timer == 0:
          cycleImages(1)
        elif collide(loadImageButton, pos) and timer == 0:
          cycleImages()
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