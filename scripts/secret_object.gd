extends Area2D

@export var difficulty : int

func _ready():
	hide()

func show_self(player_att):
	if player_att >= difficulty:
		show()
	if player_att < difficulty:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_meta("player_big_area"):
		$"../Hero".try_to_spot.connect(show_self)

func _on_area_exited(area: Area2D) -> void:
	if area.has_meta("player_big_area"):
		$"../Hero".try_to_spot.disconnect(show_self)
