import nimfire/colors
import nimfire/draw
import nimfire/types
import nimfire

proc isTransparent* (c: Rect): bool =
    return c.colour == toRGBX(0, 0, 0, 0)

var blueButton*   = newRect((1020, 20), (50, 50), BLUE)
var greenButton*  = newRect((1080, 20), (50, 50), GREEN)
var redButton*    = newRect((1140, 20), (50, 50), RED)
var yellowButton* = newRect((1200, 20), (50, 50), YELLOW)

var lightBlueButton* = newRect((1020, 80), (50, 50), uPASTEL_LIGHT_BLUE)
var limeButton*      = newRect((1080, 80), (50, 50), LIME)
var orangeButton*    = newRect((1140, 80), (50, 50), ORANGE_RED)
var brownButton*     = newRect((1200, 80), (50, 50), ACAJOU)

var purpleButton* = newRect((1020, 140), (50, 50), PURPLE)
var blackButton*  = newRect((1080, 140), (50, 50), BLACK)
var whiteButton*  = newRect((1140, 140), (50, 50), WHITE)
var grayButton*   = newRect((1200, 140), (50, 50), GRAY)

var cyanButton*  = newRect((1020, 200), (50, 50), TEAL)
var creamButton* = newRect((1080, 200), (50, 50), CREAM)
var baikoButton* = newRect((1140, 200), (50, 50), BAIKO)
var crayButton*  = newRect((1200, 200), (50, 50), uGRAYED_CREAM)

var leftBrushButton* = newRect((820, 220), (50, 50), ACAJOU)
var rightBrushButton* = newRect((950, 220), (50, 50), ACAJOU)

var saveButton*    = newRect((820, 280), (50, 50), ACAJOU)
var saveButtonAE1* = newRect((830, 290), (30, 30), BLUE)
var saveButtonAE2* = newRect((836, 290), (20, 10), GRAY)
var saveButtonAE3* = newRect((842, 291), ( 8,  6), BLUE)

var trButton*    = newRect((880, 280), (50, 50), ACAJOU) # transparency handling
var trButtonAE1* = newRect((891, 291), (20, 20), WHITE)
var trButtonAE2* = newRect((901, 301), (20, 20), BLACK)

var cleanButton*    = newRect((950, 280), (50, 50), ACAJOU)

proc leftBrushButtonArrow* (w: var Window, size: int) =
    let pos = (835, 245)
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pos[0]+abs(i)+j
        let y = pos[1]+i
        w.fillPos((x, y), uDARK_BROWN)
proc rightBrushButtonArrow* (w: var Window, size: int) =
    let pos = (985, 245)
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pos[0]-abs(i)-j
        let y = pos[1]+i
        w.fillPos((x, y), uDARK_BROWN)
proc cleanButtonCross* (wn: var Window) =
    proc draw(p: (int, int), s: int, w: var Window) =
      for i in -s..s:     # s = size
        let x = p[0] + i  # p = pos
        let y = p[1] + i
        w.fillPos((x, y), RED)
        let a = p[0] + i
        let b = p[1] - i
        w.fillPos((a, b), RED)
    draw((976, 304), 12, wn)
    draw((974, 304), 12, wn)
    draw((976, 306), 12, wn)
    draw((974, 306), 12, wn)

# lists that should be updated to update drawing boards
var colourButtons* = @[blueButton,
                       greenButton,
                       redButton,
                       yellowButton,
                       lightBlueButton,
                       limeButton,
                       orangeButton,
                       brownButton,
                       purpleButton,
                       blackButton,
                       whiteButton,
                       grayButton,
                       cyanButton,
                       creamButton,
                       baikoButton,
                       crayButton]