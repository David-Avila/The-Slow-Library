// Finite State Machine

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.State = {}
dsl.State.enter = function(prev, obj); end function
dsl.State.update = function(obj); end function
dsl.State.exit = function(next, obj); end function

dsl.newState = function(name)
	s = new dsl.State
	s.name = name
	return s
end function

dsl.newStateMachine = function(owner)
	sm = new dsl.StateMachine
	return sm.init(owner)
end function

dsl.StateMachine = {}
dsl.StateMachine.owner = null
dsl.StateMachine.state = null
dsl.StateMachine.states = {}

dsl.StateMachine.init = function(owner)
	self.owner = owner
	self.states = {}
	self.state = null
	return self
end function

dsl.StateMachine.addState = function(states)
	if states isa map then
		s = {} + states
		self.states[s.name] = s

		if self.state == null then self.state = s
	else if states isa list then
		for state in states
			s = {} + state
			self.states[s.name] = s

			if self.state == null then self.state = s
		end for
	end if
end function

dsl.StateMachine.change = function(next)
	if next isa string then
		newState = self.states[next]
	else
		newState = self.states[next.name]
	end if

	if newState != null then
		self.state.exit newState, self.owner
		prev = self.state
		self.state = newState
		self.state.enter prev, self.owner
	else if globals.hasIndex("DSL_Log") then
		dsl.error "DSL: Tryed to change to a null state: State passed: " + newState
	end if
end function

dsl.StateMachine.update = function
	l = globals.hasIndex("DSL_Log")

	if self.state != null then
		if self.state.hasIndex("update") then
			self.state.update self.owner
		else if l then
			dsl.error "DSL: Current state doesn't has an update function, did you created it with dsl.newState?"
		end if
	else if l then
		dsl.error "DSL: Current state is not a valid state, it is: " + self.state 
	end if
end function