import nimfire/colors
import nimfire/draw

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