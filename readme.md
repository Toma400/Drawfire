![](banner.png)
**Drawfire** is simple drawing application made on [Nimfire framework](https://github.com/Toma400/Nimfire)
as example to learn code from. However, process of writing it was also fun enough
for me to decide to make it an app on its own.  
Don't expect anything groundbreaking - it is just fun side-project and it won't get
anywhere close to legends like Krita or GIMP. It's still fun to play with.

### What features does it have?
It allows you to draw with few predetermined colours, as well as adjust brush size
and type. It exports images to PNG, of strict size 800x600.  
From advantages it has I would definitely say that it is extremely small - so if you
want to draw something really quickly, it will definitely be possible.

### How to use it?
Whenever you run the app, you get empty canvas. Draw with your mouse.  
Here are shortcuts that you will need:

|    Key(s)    | Usage                          |
|:------------:|:-------------------------------|
|     TAB      | Saves the image                |
|      Q       | Clears the canvas              |
|      T       | Changes transparency of canvas |
|  UP / DOWN   | Changes size of brush          |
| LEFT / RIGHT | Changes brush type             |
|      B       | Changes brush colour to black  |
|      W       | Changes brush colour to white  |
|      L       | Changes brush colour to blue   |
|      G       | Changes brush colour to green  |
|      R       | Changes brush colour to red    |
|      Y       | Changes brush colour to yellow |
|      P       | Changes brush colour to purple |

### Feature chart
- [x] Basics
  - [x] Changing brush size
    - [ ] Brush size Rect 
  - [ ] Filling tool
  - [ ] Eraser
- [x] Colour
  - [x] Predefined colour picker 
  - [ ] Fluid colour picker 
- [x] Brushes
  - [x] Notifier of current brush type & size 
  - [x] Various brushes
    - [x] Circle brush 
  - [ ] Custom brushes
    - [ ] JSON-driven
    - [ ] PNG-driven <!-- reading matrix and creating specific brush through it? -->
- [X] Saving the image
- [ ] Loading the image <!-- load.png is loaded and checked for boundaries
                             would require Nimfire to make reverse 'toRect' -->
- [ ] Advanced
  - [ ] Layers 
  - [ ] Transparency support
- [ ] APIs
  - [ ] Wacom 