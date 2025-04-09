extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://scenes/ui/menus/options_menu/options_menu.tscn")

@onready var container: Container = $MarginContainer/PanelContainer
@onready var current_focus: Node = self


func _ready() -> void:
	%OptionsButton.pressed.connect(_on_options_pressed)
	%RestartButton.pressed.connect(_on_restart_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)

	get_tree().paused = true
	container.pivot_offset = container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(container, "scale", Vector2.ZERO, 0)
	tween.tween_property(container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(
		Tween.TRANS_BACK
	)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


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
	ScreenTransition.transition_to_scene("res://scenes/ui/menus/main_menu/main_menu.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		# closes pause menu
		if current_focus != self:
			# closing controls menu in options if open
			if current_focus.is_control_menu_open:
				current_focus.on_controls_closed(current_focus.controls_instance)
				return

			# else close secondary menu
			_close_secondary_menu(current_focus)


# closes the passed in secondary menu
func _close_secondary_menu(menu_instance: Node) -> void:
	current_focus = self
	menu_instance.queue_free()
	container.visible = true
