extends Area2D

signal loot(String)
#var items = [Global.sword, Global.dagger, Global.b_sword]
var close = true

func _ready():
	$AnimatedSprite2D.play("default")
	set_meta("chest", 111)
	

func open():
	if close == true:
		close = false
		var item
		$AnimatedSprite2D.play("open")
		var item_numb = randi_range(0,4)
		if item_numb == 0:
			Global.coins += 10
		if item_numb == 1:
			var rare = randi_range(1, 12)
			if rare <= 8:
				item = Global.b_claymore
			if rare == 9 or rare == 10 or rare == 11:
				item = Global.claymore
			if rare == 12:
				item = Global.p_claymore
		if item_numb == 2:
			var rare = randi_range(1, 12)
			if rare <= 6:
				item = Global.dagger
			if rare == 7 or rare == 8 or rare == 9 or rare == 10:
				item = Global.s_dagger
			if rare == 11 or rare == 12:
				item = Global.p_dagger
		if item_numb == 3:
			var rare = randi_range(1, 20)
			if rare <= 6:
				item = Global.b_sword
			if rare > 6 and rare <= 14:
				item = Global.sword
			if rare > 14 and rare <= 18:
				item = Global.s_sword
			if rare == 19 or rare == 20:
				item = Global.p_sword
		if item_numb == 4:
			var rare = randi_range(1, 20)
			if rare <= 12:
				item = Global.b_halberd
			if rare > 12 and rare <= 16:
				item = Global.halberd
			if rare > 16 and rare <= 19:
				item = Global.s_halberd
			if rare == 20:
				item = Global.p_halberd
		if item_numb != 0:
			loot.emit(item)

func _on_area_entered(area):
	if area.has_meta("player"):
		$"../Hero".open_chest.connect(open)


func _on_area_exited(area):
	if area.has_meta("player"):
		$"../Hero".open_chest.disconnect(open)
