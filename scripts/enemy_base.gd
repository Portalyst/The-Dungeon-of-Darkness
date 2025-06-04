extends CharacterBody2D

var on_right = false
var on_left = false
var on_top = false
var on_bottom = false

var prep_to_att = false

signal deal_attack(int)

signal drop_loot()

signal give_turn()

signal give_exp(int)

@export var loot : PackedScene
@export var type : String
@export var armor : int
@export var damage : int
@export var HP = 8
@export var dead : bool = false
@export var danger_lvl : int
@export var index_in_array : int = -1

var moves = 6

var player

var start_position : Vector2

var need_more_power : bool = false

func _ready():
	player = $"../Hero"
	set_meta("enemy", 3)
	player.player_attack.connect(take_damage)
	start_position = self.position

func _on_area_up_body_entered(body):
	if body.has_meta("player"):
		on_top = true
		$Timer.start()
		player = body

func _on_area_up_body_exited(body):
	if body.has_meta("player"):
		on_top = false
		$Timer.start()

func _on_area_down_body_entered(body):
	if body.has_meta("player"):
		on_bottom = true
		$Timer.start()
		player = body

func _on_area_down_body_exited(body):
	if body.has_meta("player"):
		on_bottom = false
		$Timer.start()

func _on_area_left_body_entered(body):
	if body.has_meta("player"):
		on_left = true
		player = body
		$Timer.start()

func _on_area_left_body_exited(body):
	if body.has_meta("player"):
		on_left = false
		$Timer.start()

func _on_area_right_body_entered(body):
	if body.has_meta("player"):
		player = body
		on_right = true
		$Timer.start()

func _on_area_right_body_exited(body):
	if body.has_meta("player"):
		on_right = false
		$Timer.start()

func _on_timer_timeout():
	if dead == true and need_more_power == true and $Timer_of_immortality.is_stopped() == true and on_bottom == false and on_left == false and on_right == false and on_top == false:
		$Timer_of_immortality.start()
		need_more_power = false
	else:
		$Timer_of_immortality.stop()
	if (player.dead == false) and (Global.player_action == false) and dead == false:
		if prep_to_att == false:
			if moves != 0:
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
				$Timer.start()
			if moves == 0:
				give_turn.emit(dead, index_in_array, type)
				moves = 6
		if (prep_to_att == true) and (Global.player_action == false):
			var attack = randi_range(1, 20)
			$dice.modulate = Color(1, 1, 1)
			$dice.show()
			$dice.text = str(attack)
			$AnimationPlayer.play("throw")
			await $AnimationPlayer.animation_finished
			$dice.hide()
			#Global.player_action = true
			if attack >= Global.armor:
				attack()
			if attack < Global.armor:
				give_turn.emit(dead, index_in_array, type)
			#Global.player_action = true
	if on_top == false and on_bottom == false and on_left == false and on_right == false and prep_to_att == false:
		self.position = start_position
	if (player.dead == false) and (Global.player_action == true):
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
			var chance = randi_range(0, 10)
			if chance == 10:
				drop_loot.emit(loot)
			give_exp.emit(danger_lvl)
			dead = true
			give_turn.emit(dead, index_in_array, type)
			if type != "skeleton":
				queue_free()
			else:
				need_more_power = true
				#$Timer_of_immortality.start()
				$AnimatedSprite2D.play("dead")
		if HP > 0:
			Global.player_action = false

func attack():
	var deal_damage : int = randi_range(1, damage)
	$dice.modulate = Color(1, 0, 0)
	$dice.show()
	$dice.text = str(deal_damage)
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	$dice.hide()
	deal_attack.emit(deal_damage)
	give_turn.emit(dead, index_in_array, type)
	$Timer.start()
	print(deal_damage)


func _on_timer_of_immortality_timeout() -> void:
	dead = false
	$AnimatedSprite2D.play("idle")
