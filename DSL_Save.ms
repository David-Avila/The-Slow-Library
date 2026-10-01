import "json"

// Save data encryption
// Simple XOR over the json text with a fixed key, plus a head marker so we can
// tell our own files apart. This only stops casual editing of a save file, it
// is not real security: the key ships with the game.

dsl._saveHead = "DSLv1:"

dsl.saveData = function(path, data, encKey="dsl-save-key")
	if path == null then
		dsl.error "DSL: Trying to save data, but the path passed is null"
		return
	end if
	
	if data == null then
		dsl.error "DSL: Trying to save data, but the data passed is null"
		return
	end if
	
	f = file.open(path, "w+")
	f.write dsl.encrypt(data, encKey)
	f.close
end function

dsl.loadData = function(path, encKey="dsl-save-key")
	if path == null then
		dsl.error "DSL: Trying to save data, but the path passed is null"
		return
	end if
	
	if not file.exists(path) then
		dsl.error "DSL: Trying to load from a file that doesn't exists"
		return		
	end if
	
	f = file.open(path, "r")
	raw = f.read
	f.close
	
	if raw.startsWith(dsl._saveHead) then
		return dsl.decrypt(raw, encKey)
	else
		dsl.error "DSL: Save file is corrupted, save head is unknown."
	end if
end function


// Turn any value into a string that is safe to write to a file.
// Returns the text, or null if the key or the value cannot be used.
dsl.encrypt = function(data, encKey="dsl-save-key")
	if not encKey isa string or encKey.len == 0 then
		dsl.error "'dsl.encrypt' needs a non empty string as key."
		return null
	end if
	
	text = json.toJSON(data)
	if not text isa string then
		dsl.error "'dsl.encrypt' can only store values json can write."
		return null
	end if
	
	return dsl._saveHead + dsl._xor(text, encKey)
end function

// Undo dsl.encrypt. Returns null when the text is not one of ours or the key
// is wrong, so a bad file never loads garbage.
dsl.decrypt = function(text, encKey="dsl-save-key")
	if not encKey isa string or encKey.len == 0 then
		dsl.error "'dsl.decrypt' needs a non empty string as key."
		return null
	end if
	
	if not text isa string then
		dsl.error "'dsl.decrypt' needs text, not " + text + "."
		return null
	end if
	
	if text.indexOf(dsl._saveHead) != 0 then
		dsl.error "'dsl.decrypt' got a file that was not written by 'dsl.encrypt'."
		return null
	end if
	
	data = json.parse(dsl._unxor(text[dsl._saveHead.len:], encKey))
	
	if not data isa map and not data isa list then
		dsl.error "'dsl.decrypt' failed, the key is wrong or the file was changed."
		return null
	end if
	
	return data
end function

dsl._xor = function(text, encKey)
	out = ""
	i = 0
	for c in text
		v = code(c) + code(encKey[i % encKey.len])
		out += char(v % 256 + 256)
		i += 1
	end for
	return out
end function

dsl._unxor = function(text, encKey)
	out = ""
	i = 0
	for c in text
		v = code(c) - 256 - code(encKey[i % encKey.len])
		while v < 0
			v += 256
		end while
		out += char(v)
		i += 1
	end for
	return out
end function
