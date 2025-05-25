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

var enemy_spoted = false

var moves = 6

var enemy_body

var on_line = false

var mimic_in_area = false

var door_in_area = false

@onready var tilemap = $"../TileMap"

@export var dead = false

@export var animation_player : AnimationPlayer

var canmove = true
var chest_in_area = false
var currarea

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

signal use_stair

func _ready():
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
	if Global.player_action == true and dead == false:
		$CanvasLayer2/Candle.play("youre_turn")
	if Global.player_action == false and dead == false:
		$CanvasLayer2/Candle.play("enemy_turn")
	$Label2.text = "moves: " + str(moves)
	$Label.text = "player action: " + str(Global.player_action)
	if dead == true or Global.player_action == false or on_line == true:
		canmove = false
	if Global.player_action == true and on_line == false and dead == false:
		canmove = true
	if canmove == true:
		if Input.is_action_just_pressed("inv"):
			$CanvasLayer.visible = !$CanvasLayer.visible
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
	$Timer.wait_time = 0.01
	if new_text == "open chest":
		if mimic_in_area == true:
			trigger.emit()
		if chest_in_area == true:
			open_chest.emit()
			#chest_in_area = false
			
		#if chest_in_area == false:
		#	new_text = "no chest"
		#	$Timer.start()
	if new_text == "use stair":
		use_stair.emit(Global.current_level)
	
	if new_text == "zoom 1":
		$AnimationPlayer.play("zoom_in")
	
	if new_text == "zoom 2":
		$AnimationPlayer.play("zoom_out")
	
	if new_text == "look":
		look_around()
	
	if new_text == "dead":
		death()
	
	if new_text == "level":
		new_level()
	
	if new_text == "attack mimic" and enemy_spoted == true and Global.player_action == true and mimic_in_area == true:
		attack()
		moves = 6
	
	if new_text == "punch door" and door_in_area == true and dead == false and Global.player_action == true:
		punch_door.emit()
		if is_door_lock == true:
			is_door_lock = false
		is_door_open = true
	
	if new_text == "open door" and door_in_area == true and dead == false and Global.player_action == true:
		open_door.emit()
		if is_door_lock == false:
			is_door_open = true
	
	if new_text == "end" and Global.in_battle == true:
		moves = 6
		Global.player_action = false

	if new_text == "eq sword":
		var eq_item = InvLog.items.find(Global.sword)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.sword)
			InvLog.items[12] = Global.sword
			Global.damage = 6
			Global.boost = 0
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq dagger":
		var eq_item = InvLog.items.find(Global.dagger)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.dagger)
			InvLog.items[12] = Global.dagger
			Global.damage = 4
			Global.boost = 0
			Global.pure = false
			Global.char_boost = dexterity

	if new_text == "eq sharp dagger":
		var eq_item = InvLog.items.find(Global.s_dagger)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.s_dagger)
			InvLog.items[12] = Global.s_dagger
			Global.damage = 6
			Global.boost = 2
			Global.pure = false
			Global.char_boost = dexterity

	if new_text == "eq pure dagger":
		var eq_item = InvLog.items.find(Global.p_dagger)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.p_dagger)
			InvLog.items[12] = Global.p_dagger
			Global.damage = 6
			Global.boost = 0
			Global.pure = true
			Global.char_boost = dexterity

	if new_text == "eq broken sword":
		var eq_item = InvLog.items.find(Global.b_sword)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.b_sword)
			InvLog.items[12] = Global.b_sword
			Global.damage = 4
			Global.boost = -2
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq pure sword":
		var eq_item = InvLog.items.find(Global.p_sword)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.p_sword)
			InvLog.items[12] = Global.p_sword
			Global.damage = 8
			Global.boost = 0
			Global.pure = true
			Global.char_boost = strength

	if new_text == "eq sharp sword":
		var eq_item = InvLog.items.find(Global.s_sword)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.s_sword)
			InvLog.items[12] = Global.s_sword
			Global.damage = 8
			Global.boost = 2
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq broken claymore":
		var eq_item = InvLog.items.find(Global.b_claymore)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.b_claymore)
			InvLog.items[12] = Global.b_claymore
			Global.damage = 6
			Global.boost = -2
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq pure claymore":
		var eq_item = InvLog.items.find(Global.p_claymore)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.p_claymore)
			InvLog.items[12] = Global.p_claymore
			Global.damage = 12
			Global.boost = 12 
			Global.pure = true
			Global.char_boost = strength
			print(InvLog.items[12])

	if new_text == "eq greate claymore":
		var eq_item = InvLog.items.find(Global.g_claymore)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.g_claymore)
			InvLog.items[12] = Global.g_claymore
			Global.damage = 12
			Global.boost = 0 
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq claymore":
		var eq_item = InvLog.items.find(Global.claymore)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.claymore)
			InvLog.items[12] = Global.claymore
			Global.damage = 8
			Global.boost = 0 
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq pure halberd":
		var eq_item = InvLog.items.find(Global.p_halberd)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.p_halberd)
			InvLog.items[12] = Global.p_halberd
			Global.damage = 12
			Global.boost = 0
			Global.pure = true
			Global.char_boost = strength

	if new_text == "eq sharp halberd":
		var eq_item = InvLog.items.find(Global.s_halberd)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.s_halberd)
			InvLog.items[12] = Global.s_halberd
			Global.damage = 8
			Global.boost = 2
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq halberd":
		var eq_item = InvLog.items.find(Global.halberd)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.halberd)
			InvLog.items[12] = Global.halberd
			Global.damage = 8
			Global.boost = 0
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq broken halberd":
		var eq_item = InvLog.items.find(Global.b_halberd)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.b_halberd)
			InvLog.items[12] = Global.b_halberd
			Global.damage = 6
			Global.boost = -2
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq broken spear":
		var eq_item = InvLog.items.find(Global.b_spear)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.b_spear)
			InvLog.items[12] = Global.b_spear
			Global.damage = 4
			Global.boost = -2
			Global.pure = false
			Global.char_boost = dexterity

	if new_text == "eq spear":
		var eq_item = InvLog.items.find(Global.spear)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.spear)
			InvLog.items[12] = Global.spear
			Global.damage = 6
			Global.boost = 0
			Global.pure = false
			Global.char_boost = dexterity

	if new_text == "eq pure spear":
		var eq_item = InvLog.items.find(Global.p_spear)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.p_spear)
			InvLog.items[12] = Global.p_spear
			Global.damage = 8
			Global.boost = 0
			Global.pure = true
			Global.char_boost = dexterity

	if new_text == "eq sharp spear":
		var eq_item = InvLog.items.find(Global.s_spear)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.s_spear)
			InvLog.items[12] = Global.s_spear
			Global.damage = 8
			Global.boost = 2
			Global.pure = false
			Global.char_boost = dexterity

	if new_text == "eq bat":
		var eq_item = InvLog.items.find(Global.bat)
		if eq_item != -1:
			var has = InvLog.items.find("w")
			if has == -1:
				InvLog.remove_item(12)
				weapon_changed.emit(null)
				remove.emit(-1)
			remove.emit(eq_item)
			weapon_changed.emit(Global.bat)
			InvLog.items[12] = Global.bat
			Global.damage = 6
			Global.boost = 0
			Global.pure = false
			Global.char_boost = strength

	if new_text == "eq iron armor":
		var eq_item = InvLog.items.find(Global.iron_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.iron_armor)
			InvLog.items[13] = Global.iron_armor
			Global.armor = 10
	if new_text == "eq iron chestplate":
		var eq_item = InvLog.items.find(Global.iron_chestplate)
		if eq_item != -1:
			var has = InvLog.items.find("a")
			if has == -1:
				InvLog.remove_item(13)
				armor_changed.emit(null)
				remove.emit(-1)
			#print(InvLog.items[12])
			remove.emit(eq_item) #эта сука удаляет еще и оружку. как? да если б я знал
			armor_changed.emit(Global.iron_chestplate)
			InvLog.items[13] = Global.iron_chestplate
			Global.armor = 10
	if new_text == "eq armor of knights":
		var eq_item = InvLog.items.find(Global.armor_of_knights)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.armor_of_knights)
			InvLog.items[13] = Global.armor_of_knights
			Global.armor = 12
	if new_text == "eq prototype a":
		var eq_item = InvLog.items.find(Global.prototype_a)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.prototype_a)
			InvLog.items[13] = Global.prototype_a
			Global.armor = 18
	if new_text == "eq scaly armor":
		var eq_item = InvLog.items.find(Global.scaly_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.scaly_armor)
			InvLog.items[13] = Global.scaly_armor
			Global.armor = 12
	if new_text == "eq leather armor":
		var eq_item = InvLog.items.find(Global.leather_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.leather_armor)
			InvLog.items[13] = Global.leather_armor
			Global.armor = 8
	if new_text == "eq heavy armor":
		var eq_item = InvLog.items.find(Global.heavy_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.heavy_armor)
			InvLog.items[13] = Global.heavy_armor
			Global.armor = 16
	if new_text == "eq chain armor":
		var eq_item = InvLog.items.find(Global.chain_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.chain_armor)
			InvLog.items[13] = Global.chain_armor
			Global.armor = 10
	if new_text == "eq bone armor":
		var eq_item = InvLog.items.find(Global.bone_armor)
		if eq_item != -1:
			remove.emit(-1)
			var has = InvLog.items.find("a")
			armor_changed.emit(null)
			if has == -1:
				InvLog.remove_item(13)
			remove.emit(eq_item)
			armor_changed.emit(Global.bone_armor)
			InvLog.items[13] = Global.bone_armor
			Global.armor = 10
