extends Marker2D

func display_item(item):
	if item:
		var create = item.instantiate()
		add_child(create)
		create.item_slot = get_index()
		#create.position += Vector2(8, 8)
