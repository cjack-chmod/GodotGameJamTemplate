extends CanvasLayer

signal sig_transitioned_halfway

var main_scene_file_path: String = "res://scenes/levels/main.tscn"

var _skip_emit: bool = false


func _transition() -> void:
	$AnimationPlayer.play("default")
	await sig_transitioned_halfway
	_skip_emit = true
	$AnimationPlayer.play_backwards("default")
	await get_tree().create_timer(.4).timeout


func transition_to_scene(scene_path: String) -> void:
	_transition()
	await sig_transitioned_halfway
	get_tree().change_scene_to_file(scene_path)


func emit_sig_transitioned_halfway() -> void:
	if _skip_emit:
		_skip_emit = false
		return
	sig_transitioned_halfway.emit()
