extends Node

var coins = 15

var max_HP = 10
var HP = 10
var armor = 10

var in_battle = false
var player_action = true

var damage = 1
var pure = false
var boost = 0

var camera

var cam_pos : Vector2

#rooms

var room0 = load("res://scenes/room_0.tscn")

var room1 = load("res://scenes/room_1.tscn")

#weapons

var bat = load("res://scenes/bat.tscn")

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
