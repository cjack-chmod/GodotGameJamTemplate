extends CanvasLayer

const OPTIONS_MENU: PackedScene = preload("res://menus/options_menu/options_menu.tscn")
const CREDITS: PackedScene = preload("res://menus/credits/credits.tscn")

@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	$%PlayButton.pressed.connect(_on_play_pressed)
	$%OptionsButton.pressed.connect(_on_options_pressed)
	$%QuitButton.pressed.connect(_on_quit_pressed)
	$%CreditsButton.pressed.connect(_on_credits_pressed)


func _on_play_pressed() -> void:
	# set any starting conditions here
	ScreenTransition.transition_to_scene(ScreenTransition.main_scene_file_path)


func _on_credits_pressed() -> void:
	margin_container.visible = false
	var credits_instance: CanvasLayer = CREDITS.instantiate()
	add_child(credits_instance)
	credits_instance.sig_back_pressed.connect(_on_credits_closed.bind(credits_instance))


func _on_options_pressed() -> void:
	margin_container.visible = false
	var options_instance: CanvasLayer = OPTIONS_MENU.instantiate()
	add_child(options_instance)
	options_instance.sig_back_pressed.connect(_on_options_closed.bind(options_instance))


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_closed(options_instance: Node) -> void:
	options_instance.queue_free()
	margin_container.visible = true


func _on_credits_closed(credits_instance: Node) -> void:
	credits_instance.queue_free()
	margin_container.visible = true