#	if Global.in_battle == true:
#		$CanvasLayer2/CLOCK/turn_clock.play("end")
	new_text = ""
	$Timer.start()
	#print(InvLog.items.find("w"))


func _on_line_edit_mouse_entered():
	$CanvasLayer2/LineEdit.grab_focus()
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

func take_turn():
	#print("I GDE?")
	Global.player_action = true
	moves = 6

func _on_area_2d_body_entered(body):
	if body.has_meta("enemy"):
		body.deal_attack.connect(get_damage)
		body.drop_loot.connect(get_loot)
		enemy_spoted = true
		enemy_body = body
		if body.type == "mimic":
			mimic_in_area = true

func _on_area_2d_body_exited(body):
	if body.has_meta("enemy"):
		body.deal_attack.disconnect(get_damage)
		body.drop_loot.disconnect(get_loot)
		enemy_spoted = false
		enemy_body = null
		if body.type == "mimic":
			mimic_in_area = false

func _on_area_2d_2_body_entered(body):
	if body.has_meta("enemy"):
		Global.in_battle = true
		body.give_turn.connect(take_turn)
		body.give_exp.connect(take_exp)
		#print("enemy spoted")

func _on_area_2d_2_body_exited(body):
	if body.has_meta("enemy"):
		Global.in_battle = false
		moves = 6
		body.give_turn.disconnect(take_turn)

