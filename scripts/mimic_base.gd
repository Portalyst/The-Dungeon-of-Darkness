extends CharacterBody2D

var on_right = false
var on_left = false
var on_top = false
var on_bottom = false

var prep_to_att = false

signal deal_attack(int)

@export var armor : int
@export var damage : int
@export var HP = 8
@export var dead = false

var moves = 6

var player

func _ready():
	set_meta("enemy", 3)
	$"../Hero".player_attack.connect(take_damage)



func _on_area_up_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_top = true
			$Timer.start()
			player = body
	else:
		on_top = false

func _on_area_up_body_exited(body):
	if body.has_meta("player"):
		on_top = false
		$Timer.start()

func _on_area_down_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_bottom = true
			$Timer.start()
			player = body
	else:
		on_bottom = false

func _on_area_down_body_exited(body):
	if body.has_meta("player"):
		on_bottom = false
		$Timer.start()

func _on_area_left_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_left = true
			player = body
			$Timer.start()
	else:
		on_left = false

func _on_area_left_body_exited(body):
	if body.has_meta("player"):
		on_left = false
		$Timer.start()

func _on_area_right_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			player = body
			on_right = true
			$Timer.start()
	else:
		on_right = false

func _on_area_right_body_exited(body):
	if body.has_meta("player"):
		on_right = false
		$Timer.start()

func _on_timer_timeout():
	if dead == false:
		if player.dead == false and Global.player_action == false:
			if prep_to_att == false:
				var direction : Vector2
				if on_top == true:
					direction += Vector2(0, -16)
				if on_bottom == true:
					direction += Vector2(0, 16)
				if on_left == true:
					direction += Vector2(-16, 0)
				if on_right == true:
					direction += Vector2(16, 0)
				position += direction
				moves -= 1
				if moves == 0:
					Global.player_action = true
			if prep_to_att == true and Global.player_action == false:
				var attack = randi_range(1, 20)
				$dice.visible = true
				$dice.modulate = Color(1, 1, 1)
				$dice.text = str(attack)
				$AnimationPlayer.play("throw")
				await $AnimationPlayer.animation_finished
				$dice.visible = false
				if attack >= Global.armor:
					var deal_damage : int = randi_range(1, damage)
					$dice.modulate = Color(1, 0, 0)
					$dice.visible = true
					$dice.text = str(deal_attack)
					$AnimationPlayer.play("throw")
					await $AnimationPlayer.animation_finished
					$dice.visible = false
					deal_attack.emit(deal_damage)
				Global.player_action = true
				prep_to_att = false
		$Timer.start()

func _on_att_area_body_entered(body):
	if body.has_meta("player"):
		prep_to_att = true

func _on_att_area_body_exited(body):
	if body.has_meta("player"):
		prep_to_att = false

func take_damage(damage):
	if dead == false:
		HP -= damage
		if HP <= 0:
			dead = true
			queue_free()
			Global.player_action = true
