extends Area2D

@export var up : bool #1-up 0-down
@export var variant : String # 1-left 0-right 2-bottom

var player

signal launch_animation(String)

func _ready():
	if up == true:
		$AnimatedSprite2D.play("up")
	else:
		$AnimatedSprite2D.play("down")
	set_meta("stairs", 1)
	if up == false and variant == "":
		Global.level_1_coord = self.position
	if up == true and variant == "bottom":
		Global.level_2_coord_var_2 = self.position
	if up == false and variant == "left":
		Global.level_2_coord_var_1 = self.position
	if up == false and variant == "right":
		Global.level_2_coord_var_0 = self.position
	if up == true and variant == "left":
		Global.level_3_coord_var_1 = self.position
	if up == true and variant == "right":
		Global.level_3_coord_var_0 = self.position

func stairs_log(player_layer):
	launch_animation.emit("in")
	await player.animation_player.animation_finished
	if player_layer == 1:
		Global.current_level += 1
		player.position = Global.level_2_coord_var_2

	if player_layer == 2:
		if up == false:
			Global.current_level += 1
			if variant == "left":
				player.position = Global.level_3_coord_var_1
			if variant == "right":
				player.position = Global.level_3_coord_var_0
		if up == true:
			Global.current_level -= 1
			player.position = Global.level_1_coord

	if player_layer == 3:
		Global.current_level -= 1
		if variant == "left":
			player.position = Global.level_2_coord_var_1
		if variant == "right":
			player.position = Global.level_2_coord_var_0
	launch_animation.emit("out")

func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.use_stair.connect(stairs_log)
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		body.use_stair.disconnect(stairs_log)
