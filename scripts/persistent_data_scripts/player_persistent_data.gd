class_name PlayerPersistentData
extends PersistentData

var health: int
var max_health: int
var keys: int

func _init(i_health: int, i_max_health: int, i_keys: int):
	health = i_health
	max_health = i_max_health
	keys = i_keys	
