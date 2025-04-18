extends Area2D

@export var door_type : int = 1
@export var opened : bool = false
@export var locked : bool = false

signal del_shadow

func _ready():
	set_meta("door", 69)
	if door_type == 1:
		$AnimatedSprite2D.play("closed")
	if door_type == 2:
		$AnimatedSprite2D.play("big_closed")
	if door_type == 3:
		$AnimatedSprite2D.play("very_big_closed")

func open() -> void:
	if locked == true:
		$Lock.show()
		$AnimationPlayer.play("locked")
		return
	if door_type == 1:
		$AnimatedSprite2D.play("opened")
	if door_type == 2:
		$AnimatedSprite2D.play("big_opened")
	if door_type == 3:
		$AnimatedSprite2D.play("very_big_opened")
	$Timer.start()

func player_punch_door() -> void:
	locked = false
	if door_type == 1:
		$AnimatedSprite2D.play("opened")
		#print("open")
	if door_type == 2:
		$AnimatedSprite2D.play("big_opened")
	$Timer.start()

func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)
		body.punch_door.connect(player_punch_door)


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)
		body.punch_door.disconnect(player_punch_door)

func _on_timer_timeout() -> void:
	del_shadow.emit()
	opened = true
	#self.queue_free()
