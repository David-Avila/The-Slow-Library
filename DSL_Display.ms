// Display Managment
import "listUtil"

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.disp = {}

SpriteDisp = new SpriteDisplay
SpriteDisp.add = function(sprite)
	self.sprites.push sprite
end function

SpriteDisp.remove = function(sprite)
	self.sprites.removeVal sprite
end function

SpriteDisp.wipe = function
	while self.sprites.len > 0
		self.remove self.sprites[0]
	end while
end function

SpriteDisp.ysort = function
	if self.sprites.len <= 2 then return

	changed = true
	while changed
		changed = false
		for i in range(0, self.sprites.len-2)
			sp1 = self.sprites[i]
			sp2 = self.sprites[i+1]

			if sp1.y - sp1.image.height * sp1.scale * 0.5 < sp2.y - sp2.image.height * sp2.scale * 0.5 then
				self.sprites[i] = sp2
				self.sprites[i+1] = sp1
				changed = true
			end if
		end for
	end while
end function

display(2).mode = displayMode.sprite
display(1).mode = displayMode.sprite
display(0).mode = displayMode.sprite

// Default displays
globals.SOL = display(7) // Solid
// display(6) - not used
globals.GFX = display(5) // Pixel
globals.SPD = new SpriteDisp
globals.TXT = display(3) // Text
globals.UID = display(2) // UI
globals.TRD = display(1) // Transitions
globals.TOD = display(0) // Top display

SPD.install 4