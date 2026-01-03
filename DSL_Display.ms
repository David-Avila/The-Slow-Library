// Display Managment

dsl.disp = {}

dsl.disp.SPRITE = displayMode.sprite
dsl.disp.PIXEL = displayMode.pixel
dsl.disp.TEXT = displayMode.text
dsl.disp.SOLID = displayMode.solidColor
dsl.disp.TILE = displayMode.tile
dsl.disp.OFF = displayMode.off

// Default displays
SOL = display(7) // Solid
// display(6) - not used
SPD = display(5) // Sprite
GFX = display(4) // Pixel
TXT = display(3) // Text
UID = display(2) // UI
TRD = display(1) // Transitions
TOD = display(0) // Top display

// Modes
UID.mode = dsl.disp.SPRITE
TRD.mode = dsl.disp.SPRITE
TOD.mode = dsl.disp.SPRITE