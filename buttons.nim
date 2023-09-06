import nimfire/colors
import nimfire/draw
import nimfire/types
import nimfire

var blueButton*   = newRect((1020, 20), (50, 50), BLUE)
var greenButton*  = newRect((1080, 20), (50, 50), GREEN)
var redButton*    = newRect((1140, 20), (50, 50), RED)
var yellowButton* = newRect((1200, 20), (50, 50), YELLOW)

var lightBlueButton* = newRect((1020, 80), (50, 50), toRGBX(135, 171, 203, 255))
var limeButton*      = newRect((1080, 80), (50, 50), LIME)
var orangeButton*    = newRect((1140, 80), (50, 50), ORANGE_RED)
var brownButton*     = newRect((1200, 80), (50, 50), ACAJOU)

var purpleButton* = newRect((1020, 140), (50, 50), PURPLE)
var blackButton*  = newRect((1080, 140), (50, 50), BLACK)
var whiteButton*  = newRect((1140, 140), (50, 50), WHITE)
var grayButton*   = newRect((1200, 140), (50, 50), toRGBX(126, 133, 138, 255))

var cyanButton*  = newRect((1020, 200), (50, 50), TEAL)
var creamButton* = newRect((1080, 200), (50, 50), CREAM)

var leftBrushButton* = newRect((820, 220), (50, 50), ACAJOU)
var rightBrushButton* = newRect((950, 220), (50, 50), ACAJOU)

var saveButton*    = newRect((820, 280), (50, 50), ACAJOU)
var saveButtonAE1* = newRect((830, 290), (30, 30), BLUE)
var saveButtonAE2* = newRect((836, 290), (20, 10), GRAY)
var saveButtonAE3* = newRect((842, 291), ( 8,  6), BLUE)

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
                       creamButton]