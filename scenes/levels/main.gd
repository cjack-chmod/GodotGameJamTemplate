extends Node2D

# calling this signal will trigger the game over screen
# this can be moved, called or altered as needed
signal sig_game_over

const PAUSE_MENU: PackedScene = preload("res://scenes/ui/menus/pause_menu/pause_menu.tscn")
const GAME_OVER_MENU_PATH: String = "res://scenes/ui/menus/game_over_menu/game_over_menu.tscn"

## This export lets you customise which mouse mode will be used in this scene
@export var scene_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE


func _ready() -> void:
	# enables the mouse mode given in export
	Input.mouse_mode = scene_mouse_mode
	sig_game_over.connect(game_over)


func _input(event: InputEvent) -> void:
	# this code sets what is needed to pause the game
	if event.is_action_pressed("pause"):
		_pause_game()


# code to create the pause menu
func _pause_game() -> void:
	var pause_menu: CanvasLayer = PAUSE_MENU.instantiate()
	pause_menu.parent_scene_mouse_mode = scene_mouse_mode
	add_child(pause_menu)
	get_tree().root.set_input_as_handled()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# this function calls the game over functionality
# call the sig_game_over signal to trigger. You can modify or move this as required
func game_over() -> void:
	var game_over_menu: PackedScene = load(GAME_OVER_MENU_PATH)
	var game_over_menu_object: CanvasLayer = game_over_menu.instantiate()
	add_child(game_over_menu_object)
