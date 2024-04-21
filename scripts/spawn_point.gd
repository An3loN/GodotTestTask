class_name SpawnPoint
extends Marker2D

static var active_points: Array[SpawnPoint] = []

@export var tag := "default"

func _init():
	active_points.append(self)

func _exit_tree():
	active_points.erase(self)
