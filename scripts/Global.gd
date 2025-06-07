extends Node

var enemies_lives : Array = []

var immortality_index : Array = []

var turn_list : Array = []
var current_turn : int = 0

var coins : int = 15

var max_HP : int = 10
var HP : int = 100

var armor : int = 10

var level : int = 1
var exp : int = 0
var needful_exp : int = 100

var player

var in_battle : bool = false

var damage : int = 1
var pure : bool = false
var boost : int = 0
var char_boost : int = 0

var selected_item

#weapons

var bat = load("res://scenes/bat.tscn")

func _ready() -> void:
	print(bat)
	print(bat.get_state().get_node_property_name(0, 0))

var p_sword = load("res://scenes/p_sword.tscn")
var s_sword = load("res://scenes/s_sword.tscn")
var sword = load("res://scenes/sword.tscn")
var b_sword = load("res://scenes/broken_sword.tscn")

var p_dagger = load("res://scenes/p_dagger.tscn")
var s_dagger = load("res://scenes/s_dagger.tscn")
var dagger = load("res://scenes/dagger.tscn")

var g_claymore = load("res://scenes/g_claymore.tscn")
var p_claymore = load("res://scenes/p_claymore.tscn")
var claymore = load("res://scenes/claymore.tscn")
var b_claymore =load("res://scenes/b_claymore.tscn")

var p_halberd = load("res://scenes/p_halberd.tscn")
var s_halberd = load("res://scenes/s_halberd.tscn")
var halberd = load("res://scenes/halberd.tscn")
var b_halberd =load("res://scenes/b_halberd.tscn")

var b_spear = load("res://scenes/broken_spear.tscn")
var spear = load("res://scenes/spear.tscn")
var s_spear = load("res://scenes/sharp_spear.tscn")
var p_spear = load("res://scenes/pure_spear.tscn")

#armors

var bone_armor = load("res://scenes/bone_armor.tscn")
var chain_armor = load("res://scenes/chain_armor.tscn")
var armor_of_knights = load("res://scenes/armor_of_knights.tscn")
var heavy_armor = load("res://scenes/heavy_armor.tscn")
var iron_armor = load("res://scenes/iron_armor.tscn")
var leather_armor = load("res://scenes/leather_armor.tscn")
var lightweight_heavy_armor = load("res://scenes/lightweight_heavy_armor.tscn")
var scaly_armor = load("res://scenes/scaly_armor.tscn")
var iron_chestplate = load("res://scenes/iron_chestplate.tscn")
var prototype_a = load("res://scenes/prototype_a.tscn")

#other items

var coin = load("res://scenes/coins.tscn")
var mimic_tongue = load("res://scenes/mimic_tongue.tscn")
var mimic_scaly = load("res://scenes/mimic_scaly.tscn")

var common_items : Array = [iron_armor, iron_chestplate, leather_armor, b_spear, spear,
							b_halberd, halberd, b_claymore, dagger, s_dagger, p_dagger,
							b_sword, sword, s_sword, bat]

var rare_items : Array =[mimic_scaly, lightweight_heavy_armor, chain_armor, s_spear,
						p_spear, p_sword, claymore, s_halberd, p_halberd, heavy_armor]

var legendary_items : Array = [p_claymore]

var all_items : Array = [iron_armor, iron_chestplate, leather_armor, b_spear, spear,
						b_halberd, halberd, b_claymore, dagger, s_dagger, p_dagger,
						b_sword, sword, s_sword, bat, lightweight_heavy_armor, chain_armor, s_spear,
						p_spear, p_sword, claymore, s_halberd, p_halberd, heavy_armor, p_claymore]

#Stairs logic

var current_level : int = 1

var level_1_coord : Vector2i
var level_2_coord_var_0 : Vector2i
var level_2_coord_var_1 : Vector2i
var level_2_coord_var_2 : Vector2i
var level_3_coord_var_1 : Vector2i
var level_3_coord_var_0 : Vector2i

func switch_turn():
	for bodies_index in turn_list.size():
		print(bodies_index)
		if turn_list[bodies_index] != null:
			turn_list[bodies_index].turn = false
			print(turn_list[bodies_index].dead, " ", turn_list[bodies_index])
			if turn_list[bodies_index].dead == true:
				turn_list[bodies_index] = null
	current_turn += 1
	#if current_turn < turn_list.size():
		#if turn_list[current_turn] != null:
			#if turn_list[current_turn].dead == true:
				#turn_list[current_turn] = null
	while current_turn < turn_list.size() and turn_list[current_turn] == null:
		current_turn += 1
	#for bodies in turn_list:
		#if bodies == null:
			#current_turn += 1
		#print(a)
	#for i in all_enemies:
		#if i == null:
			#a += 1
	#current_turn += 1
	if current_turn >= turn_list.size():
		current_turn = 0
		#player_action = true
	if turn_list[current_turn] != null:
		turn_list[current_turn].turn = true
	#update_turn()
	#else:
		#switch_turn()

func update_turn():
	#print(current_turn, turn_list.size())
	#if current_turn < turn_list.size():
		#if turn_list[current_turn] == null:
			#current_turn = 0
	if current_turn >= turn_list.size():
		current_turn = 0
		#player_action = true
	if turn_list.all(func(body): return body == null or body == turn_list[0]) == true:
		for idx in turn_list.size():
			if idx != 0:
				turn_list.remove_at(idx)
		in_battle = false
		#player_action = true
		current_turn = 0
	#update_turn()
