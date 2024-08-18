extends CharacterBody2D



#@export var dagger : PackedScene
#@export var coin : PackedScene
#@export var potion : PackedScene
#@export var big_potion : PackedScene
signal open_chest(bool)
signal remove(String)

var enemy_spoted = false

var moves = 6

var enemy_body

@onready var tilemap = $"../TileMap"

@export var dead = false

var canmove = true
var chest_in_area = false
var currarea

signal weapon_changed(item)
signal player_attack(int)

func _ready():
	set_meta("player", 222)

func _physics_process(delta):
	if dead == true or Global.player_action == false:
		canmove = false
	if canmove == true:
		if Input.is_action_just_pressed("inv"):
			$CanvasLayer.visible = !$CanvasLayer.visible
	if Input.is_action_just_pressed("esc"):
		canmove = true
	if moves != 0:
		if canmove == true:
			if Input.is_action_just_pressed("ui_left"):
				move(Vector2.LEFT)
				if Global.in_battle == true:
					moves -= 1
			if Input.is_action_just_pressed("ui_right"):
				move(Vector2.RIGHT)
				if Global.in_battle == true:
					moves -= 1
			if Input.is_action_just_pressed("ui_up"):
				move(Vector2.UP)
				if Global.in_battle == true:
					moves -= 1
			if Input.is_action_just_pressed("ui_down"):
				move(Vector2.DOWN)
				if Global.in_battle == true:
					moves -= 1

func move(direction: Vector2):
	if canmove == true:
		var currtile: Vector2i = tilemap.local_to_map(global_position)
		var targtile: Vector2i = Vector2i(currtile.x + direction.x, currtile.y + direction.y)
		var tiledata: TileData = tilemap.get_cell_tile_data(0, targtile)
		if tiledata.get_custom_data("walk") == false:
			return
		global_position = tilemap.map_to_local(targtile)


