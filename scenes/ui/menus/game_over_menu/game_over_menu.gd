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
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	current_focus = options_instance
	container.visible = false
	add_child(options_instance)
	options_instance.sig_back_pressed.connect(_close_secondary_menu.bind(options_instance))


func _on_restart_pressed() -> void:
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene(MAIN_MENU_SCENE_PATH)
