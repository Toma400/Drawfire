from chroma import ColorRGBX
import std/private/oscommon
import std/tables
import nimfire/colors
import nimfire/draw
import nimfire/types
import nimfire
import json

var jsCols = newTable[string, seq[int]]()
var dfCols = {  "1": BLUE,
                "2": GREEN,
                "3": RED,
                "4": YELLOW,
                "5": uPASTEL_LIGHT_BLUE,
                "6": LIME,
                "7": ORANGE_RED,
                "8": ACAJOU,
                "9": PURPLE,
               "10": BLACK,
               "11": WHITE,
               "12": GRAY,
               "13": TEAL,
               "14": CREAM,
               "15": BAIKO,
               "16": uGRAYED_CREAM}.toTable

if fileExists("colours.json"):
  try:
    var f = readFile("colours.json")
    var js = parseJson(f)
    for ix in 1..16:
        var jns = js[$ix].getElems()
        var ret = newSeq[int](3)
        for ji in jns.items:
            ret.add(ji.getInt())
        jsCols[$ix] = ret
  except: discard

proc getColors* (s: string): ColorRGBX =
    try: result = toRGBX(jsCols[s][3].uint8,
                         jsCols[s][4].uint8,
                         jsCols[s][5].uint8, 255.uint8)
    except: result = dfCols[s]

proc isTransparent* (c: Rect): bool =
    return c.colour == toRGBX(0, 0, 0, 0)

var blueButton*   = newRect((1020, 20), (50, 50), getColors("1"))
var greenButton*  = newRect((1080, 20), (50, 50), getColors("2"))
var redButton*    = newRect((1140, 20), (50, 50), getColors("3"))
var yellowButton* = newRect((1200, 20), (50, 50), getColors("4"))

var lightBlueButton* = newRect((1020, 80), (50, 50), getColors("5"))
var limeButton*      = newRect((1080, 80), (50, 50), getColors("6"))
var orangeButton*    = newRect((1140, 80), (50, 50), getColors("7"))
var brownButton*     = newRect((1200, 80), (50, 50), getColors("8"))

var purpleButton* = newRect((1020, 140), (50, 50), getColors("9"))
var blackButton*  = newRect((1080, 140), (50, 50), getColors("10"))
var whiteButton*  = newRect((1140, 140), (50, 50), getColors("11"))
var grayButton*   = newRect((1200, 140), (50, 50), getColors("12"))

var cyanButton*  = newRect((1020, 200), (50, 50), getColors("13"))
var creamButton* = newRect((1080, 200), (50, 50), getColors("14"))
var baikoButton* = newRect((1140, 200), (50, 50), getColors("15"))
var crayButton*  = newRect((1200, 200), (50, 50), getColors("16"))

let leftBrushButton* = newRect((820, 220), (50, 50), ACAJOU)
let rightBrushButton* = newRect((950, 220), (50, 50), ACAJOU)

let saveButton*    = newRect((820, 280), (50, 50), ACAJOU)
let saveButtonAE1* = newRect((830, 290), (30, 30), BLUE)
let saveButtonAE2* = newRect((836, 290), (20, 10), GRAY)
let saveButtonAE3* = newRect((842, 291), ( 8,  6), BLUE)

let trButton*    = newRect((880, 280), (50, 50), ACAJOU) # transparency handling
let trButtonAE1* = newRect((891, 291), (20, 20), WHITE)
let trButtonAE2* = newRect((901, 301), (20, 20), BLACK)

let cleanButton*    = newRect((950, 280), (50, 50), ACAJOU)

let separator*        = newRect((800, 382), (480, 5), ACAJOU)
let leftImageButton*  = newRect((965, 410), (50, 50), ACAJOU)
let rightImageButton* = newRect((1065, 410), (50, 50), ACAJOU)
let loadImageButton*  = newRect((1025, 400), (30, 70), ACAJOU)

proc leftBrushButtonArrow* (w: var Window, size: int) =
    let pos = (835, 245)               # brush buttons
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pos[0]+abs(i)+j
        let y = pos[1]+i
        w.fillPos((x, y), uDARK_BROWN)

    let pis = (985, 435)              # image switch buttons
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pis[0]+abs(i)+j
        let y = pis[1]+i
        w.fillPos((x, y), MORNING_BLUE)
proc rightBrushButtonArrow* (w: var Window, size: int) =
    let pos = (985, 245)               # brush buttons
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pos[0]-abs(i)-j
        let y = pos[1]+i
        w.fillPos((x, y), uDARK_BROWN)

    let pis = (1095, 435)              # image switch buttons
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pis[0]-abs(i)-j
        let y = pis[1]+i
        w.fillPos((x, y), MORNING_BLUE)
proc downBrushButtonArrow* (w: var Window, size: int) =
    let pis = (1040, 420)
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pis[0]+i
        let y = pis[1]-abs(i)+j
        w.fillPos((x, y), uGRAYED_CREAM)

    let pvs = (1040, 450)
    for i in -size..size:
      for j in 0..(size-abs(i)):
        let x = pvs[0]+i
        let y = pvs[1]-abs(i)+j
        w.fillPos((x, y), uGRAYED_CREAM)
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
let colourButtons* = @[blueButton,
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