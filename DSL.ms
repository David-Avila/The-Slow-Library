// Game loop
globals.dsl = {}

// Library features
import "DSL_Debug"
import "DSL_Input"

dsl.running = true

dsl.frameCount = 0
dsl.lastTime = 0
dsl.dt = 1/60

dsl.fpsTimer = 0
dsl.fpsFrames = 0
dsl.fpsValue = 0


dsl.stop = function; dsl.running = false; end function
dsl.loop = function; end function
dsl.fps = function; return dsl.fpsValue; end function

dsl.update = function
	// Delta time calculation
	dsl.frameCount += 1
	dsl.dt = time - dsl.lastTime
	dsl.lastTime = time

	// FPS calculation
	dsl.fpsTimer += dsl.dt
	dsl.fpsFrames += 1

	if dsl.fpsTimer >= 1 then
		dsl.fpsValue = dsl.fpsFrames / dsl.fpsTimer
		dsl.fpsTimer = 0
		dsl.fpsFrames = 0
	end if

	// Main loop
	dsl.loop
end function


//*************** DEMO
if locals == globals then
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