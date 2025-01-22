extends CanvasLayer

signal sig_back_pressed

const CONTROLS: PackedScene = preload("res://menus/controls/controls.tscn")

var controls_instance: CanvasLayer
var is_control_menu_open: bool = false

@onready var window_button: Button = $%WindowButton
@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var back_button: Button = $%BackButton
@onready var controls: Button = %Controls


func _ready() -> void:
	window_button.pressed.connect(_on_window_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind("music"))
	controls.pressed.connect(_on_controls_pressed)
	_update_display()


func _update_display() -> void:
	sfx_slider.value = _get_bus_volume_percent("sfx")
	music_slider.value = _get_bus_volume_percent("music")


func _get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func _set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_controls_pressed() -> void:
	is_control_menu_open = true
	controls_instance = CONTROLS.instantiate()
	add_child(controls_instance)
	controls_instance.sig_back_pressed.connect(on_controls_closed.bind(controls_instance))


func on_controls_closed(_controls_instance: Node) -> void:
	is_control_menu_open = false
	_controls_instance.queue_free()


func _on_window_button_pressed() -> void:
	var mode: int = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_update_display()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	_set_bus_volume_percent(bus_name, value)


func _on_back_button_pressed() -> void:
	sig_back_pressed.emit()
