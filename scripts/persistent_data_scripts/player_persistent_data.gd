class_name PlayerPersistentData
extends PersistentData

var health: int
var max_health: int
var keys: int
var item_sotrage: ItemStorage

func _init(i_health: int, i_max_health: int, i_keys: int, i_item_sotrage: ItemStorage):
	health = i_health
	max_health = i_max_health
	keys = i_keys
	item_sotrage = i_item_sotrage
