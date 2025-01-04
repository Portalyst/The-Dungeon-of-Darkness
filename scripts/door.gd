extends Area2D

signal del_shadow()

func _ready():
	set_meta("door", 69)

func open():
	$AnimatedSprite2D.play("opened")
	$Timer.start()


func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)

func _on_timer_timeout() -> void:
	del_shadow.emit()
	self.queue_free()
