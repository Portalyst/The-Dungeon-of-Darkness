extends ColorRect

func display_item(item):
	if item:
		var create = item.instantiate()
		add_child(create)
		create.item_slot = get_index()
		create.position += Vector2(8, 8)
		create.Script_Name = item
		#print("pre index: " + str(get_index()))
