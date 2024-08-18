extends ContainerSlot


func _ready():
	display_item_slot(InvLog.cols, InvLog.rows)
	position = (get_viewport_rect().size - size) / 2
