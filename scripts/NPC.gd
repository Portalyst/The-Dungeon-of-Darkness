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

signal return_dialog_value

@export var loot : PackedScene
@export var Name : String
@export var armor : int
@export var damage : int
@export var HP = 8
@export var dead : bool = false
@export var danger_lvl : int
@export var immortal : bool = false

@export var index_in_array : int = -1

@export var index_of_enemy : int
@export var turn : bool = false
@export var aggressive : bool = false
@export var index_in_NPC_array : int = -1

var moves = 6

var player

var start_position : Vector2

var rescue_flag : bool = false

@export var dialog_list : Array = ["heroa: ", "hero: suka", "hero: ne suka", "what did you say? my name is Empty, btw", "hero: agu?", "fuck off!"]
@export var variants : Array = ["suka", "ne suka"] 
@export var portrait : CompressedTexture2D

var first_meet : bool = true

func _ready():
	player = $"../Hero"
	set_meta("NPC", 3)
	player.player_attack.connect(take_damage)
	player.talk_to_NPC.connect(talk)
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
	
	#if dead == true and on_bottom == false and on_left == false and on_right == false and on_top == false and rescue_flag == true and immortal == true:
		#$Timer_of_immortality.start()
		#rescue_flag = false
	#if on_bottom == true or on_left == true or on_right == true or on_top == true and immortal == true:
		#$Timer_of_immortality.stop()
		#rescue_flag = true
	if (player.dead == false) and dead == false and turn == true and aggressive == true:
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
				give_turn.emit(dead, index_in_array)
				moves = 6
		if (prep_to_att == true) and turn == true:
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
				give_turn.emit(dead, index_in_array)
			#Global.player_action = true
	if on_top == false and on_bottom == false and on_left == false and on_right == false and prep_to_att == false and self.position != start_position:
		self.position = start_position
	if (player.dead == false) and turn == false and aggressive == true:
		$Timer.start()

func _on_att_area_body_entered(body):
	if body.has_meta("player"):
		prep_to_att = true

func _on_att_area_body_exited(body):
	if body.has_meta("player"):
		prep_to_att = false

func take_damage(damage, index_of_target):
	if dead == false and index_of_target == index_of_enemy:
		HP -= damage
		self.modulate = Color(1, 0, 0)
		aggressive = true
		if HP <= 0:
			#Global.all_enemies.remove_at(index_of_enemy)
			#print("OAOOAOAO")
			var chance = randi_range(0, 10)
			if chance == 10:
				drop_loot.emit(loot)
			give_exp.emit(danger_lvl)
			dead = true
			#Global.all_enemies[Global.current_turn] = null
			#print(Global.all_enemies[Global.current_turn])
			give_turn.emit(dead, index_in_array)
			if immortal == false or Global.pure == true:
				#give_turn.emit(dead, index_in_array)
				queue_free()
			#else:
				#$damage_timer.start()
				#if type == "skeleton":
					#$AnimatedSprite2D.play("dead")
				#if type == "shadow man":
					#$AnimatedSprite2D.hide()
				#rescue_flag = true
				#Global.update_turn()
			
			#Global.update_turn()
			#Global.switch_turn()
			#print(Global.all_enemies)
		if HP > 0:
			$damage_timer.start()
			Global.switch_turn()
			Global.update_turn()

func attack():
	var deal_damage : int = randi_range(1, damage)
	$dice.modulate = Color(1, 0, 0)
	$dice.show()
	$dice.text = str(deal_damage)
	$AnimationPlayer.play("throw")
	await $AnimationPlayer.animation_finished
	$dice.hide()
	deal_attack.emit(deal_damage)
	give_turn.emit(dead, index_in_array)
	$Timer.start()


func _on_timer_of_immortality_timeout():
	dead = false
	Global.enemies_lives[index_in_array] = false
	#Global.update_turn()


func _on_damage_timer_timeout() -> void:
	self.modulate = Color(1, 1, 1)
	#Global.player_action = false
	
func talk():
	return_dialog_value.emit(dialog_list, Name, portrait, first_meet, variants)
