extends Node

# after how many log messages the logger will flush memory,
# close file, and reopen
const FLUSH_EVERY: float = 100
# max number of log files. If 10 already exist it will overwrite the latest one
const LOGFILE_AMOUNT: int = 10
# By default log files will be stored (for windows) in:
# C:\Users\<User>\AppData\Roaming\Godot\app_userdata\<ProjectName>\logs
# Alter here to change
const LOGFILE_PATH: String = "user://logs/logger-%s.log"

# Message format options
const FORMAT: String = "%s - %s - %s"
const DEBUG: String = "Debug"
const INFO: String = "Info"
const WARNING: String = "Warning"
const ERROR: String = "Error"

var current_filename: String = get_logfilename()
var logfile: FileAccess
var message_amount: int = 0

#################################################
# Setup
#################################################


func _init() -> void:
	logfile = FileAccess.open(current_filename, FileAccess.WRITE)


func get_logfilename() -> String:
	var logfilename: String
	var last_modified_time: float = 0

	for index: int in range(0, LOGFILE_AMOUNT):
		var filename: String = LOGFILE_PATH % [index]

		if not FileAccess.file_exists(filename):
			logfilename = filename
			break

		var modified_time: float = FileAccess.get_modified_time(filename)

		if modified_time < last_modified_time or last_modified_time == 0:
			last_modified_time = modified_time
			logfilename = filename

	return logfilename


#################################################
# Logger functions, call Logger.<fnc_name> to use
#################################################


func debug(message: String) -> void:
	if OS.is_debug_build():
		_log(DEBUG, message)


func info(message: String) -> void:
	_log(INFO, message)


func warning(message: String) -> void:
	_log(WARNING, message, true)


func error(message: String) -> void:
	_log(ERROR, message, true)


#################################################
# Internal Functions
#################################################


func _format_time() -> String:
	var time: Dictionary = Time.get_time_dict_from_system()
	return "[%02d:%02d:%02d]" % [time.hour, time.minute, time.second]


# TODO look at using get_stack() to print file and function name the call is coming from
func _log(level: String, message: String, flush: bool = false) -> void:
	var log_message: String = FORMAT % [_format_time(), level, message]

	logfile.store_line(log_message)
	message_amount += 1

	if flush or message_amount > FLUSH_EVERY:
		_flush()

	# Output to stdout
	if OS.is_debug_build():
		print(log_message)


func _flush() -> void:
	message_amount = 0

	if logfile != null:
		logfile.close()

	logfile = FileAccess.open(current_filename, FileAccess.READ_WRITE)
	logfile.seek_end()


func _exit_tree() -> void:
	_flush()
