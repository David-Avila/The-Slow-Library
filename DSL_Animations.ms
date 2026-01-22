// Sprite animation system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.anim = {}

_anim = {}
_anim.frames = null
_anim.speed = 10
_anim.loop = true
_anim.done = false
_anim.time = 0
_anim.frame = 0

// this function assumes that the spriteSheet stores sprites horizontaly
dsl.anim.create = function(spriteSheet, width, speed=10, loop=true)
	l = globals.hasIndex("DSL_Log")

	if not spriteSheet isa Image then
		if l then
			dsl.error "DSL: The 'sprite sheet' supplied to dsl.anim.create is null or not an image."
			dsl.error "DSL: Make sure is loaded correctly. Passed sprite sheet value: " + spriteSheet
		end if

		return null
	end if

	if not width isa number then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'width' value: " + width
		end if

		return null
	else if width == 0 then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is 0. Only allowed possitive values greater than 0"
		end if
	end if

	if not speed isa number then
		if l then
			dsl.error "DSL: The 'speed' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'speed' value: " + speed
		end if

		return null
	end if

	a = new _anim
	a.speed = speed
	a.frames = []
	a.frame = 0
	a.done = false
	a.loop = loop

	height = spriteSheet.height
	amount = spriteSheet.width / width

	for i in range(0, amount-1)
		a.frames.push spriteSheet.getImage(width * i, 0, width, height)
	end for

	return a
end function

dsl.anim.createReverse = function(spriteSheet, width, speed=10, loop=true)
	l = globals.hasIndex("DSL_Log")

	if not spriteSheet isa Image then
		if l then
			dsl.error "DSL: The 'sprite sheet' supplied to dsl.anim.create is null or not an image."
			dsl.error "DSL: Make sure is loaded correctly. Passed sprite sheet value: " + spriteSheet
		end if

		return null
	end if

	if not width isa number then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'width' value: " + width
		end if

		return null
	else if width == 0 then
		if l then
			dsl.error "DSL: The 'width' supplied to dsl.anim.create is 0. Only allowed possitive values greater than 0"
		end if
	end if

	if not speed isa number then
		if l then
			dsl.error "DSL: The 'speed' supplied to dsl.anim.create is null or not an number."
			dsl.error "DSL: Passed 'speed' value: " + speed
		end if

		return null
	end if

	a = new _anim
	a.speed = speed
	a.frames = []
	a.done = false
	a.loop = loop

	height = spriteSheet.height
	amount = spriteSheet.width / width

	for i in range(amount-1, 0, -1)
		a.frames.push spriteSheet.getImage(width * i, 0, width, height)
	end for

	return a
end function

dsl.anim.isDone = function(sprite)
	return sprite._currAnim.done
end function

dsl.anim.change = function(sprite, animation, frame=0)
	if sprite.hasIndex("_currAnim") then
		sprite._currAnim.frame = 0
		sprite._currAnim.time = 0
		sprite._currAnim.done = false

		sprite._currAnim = animation
		sprite._currAnim.done = false

		sprite._currAnim.frame = frame
		sprite._currAnim.time = 0
	else
		sprite._currAnim = animation

		sprite._currAnim.done = false

		sprite._currAnim.frame = frame
		sprite._currAnim.time = 0
	end if
end function

dsl.anim.animate = function(sprite)
	if sprite == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The sprite supplied to dsl.anim.animate is null, are you sure is not deleted?"
		end if
		return
	end if

	if sprite._currAnim == null or not sprite._currAnim isa _anim then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The animation supplied to dsl.anim.animate is null or not a valid animation."
		end if
		return
	end if


	if not sprite._currAnim.done then
		// TODO Remove dependency from `dsl`
		sprite._currAnim.time += dsl.dt

		frame = floor(sprite._currAnim.time * sprite._currAnim.speed % sprite._currAnim.frames.len)
		frame += sprite._currAnim.frame

		lastFrame = sprite._currAnim.frames.len-1

		if lastFrame - frame < 0 then
			currFrame = -1 + abs(lastFrame - frame)
		else
			currFrame = frame
		end if

		sprite.image = sprite._currAnim.frames[currFrame]
		
		if currFrame >= lastFrame and (not sprite._currAnim.loop) then
			sprite._currAnim.done = true
		end if	
	end if
end function