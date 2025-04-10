extends TopLevelMenu


func _ready() -> void:
	super()

	# connecting buttons
	%PlayButton.pressed.connect(_on_play_pressed)
	%OptionsButton.pressed.connect(_on_options_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)
	%CreditsButton.pressed.connect(_on_credits_pressed)


##############################
# Button Press Functions
##############################


# launces main scene defined in ScreenTransition
func _on_play_pressed() -> void:
	# set any starting conditions here
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


# launches credits menu, and binds back key to close fnc
func _on_credits_pressed() -> void:
	container.visible = false
	var credits_scene: PackedScene = load(CREDITS_SCENE_PATH)
	var credits_instance: CanvasLayer = credits_scene.instantiate()
	add_child(credits_instance)
	current_focus = credits_instance
	credits_instance.sig_back_pressed.connect(_close_secondary_menu.bind(credits_instance))


# launches options menu, and binds back key to close fnc
func _on_options_pressed() -> void:
	container.visible = false
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	add_child(options_instance)
	current_focus = options_instance
	options_instance.sig_back_pressed.connect(_close_secondary_menu.bind(options_instance))


func _on_quit_pressed() -> void:
	get_tree().quit()
