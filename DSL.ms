// Game loop
globals.dsl = {}

// Library features
import "DSL_Input"

dsl.running = true

dsl.frameCount = 0
dsl.lastTime = 0
dsl.dt = 1/60

dsl.update = function
	dsl.frameCount += 1
	dsl.dt = time - dsl.lastTime
	dsl.lastTime = time

	dsl.loop
end function

dsl.stop = function; dsl.running = false ;end function

dsl.loop = function(dt); end function

if locals == globals then

	// Loop function gives you acces to the game's main loop and delta time
	// You can acces delta time with dsl.dt
	dsl.loop = function
		if dsl.keyPressed("escape") then
			dsl.stop
		end if
	end function

	while dsl.running
		dsl.update
		yield
	end while
end if