extends CharacterBody2D

#ловкость - dexterity
#сила - strength
#телосложение - physique / protection

var dexterity : int = 1
var strength : int = 1
var protection : int = 1
var attentiveness : int = 1

var free_level : int = 0

var door_cord : Vector2
var is_door_open : bool
var is_door_lock : bool

var moves = 60

var on_line : bool = false

var turn : bool = true

#var mimic_in_area : bool = false
#var skeleton_in_area : bool = false
#var cult_in_area : bool = false
#var shadow_man_in_area : bool = false

var door_in_area = false

@onready var tilemap = $"../TileMap"

@export var dead = false

@export var animation_player : AnimationPlayer

var canmove = true
var chest_in_area = false
var currarea

var last_commands : Array = []
var command : int

var next_dialog_pressed : bool = false

#SIGNALS

#battle
signal player_attack(int)
signal trigger()
signal open_chest(bool)
#inventory
signal remove(String)
signal armor_changed(item)
signal weapon_changed(item)
#door
signal open_door
signal punch_door
#Secret objects
signal try_to_spot(int)
#level
signal use_stair
#NPC
signal talk_to_NPC

func _ready():
	Global.turn_list.append(self)
	animation_player = $AnimationPlayer
	set_meta("player", 1)
	$dice.visible = false
	$"CanvasLayer2/Bars/curr-level".text = str(Global.level)
	HP_changed()
	EXP_changed()
	char_upt()
	$CanvasLayer/Inv/Cross.self_modulate.a = 0.5
	$CanvasLayer/Inv/Cross2.self_modulate.a = 0.5
	$CanvasLayer/Inv/Cross3.self_modulate.a = 0.5
	$CanvasLayer2/LineEdit.set("theme_override_colors/font_color",Color("white"))
	
func _physics_process(delta):
	$"CanvasLayer2/Bars/curr-level".text = str(Global.current_level)
	if turn == true and dead == false:
		$CanvasLayer2/Candle.play("youre_turn")
	if turn == false and dead == false:
		$CanvasLayer2/Candle.play("enemy_turn")
	$Label2.text = str(Global.in_battle)#turn: " + str(Global.current_turn, " ")# + "array: " + str(Global.turn_list)
	$Label.text = str(Global.enemies_lives)#str(last_commands)#"array: " + str(Global.turn_list) #"player action: " +  + " " +
	if dead == true or turn == false or on_line == true:
		canmove = false
	if turn == true and on_line == false and dead == false:
		canmove = true
	if canmove == true:
		if Input.is_action_just_pressed("inv"):
			$CanvasLayer.visible = !$CanvasLayer.visible
	
	if on_line == true and dead == false:
		if Input.is_action_just_pressed("arrow_down"):
			if command > 0:
				command -= 1
				$CanvasLayer2/LineEdit.text = last_commands[command]
		if Input.is_action_just_pressed("arrow_up"):
			if command < last_commands.size() - 1:
				command += 1
				$CanvasLayer2/LineEdit.text = last_commands[command]
	
	if Input.is_action_just_pressed("esc"):
		canmove = true
	if moves != 0:
		if canmove == true:
			if Input.is_action_just_pressed("ui_left"):
				move(Vector2.LEFT)
			if Input.is_action_just_pressed("ui_right"):
				move(Vector2.RIGHT)
			if Input.is_action_just_pressed("ui_up"):
				move(Vector2.UP)
			if Input.is_action_just_pressed("ui_down"):
				move(Vector2.DOWN)

func move(direction: Vector2):
	if canmove == true:
		var currtile: Vector2i = tilemap.local_to_map(global_position)
		var targtile: Vector2i = Vector2i(currtile.x + direction.x, currtile.y + direction.y)
		var tiledata: TileData = tilemap.get_cell_tile_data(0, targtile)
		#var walk_near = walk.emit(tilemap.map_to_local(targtile))
		if tiledata.get_custom_data("walk") == false:
			return
		if door_in_area == true and door_cord == tilemap.map_to_local(targtile) and is_door_open == false:
			return
		global_position = tilemap.map_to_local(targtile)
		if Global.in_battle == true:
			moves -= 1


