class_name TopLevelMenu
extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://scenes/ui/menus/options_menu/options_menu.tscn")
const MAIN_MENU_SCENE_PATH: String = "res://scenes/ui/menus/main_menu/main_menu.tscn"
const CREDITS_SCENE_PATH: String = "res://scenes/ui/menus/credits/credits.tscn"

var container: Container

@onready var current_focus: Node = self

##########################
# This class is used to group functionality
# for the main_menu, game_over_menu and pause_menu
# which all need the same functionality for certain buttons
# and menus related to options etc.
##########################


# add any ready functions here that apply to all
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	container = %PanelContainer
	container.pivot_offset = container.size / 2


# escape button handling
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		# closes pause menu
		if current_focus == self:
			_escape_pressed()
		elif current_focus != self:
			_escape_pressed_with_secondary_menu_open()


# closes the passed in secondary menu
func _close_secondary_menu(menu_instance: Node) -> void:
	current_focus = self
	menu_instance.queue_free()
	container.visible = true


# used for menus that are opened in an existing scene
# not used for main menu as that is the main scene when launched
func _transition_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(container, "scale", Vector2.ZERO, 0)
	tween.tween_property(container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(
		Tween.TRANS_BACK
	)


# used for menus that are closed in an existing scene
# only used for pause menu atm
func _transition_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(container, "scale", Vector2.ONE, 0)
	tween.tween_property(container, "scale", Vector2.ZERO, .3).set_ease(Tween.EASE_IN).set_trans(
		Tween.TRANS_BACK
	)
	await tween.finished


func _escape_pressed() -> void:
	pass


func _escape_pressed_with_secondary_menu_open() -> void:
	# closing controls menu in options if open
	if current_focus.is_control_menu_open:
		current_focus.on_controls_closed(current_focus.controls_instance)
		return

	# else close secondary menu
	_close_secondary_menu(current_focus)