func _on_line_edit_text_submitted(new_text):
	var text = $CanvasLayer2/LineEdit.get_text()
	if new_text == "open chest":
		if chest_in_area == true:
			open_chest.emit()
			new_text = "successful"
			$Timer.start()
			
		if chest_in_area == false:
			new_text = "no chest"
			$Timer.start()
	var command = new_text[0] + new_text[1] + new_text[2]
	if command == "att" and enemy_spoted == true:
		Global.player_action = false
		var attk = randi_range(1, 20) + Global.boost
		if attk >= enemy_body.armor:
			player_attack.emit(randi_range(1, Global.damage))
	
	if new_text == "end" and Global.in_battle == true:
		moves = 6
		Global.player_action = false

	if new_text[0] + new_text[1] == "eq":
		var curr_item
		remove.emit(-1)
		var has = InvLog.items.find("w")
		if new_text.length() >= 8:
			curr_item = new_text[3] + new_text[4] + new_text[5] + new_text[6] + new_text[7]
		weapon_changed.emit(null)
		if has == -1:
			InvLog.remove_item(12)
			#remove.emit(12)
			#print(InvLog.items[12])
		if curr_item == "sword":
			var wp = InvLog.items.find(Global.sword)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.sword)
				InvLog.items[12] = Global.sword
				Global.damage = 6
				Global.boost = 0
				Global.pure = false
		if curr_item == "dagge":
			var wp = InvLog.items.find(Global.dagger)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.dagger)
				InvLog.items[12] = Global.dagger
				Global.damage = 4
				Global.boost = 0
				Global.pure = false
		if curr_item == "s dag":
			var wp = InvLog.items.find(Global.s_dagger)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.s_dagger)
				InvLog.items[12] = Global.s_dagger
				Global.damage = 6
				Global.boost = 2
				Global.pure = false
		if curr_item == "p dag":
			var wp = InvLog.items.find(Global.p_dagger)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.p_dagger)
				InvLog.items[12] = Global.p_dagger
				Global.damage = 6
				Global.boost = 0
				Global.pure = true
		if curr_item == "b swo":
			var wp = InvLog.items.find(Global.b_sword)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.b_sword)
				InvLog.items[12] = Global.b_sword
				Global.damage = 4
				Global.boost = -2
				Global.pure = false
		if curr_item == "p swo":
			var wp = InvLog.items.find(Global.p_sword)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.p_sword)
				InvLog.items[12] = Global.p_sword
				Global.damage = 8
				Global.boost = 0
				Global.pure = true
		if curr_item == "s swo":
			var wp = InvLog.items.find(Global.s_sword)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.s_sword)
				InvLog.items[12] = Global.s_sword
				Global.damage = 8
				Global.boost = 2
				Global.pure = false
		if curr_item == "b cla":
			var wp = InvLog.items.find(Global.b_claymore)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.b_claymore)
				InvLog.items[12] = Global.b_claymore
				Global.damage = 6
				Global.boost = -2
				Global.pure = false
		if curr_item == "p cla":
			var wp = InvLog.items.find(Global.p_claymore)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.p_claymore)
				InvLog.items[12] = Global.p_claymore
				Global.damage = 12
				Global.boost = 12 
				Global.pure = true
		if curr_item == "g cla":
			var wp = InvLog.items.find(Global.g_claymore)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.g_claymore)
				InvLog.items[12] = Global.g_claymore
				Global.damage = 12
				Global.boost = 0 
				Global.pure = false
		if curr_item == "claym":
			var wp = InvLog.items.find(Global.claymore)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.claymore)
				InvLog.items[12] = Global.claymore
				Global.damage = 8
				Global.boost = 0 
				Global.pure = false
		if curr_item == "p hal":
			var wp = InvLog.items.find(Global.p_halberd)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.p_halberd)
				InvLog.items[12] = Global.p_halberd
				Global.damage = 12
				Global.boost = 0
				Global.pure = true
		if curr_item == "s hal":
			var wp = InvLog.items.find(Global.s_halberd)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.s_halberd)
				InvLog.items[12] = Global.s_halberd
				Global.damage = 8
				Global.boost = 2
				Global.pure = false
		if curr_item == "halbe":
			var wp = InvLog.items.find(Global.halberd)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.halberd)
				InvLog.items[12] = Global.halberd
				Global.damage = 8
				Global.boost = 0
				Global.pure = false
		if curr_item == "b hal":
			var wp = InvLog.items.find(Global.b_halberd)
			if wp != -1:
				remove.emit(wp)
				weapon_changed.emit(Global.b_halberd)
				InvLog.items[12] = Global.b_halberd
				Global.damage = 6
				Global.boost = -2
				Global.pure = false
	new_text = ""
	#print(InvLog.items.find("w"))


func _on_line_edit_mouse_entered():
	$CanvasLayer2/LineEdit.grab_focus()
	canmove = false


func _on_area_2d_area_entered(area):
	if area.has_meta("chest"):
		chest_in_area = true
		area.loot.connect(get_loot)

func _on_timer_timeout():
	$CanvasLayer2/LineEdit.text = ""
	chest_in_area = false

func _on_line_edit_mouse_exited():
	$CanvasLayer2/LineEdit.release_focus()
	canmove = true

func _on_area_2d_area_exited(area):
	if area.has_meta("chest"):
		chest_in_area = false

func _on_button_pressed():
	$CanvasLayer.hide()

func get_loot(get_item):
	var slot = InvLog.items.find({})
	InvLog.set_item(slot, get_item)

func get_damage(damage):
	Global.HP -= damage
	if Global.HP <= 0:
		dead = true
		print("YOU DEAD")

func _on_area_2d_body_entered(body):
	if body.has_meta("enemy"):
		body.deal_attack.connect(get_damage)
		enemy_spoted = true
		enemy_body = body

func _on_area_2d_body_exited(body):
	if body.has_meta("enemy"):
		body.deal_attack.disconnect(get_damage)
		enemy_spoted = false
		enemy_body = null

func _on_area_2d_2_body_entered(body):
	if body.has_meta("enemy"):
		Global.in_battle = true
		

func _on_area_2d_2_body_exited(body):
	if body.has_meta("enemy"):
		Global.in_battle = false

func _on_close_button_pressed():
	$CanvasLayer/ItemsMenu.hide()
