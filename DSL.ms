// Game loop
globals.dsl = {}

// Library features
import "DSL_Debug"
import "DSL_Display"
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

//**************************************
if false then
	spaces = " "*80
	text.delimiter = char(13)
	
	dirInfo = file.info(path)
	if dirInfo == null then
		print "Invalid path"
		return
	end if

	lines = [dirInfo.path + " : "]	

	if not dirInfo.isDirectory then
		files = [file.name(dirInfo.path)]
		dirInfo = file.info(file.parent(dirInfo.path))
	else
		files = file.children(dirInfo.path)
		if files.len == 0 then
			print lines[0]
			print "  (Directory empty)"
			return
		end if
	end if
	
	files.sort
	for i in range(0, files.len-1)
		finfo = file.info(file.child(dirInfo.path,files[i]))
		if finfo == null then
			lines.push "file.info failed on: " + file.child(path, files[i])
			continue
		end if
		namecol = (files[i]+spaces)[:32]
		sizecol = (spaces+finfo.size)[-8:]
		if finfo.isDirectory then sizecol = "     DIR"
		lines.push "  " + namecol + sizecol + "  " + finfo.date
	end for
	pageThrough lines
end if
//**************************************

dsl._scanFolder = function(path, ext)
	filesFound = []

	for f in file.children(path)
		fileOrFolder = path + "/" + f
		if not file.info(fileOrFolder).isDirectory then
			fileName = file.name(fileOrFolder)

			fN = fileName.split(".")

			fN[0] = fN[0].replace(" ", "_")
			fN[0] = fN[0].replace("-", "_")

			if fN[1] == ext then
				filesFound.push {"name": fN[0], "path": fileOrFolder}
			end if
		else
			imgs = dsl._scanFolder(fileOrFolder, ext)

			for ff in imgs
				filesFound.push ff
			end for
		end if
	end for

	return filesFound
end function

dsl.images = {}
dsl.importImages = function(folder)
	path = pwd + "/" + folder

	// file.info(pathToFolderOrFile)
	// file.name(pathToFolderOrFile) -- return just the file or folder name without the path
	// file.children(path) -- returns an array with the names of the folders and files inside the path
	filesFound = dsl._scanFolder(path, "png")

	for f in filesFound
		dsl.images[f.name] = file.loadImage(f.path)
	end for
end function

dsl.sounds = {}
dsl.importSounds = function(folder)
	path = pwd + "/" + folder

	// file.info(pathToFolderOrFile)
	// file.name(pathToFolderOrFile) -- return just the file or folder name without the path
	// file.children(path) -- returns an array with the names of the folders and files inside the path
	filesFound = dsl._scanFolder(path, "wav")

	for f in filesFound
		dsl.sounds[f.name] = file.loadSound(f.path)
	end for
end function