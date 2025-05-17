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
	Logger.info("Play game button pressed")
	# set any starting conditions here
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


# launches credits menu, and binds back key to close fnc
func _on_credits_pressed() -> void:
	Logger.info("Credits button pressed")
	var credits_scene: PackedScene = load(CREDITS_SCENE_PATH)
	_instantiate_secondary_menu(credits_scene)


# launches options menu, and binds back key to close fnc
func _on_options_pressed() -> void:
	Logger.info("Options button Pressed")
	_instantiate_secondary_menu(OPTIONS_MENU)


func _on_quit_pressed() -> void:
	Logger.info("Quit button pressed")
	get_tree().quit()
