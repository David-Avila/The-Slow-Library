// List Utils

// Return this vector minus another.
list.minus = function(other)
	return [self[0] - other[0], self[1] - other[1]]
end function

// Return this vector plus another.
list.plus = function(other)
	return [self[0] + other[0], self[1] + other[1]]
end function

// Return this vector times another.
list.times = function(other)
	return [self[0] * other[0], self[1] * other[1]]
end function

// Return the magnitude (length) of this vector.
list.magnitude = function
	return sqrt(self[0]^2 + self[1]^2)
end function

// Return the squared magnitude (length) of this vector.
// (More efficient than list.magnitude.)
list.sqrMagnitude = function
	return self[0]^2 + self[1]^2
end function

// Scale this vector in place so that its length is 1 (if possible).
list.normalize = function
	m = sqrt(self[0]^2 + self[1]^2)
	if m != 0 then
		self[0] /= m
		self[1] /= m
	end if
end function

// Return a (new) normalized version of this vector
list.normalized = function
	m = sqrt(self[0]^2 + self[1]^2)
	if m != 0 then return [self[0] / m, self[1] / m]
	return self[:2]
end function

list.distanceTo = function(other)
	dx = other[0] - self[0]
	dy = other[1] - self[1]
	return sqrt(dx * dx + dy * dy)
end function

// Dot product
list.dot = function(other)
	return self[0] * other[0] + self[1] * other[1]
end function

list.angleTo = function(other)
	return atan((other[1] - self[1]), (other[0] - self[0])) * rad2deg 
end function

// Rotates the [x,y] a certain amount of degrees counter-clockwise
// i.e: [1, 0].rotate 90 = [0, 1]
list.rotate = function(angle)
	cosA = cos(angle * deg2rad)
	sinA = sin(angle * deg2rad)
	
	x = self[0] * cosA - self[1] * sinA
	y = self[0] * sinA + self[1] * cosA
	
	// Rounded 5 decimal values to make the result more clear
	self[0] = round(x, 5)
	self[1] = round(y, 5)
end function

// Function to make an [x,y] list out of a map (or another such list).
// Example usage: xyList(mouse)  -->   [103, 514]
globals.xyList = function(listOrMap)
	if listOrMap isa list then return listOrMap[0:2]
	return [listOrMap.x, listOrMap.y]
end function