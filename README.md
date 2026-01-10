# The Slow Library (DSL)
This is a small personal library that I'm creating to speed up development of games during a game jam. It is meant to
be a collection of functions and system, that help getting started with new projects. It is NOT meant to take control
of the game loop, rendering nor any other important part of the development process.

You can use the complete library or just the file you want. 

**NOTES FOR SINGLE FILE USE**:
If you don't use the library by importing `DSL.ms` and just want to use one of the modules, make sure to declare
the variable `dsl` as global:

```
globals.dsl = {}

// then you can import any of the stand alone files
import "DSL_Log"
import "DSL_Animations"
import "DSL_Input"
import "DSL_Entity"
import "DSL_Display"
import "DSL_Debug" // WIP
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
`DSL` counts with a small yet solid animation system. With just two functions you can create an animate any sprite.

```
// This function returns an animation that you can use with `dsl.anim.animate`
dsl.anim.create(spriteSheetImage, individualFrameWidth, animationSpeed)

// animationSpeed's default value is 10

dsl.anim.animate spriteToAnimate, animation
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

dsl.warn "Something is not working"

dsl.error "There is definitly something wrong here"

dsl.fatal "Big error, aborting"
```

View those logs using `view "log.txt"` in Mini Micro, or your favorite text editor. A copy of the previous log is saved to `prev_log.txt` before replacing the `log.txt` file.

**NOTE**: The logging system overrides previus `log.txt` files, if you want to keep logs from previous runs
use `file.copy "log.txt", "old_log.txt"` before running again. You can use any name you want for old logs, that's
up to you.
