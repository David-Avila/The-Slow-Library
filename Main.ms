import "DSL_Lib"

while dsl.running

	if dsl.keyPressed("escape") then
		dsl.stop
	end if

	yield
end while
