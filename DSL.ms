// Game loop
globals.dsl = {}

// Library features
import "DSL_Debug"
import "DSL_Input"
import "DSL_Entity"

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

	key.clear
end function


//*************** DEMO
if locals == globals then
	ent = {}
	ent.alive = true
	ent.update = function(dt)
		if dsl.keyPressed("a") then 
			print "A"
		end if

		if dsl.keyReleased("a") then 
			print "A"
		end if

		if dsl.keyPressed("d") then
			print "Deleted"
			self.alive = false
		end if
	end function

	ents = [ent]

	dsl.loop = function
		
		if dsl.keyPressed("escape") then
			dsl.stop
		end if
		dsl.entt.update ents
	end function

	while dsl.running
		dsl.update
		yield
	end while

end if