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