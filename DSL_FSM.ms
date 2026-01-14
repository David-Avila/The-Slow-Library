// Finite State Machine
dsl.sm = {}

dsl.sm.state = {}
dsl.sm.state.enter = function(prevState = null); end function
dsl.sm.state.update = function; end function
dsl.sm.state.exit = function(nextState); end function

dsl.sm.change = function(newState)
	if newState != null then
		self.state.exit newState
		self.state = newState
		self.state.enter newState
	else if 
	end if
end function

dsl.sm.update = function
	if self.state != null then
		self.state.update
	end if
end function