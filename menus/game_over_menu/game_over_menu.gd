extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://menus/options_menu/options_menu.tscn")

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ONE, .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_options_pressed() -> void:
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	panel_container.visible = false
	add_child(options_instance)
	options_instance.sig_back_pressed.connect(_on_options_closed.bind(options_instance))


func _on_restart_pressed() -> void:
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	self.hide()
	call_deferred("queue_free")
	ScreenTransition.transition_to_scene("res://menus/main_menu/main_menu.tscn")


func _on_options_closed(options_instance: Node) -> void:
	options_instance.queue_free()
	panel_container.visible = true
