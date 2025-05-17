extends TopLevelMenu


func _ready() -> void:
	super()
	%OptionsButton.pressed.connect(_on_options_pressed)
	%RestartButton.pressed.connect(_on_restart_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)

	get_tree().paused = true
	_transition_in()


##############################
# Button Press Functions
##############################


func _on_options_pressed() -> void:
	Logger.info("Options opened")
	_instantiate_secondary_menu(OPTIONS_MENU)


func _on_restart_pressed() -> void:
	Logger.info("Restarting game")
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


func _on_quit_pressed() -> void:
	Logger.info("Quitting Game")
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene(MAIN_MENU_SCENE_PATH)
