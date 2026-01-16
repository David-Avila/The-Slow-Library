// Display Managment
import "listUtil"
dsl.disp = {}

dsl.disp.SPRITE = displayMode.sprite
dsl.disp.PIXEL = displayMode.pixel
dsl.disp.TEXT = displayMode.text
dsl.disp.SOLID = displayMode.solidColor
dsl.disp.TILE = displayMode.tile
dsl.disp.OFF = displayMode.off

// Default displays
globals.SOL = display(7) // Solid
// display(6) - not used
globals.GFX = display(5) // Sprite
globals.SPD = display(4) // Pixel
globals.TXT = display(3) // Text
globals.UID = display(2) // UI
globals.TRD = display(1) // Transitions
globals.TOD = display(0) // Top display

// Modes
UID.mode = dsl.disp.SPRITE
TRD.mode = dsl.disp.SPRITE
TOD.mode = dsl.disp.SPRITE

// Helper functions
SPD.add = function(sprite)
	SPD.sprites.push sprite
end function

SPD.remove = function(sprite)
	SPD.sprites.removeVal sprite
end function