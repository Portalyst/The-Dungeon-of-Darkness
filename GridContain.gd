extends GridContainer

class_name ContainerSlot

var ItemSlot = load("res://scenes/color_rect.tscn")
var slots

func display_item_slot(cols: int, rows: int):
	var item_slot
	columns = cols
	slots = cols * rows
	for index in range(slots):
		item_slot = ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.display_item(InvLog.items[index])
		InvLog.item_changed.connect(_on_Inventory_items_changed)

func _on_Inventory_items_changed(indexes):
	var item_slot
	for index in indexes:
		if index < slots:
			item_slot = get_child(index)
			item_slot.display_item(InvLog.items[index])
