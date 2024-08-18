extends Node2D

func _on_button_mouse_entered():
	$AnimationPlayer.play("play_area")

func _on_button_1_mouse_entered():
	$AnimationPlayer.play("setting_area")

func _on_button_2_mouse_entered():
	$AnimationPlayer.play("exit_area")

func _on_button_pressed():
	$Menu/Play/CPUParticles2D.emitting = true
	$AnimationPlayer.play("play_area")
	$Menu/Play/Timer.start()

func _on_button_2_pressed():
	$Menu/Exit/CPUParticles2D.emitting = true
	$AnimationPlayer.play("exit_area")
	#get_tree().quit()

func _on_button_1_pressed():
	$Menu/Settings/CPUParticles2D.emitting = true
	$AnimationPlayer.play("setting_area")


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
