extends CharacterBody2D

var on_right = false
var on_left = false
var on_top = false
var on_bottom = false

var angry = false

var prep_to_att = false

signal deal_attack(int)

signal drop_loot()

signal give_turn()

var agr_rate = 5

@export var loot2 : String
@export var loot : String
@export var type = "mimic"
@export var armor : int
@export var damage : int
@export var HP = 8
@export var dead = false

var moves = 6

var player

func _process(delta):
	if agr_rate <= 0:
		angry = false
		agr_rate = 0
	if dead == false:
		if angry == true:
			$AnimatedSprite2D.play("active")
		else:
			$AnimatedSprite2D.play("pass")

func _ready():
	set_meta("enemy", 3)
	$"../Hero".player_attack.connect(take_damage)
	player = $"../Hero"



func _on_area_up_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_top = true
			#$Timer.start()
			#player = body
	else:
		on_top = false

func _on_area_up_body_exited(body):
	if body.has_meta("player"):
		on_top = false
		#$Timer.start()

func _on_area_down_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_bottom = true
			#$Timer.start()
			player = body
	else:
		on_bottom = false

func _on_area_down_body_exited(body):
	if body.has_meta("player"):
		on_bottom = false
		#$Timer.start()

func _on_area_left_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			on_left = true
			player = body
			#$Timer.start()
	else:
		on_left = false

func _on_area_left_body_exited(body):
	if body.has_meta("player"):
		on_left = false
		#$Timer.start()

func _on_area_right_body_entered(body):
	if prep_to_att == false:
		if body.has_meta("player"):
			player = body
			on_right = true
			#$Timer.start()
	else:
		on_right = false

func _on_area_right_body_exited(body):
	if body.has_meta("player"):
		on_right = false
		#$Timer.start()

func _on_timer_timeout():
	print(dead, angry, player.dead, Global.player_action, prep_to_att, moves)
	#if dead == false and angry == true:
	if (player.dead == false) and (Global.player_action == false):
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
				print("MOVE")
			if moves == 0:
				give_turn.emit()
				print("EMIT")
		if (prep_to_att == true) and (Global.player_action == false):
			var attack = randi_range(1, 20)
			$dice.visible = true
			$dice.modulate = Color(1, 1, 1)
			$dice.text = str(attack)
			$AnimationPlayer.play("throw")
			await $AnimationPlayer.animation_finished
			$dice.visible = false
			Global.player_action = true
			if attack >= Global.armor:
				attack()
		#Global.player_action = true
		print("timer end")
	$Timer.start()

func _on_att_area_body_entered(body):
	if body.has_meta("player"):
		prep_to_att = true
		$"../Hero".trigger.connect(triggired)

func _on_att_area_body_exited(body):
	if body.has_meta("player"):
		prep_to_att = false
		$"../Hero".trigger.disconnect(triggired)

func take_damage(damage):
	if dead == false:
		angry = true
		agr_rate = 5
		HP -= damage
		if HP <= 0:
			var chance_for_one = randi_range(0, 10)
			if chance_for_one == 10:
				drop_loot.emit(loot)
			var chance_for_two = randi_range(0, 20)
			if chance_for_two == 20:
				drop_loot.emit(loot2)
			dead = true
			queue_free()
			give_turn.emit()

func triggired():
	if angry == false:
		agr_rate = 5
		#Global.player_action = false
		angry = true
		attack()

func attack():
	agr_rate -= 1
	var deal_damage = randi_range(1, damage)
	$dice.modulate = Color(1, 0, 0)
	$dice.visible = true
	$dice.text = str(deal_damage)
	#print(deal_damage)
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	$dice.visible = false
	deal_attack.emit(deal_damage)
	give_turn.emit()
	#Global.player_action = true
	#print("mimic attack")
	#print(Global.player_action)