func _on_line_edit_text_submitted(new_text):
	if last_commands.has(new_text) == true:
		last_commands.remove_at(last_commands.find(new_text))
	last_commands.append(new_text) 
	command = last_commands.size()
	
	$Timer.wait_time = 0.01
	if new_text == "open chest":
		#if mimic_in_area == true:
			#trigger.emit()
		if chest_in_area == true:
			open_chest.emit()
			#chest_in_area = false
			
		#if chest_in_area == false:
		#	new_text = "no chest"
		#	$Timer.start()
	if new_text == "talk":
		talk_to_NPC.emit()
	
	
	if new_text == "enter":
		use_stair.emit(Global.current_level)
	
	if new_text == "zoom 1":
		$AnimationPlayer.play("zoom_in")
	
	if new_text == "zoom 2":
		$AnimationPlayer.play("zoom_out")
	
	if new_text == "look":
		look_around()
	
	if new_text == "dead":
		get_damage(10000)
	
	if new_text == "level":
		new_level()

	if new_text.contains("attack") == true and turn == true and Global.in_battle == true:
		var name : String = new_text.replace("attack ", "")
		attack(name)
	
	if new_text == "punch door" and door_in_area == true and dead == false and turn == true:
		punch_door.emit()
		if is_door_lock == true:
			is_door_lock = false
		is_door_open = true
	
	if new_text == "open door" and door_in_area == true and dead == false and turn == true:
		open_door.emit()
		if is_door_lock == false:
			is_door_open = true
	
	if new_text == "end" and Global.in_battle == true and turn == true:
		#print(Global.turn_list)
		#print(Global.enemies_lives)
		moves = 6
		if Global.enemies_lives.has(false) == true:
			Global.switch_turn()
			#print("goida")
	
	if new_text.contains("eq") == true and turn == true:
		for item in Global.all_items:
		#	print(item.get_state().get_node_property_value(0, 2))
			if item.get_state().get_node_property_value(0, 0) == new_text.replace("eq ", ""):
				var eq_item : int = InvLog.items.find(item)
				if eq_item != -1:
					if item.get_state().get_node_property_value(0, 1).contains("1-") == true:
						var has = InvLog.items.find("w")
						if has == -1:
							InvLog.remove_item(12)
							weapon_changed.emit(null)
							remove.emit(-1)
						remove.emit(eq_item)
						weapon_changed.emit(item)
						InvLog.items[12] = item
						Global.damage = item.get_state().get_node_property_value(0, 1).replace("1-", "").to_int()
						Global.pure = item.get_state().get_node_property_value(0, 0).contains("Pure")
						var char_scaling = item.get_state().get_node_property_value(0, 4)
						if char_scaling == "strength":
							Global.char_boost = strength
						if char_scaling == "dexterity":
							Global.char_boost = dexterity
						$CanvasLayer/Inv/WeaponIcon.hide()
					else:
						var has = InvLog.items.find("a")
						if has == -1:
							InvLog.remove_item(13)
							armor_changed.emit(null)
							remove.emit(-1)
						remove.emit(eq_item)
						armor_changed.emit(item)
						InvLog.items[13] = item
						Global.armor = item.get_state().get_node_property_value(0, 2)
						$CanvasLayer/Inv/ArmorIcon.hide()
					#print(Global.armor)
					#print(Global.damage)
	

#	if Global.in_battle == true:
#		$CanvasLayer2/CLOCK/turn_clock.play("end")
	new_text = ""
	$Timer.start()
	#print(InvLog.items.find("w"))


func _on_line_edit_mouse_entered():
	#$CanvasLayer2/LineEdit.grab_focus()
	on_line = true


func _on_area_2d_area_entered(area):
	if area.has_meta("chest"):
		chest_in_area = true
		area.loot.connect(get_loot)
	if area.has_meta("door"):
		door_in_area = true
		door_cord = area.position
		is_door_open = area.opened
		is_door_lock = area.locked
	if area.has_meta("stairs"):
		area.launch_animation.connect(stairs_animation)

