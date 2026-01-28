# The Slow Library (DSL)
This is a small personal library that I'm creating to speed up development of games during a game jam. It is meant to
be a collection of functions and system, that help getting started with new projects. It is NOT meant to take control
of the game loop, rendering nor any other important part of the development process.

You can use the complete library or just the file you want. Import `DSL` or any of the following modules.

```
import "DSL_Log"
import "DSL_Animations"
import "DSL_Input"
import "DSL_FSM"
import "DSL_Display"
import "DSL_Debug" // WIP
import "DSL_Entity"
```

# Game loop
DSL offers handy functions to avoid boilerplate, but gives you the freedom to choose how you manage the main loop.

You have access to several properties, `dt`, `frameCount`, `lastTime`, `fps`. 

All of which can be acces with `dsl.PROPERTY`

**Sample Gameloop**
```
import "DSL"

dsl.loop = function
	// Override this function to update your game and
	// add gameplay functionality
end funtion

while dsl.running
	dsl.update

	// If you don't use the `dsl.loop` function, you can 
	// add your code here and still take advantage of the 
	// library's systems

	yield
end while
```

# Helper functions
By importing `DSL` you have access to a couple of functions to save time.

Use this functions to recursively find assets starting from the folder name you pass
NOTE: PATH should be relative path, NOT absolute

```
dsl.importImages PATH
dsl.importSounds PATH
```

If you don't provide a path, the functions will start scanning at the root of the project.

After using any of this functions, you can access the loaded assets through `dsl.images` or `dsl.sounds` 
depending on the function you called.

**IMPORTANT RULE**: There should be only one file with the same name and extension across all project folders. If there
are more than one file, i.e two files called `player.png`, then the last file found will be the one that is saved to `dsl.images` or `dsl.sounds`. Spaces and dashes on file names will be replaced by a `_`.

For instance:
A file called `player idle.png` or `player-idle.png` will be stored as `player_idle`, and can be accessed with `dsl.images.player_idle`. That also applies to sound effects and music.

# Animation System
`DSL` counts with a small yet solid animation system. With these functions you can create an animate any sprite.

```
// This function returns an animation that you can use with `dsl.anim.animate`
dsl.anim.create(spriteSheetImage, individualFrameWidth, animationSpeed)

// animationSpeed's default value is 10

dsl.anim.change sprite, animation

dsl.anim.animate spriteToAnimate
```

Check the next example to see how it works.

```
player = new Sprite
player.idleAnimation = dsl.anim.create(dsl.images.player_idle_sheet, 16)

player.update = function
	dsl.anim.animate self, self.idleAnimation
end function

```

# Input system
DSL's input system exposes 5 functions:

Each of these functions returns `true` or `false`.
```
dsl.keyPressed(key)
dsl.keyReleased(key)
dsl.keyDown(key)
dsl.keyUp(key)
```

This function returns a range between `-1` and `1`:

```
dsl.axis(axis)
dsl.axis(leftKey, rightKey)
```

**Axis available are**:

Joystick, WASD and arrow keys:
`Horizontal`, `Vertical`

Mouse:
`Mouse X`, `Mouse Y`

Joysticks only:
`JoyAxis1` through `JoyAxis29` which detect axis input from any joystick or gamepad
`Joy1Axis1` through `Joy8Axis29` which detect axis inputs from specific joystick/gamepad 1 through 8.


**TODO**: Assert the key passed to each function to avoid crashes when the key is not found

# Logging functions
Use these functions to log important messages to `log.txt`.

```
dsl.log "Player spawned correctly"

// `dsl.log` is deprecated, the new name is `dsl.info`
// this change was made to keep a consistent naming
// of the different logging levels

dsl.info "Player spawned correctly"

dsl.warn "Something is not working"

dsl.error "There is definitly something wrong here"

dsl.fatal "Big error, aborting"
```

View those logs using `view "log.txt"` in Mini Micro, or your favorite text editor.

**NOTE**: The logging system overrides `prev_log.txt` with the content of `log.txt` and then replaces `log.txt` with the new logs, if you want to keep logs from previous runs use `file.copy "log.txt", "old_log.txt"` before running again. You can use any name you want for old logs, that's up to you.


# Finite State Machine
**Documentation will be added soon**

For now, this is an example of how it's used:
```
import "DSL"

Base = new Sprite
Base.image = file.loadImage("/sys/pics/Wumpus.png")
Base.x = 480; Base.y = 320

dsl.addFSM Base

Base.addState "idle"
Base.addState "walk"

Base.idle.update = function(obj)
	if dsl.keyPressed("c") then
		obj.changeState "walk"
	end if
end function

Base.walk.update = function(obj)
	if dsl.keyPressed("c") then
		obj.changeState "idle"
	end if
end function

Base.update = function
	self.updateStates
end function

ins = Base.clone
ins.idle.enter = function(prev, obj)
	print "Entering idle state on instance"
end function

ins.walk.enter = function(prev, obj)
	print "Entering walk state on instance"
end function

SPD.add ins

while dsl.running
	dsl.update

	if dsl.keyPressed("escape") then
		dsl.stop
	end if

	ins.update

	yield
end while

SPD.remove ins
```


# Entity Functions
One function that you can use to handle basic entities.

```
dsl.entt.update entityList
```
This function will loop through the list, update all entities inside it and check if the variable `alive` is `true`, if it's false then that entity will be removed from the list. Optionally, if the entity has a function called `onDelete`, it will be called, so you can specify the exact behaviour an entity should have when deleted.
