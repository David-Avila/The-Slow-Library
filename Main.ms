import "DSL"

while dsl.running
	dsl.update

	if dsl.keyPressed("escape") then
		dsl.stop
	end if
	
	yield
end while