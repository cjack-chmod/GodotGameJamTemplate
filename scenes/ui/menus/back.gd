extends CanvasLayer

signal sig_back_pressed

@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)


func _on_back_button_pressed() -> void:
	Logger.info("Back button pressed")
	sig_back_pressed.emit()
