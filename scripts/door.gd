extends Area2D

var rooms = [Global.room0, Global.room1]

@onready var tilemap = $"../TileMap"

var player

var change_pl_pos : Vector2
var change_cam_pos : Vector2
var change_room_pos : Vector2

func _ready():
	set_meta("door", 69)
	var currtile : Vector2i = tilemap.local_to_map(self.position)
	var tiledata : TileData = tilemap.get_cell_tile_data(0, currtile)
	if tiledata.get_custom_data("right") == true:
		change_room_pos = Vector2(8, -72)
		change_cam_pos = Vector2(144, 0)
		change_pl_pos = Vector2(48, 0)
	if tiledata.get_custom_data("up") == true:
		change_room_pos = Vector2(-72, -152)
		change_cam_pos = Vector2(0, -144)
		change_pl_pos = Vector2(0, -48)

func open():
	$AnimatedSprite2D.play("opened")
	var r_room = rooms[randi_range(0, 1)]
	var spawn_room = r_room.instantiate()
	add_child(spawn_room)
	spawn_room.position += change_room_pos
	Global.camera.position += change_cam_pos
	player.position += change_pl_pos
	print(player.position)


func _on_body_entered(body):
	if body.has_meta("player"):
		body.open_door.connect(open)
		player = body


func _on_body_exited(body):
	if body.has_meta("player"):
		body.open_door.disconnect(open)
