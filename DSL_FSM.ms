dsl.fsm = {}

dsl.state = {}
dsl.state.name = "default"
dsl.state.update = function(obj); end function
dsl.state.enter = function(prev, obj); end function
dsl.state.exit = function(prev, obj); end function
dsl.state.clone = function
	s = new self
	s.name = "" + self.name
	s.update = @self.update
	s.enter = @self.enter
	s.exit = @self.exit

	return s
end function

dsl.addFSM = function(obj)
	obj.state = null

	obj.addState = function(name)
		s = new dsl.state
		s.name = name
		self[name] = s

		if self.state == null then self.state = name
	end function

	obj.updateStates = function
		self[self.state].update self
	end function

	obj.changeState = function(next)
		if self.state != null then
			self[self.state].exit next, self
		end if

		prev = self.state
		self.state = next

		self[self.state].enter prev, self
	end function

	obj.clone = function
		clone = {} + self

		for name in self.indexes
			nan = not(self[name] isa number)
			nas = not(self[name] isa string)
			nal = not(self[name] isa list)

			if nan and nas and nal then
				if self[name] isa dsl.state then
					clone[name] = self[name].clone
				else
					if not clone.hasIndex(name) then
						clone[name] = self[name]
					end if
				end if
			else
				if not clone.hasIndex(name) then
					clone[name] = self[name]
				end if
			end if
		end for

		return clone
	end function
end function