func _on_timer_timeout():
	$CanvasLayer2/LineEdit.text = ""
	$CanvasLayer2/LineEdit.set("theme_override_colors/font_color",Color("white"))

func _on_line_edit_mouse_exited():
	$CanvasLayer2/LineEdit.release_focus()
	on_line = false

func _on_area_2d_area_exited(area):
	if area.has_meta("chest"):
		chest_in_area = false
		area.loot.disconnect(get_loot)
	if area.has_meta("door"):
		door_in_area = false
		door_cord = Vector2(0, 0)
	if area.has_meta("stair"):
		area.launch_animation.disconnect(stairs_animation)

#func _on_button_pressed():
	#$CanvasLayer.hide()

func get_loot(get_item):
	var slot = InvLog.items.find({})
	if slot != -1:
		InvLog.set_item(slot, get_item)

func get_damage(damage):
	$Hero.modulate = Color(1, 0, 0)
	$damage_timer.start()
	Global.HP -= damage
	HP_changed()
	if Global.HP <= 0:
		death()

func take_turn(enemy_dead, enemy_index):
	print("solus two")
	Global.switch_turn()
	Global.enemies_lives[enemy_index] = enemy_dead
	moves = 6
	if Global.enemies_lives.has(false) == false:
		Global.in_battle = false
		Global.enemies_lives.clear()
		if Global.pure == false:
			for i in Global.immortality_index:
				Global.enemies_lives.append(true)
	#print("in battle", Global.in_battle)
	#print("array", Global.enemies_lives)

func _on_area_2d_body_entered(body):
	if body.has_meta("enemy") or body.has_meta("NPC"):
		body.deal_attack.connect(get_damage)
		body.drop_loot.connect(get_loot)
		if body.has_meta("NPC"):
			body.return_dialog_value.connect(update_dialog)
			if body.index_in_NPC_array == -1:
				Global.NPC_Array.append(body)
				body.index_in_NPC_array == Global.NPC_Array.size() - 1
		#if body.type == "mimic":
			#mimic_in_area = true
		#if body.type == "skeleton":
			#skeleton_in_area = true
		#if body.type == "cult":
			#cult_in_area = true
		#if body.type == "shadow":
					#shadow_man_in_area = true

func _on_area_2d_body_exited(body):
	if body.has_meta("enemy") or body.has_meta("NPC"):
		body.deal_attack.disconnect(get_damage)
		body.drop_loot.disconnect(get_loot)
		if body.has_meta("NPC"):
			body.return_dialog_value.disconnect(update_dialog)
			if body.index_in_NPC_array != -1:
				Global.NPC_Array.remove_at(body.index_in_NPC_array)
				body.index_in_NPC_array == -1
		#for i in Global.all_enemies:
			#if i:
				#if i.type == "shadow":
					#shadow_man_in_area = true
				#else:
					#shadow_man_in_area = false
				#if i.type == "skeleton":
					#skeleton_in_area = true
				#else:
					#skeleton_in_area = false
				#if i.type == "mimic":
					#mimic_in_area = true
				#else:
					#mimic_in_area = false
				#if i.type == "cult":
					#cult_in_area = true
				#else:
					#cult_in_area = false
		#if Global.all_enemies.has(Global.mimic) == false:
			#mimic_in_area = false
		#if Global.all_enemies.has(Global.skeleton) == false:
			#skeleton_in_area = false
		#if Global.all_enemies.has(Global.cultist) == false:
			#cult_in_area = false

func _on_area_2d_2_body_entered(body):
	if body.has_meta("enemy") or body.has_meta("NPC"):
		if body.dead == false and body.has_meta("enemy"):
			Global.in_battle = true
		if body.has_meta("NPC"):
			if body.dead == false and body.aggressive == true:
				Global.in_battle = true
		body.give_turn.connect(take_turn)
		body.give_exp.connect(take_exp)
		Global.turn_list.append(body)
		body.index_of_enemy = Global.turn_list.size() - 1
		if body.index_in_array == -1:
			Global.enemies_lives.append(body.dead)
			body.index_in_array = Global.enemies_lives.size() - 1
			if body.immortal == true:
				Global.immortality_index.append(body.index_in_array)
		#print(body.index_in_array, Global.enemies_lives)

