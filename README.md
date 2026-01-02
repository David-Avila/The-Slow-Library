# The Slow Library (DSL)
This is a small personal library that I'm creating to speed up development of games during a game jam.

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