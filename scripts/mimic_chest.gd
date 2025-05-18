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

signal give_exp(int)

var agr_rate = 5

@export var danger_lvl : int
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
	$Timer.start()



func _on_area_up_body_entered(body):
	if body.has_meta("player"):
		on_top = true
		#$Timer.start()
		player = body

func _on_area_up_body_exited(body):
	if body.has_meta("player"):
		on_top = false
		#$Timer.start()

func _on_area_down_body_entered(body):
	if body.has_meta("player"):
		on_bottom = true
		#$Timer.start()
		player = body

func _on_area_down_body_exited(body):
	if body.has_meta("player"):
		on_bottom = false
		#$Timer.start()

func _on_area_left_body_entered(body):
	if body.has_meta("player"):
		on_left = true
		player = body
		#$Timer.start()

func _on_area_left_body_exited(body):
	if body.has_meta("player"):
		on_left = false
		#$Timer.start()

func _on_area_right_body_entered(body):
	if body.has_meta("player"):
		player = body
		on_right = true
		#$Timer.start()

func _on_area_right_body_exited(body):
	if body.has_meta("player"):
		on_right = false
		#$Timer.start()

func _on_timer_timeout():
	#print(player.dead, Global.player_action)
	#if dead == false and angry == true:
	if (player.dead == false) and (Global.player_action == false):
		if prep_to_att == false:
			if moves != 0:
				var direction : Vector2
				if on_top == true:
					direction += Vector2(0, -16)
					#print("TOP")
				if on_bottom == true:
					direction += Vector2(0, 16)
					#print("BOTTOM")
				if on_left == true:
					direction += Vector2(-16, 0)
					#print("LEFT")
				if on_right == true:
					direction += Vector2(16, 0)
					#print("RIGHT")
				position += direction
				moves -= 1
				$Timer.start()
				#print("MOVE")
			if moves == 0:
				give_turn.emit()
				moves = 6
				#print("EMIT")
		#print(prep_to_att, Global.player_action)
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
				give_turn.emit()
				print(player.dead, Global.player_action)
	
	if (player.dead == false) and (Global.player_action == true):
		$Timer.start()
	#print("timer", player.dead, Global.player_action)
		#Global.player_action = true
		#print("timer end")

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
			give_exp.emit(danger_lvl)
			give_turn.emit()
			dead = true
			queue_free()

func triggired():
	if angry == false:
		agr_rate = 5
		#Global.player_action = false
		angry = true
		attack()

func attack():
	#print(player.dead, Global.player_action)
	agr_rate -= 1
	var deal_damage = randi_range(1, damage)
	$dice.modulate = Color(1, 0, 0)
	$dice.show()
	#print($dice.visible)
	$dice.text = str(deal_damage)
	#print(deal_damage)
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	#print($dice.visible)
	print(deal_damage)
	$dice.hide()
	deal_attack.emit(deal_damage)
	give_turn.emit()
	#print(player.dead, Global.player_action)
	$Timer.start()
	#Global.player_action = true
	#print("mimic attack")
	#print(Global.player_action)
