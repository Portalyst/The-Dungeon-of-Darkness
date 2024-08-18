extends Node

var coins = 15

var HP = 10
var armor = 10

var in_battle = false
var player_action = true

var damage = 1
var pure = false
var boost = 0

var p_sword = preload("res://scenes/p_sword.tscn")
var s_sword = preload("res://scenes/s_sword.tscn")
var sword = preload("res://scenes/sword.tscn")
var b_sword = preload("res://scenes/broken_sword.tscn")

var p_dagger = preload("res://scenes/p_dagger.tscn")
var s_dagger = preload("res://scenes/s_dagger.tscn")
var dagger = preload("res://scenes/dagger.tscn")

var g_claymore = preload("res://scenes/g_claymore.tscn")
var p_claymore = preload("res://scenes/p_claymore.tscn")
var claymore = preload("res://scenes/claymore.tscn")
var b_claymore =preload("res://scenes/b_claymore.tscn")

var p_halberd = preload("res://scenes/p_halberd.tscn")
var s_halberd = preload("res://scenes/s_halberd.tscn")
var halberd = preload("res://scenes/halberd.tscn")
var b_halberd =preload("res://scenes/b_halberd.tscn")
