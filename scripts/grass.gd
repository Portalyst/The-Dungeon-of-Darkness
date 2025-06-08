extends Node2D

var border_reached : bool = false

var first_border : int = randi_range(-10, -20)
var second_border : int = randi_range(10, 20)


func _ready() -> void:
	var i : int = randi_range(1, 3)
	$AnimatedSprite2D.play("idle_"+str(i))
	var rand : int = randi_range(0, 1)
	if rand == 0:
		border_reached = false
	if rand == 1:
		border_reached = true

func _on_timer_timeout() -> void:
	if $AnimatedSprite2D.rotation != deg_to_rad(first_border) and border_reached == false:
		$AnimatedSprite2D.rotation -= 0.0005
	if $AnimatedSprite2D.rotation <= deg_to_rad(first_border) and border_reached == false:
		border_reached = true
	if $AnimatedSprite2D.rotation != deg_to_rad(second_border) and border_reached == true:
		$AnimatedSprite2D.rotation += 0.001
	if $AnimatedSprite2D.rotation >= deg_to_rad(second_border) and border_reached == true:
		border_reached = false
