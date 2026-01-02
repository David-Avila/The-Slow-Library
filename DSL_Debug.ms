// Debug system
dsl.debug = {}

dsl.fpsTimer = 0
dsl.fpsFrames = 0
dsl.fpsValue = 0

dsl.debug.update = function
	dsl.debug.fpsTimer += dsl.dt
	dsl.debug.fpsFrames += 1

	if dsl.debug.fpsTimer >= 1 then
		dsl.debug.fpsValue = dsl.debug.fpsFrames / dsl.debug.fpsTimer
		dsl.debug.fpsTimer = 0
		dsl.debug.fpsFrames = 0
	end if
end function

dsl.debug.fps = function; return dsl.debug.fpsValue; end function