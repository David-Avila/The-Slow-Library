// Display Managment
dsl.disp = {}

SpriteDisp = new SpriteDisplay
SpriteDisp.scale = 1
SpriteDisp.add = function(sprite)
	sprite.scale = self.scale
	self.sprites.push sprite
end function

SpriteDisp.remove = function(sprite)
	self.sprites.removeVal sprite
end function

SpriteDisp.wipe = function
	while self.sprites.len > 0
		self.sprites.pop
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
display(1).mode = displayMode.pixel
display(0).mode = displayMode.sprite

// Default displays
globals.SOL = display(7)
globals.GFX = display(5)
globals.SPD = new SpriteDisp
globals.TXT = display(3)
globals.UID = display(2)
globals.TRD = display(1)
globals.TOD = display(0)

SPD.install 4
TRD.clear