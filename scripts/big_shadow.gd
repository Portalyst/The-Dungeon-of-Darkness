extends Sprite2D

var showing : bool = false

func _ready() -> void:
	self.show()

func get_door_signal():
	$Timer.start()
	showing = true

func _on_area_2d_area_entered(area):
	if area.has_meta("door"):
		area.del_shadow.connect(get_door_signal)
		#print("connected")

func start_showing():
	if self.modulate.a <= 0:
			self.queue_free()
	if showing == true:
		self.modulate.a -= 0.1
		print(Color(1.0, 1.0, 1.0, -0.0))

func _on_timer_timeout() -> void:
	start_showing()
