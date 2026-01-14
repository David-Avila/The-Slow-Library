// Finite State Machine
dsl.sm = {}

dsl.sm.state = {}
dsl.sm.state.enter = function(prevState = null); end function
dsl.sm.state.update = function; end function
dsl.sm.state.exit = function(nextState); end function

dsl.newState = function
	s = new dsl.sm.state
	return s
end function

dsl.sm.change = function(newState)
	if newState != null then
		self.state.exit newState
		self.state = newState
		self.state.enter newState
	else if globals.hasIndex("DSL_Log") then
		dsl.error "DSL: Tryed to change to a null state: State passed: " + newState
	end if
end function

dsl.sm.update = function
	l = globals.hasIndex("DSL_Log")

	if self.state != null then
		if self.state.hasIndex("update") then
			self.state.update
		else if l then
			dsl.error "DSL: Current state doesn't has an update function, did you created it with dsl.newState?"
		end if
	else if l then
		dsl.error "DSL: Current state is not a valid state, it is: " + self.state 
	end if
end function