extends Area2D

@export var big : bool = false
@export var opened : bool = false
@export var locked : bool = false

signal del_shadow

func _ready():
	set_meta("door", 69)
	if big == false:
		$AnimatedSprite2D.play("closed")
	else:
		$AnimatedSprite2D.play("big_closed")

func open() -> void:
	if locked == true:
		$Lock.show()
		$AnimationPlayer.play("locked")
		return
	if big == false:
		$AnimatedSprite2D.play("opened")
	else:
		$AnimatedSprite2D.play("big_opened")
	$Timer.start()

func player_punch_door() -> void:
	locked = false
	if big == false:
		$AnimatedSprite2D.play("opened")
	else:
		$AnimatedSprite2D.play("big_opened")
	$Timer.start()

func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)
		if locked == true:
			body.punch_door.connect(player_punch_door)


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)
		if locked == true:
			body.punch_door.disconnect(player_punch_door)

func _on_timer_timeout() -> void:
	del_shadow.emit()
	opened = true
	#self.queue_free()