func _on_area_2d_2_body_exited(body):
	if body.has_meta("enemy") or body.has_meta("NPC"):
		#Global.in_battle = false
		if body.dead == false:
			moves = 6
		body.give_turn.disconnect(take_turn)
		if body.index_of_enemy < Global.turn_list.size():
			Global.turn_list[body.index_of_enemy] = null
		Global.update_turn()
		body.index_in_array = -1
		#if body.dead == true:
			#Global.enemies_lives.remove_at(body.index_in_array)
			#body.index_in_array = -1
		#print(body.index_in_array, Global.enemies_lives)

func _on_close_button_pressed():
	$CanvasLayer/ItemsMenu.hide()

func attack(name_of_target):
	var index_of_target : int = -1
	for indx in Global.turn_list.size():
			if Global.turn_list[indx]:
				if Global.turn_list[indx] != self:
					if Global.turn_list[indx].type == name_of_target:
						index_of_target = indx
						break
	if index_of_target != -1:
		var attk = randi_range(1, 20) + Global.boost + Global.char_boost
		$dice.text = str(attk)
		$dice.modulate = Color(1, 1, 1)
		$dice.visible = true
		$AnimationPlayer.play("return")
		await $AnimationPlayer.animation_finished
		$dice.visible = false
		if attk < Global.turn_list[index_of_target].armor:
			Global.switch_turn()
		if attk >= Global.turn_list[index_of_target].armor:
			var deal_damage : int
			if attk < 20:
				deal_damage = randi_range(1, Global.damage)
			if attk >= 20:
				deal_damage = Global.damage + attk - 20
			$dice.text = str(deal_damage)
			$dice.modulate = Color(1, 0, 0)
			$dice.visible = true
			$AnimationPlayer.play("return")
			await $AnimationPlayer.animation_finished
			$dice.visible = false
			player_attack.emit(deal_damage, index_of_target)

func _on_damage_timer_timeout():
	if dead != true:
		$Hero.modulate = Color(1, 1, 1)

func death():
	$CanvasLayer2/Candle.play("dead")
	dead = true
	$Hero.modulate = Color(1, 0, 0)
	print("dead")

func take_exp(monster_lvl):
	if monster_lvl == 1:
		Global.exp += 15
	if monster_lvl == 2:
		Global.exp += 25
	if monster_lvl == 3:
		Global.exp += 45
	if Global.exp >= Global.needful_exp:
		new_level()
	EXP_changed()

func HP_changed():
	$CanvasLayer2/Bars/HP_bar.value = Global.HP * 100 / Global.max_HP
	if Global.HP >= -999:
		$CanvasLayer2/Bars/HP_bar/HPcount.text = str(Global.HP) + "/" + str(Global.max_HP)
	else:
		$CanvasLayer2/Bars/HP_bar/HPcount.text = "-999/" + str(Global.max_HP)

func EXP_changed():
	$CanvasLayer2/Bars/EXP_bar.value = Global.exp * 100 / Global.needful_exp

func new_level():
	Global.level += 1
	free_level += 1
	Global.exp -= Global.needful_exp
	Global.needful_exp = Global.needful_exp * 5 * Global.level
	$"CanvasLayer2/Bars/curr-level".text = str(Global.level)
	$CanvasLayer/Inv/Cross.self_modulate.a = 1
	$CanvasLayer/Inv/Cross2.self_modulate.a = 1
	$CanvasLayer/Inv/Cross3.self_modulate.a = 1
	$CanvasLayer2/LineEdit.set("theme_override_colors/font_color",Color("yellow"))
	$CanvasLayer2/LineEdit.text = "новый уровень!"
	$Timer.wait_time = 1


