extends Area2D

@export var up : bool #1-up 0-down
@export var variant : String # 1-left 0-right 2-bottom

var player

var level_1_coord : Vector2i = Vector2i(248, -344)
var level_2_coord_var_0 : Vector2i = Vector2i(312, -696)
var level_2_coord_var_1 : Vector2i = Vector2i(152, -696)
var level_2_coord_var_2 : Vector2i = Vector2i(232, -616)
var level_3_coord_var_1 : Vector2i = Vector2i(168, -984)
var level_3_coord_var_0 : Vector2i = Vector2i(280, -984)

signal launch_animation(String)

func _ready():
	set_meta("stairs", 1)

func stairs_log(player_layer):
	launch_animation.emit("in")
	await player.animation_player.animation_finished
	if player_layer == 1:
		Global.current_level += 1
		player.position = level_2_coord_var_2

	if player_layer == 2:
		if up == false:
			Global.current_level += 1
			if variant == "left":
				player.position = level_3_coord_var_1
			if variant == "right":
				player.position = level_3_coord_var_0
		if up == true:
			Global.current_level -= 1
			player.position = level_1_coord

	if player_layer == 3:
		Global.current_level -= 1
		if variant == "left":
			player.position = level_2_coord_var_1
		if variant == "right":
			player.position = level_2_coord_var_0
	launch_animation.emit("out")

func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.use_stair.connect(stairs_log)
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		body.use_stair.disconnect(stairs_log)
