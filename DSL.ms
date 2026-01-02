// Game loop
globals.dsl = {}

// Library features
import "DSL_Input"

dsl.running = true

dsl.frameCount = 0
dsl.lastTime = 0
dsl.dt = 1/60

dsl.update = function
	self.frameCount += 1
	self.dt = time - self.lastTime
	self.lastTime = time

	self.loop self.dt
end function

dsl.stop = function; self.running = false ;end function

dsl.loop = function(dt); end function

if locals == globals then
	dsl.loop = function(dt)

	end function

	while dsl.running
		dsl.update
	end while
end if