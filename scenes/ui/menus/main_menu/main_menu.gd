extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://scenes/ui/menus/options_menu/options_menu.tscn")
const CREDITS: PackedScene = preload("res://scenes/ui/menus/credits/credits.tscn")

@onready var current_focus: Node = self
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	$%PlayButton.pressed.connect(_on_play_pressed)
	$%OptionsButton.pressed.connect(_on_options_pressed)
	$%QuitButton.pressed.connect(_on_quit_pressed)
	$%CreditsButton.pressed.connect(_on_credits_pressed)


# launces main scene defined in ScreenTransition
func _on_play_pressed() -> void:
	# set any starting conditions here
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


# launches credits menu, and binds back key to close fnc
func _on_credits_pressed() -> void:
	margin_container.visible = false
	var credits_instance: CanvasLayer = CREDITS.instantiate()
	add_child(credits_instance)
	current_focus = credits_instance
	credits_instance.sig_back_pressed.connect(_close_secondary_menu.bind(credits_instance))


# launches options menu, and binds back key to close fnc
func _on_options_pressed() -> void:
	margin_container.visible = false
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	add_child(options_instance)
	current_focus = options_instance
	options_instance.sig_back_pressed.connect(_close_secondary_menu.bind(options_instance))


func _on_quit_pressed() -> void:
	get_tree().quit()


# closes the passed in secondary menu
func _close_secondary_menu(menu_instance: Node) -> void:
	current_focus = self
	menu_instance.queue_free()
	margin_container.visible = true


# closes secondary menus using escape key
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		# if current focus is secondary menu
		if current_focus != self:
			# if is options menu
			if "is_control_menu_open" in current_focus:
				# closing controls menu in options if open
				if current_focus.is_control_menu_open:
					current_focus.on_controls_closed(current_focus.controls_instance)
					return

			# else close secondary menu
			_close_secondary_menu(current_focus)
