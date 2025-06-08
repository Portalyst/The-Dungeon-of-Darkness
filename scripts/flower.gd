extends Node2D

var touch : bool = false

func _on_control_mouse_entered() -> void:
	if touch == false:
		touch = true
		$AnimationPlayer.play("touched_right")
		await $AnimationPlayer.animation_finished
		touch = false

func _on_left_mouse_entered() -> void:
	if touch == false:
		touch = true
		$AnimationPlayer.play("touched_left")
		await $AnimationPlayer.animation_finished
		touch = false
