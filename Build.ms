import "DSL"

print "Starting build."
now = time
dsl.build
print "Library built in " + round(time - now, 3) + "s"