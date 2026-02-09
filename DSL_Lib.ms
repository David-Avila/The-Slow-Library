// Game loop
globals.dsl = {}

import "stringUtil"
import "listUtil"

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

// Save all modules to a single file
dsl.build = function
	files = []
	files.push "DSL.ms"
	files.push "DSL_Debug.ms"
	files.push "DSL_Display.ms"
	files.push "DSL_Input.ms"
	files.push "DSL_Entity.ms"
	files.push "DSL_Animations.ms"
	files.push "DSL_Log.ms"
	files.push "DSL_FSM.ms"

	cont = []

	for f in files
		cont += file.readLines(f)
	end for 

	file.writeLines "DSL_Lib.ms", cont
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
// Debug system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.debug = {}

dsl.debug.enabled = false

// Display Managment

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
// Input system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.keys = {
	"a": {"code": "a", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 0, "state" : "up", "lastChecked": -1}, 
	"b": {"code": "b", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 1, "state" : "up", "lastChecked": -1}, 
	"c": {"code": "c", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 2, "state" : "up", "lastChecked": -1}, 
	"d": {"code": "d", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 3, "state" : "up", "lastChecked": -1}, 
	"e": {"code": "e", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 4, "state" : "up", "lastChecked": -1}, 
	"f": {"code": "f", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 5, "state" : "up", "lastChecked": -1}, 
	"g": {"code": "g", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 6, "state" : "up", "lastChecked": -1}, 
	"h": {"code": "h", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 7, "state" : "up", "lastChecked": -1}, 
	"i": {"code": "i", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 8, "state" : "up", "lastChecked": -1}, 
	"j": {"code": "j", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 9, "state" : "up", "lastChecked": -1}, 
	"k": {"code": "k", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 10, "state" : "up", "lastChecked": -1}, 
	"l": {"code": "l", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 11, "state" : "up", "lastChecked": -1}, 
	"m": {"code": "m", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 12, "state" : "up", "lastChecked": -1}, 
	"n": {"code": "n", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 13, "state" : "up", "lastChecked": -1}, 
	"o": {"code": "o", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 14, "state" : "up", "lastChecked": -1}, 
	"p": {"code": "p", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 15, "state" : "up", "lastChecked": -1}, 
	"q": {"code": "q", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 16, "state" : "up", "lastChecked": -1}, 
	"r": {"code": "r", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 17, "state" : "up", "lastChecked": -1}, 
	"s": {"code": "s", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 18, "state" : "up", "lastChecked": -1}, 
	"t": {"code": "t", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 19, "state" : "up", "lastChecked": -1}, 
	"u": {"code": "u", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 20, "state" : "up", "lastChecked": -1}, 
	"v": {"code": "v", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 21, "state" : "up", "lastChecked": -1}, 
	"w": {"code": "w", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 22, "state" : "up", "lastChecked": -1}, 
	"x": {"code": "x", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 23, "state" : "up", "lastChecked": -1}, 
	"y": {"code": "y", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 24, "state" : "up", "lastChecked": -1}, 
	"z": {"code": "z", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 25, "state" : "up", "lastChecked": -1}, 
	"1": {"code": "1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 26, "state" : "up", "lastChecked": -1}, 
	"2": {"code": "2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 27, "state" : "up", "lastChecked": -1}, 
	"3": {"code": "3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 28, "state" : "up", "lastChecked": -1}, 
	"4": {"code": "4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 29, "state" : "up", "lastChecked": -1}, 
	"5": {"code": "5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 30, "state" : "up", "lastChecked": -1}, 
	"6": {"code": "6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 31, "state" : "up", "lastChecked": -1}, 
	"7": {"code": "7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 32, "state" : "up", "lastChecked": -1}, 
	"8": {"code": "8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 33, "state" : "up", "lastChecked": -1}, 
	"9": {"code": "9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 34, "state" : "up", "lastChecked": -1}, 
	"0": {"code": "0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 35, "state" : "up", "lastChecked": -1}, 
	"-": {"code": "-", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 36, "state" : "up", "lastChecked": -1}, 
	"=": {"code": "=", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 37, "state" : "up", "lastChecked": -1}, 
	"[": {"code": "[", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 38, "state" : "up", "state" : "up", "lastChecked": -1}, 
	"]": {"code": "]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 39, "state" : "up", "lastChecked": -1}, 
	"\": {"code": "\", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 40, "state" : "up", "lastChecked": -1}, 
	",": {"code": ",", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 41, "state" : "up", "lastChecked": -1}, 
	".": {"code": ".", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 42, "state" : "up", "lastChecked": -1}, 
	"/": {"code": "/", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 43, "state" : "up", "lastChecked": -1}, 
	";": {"code": ";", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 44, "state" : "up", "lastChecked": -1}, 
	"'": {"code": "'", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 45, "state" : "up", "lastChecked": -1}, 
	"`": {"code": "`", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 46, "state" : "up", "lastChecked": -1}, 
	"f1": {"code": "f1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 47, "state" : "up", "lastChecked": -1}, 
	"f2": {"code": "f2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 48, "state" : "up", "lastChecked": -1}, 
	"f3": {"code": "f3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 49, "state" : "up", "lastChecked": -1}, 
	"f4": {"code": "f4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 50, "state" : "up", "lastChecked": -1}, 
	"f5": {"code": "f5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 51, "state" : "up", "lastChecked": -1}, 
	"f6": {"code": "f6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 52, "state" : "up", "lastChecked": -1}, 
	"f7": {"code": "f7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 53, "state" : "up", "lastChecked": -1}, 
	"f8": {"code": "f8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 54, "state" : "up", "lastChecked": -1}, 
	"f9": {"code": "f9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 55, "state" : "up", "lastChecked": -1}, 
	"f10": {"code": "f10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 56, "state" : "up", "lastChecked": -1}, 
	"f11": {"code": "f11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 57, "state" : "up", "lastChecked": -1}, 
	"f12": {"code": "f12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 58, "state" : "up", "lastChecked": -1}, 
	"f13": {"code": "f13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 59, "state" : "up", "lastChecked": -1}, 
	"f14": {"code": "f14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 60, "state" : "up", "lastChecked": -1}, 
	"f15": {"code": "f15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 61, "state" : "up", "lastChecked": -1}, 
	"up": {"code": "up", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 62, "state" : "up", "lastChecked": -1}, 
	"down": {"code": "down", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 63, "state" : "up", "lastChecked": -1}, 
	"left": {"code": "left", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 64, "state" : "up", "lastChecked": -1}, 
	"right": {"code": "right", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 65}, 
	"[1]": {"code": "[1]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 66, "state" : "up", "lastChecked": -1}, 
	"[2]": {"code": "[2]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 67, "state" : "up", "lastChecked": -1}, 
	"[3]": {"code": "[3]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 68, "state" : "up", "lastChecked": -1}, 
	"[4]": {"code": "[4]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 69, "state" : "up", "lastChecked": -1}, 
	"[5]": {"code": "[5]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 70, "state" : "up", "lastChecked": -1}, 
	"[6]": {"code": "[6]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 71, "state" : "up", "lastChecked": -1}, 
	"[7]": {"code": "[7]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 72, "state" : "up", "lastChecked": -1}, 
	"[8]": {"code": "[8]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 73, "state" : "up", "lastChecked": -1}, 
	"[9]": {"code": "[9]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 74, "state" : "up", "lastChecked": -1}, 
	"[0]": {"code": "[0]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 75, "state" : "up", "lastChecked": -1}, 
	"[+]": {"code": "[+]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 76, "state" : "up", "lastChecked": -1}, 
	"[-]": {"code": "[-]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 77, "state" : "up", "lastChecked": -1}, 
	"[*]": {"code": "[*]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 78, "state" : "up", "lastChecked": -1}, 
	"[/]": {"code": "[/]", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 79, "state" : "up", "lastChecked": -1}, 
	"enter": {"code": "enter", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 80, "state" : "up", "lastChecked": -1}, 
	"equals": {"code": "equals", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 81, "state" : "up", "lastChecked": -1}, 
	"clear": {"code": "clear", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 82, "state" : "up", "lastChecked": -1}, 
	"left shift": {"code": "left shift", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 83, "state" : "up", "lastChecked": -1}, 
	"right shift": {"code": "right shift", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 84, "state" : "up", "lastChecked": -1}, 
	"left ctrl": {"code": "left ctrl", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 85, "state" : "up", "lastChecked": -1}, 
	"right ctrl": {"code": "right ctrl", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 86, "state" : "up", "lastChecked": -1}, 
	"left alt": {"code": "left alt", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 87, "state" : "up", "lastChecked": -1}, 
	"right alt": {"code": "right alt", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 88, "state" : "up", "lastChecked": -1}, 
	"left cmd": {"code": "left cmd", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 89, "state" : "up", "lastChecked": -1}, 
	"right cmd": {"code": "right cmd", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 90, "state" : "up", "lastChecked": -1}, 
	"backspace": {"code": "backspace", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 91, "state" : "up", "lastChecked": -1}, 
	"tab": {"code": "tab", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 92, "state" : "up", "lastChecked": -1}, 
	"return": {"code": "return", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 93, "state" : "up", "lastChecked": -1}, 
	"escape": {"code": "escape", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 94, "state" : "up", "lastChecked": -1}, 
	"space": {"code": "space", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 95, "state" : "up", "lastChecked": -1}, 
	"delete": {"code": "delete", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 96, "state" : "up", "lastChecked": -1}, 
	"insert": {"code": "insert", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 97, "state" : "up", "lastChecked": -1}, 
	"home": {"code": "home", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 98, "state" : "up", "lastChecked": -1}, 
	"end": {"code": "end", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 99, "state" : "up", "lastChecked": -1}, 
	"page up": {"code": "page up", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 100, "state" : "up", "lastChecked": -1}, 
	"page down": {"code": "page down", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 101, "state" : "up", "lastChecked": -1}, 
	"mouse 0": {"code": "mouse 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 102, "state" : "up", "lastChecked": -1}, 
	"mouse 1": {"code": "mouse 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 103, "state" : "up", "lastChecked": -1}, 
	"mouse 2": {"code": "mouse 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 104, "state" : "up", "lastChecked": -1}, 
	"mouse 3": {"code": "mouse 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 105, "state" : "up", "lastChecked": -1}, 
	"mouse 4": {"code": "mouse 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 106, "state" : "up", "lastChecked": -1}, 
	"mouse 5": {"code": "mouse 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 107, "state" : "up", "lastChecked": -1}, 
	"mouse 6": {"code": "mouse 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 108, "state" : "up", "lastChecked": -1}, 
	"joystick button 0": {"code": "joystick button 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 109, "state" : "up", "lastChecked": -1}, 
	"joystick button 1": {"code": "joystick button 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 110, "state" : "up", "lastChecked": -1}, 
	"joystick button 2": {"code": "joystick button 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 111, "state" : "up", "lastChecked": -1}, 
	"joystick button 3": {"code": "joystick button 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 112, "state" : "up", "lastChecked": -1}, 
	"joystick button 4": {"code": "joystick button 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 113, "state" : "up", "lastChecked": -1}, 
	"joystick button 5": {"code": "joystick button 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 114, "state" : "up", "lastChecked": -1}, 
	"joystick button 6": {"code": "joystick button 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 115, "state" : "up", "lastChecked": -1}, 
	"joystick button 7": {"code": "joystick button 7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 116, "state" : "up", "lastChecked": -1}, 
	"joystick button 8": {"code": "joystick button 8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 117, "state" : "up", "lastChecked": -1}, 
	"joystick button 9": {"code": "joystick button 9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 118, "state" : "up", "lastChecked": -1}, 
	"joystick button 10": {"code": "joystick button 10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 119, "state" : "up", "lastChecked": -1}, 
	"joystick button 11": {"code": "joystick button 11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 120, "state" : "up", "lastChecked": -1}, 
	"joystick button 12": {"code": "joystick button 12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 121, "state" : "up", "lastChecked": -1}, 
	"joystick button 13": {"code": "joystick button 13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 122, "state" : "up", "lastChecked": -1}, 
	"joystick button 14": {"code": "joystick button 14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 123, "state" : "up", "lastChecked": -1}, 
	"joystick button 15": {"code": "joystick button 15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 124, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 0": {"code": "joystick 1 button 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 125, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 1": {"code": "joystick 1 button 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 126, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 2": {"code": "joystick 1 button 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 127, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 3": {"code": "joystick 1 button 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 128, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 4": {"code": "joystick 1 button 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 129, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 5": {"code": "joystick 1 button 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 130, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 6": {"code": "joystick 1 button 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 131, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 7": {"code": "joystick 1 button 7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 132, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 8": {"code": "joystick 1 button 8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 133, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 9": {"code": "joystick 1 button 9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 134, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 10": {"code": "joystick 1 button 10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 135, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 11": {"code": "joystick 1 button 11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 136, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 12": {"code": "joystick 1 button 12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 137, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 13": {"code": "joystick 1 button 13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 138, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 14": {"code": "joystick 1 button 14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 139, "state" : "up", "lastChecked": -1}, 
	"joystick 1 button 15": {"code": "joystick 1 button 15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 140, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 0": {"code": "joystick 2 button 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 141, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 1": {"code": "joystick 2 button 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 142, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 2": {"code": "joystick 2 button 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 143, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 3": {"code": "joystick 2 button 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 144, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 4": {"code": "joystick 2 button 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 145, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 5": {"code": "joystick 2 button 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 146, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 6": {"code": "joystick 2 button 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 147, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 7": {"code": "joystick 2 button 7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 148, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 8": {"code": "joystick 2 button 8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 149, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 9": {"code": "joystick 2 button 9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 150, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 10": {"code": "joystick 2 button 10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 151, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 11": {"code": "joystick 2 button 11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 152, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 12": {"code": "joystick 2 button 12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 153, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 13": {"code": "joystick 2 button 13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 154, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 14": {"code": "joystick 2 button 14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 155, "state" : "up", "lastChecked": -1}, 
	"joystick 2 button 15": {"code": "joystick 2 button 15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 156, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 0": {"code": "joystick 3 button 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 157, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 1": {"code": "joystick 3 button 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 158, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 2": {"code": "joystick 3 button 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 159, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 3": {"code": "joystick 3 button 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 160, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 4": {"code": "joystick 3 button 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 161, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 5": {"code": "joystick 3 button 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 162, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 6": {"code": "joystick 3 button 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 163, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 7": {"code": "joystick 3 button 7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 164, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 8": {"code": "joystick 3 button 8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 165, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 9": {"code": "joystick 3 button 9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 166, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 10": {"code": "joystick 3 button 10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 167, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 11": {"code": "joystick 3 button 11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 168, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 12": {"code": "joystick 3 button 12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 169, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 13": {"code": "joystick 3 button 13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 170, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 14": {"code": "joystick 3 button 14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 171, "state" : "up", "lastChecked": -1}, 
	"joystick 3 button 15": {"code": "joystick 3 button 15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 172, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 0": {"code": "joystick 4 button 0", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 173, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 1": {"code": "joystick 4 button 1", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 174, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 2": {"code": "joystick 4 button 2", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 175, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 3": {"code": "joystick 4 button 3", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 176, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 4": {"code": "joystick 4 button 4", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 177, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 5": {"code": "joystick 4 button 5", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 178, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 6": {"code": "joystick 4 button 6", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 179, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 7": {"code": "joystick 4 button 7", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 180, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 8": {"code": "joystick 4 button 8", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 181, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 9": {"code": "joystick 4 button 9", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 182, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 10": {"code": "joystick 4 button 10", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 183, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 11": {"code": "joystick 4 button 11", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 184, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 12": {"code": "joystick 4 button 12", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 185, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 13": {"code": "joystick 4 button 13", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 186, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 14": {"code": "joystick 4 button 14", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 187, "state" : "up", "lastChecked": -1}, 
	"joystick 4 button 15": {"code": "joystick 4 button 15", "lastPressed": -1, "lastReleased": -1, "wasDown": 0, "index": 188, "state" : "up", "lastChecked": -1}}

dsl.checkKeyState = function(k)

	if  dsl.keys[k].lastChecked == dsl.frameCount then 
		return dsl.keys[k].state
	end if

	dsl.keys[k].lastChecked = dsl.frameCount

	if key.pressed(k) then
		if dsl.keys[k].state == "up" or dsl.keys[k].state == "released" then
			dsl.keys[k].state = "pressed"
		else
			dsl.keys[k].state = "down"
		end if
	else
		if dsl.keys[k].state == "down" or dsl.keys[k].state == "pressed" then
			dsl.keys[k].state = "released"
		else
			dsl.keys[k].state = "up"
		end if
	end if

	return dsl.keys[k].state
end function

dsl.keyPressed = function(k)

	if key.keyNames.indexOf(k) == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: Key passed to 'dsl.keyPressed' does not exists. Key Passed: " + k
		end if

		return null
	end if

	cState = dsl.checkKeyState(k)
	return cState == "pressed"
end function

dsl.keyDown = function(k)

	if key.keyNames.indexOf(k) == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: Key passed to 'dsl.keyDown' does not exists. Key Passed: " + k
		end if

		return null
	end if

	cState = dsl.checkKeyState(k)
	return cState == "down"
end function

dsl.keyReleased = function(k)

	if key.keyNames.indexOf(k) == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: Key passed to 'dsl.keyReleased' does not exists. Key Passed: " + k
		end if

		return null
	end if

	cState = dsl.checkKeyState(k)
	return cState == "released"
end function

dsl.keyUp = function(k)

	if key.keyNames.indexOf(k) == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: Key passed to 'dsl.keyUp' does not exists. Key Passed: " + k
		end if

		return null
	end if

	cState = dsl.checkKeyState(k)
	return cState == "up"
end function

dsl.axis = function(k1, k2="")
	if not k1 isa string then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: First axis/key passed to 'dsl.axis' is not a string. Axis/Key Passed: " + k1
		end if

		return null
	end if

	if k2 != "" then
		if not k2 isa string then
			if globals.hasIndex("DSL_Log") then
				dsl.error "DSL: Second key passed to 'dsl.axis' is not a string. Key Passed: " + k2
			end if

			return null
		end if

		k1P = dsl.checkKeyState(k1)
		k2P = dsl.checkKeyState(k2)

		return (k2P == "down" or k2P == "pressed") - (k1P == "down" or k1P == "pressed")
	else
		return key.axis(k1)
	end if
end function
// Entity System

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.entt = {}

dsl.entt.update = function(list)
	toDelete = []

	for e in list
		if e.alive then
			if e.hasIndex("update") then
				e.update
			else
				if globals.hasIndex("DSL_Log") then
					dsl.error "DSL: The entity you are updating with dsl.entt.update does not contains an 'update' function. Make sure there is not a typo in the declaration."
				end if
			end if
		else
			toDelete.push e
		end if
	end for

	while toDelete.len > 0
		if toDelete[0].hasIndex("onDelete") then toDelete[0].onDelete

		list.removeVal toDelete[0]
		toDelete.removeVal toDelete[0]
	end while
end function

// Sprite animation system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.anim = {}

_anim = {}
_anim.frames = null
_anim.speed = 10
_anim.loop = true
_anim.done = false
_anim.time = 0
_anim.frame = 0

// this function assumes that the spriteSheet stores sprites horizontaly
dsl.anim.create = function(spriteSheet, width, speed=10, loop=true)
	l = globals.hasIndex("DSL_Log")

	if not spriteSheet isa Image then
		if l then
			dsl.error "DSL: The 'sprite sheet' supplied to dsl.anim.create is null or not an image."
			dsl.error "DSL: Make sure is loaded correctly. Passed sprite sheet value: " + spriteSheet
		end if

		return null
	end if

	if not width isa number then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'width' value: " + width
		end if

		return null
	else if width == 0 then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is 0. Only allowed possitive values greater than 0"
		end if
	end if

	if not speed isa number then
		if l then
			dsl.error "DSL: The 'speed' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'speed' value: " + speed
		end if

		return null
	end if

	a = new _anim
	a.speed = speed
	a.frames = []
	a.frame = 0
	a.done = false
	a.loop = loop

	height = spriteSheet.height
	amount = spriteSheet.width / width

	for i in range(0, amount-1)
		a.frames.push spriteSheet.getImage(width * i, 0, width, height)
	end for

	return a
end function

dsl.anim.createReverse = function(spriteSheet, width, speed=10, loop=true)
	l = globals.hasIndex("DSL_Log")

	if not spriteSheet isa Image then
		if l then
			dsl.error "DSL: The 'sprite sheet' supplied to dsl.anim.create is null or not an image."
			dsl.error "DSL: Make sure is loaded correctly. Passed sprite sheet value: " + spriteSheet
		end if

		return null
	end if

	if not width isa number then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'width' value: " + width
		end if

		return null
	else if width == 0 then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is 0. Only allowed possitive values greater than 0"
		end if
	end if

	if not speed isa number then
		if l then
			dsl.error "DSL: The 'speed' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'speed' value: " + speed
		end if

		return null
	end if

	a = new _anim
	a.speed = speed
	a.frames = []
	a.done = false
	a.loop = loop

	height = spriteSheet.height
	amount = spriteSheet.width / width

	for i in range(amount-1, 0, -1)
		a.frames.push spriteSheet.getImage(width * i, 0, width, height)
	end for

	return a
end function

dsl.anim.isDone = function(sprite)
	return sprite._currAnim.done
end function

dsl.anim.change = function(sprite, animation, frame=0)
	if sprite.hasIndex("_currAnim") then
		sprite._currAnim.frame = 0
		sprite._currAnim.time = 0
		sprite._currAnim.done = false

		sprite._currAnim = animation
		sprite._currAnim.done = false

		sprite._currAnim.frame = frame
		sprite._currAnim.time = 0
	else
		sprite._currAnim = animation

		sprite._currAnim.done = false

		sprite._currAnim.frame = frame
		sprite._currAnim.time = 0
	end if
end function

dsl.anim.animate = function(sprite)
	if sprite == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The sprite supplied to dsl.anim.animate is null, are you sure is not deleted?"
		end if
		return
	end if

	if sprite._currAnim == null or not sprite._currAnim isa _anim then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The animation supplied to dsl.anim.animate is null or not a valid animation."
		end if
		return
	end if


	if not sprite._currAnim.done or sprite._currAnim.loop then
		// TODO Remove dependency from `dsl`
		sprite._currAnim.time += dsl.dt

		frame = floor(sprite._currAnim.time * sprite._currAnim.speed % sprite._currAnim.frames.len)
		frame += sprite._currAnim.frame

		lastFrame = sprite._currAnim.frames.len-1

		if lastFrame - frame < 0 then
			currFrame = -1 + abs(lastFrame - frame)
		else
			currFrame = frame
		end if

		sprite.image = sprite._currAnim.frames[currFrame]
		
		sprite._currAnim.done = false
		if currFrame >= lastFrame and (not sprite._currAnim.loop) then
			sprite._currAnim.done = true
		end if	
	end if
end function
// Logging system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

logFile = "log.txt"
prevLogFile = "prev_log.txt"

recordStartup = function

	if file.exists(logFile) then
		if file.exists(prevLogFile) then file.delete(prevLogFile)
		file.copy logFile, prevLogFile
		file.delete logFile
	end if

	f = file.open(logFile, "a")
	f.write "DSL: Starting up..."
	f.close
end function

recordStartup

// DEPRECATED
dsl.log = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "WARNING - DSL: 'dsl.log' is deprecated, the new name is 'dsl.info'."
	f.write char(13) + "INFO at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.info = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "INFO at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.warn = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "WARNING at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.error = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "ERROR at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.fatal = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "FATAL at " + round(time, 3) + "s: " + msg
	f.close

	dsl.stop
end function
dsl.fsm = {}

dsl.state = {}
dsl.state.name = "default"
dsl.state.update = function(obj); end function
dsl.state.enter = function(prev, obj); end function
dsl.state.exit = function(prev, obj); end function
dsl.state.clone = function
	s = new self
	s.name = "" + self.name
	s.update = @self.update
	s.enter = @self.enter
	s.exit = @self.exit

	return s
end function

dsl.addFSM = function(obj)
	obj.state = null

	obj.addState = function(name)
		s = new dsl.state
		s.name = name
		self[name] = s
	end function

	obj.updateStates = function
		self[self.state].update self
	end function

	obj.changeState = function(next)
		if self.state == next then return
		
		if self.state != null then
			self[self.state].exit next, self
		end if

		prev = self.state
		self.state = next

		self[self.state].enter prev, self
	end function

	obj.inState = function(state)
		if state isa string then
			return self.state == state
		else if state isa list then
			onState = false

			for st in state
				if self.state == st then
					onState = true
					break
				end if 
			end for

			return onState
		else
			return false
		end if
	end function

	obj.clone = function
		clone = {} + self

		for name in self.indexes
			nan = not(self[name] isa number)
			nas = not(self[name] isa string)
			nal = not(self[name] isa list)

			if nan and nas and nal then
				if self[name] isa dsl.state then
					clone[name] = self[name].clone
				else
					if not clone.hasIndex(name) then
						clone[name] = self[name]
					end if
				end if
			else
				if not clone.hasIndex(name) then
					clone[name] = self[name]
				end if
			end if
		end for

		return clone
	end function
end function
