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
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	container.visible = false
	current_focus = options_instance
	add_child(options_instance)
	options_instance.sig_back_pressed.connect(_close_secondary_menu.bind(options_instance))


func _on_restart_pressed() -> void:
	var scene: String = get_parent().scene_file_path
	get_tree().paused = false
	ScreenTransition.transition_to_scene(scene)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	ScreenTransition.transition_to_scene(MAIN_MENU_SCENE_PATH)
