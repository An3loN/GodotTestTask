class_name Level
extends Node2D

var player: Player

func spawn_character(i_character_scene: PackedScene, spawn_tag:String = "default") -> Player:
	player = i_character_scene.instantiate() as Player
	add_child(player)
	var spawn_position := _get_spawn_position(spawn_tag)
	player.global_position = spawn_position
	return player

func _get_spawn_position(spawn_tag: String) -> Vector2:
	var default_spawn_point: SpawnPoint
	for spawn_point in SpawnPoint.active_points:
		if spawn_point.tag == "default":
			default_spawn_point = spawn_point
		if spawn_point.tag == spawn_tag:
			return spawn_point.global_position
	if default_spawn_point:
		return default_spawn_point.global_position
	printerr("Neither default or %s spawn points found" % spawn_tag)
	return Vector2.ZERO
