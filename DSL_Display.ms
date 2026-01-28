// Display Managment
import "listUtil"

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.disp = {}

display(2).mode = displayMode.sprite
display(1).mode = displayMode.sprite
display(0).mode = displayMode.sprite

// Default displays
globals.SOL = display(7) // Solid
// display(6) - not used
globals.GFX = display(5) // Pixel
globals.SPD = display(4) // Sprite
globals.TXT = display(3) // Text
globals.UID = display(2) // UI
globals.TRD = display(1) // Transitions
globals.TOD = display(0) // Top display

// Helper functions
SPD.add = function(sprite)
	SPD.sprites.push sprite
end function

SPD.remove = function(sprite)
	SPD.sprites.removeVal sprite
end function

SPD.wipe = function
	while SPD.sprites.len > 0
		SPD.remove SPD.sprites[0]
	end while
end function