func _on_close_button_pressed():
	$CanvasLayer/ItemsMenu.hide()

func attack():
	Global.player_action = false
	var attk = randi_range(1, 20) + Global.boost + Global.char_boost
	$dice.text = str(attk)
	$dice.modulate = Color(1, 1, 1)
	$dice.visible = true
	$AnimationPlayer.play("return")
	await $AnimationPlayer.animation_finished
	$dice.visible = false
	if attk >= enemy_body.armor:
		var deal_damage = randi_range(1, Global.damage)
		$dice.text = str(deal_damage)
		$dice.modulate = Color(1, 0, 0)
		$dice.visible = true
		$AnimationPlayer.play("return")
		await $AnimationPlayer.animation_finished
		$dice.visible = false
		player_attack.emit(deal_damage)

func _on_damage_timer_timeout():
	if dead != true:
		$Hero.modulate = Color(1, 1, 1)

func death():
	$CanvasLayer2/Candle.play("dead")
	dead = true
	$Hero.modulate = Color(1, 0, 0)

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
		print(Global.selected_item)
		print(index_of_item)
		remove.emit(index_of_item)
		print(InvLog.items.find(Global.selected_item))

func stairs_animation(zoom_in_out):
	if zoom_in_out == "in":
		$AnimationPlayer.play("zoom_in")
	if zoom_in_out == "out":
		$AnimationPlayer.play("zoom_out")
