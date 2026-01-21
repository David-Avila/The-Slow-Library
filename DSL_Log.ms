// Logging system

if not globals.hasIndex("dsl") then
	globals.dsl = {}
end if

logFile = "log.txt"
prevLogFile = "prev_log.txt"

recordStartup = function

	if file.exists(logFile) then
		if file.exists(prevLogFile) then file.delete(prevLogFile)
		file.copy logFile, prevLogFile
		file.delete logFile
	end if

	f = file.open(logFile, "a")
	f.write "DSL: Starting up..."
	f.close
end function

recordStartup

// DEPRECATED
dsl.log = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "WARNING - DSL: 'dsl.log' is deprecated, the new name is 'dsl.info'."
	f.write char(13) + "INFO at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.info = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "INFO at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.warn = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "WARNING at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.error = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "ERROR at " + round(time, 3) + "s: " + msg
	f.close
end function

dsl.fatal = function(msg)
	f = file.open(logFile, "a")
	f.write char(13) + "FATAL at " + round(time, 3) + "s: " + msg
	f.close

	dsl.stop
end function