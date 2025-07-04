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
	items[0] = Global.sword
	items[1] = Global.claymore
	items[2] = Global.iron_chestplate
	items[3] = Global.iron_armor
	
	items[12] = "w"
	items[13] = "a"

func set_item(index, item):
	var pre_item = items[index]
	items[index] = item
	item_changed.emit([index])
	return pre_item

func remove_item(index):
	var pre_item = items[index].duplicate()
	#print("del_indx: " + str(index))
	if index == 12:
		items[index] = "w"
	if index == 13:
		items[index] = "a"
	else:
		items[index] = {}
	item_changed.emit([index])
	return pre_item
