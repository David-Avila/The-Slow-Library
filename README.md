# The Slow Library (DSL)
This is a small personal library that I'm creating to speed up development of games during a game jam. It is meant to
be a collection of functions and system, that help getting started with new projects. It is NOT meant to take control
of the game loop, rendering nor any other important part of the development process.

**New Method**:

To use this library, just go to [Releases](https://github.com/David-Avila/The-Slow-Library/releases) and download the `DSL_Lib.ms`, import it in your code with `import "DSL_Lib"` and you're ready to go.

# Game loop
DSL offers handy functions to avoid boilerplate, but gives you the freedom to choose how you manage the main loop.

You have access to several properties, `dt`, `frameCount`, `lastTime`, `fps`, `timeScale`, `version`.

All of which can be acces with `dsl.PROPERTY`

`dsl.version` is the version of the library you imported, use it if you need to support more than one version of DSL.

**Sample Gameloop**
```
import "DSL_Lib"

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
By importing `DSL_Lib` you have access to a couple of functions to save time.

Use this functions to recursively find assets starting from the folder name you pass. If you don't supply any argument, the library will load all images stored under `/usr`.

For relative path, just put the name of the folder you want to start with, i.e `assets` or `./assets` or even `assets/sprites`, `./assets/sprites`. For absolute path use `/usr/assets`, you can also load the built in images by passing `/sys/pics`. It also applys to `dsl.importSounds`

```
dsl.importImages PATH
dsl.importSounds PATH
```

After using any of this functions, you can access the loaded assets through `dsl.images` or `dsl.sounds` depending on the function you called. For images, it will look for `.png` files, and for sounds both `.wav` and `.ogg` work.

**IMPORTANT RULE**: There should be only one file with the same name and extension across all project folders. If there
are more than one file, i.e two files called `player.png`, then the last file found will be the one that is saved to `dsl.images` or `dsl.sounds`. Spaces and dashes on file names will be replaced by a `_`.

For instance:
A file called `player idle.png` or `player-idle.png` will be stored as `player_idle`, and can be accessed with `dsl.images.player_idle`. That also applies to sound effects and music.

`dsl.importPath` does the same for your code instead of your assets, adding folders to `env.importPaths` so Mini Micro knows where to look for your files. It adds the folder you pass and every folder inside it, recursively.

```
dsl.importPath PATH
```

For instance, to load `/scripts/misc/common/lib.ms` you would normally have to add `/scripts/misc/common` to `env.importPaths` by hand, otherwise Mini Micro won't find the file. This function lets you split a project into as many nested folders as you need without worrying about where Mini Micro searches for them.

Called without an argument it uses your project folder, which is the most common use:
```
dsl.importPath
```

Relative paths work like they do for `dsl.importImages`, so you can pass a folder name, a relative path or an absolute one, and folders that are already in `env.importPaths` are skipped.

# Animation System
`DSL` counts with a small yet solid animation system. With these functions you can create an animate any sprite.

```
// This function returns an animation that you can use with `dsl.anim.animate`
dsl.anim.create(spriteSheetImage, individualFrameWidth, animationSpeed, loop)
dsl.anim.createReverse(spriteSheetImage, individualFrameWidth, animationSpeed, loop)

// animationSpeed's default value is 10

dsl.anim.change sprite, animation

dsl.anim.animate spriteToAnimate
```

Check the next example to see how it works.

```
player = new Sprite
player.idleAnimation = dsl.anim.create(dsl.images.player_idle_sheet, 16)

dsl.anim.change player, player.idleAnimation

player.update = function
	dsl.anim.animate self, self.idleAnimation
end function

```

**IMPORTANT RULE**:

When using animations on a base class (a class that is going to be instantiated with `new`), all animations need to be loaded inside of a function. See the next example:

```
base = new Sprite
base.init = function
	self.idle = dsl.anim.create(dsl.images.player_idle, 16)

	dsl.anim.change self, self.idle
end function

base.update = function
	dsl.anim.animate self
end function
```

That is the correct way, otherwise the same animation is going to be use for multiple sprites at the same time, which will result in all sprites having the same animation playing at the same time.

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
`dsl.addFSM` turns any object into a state machine. States are added with `addState` and each one has its own `update`, `enter` and `exit` functions. `changeState` moves from one state to the next and `updateStates` runs the `update` of the state you are currently on.

```
dsl.addFSM player // 'player' can be any type of map, custom, empty, sprite...

player.addState "idle"
player.addState "walk"

player.idle.update = function(obj)
  // Inside of a state, 'self' corresponds to the state map itself.
  // The argument passed to you, in this case 'obj', corresponds to the object
  // that has the state machine, in this case the 'player' object
	if dsl.keyPressed("c") then obj.changeState "walk"
end function

// `prev` is the state we are coming from
player.idle.enter = function(prev, obj); end function

// `next` is the state we are going to
player.walk.exit = function(next, obj); end function

player.update = function
	self.updateStates
end function

player.inState "walk"		// true while on the "walk" state
```

`changeState` runs `exit` on the state you are leaving and then `enter` on the one you are entering, so anything that should only happen once per transition belongs there instead of in `update`. `inState` also takes a list of names, like `obj.inState ["walk", "idle"]`, and `player.clone` copies a whole state machine, giving the copy its own independent states.

# Locked States
States can be locked. A locked state can still be entered, but it can't be changed to another state, which is useful for states the player shouldn't be able to skip out of, like a game over or a dialogue scene.

`addState` takes a second parameter that marks the new state as locked, it defaults to `false`:
```
Base.addState "idle"
Base.addState "walk"
Base.addState "gameOver", true
```

While the entity is on a locked state, every call to `changeState` is ignored: `exit` is not called and the state stays the same. Set `locked` back to `false` to allow changes again:
```
Base.changeState "idle"    // ignored, "gameOver" is locked
Base.gameOver.locked = false
Base.changeState "idle"    // now it changes
```

Every state also has a `locked` property you can read and write at any time, and it's kept when cloning a state or a whole FSM.

**NOTE**: `inState` and `updateStates` still work as usual while a state is locked, only changing to a different state is blocked.


# Save System
DSL can write any value to a file as json, so you don't need to build your own save format. The data is XOR encrypted with a key and saved with a `DSLv1:` head marker, which is checked when loading so a file that isn't one of ours gets rejected instead of loading garbage.

```
dsl.saveData path, data, encKey
dsl.loadData path, encKey
```

`encKey` defaults to `"dsl-save-key"`, and since it's an argument you can change it per file if you want:

```
dsl.saveData "player.dsf", game.data
dsl.saveData "settings.dsf", settings, "a different key"

game.data = dsl.loadData "player.dsf"
settings = dsl.loadData "settings.dsf", "a different key"
```

`saveData` writes the file and `loadData` returns the data that was stored, or `null` when it couldn't be read. On a first run the file won't exist yet, so check the result before using it and fill in your defaults:

```
game.data = dsl.loadData "player.dsf"

if game.data == null then
	game.data = {coins: 0, level: 1}
	dsl.saveData "player.dsf", game.data
end if
```

The path can be any file you can reach, so `"data.dsf"`, `"saves/player.dsf"` or an absolute `"/usr/saves/player.dsf"` all work. Nothing is created for you, the folder has to be there already.

**NOTE**: `encKey` has to be the same string on save and load. If you change it, the old files can't be read anymore.

You can also do the encryption on its own, without touching the filesystem:

```
text = dsl.encrypt(data, encKey)
data = dsl.decrypt(text, encKey)
```

`encrypt` returns the encrypted string, and `decrypt` takes it back to the original value. `saveData` and `loadData` are just these two plus `file.open`, so if you need to store the result somewhere else, like in Mini Cloud, use these.

**IMPORTANT RULE**: this is obfuscation, not real security. The key is inside your game, so anyone who looks at your code can read the data back. It stops a save from being casually edited, which is usually what you want, but it will not stop someone who is determined.

Only numbers, strings, lists and maps survive the round trip, because those are what json can write. Anything else (sprites, images, functions) has no json representation, so `encrypt` returns `null` for it instead of writing a broken file. Custom objects work fine as long as the values you store inside them are one of those four types.

Map keys should be strings. `dsl.decrypt` returns `null` if the text was changed by hand or the key is wrong, so check for `null` after loading rather than assuming it worked.

# Entity Functions
One function that you can use to handle basic entities.

```
dsl.entt.update entityList
```
This function will loop through the list, update all entities inside it and check if the variable `alive` is `true`, if it's false then that entity will be removed from the list. Optionally, if the entity has a function called `onDelete`, it will be called, so you can specify the exact behaviour an entity should have when deleted.
