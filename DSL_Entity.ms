// Entity System
import "listUtil"

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
