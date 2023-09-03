import nimfire/colors
import nimfire/input
import nimfire/types # required for 'brushDraw' proc
import nimfire/draw
import nimfire

var w  = initWindow((1200, 800), "Drawfire", bg_colour=GREEN)  # creates window with green background
var cr = newRect(pos=(50, 50), size=(50, 50), BLACK)            # rect showing current colour
                                                                # we will use cr.colour
                                                                # from now on, as it will
                                                                # update more easily
var brush = 1 # size of a brush

# since we have brush size, we will need to customise our drawing:
# the bigger the brush, the bigger area got covered
proc brushDraw(w: var Window, pos: (int, int)) =        # -var- Window because it is required by fillPos
  for i in -brush..brush:    # we get two opposite ends which will let us to make "\" shape
                             # this means minimal size of brush will be actually 3, as -1..1 is 3 pixels
    let x = pos[0] + i  # let us go outside of our mouse position, since bigger brush must also touch
    let y = pos[1] + i  # neighbouring pixels
    w.fillPos((x, y), cr.colour)

# we can also make different brush shape:
proc brushDrawSquare(w: var Window, pos: (int, int)) =
  for i in -brush..brush:       # setting two loops let us cover square shape instead (kinda like x/y)
    for j in -brush..brush:
      let x = pos[0] + i
      let y = pos[1] + j  # we change our '+ i' into separate variable for each axis
      w.fillPos((x, y), cr.colour)

proc brushDrawCross(w: var Window, pos: (int, int)) =
  for i in -brush..brush:        # setting cross shape requires us to keep one axis unaffected
    let x = pos[0] + i
    let y = pos[1]
    w.fillPos((x, y), cr.colour)
  for j in -brush..brush:        # and then do the same for second iteration, but reversely
    let x = pos[0]
    let y = pos[1] + j
    w.fillPos((x, y), cr.colour)

while w.tick():
  w.drawRect(cr) # draws Rect showing current colour

  if w.getKeyPressed(KEY.B):
    cr.setColour(BLACK) # .setColour is performance-heavy operation, so we need to be careful
                        # to not use it too often (conditioning it with pressing key should be okay)
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
  elif w.getKeyPressed(KEY.Q):
    w.clear()
  elif w.getKeyPressed(KEY.UP):   # we add two new options: changing size of a brush up and down
    brush += 1
  elif w.getKeyPressed(KEY.DOWN):
    if brush > 1:
      brush -= 1

  # drawing with mouse
  if w.getMousePressed(LEFT):
    var pos = w.getMousePos()
    brushDraw(w, pos) # we change code here to use our proc instead
    # you can also use brushDrawSquare to test different brush types

  w.update(manual=true)

w.finish()