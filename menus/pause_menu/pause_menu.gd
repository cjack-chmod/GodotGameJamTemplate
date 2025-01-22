extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://menus/options_menu/options_menu.tscn")

var is_closing: bool

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	restart_button.pressed.connect(_on_restart_pressed)

	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ONE, .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_close()
		get_tree().root.set_input_as_handled()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _close() -> void:
	if is_closing:
		return

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_closing = true

	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ZERO, .3)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_BACK)
	)

	await tween.finished
	get_tree().paused = false
	queue_free()


func _on_resume_pressed() -> void:
	_close()


func _on_options_pressed() -> void:
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	panel_container.visible = false
	add_child(options_instance)
	options_instance.sig_back_pressed.connect(_on_options_closed.bind(options_instance))


func _on_restart_pressed() -> void:
	var scene: String = get_parent().scene_file_path
	get_tree().paused = false
	ScreenTransition.transition_to_scene(scene)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	ScreenTransition.transition_to_scene("res://menus/main_menu/main_menu.tscn")


func _on_options_closed(options_instance: Node) -> void:
	options_instance.queue_free()
	panel_container.visible = true
