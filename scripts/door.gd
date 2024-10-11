extends Area2D

var rooms = [Global.room0, Global.room1]

func _ready():
	set_meta("door", 69)

func open():
	$AnimatedSprite2D.play("opened")
	var r_room = rooms[randi_range(0, 1)]
	var spawn_room = r_room.instantiate()
	add_child(spawn_room)
	spawn_room.position += Vector2(80, 0)
	Global.camera.position += Vector2(144, 0)
	print("SUKA")
	print(spawn_room.Markerpos)


func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)