func _on_str_button_pressed():
	if free_level > 0:
		free_level -= 1
		strength += 1
		if free_level == 0:
			$CanvasLayer/Inv/Cross.self_modulate.a = 0.5
			$CanvasLayer/Inv/Cross2.self_modulate.a = 0.5
			$CanvasLayer/Inv/Cross3.self_modulate.a = 0.5
		char_upt()

func _on_prt_button_pressed():
	if free_level > 0:
		free_level -= 1
		protection += 1
		if free_level == 0:
			$CanvasLayer/Inv/Cross.hide()
		char_upt()

func _on_dex_button_pressed():
	if free_level > 0:
		free_level -= 1
		dexterity += 1
		if free_level == 0:
			$CanvasLayer/Inv/Cross.hide()
		char_upt()

func char_upt():
	$CanvasLayer/Inv/str_label.text = str(strength)
	$CanvasLayer/Inv/dex_label.text = str(dexterity)
	$CanvasLayer/Inv/prot_label.text = str(protection)

func look_around():
	try_to_spot.emit(attentiveness)

func _on_trash_button_pressed() -> void:
	if visible == true:
		var index_of_item = InvLog.items.find(Global.selected_item)
		remove.emit(index_of_item)
		$CanvasLayer/ItemsMenu.hide()
		#print(Global.selected_item)
		#print(index_of_item)
		#print(InvLog.items.find(Global.selected_item))

func stairs_animation(zoom_in_out):
	if zoom_in_out == "in":
		$AnimationPlayer.play("zoom_in")
	if zoom_in_out == "out":
		$AnimationPlayer.play("zoom_out")


func _on_hp_bar_mouse_entered() -> void:
	$CanvasLayer2/Bars/HP_bar/HPcount.show()

func _on_hp_bar_mouse_exited() -> void:
	$CanvasLayer2/Bars/HP_bar/HPcount.hide()

func update_dialog(npc_dialog_list, name_of_npc, npc_portrait, first_meet):
	$CanvasLayer2/DialogWindow.show()
	print("sybau")
	var player_talk : bool = false
	$CanvasLayer2/DialogWindow/NPCPortrait.texture = npc_portrait
	$dialog_text_timer.start()
	$dialog_text_timer.one_shot = false
	$CanvasLayer2/DialogWindow/next_button/Label.text = "next->"
	for i in npc_dialog_list.size():
		$CanvasLayer2/DialogWindow/dialog.visible_characters = 0
		if npc_dialog_list[i].contains("мое имя") or npc_dialog_list[i].contains("меня зовут") or npc_dialog_list[i].contains("my name is"):
			first_meet = false
		if npc_dialog_list[i].contains("hero: "):
			player_talk = true
			$AnimationPlayer.play("hero_talk")
		if npc_dialog_list[i].contains("hero: ") == false and player_talk == true:
			player_talk = false
			$AnimationPlayer.play("NPC_talk")
		if first_meet == true:
			$CanvasLayer2/DialogWindow/NameOfCharacter.text = "???:"
		else:
			$CanvasLayer2/DialogWindow/NameOfCharacter.text = name_of_npc + ":"
		if player_talk == true:
			$CanvasLayer2/DialogWindow/NameOfCharacter.text = Global.player_name + ":"
		if player_talk == false:
			$CanvasLayer2/DialogWindow/dialog.text = npc_dialog_list[i]
		else:
			$CanvasLayer2/DialogWindow/dialog.text = npc_dialog_list[i].replace("hero: ", "")
		if i == npc_dialog_list.size() - 1:
			$CanvasLayer2/DialogWindow/next_button/Label.text = "exit"
		await $CanvasLayer2/DialogWindow/next_button.pressed
	$dialog_text_timer.stop()
	$dialog_text_timer.one_shot = true
	$CanvasLayer2/DialogWindow.hide()

func _on_dialog_text_timer_timeout() -> void:
	$CanvasLayer2/DialogWindow/dialog.visible_characters += 1
