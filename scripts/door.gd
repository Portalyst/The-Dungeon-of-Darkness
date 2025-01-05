extends Area2D

@export var big : bool = false
@export var opened : bool = false

signal del_shadow

func _ready():
	set_meta("door", 69)
	if big == false:
		$AnimatedSprite2D.play("closed")
	else:
		$AnimatedSprite2D.play("big_closed")

func open():
	if big == false:
		$AnimatedSprite2D.play("opened")
	else:
		$AnimatedSprite2D.play("big_opened")
	$Timer.start()


func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)

func _on_timer_timeout() -> void:
	del_shadow.emit()
	opened = true
	#self.queue_free()
