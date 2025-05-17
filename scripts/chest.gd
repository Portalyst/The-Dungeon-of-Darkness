extends Area2D

signal loot(String)
#var items = [Global.sword, Global.dagger, Global.b_sword]
var close = true

@export var secret : bool = false

var difficulty = 1 #randi_range(1, 3)

func _ready():
	$AnimatedSprite2D.play("default")
	set_meta("chest", 111)
	if secret == true:
		hide()

func open():
	if self.visible == false:
		return
	if close == true:
		close = false
		var item
		$AnimatedSprite2D.play("open")
		var item_numb = randi_range(0,4)
		print(item_numb)
		while item_numb != 0:
			item_numb -= 1
			rand_item()

func rand_item():
	var rare : int = randi_range(0, 100)
	var item
	if rare >= 0 and rare <= 80:
		item = Global.common_items.pick_random()
	if rare >= 81 and rare <= 99:
		item = Global.rare_items.pick_random()
	if rare == 100:
		item = Global.legendary_items.pick_random()
	loot.emit(item)

func show_self(player_att):
	if player_att >= difficulty:
		show()
	if player_att < difficulty:
		queue_free()

func _on_area_entered(area):
	if area.has_meta("player"):
		$"../Hero".open_chest.connect(open)
	if area.has_meta("player_big_area"):
		$"../Hero".try_to_spot.connect(show_self)


func _on_area_exited(area):
	if area.has_meta("player"):
		$"../Hero".open_chest.disconnect(open)
	if area.has_meta("player_big_area"):
		$"../Hero".try_to_spot.disconnect(show_self)
