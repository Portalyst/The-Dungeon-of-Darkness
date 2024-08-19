extends Node

signal item_changed(indexes)

var cols = 3
var rows = 4
var slots = cols * rows
var items = []

func _ready():
	slots += 2
	for i in range(slots):
		items.append({})
	items[0] = Global.p_claymore
	items[1] = Global.iron_armor
	items[2] = Global.iron_chestplate
	items[12] = "w"
	items[13] = "a"

func set_item(index, item):
	var pre_item = items[index]
	items[index] = item
	item_changed.emit([index])
	return pre_item

func remove_item(index):
	var pre_item = items[index].duplicate()
	#print(index)
	if index == 12:
		items[index] = "w"
	else:
		items[index] = {}
	#item_changed.emit([index])
	return pre_item
