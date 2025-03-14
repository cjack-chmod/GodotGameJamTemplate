extends Node2D

const PAUSE_MENU: PackedScene = preload("res://scenes/ui/menus/pause_menu/pause_menu.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(PAUSE_MENU.instantiate())
		get_tree().root.set_input_as_handled()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
