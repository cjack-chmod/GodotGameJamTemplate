extends Node2D

const PAUSE_MENU: PackedScene = preload("res://scenes/ui/menus/pause_menu/pause_menu.tscn")

## This export lets you customise which mouse mode will be used in this scene
@export var scene_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE


func _ready() -> void:
	# enables the mouse mode given in export
	Input.mouse_mode = scene_mouse_mode


func _input(event: InputEvent) -> void:
	# this code sets what is needed to pause the game
	if event.is_action_pressed("pause"):
		_spawn_pause_menu()
		get_tree().root.set_input_as_handled()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# code to create the pause menu
func _spawn_pause_menu() -> void:
	var pause_menu: CanvasLayer = PAUSE_MENU.instantiate()
	pause_menu.parent_scene_mouse_mode = scene_mouse_mode
	add_child(pause_menu)
