// Sprite animation system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

dsl.anim = {}

_anim = {}
_anim.frames = null
_anim.speed = 10
_anim.frame = 0

// this function assumes that the spriteSheet stores sprites horizontaly
dsl.anim.create = function(spriteSheet, width, speed=10)
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

	height = spriteSheet.height
	amount = spriteSheet.width / width

	for i in range(0, amount-1)
		a.frames.push spriteSheet.getImage(width * i, 0, width, height)
	end for

	return a
end function

dsl.anim.animate = function(sprite, animation)
	if sprite == null then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The sprite supplied to dsl.anim.animate is null, are you sure is not deleted?"
		end if
		return
	end if

	if animation == null or not animation isa _anim then
		if globals.hasIndex("DSL_Log") then
			dsl.error "DSL: The animation supplied to dsl.anim.animate is null or not a valid animation."
		end if
		return
	end if

	sprite.image = animation.frames[time * animation.speed % animation.frames.len]
end function