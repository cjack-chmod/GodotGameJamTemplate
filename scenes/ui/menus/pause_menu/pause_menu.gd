extends TopLevelMenu

var is_closing: bool
var parent_scene_mouse_mode: Input.MouseMode = Input.MouseMode.MOUSE_MODE_VISIBLE


func _ready() -> void:
	super()
	get_tree().paused = true

	# connecting buttons
	%ResumeButton.pressed.connect(_on_resume_pressed)
	%OptionsButton.pressed.connect(_on_options_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)
	%RestartButton.pressed.connect(_on_restart_pressed)

	_transition_in()


##############################
# Menu Closing Functions
##############################


# redefining this function as it is different from the others
# and does nothing in the parent class
func _escape_pressed() -> void:
	super()
	_close()


# function that closes the paused menu
# called when escape key presssed or when resume button is pressed
func _close() -> void:
	if is_closing:
		return

	Input.mouse_mode = parent_scene_mouse_mode
	is_closing = true

	await _transition_out()
	get_tree().paused = false
	queue_free()


##############################
# Button Press Functions
##############################


func _on_resume_pressed() -> void:
	_close()


func _on_options_pressed() -> void:
	_instantiate_secondary_menu(OPTIONS_MENU)


func _on_restart_pressed() -> void:
	get_tree().paused = false
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	ScreenTransition.transition_to_scene(MAIN_MENU_SCENE_PATH)
