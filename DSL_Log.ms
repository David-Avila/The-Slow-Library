// Logging system

logFile = "log.txt"
prevLogFile = "prev_log.txt"

recordStartup = function
	content = []

	if file.exists(logFile) then
		if file.exists(prevLogFile) then file.delete(prevLogFile)
		file.copy logFile, prevLogFile
	end if

	content.push "Starting up..."

	file.writeLines logFile, content
end function

recordStartup

dsl.log = function(msg)
	content = file.readLines(logFile)

	content.push "INFO at frame #" + dsl.frameCount + ": " + msg

	file.writeLines logFile, content
end function

dsl.warn = function(msg)
	content = file.readLines(logFile)

	content.push "WARNING at frame #" + dsl.frameCount + ": " + msg

	file.writeLines logFile, content
end function

dsl.error = function(msg)
	content = file.readLines(logFile)

	content.push "ERROR at frame #" + dsl.frameCount + ": " + msg

	file.writeLines logFile, content
end function

dsl.fatal = function(msg)
	content = file.readLines(logFile)

	content.push ("FATAL at frame #" + dsl.frameCount + ": " + msg).upper

	file.writeLines logFile, content
end function