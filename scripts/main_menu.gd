extends Node2D

var entering : bool = false

func _process(delta: float) -> void:
	if entering == true:
		$"Big-shadow".modulate.a += 0.01
	if $"Big-shadow".modulate.a >= 1 and $Timer.is_stopped() == true:
		$Timer.start()
		$PlayFrame.hide()

func _on_play_button_mouse_entered() -> void:
	if entering == false:
		$PlayFrame.show()

func _on_play_button_mouse_exited() -> void:
	$PlayFrame.hide()

func _on_settings_button_mouse_entered() -> void:
	if entering == false:
		$SettingsFrame.show()

func _on_settings_button_mouse_exited() -> void:
	$SettingsFrame.hide()

func _on_exit_button_mouse_entered() -> void:
	if entering == false:
		$ExitFrame.show()

func _on_exit_button_mouse_exited() -> void:
	$ExitFrame.hide()

func _on_play_button_pressed() -> void:
	entering = true
	$PlayFrame.hide()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/layer0.tscn")
