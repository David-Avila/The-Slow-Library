// Entity System
import "listUtil"

dsl.entt = {}

dsl.entt.update = function(list)
	toDelete = []

	for e in list
		if e.alive then
			if e.hasIndex("update") then
				e.update dsl.dt
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
