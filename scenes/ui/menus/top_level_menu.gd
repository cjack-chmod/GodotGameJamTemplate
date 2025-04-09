class_name TopLevelMenu
extends CanvasLayer

var container: Container

@onready var current_focus: Node = self

##########################
# This class is used to group functionality
# for the main_menu, game_over_menu and pause_menu
# which all need the same functionality for certain buttons
# and menus related to options etc.
##########################

# TODO fill this out and replace with other menus


# closes the passed in secondary menu
func _close_secondary_menu(menu_instance: Node) -> void:
	current_focus = self
	menu_instance.queue_free()
	container.visible = true
