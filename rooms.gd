extends Node2D

@export var Markerpos : Vector2

func _ready():
	Markerpos = $Camera_center.position
