extends ColorRect

var child

func _ready():
	$"../..".armor_changed.connect(display_item)

func display_item(item):
	if item:
		var create = item.instantiate()
		add_child(create)
		create.item_slot = 13
		#print(create.item_slot)
		create.position += Vector2(8, 8)
		child = create
	else:
		if child != null:
			child.queue_free()
