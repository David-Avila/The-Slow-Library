# The Slow Library (DSL)
This is a small personal library that I'm creating to speed up development of games during a game jam.

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
dsl.importImages(PATH)
dsl.importSounds(PATH)
```

If you don't provide a path, the functions will start scanning at the root of the project.

After using any of this functions, you can access the loaded assets through `dsl.images` or `dsl.sounds` 
depending on the function you called.

# Animation System
`DSL` counts with a small yet solid animation system. With just two functions you can create an animate any sprite.

```
// This function returns an animation that you can use with `dsl.anim.animate`
dsl.anim.create(spriteSheetImage, individualFrameWidth, animationSpeed)

// animationSpeed's default value is 10

dsl.anim.animate(spriteToAnimate, animation)
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
DSL's input system exposes 4 functions:

```
dsl.keyPressed(key)
dsl.keyReleased(key)
dsl.keyDown(key)
dsl.keyUp(key)
```

Each function returns `true` or `false`.

**TODO**: Assert the key passed to each function to avoid crashes when the key is not found

# Logging functions
Use this functions to log important messages to `log.txt`.

```
dsl.log "Player spawned correctly"

dsl.warn "Something is not working"

dsl.error "There is definitly something wrong here"

dsl.fatal "Big error, aborting"
```

**NOTE**: The logging system overrides previus `log.txt` files, if you want to keep logs from previous runs
use `file.copy "log.txt" "old_log.txt"` before running again. You can use any name you want for old logs, that's
up to you