extends Sprite2D

func _ready() -> void:
	self.show()

func show_room():
	self.queue_free()

func _on_area_2d_area_entered(area):
	if area.has_meta("door"):
		area.del_shadow.connect(show_room)
		print("connected")
