// Game loop
globals.dsl = {}

checkImport = function(fileName)
	f = fileName + ".ms"

	if file.exists(f) then
		import fileName
		globals[fileName] = fileName
	end if
end function

// Library features
checkImport "DSL_Debug"
checkImport "DSL_Display"
checkImport "DSL_Input"
checkImport "DSL_Entity"
checkImport "DSL_Animations"
checkImport "DSL_Log"
checkImport "DSL_FSM"
import "stringUtil"

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

dsl.newSprite = function(imgOrPath, x=0, y=0, scale=1)
	s = new Sprite
	if imgOrPath isa string then
		s.image = file.loadImage(imgOrPath)
	else
		s.image = imgOrPath
	end if
	s.x = x
	s.y = y
	s.scale = scale

	return s
end function

dsl._scanFolder = function(ext, folder)
	filesFound = []

	for fileName in file.children(folder)
		filePath = file.child(folder, fileName)

		if file.info(filePath).isDirectory then
			filesFound += dsl._scanFolder(ext, filePath)
		else if fileName isa string then
			if fileName.endsWith(ext) then
				fileName.replace " ", "_"
				fileName.replace "-", "_"

				filesFound.push {"name": fileName - ("." + ext), "path": filePath}
			end if
		end if
	end for

	return filesFound
end function

dsl.images = {}
dsl.importImages = function(folder="")
	if folder == "" then 
		folder = pwd
	else if not folder[0] == "/" then
		folder = file.child(pwd, folder)
	end if

	filesFound = dsl._scanFolder("png", folder)

	for f in filesFound
		dsl.images[f.name] = file.loadImage(f.path)
	end for
end function

dsl.sounds = {}
dsl.importSounds = function(folder="")
	if folder == "" then 
		folder = pwd
	else if not folder[0] == "/" then
		folder = file.child(pwd, folder)
	end if

	filesFound = dsl._scanFolder("wav", folder)
	filesFound += dsl._scanFolder("ogg", folder)

	for f in filesFound
		dsl.sounds[f.name] = file.loadSound(f.path)
	end for
end function