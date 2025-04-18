extends Node2D

var entering : bool = false

func _on_button_mouse_entered():
	if entering == false:
		$Menu/PlayNew.show()
		
	#$AnimationPlayer.play("play_area")

func _process(delta: float) -> void:
	if entering == true and $Camera2D.zoom.x != 1.5:
		$Camera2D.zoom.x += 0.01
		$Camera2D.zoom.y += 0.01
		$"Menu/Big-shadow".modulate.a += 0.01
	if $"Menu/Big-shadow".modulate.a >= 1:
		get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_button_1_mouse_entered():
	$AnimationPlayer.play("setting_area")

func _on_button_2_mouse_entered():
	$AnimationPlayer.play("exit_area")

func _on_button_pressed():
	if $Menu/PlayNew.visible == true and entering == false:
		$Logo.hide()
		$Logo2.hide()
		entering = true
		$Menu/PlayNew.hide()
		
		#$Menu/Play/CPUParticles2D.emitting = true
		#$AnimationPlayer.play("play_area")
		#$Menu/Play/Timer.start()

func _on_button_2_pressed():
	$Menu/Exit/CPUParticles2D.emitting = true
	$AnimationPlayer.play("exit_area")
	#get_tree().quit()

func _on_button_1_pressed():
	$Menu/Settings/CPUParticles2D.emitting = true
	$AnimationPlayer.play("setting_area")


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_button_mouse_exited() -> void:
	$Menu/PlayNew.hide()
